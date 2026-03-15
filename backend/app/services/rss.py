from __future__ import annotations

import hashlib
import ipaddress
from datetime import UTC, datetime
from urllib.parse import urljoin, urlparse

import feedparser
import httpx

from app.core.config import get_settings


PRIVATE_HOSTS = {"localhost"}
PRIVATE_NETWORKS = (
    ipaddress.ip_network("127.0.0.0/8"),
    ipaddress.ip_network("10.0.0.0/8"),
    ipaddress.ip_network("172.16.0.0/12"),
    ipaddress.ip_network("192.168.0.0/16"),
)


class InvalidRSSUrlError(ValueError):
    pass


def _validate_public_url(rss_url: str) -> None:
    parsed = urlparse(rss_url)

    if parsed.scheme not in {"http", "https"}:
        raise InvalidRSSUrlError("Only http/https URLs are allowed.")

    hostname = parsed.hostname
    if not hostname:
        raise InvalidRSSUrlError("A valid hostname is required.")
    if hostname in PRIVATE_HOSTS:
        raise InvalidRSSUrlError("Private or local addresses are not allowed.")

    try:
        ip = ipaddress.ip_address(hostname)
        if any(ip in network for network in PRIVATE_NETWORKS):
            raise InvalidRSSUrlError("Private or local addresses are not allowed.")
    except ValueError:
        pass


async def _fetch_feed_text(rss_url: str) -> str:
    settings = get_settings()
    _validate_public_url(rss_url)

    headers = {"User-Agent": settings.user_agent}

    try:
        async with httpx.AsyncClient(
            follow_redirects=True,
            timeout=settings.request_timeout_seconds,
            max_redirects=settings.max_redirects,
            headers=headers,
        ) as client:
            response = await client.get(rss_url)
            response.raise_for_status()
    except httpx.TimeoutException as exc:
        raise InvalidRSSUrlError("The RSS URL timed out while fetching.") from exc
    except httpx.HTTPStatusError as exc:
        status_code = exc.response.status_code
        raise InvalidRSSUrlError(f"The RSS URL returned HTTP {status_code}.") from exc
    except httpx.ConnectError as exc:
        raise InvalidRSSUrlError("The RSS URL could not be reached.") from exc
    except httpx.HTTPError as exc:
        raise InvalidRSSUrlError("The RSS URL could not be fetched.") from exc

    return response.text


def _normalize_datetime(struct_time: object | None) -> datetime | None:
    if not struct_time:
        return None
    try:
        return datetime(
            year=struct_time.tm_year,
            month=struct_time.tm_mon,
            day=struct_time.tm_mday,
            hour=struct_time.tm_hour,
            minute=struct_time.tm_min,
            second=struct_time.tm_sec,
            tzinfo=UTC,
        )
    except AttributeError:
        return None


def _build_entry_identity(entry: feedparser.FeedParserDict) -> str | None:
    guid = entry.get("id") or entry.get("guid")
    if guid:
        return str(guid)

    link = entry.get("link")
    if link:
        return str(link)

    title = entry.get("title")
    published = _normalize_datetime(entry.get("published_parsed") or entry.get("updated_parsed"))
    if title and published:
        payload = f"{title}|{published.isoformat()}"
        return hashlib.sha256(payload.encode("utf-8")).hexdigest()
    return None


def _parse_feed_document(document: str) -> feedparser.FeedParserDict:
    parsed_feed = feedparser.parse(document)
    if parsed_feed.bozo and not parsed_feed.entries:
        raise InvalidRSSUrlError("The provided URL is not a valid RSS or Atom feed.")
    return parsed_feed


def _normalize_http_url(base_url: str, candidate: object | None) -> str | None:
    if not candidate:
        return None

    value = str(candidate).strip()
    if not value:
        return None

    absolute = urljoin(base_url, value)
    parsed = urlparse(absolute)
    if parsed.scheme not in {"http", "https"} or not parsed.netloc:
        return None
    return absolute


def _extract_favicon_url(feed: feedparser.FeedParserDict, site_url: str) -> str | None:
    candidates: list[object | None] = [
        feed.get("icon"),
        feed.get("logo"),
    ]

    image = feed.get("image")
    if isinstance(image, dict):
        candidates.extend([image.get("href"), image.get("url")])

    for link in feed.get("links", []):
        if not isinstance(link, dict):
            continue
        rel = str(link.get("rel") or "").lower()
        if rel in {"icon", "shortcut icon", "apple-touch-icon"}:
            candidates.append(link.get("href"))

    for candidate in candidates:
        normalized = _normalize_http_url(site_url, candidate)
        if normalized:
            return normalized

    return _normalize_http_url(site_url, "/favicon.ico")


def _extract_metadata(rss_url: str, parsed_feed: feedparser.FeedParserDict) -> dict[str, str | None]:
    feed = parsed_feed.feed
    title = feed.get("title")
    link = feed.get("link")
    description = feed.get("subtitle") or feed.get("description")

    if not title or not link:
        raise InvalidRSSUrlError("The feed metadata is incomplete.")

    favicon_url = _extract_favicon_url(feed, str(link))

    return {
        "rss_url": rss_url,
        "site_url": link,
        "title": title,
        "description": description,
        "language": feed.get("language"),
        "type": feed.get("type"),
        "categories": ",".join(
            str(term).strip().lower()
            for term in (
                entry.get("term")
                for entry in feed.get("tags", [])
                if isinstance(entry, dict) and entry.get("term")
            )
            if str(term).strip()
        ),
        "favicon_url": favicon_url,
        "feed_format": parsed_feed.version or "unknown",
    }


async def fetch_feed_metadata(rss_url: str) -> dict[str, str | None]:
    document = await _fetch_feed_text(rss_url)
    parsed_feed = _parse_feed_document(document)
    return _extract_metadata(rss_url, parsed_feed)


async def fetch_feed_bundle(rss_url: str) -> dict[str, object]:
    document = await _fetch_feed_text(rss_url)
    parsed_feed = _parse_feed_document(document)

    metadata = _extract_metadata(rss_url, parsed_feed)
    entries: list[dict[str, object]] = []

    for entry in parsed_feed.entries:
        identity = _build_entry_identity(entry)
        link = entry.get("link")
        title = entry.get("title")
        if not identity or not link or not title:
            continue

        published_at = _normalize_datetime(entry.get("published_parsed") or entry.get("updated_parsed"))
        summary = str(entry.get("summary") or entry.get("subtitle") or "").strip() or None
        content_text = None
        content = entry.get("content")
        if isinstance(content, list):
            for item in content:
                if isinstance(item, dict):
                    candidate = str(item.get("value") or "").strip()
                    if candidate:
                        content_text = candidate
                        break
        entries.append(
            {
                "guid": identity,
                "title": str(title),
                "feed_url": str(link),
                "published_at": published_at,
                "summary": summary,
                "content_text": content_text,
            }
        )

    return {
        "metadata": metadata,
        "entries": entries,
    }
