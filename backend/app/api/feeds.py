from __future__ import annotations

from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.api.deps import get_session
from app.db.models import Feed, Source
from app.schemas.feed import FeedListResponse, FeedResponse

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


@router.get(
    "/feeds",
    response_model=FeedListResponse,
    summary="List feeds",
    description="List feed entries across active sources with optional source, language, and time-window filters.",
    responses={400: {"description": "Invalid since filter"}},
)
def list_feeds(
    source_id: str | None = None,
    language: str | None = None,
    since: str | None = None,
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=20, ge=1, le=100),
    db: Session = Depends(get_session),
) -> FeedListResponse:
    since_dt = _parse_since(since)

    query = select(Feed).join(Source).where(Source.status == "active")
    count_query = select(func.count()).select_from(Feed).join(Source).where(Source.status == "active")

    if source_id:
        query = query.where(Feed.source_id == source_id)
        count_query = count_query.where(Feed.source_id == source_id)
    if language:
        query = query.where(Source.language == language)
        count_query = count_query.where(Source.language == language)
    if since_dt:
        query = query.where(Feed.published_at >= since_dt)
        count_query = count_query.where(Feed.published_at >= since_dt)

    total = db.scalar(count_query) or 0
    query = query.order_by(Feed.published_at.desc()).offset((page - 1) * limit).limit(limit)
    feeds = db.scalars(query).all()

    return FeedListResponse(
        items=[FeedResponse.model_validate(feed) for feed in feeds],
        page=page,
        limit=limit,
        total=total,
    )


@router.get(
    "/sources/{source_id}/feeds",
    response_model=FeedListResponse,
    summary="List feeds for a source",
    description="List feed entries for a single active source.",
    responses={404: {"description": "Source not found"}},
)
def list_source_feeds(
    source_id: str,
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=20, ge=1, le=100),
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
        items=[FeedResponse.model_validate(feed) for feed in feeds],
        page=page,
        limit=limit,
        total=total,
    )


@router.get(
    "/sources/{source_id}/feeds/{feed_id}",
    response_model=FeedResponse,
    summary="Get one feed entry",
    description="Return a single feed entry from an active source.",
    responses={404: {"description": "Feed not found"}},
)
def get_source_feed(source_id: str, feed_id: str, db: Session = Depends(get_session)) -> FeedResponse:
    query = select(Feed).join(Source).where(Source.status == "active", Feed.source_id == source_id, Feed.id == feed_id)
    feed = db.scalar(query)
    if not feed:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "feed_not_found", "message": "Feed not found."},
        )
    return FeedResponse.model_validate(feed)
