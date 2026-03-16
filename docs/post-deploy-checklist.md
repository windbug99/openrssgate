# Post-Deploy Checklist

## Goal

Run a short, repeatable verification after each backend deploy.

## 1. Health

Replace the domain below with your deployed API base domain.

```bash
curl https://openrssgate-production.up.railway.app/health
```

Expected:

```json
{"status":"ok"}
```

## 2. Remote MCP Smoke Test

```bash
cd /Users/tomato/cursor/openrssgate/backend
source .venv/bin/activate
RSSGATE_MCP_BASE_URL=https://openrssgate-production.up.railway.app python scripts/mcp_smoke_test.py
```

Expected:

- `initialize` succeeds
- `Mcp-Session-Id` is returned
- `tools/list` returns the MCP tool list
- `tools/call` succeeds for `search_sources`

## 3. Manual Remote MCP Calls

Initialize:

```bash
curl -i -X POST https://openrssgate-production.up.railway.app/mcp \
  -H 'Content-Type: application/json' \
  -d '{
    "jsonrpc":"2.0",
    "id":1,
    "method":"initialize",
    "params":{
      "protocolVersion":"2025-03-26",
      "capabilities":{},
      "clientInfo":{"name":"manual-test","version":"0.1.0"}
    }
  }'
```

Save the `Mcp-Session-Id` response header, then mark the session initialized:

```bash
curl -X POST https://openrssgate-production.up.railway.app/mcp \
  -H 'Content-Type: application/json' \
  -H 'Mcp-Session-Id: <SESSION_ID>' \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'
```

List tools:

```bash
curl -X POST https://openrssgate-production.up.railway.app/mcp \
  -H 'Content-Type: application/json' \
  -H 'Mcp-Session-Id: <SESSION_ID>' \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'
```

Get stats:

```bash
curl -X POST https://openrssgate-production.up.railway.app/mcp \
  -H 'Content-Type: application/json' \
  -H 'Mcp-Session-Id: <SESSION_ID>' \
  -d '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_stats","arguments":{}}}'
```

List recent feeds:

```bash
curl -X POST https://openrssgate-production.up.railway.app/mcp \
  -H 'Content-Type: application/json' \
  -H 'Mcp-Session-Id: <SESSION_ID>' \
  -d '{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"list_feeds","arguments":{"q":"openai","since":"7d","limit":5}}}'
```

## 4. Public REST Checks

```bash
curl https://openrssgate-production.up.railway.app/v1/stats
curl 'https://openrssgate-production.up.railway.app/v1/sources?limit=5'
curl 'https://openrssgate-production.up.railway.app/v1/feeds?q=openai&since=7d&limit=5'
```

Expected:

- all return `200`
- payloads are valid JSON
- `stats` fields are populated
- `sources` and `feeds` pagination fields are present

## 5. Web Checks

- Homepage loads
- Source section lists sources
- Source registration form opens

## 6. Connector Checks

- MCP connector can add the remote endpoint at `/mcp`
- tool list is visible
- `search_sources` succeeds
- `get_stats` succeeds
- `list_feeds` succeeds

## 7. Optional Write Checks

These create real work or data. Run only when needed.

- `validate_source`
- `autofill_source`
- `create_source`

For `create_source`, use a disposable test feed and confirm moderation/rate-limit behavior afterward.
