from __future__ import annotations

import os
import sys


def _require(name: str) -> str:
    value = os.getenv(name, "").strip()
    if not value:
        raise RuntimeError(f"Missing required environment variable: {name}")
    return value


def main() -> int:
    database_url = _require("DATABASE_URL")

    if not database_url.startswith(("postgresql+psycopg://", "sqlite:///")):
        raise RuntimeError("DATABASE_URL must use postgresql+psycopg:// or sqlite:///")

    cors_allowed_origins = os.getenv("CORS_ALLOWED_ORIGINS", "").strip()
    collector_poll_interval_seconds = os.getenv("COLLECTOR_POLL_INTERVAL_SECONDS", "").strip()
    public_read_window_seconds = os.getenv("PUBLIC_READ_WINDOW_SECONDS", "").strip()
    public_read_max_requests = os.getenv("PUBLIC_READ_MAX_REQUESTS", "").strip()
    response_cache_enabled = os.getenv("RESPONSE_CACHE_ENABLED", "").strip().lower()
    redis_url = os.getenv("REDIS_URL", "").strip()

    if response_cache_enabled in {"1", "true", "yes"} and not redis_url:
        print("Warning: RESPONSE_CACHE_ENABLED is true but REDIS_URL is not set", file=sys.stderr)

    print("Deployment environment looks valid")
    print(f"DATABASE_URL={database_url.split('@')[0] if '@' in database_url else database_url}")
    print(f"CORS_ALLOWED_ORIGINS={cors_allowed_origins or '(not set)'}")
    print(f"COLLECTOR_POLL_INTERVAL_SECONDS={collector_poll_interval_seconds or '(default)'}")
    print(f"PUBLIC_READ_WINDOW_SECONDS={public_read_window_seconds or '(default)'}")
    print(f"PUBLIC_READ_MAX_REQUESTS={public_read_max_requests or '(default)'}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        raise SystemExit(1) from exc
