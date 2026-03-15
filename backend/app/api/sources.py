from __future__ import annotations

from datetime import UTC, datetime, timedelta
from urllib.parse import urlparse

from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from sqlalchemy import func, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.api.deps import get_session
from app.core.config import get_settings
from app.db.models import Feed, Source
from app.schemas.source import (
    SourceAutofillResponse,
    SourceCreate,
    SourceListResponse,
    SourceResponse,
    SourceStatusResponse,
    SourceValidateResponse,
    StatsResponse,
)
from app.source_metadata import (
    LANGUAGE_VALUES,
    MAX_SOURCE_TAGS,
    SOURCE_CATEGORY_VALUES,
    SOURCE_TAG_VALUES,
    SOURCE_TYPE_VALUES,
    csv_contains,
    join_csv,
    parse_csv,
)
from app.services.ai_review import build_validate_message, review_source_bundle_with_ai
from app.services.cache import response_cache
from app.services.ingest import ingest_source_bundle
from app.services.rate_limit import RateLimitExceededError, registration_rate_limiter
from app.services.review import _normalize_site_host
from app.services.rss import InvalidRSSUrlError, fetch_feed_bundle
from app.services.source_autofill import autofill_source_metadata, detect_tags_from_text

router = APIRouter(prefix="/sources", tags=["sources"])
public_router = APIRouter(tags=["sources"])


def _request_ip(request: Request) -> str:
    forwarded_for = request.headers.get("x-forwarded-for", "")
    if forwarded_for:
        return forwarded_for.split(",")[0].strip()
    return request.client.host if request.client else "unknown"


def _validate_registration_payload(payload: SourceCreate) -> None:
    parsed = urlparse(str(payload.rss_url))
    host = parsed.hostname or ""
    if len(host) > 255:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_rss_url", "message": "RSS hostname is too long."},
        )

    if payload.language and len(payload.language.strip()) < 2:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_language", "message": "Language must be at least 2 characters."},
        )


def _to_source_response(source: Source) -> SourceResponse:
    return SourceResponse(
        id=source.id,
        rss_url=source.rss_url,
        site_url=source.site_url,
        title=source.title,
        description=source.description,
        favicon_url=source.favicon_url,
        language=source.language,
        type=source.source_type,
        categories=parse_csv(source.categories),
        tags=parse_csv(source.tags),
        status=source.status,
        status_reason=source.status_reason,
        ai_reviewed_at=source.ai_reviewed_at,
        ai_review_source=source.ai_review_source,
        ai_review_reason=source.ai_review_reason,
        ai_review_confidence=source.ai_review_confidence,
        ai_review_decision=source.ai_review_decision,
        registered_by=source.registered_by,
        registered_at=source.registered_at,
        last_fetched_at=source.last_fetched_at,
        last_published_at=source.last_published_at,
    )


def _is_source_stale(source: Source) -> bool:
    if source.last_fetched_at is None:
        return True

    fetched_at = source.last_fetched_at
    if fetched_at.tzinfo is None:
        fetched_at = fetched_at.replace(tzinfo=UTC)

    window_minutes = max(source.fetch_interval_minutes * 2, 60)
    return fetched_at < datetime.now(UTC) - timedelta(minutes=window_minutes)


def _source_exists_for_rss_url(db: Session, rss_url: str) -> bool:
    return (db.scalar(select(func.count()).select_from(Source).where(Source.rss_url == rss_url)) or 0) > 0


def _source_exists_for_site_url(db: Session, site_url: str) -> bool:
    normalized_site_host = _normalize_site_host(site_url)
    if not normalized_site_host:
        return False

    existing_site_urls = db.scalars(select(Source.site_url)).all()
    return any(_normalize_site_host(existing_site_url or "") == normalized_site_host for existing_site_url in existing_site_urls)


def _detect_tags(metadata: dict[str, object], payload_tags: list[str]) -> list[str]:
    if payload_tags:
        return payload_tags
    text = " ".join(
        str(part).strip()
        for part in (metadata.get("title"), metadata.get("description"), metadata.get("categories"))
        if str(part or "").strip()
    )
    return detect_tags_from_text(text)


def _ensure_source_not_registered(db: Session, metadata: dict[str, object], fallback_rss_url: str) -> tuple[str, str]:
    normalized_rss_url = str(metadata.get("rss_url") or fallback_rss_url)
    if _source_exists_for_rss_url(db, normalized_rss_url):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={"code": "duplicate_source", "message": "This RSS URL is already registered."},
        )

    site_url = str(metadata.get("site_url") or "").strip()
    if _source_exists_for_site_url(db, site_url):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={"code": "duplicate_source", "message": "A source for this site is already registered."},
        )

    return normalized_rss_url, site_url


@router.get(
    "",
    response_model=SourceListResponse,
    summary="List sources",
    description="List active sources with optional keyword, language, type, category, and tag filters.",
)
def list_sources(
    keyword: str | None = None,
    language: str | None = None,
    type: str | None = None,
    category: str | None = None,
    tag: str | None = None,
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=20, ge=1, le=100),
    db: Session = Depends(get_session),
) -> SourceListResponse:
    query = select(Source).where(Source.status == "active")
    count_query = select(func.count()).select_from(Source).where(Source.status == "active")

    if keyword:
        pattern = f"%{keyword}%"
        query = query.where(Source.title.ilike(pattern))
        count_query = count_query.where(Source.title.ilike(pattern))
    if language:
        query = query.where(Source.language == language)
        count_query = count_query.where(Source.language == language)
    if type:
        query = query.where(Source.source_type == type)
        count_query = count_query.where(Source.source_type == type)
    if category:
        query = query.where(csv_contains(Source.categories, category))
        count_query = count_query.where(csv_contains(Source.categories, category))
    if tag:
        query = query.where(csv_contains(Source.tags, tag))
        count_query = count_query.where(csv_contains(Source.tags, tag))

    total = db.scalar(count_query) or 0
    query = query.order_by(Source.last_published_at.desc(), Source.registered_at.desc())
    query = query.offset((page - 1) * limit).limit(limit)
    sources = db.scalars(query).all()

    return SourceListResponse(
        items=[_to_source_response(source) for source in sources],
        page=page,
        limit=limit,
        total=total,
    )


@router.post(
    "/validate",
    response_model=SourceValidateResponse,
    summary="Validate a source URL",
    description="Validate an RSS URL before registration and return detected source metadata without writing to the database.",
    responses={400: {"description": "Invalid or unreachable RSS URL"}},
)
async def validate_source(payload: SourceCreate, db: Session = Depends(get_session)) -> SourceValidateResponse:
    _validate_registration_payload(payload)

    try:
        bundle = await fetch_feed_bundle(str(payload.rss_url))
    except InvalidRSSUrlError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_rss_url", "message": str(exc)},
        ) from exc

    metadata = bundle["metadata"]
    normalized_rss_url, site_url = _ensure_source_not_registered(db, metadata, str(payload.rss_url))

    language = payload.language
    if language is None:
        detected_language = str(metadata.get("language") or "").strip().lower()
        if detected_language in LANGUAGE_VALUES:
            language = detected_language

    source_type = payload.type
    if source_type is None:
        detected_type = str(metadata.get("type") or "").strip().lower()
        if detected_type in SOURCE_TYPE_VALUES:
            source_type = detected_type

    categories = payload.categories
    if not categories:
        detected_categories = [
            value.strip().lower()
            for value in str(metadata.get("categories") or "").split(",")
            if value.strip().lower() in SOURCE_CATEGORY_VALUES
        ]
        categories = list(dict.fromkeys(detected_categories))

    review_result = await review_source_bundle_with_ai(
        metadata=metadata,
        entries=bundle["entries"],
        duplicate_site_url_exists=False,
    )

    return SourceValidateResponse(
        valid=True,
        rss_url=normalized_rss_url,
        site_url=str(metadata.get("site_url") or ""),
        title=str(metadata.get("title") or ""),
        description=metadata.get("description"),
        favicon_url=metadata.get("favicon_url"),
        language=language,
        type=source_type,
        categories=categories,
        tags=_detect_tags(metadata, payload.tags),
        feed_format=str(metadata.get("feed_format") or "") or None,
        status=review_result.final_decision.status,
        status_reason=review_result.final_decision.reason,
        review_source=review_result.review_source,
        ai_review_reason=review_result.ai_review_reason,
        ai_review_confidence=review_result.ai_review_confidence,
        ai_review_decision=review_result.ai_review_decision,
        message=build_validate_message(review_result),
    )


@router.post(
    "/autofill",
    response_model=SourceAutofillResponse,
    summary="Autofill source metadata",
    description="Inspect source metadata and representative feed entries to suggest language, type, categories, and tags.",
    responses={400: {"description": "Invalid or unreachable RSS URL"}},
)
async def autofill_source(payload: SourceCreate, db: Session = Depends(get_session)) -> SourceAutofillResponse:
    _validate_registration_payload(payload)

    try:
        bundle = await fetch_feed_bundle(str(payload.rss_url))
    except InvalidRSSUrlError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_rss_url", "message": str(exc)},
        ) from exc

    metadata = bundle["metadata"]
    _ensure_source_not_registered(db, metadata, str(payload.rss_url))
    suggestions = await autofill_source_metadata(bundle)
    return SourceAutofillResponse(**suggestions)


@router.post(
    "",
    response_model=SourceResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register a source",
    description="Register a new source from the web frontend. The server validates the feed, extracts metadata, and ingests the initial feed entries.",
    responses={
        400: {"description": "Invalid or unreachable RSS URL"},
        409: {"description": "Duplicate RSS URL"},
    },
)
async def create_source(payload: SourceCreate, request: Request, db: Session = Depends(get_session)) -> SourceResponse:
    settings = get_settings()
    _validate_registration_payload(payload)

    request_ip = _request_ip(request)
    request_host = urlparse(str(payload.rss_url)).hostname or "unknown"
    try:
        registration_rate_limiter.enforce(
            ip=request_ip,
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
        bundle = await fetch_feed_bundle(str(payload.rss_url))
    except InvalidRSSUrlError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": "invalid_rss_url", "message": str(exc)},
        ) from exc

    metadata = bundle["metadata"]
    normalized_rss_url, site_url = _ensure_source_not_registered(db, metadata, str(payload.rss_url))

    source = Source(
        rss_url=normalized_rss_url,
        site_url=metadata["site_url"] or "",
        title=metadata["title"] or "",
        description=metadata["description"],
        favicon_url=metadata["favicon_url"],
        language=payload.language,
        source_type=payload.type,
        categories=join_csv(payload.categories),
        tags=join_csv(payload.tags),
        status="pending_review",
        feed_format=metadata["feed_format"],
        registered_by="web",
    )
    db.add(source)

    try:
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={"code": "duplicate_source", "message": "This RSS URL is already registered."},
        ) from exc

    review_result = await review_source_bundle_with_ai(
        metadata=metadata,
        entries=bundle["entries"],
        duplicate_site_url_exists=False,
    )
    source.status = review_result.final_decision.status
    source.status_reason = review_result.final_decision.reason
    if review_result.review_source in {"ai", "rule_fallback"}:
        source.ai_reviewed_at = datetime.now(UTC)
        source.ai_review_source = "create"
        source.ai_review_reason = review_result.ai_review_reason
        source.ai_review_confidence = review_result.ai_review_confidence
        source.ai_review_decision = review_result.ai_review_decision or review_result.final_decision.status
    else:
        source.ai_reviewed_at = None
        source.ai_review_source = None
        source.ai_review_reason = None
        source.ai_review_confidence = None
        source.ai_review_decision = None

    if review_result.final_decision.status == "active":
        ingest_source_bundle(
            db=db,
            source=source,
            metadata=metadata,
            entries=bundle["entries"],
        )
    db.commit()
    db.refresh(source)
    return _to_source_response(source)


@router.get(
    "/{source_id}",
    response_model=SourceResponse,
    summary="Get source",
    description="Return a single active source by id.",
    responses={404: {"description": "Source not found"}},
)
def get_source(source_id: str, db: Session = Depends(get_session)) -> SourceResponse:
    source = db.get(Source, source_id)
    if not source or source.status != "active":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )
    return _to_source_response(source)


@router.get(
    "/{source_id}/status",
    response_model=SourceStatusResponse,
    summary="Get source collection status",
    description="Return public collection health metadata for a single active source.",
    responses={404: {"description": "Source not found"}},
)
def get_source_status(source_id: str, db: Session = Depends(get_session)) -> SourceStatusResponse:
    source = db.get(Source, source_id)
    if not source or source.status != "active":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )

    return SourceStatusResponse(
        source_id=source.id,
        last_fetched_at=source.last_fetched_at,
        last_published_at=source.last_published_at,
        consecutive_fail_count=source.consecutive_fail_count,
        fetch_interval_minutes=source.fetch_interval_minutes,
        is_stale=_is_source_stale(source),
    )


@public_router.get(
    "/stats",
    response_model=StatsResponse,
    summary="Get gateway stats",
    description="Return lightweight public stats about indexed sources and feeds.",
)
def get_stats(db: Session = Depends(get_session)) -> StatsResponse:
    settings = get_settings()
    cache_key = "stats:public"
    if settings.response_cache_enabled:
        cached = response_cache.get_json(cache_key)
        if cached is not None:
            return StatsResponse.model_validate(cached)

    now = datetime.now(UTC)
    last_24h = now - timedelta(hours=24)

    payload = StatsResponse(
        total_sources=db.scalar(select(func.count()).select_from(Source)) or 0,
        active_sources=db.scalar(select(func.count()).select_from(Source).where(Source.status == "active")) or 0,
        total_feeds=db.scalar(select(func.count()).select_from(Feed).join(Source).where(Source.status == "active")) or 0,
        feeds_last_24h=(
            db.scalar(
                select(func.count())
                .select_from(Feed)
                .join(Source)
                .where(Source.status == "active", Feed.published_at >= last_24h)
            )
            or 0
        ),
    )
    if settings.response_cache_enabled:
        response_cache.set_json(cache_key, payload.model_dump(mode="json"), settings.response_cache_ttl_seconds)
    return payload
