from __future__ import annotations

import json
from threading import Lock
from time import monotonic
from typing import Any

try:
    import redis  # type: ignore
except ImportError:  # pragma: no cover - optional dependency in local tests
    redis = None


class ResponseCache:
    def __init__(self) -> None:
        self._lock = Lock()
        self._memory: dict[str, tuple[float, str]] = {}
        self._client: Any = None
        self._url: str | None = None

    def configure(self, url: str | None) -> None:
        if url == self._url:
            return
        self._url = url
        self._client = None
        if url and redis is not None:
            self._client = redis.Redis.from_url(url, decode_responses=True)

    def get_json(self, key: str) -> Any | None:
        if self._client is not None:
            value = self._client.get(key)
            return json.loads(value) if value else None

        with self._lock:
            cached = self._memory.get(key)
            if not cached:
                return None
            expires_at, payload = cached
            if expires_at <= monotonic():
                self._memory.pop(key, None)
                return None
            return json.loads(payload)

    def set_json(self, key: str, value: Any, ttl_seconds: int) -> None:
        payload = json.dumps(value, default=str)
        if self._client is not None:
            self._client.setex(key, ttl_seconds, payload)
            return

        with self._lock:
            self._memory[key] = (monotonic() + ttl_seconds, payload)

    def reset(self) -> None:
        with self._lock:
            self._memory.clear()


response_cache = ResponseCache()
