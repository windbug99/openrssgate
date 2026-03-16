# Claude Desktop MCP Verification

## Goal

Verify that Claude Desktop can reach the RSS Gateway remote MCP transport over HTTP.

Note:

- The project now exposes a session-based remote MCP HTTP endpoint at `/mcp`.
- Legacy debug endpoints `/mcp/tools`, `/mcp/sse`, and `/mcp/call` still exist for smoke tests and manual checks.
- Local stdio MCP is still available when you want a purely local Claude Desktop setup.
- Claude Desktop free-plan environments may not expose remote MCP connector registration. In that case, use the local stdio setup and revisit remote HTTP MCP later.

## 1. Start local services

Backend:

```bash
cd backend
source .venv/bin/activate
.venv/bin/alembic upgrade head
uvicorn app.main:app --host 127.0.0.1 --port 8000
```

Optional collector:

```bash
cd backend
source .venv/bin/activate
python -m app.collector.worker
```

## 2. Run smoke test before Claude Desktop

```bash
cd backend
source .venv/bin/activate
python scripts/mcp_smoke_test.py
```

Expected result:

- `/mcp` `initialize` returns a valid JSON-RPC result and `Mcp-Session-Id`
- `/mcp` `tools/list` returns the tool manifest
- `/mcp` `tools/call` returns a valid `search_sources` response

## 3. Recommended Claude Desktop connection values

Use the remote MCP HTTP endpoint if you want a hosted connector, or the local stdio MCP server if you want a local-only setup.

If your Claude Desktop account does not show a remote connector or HTTP MCP registration option, you cannot use the remote MCP transport from the app yet. That is an account or plan limitation, not an OpenRSSGate server issue.

Remote MCP endpoint:

```text
HTTP MCP URL: http://127.0.0.1:8000/mcp
```

Local stdio registration values are documented in [claude-desktop-local-mcp.md](claude-desktop-local-mcp.md).

## 4. Current practical recommendation

For this repository today:

- Use remote HTTP MCP for smoke tests, deployment checks, and any client that supports remote MCP URLs.
- Use local stdio MCP for Claude Desktop when the account is on a free plan and the remote connector UI is unavailable.

## 5. Legacy debug endpoints

These routes remain useful for smoke tests and custom debugging:

```text
SSE URL: http://127.0.0.1:8000/mcp/sse
Tool call URL: http://127.0.0.1:8000/mcp/call
```

Tool names currently exposed:

- `search_sources`
- `get_source`
- `get_source_status`
- `get_stats`
- `get_recent_feeds`
- `get_source_feeds`
- `list_feeds`
- `get_feed`
- `get_source_feed`
- `validate_source`
- `autofill_source`
- `create_source`

## 6. Suggested manual prompts

Use prompts that map directly to the current read-only tools.

```text
한국어 블로그 Source를 찾아줘
최근 24시간 피드를 보여줘
특정 Source의 최신 글 목록을 보여줘
```

## 7. Verification checklist

- Claude Desktop connects through the remote HTTP MCP endpoint without transport errors
- tool list is visible
- `search_sources` can return results
- `get_recent_feeds` can return results
- HTTP session handshake completes and returns `Mcp-Session-Id`

The broader deploy-time checks are documented in [post-deploy-checklist.md](post-deploy-checklist.md).

## 8. Current limitation

This project implements the MCP session handshake and tool transport in FastAPI routes rather than through a dedicated FastMCP dependency. The legacy debug endpoints are still project-specific and should not be treated as the primary integration path.
