from fastapi.testclient import TestClient

from app.db.database import Base, SessionLocal, engine
from app.db.models import Feed, Source
from app.main import app


client = TestClient(app)


def setup_function() -> None:
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)


def test_health_endpoint() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_ops_summary_endpoint() -> None:
    response = client.get("/v1/ops/summary")
    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "ok"
    assert "sources" in payload
    assert "collector" in payload


def test_ops_sources_endpoint_lists_non_active_sources() -> None:
    with SessionLocal() as db:
        source = Source(
            rss_url="https://example.com/review.xml",
            site_url="https://example.com",
            title="Review Source",
            description="desc",
            status="hidden",
            status_reason="missing_description",
            registered_by="web",
        )
        db.add(source)
        db.commit()

    response = client.get("/v1/ops/sources?status=hidden")
    assert response.status_code == 200
    payload = response.json()
    assert payload["items"][0]["status"] == "hidden"
    assert payload["items"][0]["status_reason"] == "missing_description"


def test_mcp_tools_endpoint() -> None:
    response = client.get("/mcp/tools")
    assert response.status_code == 200
    payload = response.json()
    assert "tools" in payload
    assert any(tool["name"] == "search_sources" for tool in payload["tools"])


def test_openapi_contains_tag_metadata() -> None:
    response = client.get("/openapi.json")
    assert response.status_code == 200
    payload = response.json()
    assert payload["info"]["title"] == "RSS Gateway"
    assert any(tag["name"] == "sources" for tag in payload["tags"])


def test_mcp_call_search_sources_endpoint() -> None:
    with SessionLocal() as db:
        source = Source(
            rss_url="https://example.com/rss.xml",
            site_url="https://example.com",
            title="Example Source",
            description="desc",
            language="ko",
            category="blog",
            tags="AI,tech",
            status="active",
            registered_by="web",
        )
        db.add(source)
        db.commit()

    response = client.post(
        "/mcp/call",
        json={"name": "search_sources", "arguments": {"language": "ko", "limit": 10}},
    )
    assert response.status_code == 200
    payload = response.json()
    assert payload["tool"] == "search_sources"
    assert payload["result"]["total"] == 1
    assert payload["result"]["items"][0]["title"] == "Example Source"


def test_mcp_sse_endpoint_streams_manifest() -> None:
    with client.stream("GET", "/mcp/sse?once=true") as response:
        assert response.status_code == 200
        assert response.headers["content-type"].startswith("text/event-stream")
        body = "".join(response.iter_text())

    assert "event: server_ready" in body
    assert "event: tools" in body
    assert "search_sources" in body


def test_create_source_is_rate_limited(monkeypatch) -> None:
    from app.api import sources as sources_module

    class FakeLimiter:
        def enforce(self, **_: object) -> None:
            raise sources_module.RateLimitExceededError("Too many source registration attempts. Please try again later.")

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        raise AssertionError("fetch_feed_bundle should not run when rate limited")

    monkeypatch.setattr(sources_module, "registration_rate_limiter", FakeLimiter())
    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post(
        "/v1/sources",
        json={"rss_url": "https://example.com/rss.xml", "tags": []},
    )

    assert response.status_code == 429
    assert response.json()["error"]["code"] == "rate_limited"


def test_create_source_can_be_hidden_after_review(monkeypatch) -> None:
    from app.api import sources as sources_module

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/rss.xml",
                "site_url": "https://example.com",
                "title": "Example Source",
                "description": None,
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [
                {
                    "guid": "entry-1",
                    "title": "Entry 1",
                    "feed_url": "https://example.com/1",
                    "published_at": None,
                },
                {
                    "guid": "entry-2",
                    "title": "Entry 2",
                    "feed_url": "https://example.com/2",
                    "published_at": None,
                },
            ],
        }

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post(
        "/v1/sources",
        json={"rss_url": "https://example.com/rss.xml", "tags": []},
    )

    assert response.status_code == 201
    payload = response.json()
    assert payload["status"] == "hidden"
    assert payload["status_reason"] == "missing_description"


def test_create_source_can_be_rejected_after_review(monkeypatch) -> None:
    from app.api import sources as sources_module

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/rejected.xml",
                "site_url": "https://example.com",
                "title": "RSS",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [],
        }

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post(
        "/v1/sources",
        json={"rss_url": "https://example.com/rejected.xml", "tags": []},
    )

    assert response.status_code == 201
    payload = response.json()
    assert payload["status"] == "rejected"
    assert payload["status_reason"] == "generic_or_invalid_title"
