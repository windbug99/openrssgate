import asyncio

import feedparser

from app.services.rss import _extract_entry_author
from app.services.rss import _extract_metadata
from app.services.rss import fetch_feed_bundle


def test_extract_metadata_uses_feed_icon_when_available() -> None:
    parsed_feed = feedparser.FeedParserDict(
        feed=feedparser.FeedParserDict(
            title="Example Feed",
            link="https://example.com",
            description="desc",
            icon="/assets/icon.png",
        ),
        entries=[],
        version="rss20",
    )

    metadata = _extract_metadata("https://example.com/rss.xml", parsed_feed)

    assert metadata["favicon_url"] == "https://example.com/assets/icon.png"


def test_extract_metadata_falls_back_to_site_favicon() -> None:
    parsed_feed = feedparser.FeedParserDict(
        feed=feedparser.FeedParserDict(
            title="Example Feed",
            link="https://example.com/blog",
            description="desc",
        ),
        entries=[],
        version="rss20",
    )

    metadata = _extract_metadata("https://example.com/rss.xml", parsed_feed)

    assert metadata["favicon_url"] == "https://example.com/favicon.ico"


def test_extract_entry_author_prefers_author_then_creator() -> None:
    entry = feedparser.FeedParserDict(author="Author Name", creator="Creator Name")
    assert _extract_entry_author(entry) == "Author Name"

    creator_only = feedparser.FeedParserDict(creator="Creator Name")
    assert _extract_entry_author(creator_only) == "Creator Name"


def test_parse_feed_bundle_extracts_author_summary_and_content(monkeypatch) -> None:
    document = """\
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title>Example Feed</title>
    <link>https://example.com</link>
    <description>desc</description>
    <item>
      <guid>post-1</guid>
      <title>Post 1</title>
      <link>https://example.com/post-1</link>
      <description>Summary text</description>
      <dc:creator>Creator Name</dc:creator>
      <content:encoded><![CDATA[<p>Full content</p>]]></content:encoded>
      <pubDate>Tue, 17 Mar 2026 00:00:00 GMT</pubDate>
    </item>
  </channel>
</rss>
"""
    async def _fake_fetch_feed_text(_rss_url: str) -> str:
        return document

    monkeypatch.setattr("app.services.rss._fetch_feed_text", _fake_fetch_feed_text)

    bundle = asyncio.run(fetch_feed_bundle("https://example.com/rss.xml"))

    assert bundle["entries"][0]["author"] == "Creator Name"
    assert bundle["entries"][0]["summary"] == "Summary text"
    assert bundle["entries"][0]["content"] == "<p>Full content</p>"
