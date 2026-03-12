# Frontend

## Run

```bash
npm install
npm run dev
```

Set `NEXT_PUBLIC_API_BASE_URL` to the backend base URL, for example:

```bash
NEXT_PUBLIC_API_BASE_URL=http://127.0.0.1:8000/v1
```

Frontend runs on `http://127.0.0.1:3000` by default.

## Local Flow

1. Start backend with `uvicorn app.main:app --reload` inside `backend/`.
2. Start collector worker with `python -m app.collector.worker` inside `backend/`.
3. Start frontend with `npm run dev` inside `frontend/`.

## Vercel

Deploy `frontend/` as the project root and set:

```bash
NEXT_PUBLIC_API_BASE_URL=https://your-railway-api-domain/v1
```
