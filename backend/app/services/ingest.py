from __future__ import annotations

from datetime import UTC, datetime, timedelta

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.config import get_settings
from app.db.models import Feed, Source


def _utcnow() -> datetime:
    return datetime.now(UTC)


def _to_utc_naive(value: datetime | None) -> datetime | None:
    if value is None:
        return None
    if value.tzinfo is None:
        return value
    return value.astimezone(UTC).replace(tzinfo=None)


def _recent_entry_cutoff() -> datetime:
    settings = get_settings()
    return _to_utc_naive(_utcnow()) - timedelta(days=settings.feed_retention_days)


def _filter_recent_entries(entries: list[dict[str, object]]) -> list[dict[str, object]]:
    cutoff = _recent_entry_cutoff()
    filtered: list[dict[str, object]] = []
    for entry in entries:
        published_at = _to_utc_naive(entry.get("published_at"))
        if published_at is None or published_at < cutoff:
            continue
        filtered.append({**entry, "published_at": published_at})
    return filtered


def ingest_source_bundle(
    db: Session,
    source: Source,
    metadata: dict[str, object],
    entries: list[dict[str, object]],
) -> dict[str, int]:
    recent_entries = _filter_recent_entries(entries)

    source.site_url = str(metadata.get("site_url") or source.site_url)
    source.title = str(metadata.get("title") or source.title)
    source.description = metadata.get("description") if metadata.get("description") is not None else source.description
    source.favicon_url = metadata.get("favicon_url") if metadata.get("favicon_url") is not None else source.favicon_url
    source.feed_format = str(metadata.get("feed_format") or source.feed_format or "unknown")
    source.last_fetched_at = _to_utc_naive(_utcnow())
    source.consecutive_fail_count = 0

    inserted = 0
    latest_published_at = _to_utc_naive(source.last_published_at)
    candidate_guids = [str(entry["guid"]) for entry in recent_entries]

    existing_guids = set()
    if candidate_guids:
        existing_guids = set(
            db.scalars(select(Feed.guid).where(Feed.source_id == source.id, Feed.guid.in_(candidate_guids))).all()
        )

    for entry in recent_entries:
        guid = str(entry["guid"])
        if guid in existing_guids:
            continue

        published_at = _to_utc_naive(entry.get("published_at"))
        feed = Feed(
            source_id=source.id,
            guid=guid,
            title=str(entry["title"]),
            feed_url=str(entry["feed_url"]),
            author=str(entry["author"]).strip() if entry.get("author") else None,
            summary=str(entry["summary"]).strip() if entry.get("summary") else None,
            content=str(entry["content"]).strip() if entry.get("content") else None,
            published_at=published_at,
        )
        db.add(feed)
        inserted += 1

        if published_at and (latest_published_at is None or published_at > latest_published_at):
            latest_published_at = published_at

    source.last_published_at = _to_utc_naive(latest_published_at)
    return {"inserted": inserted}


def mark_source_fetch_failure(db: Session, source: Source) -> None:
    source.consecutive_fail_count += 1
    source.last_fetched_at = _to_utc_naive(_utcnow())
    if source.consecutive_fail_count >= 5:
        source.fetch_interval_minutes = 24 * 60
    db.add(source)
