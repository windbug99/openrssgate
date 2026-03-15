from __future__ import annotations

import asyncio
import html
import re
import uuid
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from datetime import UTC, datetime
from html.parser import HTMLParser
from pathlib import Path
from typing import Any
from urllib.parse import urljoin, urlparse

import feedparser
import httpx

from app.api.sources import _detect_tags
from app.services.review import review_source_bundle
from app.source_metadata import MAX_SOURCE_CATEGORIES, SOURCE_CATEGORY_VALUES, SOURCE_TYPE_VALUES


OPML_PATHS = [
    Path("docs/feedly-744ba8b1-3a15-4b25-a356-f4529871a961-2026-02-18.opml"),
    Path("docs/subscriptions.opml"),
]
OUTPUT_PATH = Path("docs/20260314_opml_source_import.sql")
USER_AGENT = "OpenRSSGate Import Bot/0.1 (+https://github.com/windbug99/openrssgate)"
REQUEST_TIMEOUT = 12.0
MAX_CONCURRENCY = 12

LANGUAGE_VALUES = {
    "en",
    "zh",
    "es",
    "ar",
    "pt",
    "ru",
    "ja",
    "de",
    "fr",
    "ko",
    "hi",
    "id",
    "tr",
    "other",
}


class PageMetaParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.lang: str | None = None
        self.title: str = ""
        self._in_title = False
        self.meta: dict[str, str] = {}
        self.icons: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attr_map = {key.lower(): (value or "") for key, value in attrs}
        if tag.lower() == "html" and attr_map.get("lang"):
            self.lang = attr_map["lang"].strip()

        if tag.lower() == "title":
            self._in_title = True

        if tag.lower() == "meta":
            name = (attr_map.get("name") or attr_map.get("property") or "").strip().lower()
            content = attr_map.get("content", "").strip()
            if name and content:
                self.meta[name] = content

        if tag.lower() == "link":
            rel = attr_map.get("rel", "").lower()
            href = attr_map.get("href", "").strip()
            if href and "icon" in rel:
                self.icons.append(href)

    def handle_endtag(self, tag: str) -> None:
        if tag.lower() == "title":
            self._in_title = False

    def handle_data(self, data: str) -> None:
        if self._in_title:
            self.title += data


@dataclass
class OpmlSource:
    title: str
    rss_url: str
    html_url: str | None
    source_file: str


def normalize_language(candidate: str | None) -> str | None:
    if not candidate:
        return None
    value = candidate.strip().lower().replace("_", "-")
    if not value:
        return None
    primary = value.split("-")[0]
    return primary if primary in LANGUAGE_VALUES else "other"


def infer_language(*candidates: str | None) -> str | None:
    for candidate in candidates:
        normalized = normalize_language(candidate)
        if normalized:
            return normalized
    return None


def guess_language_from_text(text: str) -> str | None:
    if not text.strip():
        return None
    if re.search(r"[\uac00-\ud7a3]", text):
        return "ko"
    if re.search(r"[\u3040-\u30ff]", text):
        return "ja"
    if re.search(r"[\u4e00-\u9fff]", text):
        return "zh"
    if re.search(r"[\u0400-\u04ff]", text):
        return "ru"
    if re.search(r"[\u0600-\u06ff]", text):
        return "ar"
    return None


def pick_type(text: str, site_url: str, rss_url: str) -> str | None:
    haystack = " ".join([text.lower(), site_url.lower(), rss_url.lower()])
    checks = [
        ("newsletter", ["substack", "beehiiv", "newsletter", "/newsletter", "buttondown", "ghost.io"]),
        ("documentation", ["docs.", "/docs", "documentation", "reference", "manual", "developer docs"]),
        ("research", ["research", "paper", "papers", "arxiv", "csail", "lab", "institute"]),
        ("news", ["news", "journal", "times", "post", "report", "daily", "briefing"]),
        ("magazine", ["magazine", "review", "publication"]),
        ("forum", ["forum", "community", "discourse"]),
        ("podcast", ["podcast", "episode", "audio"]),
        ("video", ["youtube", "video", "channel"]),
        ("blog", ["blog", "weblog", "posts"]),
    ]
    for source_type, keywords in checks:
        if source_type not in SOURCE_TYPE_VALUES:
            continue
        if any(keyword in haystack for keyword in keywords):
            return source_type
    return "blog"


def pick_categories(text: str, site_url: str) -> list[str]:
    haystack = " ".join([text.lower(), site_url.lower()])
    category_keywords: list[tuple[str, list[str]]] = [
        ("tech", ["software", "engineering", "developer", "programming", "tech", "computer", "ai", "cloud"]),
        ("business", ["business", "startup", "founder", "saas", "market", "strategy"]),
        ("finance", ["finance", "invest", "investing", "economy", "stocks", "venture", "capital"]),
        ("science", ["science", "research", "lab", "physics", "biology"]),
        ("health", ["health", "medical", "medicine", "wellness"]),
        ("education", ["education", "learning", "teaching", "tutorial", "course"]),
        ("design", ["design", "ux", "ui", "typography"]),
        ("culture", ["culture", "society", "media criticism"]),
        ("entertainment", ["movies", "tv", "music", "entertainment"]),
        ("gaming", ["gaming", "games", "gamedev"]),
        ("sports", ["sports", "baseball", "football", "basketball", "soccer"]),
        ("lifestyle", ["lifestyle", "life", "habits"]),
        ("travel", ["travel", "trip", "aviation", "flying"]),
        ("food", ["food", "cooking", "recipe"]),
        ("fashion", ["fashion", "style"]),
        ("hobby", ["hobby", "craft", "photography"]),
        ("automotive", ["automotive", "cars", "ev", "tesla"]),
        ("politics", ["politics", "policy", "government", "election"]),
        ("security", ["security", "cybersecurity", "infosec"]),
        ("environment", ["climate", "environment", "energy"]),
        ("media", ["journalism", "writer", "newsletter", "publication", "media"]),
    ]
    selected: list[str] = []
    for category, keywords in category_keywords:
        if category not in SOURCE_CATEGORY_VALUES:
            continue
        if any(keyword in haystack for keyword in keywords):
            selected.append(category)
        if len(selected) >= MAX_SOURCE_CATEGORIES:
            break
    if not selected:
        selected.append("other")
    return selected[:MAX_SOURCE_CATEGORIES]


def normalize_url(url: str | None) -> str | None:
    if not url:
        return None
    value = url.strip()
    if not value:
        return None
    parsed = urlparse(value)
    if parsed.scheme not in {"http", "https"} or not parsed.netloc:
        return None
    path = parsed.path or "/"
    if path != "/" and path.endswith("/"):
        path = path[:-1]
    rebuilt = parsed._replace(netloc=parsed.netloc.lower(), path=path, fragment="")
    return rebuilt.geturl()


def sql_str(value: str | None) -> str:
    if value is None:
        return "NULL"
    return "'" + value.replace("\\", "\\\\").replace("'", "''") + "'"


def sql_timestamp(value: datetime | None) -> str:
    if value is None:
        return "NULL"
    return sql_str(value.astimezone(UTC).isoformat().replace("+00:00", "Z"))


def parse_opml_sources() -> list[OpmlSource]:
    items: list[OpmlSource] = []
    seen: set[str] = set()
    for path in OPML_PATHS:
        root = ET.parse(path).getroot()
        for outline in root.findall(".//outline"):
            rss_url = outline.attrib.get("xmlUrl") or outline.attrib.get("xmlurl")
            if not rss_url:
                continue
            normalized_rss = normalize_url(rss_url)
            if not normalized_rss or normalized_rss in seen:
                continue
            seen.add(normalized_rss)
            items.append(
                OpmlSource(
                    title=(outline.attrib.get("title") or outline.attrib.get("text") or "").strip(),
                    rss_url=normalized_rss,
                    html_url=normalize_url(outline.attrib.get("htmlUrl") or outline.attrib.get("htmlurl")),
                    source_file=path.name,
                )
            )
    return items


async def fetch_text(client: httpx.AsyncClient, url: str | None) -> tuple[str | None, str | None]:
    if not url:
        return None, None
    try:
        response = await client.get(url)
        response.raise_for_status()
        return response.text, str(response.url)
    except Exception:
        return None, None


def extract_site_meta(html_text: str | None, site_url: str) -> dict[str, str | None]:
    if not html_text:
        return {"title": None, "description": None, "lang": None, "favicon_url": urljoin(site_url, "/favicon.ico")}
    parser = PageMetaParser()
    parser.feed(html_text)
    description = (
        parser.meta.get("description")
        or parser.meta.get("og:description")
        or parser.meta.get("twitter:description")
    )
    title = parser.meta.get("og:title") or parser.title.strip() or None
    favicon = parser.icons[0] if parser.icons else "/favicon.ico"
    favicon_url = urljoin(site_url, favicon)
    lang = parser.lang or parser.meta.get("og:locale")
    return {"title": title, "description": description, "lang": lang, "favicon_url": favicon_url}


def published_at_from_entry(entry: Any) -> datetime | None:
    value = entry.get("published_parsed") or entry.get("updated_parsed")
    if not value:
        return None
    try:
        return datetime(
            value.tm_year,
            value.tm_mon,
            value.tm_mday,
            value.tm_hour,
            value.tm_min,
            value.tm_sec,
            tzinfo=UTC,
        )
    except Exception:
        return None


async def build_row(client: httpx.AsyncClient, semaphore: asyncio.Semaphore, source: OpmlSource) -> dict[str, Any]:
    async with semaphore:
        feed_text, final_rss_url = await fetch_text(client, source.rss_url)
        if not feed_text:
            return {"rss_url": source.rss_url, "error": "feed_fetch_failed", "source_file": source.source_file}

        parsed = feedparser.parse(feed_text)
        feed = parsed.feed
        site_url = normalize_url(feed.get("link")) or source.html_url
        if not site_url:
            parsed_rss = urlparse(final_rss_url or source.rss_url)
            site_url = f"{parsed_rss.scheme}://{parsed_rss.netloc}"

        site_html, final_site_url = await fetch_text(client, site_url)
        site_url = normalize_url(final_site_url) or site_url
        site_meta = extract_site_meta(site_html, site_url)

        title = str(feed.get("title") or site_meta["title"] or source.title or urlparse(site_url).netloc).strip()
        description = str(feed.get("subtitle") or feed.get("description") or site_meta["description"] or "").strip() or None
        language = infer_language(
            str(feed.get("language") or "") or None,
            site_meta["lang"],
            guess_language_from_text(" ".join(filter(None, [title, description or ""]))),
        )

        text_blob = " ".join(filter(None, [title, description or "", site_meta["title"] or "", site_meta["description"] or ""]))
        source_type = pick_type(text_blob, site_url, final_rss_url or source.rss_url)
        categories = pick_categories(text_blob, site_url)
        tags = _detect_tags({"title": title, "description": description}, [])

        entries: list[dict[str, Any]] = []
        last_published_at: datetime | None = None
        for entry in parsed.entries[:20]:
            entry_title = str(entry.get("title") or "").strip()
            entry_link = str(entry.get("link") or "").strip()
            if not entry_title or not entry_link:
                continue
            published_at = published_at_from_entry(entry)
            if published_at and (last_published_at is None or published_at > last_published_at):
                last_published_at = published_at
            entries.append(
                {
                    "guid": str(entry.get("id") or entry_link),
                    "title": entry_title,
                    "feed_url": entry_link,
                    "published_at": published_at,
                }
            )

        metadata_for_review = {
            "title": title,
            "description": description,
            "site_url": site_url,
        }
        decision = review_source_bundle(metadata_for_review, entries, duplicate_site_url_exists=False)

        normalized_rss_url = normalize_url(final_rss_url or source.rss_url) or source.rss_url
        if not tags:
            tags = ["other"]

        return {
            "id": str(uuid.uuid5(uuid.NAMESPACE_URL, normalized_rss_url)),
            "rss_url": normalized_rss_url,
            "site_url": site_url,
            "title": title[:255],
            "description": description,
            "favicon_url": normalize_url(site_meta["favicon_url"]) or urljoin(site_url, "/favicon.ico"),
            "language": language,
            "tags": ",".join(tags[:3]) if tags else None,
            "status": decision.status,
            "ai_reviewed_at": None,
            "ai_review_source": None,
            "ai_review_reason": None,
            "ai_review_confidence": None,
            "ai_review_decision": None,
            "feed_format": (parsed.version or "unknown")[:32],
            "fetch_interval_minutes": 60,
            "last_fetched_at": datetime.now(UTC),
            "last_published_at": last_published_at,
            "consecutive_fail_count": 0,
            "registered_by": "opml_import",
            "status_reason": decision.reason,
            "type": source_type,
            "categories": ",".join(categories[:2]) if categories else None,
            "source_file": source.source_file,
        }


def render_sql(rows: list[dict[str, Any]], failures: list[dict[str, Any]]) -> str:
    lines = [
        "-- Generated from OPML sources on 2026-03-14.",
        f"-- Imported rows: {len(rows)}",
        f"-- Failed rows: {len(failures)}",
    ]
    for failure in failures[:100]:
        lines.append(f"-- FAILED {failure['rss_url']} ({failure['source_file']}): {failure['error']}")

    lines.extend(
        [
            "",
            "BEGIN;",
            "",
        ]
    )

    for row in rows:
        lines.extend(
            [
                "INSERT INTO sources (",
                "  id, rss_url, site_url, title, description, favicon_url, language, tags,",
                "  status, status_reason, ai_reviewed_at, ai_review_source, ai_review_reason,",
                "  ai_review_confidence, ai_review_decision, feed_format, fetch_interval_minutes,",
                "  last_fetched_at, last_published_at, consecutive_fail_count, registered_by, type, categories",
                ") VALUES (",
                f"  {sql_str(row['id'])}, {sql_str(row['rss_url'])}, {sql_str(row['site_url'])}, {sql_str(row['title'])},",
                f"  {sql_str(row['description'])}, {sql_str(row['favicon_url'])}, {sql_str(row['language'])}, {sql_str(row['tags'])},",
                f"  {sql_str(row['status'])}, {sql_str(row['status_reason'])}, {sql_timestamp(row['ai_reviewed_at'])}, {sql_str(row['ai_review_source'])}, {sql_str(row['ai_review_reason'])},",
                f"  {sql_str(row['ai_review_confidence'])}, {sql_str(row['ai_review_decision'])}, {sql_str(row['feed_format'])}, {row['fetch_interval_minutes']},",
                f"  {sql_timestamp(row['last_fetched_at'])}, {sql_timestamp(row['last_published_at'])}, {row['consecutive_fail_count']}, {sql_str(row['registered_by'])}, {sql_str(row['type'])}, {sql_str(row['categories'])}",
                ")",
                "ON CONFLICT (rss_url) DO UPDATE SET",
                "  site_url = EXCLUDED.site_url,",
                "  title = EXCLUDED.title,",
                "  description = EXCLUDED.description,",
                "  favicon_url = EXCLUDED.favicon_url,",
                "  language = EXCLUDED.language,",
                "  tags = EXCLUDED.tags,",
                "  status = EXCLUDED.status,",
                "  status_reason = EXCLUDED.status_reason,",
                "  ai_reviewed_at = EXCLUDED.ai_reviewed_at,",
                "  ai_review_source = EXCLUDED.ai_review_source,",
                "  ai_review_reason = EXCLUDED.ai_review_reason,",
                "  ai_review_confidence = EXCLUDED.ai_review_confidence,",
                "  ai_review_decision = EXCLUDED.ai_review_decision,",
                "  feed_format = EXCLUDED.feed_format,",
                "  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,",
                "  last_fetched_at = EXCLUDED.last_fetched_at,",
                "  last_published_at = EXCLUDED.last_published_at,",
                "  consecutive_fail_count = EXCLUDED.consecutive_fail_count,",
                "  registered_by = EXCLUDED.registered_by,",
                "  type = EXCLUDED.type,",
                "  categories = EXCLUDED.categories;",
                "",
            ]
        )

    lines.append("COMMIT;")
    return "\n".join(lines)


async def main() -> None:
    sources = parse_opml_sources()
    semaphore = asyncio.Semaphore(MAX_CONCURRENCY)
    limits = httpx.Limits(max_keepalive_connections=20, max_connections=30)
    headers = {"User-Agent": USER_AGENT}
    async with httpx.AsyncClient(
        follow_redirects=True,
        timeout=REQUEST_TIMEOUT,
        limits=limits,
        headers=headers,
    ) as client:
        rows = await asyncio.gather(*(build_row(client, semaphore, source) for source in sources))

    failures = [row for row in rows if row.get("error")]
    successes = [row for row in rows if not row.get("error")]
    unique_by_rss: dict[str, dict[str, Any]] = {}
    for row in successes:
        unique_by_rss[row["rss_url"]] = row

    OUTPUT_PATH.write_text(render_sql(list(unique_by_rss.values()), failures), encoding="utf-8")
    print(f"Generated {OUTPUT_PATH} with {len(unique_by_rss)} rows and {len(failures)} failures.")


if __name__ == "__main__":
    asyncio.run(main())
