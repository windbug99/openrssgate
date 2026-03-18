from __future__ import annotations

from typer.testing import CliRunner

from openrssgate.main import app


runner = CliRunner()


def test_feed_command_prints_author_summary_and_content(monkeypatch) -> None:
    class FakeClient:
        def get_feed(self, feed_id: str) -> dict[str, object]:
            assert feed_id == "feed-1"
            return {
                "id": "feed-1",
                "source_id": "source-1",
                "title": "Feed title",
                "feed_url": "https://example.com/feed-1",
                "published_at": "2026-03-18T00:00:00Z",
                "author": "Feed Author",
                "summary": "Feed summary",
                "content": "<p>Feed content</p>",
                "source": {
                    "title": "Source title",
                    "site_url": "https://example.com",
                },
            }

    monkeypatch.setattr("openrssgate.commands.feeds.OpenRSSGateClient", FakeClient)

    result = runner.invoke(app, ["feed", "feed-1"])

    assert result.exit_code == 0
    assert "author: Feed Author" in result.stdout
    assert "summary: Feed summary" in result.stdout
    assert "content: <p>Feed content</p>" in result.stdout
