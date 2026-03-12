from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field, HttpUrl, field_validator


class SourceCreate(BaseModel):
    rss_url: HttpUrl
    language: str | None = Field(default=None, max_length=16)
    category: str | None = Field(default=None, max_length=32)
    tags: list[str] = Field(default_factory=list, max_length=5)

    @field_validator("tags")
    @classmethod
    def validate_tags(cls, value: list[str]) -> list[str]:
        cleaned = [tag.strip() for tag in value if tag.strip()]
        if len(cleaned) > 5:
            raise ValueError("A maximum of 5 tags is allowed.")
        for tag in cleaned:
            if len(tag) > 20:
                raise ValueError("Each tag must be 20 characters or fewer.")
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
    category: str | None
    tags: list[str]
    status: str
    registered_by: str
    registered_at: datetime
    last_fetched_at: datetime | None
    last_published_at: datetime | None


class SourceListResponse(BaseModel):
    items: list[SourceResponse]
    page: int
    limit: int
    total: int
