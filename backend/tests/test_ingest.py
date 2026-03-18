from datetime import UTC, datetime

from app.db.database import Base, SessionLocal, engine
from app.db.models import Feed, Source
from app.services import ingest as ingest_module
from app.services.ingest import ingest_source_bundle


def test_ingest_source_bundle_inserts_new_feeds() -> None:
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

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

        result = ingest_source_bundle(
            db=db,
            source=source,
            metadata={
                "site_url": "https://example.com",
                "title": "Example",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss20",
            },
            entries=[
                {
                    "guid": "feed-1",
                    "title": "First post",
                    "feed_url": "https://example.com/posts/1",
                    "author": "Jane Doe",
                    "summary": "Short summary",
                    "content": "<p>Full content</p>",
                    "published_at": datetime(2026, 3, 12, 0, 0, tzinfo=UTC),
                }
            ],
        )
        db.commit()
        db.refresh(source)
        feed = db.query(Feed).filter(Feed.source_id == source.id, Feed.guid == "feed-1").one()

        assert result["inserted"] == 1
        assert source.last_published_at == datetime(2026, 3, 12, 0, 0)
        assert feed.author == "Jane Doe"
        assert feed.summary == "Short summary"
        assert feed.content == "<p>Full content</p>"


def test_ingest_source_bundle_handles_aware_last_published_at_from_db() -> None:
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    with SessionLocal() as db:
        source = Source(
            rss_url="https://example.com/rss.xml",
            site_url="https://example.com",
            title="Example",
            description="desc",
            status="active",
            registered_by="web",
            last_published_at=datetime(2026, 3, 11, 12, 0, tzinfo=UTC),
        )
        db.add(source)
        db.commit()
        db.refresh(source)

        result = ingest_source_bundle(
            db=db,
            source=source,
            metadata={
                "site_url": "https://example.com",
                "title": "Example",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss20",
            },
            entries=[
                {
                    "guid": "feed-2",
                    "title": "Second post",
                    "feed_url": "https://example.com/posts/2",
                    "author": "Jane Doe",
                    "summary": "Summary",
                    "content": "<p>Content</p>",
                    "published_at": datetime(2026, 3, 12, 0, 0, tzinfo=UTC),
                }
            ],
        )
        db.commit()
        db.refresh(source)

        assert result["inserted"] == 1
        assert source.last_published_at == datetime(2026, 3, 12, 0, 0)


def test_ingest_source_bundle_persists_only_recent_entries_and_skips_duplicates(monkeypatch) -> None:
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    fixed_now = datetime(2026, 3, 15, 0, 0, tzinfo=UTC)
    monkeypatch.setattr(ingest_module, "_utcnow", lambda: fixed_now)

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

        first_result = ingest_source_bundle(
            db=db,
            source=source,
            metadata={
                "site_url": "https://example.com",
                "title": "Example",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss20",
            },
            entries=[
                {
                    "guid": "recent-1",
                    "title": "Recent post",
                    "feed_url": "https://example.com/posts/1",
                    "author": "Jane Doe",
                    "summary": "Recent summary",
                    "content": "<p>Recent content</p>",
                    "published_at": datetime(2026, 3, 14, 0, 0, tzinfo=UTC),
                },
                {
                    "guid": "old-1",
                    "title": "Old post",
                    "feed_url": "https://example.com/posts/old",
                    "author": "Jane Doe",
                    "summary": "Old summary",
                    "content": "<p>Old content</p>",
                    "published_at": datetime(2026, 2, 12, 0, 0, tzinfo=UTC),
                },
                {
                    "guid": "missing-date",
                    "title": "No date",
                    "feed_url": "https://example.com/posts/no-date",
                    "author": "Jane Doe",
                    "summary": "No date summary",
                    "content": "<p>No date content</p>",
                    "published_at": None,
                },
            ],
        )
        db.commit()

        second_result = ingest_source_bundle(
            db=db,
            source=source,
            metadata={
                "site_url": "https://example.com",
                "title": "Example",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss20",
            },
            entries=[
                {
                    "guid": "recent-1",
                    "title": "Recent post",
                    "feed_url": "https://example.com/posts/1",
                    "author": "Jane Doe",
                    "summary": "Recent summary",
                    "content": "<p>Recent content</p>",
                    "published_at": datetime(2026, 3, 14, 0, 0, tzinfo=UTC),
                },
                {
                    "guid": "recent-2",
                    "title": "New recent post",
                    "feed_url": "https://example.com/posts/2",
                    "author": "John Doe",
                    "summary": "New summary",
                    "content": "<p>New content</p>",
                    "published_at": datetime(2026, 3, 15, 0, 0, tzinfo=UTC),
                },
            ],
        )
        db.commit()
        db.refresh(source)

        feeds = db.query(Feed).filter(Feed.source_id == source.id).order_by(Feed.guid.asc()).all()

        assert first_result["inserted"] == 1
        assert second_result["inserted"] == 1
        assert [feed.guid for feed in feeds] == ["recent-1", "recent-2"]
        assert feeds[0].author == "Jane Doe"
        assert feeds[0].summary == "Recent summary"
        assert feeds[0].content == "<p>Recent content</p>"
        assert feeds[1].author == "John Doe"
        assert source.last_published_at == datetime(2026, 3, 15, 0, 0)
