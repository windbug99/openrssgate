from datetime import UTC, datetime

from app.db.database import Base, SessionLocal, engine
from app.db.models import Source
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
                    "published_at": datetime(2026, 3, 12, 0, 0, tzinfo=UTC),
                }
            ],
        )
        db.commit()
        db.refresh(source)

        assert result["inserted"] == 1
        assert source.last_published_at == datetime(2026, 3, 12, 0, 0)


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
                    "published_at": datetime(2026, 3, 12, 0, 0, tzinfo=UTC),
                }
            ],
        )
        db.commit()
        db.refresh(source)

        assert result["inserted"] == 1
        assert source.last_published_at == datetime(2026, 3, 12, 0, 0)
