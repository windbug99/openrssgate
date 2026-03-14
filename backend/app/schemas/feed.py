from datetime import datetime

from pydantic import BaseModel, ConfigDict


class FeedResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    source_id: str
    guid: str
    title: str
    feed_url: str
    published_at: datetime | None


class FeedListResponse(BaseModel):
    items: list[FeedResponse]
    page: int
    limit: int
    total: int


class FeedSourceSummary(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    site_url: str
    rss_url: str
    language: str | None
    type: str | None
    categories: list[str]
    tags: list[str]


class FeedDetailResponse(BaseModel):
    id: str
    source_id: str
    guid: str
    title: str
    feed_url: str
    published_at: datetime | None
    source: FeedSourceSummary
