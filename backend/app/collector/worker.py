from __future__ import annotations

import asyncio
import logging

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.interval import IntervalTrigger

from app.collector.scheduler import run_collection_cycle
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
    scheduler.start()

    logger.info(
        "collector worker started",
        extra={"collector_poll_interval_seconds": settings.collector_poll_interval_seconds},
    )

    await _run_cycle()

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
