from __future__ import annotations

import json

import httpx

from openrssgate.client import OpenRSSGateClient, format_json
from openrssgate.config import DEFAULT_API_BASE_URL, get_api_base_url


def test_format_json_outputs_indented_unicode() -> None:
    payload = {"title": "테스트"}
    assert json.loads(format_json(payload)) == payload


def test_default_api_base_url_points_to_public_service(monkeypatch) -> None:
    monkeypatch.delenv("OPENRSSGATE_API_BASE_URL", raising=False)
    assert get_api_base_url() == DEFAULT_API_BASE_URL


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


def test_connect_error_includes_base_url_guidance(monkeypatch) -> None:
    def fake_request(
        method: str,
        url: str,
        params: dict[str, object] | None = None,
        json: object | None = None,
        timeout: float | None = None,
    ) -> httpx.Response:
        request = httpx.Request(method, url, params=params)
        raise httpx.ConnectError("[Errno 61] Connection refused", request=request)

    monkeypatch.setattr(httpx, "request", fake_request)

    client = OpenRSSGateClient("http://127.0.0.1:8000/v1")

    try:
        client.get_stats()
    except Exception as exc:
        message = str(exc)
    else:
        raise AssertionError("Expected connection error")

    assert "Failed to connect to OpenRSSGate API." in message
    assert "Base URL: http://127.0.0.1:8000/v1" in message
    assert "OPENRSSGATE_API_BASE_URL" in message
