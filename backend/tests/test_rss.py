import feedparser

from app.services.rss import _extract_metadata


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
