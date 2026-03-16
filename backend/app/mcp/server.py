from __future__ import annotations

import asyncio
import json
import secrets
from collections.abc import AsyncIterator
from datetime import datetime, timedelta, timezone
from threading import Lock
from typing import Any
from urllib.parse import urlparse

from fastapi import APIRouter, Depends, Header, HTTPException, Query, Request, Response, status
from fastapi.responses import JSONResponse, StreamingResponse
from pydantic import BaseModel, Field
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.api.deps import get_session
from app.api import sources as sources_api
from app.db.models import Feed, Source
from app.schemas.source import SourceCreate
from app.source_metadata import csv_contains, parse_csv
from app.services.rate_limit import RateLimitExceededError, registration_rate_limiter
from app.services.rss import InvalidRSSUrlError

router = APIRouter(prefix="/mcp", tags=["mcp"])
PROTOCOL_VERSION = "2025-03-26"
SESSION_HEADER = "Mcp-Session-Id"
SESSION_TTL = timedelta(hours=1)


class _RemoteMCPSession:
    def __init__(self, session_id: str):
        self.session_id = session_id
        self.created_at = datetime.now(timezone.utc)
        self.initialized = False


_session_lock = Lock()
_remote_sessions: dict[str, _RemoteMCPSession] = {}


class MCPToolCallRequest(BaseModel):
    name: str
    arguments: dict[str, Any] = Field(default_factory=dict)


def _source_create_from_arguments(arguments: dict[str, Any]) -> SourceCreate:
    return SourceCreate(
        rss_url=str(arguments.get("rss_url") or ""),
        language=arguments.get("language"),
        type=arguments.get("type"),
        categories=list(arguments.get("categories") or []),
        tags=list(arguments.get("tags") or []),
    )


def _jsonrpc_result(request_id: Any, result: dict[str, Any]) -> dict[str, Any]:
    return {"jsonrpc": "2.0", "id": request_id, "result": result}


def _jsonrpc_error(request_id: Any, code: int, message: str) -> dict[str, Any]:
    return {"jsonrpc": "2.0", "id": request_id, "error": {"code": code, "message": message}}


def _tool_error_result(code: str, message: str) -> dict[str, Any]:
    error = {"code": code, "message": message}
    return {
        "content": [{"type": "text", "text": json.dumps({"error": error}, ensure_ascii=False)}],
        "structuredContent": {"error": error},
        "isError": True,
    }


def _tool_success_result(result: dict[str, Any]) -> dict[str, Any]:
    return {
        "content": [{"type": "text", "text": json.dumps(result, ensure_ascii=False)}],
        "structuredContent": result,
        "isError": False,
    }


def _normalized_tool_definitions() -> list[dict[str, Any]]:
    normalized: list[dict[str, Any]] = []
    for tool in get_mcp_tool_manifest()["tools"]:
        item = dict(tool)
        if "input_schema" in item and "inputSchema" not in item:
            item["inputSchema"] = item["input_schema"]
        normalized.append(item)
    return normalized


def _prune_sessions() -> None:
    cutoff = datetime.now(timezone.utc) - SESSION_TTL
    expired = [session_id for session_id, session in _remote_sessions.items() if session.created_at < cutoff]
    for session_id in expired:
        _remote_sessions.pop(session_id, None)


def _create_remote_session() -> _RemoteMCPSession:
    with _session_lock:
        _prune_sessions()
        session = _RemoteMCPSession(secrets.token_urlsafe(24))
        _remote_sessions[session.session_id] = session
        return session


def _get_remote_session(session_id: str | None) -> _RemoteMCPSession | None:
    if not session_id:
        return None
    with _session_lock:
        _prune_sessions()
        return _remote_sessions.get(session_id)


def _delete_remote_session(session_id: str | None) -> None:
    if not session_id:
        return
    with _session_lock:
        _remote_sessions.pop(session_id, None)


def _serialize_source(source: Source) -> dict[str, Any]:
    return {
        "id": source.id,
        "rss_url": source.rss_url,
        "site_url": source.site_url,
        "title": source.title,
        "description": source.description,
        "favicon_url": source.favicon_url,
        "language": source.language,
        "type": source.source_type,
        "categories": parse_csv(source.categories),
        "tags": parse_csv(source.tags),
        "status": source.status,
        "registered_by": source.registered_by,
        "registered_at": source.registered_at.isoformat() if source.registered_at else None,
        "last_fetched_at": source.last_fetched_at.isoformat() if source.last_fetched_at else None,
        "last_published_at": source.last_published_at.isoformat() if source.last_published_at else None,
    }


def _serialize_feed(feed: Feed) -> dict[str, Any]:
    return {
        "id": feed.id,
        "source_id": feed.source_id,
        "guid": feed.guid,
        "title": feed.title,
        "feed_url": feed.feed_url,
        "published_at": feed.published_at.isoformat() if feed.published_at else None,
    }


def _serialize_feed_detail(feed: Feed, source: Source) -> dict[str, Any]:
    return {
        **_serialize_feed(feed),
        "source": {
            "id": source.id,
            "title": source.title,
            "site_url": source.site_url,
            "rss_url": source.rss_url,
            "language": source.language,
            "type": source.source_type,
            "categories": parse_csv(source.categories),
            "tags": parse_csv(source.tags),
        },
    }


def _serialize_source_status(source: Source) -> dict[str, Any]:
    return {
        "source_id": source.id,
        "last_fetched_at": source.last_fetched_at.isoformat() if source.last_fetched_at else None,
        "last_published_at": source.last_published_at.isoformat() if source.last_published_at else None,
        "consecutive_fail_count": source.consecutive_fail_count,
        "fetch_interval_minutes": source.fetch_interval_minutes,
        "is_stale": sources_api._is_source_stale(source),
    }


def _parse_since(value: str | None) -> datetime | None:
    if not value:
        return None
    unit = value[-1]
    try:
        amount = int(value[:-1])
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_since", "message": "since must use forms like 1h, 24h, or 7d."},
        ) from exc

    if unit == "h":
        delta = timedelta(hours=amount)
    elif unit == "d":
        delta = timedelta(days=amount)
    else:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_since", "message": "since must use forms like 1h, 24h, or 7d."},
        )
    return datetime.now(timezone.utc).replace(tzinfo=None) - delta


def get_mcp_tool_manifest() -> dict[str, list[dict[str, Any]]]:
    return {
        "tools": [
            {
                "name": "search_sources",
                "description": "Search sources by keyword, language, type, category, or tag.",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "keyword": {"type": "string"},
                        "language": {"type": "string"},
                        "type": {"type": "string"},
                        "category": {"type": "string"},
                        "tag": {"type": "string"},
                        "page": {"type": "integer", "default": 1},
                        "limit": {"type": "integer", "default": 20},
                    },
                },
            },
            {
                "name": "get_source",
                "description": "Get a single source by id.",
                "input_schema": {
                    "type": "object",
                    "properties": {"source_id": {"type": "string"}},
                    "required": ["source_id"],
                },
            },
            {
                "name": "get_source_status",
                "description": "Get public collection status for a single source.",
                "input_schema": {
                    "type": "object",
                    "properties": {"source_id": {"type": "string"}},
                    "required": ["source_id"],
                },
            },
            {
                "name": "get_stats",
                "description": "Get public source and feed statistics.",
                "input_schema": {"type": "object", "properties": {}},
            },
            {
                "name": "get_recent_feeds",
                "description": "List recent feeds using filters like since, language, or source_id.",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "source_id": {"type": "string"},
                        "language": {"type": "string"},
                        "since": {"type": "string", "default": "24h"},
                        "page": {"type": "integer", "default": 1},
                        "limit": {"type": "integer", "default": 20},
                    },
                },
            },
            {
                "name": "get_source_feeds",
                "description": "List feeds for a specific source.",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "source_id": {"type": "string"},
                        "page": {"type": "integer", "default": 1},
                        "limit": {"type": "integer", "default": 20},
                    },
                    "required": ["source_id"],
                },
            },
            {
                "name": "list_feeds",
                "description": "List feeds across active sources using source, language, type, category, tag, query, or since filters.",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "source_id": {"type": "string"},
                        "language": {"type": "string"},
                        "type": {"type": "string"},
                        "category": {"type": "string"},
                        "tag": {"type": "string"},
                        "q": {"type": "string"},
                        "since": {"type": "string"},
                        "page": {"type": "integer", "default": 1},
                        "limit": {"type": "integer", "default": 20},
                    },
                },
            },
            {
                "name": "get_feed",
                "description": "Get a single feed by id.",
                "input_schema": {
                    "type": "object",
                    "properties": {"feed_id": {"type": "string"}},
                    "required": ["feed_id"],
                },
            },
            {
                "name": "get_source_feed",
                "description": "Get a single feed from a specific source.",
                "input_schema": {
                    "type": "object",
                    "properties": {"source_id": {"type": "string"}, "feed_id": {"type": "string"}},
                    "required": ["source_id", "feed_id"],
                },
            },
            {
                "name": "validate_source",
                "description": "Validate an RSS URL before registration and return detected source metadata.",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "rss_url": {"type": "string"},
                        "language": {"type": "string"},
                        "type": {"type": "string"},
                        "categories": {"type": "array", "items": {"type": "string"}},
                        "tags": {"type": "array", "items": {"type": "string"}},
                    },
                    "required": ["rss_url"],
                },
            },
            {
                "name": "autofill_source",
                "description": "Inspect a source and suggest metadata such as language, type, categories, and tags.",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "rss_url": {"type": "string"},
                        "language": {"type": "string"},
                        "type": {"type": "string"},
                        "categories": {"type": "array", "items": {"type": "string"}},
                        "tags": {"type": "array", "items": {"type": "string"}},
                    },
                    "required": ["rss_url"],
                },
            },
            {
                "name": "create_source",
                "description": "Register a new source using the same public flow as the web app.",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "rss_url": {"type": "string"},
                        "language": {"type": "string"},
                        "type": {"type": "string"},
                        "categories": {"type": "array", "items": {"type": "string"}},
                        "tags": {"type": "array", "items": {"type": "string"}},
                    },
                    "required": ["rss_url"],
                },
            },
        ]
    }


def _initialize_result() -> dict[str, Any]:
    return {
        "protocolVersion": PROTOCOL_VERSION,
        "capabilities": {"tools": {}},
        "serverInfo": {"name": "rss-gateway-http", "version": "0.1.0"},
    }


def _search_sources(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    keyword = arguments.get("keyword")
    language = arguments.get("language")
    source_type = arguments.get("type")
    category = arguments.get("category")
    tag = arguments.get("tag")
    page = max(int(arguments.get("page", 1)), 1)
    limit = min(max(int(arguments.get("limit", 20)), 1), 100)

    query = select(Source).where(Source.status == "active")
    count_query = select(func.count()).select_from(Source).where(Source.status == "active")

    if keyword:
        pattern = f"%{keyword}%"
        query = query.where(Source.title.ilike(pattern))
        count_query = count_query.where(Source.title.ilike(pattern))
    if language:
        query = query.where(Source.language == language)
        count_query = count_query.where(Source.language == language)
    if source_type:
        query = query.where(Source.source_type == source_type)
        count_query = count_query.where(Source.source_type == source_type)
    if category:
        query = query.where(csv_contains(Source.categories, category))
        count_query = count_query.where(csv_contains(Source.categories, category))
    if tag:
        query = query.where(csv_contains(Source.tags, tag))
        count_query = count_query.where(csv_contains(Source.tags, tag))

    total = db.scalar(count_query) or 0
    items = db.scalars(
        query.order_by(Source.last_published_at.desc(), Source.registered_at.desc()).offset((page - 1) * limit).limit(limit)
    ).all()
    return {"items": [_serialize_source(item) for item in items], "page": page, "limit": limit, "total": total}


def _get_source(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    source_id = arguments.get("source_id")
    if not source_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "missing_source_id", "message": "source_id is required."},
        )
    source = db.get(Source, str(source_id))
    if not source or source.status != "active":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )
    return _serialize_source(source)


def _get_source_status(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    source_id = arguments.get("source_id")
    if not source_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "missing_source_id", "message": "source_id is required."},
        )
    source = db.get(Source, str(source_id))
    if not source or source.status != "active":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )
    return _serialize_source_status(source)


def _get_stats(db: Session, _: dict[str, Any]) -> dict[str, Any]:
    now = datetime.now(timezone.utc)
    last_24h = now - timedelta(hours=24)
    return {
        "total_sources": db.scalar(select(func.count()).select_from(Source)) or 0,
        "active_sources": db.scalar(select(func.count()).select_from(Source).where(Source.status == "active")) or 0,
        "total_feeds": db.scalar(select(func.count()).select_from(Feed).join(Source).where(Source.status == "active")) or 0,
        "feeds_last_24h": (
            db.scalar(select(func.count()).select_from(Feed).join(Source).where(Source.status == "active", Feed.published_at >= last_24h))
            or 0
        ),
    }


def _get_recent_feeds(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    source_id = arguments.get("source_id")
    language = arguments.get("language")
    since_dt = _parse_since(arguments.get("since"))
    page = max(int(arguments.get("page", 1)), 1)
    limit = min(max(int(arguments.get("limit", 20)), 1), 100)

    query = select(Feed).join(Source).where(Source.status == "active")
    count_query = select(func.count()).select_from(Feed).join(Source).where(Source.status == "active")

    if source_id:
        query = query.where(Feed.source_id == str(source_id))
        count_query = count_query.where(Feed.source_id == str(source_id))
    if language:
        query = query.where(Source.language == str(language))
        count_query = count_query.where(Source.language == str(language))
    if since_dt:
        query = query.where(Feed.published_at >= since_dt)
        count_query = count_query.where(Feed.published_at >= since_dt)

    total = db.scalar(count_query) or 0
    items = db.scalars(query.order_by(Feed.published_at.desc()).offset((page - 1) * limit).limit(limit)).all()
    return {"items": [_serialize_feed(item) for item in items], "page": page, "limit": limit, "total": total}


def _list_feeds(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    source_id = arguments.get("source_id")
    language = arguments.get("language")
    source_type = arguments.get("type")
    category = arguments.get("category")
    tag = arguments.get("tag")
    query_text = arguments.get("q")
    since_dt = _parse_since(arguments.get("since"))
    page = max(int(arguments.get("page", 1)), 1)
    limit = min(max(int(arguments.get("limit", 20)), 1), 100)

    query = select(Feed).join(Source).where(Source.status == "active")
    count_query = select(func.count()).select_from(Feed).join(Source).where(Source.status == "active")

    if source_id:
        query = query.where(Feed.source_id == str(source_id))
        count_query = count_query.where(Feed.source_id == str(source_id))
    if language:
        query = query.where(Source.language == str(language))
        count_query = count_query.where(Source.language == str(language))
    if source_type:
        query = query.where(Source.source_type == str(source_type))
        count_query = count_query.where(Source.source_type == str(source_type))
    if category:
        query = query.where(csv_contains(Source.categories, str(category)))
        count_query = count_query.where(csv_contains(Source.categories, str(category)))
    if tag:
        query = query.where(csv_contains(Source.tags, str(tag)))
        count_query = count_query.where(csv_contains(Source.tags, str(tag)))
    if query_text:
        pattern = f"%{query_text}%"
        query = query.where(Feed.title.ilike(pattern))
        count_query = count_query.where(Feed.title.ilike(pattern))
    if since_dt:
        query = query.where(Feed.published_at >= since_dt)
        count_query = count_query.where(Feed.published_at >= since_dt)

    total = db.scalar(count_query) or 0
    items = db.scalars(query.order_by(Feed.published_at.desc()).offset((page - 1) * limit).limit(limit)).all()
    return {"items": [_serialize_feed(item) for item in items], "page": page, "limit": limit, "total": total}


def _get_feed(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    feed_id = arguments.get("feed_id")
    if not feed_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "missing_feed_id", "message": "feed_id is required."},
        )
    row = db.execute(select(Feed, Source).join(Source).where(Source.status == "active", Feed.id == str(feed_id))).first()
    if not row:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "feed_not_found", "message": "Feed not found."},
        )
    feed, source = row
    return _serialize_feed_detail(feed, source)


def _get_source_feeds(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    source_id = arguments.get("source_id")
    if not source_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "missing_source_id", "message": "source_id is required."},
        )
    page = max(int(arguments.get("page", 1)), 1)
    limit = min(max(int(arguments.get("limit", 20)), 1), 100)

    source = db.get(Source, str(source_id))
    if not source or source.status != "active":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )

    query = select(Feed).where(Feed.source_id == str(source_id))
    count_query = select(func.count()).select_from(Feed).where(Feed.source_id == str(source_id))
    total = db.scalar(count_query) or 0
    items = db.scalars(query.order_by(Feed.published_at.desc()).offset((page - 1) * limit).limit(limit)).all()
    return {"items": [_serialize_feed(item) for item in items], "page": page, "limit": limit, "total": total}


def _get_source_feed(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    source_id = arguments.get("source_id")
    feed_id = arguments.get("feed_id")
    if not source_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "missing_source_id", "message": "source_id is required."},
        )
    if not feed_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "missing_feed_id", "message": "feed_id is required."},
        )
    row = db.execute(
        select(Feed, Source).join(Source).where(Source.status == "active", Feed.source_id == str(source_id), Feed.id == str(feed_id))
    ).first()
    if not row:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "feed_not_found", "message": "Feed not found."},
        )
    feed, source = row
    return _serialize_feed_detail(feed, source)


async def _validate_source(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    payload = _source_create_from_arguments(arguments)
    sources_api._validate_registration_payload(payload)

    try:
        bundle = await sources_api.fetch_feed_bundle(str(payload.rss_url))
    except InvalidRSSUrlError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_rss_url", "message": str(exc)},
        ) from exc

    metadata = bundle["metadata"]
    normalized_rss_url, _ = sources_api._ensure_source_not_registered(db, metadata, str(payload.rss_url))

    language = payload.language
    if language is None:
        detected_language = str(metadata.get("language") or "").strip().lower()
        if detected_language in sources_api.LANGUAGE_VALUES:
            language = detected_language

    source_type = payload.type
    if source_type is None:
        detected_type = str(metadata.get("type") or "").strip().lower()
        if detected_type in sources_api.SOURCE_TYPE_VALUES:
            source_type = detected_type

    categories = payload.categories
    if not categories:
        detected_categories = [
            value.strip().lower()
            for value in str(metadata.get("categories") or "").split(",")
            if value.strip().lower() in sources_api.SOURCE_CATEGORY_VALUES
        ]
        categories = list(dict.fromkeys(detected_categories))

    review_result = await sources_api.review_source_bundle_with_ai(
        metadata=metadata,
        entries=bundle["entries"],
        duplicate_site_url_exists=False,
    )
    return {
        "valid": True,
        "rss_url": normalized_rss_url,
        "site_url": str(metadata.get("site_url") or ""),
        "title": str(metadata.get("title") or ""),
        "description": metadata.get("description"),
        "favicon_url": metadata.get("favicon_url"),
        "language": language,
        "type": source_type,
        "categories": categories,
        "tags": sources_api._detect_tags(metadata, payload.tags),
        "feed_format": str(metadata.get("feed_format") or "") or None,
        "status": review_result.final_decision.status,
        "status_reason": review_result.final_decision.reason,
        "review_source": review_result.review_source,
        "ai_review_reason": review_result.ai_review_reason,
        "ai_review_confidence": review_result.ai_review_confidence,
        "ai_review_decision": review_result.ai_review_decision,
        "message": sources_api.build_validate_message(review_result),
    }


async def _autofill_source(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    payload = _source_create_from_arguments(arguments)
    sources_api._validate_registration_payload(payload)

    try:
        bundle = await sources_api.fetch_feed_bundle(str(payload.rss_url))
    except InvalidRSSUrlError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_rss_url", "message": str(exc)},
        ) from exc

    metadata = bundle["metadata"]
    sources_api._ensure_source_not_registered(db, metadata, str(payload.rss_url))
    return dict(await sources_api.autofill_source_metadata(bundle))


async def _create_source(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    payload = _source_create_from_arguments(arguments)
    settings = sources_api.get_settings()
    sources_api._validate_registration_payload(payload)

    request_host = urlparse(str(payload.rss_url)).hostname or "unknown"
    client_key = str(arguments.get("client_key") or "mcp")
    try:
        registration_rate_limiter.enforce(
            ip=client_key,
            host=request_host,
            window_seconds=settings.source_registration_window_seconds,
            max_attempts=settings.source_registration_max_attempts,
            max_same_host=settings.source_registration_max_same_host,
        )
    except RateLimitExceededError as exc:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail={"code": "rate_limited", "message": str(exc)},
        ) from exc

    try:
        bundle = await sources_api.fetch_feed_bundle(str(payload.rss_url))
    except InvalidRSSUrlError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_rss_url", "message": str(exc)},
        ) from exc

    metadata = bundle["metadata"]
    normalized_rss_url, site_url = sources_api._ensure_source_not_registered(db, metadata, str(payload.rss_url))

    source = Source(
        rss_url=normalized_rss_url,
        site_url=site_url,
        title=str(metadata.get("title") or ""),
        description=metadata.get("description"),
        favicon_url=metadata.get("favicon_url"),
        language=payload.language,
        source_type=payload.type,
        categories=sources_api.join_csv(payload.categories),
        tags=sources_api.join_csv(sources_api._detect_tags(metadata, payload.tags)),
        registered_by="mcp",
    )

    detected_language = str(metadata.get("language") or "").strip().lower()
    if source.language is None and detected_language in sources_api.LANGUAGE_VALUES:
        source.language = detected_language

    detected_type = str(metadata.get("type") or "").strip().lower()
    if source.source_type is None and detected_type in sources_api.SOURCE_TYPE_VALUES:
        source.source_type = detected_type

    if source.categories is None:
        detected_categories = [
            value.strip().lower()
            for value in str(metadata.get("categories") or "").split(",")
            if value.strip().lower() in sources_api.SOURCE_CATEGORY_VALUES
        ]
        source.categories = sources_api.join_csv(list(dict.fromkeys(detected_categories)))

    review_result = await sources_api.review_source_bundle_with_ai(
        metadata=metadata,
        entries=bundle["entries"],
        duplicate_site_url_exists=False,
    )
    source.status = review_result.final_decision.status
    source.status_reason = review_result.final_decision.reason
    if review_result.review_source in {"ai", "rule_fallback"}:
        source.ai_reviewed_at = datetime.now(timezone.utc)
        source.ai_review_source = "create"
        source.ai_review_reason = review_result.ai_review_reason
        source.ai_review_confidence = review_result.ai_review_confidence
        source.ai_review_decision = review_result.ai_review_decision or review_result.final_decision.status

    db.add(source)
    db.flush()

    if review_result.final_decision.status == "active":
        sources_api.ingest_source_bundle(
            db=db,
            source=source,
            metadata=metadata,
            entries=bundle["entries"],
        )
    db.commit()
    db.refresh(source)
    return _serialize_source(source)


async def call_tool_async(db: Session, name: str, arguments: dict[str, Any]) -> dict[str, Any]:
    handlers = {
        "search_sources": _search_sources,
        "get_source": _get_source,
        "get_source_status": _get_source_status,
        "get_stats": _get_stats,
        "get_recent_feeds": _get_recent_feeds,
        "get_source_feeds": _get_source_feeds,
        "list_feeds": _list_feeds,
        "get_feed": _get_feed,
        "get_source_feed": _get_source_feed,
        "validate_source": _validate_source,
        "autofill_source": _autofill_source,
        "create_source": _create_source,
    }
    handler = handlers.get(name)
    if not handler:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "tool_not_found", "message": f"Unknown MCP tool: {name}"},
        )
    result = handler(db, arguments)
    if asyncio.iscoroutine(result):
        result = await result
    return {
        "tool": name,
        "result": result,
    }


def call_tool(db: Session, name: str, arguments: dict[str, Any]) -> dict[str, Any]:
    return asyncio.run(call_tool_async(db, name, arguments))


def _sse_event(event: str, data: dict[str, Any]) -> str:
    return f"event: {event}\ndata: {json.dumps(data, ensure_ascii=False)}\n\n"


async def _event_stream(once: bool = False):
    yield _sse_event("server_ready", {"message": "RSS Gateway MCP SSE stream connected."})
    yield _sse_event("tools", get_mcp_tool_manifest())

    if once:
        return

    while True:
        await asyncio.sleep(15)
        yield _sse_event("ping", {"ok": True})


async def _remote_session_stream(session_id: str) -> AsyncIterator[str]:
    yield _sse_event("endpoint", {"path": "/mcp", "sessionId": session_id})
    yield _sse_event("message", _jsonrpc_result(None, {"tools": _normalized_tool_definitions()}))
    while True:
        await asyncio.sleep(15)
        yield ": ping\n\n"


def _remote_mcp_response(payload: dict[str, Any], session_id: str | None = None) -> JSONResponse:
    headers = {SESSION_HEADER: session_id} if session_id else None
    return JSONResponse(content=payload, headers=headers)


async def _handle_remote_tools_call(db: Session, request_id: Any, params: dict[str, Any]) -> dict[str, Any]:
    name = params.get("name")
    arguments = params.get("arguments", {})

    try:
        payload = await call_tool_async(db, str(name), arguments if isinstance(arguments, dict) else {})
    except HTTPException as exc:
        detail = exc.detail if isinstance(exc.detail, dict) else {"code": "tool_error", "message": str(exc.detail)}
        return _jsonrpc_result(request_id, _tool_error_result(str(detail["code"]), str(detail["message"])))
    except Exception as exc:  # pragma: no cover
        return _jsonrpc_result(request_id, _tool_error_result("internal_error", str(exc)))

    return _jsonrpc_result(request_id, _tool_success_result(payload["result"]))


@router.get(
    "",
    summary="Open remote MCP stream",
    description="Open a session-bound SSE stream for the remote MCP transport. Send JSON-RPC requests to POST /mcp.",
)
async def remote_mcp_sse(
    mcp_session_id: str | None = Header(default=None, alias=SESSION_HEADER),
) -> StreamingResponse:
    session = _get_remote_session(mcp_session_id)
    if not session:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_mcp_session", "message": "A valid MCP session is required."},
        )
    return StreamingResponse(_remote_session_stream(session.session_id), media_type="text/event-stream")


@router.post(
    "",
    summary="Handle remote MCP JSON-RPC",
    description="Handle session-based remote MCP requests over HTTP JSON-RPC.",
)
async def remote_mcp_call(
    request: Request,
    db: Session = Depends(get_session),
    mcp_session_id: str | None = Header(default=None, alias=SESSION_HEADER),
) -> Response:
    try:
        payload = await request.json()
    except json.JSONDecodeError:
        return _remote_mcp_response(_jsonrpc_error(None, -32700, "Parse error"))

    if not isinstance(payload, dict):
        return _remote_mcp_response(_jsonrpc_error(None, -32600, "Invalid Request"))

    request_id = payload.get("id")
    method = payload.get("method")
    params = payload.get("params", {})

    if method == "initialize":
        session = _create_remote_session()
        return _remote_mcp_response(_jsonrpc_result(request_id, _initialize_result()), session.session_id)

    session = _get_remote_session(mcp_session_id)
    if not session:
        return _remote_mcp_response(_jsonrpc_error(request_id, -32001, "MCP session is missing or invalid."))

    if method == "notifications/initialized":
        session.initialized = True
        if request_id is None:
            return Response(status_code=status.HTTP_202_ACCEPTED, headers={SESSION_HEADER: session.session_id})
        return _remote_mcp_response(_jsonrpc_result(request_id, {}), session.session_id)

    if method == "ping":
        return _remote_mcp_response(_jsonrpc_result(request_id, {}), session.session_id)
    if method == "shutdown":
        _delete_remote_session(session.session_id)
        return _remote_mcp_response(_jsonrpc_result(request_id, {}), session.session_id)
    if method == "tools/list":
        return _remote_mcp_response(_jsonrpc_result(request_id, {"tools": _normalized_tool_definitions()}), session.session_id)
    if method == "tools/call":
        if not isinstance(params, dict):
            return _remote_mcp_response(_jsonrpc_error(request_id, -32602, "Invalid params"), session.session_id)
        return _remote_mcp_response(await _handle_remote_tools_call(db, request_id, params), session.session_id)

    return _remote_mcp_response(_jsonrpc_error(request_id, -32601, f"Method not found: {method}"), session.session_id)


@router.delete(
    "",
    summary="Close remote MCP session",
    description="Delete a previously initialized remote MCP session.",
    status_code=204,
)
def remote_mcp_delete(
    mcp_session_id: str | None = Header(default=None, alias=SESSION_HEADER),
) -> Response:
    session = _get_remote_session(mcp_session_id)
    if not session:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_mcp_session", "message": "A valid MCP session is required."},
        )
    _delete_remote_session(session.session_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.get(
    "/tools",
    summary="Get MCP tool manifest",
    description="Return the read-only MCP tool list and input schemas exposed by RSS Gateway.",
)
def mcp_tools() -> dict[str, Any]:
    return get_mcp_tool_manifest()


@router.get(
    "/sse",
    summary="Open MCP SSE stream",
    description="Open a lightweight SSE stream for MCP-compatible clients. Use `once=true` for a one-shot stream in smoke tests.",
)
async def mcp_sse(once: bool = Query(default=False)) -> StreamingResponse:
    return StreamingResponse(_event_stream(once=once), media_type="text/event-stream")


@router.post(
    "/call",
    summary="Call MCP tool",
    description="Invoke one of the read-only MCP tools and return the serialized result payload.",
    responses={
        400: {"description": "Missing or invalid tool arguments"},
        404: {"description": "Unknown tool or missing source"},
    },
)
def mcp_call(payload: MCPToolCallRequest, db: Session = Depends(get_session)) -> dict[str, Any]:
    return call_tool(db, payload.name, payload.arguments)
