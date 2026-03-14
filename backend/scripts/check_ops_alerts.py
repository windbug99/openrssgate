from __future__ import annotations

import os
import sys

import httpx


def main() -> int:
    base_url = os.getenv("OPENRSSGATE_API_BASE_URL", "http://127.0.0.1:8000").rstrip("/")
    response = httpx.get(f"{base_url}/v1/ops/alerts", timeout=10.0)
    response.raise_for_status()
    payload = response.json()

    status = payload.get("status", "unknown")
    alerts = payload.get("alerts", [])

    print(f"ops_status={status}")
    for alert in alerts:
        print(f"{alert['severity']}: {alert['code']} - {alert['message']}")

    return 0 if status == "ok" else 1


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except httpx.HTTPError as exc:
        print(str(exc), file=sys.stderr)
        raise SystemExit(1) from exc
