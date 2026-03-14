from __future__ import annotations

import asyncio
import logging

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.interval import IntervalTrigger

from app.collector.scheduler import purge_expired_feeds, run_collection_cycle
from app.core.config import get_settings
from app.db.database import Base, SessionLocal, engine

logger = logging.getLogger(__name__)


async def _run_cycle() -> None:
    with SessionLocal() as db:
        result = await run_collection_cycle(db)
    logger.info(
        "collection cycle completed",
        extra={
            "processed_sources": result["processed_sources"],
            "inserted_feeds": result["inserted_feeds"],
        },
    )


async def _run_cleanup_cycle() -> None:
    with SessionLocal() as db:
        deleted_feeds = purge_expired_feeds(db)
    logger.info(
        "feed cleanup cycle completed",
        extra={"deleted_feeds": deleted_feeds},
    )


async def run_worker() -> None:
    settings = get_settings()
    Base.metadata.create_all(bind=engine)

    scheduler = AsyncIOScheduler()
    scheduler.add_job(
        _run_cycle,
        trigger=IntervalTrigger(seconds=settings.collector_poll_interval_seconds),
        id="collect-feeds",
        max_instances=1,
        coalesce=True,
        replace_existing=True,
    )
    scheduler.add_job(
        _run_cleanup_cycle,
        trigger=IntervalTrigger(hours=settings.feed_cleanup_interval_hours),
        id="cleanup-old-feeds",
        max_instances=1,
        coalesce=True,
        replace_existing=True,
    )
    scheduler.start()

    logger.info(
        "collector worker started",
        extra={
            "collector_poll_interval_seconds": settings.collector_poll_interval_seconds,
            "feed_cleanup_interval_hours": settings.feed_cleanup_interval_hours,
            "feed_retention_days": settings.feed_retention_days,
        },
    )

    await _run_cycle()
    await _run_cleanup_cycle()

    stop_event = asyncio.Event()
    try:
        await stop_event.wait()
    finally:
        scheduler.shutdown(wait=False)


def main() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s [%(name)s] %(message)s",
    )
    asyncio.run(run_worker())


if __name__ == "__main__":
    main()
