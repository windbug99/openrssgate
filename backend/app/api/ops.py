from __future__ import annotations

from datetime import UTC, datetime, timedelta

from fastapi import APIRouter, Depends
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.api.deps import get_session
from app.core.config import get_settings
from app.db.models import Feed, Source

router = APIRouter(prefix="/ops", tags=["ops"])


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
