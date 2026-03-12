from __future__ import annotations

import asyncio
import json
from datetime import datetime, timedelta, timezone
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.responses import StreamingResponse
from pydantic import BaseModel, Field
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.api.deps import get_session
from app.db.models import Feed, Source

router = APIRouter(prefix="/mcp", tags=["mcp"])


class MCPToolCallRequest(BaseModel):
    name: str
    arguments: dict[str, Any] = Field(default_factory=dict)


def _serialize_source(source: Source) -> dict[str, Any]:
    return {
        "id": source.id,
        "rss_url": source.rss_url,
        "site_url": source.site_url,
        "title": source.title,
        "description": source.description,
        "favicon_url": source.favicon_url,
        "language": source.language,
        "category": source.category,
        "tags": source.tags.split(",") if source.tags else [],
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
                "description": "Search sources by keyword, language, category, or tag.",
                "input_schema": {
                    "type": "object",
                    "properties": {
                        "keyword": {"type": "string"},
                        "language": {"type": "string"},
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
        ]
    }


def _search_sources(db: Session, arguments: dict[str, Any]) -> dict[str, Any]:
    keyword = arguments.get("keyword")
    language = arguments.get("language")
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
    if category:
        query = query.where(Source.category == category)
        count_query = count_query.where(Source.category == category)
    if tag:
        pattern = f"%{tag}%"
        query = query.where(Source.tags.ilike(pattern))
        count_query = count_query.where(Source.tags.ilike(pattern))

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


def call_tool(db: Session, name: str, arguments: dict[str, Any]) -> dict[str, Any]:
    handlers = {
        "search_sources": _search_sources,
        "get_source": _get_source,
        "get_recent_feeds": _get_recent_feeds,
        "get_source_feeds": _get_source_feeds,
    }
    handler = handlers.get(name)
    if not handler:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "tool_not_found", "message": f"Unknown MCP tool: {name}"},
        )
    return {
        "tool": name,
        "result": handler(db, arguments),
    }


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
