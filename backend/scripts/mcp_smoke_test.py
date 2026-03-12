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
        tools_response = client.get("/mcp/tools")
        if tools_response.status_code != 200:
            return _fail(f"/mcp/tools failed: {tools_response.status_code} {tools_response.text}")
        tools_payload = tools_response.json()

        sse_response = client.get("/mcp/sse", params={"once": "true"})
        if sse_response.status_code != 200:
            return _fail(f"/mcp/sse failed: {sse_response.status_code} {sse_response.text}")
        if "event: tools" not in sse_response.text:
            return _fail("/mcp/sse did not stream the tools event")

        call_response = client.post(
            "/mcp/call",
            json={"name": "search_sources", "arguments": {"limit": 5}},
        )
        if call_response.status_code != 200:
            return _fail(f"/mcp/call failed: {call_response.status_code} {call_response.text}")
        call_payload = call_response.json()

    print("MCP smoke test passed")
    print(json.dumps({"tools": tools_payload, "call": call_payload}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
