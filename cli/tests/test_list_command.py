from __future__ import annotations

import json

from typer.testing import CliRunner

from openrssgate.main import app


runner = CliRunner()


def test_list_command_all_fetches_remaining_pages(monkeypatch) -> None:
    calls: list[int] = []

    class FakeClient:
        def list_sources(self, **params: object) -> dict[str, object]:
            page = int(params["page"])
            calls.append(page)
            if page == 1:
                return {
                    "items": [{"id": "1", "title": "First", "language": "en", "type": "blog", "categories": ["tech"], "site_url": "https://a", "rss_url": "https://a/feed", "tags": [], "last_fetched_at": None}],
                    "page": 1,
                    "limit": 1,
                    "total": 2,
                }
            return {
                "items": [{"id": "2", "title": "Second", "language": "en", "type": "blog", "categories": ["tech"], "site_url": "https://b", "rss_url": "https://b/feed", "tags": [], "last_fetched_at": None}],
                "page": 2,
                "limit": 1,
                "total": 2,
            }

    monkeypatch.setattr("openrssgate.commands.list.OpenRSSGateClient", FakeClient)

    result = runner.invoke(app, ["list", "--all", "--limit", "1"])

    assert result.exit_code == 0
    assert calls == [1, 2]
    assert "First [en / blog / tech]" in result.stdout
    assert "Second [en / blog / tech]" in result.stdout


def test_list_command_all_json_merges_items(monkeypatch) -> None:
    class FakeClient:
        def list_sources(self, **params: object) -> dict[str, object]:
            page = int(params["page"])
            return {
                "items": [{"id": str(page), "title": f"Item {page}"}],
                "page": page,
                "limit": 1,
                "total": 2,
            }

    monkeypatch.setattr("openrssgate.commands.list.OpenRSSGateClient", FakeClient)

    result = runner.invoke(app, ["list", "--all", "--limit", "1", "--json"])

    assert result.exit_code == 0
    payload = json.loads(result.stdout)
    assert payload["total"] == 2
    assert [item["id"] for item in payload["items"]] == ["1", "2"]
