from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime, timedelta
from urllib.parse import urlparse


SPAM_KEYWORDS = {
    "casino",
    "bet",
    "slot",
    "loan",
    "viagra",
    "crypto pump",
    "forex signal",
}
STALE_FEED_DAYS = 365
MAX_MISSING_PUBLISHED_RATIO = 0.7
MAX_DUPLICATE_TITLE_RATIO = 0.6


@dataclass(frozen=True)
class ReviewDecision:
    status: str
    reason: str


def _normalize_site_host(site_url: str) -> str:
    return (urlparse(site_url).hostname or "").lower()


def review_source_bundle(
    metadata: dict[str, object],
    entries: list[dict[str, object]],
    *,
    duplicate_site_url_exists: bool = False,
) -> ReviewDecision:
    title = str(metadata.get("title") or "").strip()
    site_url = str(metadata.get("site_url") or "").strip()
    normalized_title = title.lower()

    if duplicate_site_url_exists and _normalize_site_host(site_url):
        return ReviewDecision(status="rejected", reason="duplicate_site_url")

    if any(keyword in normalized_title for keyword in SPAM_KEYWORDS):
        return ReviewDecision(status="rejected", reason="spam_like_title")

    if not entries:
        return ReviewDecision(status="rejected", reason="no_feed_entries")

    if len(entries) < 2:
        return ReviewDecision(status="hidden", reason="too_few_entries")

    titles = [str(entry.get("title") or "").strip().lower() for entry in entries if str(entry.get("title") or "").strip()]
    if titles:
        duplicate_ratio = 1 - (len(set(titles)) / len(titles))
        if duplicate_ratio >= MAX_DUPLICATE_TITLE_RATIO:
            return ReviewDecision(status="hidden", reason="repetitive_entry_titles")

    published_entries = [entry.get("published_at") for entry in entries]
    missing_published_count = sum(1 for published_at in published_entries if published_at is None)
    if entries and (missing_published_count / len(entries)) > MAX_MISSING_PUBLISHED_RATIO:
        return ReviewDecision(status="hidden", reason="missing_published_dates")

    valid_published = [published_at for published_at in published_entries if isinstance(published_at, datetime)]
    if valid_published:
        latest_published = max(valid_published)
        latest_published_utc = (
            latest_published if latest_published.tzinfo else latest_published.replace(tzinfo=UTC)
        ).astimezone(UTC)
        if latest_published_utc < datetime.now(UTC) - timedelta(days=STALE_FEED_DAYS):
            return ReviewDecision(status="hidden", reason="stale_feed")

    return ReviewDecision(status="active", reason="auto_approved")
