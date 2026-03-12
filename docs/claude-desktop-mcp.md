# Claude Desktop MCP Verification

## Goal

Verify that Claude Desktop can reach the RSS Gateway MCP endpoints over HTTP SSE.

Note:

- Remote HTTP SSE MCP is available in the project.
- Actual local validation in this repository was completed through the local stdio MCP server because Claude Desktop free-plan environments may not expose custom remote connector registration.

## 1. Start local services

Backend:

```bash
cd /Users/tomato/cursor/openrssgate/backend
source .venv/bin/activate
.venv/bin/alembic upgrade head
uvicorn app.main:app --host 127.0.0.1 --port 8000
```

Optional collector:

```bash
cd /Users/tomato/cursor/openrssgate/backend
source .venv/bin/activate
python -m app.collector.worker
```

## 2. Run smoke test before Claude Desktop

```bash
cd /Users/tomato/cursor/openrssgate/backend
source .venv/bin/activate
python scripts/mcp_smoke_test.py
```

Expected result:

- `/mcp/tools` returns the tool manifest
- `/mcp/sse?once=true` returns `server_ready` and `tools` events
- `/mcp/call` returns a valid `search_sources` response

## 3. Claude Desktop connection values

Use the local MCP HTTP SSE endpoint:

```text
SSE URL: http://127.0.0.1:8000/mcp/sse
Tool call URL: http://127.0.0.1:8000/mcp/call
```

Tool names currently exposed:

- `search_sources`
- `get_source`
- `get_recent_feeds`
- `get_source_feeds`

## 4. Suggested manual prompts

Use prompts that map directly to the current read-only tools.

```text
한국어 블로그 Source를 찾아줘
최근 24시간 피드를 보여줘
특정 Source의 최신 글 목록을 보여줘
```

## 5. Verification checklist

- Claude Desktop connects without transport errors
- tool list is visible
- `search_sources` can return results
- `get_recent_feeds` can return results
- SSE transport remains connected without immediate disconnect

## 6. Current limitation

This project currently exposes a lightweight HTTP SSE MCP surface using local FastAPI routes. It is sufficient for local verification, but not yet a full FastMCP production integration.
