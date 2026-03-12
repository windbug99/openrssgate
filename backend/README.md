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

## Local Environment

Create `backend/.env` from `backend/.env.example`.

```bash
DATABASE_URL=sqlite:///./rssgateway.db
COLLECTOR_POLL_INTERVAL_SECONDS=300
CORS_ALLOWED_ORIGINS=http://127.0.0.1:3000,http://localhost:3000
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

## Test

```bash
pytest
```
