from __future__ import annotations

from datetime import UTC, datetime, timedelta

from fastapi import APIRouter, Depends, Header, HTTPException, status
from pydantic import BaseModel, Field
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.api.deps import get_session
from app.core.config import get_settings
from app.db.models import Feed, Source

router = APIRouter(prefix="/ops", tags=["ops"])


class SourceStatusUpdateRequest(BaseModel):
    status: str = Field(pattern="^(active|hidden|rejected)$")
    reason: str | None = Field(default=None, max_length=255)


def require_ops_key(x_ops_key: str | None = Header(default=None)) -> None:
    settings = get_settings()
    if not settings.ops_api_key:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail={"code": "ops_key_not_configured", "message": "Operations API key is not configured."},
        )
    if x_ops_key != settings.ops_api_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "invalid_ops_key", "message": "A valid operations API key is required."},
        )


@router.get(
    "/summary",
    summary="Operations summary",
    description="Return high-level API, database, source, and collector status to support lightweight operations checks.",
)
def get_operations_summary(db: Session = Depends(get_session)) -> dict[str, object]:
    settings = get_settings()
    now = datetime.now(UTC).replace(tzinfo=None)
    stale_before = now - timedelta(minutes=settings.collector_stale_after_minutes)

    source_counts = {
        "total": db.scalar(select(func.count()).select_from(Source)) or 0,
        "active": db.scalar(select(func.count()).select_from(Source).where(Source.status == "active")) or 0,
        "pending_review": db.scalar(select(func.count()).select_from(Source).where(Source.status == "pending_review")) or 0,
        "hidden": db.scalar(select(func.count()).select_from(Source).where(Source.status == "hidden")) or 0,
        "rejected": db.scalar(select(func.count()).select_from(Source).where(Source.status == "rejected")) or 0,
        "failing": db.scalar(select(func.count()).select_from(Source).where(Source.consecutive_fail_count > 0)) or 0,
        "stale": db.scalar(
            select(func.count()).select_from(Source).where(
                Source.status == "active",
                Source.last_fetched_at.is_not(None),
                Source.last_fetched_at < stale_before,
            )
        )
        or 0,
    }
    feed_count = db.scalar(select(func.count()).select_from(Feed)) or 0
    latest_feed_at = db.scalar(select(func.max(Feed.published_at)).select_from(Feed))
    latest_fetch_at = db.scalar(select(func.max(Source.last_fetched_at)).select_from(Source))

    return {
        "status": "ok",
        "database": "ok",
        "time": now.replace(tzinfo=UTC).isoformat(),
        "sources": source_counts,
        "feeds": {"total": feed_count, "latest_published_at": latest_feed_at},
        "collector": {
            "poll_interval_seconds": settings.collector_poll_interval_seconds,
            "stale_after_minutes": settings.collector_stale_after_minutes,
            "latest_fetched_at": latest_fetch_at,
        },
    }


@router.get(
    "/sources",
    summary="Operations source listing",
    description="List sources across all moderation states for lightweight operations review.",
)
def list_operational_sources(
    status: str | None = None,
    limit: int = 50,
    db: Session = Depends(get_session),
) -> dict[str, object]:
    query = select(Source)
    if status:
        query = query.where(Source.status == status)

    sources = db.scalars(query.order_by(Source.registered_at.desc()).limit(min(max(limit, 1), 200))).all()
    return {
        "items": [
            {
                "id": source.id,
                "rss_url": source.rss_url,
                "title": source.title,
                "status": source.status,
                "status_reason": source.status_reason,
                "registered_at": source.registered_at,
                "last_fetched_at": source.last_fetched_at,
                "consecutive_fail_count": source.consecutive_fail_count,
            }
            for source in sources
        ]
    }


@router.post(
    "/sources/{source_id}/status",
    summary="Update source moderation status",
    description="Update a source to active, hidden, or rejected for operations moderation flows.",
)
def update_operational_source_status(
    source_id: str,
    payload: SourceStatusUpdateRequest,
    _: None = Depends(require_ops_key),
    db: Session = Depends(get_session),
) -> dict[str, object]:
    source = db.get(Source, source_id)
    if not source:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )

    source.status = payload.status
    source.status_reason = payload.reason or source.status_reason
    db.add(source)
    db.commit()
    db.refresh(source)

    return {
        "id": source.id,
        "status": source.status,
        "status_reason": source.status_reason,
    }
