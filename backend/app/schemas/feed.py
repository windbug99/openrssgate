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
