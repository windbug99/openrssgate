from __future__ import annotations

from datetime import UTC, datetime, timedelta

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.api.deps import get_session
from app.core.config import get_settings
from app.db.models import Feed, Source
from app.services.alerts import summarize_alerts
from app.services.api_keys import require_service_api_key
from app.services.cache import response_cache

router = APIRouter(prefix="/ops", tags=["ops"])


class SourceStatusUpdateRequest(BaseModel):
    status: str = Field(pattern="^(active|hidden|rejected)$")
    reason: str | None = Field(default=None, max_length=255)


@router.get(
    "/summary",
    summary="Operations summary",
    description="Return high-level API, database, source, and collector status to support lightweight operations checks.",
)
def get_operations_summary(db: Session = Depends(get_session)) -> dict[str, object]:
    settings = get_settings()
    cache_key = "ops:summary"
    if settings.response_cache_enabled:
        cached = response_cache.get_json(cache_key)
        if cached is not None:
            return cached

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

    overall_status, alerts = summarize_alerts(
        failing_sources=source_counts["failing"],
        stale_sources=source_counts["stale"],
        latest_fetched_at=latest_fetch_at,
        stale_sources_threshold=settings.ops_alert_stale_sources_threshold,
        failing_sources_threshold=settings.ops_alert_failing_sources_threshold,
        collector_lag_minutes=settings.ops_alert_collector_lag_minutes,
    )

    payload = {
        "status": overall_status,
        "database": "ok",
        "time": now.replace(tzinfo=UTC).isoformat(),
        "sources": source_counts,
        "feeds": {"total": feed_count, "latest_published_at": latest_feed_at},
        "collector": {
            "poll_interval_seconds": settings.collector_poll_interval_seconds,
            "stale_after_minutes": settings.collector_stale_after_minutes,
            "latest_fetched_at": latest_fetch_at,
        },
        "alerts": alerts,
    }
    if settings.response_cache_enabled:
        response_cache.set_json(cache_key, payload, settings.response_cache_ttl_seconds)
    return payload


@router.get(
    "/alerts",
    summary="Operations alerts",
    description="Return warning and critical operational alerts derived from source and collector health signals.",
)
def get_operations_alerts(db: Session = Depends(get_session)) -> dict[str, object]:
    summary = get_operations_summary(db)
    return {"status": summary["status"], "time": summary["time"], "alerts": summary["alerts"]}


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
                "ai_reviewed_at": source.ai_reviewed_at,
                "ai_review_source": source.ai_review_source,
                "ai_review_reason": source.ai_review_reason,
                "ai_review_confidence": source.ai_review_confidence,
                "ai_review_decision": source.ai_review_decision,
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
    _: None = Depends(require_service_api_key),
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
