from __future__ import annotations

import json

import httpx

from openrssgate.client import OpenRSSGateClient, format_json


def test_format_json_outputs_indented_unicode() -> None:
    payload = {"title": "테스트"}
    assert json.loads(format_json(payload)) == payload


def test_list_sources_builds_expected_request(monkeypatch) -> None:
    captured: dict[str, object] = {}

    def fake_request(
        method: str,
        url: str,
        params: dict[str, object] | None = None,
        json: object | None = None,
        timeout: float | None = None,
    ) -> httpx.Response:
        captured["method"] = method
        captured["url"] = url
        captured["params"] = params
        captured["json"] = json
        request = httpx.Request("GET", url, params=params)
        return httpx.Response(200, json={"items": [], "page": 1, "limit": 20, "total": 0}, request=request)

    monkeypatch.setattr(httpx, "request", fake_request)

    client = OpenRSSGateClient("http://127.0.0.1:8000/v1")
    client.list_sources(language="ko", limit=10)

    assert captured["method"] == "GET"
    assert captured["url"] == "http://127.0.0.1:8000/v1/sources"
    assert captured["params"] == {"language": "ko", "limit": 10}


def test_get_stats_builds_expected_request(monkeypatch) -> None:
    captured: dict[str, object] = {}

    def fake_request(
        method: str,
        url: str,
        params: dict[str, object] | None = None,
        json: object | None = None,
        timeout: float | None = None,
    ) -> httpx.Response:
        captured["method"] = method
        captured["url"] = url
        captured["params"] = params
        captured["json"] = json
        request = httpx.Request(method, url, params=params)
        return httpx.Response(200, json={"total_sources": 1, "active_sources": 1, "total_feeds": 1, "feeds_last_24h": 1}, request=request)

    monkeypatch.setattr(httpx, "request", fake_request)

    client = OpenRSSGateClient("http://127.0.0.1:8000/v1")
    client.get_stats()

    assert captured["method"] == "GET"
    assert captured["url"] == "http://127.0.0.1:8000/v1/stats"
    assert captured["params"] is None


def test_validate_source_builds_expected_request(monkeypatch) -> None:
    captured: dict[str, object] = {}

    def fake_request(
        method: str,
        url: str,
        params: dict[str, object] | None = None,
        json: object | None = None,
        timeout: float | None = None,
    ) -> httpx.Response:
        captured["method"] = method
        captured["url"] = url
        captured["params"] = params
        captured["json"] = json
        request = httpx.Request(method, url, params=params)
        return httpx.Response(200, json={"valid": True, "rss_url": "https://example.com/rss.xml"}, request=request)

    monkeypatch.setattr(httpx, "request", fake_request)

    client = OpenRSSGateClient("http://127.0.0.1:8000/v1")
    client.validate_source("https://example.com/rss.xml", language="ko", type="blog", categories=[], tags=[])

    assert captured["method"] == "POST"
    assert captured["url"] == "http://127.0.0.1:8000/v1/sources/validate"
    assert captured["json"] == {
        "rss_url": "https://example.com/rss.xml",
        "language": "ko",
        "type": "blog",
        "categories": [],
        "tags": [],
    }


def test_get_feed_builds_expected_request(monkeypatch) -> None:
    captured: dict[str, object] = {}

    def fake_request(
        method: str,
        url: str,
        params: dict[str, object] | None = None,
        json: object | None = None,
        timeout: float | None = None,
    ) -> httpx.Response:
        captured["method"] = method
        captured["url"] = url
        request = httpx.Request(method, url, params=params)
        return httpx.Response(200, json={"id": "feed-1"}, request=request)

    monkeypatch.setattr(httpx, "request", fake_request)

    client = OpenRSSGateClient("http://127.0.0.1:8000/v1")
    client.get_feed("feed-1")

    assert captured["method"] == "GET"
    assert captured["url"] == "http://127.0.0.1:8000/v1/feeds/feed-1"
