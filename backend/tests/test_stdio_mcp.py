from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

from app.db.database import Base, SessionLocal, engine
from app.db.models import Source


def _send(proc: subprocess.Popen[str], payload: dict[str, object]) -> dict[str, object]:
    assert proc.stdin is not None
    assert proc.stdout is not None
    proc.stdin.write(json.dumps(payload) + "\n")
    proc.stdin.flush()
    line = proc.stdout.readline().strip()
    return json.loads(line)


def test_stdio_mcp_initialize_and_tools_call() -> None:
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    with SessionLocal() as db:
        source = Source(
            rss_url="https://example.com/rss.xml",
            site_url="https://example.com",
            title="Example Source",
            description="desc",
            status="active",
            registered_by="web",
        )
        db.add(source)
        db.commit()

    script = Path(__file__).resolve().parents[1] / "scripts" / "mcp_stdio_server.py"
    backend_root = Path(__file__).resolve().parents[1]
    proc = subprocess.Popen(
        [sys.executable, str(script)],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        cwd=backend_root,
    )

    try:
        initialize = _send(
            proc,
            {
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "protocolVersion": "2025-03-26",
                    "capabilities": {},
                    "clientInfo": {"name": "test-client", "version": "0.1.0"},
                },
            },
        )
        assert initialize["result"]["serverInfo"]["name"] == "rss-gateway-stdio"

        assert proc.stdin is not None
        proc.stdin.write(json.dumps({"jsonrpc": "2.0", "method": "notifications/initialized"}) + "\n")
        proc.stdin.flush()

        tools = _send(proc, {"jsonrpc": "2.0", "id": 2, "method": "tools/list", "params": {}})
        assert any(tool["name"] == "search_sources" for tool in tools["result"]["tools"])

        call = _send(
            proc,
            {
                "jsonrpc": "2.0",
                "id": 3,
                "method": "tools/call",
                "params": {"name": "search_sources", "arguments": {"limit": 5}},
            },
        )
        assert call["result"]["isError"] is False
        assert call["result"]["structuredContent"]["total"] == 1
    finally:
        proc.kill()


def test_stdio_mcp_returns_tool_errors_in_result() -> None:
    script = Path(__file__).resolve().parents[1] / "scripts" / "mcp_stdio_server.py"
    backend_root = Path(__file__).resolve().parents[1]
    proc = subprocess.Popen(
        [sys.executable, str(script)],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        cwd=backend_root,
    )

    try:
        initialize = _send(
            proc,
            {
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "protocolVersion": "2025-03-26",
                    "capabilities": {},
                    "clientInfo": {"name": "test-client", "version": "0.1.0"},
                },
            },
        )
        assert initialize["result"]["serverInfo"]["name"] == "rss-gateway-stdio"

        assert proc.stdin is not None
        proc.stdin.write(json.dumps({"jsonrpc": "2.0", "method": "notifications/initialized"}) + "\n")
        proc.stdin.flush()

        call = _send(
            proc,
            {
                "jsonrpc": "2.0",
                "id": 2,
                "method": "tools/call",
                "params": {"name": "get_source", "arguments": {}},
            },
        )
        assert call["result"]["isError"] is True
        assert call["result"]["structuredContent"]["error"]["code"] == "missing_source_id"
    finally:
        proc.kill()
