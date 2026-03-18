from datetime import UTC, datetime, timedelta

from app.collector import scheduler as scheduler_module
from app.collector.scheduler import get_due_sources, purge_expired_feeds
from app.db.database import Base, SessionLocal, engine
from app.db.models import Feed, Source


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


def test_purge_expired_feeds_removes_only_entries_older_than_retention(monkeypatch) -> None:
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    fixed_now = datetime(2026, 3, 15, 0, 0, tzinfo=UTC)
    monkeypatch.setattr(
        scheduler_module,
        "get_settings",
        lambda: type("Settings", (), {"feed_retention_days": 14})(),
    )
    monkeypatch.setattr(scheduler_module, "datetime", type("FrozenDateTime", (), {"now": staticmethod(lambda _tz=None: fixed_now)}))

    with SessionLocal() as db:
        source = Source(
            rss_url="https://example.com/rss.xml",
            site_url="https://example.com",
            title="Example",
            description="desc",
            status="active",
            registered_by="web",
        )
        db.add(source)
        db.commit()
        db.refresh(source)

        db.add_all(
            [
                Feed(
                    source_id=source.id,
                    guid="recent",
                    title="Recent feed",
                    feed_url="https://example.com/recent",
                    published_at=fixed_now - timedelta(days=10),
                ),
                Feed(
                    source_id=source.id,
                    guid="expired",
                    title="Expired feed",
                    feed_url="https://example.com/expired",
                    published_at=fixed_now - timedelta(days=15),
                ),
                Feed(
                    source_id=source.id,
                    guid="no-date",
                    title="No date feed",
                    feed_url="https://example.com/no-date",
                    published_at=None,
                ),
            ]
        )
        db.commit()

        deleted_count = purge_expired_feeds(db)
        remaining_guids = {feed.guid for feed in db.query(Feed).all()}

    assert deleted_count == 1
    assert remaining_guids == {"recent", "no-date"}
