from __future__ import annotations

from dataclasses import dataclass


GENERIC_TITLES = {"rss", "feed", "untitled", "new posts"}


@dataclass(frozen=True)
class ReviewDecision:
    status: str
    reason: str


def review_source_bundle(metadata: dict[str, object], entries: list[dict[str, object]]) -> ReviewDecision:
    title = str(metadata.get("title") or "").strip()
    description = str(metadata.get("description") or "").strip()

    if len(title) < 3 or title.lower() in GENERIC_TITLES:
        return ReviewDecision(status="rejected", reason="generic_or_invalid_title")

    if not entries:
        return ReviewDecision(status="rejected", reason="no_feed_entries")

    if len(entries) < 2:
        return ReviewDecision(status="hidden", reason="too_few_entries")

    if not description:
        return ReviewDecision(status="hidden", reason="missing_description")

    return ReviewDecision(status="active", reason="auto_approved")
