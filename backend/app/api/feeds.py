from __future__ import annotations

from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.api.deps import get_session
from app.db.models import Feed, Source
from app.schemas.feed import FeedDetailResponse, FeedListRequest, FeedListResponse, FeedResponse, FeedSourceSummary
from app.source_metadata import csv_contains, parse_csv

router = APIRouter(tags=["feeds"])


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
    return datetime.now(timezone.utc) - delta


def _to_feed_detail_response(feed: Feed, source: Source) -> FeedDetailResponse:
    return FeedDetailResponse(
        id=feed.id,
        source_id=feed.source_id,
        guid=feed.guid,
        title=feed.title,
        feed_url=feed.feed_url,
        published_at=feed.published_at,
        author=feed.author,
        summary=feed.summary,
        content=feed.content,
        source=FeedSourceSummary(
            id=source.id,
            title=source.title,
            site_url=source.site_url,
            rss_url=source.rss_url,
            language=source.language,
            type=source.source_type,
            categories=parse_csv(source.categories),
            tags=parse_csv(source.tags),
        ),
    )

def _to_feed_response(feed: Feed, include_content: bool) -> FeedResponse:
    return FeedResponse(
        id=feed.id,
        source_id=feed.source_id,
        guid=feed.guid,
        title=feed.title,
        feed_url=feed.feed_url,
        published_at=feed.published_at,
        author=feed.author,
        summary=feed.summary,
        content=feed.content if include_content else None,
    )


@router.get(
    "/feeds",
    response_model=FeedListResponse,
    summary="List feeds",
    description="List feed entries across active sources with optional source, language, and time-window filters.",
    responses={400: {"description": "Invalid since filter"}},
)
def list_feeds(
    source_id: str | None = None,
    source_ids: str | None = Query(default=None, description="Comma-separated list of source IDs to filter by"),
    language: str | None = None,
    type: str | None = None,
    category: str | None = None,
    tag: str | None = None,
    q: str | None = None,
    since: str | None = None,
    content: bool = Query(default=True, description="Whether to include full content in the response"),
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=20, ge=1, le=500),
    db: Session = Depends(get_session),
) -> FeedListResponse:
    since_dt = _parse_since(since)

    query = select(Feed).join(Source).where(Source.status == "active")
    count_query = select(func.count()).select_from(Feed).join(Source).where(Source.status == "active")

    if source_id:
        query = query.where(Feed.source_id == source_id)
        count_query = count_query.where(Feed.source_id == source_id)
    if source_ids:
        ids = [i.strip() for i in source_ids.split(",") if i.strip()]
        if ids:
            query = query.where(Feed.source_id.in_(ids))
            count_query = count_query.where(Feed.source_id.in_(ids))
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
    if q:
        pattern = f"%{q}%"
        query = query.where(Feed.title.ilike(pattern))
        count_query = count_query.where(Feed.title.ilike(pattern))
    if since_dt:
        query = query.where(Feed.published_at >= since_dt)
        count_query = count_query.where(Feed.published_at >= since_dt)

    total = db.scalar(count_query) or 0
    query = query.order_by(Feed.published_at.desc()).offset((page - 1) * limit).limit(limit)
    feeds = db.scalars(query).all()

    return FeedListResponse(
        items=[_to_feed_response(feed, content) for feed in feeds],
        page=page,
        limit=limit,
        total=total,
    )


@router.post(
    "/feeds",
    response_model=FeedListResponse,
    summary="List feeds (POST)",
    description="List feed entries with filters provided in the request body. Useful for large number of source_ids.",
)
def list_feeds_post(
    request: FeedListRequest,
    db: Session = Depends(get_session),
) -> FeedListResponse:
    since_dt = _parse_since(request.since)

    query = select(Feed).join(Source).where(Source.status == "active")
    count_query = select(func.count()).select_from(Feed).join(Source).where(Source.status == "active")

    final_source_ids = set(request.source_ids or [])
    if request.rss_urls:
        source_id_rows = db.scalars(select(Source.id).where(Source.rss_url.in_(request.rss_urls))).all()
        final_source_ids.update(source_id_rows)

    if final_source_ids:
        query = query.where(Feed.source_id.in_(list(final_source_ids)))
        count_query = count_query.where(Feed.source_id.in_(list(final_source_ids)))

    if since_dt:
        query = query.where(Feed.published_at >= since_dt)
        count_query = count_query.where(Feed.published_at >= since_dt)

    total = db.scalar(count_query) or 0
    query = query.order_by(Feed.published_at.desc()).offset((request.page - 1) * request.limit).limit(request.limit)
    feeds = db.scalars(query).all()

    return FeedListResponse(
        items=[_to_feed_response(feed, request.content) for feed in feeds],
        page=request.page,
        limit=request.limit,
        total=total,
    )


@router.get(
    "/feeds/{feed_id}",
    response_model=FeedDetailResponse,
    summary="Get one feed entry",
    description="Return a single feed entry from an active source using a top-level feed id lookup.",
    responses={404: {"description": "Feed not found"}},
)
def get_feed(feed_id: str, db: Session = Depends(get_session)) -> FeedDetailResponse:
    query = select(Feed, Source).join(Source).where(Source.status == "active", Feed.id == feed_id)
    row = db.execute(query).first()
    if not row:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "feed_not_found", "message": "Feed not found."},
        )

    feed, source = row
    return _to_feed_detail_response(feed, source)


@router.get(
    "/sources/{source_id}/feeds",
    response_model=FeedListResponse,
    summary="List feeds for a source",
    description="List feed entries for a single active source.",
    responses={404: {"description": "Source not found"}},
)
def list_source_feeds(
    source_id: str,
    content: bool = Query(default=True, description="Whether to include full content in the response"),
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=20, ge=1, le=500),
    db: Session = Depends(get_session),
) -> FeedListResponse:
    source = db.get(Source, source_id)
    if not source or source.status != "active":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )

    query = select(Feed).where(Feed.source_id == source_id)
    count_query = select(func.count()).select_from(Feed).where(Feed.source_id == source_id)
    total = db.scalar(count_query) or 0
    feeds = db.scalars(query.order_by(Feed.published_at.desc()).offset((page - 1) * limit).limit(limit)).all()

    return FeedListResponse(
        items=[_to_feed_response(feed, content) for feed in feeds],
        page=page,
        limit=limit,
        total=total,
    )


@router.get(
    "/sources/{source_id}/feeds/{feed_id}",
    response_model=FeedDetailResponse,
    summary="Get one feed entry",
    description="Return a single feed entry from an active source.",
    responses={404: {"description": "Feed not found"}},
)
def get_source_feed(source_id: str, feed_id: str, db: Session = Depends(get_session)) -> FeedDetailResponse:
    query = select(Feed, Source).join(Source).where(Source.status == "active", Feed.source_id == source_id, Feed.id == feed_id)
    row = db.execute(query).first()
    if not row:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "feed_not_found", "message": "Feed not found."},
        )
    feed, source = row
    return _to_feed_detail_response(feed, source)
