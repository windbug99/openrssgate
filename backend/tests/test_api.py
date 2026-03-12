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
