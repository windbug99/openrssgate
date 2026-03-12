from __future__ import annotations

import json

import httpx

from rssgate.client import RSSGatewayClient, format_json


def test_format_json_outputs_indented_unicode() -> None:
    payload = {"title": "테스트"}
    assert json.loads(format_json(payload)) == payload


def test_list_sources_builds_expected_request(monkeypatch) -> None:
    captured: dict[str, object] = {}

    def fake_get(url: str, params: dict[str, object] | None = None, timeout: float | None = None) -> httpx.Response:
        captured["url"] = url
        captured["params"] = params
        request = httpx.Request("GET", url, params=params)
        return httpx.Response(200, json={"items": [], "page": 1, "limit": 20, "total": 0}, request=request)

    monkeypatch.setattr(httpx, "get", fake_get)

    client = RSSGatewayClient("http://127.0.0.1:8000/v1")
    client.list_sources(language="ko", limit=10)

    assert captured["url"] == "http://127.0.0.1:8000/v1/sources"
    assert captured["params"] == {"language": "ko", "limit": 10}
