from datetime import UTC, datetime, timedelta

from app.collector.scheduler import get_due_sources
from app.db.database import Base, SessionLocal, engine
from app.db.models import Source


def test_get_due_sources_respects_fetch_interval() -> None:
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    now = datetime.now(UTC)
    due = Source(
        rss_url="https://example.com/due.xml",
        site_url="https://example.com",
        title="Due source",
        description="desc",
        status="active",
        registered_by="web",
        fetch_interval_minutes=60,
        last_fetched_at=now - timedelta(minutes=61),
    )
    not_due = Source(
        rss_url="https://example.com/not-due.xml",
        site_url="https://example.com",
        title="Not due source",
        description="desc",
        status="active",
        registered_by="web",
        fetch_interval_minutes=60,
        last_fetched_at=now - timedelta(minutes=10),
    )

    with SessionLocal() as db:
        db.add_all([due, not_due])
        db.commit()

        due_sources = get_due_sources(db)

    assert len(due_sources) == 1
    assert due_sources[0].rss_url == "https://example.com/due.xml"
