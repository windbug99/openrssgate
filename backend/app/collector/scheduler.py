from __future__ import annotations

import logging
from datetime import UTC, datetime, timedelta

from sqlalchemy import delete, select
from sqlalchemy.orm import Session

from app.core.config import get_settings
from app.db.models import Source
from app.db.models import Feed
from app.services.ingest import ingest_source_bundle, mark_source_fetch_failure
from app.services.rss import InvalidRSSUrlError, fetch_feed_bundle

logger = logging.getLogger(__name__)


def _as_utc_naive(value: datetime) -> datetime:
    if value.tzinfo is None:
        return value
    return value.astimezone(UTC).replace(tzinfo=None)


def get_due_sources(db: Session) -> list[Source]:
    now = _as_utc_naive(datetime.now(UTC))
    sources = list(db.scalars(select(Source).where(Source.status == "active")).all())
    return [
        source
        for source in sources
        if source.last_fetched_at is None
        or _as_utc_naive(source.last_fetched_at) <= now - timedelta(minutes=source.fetch_interval_minutes)
    ]


def purge_expired_feeds(db: Session) -> int:
    settings = get_settings()
    cutoff = _as_utc_naive(datetime.now(UTC)) - timedelta(days=settings.feed_retention_days)
    result = db.execute(delete(Feed).where(Feed.published_at.is_not(None), Feed.published_at < cutoff))
    db.commit()
    return int(result.rowcount or 0)


async def collect_source(db: Session, source: Source) -> dict[str, object]:
    try:
        bundle = await fetch_feed_bundle(source.rss_url)
    except InvalidRSSUrlError as exc:
        mark_source_fetch_failure(db, source)
        db.commit()
        logger.warning(
            "collector.fetch_failed source_id=%s rss_url=%s fail_count=%s reason=%s",
            source.id,
            source.rss_url,
            source.consecutive_fail_count,
            str(exc),
        )
        return {"source_id": source.id, "status": "failed", "reason": str(exc), "inserted": 0}

    result = ingest_source_bundle(
        db=db,
        source=source,
        metadata=bundle["metadata"],
        entries=bundle["entries"],
    )
    db.commit()
    logger.info(
        "collector.fetch_ok source_id=%s rss_url=%s inserted=%s",
        source.id,
        source.rss_url,
        result["inserted"],
    )
    return {"source_id": source.id, "status": "ok", "inserted": result["inserted"]}


async def run_collection_cycle(db: Session) -> dict[str, object]:
    due_sources = get_due_sources(db)
    inserted_total = 0
    results: list[dict[str, object]] = []

    for source in due_sources:
        result = await collect_source(db, source)
        inserted_total += int(result["inserted"])
        results.append(result)

    return {"processed_sources": len(due_sources), "inserted_feeds": inserted_total, "results": results}
