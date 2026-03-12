from functools import lru_cache

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "RSS Gateway"
    api_prefix: str = "/v1"
    database_url: str = "sqlite:///./rssgateway.db"
    request_timeout_seconds: float = 10.0
    max_redirects: int = 5
    user_agent: str = "rss-gateway-bot/0.1 (+https://rssgateway.io)"
    collector_poll_interval_seconds: int = 300
    cors_allowed_origins: list[str] = ["http://127.0.0.1:3000", "http://localhost:3000"]

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    @field_validator("cors_allowed_origins", mode="before")
    @classmethod
    def parse_cors_allowed_origins(cls, value: object) -> object:
        if isinstance(value, str):
            return [origin.strip() for origin in value.split(",") if origin.strip()]
        return value


@lru_cache
def get_settings() -> Settings:
    return Settings()
