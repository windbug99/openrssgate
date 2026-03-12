from __future__ import annotations

import json
from typing import Any

import httpx

from rssgate.config import get_api_base_url


class ApiError(RuntimeError):
    pass


class RSSGatewayClient:
    def __init__(self, base_url: str | None = None) -> None:
        self.base_url = (base_url or get_api_base_url()).rstrip("/")

    def _request(self, path: str, params: dict[str, Any] | None = None) -> Any:
        try:
            response = httpx.get(f"{self.base_url}{path}", params=params, timeout=10.0)
            response.raise_for_status()
        except httpx.HTTPStatusError as exc:
            payload = exc.response.json() if exc.response.headers.get("content-type", "").startswith("application/json") else {}
            message = payload.get("error", {}).get("message", exc.response.text)
            raise ApiError(message) from exc
        except httpx.HTTPError as exc:
            raise ApiError(str(exc)) from exc
        return response.json()

    def list_sources(self, **params: Any) -> dict[str, Any]:
        return self._request("/sources", params=params)

    def list_feeds(self, **params: Any) -> dict[str, Any]:
        return self._request("/feeds", params=params)


def format_json(payload: Any) -> str:
    return json.dumps(payload, ensure_ascii=False, indent=2)
