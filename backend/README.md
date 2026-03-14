# Backend

## Run

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
.venv/bin/alembic upgrade head
uvicorn app.main:app --reload
```

Backend runs on `http://127.0.0.1:8000` by default.

## Run Collector Once

```bash
python -m app.collector.run_once
```

## Run Collector Worker

```bash
.venv/bin/alembic upgrade head
python -m app.collector.worker
```

## Production Start Commands

API:

```bash
bash scripts/start_api.sh
```

Worker:

```bash
bash scripts/start_worker.sh
```

`COLLECTOR_POLL_INTERVAL_SECONDS` can be used to control how often the worker checks for due sources.
`SOURCE_REGISTRATION_WINDOW_SECONDS`, `SOURCE_REGISTRATION_MAX_ATTEMPTS`, and `SOURCE_REGISTRATION_MAX_SAME_HOST` can be used to control anonymous source registration limits.
`PUBLIC_READ_WINDOW_SECONDS` and `PUBLIC_READ_MAX_REQUESTS` can be used to control public GET API rate limits.
`SERVICE_API_KEYS` and `OPS_API_KEY` can be used to protect operations or partner endpoints.
`RESPONSE_CACHE_ENABLED`, `RESPONSE_CACHE_TTL_SECONDS`, and `REDIS_URL` can be used to enable response caching.

## Local Environment

Create `backend/.env` from `backend/.env.example`.

```bash
DATABASE_URL=sqlite:///./rssgateway.db
COLLECTOR_POLL_INTERVAL_SECONDS=300
CORS_ALLOWED_ORIGINS=http://127.0.0.1:3000,http://localhost:3000
PUBLIC_READ_WINDOW_SECONDS=60
PUBLIC_READ_MAX_REQUESTS=120
SERVICE_API_KEYS=["change-this-service-key"]
RESPONSE_CACHE_ENABLED=false
```

Railway environment variables can use a JSON array instead:

```bash
CORS_ALLOWED_ORIGINS=["https://your-frontend-domain.vercel.app"]
```

## Migrations

```bash
.venv/bin/alembic upgrade head
.venv/bin/alembic revision -m "describe change"
```

## MCP Smoke Test

```bash
source .venv/bin/activate
python scripts/mcp_smoke_test.py
```

## Deployment Env Check

```bash
source .venv/bin/activate
python scripts/check_deploy_env.py
```

Claude Desktop verification steps are documented in [docs/claude-desktop-mcp.md](/Users/tomato/cursor/openrssgate/docs/claude-desktop-mcp.md).
Claude Desktop local stdio setup is documented in [docs/claude-desktop-local-mcp.md](/Users/tomato/cursor/openrssgate/docs/claude-desktop-local-mcp.md).

Deployment steps are documented in [docs/deployment-guide.md](/Users/tomato/cursor/openrssgate/docs/deployment-guide.md).

## Operations Summary

```bash
curl http://127.0.0.1:8000/v1/ops/summary
```

This returns lightweight collector and database status for production smoke checks.

```bash
curl "http://127.0.0.1:8000/v1/ops/sources?status=hidden"
```

This lists sources across moderation states, including `pending_review`, `hidden`, and `rejected`.

```bash
curl -X POST "http://127.0.0.1:8000/v1/ops/sources/<source_id>/status" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: change-this-service-key" \
  -d '{"status":"active","reason":"manual_restore"}'
```

```bash
curl http://127.0.0.1:8000/v1/ops/alerts
```

This returns warning and critical alerts derived from stale sources, failing sources, and collector lag.

```bash
source .venv/bin/activate
OPENRSSGATE_API_BASE_URL=http://127.0.0.1:8000 python scripts/check_ops_alerts.py
```

This exits with a non-zero code when operational alerts are present, so it can be wired into Railway cron checks or external monitors.

## Test

```bash
pytest
```
