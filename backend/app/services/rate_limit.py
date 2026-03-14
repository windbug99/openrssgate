from __future__ import annotations

from collections import defaultdict, deque
from threading import Lock
from time import monotonic


class RateLimitExceededError(RuntimeError):
    pass


class SlidingWindowRateLimiter:
    def __init__(self) -> None:
        self._lock = Lock()
        self._attempts_by_key: dict[tuple[str, ...], deque[float]] = defaultdict(deque)

    def enforce(self, *, key: tuple[str, ...], window_seconds: int, max_attempts: int, message: str) -> None:
        now = monotonic()
        with self._lock:
            attempts = self._attempts_by_key[key]
            self._prune(attempts, now, window_seconds)
            if len(attempts) >= max_attempts:
                raise RateLimitExceededError(message)
            attempts.append(now)

    def reset(self) -> None:
        with self._lock:
            self._attempts_by_key.clear()

    @staticmethod
    def _prune(queue: deque[float], now: float, window_seconds: int) -> None:
        cutoff = now - window_seconds
        while queue and queue[0] < cutoff:
            queue.popleft()


class RegistrationRateLimiter:
    def __init__(self) -> None:
        self._limiter = SlidingWindowRateLimiter()

    def enforce(self, *, ip: str, host: str, window_seconds: int, max_attempts: int, max_same_host: int) -> None:
        self._limiter.enforce(
            key=("registration-ip", ip),
            window_seconds=window_seconds,
            max_attempts=max_attempts,
            message="Too many source registration attempts. Please try again later.",
        )
        self._limiter.enforce(
            key=("registration-ip-host", ip, host),
            window_seconds=window_seconds,
            max_attempts=max_same_host,
            message="Too many registrations for the same host. Please try again later.",
        )

    def reset(self) -> None:
        self._limiter.reset()


class ReadRateLimiter:
    def __init__(self) -> None:
        self._limiter = SlidingWindowRateLimiter()

    def enforce(self, *, ip: str, path: str, window_seconds: int, max_attempts: int) -> None:
        self._limiter.enforce(
            key=("read-ip-path", ip, path),
            window_seconds=window_seconds,
            max_attempts=max_attempts,
            message="Too many read requests. Please try again later.",
        )

    def reset(self) -> None:
        self._limiter.reset()


registration_rate_limiter = RegistrationRateLimiter()
read_rate_limiter = ReadRateLimiter()
