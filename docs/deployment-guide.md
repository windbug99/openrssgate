# Deployment Guide

## Goal

Deploy the backend to Railway and the frontend to Vercel with separate API and worker processes.

## Backend on Railway

Create two Railway services from the `backend/` directory.

### 1. API service

Start command:

```bash
bash scripts/start_api.sh
```

Required environment variables:

```bash
DATABASE_URL=postgresql+psycopg://...
CORS_ALLOWED_ORIGINS=https://your-frontend-domain.vercel.app
COLLECTOR_POLL_INTERVAL_SECONDS=300
```

Reference files:

- `backend/.env.production.example`
- `backend/railway-api.json`

Health check path:

```text
/health
```

### 2. Worker service

Start command:

```bash
bash scripts/start_worker.sh
```

Required environment variables:

```bash
DATABASE_URL=postgresql+psycopg://...
COLLECTOR_POLL_INTERVAL_SECONDS=300
```

Reference file:

- `backend/railway-worker.json`

Notes:

- API and worker must point at the same database.
- The worker should run as a single instance in MVP.
- Both services run `alembic upgrade head` before startup.

## Database

Recommended production database:

```text
Neon PostgreSQL
```

Current code already supports SQLAlchemy database URLs through `DATABASE_URL`.

Example production DSN:

```bash
DATABASE_URL=postgresql+psycopg://USER:PASSWORD@ep-xxx.ap-southeast-1.aws.neon.tech/neondb?sslmode=require
```

## Frontend on Vercel

Project root:

```text
frontend/
```

Required environment variables:

```bash
NEXT_PUBLIC_API_BASE_URL=https://your-railway-api-domain/v1
```

The included `frontend/vercel.json` is enough for the current Next.js app. Admin auth requests are proxied through the frontend under `/api/admin/*`, so admin cookies are issued on the frontend origin instead of the Railway API origin.

Reference file:

- `frontend/.env.production.example`

## Deploy order

1. Provision PostgreSQL and set `DATABASE_URL`.
2. Run `python scripts/check_deploy_env.py` in `backend/`.
2. Deploy Railway API service.
3. Deploy Railway worker service.
4. Verify `GET /health`.
5. Verify `backend/scripts/mcp_smoke_test.py` against the deployed API.
6. Deploy Vercel frontend with `NEXT_PUBLIC_API_BASE_URL`.

## Post-deploy checks

- `GET /health` returns `{"status":"ok"}`
- `POST /mcp` with `initialize` returns `Mcp-Session-Id`
- `POST /mcp` with `tools/list` returns the MCP tool list
- `POST /mcp` with `tools/call` returns valid tool results
- `GET /mcp/tools` returns the tool manifest
- `POST /mcp/call` returns valid tool results
- Web homepage can register a source
- Explore page can list sources and feeds
