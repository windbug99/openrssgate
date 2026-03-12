from __future__ import annotations

from collections import defaultdict, deque
from threading import Lock
from time import monotonic


class RateLimitExceededError(RuntimeError):
    pass


class RegistrationRateLimiter:
    def __init__(self) -> None:
        self._lock = Lock()
        self._attempts_by_ip: dict[str, deque[float]] = defaultdict(deque)
        self._attempts_by_ip_host: dict[tuple[str, str], deque[float]] = defaultdict(deque)

    def enforce(self, *, ip: str, host: str, window_seconds: int, max_attempts: int, max_same_host: int) -> None:
        now = monotonic()
        with self._lock:
            ip_attempts = self._attempts_by_ip[ip]
            self._prune(ip_attempts, now, window_seconds)
            if len(ip_attempts) >= max_attempts:
                raise RateLimitExceededError("Too many source registration attempts. Please try again later.")

            host_attempts = self._attempts_by_ip_host[(ip, host)]
            self._prune(host_attempts, now, window_seconds)
            if len(host_attempts) >= max_same_host:
                raise RateLimitExceededError("Too many registrations for the same host. Please try again later.")

            ip_attempts.append(now)
            host_attempts.append(now)

    @staticmethod
    def _prune(queue: deque[float], now: float, window_seconds: int) -> None:
        cutoff = now - window_seconds
        while queue and queue[0] < cutoff:
            queue.popleft()


registration_rate_limiter = RegistrationRateLimiter()
