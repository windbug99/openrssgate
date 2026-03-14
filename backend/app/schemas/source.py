from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field, HttpUrl, field_validator

from app.source_metadata import (
    LANGUAGE_VALUES,
    MAX_SOURCE_CATEGORIES,
    MAX_SOURCE_TAGS,
    SOURCE_CATEGORY_VALUES,
    SOURCE_TAG_VALUES,
    SOURCE_TYPE_VALUES,
)


class SourceCreate(BaseModel):
    rss_url: HttpUrl
    language: str | None = Field(default=None, max_length=16)
    type: str | None = Field(default=None, max_length=32)
    categories: list[str] = Field(default_factory=list, max_length=MAX_SOURCE_CATEGORIES)
    tags: list[str] = Field(default_factory=list, max_length=MAX_SOURCE_TAGS)

    @field_validator("language")
    @classmethod
    def validate_language(cls, value: str | None) -> str | None:
        if value is None:
            return None
        cleaned = value.strip().lower()
        if cleaned not in LANGUAGE_VALUES:
            raise ValueError("Language must use a supported option.")
        return cleaned

    @field_validator("type")
    @classmethod
    def validate_type(cls, value: str | None) -> str | None:
        if value is None:
            return None
        cleaned = value.strip().lower()
        if cleaned not in SOURCE_TYPE_VALUES:
            raise ValueError("Type must use a supported option.")
        return cleaned

    @field_validator("categories")
    @classmethod
    def validate_categories(cls, value: list[str]) -> list[str]:
        cleaned: list[str] = []
        for category in value:
            normalized = category.strip().lower()
            if not normalized:
                continue
            if normalized not in SOURCE_CATEGORY_VALUES:
                raise ValueError("Categories must use supported options.")
            if normalized not in cleaned:
                cleaned.append(normalized)
        if len(cleaned) > MAX_SOURCE_CATEGORIES:
            raise ValueError(f"A maximum of {MAX_SOURCE_CATEGORIES} categories is allowed.")
        return cleaned

    @field_validator("tags")
    @classmethod
    def validate_tags(cls, value: list[str]) -> list[str]:
        cleaned: list[str] = []
        for tag in value:
            normalized = tag.strip().lower()
            if not normalized:
                continue
            if normalized not in SOURCE_TAG_VALUES:
                raise ValueError("Tags must use supported options.")
            if normalized not in cleaned:
                cleaned.append(normalized)
        if len(cleaned) > MAX_SOURCE_TAGS:
            raise ValueError(f"A maximum of {MAX_SOURCE_TAGS} tags is allowed.")
        return cleaned


class SourceResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    rss_url: str
    site_url: str
    title: str
    description: str | None
    favicon_url: str | None
    language: str | None
    type: str | None
    categories: list[str]
    tags: list[str]
    status: str
    status_reason: str | None
    registered_by: str
    registered_at: datetime
    last_fetched_at: datetime | None
    last_published_at: datetime | None


class SourceListResponse(BaseModel):
    items: list[SourceResponse]
    page: int
    limit: int
    total: int


class SourceValidateResponse(BaseModel):
    valid: bool
    rss_url: str
    site_url: str
    title: str
    description: str | None
    favicon_url: str | None
    language: str | None
    type: str | None
    categories: list[str]
    tags: list[str]
    feed_format: str | None


class SourceStatusResponse(BaseModel):
    source_id: str
    last_fetched_at: datetime | None
    last_published_at: datetime | None
    consecutive_fail_count: int
    fetch_interval_minutes: int
    is_stale: bool


class StatsResponse(BaseModel):
    total_sources: int
    active_sources: int
    total_feeds: int
    feeds_last_24h: int
