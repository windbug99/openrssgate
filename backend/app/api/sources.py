from __future__ import annotations

from urllib.parse import urlparse

from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from sqlalchemy import func, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.api.deps import get_session
from app.core.config import get_settings
from app.db.models import Source
from app.schemas.source import SourceCreate, SourceListResponse, SourceResponse
from app.source_metadata import csv_contains, join_csv, parse_csv
from app.services.ingest import ingest_source_bundle
from app.services.rate_limit import RateLimitExceededError, registration_rate_limiter
from app.services.review import review_source_bundle
from app.services.rss import InvalidRSSUrlError, fetch_feed_bundle

router = APIRouter(prefix="/sources", tags=["sources"])


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
        registered_by=source.registered_by,
        registered_at=source.registered_at,
        last_fetched_at=source.last_fetched_at,
        last_published_at=source.last_published_at,
    )


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
    site_url = str(metadata.get("site_url") or "").strip()
    duplicate_site_url_exists = False
    if site_url:
        duplicate_site_url_exists = (
            db.scalar(select(func.count()).select_from(Source).where(Source.site_url == site_url)) or 0
        ) > 0

    source = Source(
        rss_url=metadata["rss_url"],
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

    decision = review_source_bundle(
        metadata=metadata,
        entries=bundle["entries"],
        duplicate_site_url_exists=duplicate_site_url_exists,
    )
    source.status = decision.status
    source.status_reason = decision.reason

    if decision.status == "active":
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
