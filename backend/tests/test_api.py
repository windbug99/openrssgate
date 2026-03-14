from fastapi.testclient import TestClient
from datetime import UTC, datetime, timedelta

from app.services.cache import response_cache
from app.services.rate_limit import read_rate_limiter, registration_rate_limiter
from app.db.database import Base, SessionLocal, engine
from app.db.models import Feed, Source
from app.main import app


client = TestClient(app)


def setup_function() -> None:
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)
    read_rate_limiter.reset()
    registration_rate_limiter.reset()
    response_cache.reset()


def test_health_endpoint() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_ops_summary_endpoint() -> None:
    response = client.get("/v1/ops/summary")
    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] in {"ok", "critical"}
    assert "sources" in payload
    assert "collector" in payload


def test_ops_alerts_endpoint_returns_warning_when_threshold_exceeded(monkeypatch) -> None:
    from app.api import ops as ops_module

    with SessionLocal() as db:
        for index in range(3):
            db.add(
                Source(
                    rss_url=f"https://fail-{index}.example.com/rss.xml",
                    site_url=f"https://fail-{index}.example.com",
                    title=f"Fail {index}",
                    description="desc",
                    status="active",
                    registered_by="web",
                    consecutive_fail_count=1,
                    last_fetched_at=datetime.now(UTC) - timedelta(hours=4),
                )
            )
        db.commit()

    monkeypatch.setattr(
        ops_module,
        "get_settings",
        lambda: type(
            "Settings",
            (),
            {
                "collector_poll_interval_seconds": 300,
                "collector_stale_after_minutes": 180,
                "ops_alert_stale_sources_threshold": 2,
                "ops_alert_failing_sources_threshold": 2,
                "ops_alert_collector_lag_minutes": 500,
                "response_cache_enabled": False,
                "response_cache_ttl_seconds": 60,
            },
        )(),
    )

    response = client.get("/v1/ops/alerts")
    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "warning"
    codes = {alert["code"] for alert in payload["alerts"]}
    assert "stale_sources_high" in codes
    assert "failing_sources_high" in codes


def test_ops_sources_endpoint_lists_non_active_sources() -> None:
    with SessionLocal() as db:
        source = Source(
            rss_url="https://ops-hidden.example.com/review.xml",
            site_url="https://ops-hidden.example.com",
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


def test_ops_source_status_update_requires_key() -> None:
    with SessionLocal() as db:
        source = Source(
            rss_url="https://example.com/moderate.xml",
            site_url="https://example.com",
            title="Moderate Source",
            description="desc",
            status="hidden",
            registered_by="web",
        )
        db.add(source)
        db.commit()
        source_id = source.id

    response = client.post(
        f"/v1/ops/sources/{source_id}/status",
        json={"status": "active", "reason": "manual_restore"},
    )
    assert response.status_code == 503
    assert response.json()["error"]["code"] == "ops_key_not_configured"


def test_ops_source_status_update_succeeds_with_key(monkeypatch) -> None:
    from app.services import api_keys as api_keys_module

    monkeypatch.setattr(
        api_keys_module,
        "get_settings",
        lambda: type("Settings", (), {"ops_api_key": "secret", "service_api_keys": []})(),
    )

    with SessionLocal() as db:
        source = Source(
            rss_url="https://example.com/moderate-2.xml",
            site_url="https://example.com",
            title="Moderate Source 2",
            description="desc",
            status="hidden",
            status_reason="missing_description",
            registered_by="web",
        )
        db.add(source)
        db.commit()
        source_id = source.id

    response = client.post(
        f"/v1/ops/sources/{source_id}/status",
        json={"status": "active", "reason": "manual_restore"},
        headers={"X-Ops-Key": "secret"},
    )
    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "active"
    assert payload["status_reason"] == "manual_restore"


def test_ops_source_status_update_accepts_x_api_key(monkeypatch) -> None:
    from app.services import api_keys as api_keys_module

    monkeypatch.setattr(
        api_keys_module,
        "get_settings",
        lambda: type("Settings", (), {"ops_api_key": None, "service_api_keys": ["service-secret"]})(),
    )

    with SessionLocal() as db:
        source = Source(
            rss_url="https://example.com/moderate-3.xml",
            site_url="https://example.com",
            title="Moderate Source 3",
            description="desc",
            status="hidden",
            status_reason="missing_description",
            registered_by="web",
        )
        db.add(source)
        db.commit()
        source_id = source.id

    response = client.post(
        f"/v1/ops/sources/{source_id}/status",
        json={"status": "active", "reason": "manual_restore"},
        headers={"X-API-Key": "service-secret"},
    )
    assert response.status_code == 200
    assert response.json()["status"] == "active"


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


def test_stats_endpoint_counts_only_active_feeds() -> None:
    now = datetime.now(UTC)
    with SessionLocal() as db:
        active_source = Source(
            rss_url="https://active.example.com/rss.xml",
            site_url="https://active.example.com",
            title="Active Source",
            description="desc",
            status="active",
            registered_by="web",
        )
        hidden_source = Source(
            rss_url="https://hidden.example.com/rss.xml",
            site_url="https://hidden.example.com",
            title="Hidden Source",
            description="desc",
            status="hidden",
            registered_by="web",
        )
        db.add_all([active_source, hidden_source])
        db.commit()

        db.add_all(
            [
                Feed(
                    source_id=active_source.id,
                    guid="active-1",
                    title="Recent active entry",
                    feed_url="https://active.example.com/1",
                    published_at=now,
                ),
                Feed(
                    source_id=hidden_source.id,
                    guid="hidden-1",
                    title="Recent hidden entry",
                    feed_url="https://hidden.example.com/1",
                    published_at=now,
                ),
            ]
        )
        db.commit()

    response = client.get("/v1/stats")
    assert response.status_code == 200
    payload = response.json()
    assert payload["total_sources"] == 2
    assert payload["active_sources"] == 1
    assert payload["total_feeds"] == 1
    assert payload["feeds_last_24h"] == 1


def test_mcp_call_search_sources_endpoint() -> None:
    with SessionLocal() as db:
        source = Source(
            rss_url="https://example.com/rss.xml",
            site_url="https://example.com",
            title="Example Source",
            description="desc",
            language="ko",
            source_type="blog",
            categories="tech,media",
            tags="ai,analysis",
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
    assert payload["result"]["items"][0]["type"] == "blog"
    assert payload["result"]["items"][0]["categories"] == ["tech", "media"]


def test_validate_source_endpoint_returns_metadata(monkeypatch) -> None:
    from app.api import sources as sources_module

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/feed.xml",
                "site_url": "https://example.com",
                "title": "OpenAI Engineering Feed",
                "description": "Deep analysis and tutorials about backend systems.",
                "favicon_url": "https://example.com/favicon.ico",
                "feed_format": "rss2",
                "language": "en",
                "type": "blog",
                "categories": "tech,media",
            },
            "entries": [],
        }

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources/validate", json={"rss_url": "https://example.com/feed.xml", "tags": []})
    assert response.status_code == 200
    payload = response.json()
    assert payload["valid"] is True
    assert payload["site_url"] == "https://example.com"
    assert payload["language"] == "en"
    assert payload["type"] == "blog"
    assert payload["categories"] == ["tech", "media"]
    assert payload["tags"] == ["ai", "backend", "analysis"]


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


def test_public_source_status_endpoint_requires_active_source() -> None:
    stale_fetched_at = datetime.now(UTC) - timedelta(hours=3)
    with SessionLocal() as db:
        active_source = Source(
            rss_url="https://status.example.com/rss.xml",
            site_url="https://status.example.com",
            title="Status Source",
            description="desc",
            status="active",
            registered_by="web",
            last_fetched_at=stale_fetched_at,
            fetch_interval_minutes=30,
            consecutive_fail_count=2,
        )
        hidden_source = Source(
            rss_url="https://status-hidden.example.com/rss.xml",
            site_url="https://status-hidden.example.com",
            title="Hidden Status Source",
            description="desc",
            status="hidden",
            registered_by="web",
        )
        db.add_all([active_source, hidden_source])
        db.commit()
        active_source_id = active_source.id
        hidden_source_id = hidden_source.id

    response = client.get(f"/v1/sources/{active_source_id}/status")
    assert response.status_code == 200
    payload = response.json()
    assert payload["source_id"] == active_source_id
    assert payload["consecutive_fail_count"] == 2
    assert payload["fetch_interval_minutes"] == 30
    assert payload["is_stale"] is True

    hidden_response = client.get(f"/v1/sources/{hidden_source_id}/status")
    assert hidden_response.status_code == 404
    assert hidden_response.json()["error"]["code"] == "source_not_found"


def test_feeds_endpoint_supports_q_and_source_metadata_filters() -> None:
    now = datetime.now(UTC)
    with SessionLocal() as db:
        ai_source = Source(
            rss_url="https://ai.example.com/rss.xml",
            site_url="https://ai.example.com",
            title="AI Source",
            description="desc",
            language="en",
            source_type="blog",
            categories="tech",
            tags="ai,analysis",
            status="active",
            registered_by="web",
        )
        other_source = Source(
            rss_url="https://other.example.com/rss.xml",
            site_url="https://other.example.com",
            title="Other Source",
            description="desc",
            language="en",
            source_type="news",
            categories="business",
            tags="review",
            status="active",
            registered_by="web",
        )
        db.add_all([ai_source, other_source])
        db.commit()
        db.add_all(
            [
                Feed(
                    source_id=ai_source.id,
                    guid="feed-1",
                    title="OpenAI launches new model",
                    feed_url="https://ai.example.com/1",
                    published_at=now,
                ),
                Feed(
                    source_id=other_source.id,
                    guid="feed-2",
                    title="Market closes higher",
                    feed_url="https://other.example.com/1",
                    published_at=now,
                ),
            ]
        )
        db.commit()

    response = client.get("/v1/feeds?q=OpenAI&tag=ai&category=tech&type=blog")
    assert response.status_code == 200
    payload = response.json()
    assert payload["total"] == 1
    assert payload["items"][0]["title"] == "OpenAI launches new model"


def test_top_level_feed_detail_endpoint_returns_source_metadata() -> None:
    now = datetime.now(UTC)
    with SessionLocal() as db:
        source = Source(
            rss_url="https://detail.example.com/rss.xml",
            site_url="https://detail.example.com",
            title="Detail Source",
            description="desc",
            language="ko",
            source_type="blog",
            categories="tech",
            tags="ai",
            status="active",
            registered_by="web",
        )
        db.add(source)
        db.commit()
        feed = Feed(
            source_id=source.id,
            guid="detail-1",
            title="Detailed feed",
            feed_url="https://detail.example.com/1",
            published_at=now,
        )
        db.add(feed)
        db.commit()
        feed_id = feed.id
        source_id = source.id

    response = client.get(f"/v1/feeds/{feed_id}")
    assert response.status_code == 200
    payload = response.json()
    assert payload["id"] == feed_id
    assert payload["source"]["id"] == source_id
    assert payload["source"]["title"] == "Detail Source"

    nested_response = client.get(f"/v1/sources/{source_id}/feeds/{feed_id}")
    assert nested_response.status_code == 200
    assert nested_response.json()["source"]["id"] == source_id


def test_public_read_rate_limit_returns_429() -> None:
    from app import main as main_module

    original_enabled = main_module.settings.public_read_rate_limit_enabled
    original_window = main_module.settings.public_read_window_seconds
    original_max = main_module.settings.public_read_max_requests

    main_module.settings.public_read_rate_limit_enabled = True
    main_module.settings.public_read_window_seconds = 60
    main_module.settings.public_read_max_requests = 1

    try:
        first = client.get("/v1/stats")
        second = client.get("/v1/stats")
    finally:
        main_module.settings.public_read_rate_limit_enabled = original_enabled
        main_module.settings.public_read_window_seconds = original_window
        main_module.settings.public_read_max_requests = original_max

    assert first.status_code == 200
    assert second.status_code == 429
    assert second.json()["error"]["code"] == "rate_limited"


def test_create_source_can_be_hidden_after_review(monkeypatch) -> None:
    from app.api import sources as sources_module

    class FakeLimiter:
        def enforce(self, **_: object) -> None:
            return None

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

    monkeypatch.setattr(sources_module, "registration_rate_limiter", FakeLimiter())
    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post(
        "/v1/sources",
        json={"rss_url": "https://example.com/rss.xml", "tags": []},
    )

    assert response.status_code == 201
    payload = response.json()
    assert payload["status"] == "hidden"
    assert payload["status_reason"] == "missing_published_dates"


def test_create_source_can_be_rejected_after_review(monkeypatch) -> None:
    from app.api import sources as sources_module

    class FakeLimiter:
        def enforce(self, **_: object) -> None:
            return None

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

    monkeypatch.setattr(sources_module, "registration_rate_limiter", FakeLimiter())
    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post(
        "/v1/sources",
        json={"rss_url": "https://example.com/rejected.xml", "tags": []},
    )

    assert response.status_code == 201
    payload = response.json()
    assert payload["status"] == "rejected"
    assert payload["status_reason"] == "generic_or_invalid_title"


def test_create_source_can_be_rejected_for_duplicate_site_url(monkeypatch) -> None:
    from app.api import sources as sources_module

    class FakeLimiter:
        def enforce(self, **_: object) -> None:
            return None

    with SessionLocal() as db:
        existing = Source(
            rss_url="https://example.com/original.xml",
            site_url="https://example.com",
            title="Existing Source",
            description="desc",
            status="active",
            registered_by="web",
        )
        db.add(existing)
        db.commit()

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/duplicate.xml",
                "site_url": "https://example.com",
                "title": "Duplicate Source",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [
                {"guid": "1", "title": "Entry 1", "feed_url": "https://example.com/1", "published_at": datetime.now(UTC)},
                {"guid": "2", "title": "Entry 2", "feed_url": "https://example.com/2", "published_at": datetime.now(UTC)},
            ],
        }

    monkeypatch.setattr(sources_module, "registration_rate_limiter", FakeLimiter())
    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources", json={"rss_url": "https://example.com/duplicate.xml", "tags": []})

    assert response.status_code == 201
    payload = response.json()
    assert payload["status"] == "rejected"
    assert payload["status_reason"] == "duplicate_site_url"


def test_create_source_can_be_hidden_for_repetitive_titles(monkeypatch) -> None:
    from app.api import sources as sources_module

    class FakeLimiter:
        def enforce(self, **_: object) -> None:
            return None

    now = datetime.now(UTC)

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/repetitive.xml",
                "site_url": "https://repetitive.example.com",
                "title": "Repetitive Source",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [
                {"guid": "1", "title": "Same Title", "feed_url": "https://example.com/1", "published_at": now},
                {"guid": "2", "title": "Same Title", "feed_url": "https://example.com/2", "published_at": now},
                {"guid": "3", "title": "Same Title", "feed_url": "https://example.com/3", "published_at": now},
                {"guid": "4", "title": "Same Title", "feed_url": "https://example.com/4", "published_at": now},
                {"guid": "5", "title": "Another", "feed_url": "https://example.com/5", "published_at": now},
            ],
        }

    monkeypatch.setattr(sources_module, "registration_rate_limiter", FakeLimiter())
    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources", json={"rss_url": "https://example.com/repetitive.xml", "tags": []})

    assert response.status_code == 201
    payload = response.json()
    assert payload["status"] == "hidden"
    assert payload["status_reason"] == "repetitive_entry_titles"


def test_create_source_can_be_hidden_for_missing_published_dates(monkeypatch) -> None:
    from app.api import sources as sources_module

    class FakeLimiter:
        def enforce(self, **_: object) -> None:
            return None

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/no-dates.xml",
                "site_url": "https://nodates.example.com",
                "title": "No Dates Source",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [
                {"guid": "1", "title": "Entry 1", "feed_url": "https://example.com/1", "published_at": None},
                {"guid": "2", "title": "Entry 2", "feed_url": "https://example.com/2", "published_at": None},
                {"guid": "3", "title": "Entry 3", "feed_url": "https://example.com/3", "published_at": None},
                {"guid": "4", "title": "Entry 4", "feed_url": "https://example.com/4", "published_at": datetime.now(UTC)},
            ],
        }

    monkeypatch.setattr(sources_module, "registration_rate_limiter", FakeLimiter())
    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources", json={"rss_url": "https://example.com/no-dates.xml", "tags": []})

    assert response.status_code == 201
    payload = response.json()
    assert payload["status"] == "hidden"
    assert payload["status_reason"] == "missing_published_dates"


def test_create_source_can_be_hidden_for_stale_feed(monkeypatch) -> None:
    from app.api import sources as sources_module

    class FakeLimiter:
        def enforce(self, **_: object) -> None:
            return None

    stale_time = datetime.now(UTC) - timedelta(days=60)

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/stale.xml",
                "site_url": "https://stale.example.com",
                "title": "Stale Source",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [
                {"guid": "1", "title": "Entry 1", "feed_url": "https://example.com/1", "published_at": stale_time},
                {"guid": "2", "title": "Entry 2", "feed_url": "https://example.com/2", "published_at": stale_time},
            ],
        }

    monkeypatch.setattr(sources_module, "registration_rate_limiter", FakeLimiter())
    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources", json={"rss_url": "https://example.com/stale.xml", "tags": []})

    assert response.status_code == 201
    payload = response.json()
    assert payload["status"] == "hidden"
    assert payload["status_reason"] == "stale_feed"
