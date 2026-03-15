from fastapi.testclient import TestClient
from datetime import UTC, datetime, timedelta
from sqlalchemy import select

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


def test_admin_auth_login_setup_and_review_flow(monkeypatch) -> None:
    from app.services import admin_auth as admin_auth_module

    monkeypatch.setattr(
        admin_auth_module,
        "get_settings",
        lambda: type(
            "Settings",
            (),
            {
                "admin_bootstrap_email": "admin@example.com",
                "admin_bootstrap_password": "super-secret-123",
                "admin_session_ttl_hours": 24,
            },
        )(),
    )

    login_response = client.post(
        "/v1/admin/auth/login",
        json={"email": "admin@example.com", "password": "super-secret-123"},
    )
    assert login_response.status_code == 200
    login_payload = login_response.json()
    assert login_payload["requires_totp_setup"] is True
    assert "openrssgate_admin_session=" in login_response.headers["set-cookie"]
    assert "openrssgate_admin_state=pending" in login_response.headers.get("set-cookie", "")

    setup_response = client.post("/v1/admin/auth/totp/setup")
    assert setup_response.status_code == 200
    secret = setup_response.json()["secret"]
    otp_code = admin_auth_module._totp_at(secret, int(datetime.now(UTC).timestamp()))

    verify_response = client.post(
        "/v1/admin/auth/totp/verify",
        json={"code": otp_code},
    )
    assert verify_response.status_code == 200
    assert "openrssgate_admin_state=verified" in verify_response.headers.get("set-cookie", "")
    recovery_codes = verify_response.json()["recovery_codes"]
    assert verify_response.json()["user"]["totp_enabled"] is True
    assert len(recovery_codes) == 8

    with SessionLocal() as db:
        source = Source(
            rss_url="https://review.example.com/feed.xml",
            site_url="https://review.example.com",
            title="Review Target",
            description="desc",
            status="hidden",
            registered_by="web",
        )
        db.add(source)
        db.commit()
        source_id = source.id

    list_response = client.get("/v1/admin/sources?status=hidden")
    assert list_response.status_code == 200
    assert list_response.json()["items"][0]["id"] == source_id

    update_response = client.post(
        f"/v1/admin/sources/{source_id}/status",
        json={"status": "active", "reason": "manual_restore"},
    )
    assert update_response.status_code == 200
    assert update_response.json()["status"] == "active"

    audit_response = client.get(f"/v1/admin/sources/{source_id}/audit-logs")
    assert audit_response.status_code == 200
    assert audit_response.json()["items"][0]["action"] == "source.status_updated"

    delete_response = client.delete(
        f"/v1/admin/sources/{source_id}?reason=cleanup",
    )
    assert delete_response.status_code == 200
    assert delete_response.json()["deleted"]["id"] == source_id

    recent_audit_response = client.get("/v1/admin/audit-logs")
    assert recent_audit_response.status_code == 200
    assert recent_audit_response.json()["items"][0]["action"] in {"source.deleted", "source.status_updated"}

    client.post("/v1/admin/auth/logout")
    recovery_login_response = client.post(
        "/v1/admin/auth/login",
        json={"email": "admin@example.com", "password": "super-secret-123", "recovery_code": recovery_codes[0]},
    )
    assert recovery_login_response.status_code == 200
    assert recovery_login_response.json()["requires_totp_setup"] is False


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
            "entries": [
                {
                    "guid": "1",
                    "title": "Backend reliability patterns for AI systems",
                    "feed_url": "https://example.com/1",
                    "published_at": datetime.now(UTC),
                },
                {
                    "guid": "2",
                    "title": "Operating queues and schedulers at scale",
                    "feed_url": "https://example.com/2",
                    "published_at": datetime.now(UTC),
                },
            ],
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
    assert payload["status"] == "active"
    assert payload["status_reason"] == "auto_approved"
    assert payload["review_source"] == "rule"
    assert payload["message"] == "등록 가능한 RSS로 확인되었습니다."


def test_validate_source_endpoint_uses_ai_review_for_stale_feed(monkeypatch) -> None:
    from app.api import sources as sources_module
    from app.services.ai_review import SourceReviewResult
    from app.services.review import ReviewDecision

    stale_time = datetime.now(UTC) - timedelta(days=500)

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/stale.xml",
                "site_url": "https://example.com",
                "title": "Low Frequency Journal",
                "description": "An annual research publication.",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [
                {"guid": "1", "title": "2024 annual letter", "feed_url": "https://example.com/1", "published_at": stale_time},
                {"guid": "2", "title": "2023 annual letter", "feed_url": "https://example.com/2", "published_at": stale_time},
            ],
        }

    async def fake_review_source_bundle_with_ai(**_: object) -> SourceReviewResult:
        return SourceReviewResult(
            initial_decision=ReviewDecision(status="hidden", reason="stale_feed"),
            final_decision=ReviewDecision(status="active", reason="ai_override"),
            review_source="ai",
            ai_review_reason="Legitimate low-frequency publication with coherent entries.",
            ai_review_confidence="high",
        )

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)
    monkeypatch.setattr(sources_module, "review_source_bundle_with_ai", fake_review_source_bundle_with_ai)

    response = client.post("/v1/sources/validate", json={"rss_url": "https://example.com/stale.xml", "tags": []})

    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "active"
    assert payload["status_reason"] == "ai_override"
    assert payload["review_source"] == "ai"
    assert payload["ai_review_confidence"] == "high"
    assert payload["ai_review_reason"] == "Legitimate low-frequency publication with coherent entries."
    assert payload["message"] == "초기 자동 검토에서는 보류 대상이었지만, AI 재검토 결과 등록 가능한 정상 소스로 판단되었습니다."


def test_validate_source_endpoint_reports_rule_fallback_when_ai_review_fails(monkeypatch) -> None:
    from app.api import sources as sources_module
    from app.services.ai_review import SourceReviewResult
    from app.services.review import ReviewDecision

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/few.xml",
                "site_url": "https://example.com",
                "title": "Sparse Source",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [
                {"guid": "1", "title": "Only entry", "feed_url": "https://example.com/1", "published_at": datetime.now(UTC)},
            ],
        }

    async def fake_review_source_bundle_with_ai(**_: object) -> SourceReviewResult:
        return SourceReviewResult(
            initial_decision=ReviewDecision(status="hidden", reason="too_few_entries"),
            final_decision=ReviewDecision(status="hidden", reason="too_few_entries"),
            review_source="rule_fallback",
        )

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)
    monkeypatch.setattr(sources_module, "review_source_bundle_with_ai", fake_review_source_bundle_with_ai)

    response = client.post("/v1/sources/validate", json={"rss_url": "https://example.com/few.xml", "tags": []})

    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "hidden"
    assert payload["status_reason"] == "too_few_entries"
    assert payload["review_source"] == "rule_fallback"
    assert payload["message"] == "자동 검토 결과 엔트리가 너무 적어 공개 보류 대상으로 판단되었습니다. AI 재검토는 완료되지 않아 1차 검증 결과를 표시합니다."


def test_autofill_source_endpoint_returns_heuristic_metadata(monkeypatch) -> None:
    from app.api import sources as sources_module

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://brief.example.com/feed.xml",
                "site_url": "https://brief.example.com",
                "title": "AI Chip Policy Weekly",
                "description": "Weekly digest covering AI infrastructure, semiconductor strategy, and policy analysis.",
                "favicon_url": "https://brief.example.com/favicon.ico",
                "feed_format": "rss2",
            },
            "entries": [
                {
                    "guid": "1",
                    "title": "AI agents reshape semiconductor design workflows",
                    "feed_url": "https://brief.example.com/1",
                    "published_at": datetime.now(UTC),
                    "summary": "A weekly digest on chip tooling, AI infrastructure, and industrial policy.",
                    "content_text": None,
                },
                {
                    "guid": "2",
                    "title": "Why chip export policy now defines AI competitiveness",
                    "feed_url": "https://brief.example.com/2",
                    "published_at": datetime.now(UTC) - timedelta(days=1),
                    "summary": "Policy analysis focused on semiconductor supply chains and AI compute.",
                    "content_text": None,
                },
            ],
        }

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources/autofill", json={"rss_url": "https://brief.example.com/feed.xml", "tags": []})
    assert response.status_code == 200
    payload = response.json()
    assert payload["type"] == "newsletter"
    assert "ai" in payload["categories"]
    assert len(payload["categories"]) == 2
    assert payload["tags"] == ["ai", "agents", "semiconductor"]
    assert payload["source"] == "heuristic"
    assert payload["samples_used"] >= 2


def test_autofill_source_endpoint_uses_gemini_suggestions(monkeypatch) -> None:
    from app.api import sources as sources_module
    from app.services import source_autofill as autofill_module

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://dispatch.example.com/feed.xml",
                "site_url": "https://dispatch.example.com",
                "title": "Dispatch",
                "description": "Updates.",
                "favicon_url": "https://dispatch.example.com/favicon.ico",
                "feed_format": "rss2",
            },
            "entries": [
                {
                    "guid": "1",
                    "title": "Market note",
                    "feed_url": "https://dispatch.example.com/1",
                    "published_at": datetime.now(UTC),
                    "summary": "A short note on enterprise software buying patterns.",
                    "content_text": None,
                }
            ],
        }

    async def fake_request_gemini_autofill(_: dict[str, object]) -> dict[str, object]:
        return {
            "language": "en",
            "type": "newsletter",
            "categories": ["business", "tech"],
            "tags": ["enterprise", "analysis", "weekly"],
        }

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)
    monkeypatch.setattr(autofill_module, "_request_gemini_autofill", fake_request_gemini_autofill)

    response = client.post("/v1/sources/autofill", json={"rss_url": "https://dispatch.example.com/feed.xml", "tags": []})
    assert response.status_code == 200
    payload = response.json()
    assert payload["language"] == "en"
    assert payload["type"] == "newsletter"
    assert payload["categories"] == ["business", "tech"]
    assert payload["tags"] == ["enterprise", "analysis", "weekly"]
    assert payload["source"] == "mixed"


def test_validate_source_endpoint_returns_specific_failure_reason(monkeypatch) -> None:
    from app.api import sources as sources_module
    from app.services.rss import InvalidRSSUrlError

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        raise InvalidRSSUrlError("The RSS URL returned HTTP 404.")

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources/validate", json={"rss_url": "https://example.com/missing.xml", "tags": []})
    assert response.status_code == 400
    payload = response.json()
    assert payload["error"]["code"] == "invalid_rss_url"
    assert payload["error"]["message"] == "The RSS URL returned HTTP 404."


def test_validate_source_endpoint_rejects_duplicate_source(monkeypatch) -> None:
    from app.api import sources as sources_module

    with SessionLocal() as db:
        db.add(
            Source(
                rss_url="https://example.com/feed.xml",
                site_url="https://example.com",
                title="Existing Source",
                description="desc",
                status="active",
                registered_by="web",
            )
        )
        db.commit()

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/feed.xml",
                "site_url": "https://example.com",
                "title": "Existing Source",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [],
        }

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources/validate", json={"rss_url": "https://example.com/feed.xml", "tags": []})
    assert response.status_code == 409
    payload = response.json()
    assert payload["error"]["code"] == "duplicate_source"
    assert payload["error"]["message"] == "This RSS URL is already registered."


def test_create_source_rejects_duplicate_source_before_insert(monkeypatch) -> None:
    from app.api import sources as sources_module

    with SessionLocal() as db:
        db.add(
            Source(
                rss_url="https://example.com/feed.xml",
                site_url="https://example.com",
                title="Existing Source",
                description="desc",
                status="active",
                registered_by="web",
            )
        )
        db.commit()

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/feed.xml",
                "site_url": "https://example.com",
                "title": "Existing Source",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [],
        }

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources", json={"rss_url": "https://example.com/feed.xml", "tags": []})
    assert response.status_code == 409
    payload = response.json()
    assert payload["error"]["code"] == "duplicate_source"
    assert payload["error"]["message"] == "This RSS URL is already registered."


def test_validate_source_endpoint_rejects_duplicate_site(monkeypatch) -> None:
    from app.api import sources as sources_module

    with SessionLocal() as db:
        db.add(
            Source(
                rss_url="https://example.com/feed.xml",
                site_url="https://example.com",
                title="Existing Source",
                description="desc",
                status="active",
                registered_by="web",
            )
        )
        db.commit()

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/another-feed.xml",
                "site_url": "https://example.com/",
                "title": "Existing Source",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [],
        }

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources/validate", json={"rss_url": "https://example.com/another-feed.xml", "tags": []})
    assert response.status_code == 409
    payload = response.json()
    assert payload["error"]["code"] == "duplicate_source"
    assert payload["error"]["message"] == "A source for this site is already registered."


def test_create_source_rejects_duplicate_site_before_insert(monkeypatch) -> None:
    from app.api import sources as sources_module

    with SessionLocal() as db:
        db.add(
            Source(
                rss_url="https://example.com/feed.xml",
                site_url="https://example.com",
                title="Existing Source",
                description="desc",
                status="active",
                registered_by="web",
            )
        )
        db.commit()

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://feeds.example.com/another-feed.xml",
                "site_url": "https://example.com/",
                "title": "Existing Source",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [],
        }

    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources", json={"rss_url": "https://feeds.example.com/another-feed.xml", "tags": []})
    assert response.status_code == 409
    payload = response.json()
    assert payload["error"]["code"] == "duplicate_source"
    assert payload["error"]["message"] == "A source for this site is already registered."


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


def test_create_source_persists_ai_review_fields(monkeypatch) -> None:
    from app.api import sources as sources_module
    from app.services.ai_review import SourceReviewResult
    from app.services.review import ReviewDecision

    class FakeLimiter:
        def enforce(self, **_: object) -> None:
            return None

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/annual.xml",
                "site_url": "https://example.com",
                "title": "Annual Journal",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [
                {"guid": "1", "title": "2024 annual letter", "feed_url": "https://example.com/1", "published_at": datetime.now(UTC)},
                {"guid": "2", "title": "2023 annual letter", "feed_url": "https://example.com/2", "published_at": datetime.now(UTC)},
            ],
        }

    async def fake_review_source_bundle_with_ai(**_: object) -> SourceReviewResult:
        return SourceReviewResult(
            initial_decision=ReviewDecision(status="hidden", reason="stale_feed"),
            final_decision=ReviewDecision(status="active", reason="ai_override"),
            review_source="ai",
            ai_review_reason="Legitimate low-frequency publication with coherent entries.",
            ai_review_confidence="high",
            ai_review_decision="active",
        )

    monkeypatch.setattr(sources_module, "registration_rate_limiter", FakeLimiter())
    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)
    monkeypatch.setattr(sources_module, "review_source_bundle_with_ai", fake_review_source_bundle_with_ai)

    response = client.post(
        "/v1/sources",
        json={"rss_url": "https://example.com/annual.xml", "tags": []},
    )

    assert response.status_code == 201
    payload = response.json()
    assert payload["status"] == "active"
    assert payload["status_reason"] == "ai_override"
    assert payload["ai_review_source"] == "create"
    assert payload["ai_review_reason"] == "Legitimate low-frequency publication with coherent entries."
    assert payload["ai_review_confidence"] == "high"
    assert payload["ai_review_decision"] == "active"
    assert payload["ai_reviewed_at"] is not None

    with SessionLocal() as db:
        source = db.scalar(select(Source).where(Source.rss_url == "https://example.com/annual.xml"))

    assert source is not None
    assert source.ai_review_source == "create"
    assert source.ai_review_reason == "Legitimate low-frequency publication with coherent entries."
    assert source.ai_review_confidence == "high"
    assert source.ai_review_decision == "active"
    assert source.ai_reviewed_at is not None


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
    assert payload["status_reason"] == "no_feed_entries"


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

    assert response.status_code == 409
    payload = response.json()
    assert payload["error"]["code"] == "duplicate_source"
    assert payload["error"]["message"] == "A source for this site is already registered."


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

    stale_time = datetime.now(UTC) - timedelta(days=366)

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


def test_create_source_persists_only_recent_entries(monkeypatch) -> None:
    from app.api import sources as sources_module
    from app.services import ingest as ingest_module

    class FakeLimiter:
        def enforce(self, **_: object) -> None:
            return None

    fixed_now = datetime(2026, 3, 15, 0, 0, tzinfo=UTC)
    monkeypatch.setattr(ingest_module, "_utcnow", lambda: fixed_now)

    async def fake_fetch_feed_bundle(_: str) -> dict[str, object]:
        return {
            "metadata": {
                "rss_url": "https://example.com/recent-only.xml",
                "site_url": "https://recent.example.com",
                "title": "Recent Source",
                "description": "desc",
                "favicon_url": None,
                "feed_format": "rss2",
            },
            "entries": [
                {
                    "guid": "recent-1",
                    "title": "Recent entry",
                    "feed_url": "https://example.com/1",
                    "published_at": fixed_now,
                },
                {
                    "guid": "old-1",
                    "title": "Old entry",
                    "feed_url": "https://example.com/old",
                    "published_at": fixed_now - timedelta(days=40),
                },
            ],
        }

    monkeypatch.setattr(sources_module, "registration_rate_limiter", FakeLimiter())
    monkeypatch.setattr(sources_module, "fetch_feed_bundle", fake_fetch_feed_bundle)

    response = client.post("/v1/sources", json={"rss_url": "https://example.com/recent-only.xml", "tags": []})

    assert response.status_code == 201
    payload = response.json()
    assert payload["status"] == "active"

    with SessionLocal() as db:
        source = db.query(Source).filter(Source.rss_url == "https://example.com/recent-only.xml").one()
        feeds = db.query(Feed).filter(Feed.source_id == source.id).all()

    assert len(feeds) == 1
    assert feeds[0].guid == "recent-1"
