from __future__ import annotations

import json
import os
import sys

import httpx


BASE_URL = os.getenv("RSSGATE_MCP_BASE_URL", "http://127.0.0.1:8000")


def _fail(message: str) -> int:
    print(message, file=sys.stderr)
    return 1


def main() -> int:
    timeout = httpx.Timeout(10.0)

    with httpx.Client(base_url=BASE_URL, timeout=timeout) as client:
        initialize_response = client.post(
            "/mcp",
            json={
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "protocolVersion": "2025-03-26",
                    "capabilities": {},
                    "clientInfo": {"name": "smoke-test", "version": "0.1.0"},
                },
            },
        )
        if initialize_response.status_code != 200:
            return _fail(f"/mcp initialize failed: {initialize_response.status_code} {initialize_response.text}")
        session_id = initialize_response.headers.get("Mcp-Session-Id")
        if not session_id:
            return _fail("/mcp initialize did not return Mcp-Session-Id")
        initialize_payload = initialize_response.json()

        initialized_response = client.post(
            "/mcp",
            json={"jsonrpc": "2.0", "method": "notifications/initialized"},
            headers={"Mcp-Session-Id": session_id},
        )
        if initialized_response.status_code not in {200, 202}:
            return _fail(f"/mcp notifications/initialized failed: {initialized_response.status_code} {initialized_response.text}")

        tools_response = client.post(
            "/mcp",
            json={"jsonrpc": "2.0", "id": 2, "method": "tools/list", "params": {}},
            headers={"Mcp-Session-Id": session_id},
        )
        if tools_response.status_code != 200:
            return _fail(f"/mcp tools/list failed: {tools_response.status_code} {tools_response.text}")
        tools_payload = tools_response.json()

        call_response = client.post(
            "/mcp",
            json={
                "jsonrpc": "2.0",
                "id": 3,
                "method": "tools/call",
                "params": {"name": "search_sources", "arguments": {"limit": 5}},
            },
            headers={"Mcp-Session-Id": session_id},
        )
        if call_response.status_code != 200:
            return _fail(f"/mcp tools/call failed: {call_response.status_code} {call_response.text}")
        call_payload = call_response.json()

    print("MCP smoke test passed")
    print(
        json.dumps(
            {"initialize": initialize_payload, "tools": tools_payload, "call": call_payload},
            ensure_ascii=False,
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
