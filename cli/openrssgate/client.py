from __future__ import annotations

import json
from typing import Any

import httpx

from openrssgate.config import get_api_base_url


class ApiError(RuntimeError):
    pass


class OpenRSSGateClient:
    def __init__(self, base_url: str | None = None) -> None:
        self.base_url = (base_url or get_api_base_url()).rstrip("/")

    def _request(self, path: str, *, method: str = "GET", params: dict[str, Any] | None = None, json_body: Any = None) -> Any:
        try:
            response = httpx.request(method, f"{self.base_url}{path}", params=params, json=json_body, timeout=10.0)
            response.raise_for_status()
        except httpx.HTTPStatusError as exc:
            payload = exc.response.json() if exc.response.headers.get("content-type", "").startswith("application/json") else {}
            message = payload.get("error", {}).get("message", exc.response.text)
            raise ApiError(message) from exc
        except httpx.ConnectError as exc:
            raise ApiError(
                "Failed to connect to OpenRSSGate API.\n"
                f"Base URL: {self.base_url}\n"
                "Set OPENRSSGATE_API_BASE_URL if you want to use a custom server."
            ) from exc
        except httpx.HTTPError as exc:
            raise ApiError(str(exc)) from exc
        return response.json()

    def list_sources(self, **params: Any) -> dict[str, Any]:
        return self._request("/sources", params=params)

    def list_feeds(self, **params: Any) -> dict[str, Any]:
        return self._request("/feeds", params=params)

    def get_feed(self, feed_id: str) -> dict[str, Any]:
        return self._request(f"/feeds/{feed_id}")

    def get_stats(self) -> dict[str, Any]:
        return self._request("/stats")

    def validate_source(self, rss_url: str, **params: Any) -> dict[str, Any]:
        payload = {"rss_url": rss_url, **params}
        return self._request("/sources/validate", method="POST", json_body=payload)


def format_json(payload: Any) -> str:
    return json.dumps(payload, ensure_ascii=False, indent=2)
