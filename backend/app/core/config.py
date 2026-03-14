import json
from functools import lru_cache
from typing import Annotated

from pydantic import field_validator
from pydantic_settings import BaseSettings, NoDecode, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "RSS Gateway"
    api_prefix: str = "/v1"
    database_url: str = "sqlite:///./rssgateway.db"
    request_timeout_seconds: float = 10.0
    max_redirects: int = 5
    user_agent: str = "rss-gateway-bot/0.1 (+https://rssgateway.io)"
    collector_poll_interval_seconds: int = 300
    source_registration_window_seconds: int = 3600
    source_registration_max_attempts: int = 10
    source_registration_max_same_host: int = 3
    public_read_rate_limit_enabled: bool = True
    public_read_window_seconds: int = 60
    public_read_max_requests: int = 120
    collector_stale_after_minutes: int = 180
    ops_api_key: str | None = None
    service_api_keys: Annotated[list[str], NoDecode] = []
    response_cache_enabled: bool = False
    response_cache_ttl_seconds: int = 60
    redis_url: str | None = None
    ops_alert_stale_sources_threshold: int = 25
    ops_alert_failing_sources_threshold: int = 10
    ops_alert_collector_lag_minutes: int = 30
    cors_allowed_origins: Annotated[list[str], NoDecode] = ["http://127.0.0.1:3000", "http://localhost:3000"]

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    @field_validator("cors_allowed_origins", mode="before")
    @classmethod
    def parse_cors_allowed_origins(cls, value: object) -> object:
        if isinstance(value, str):
            stripped = value.strip()
            if not stripped:
                return []
            if stripped.startswith("["):
                loaded = json.loads(stripped)
                if isinstance(loaded, list):
                    return [str(origin).strip() for origin in loaded if str(origin).strip()]
            return [origin.strip() for origin in stripped.split(",") if origin.strip()]
        return value

    @field_validator("service_api_keys", mode="before")
    @classmethod
    def parse_service_api_keys(cls, value: object) -> object:
        if isinstance(value, str):
            stripped = value.strip()
            if not stripped:
                return []
            if stripped.startswith("["):
                loaded = json.loads(stripped)
                if isinstance(loaded, list):
                    return [str(item).strip() for item in loaded if str(item).strip()]
            return [item.strip() for item in stripped.split(",") if item.strip()]
        return value


@lru_cache
def get_settings() -> Settings:
    return Settings()
