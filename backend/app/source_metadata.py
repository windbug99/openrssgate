from __future__ import annotations

from sqlalchemy import String, func

LANGUAGE_OPTIONS = (
    "en",
    "zh",
    "es",
    "ar",
    "pt",
    "ru",
    "ja",
    "de",
    "fr",
    "ko",
    "hi",
    "id",
    "tr",
    "other",
)

SOURCE_TYPE_OPTIONS = (
    "blog",
    "news",
    "magazine",
    "newsletter",
    "podcast",
    "forum",
    "documentation",
    "research",
    "video",
    "other",
)

SOURCE_CATEGORY_OPTIONS = (
    "tech",
    "business",
    "finance",
    "science",
    "health",
    "education",
    "design",
    "culture",
    "entertainment",
    "gaming",
    "sports",
    "lifestyle",
    "travel",
    "food",
    "fashion",
    "hobby",
    "automotive",
    "politics",
    "security",
    "environment",
    "media",
    "other",
)

SOURCE_TAG_OPTIONS = (
    "ai",
    "opensource",
    "startup",
    "investing",
    "economy",
    "programming",
    "webdev",
    "mobile",
    "backend",
    "frontend",
    "devops",
    "cloud",
    "cybersecurity",
    "data",
    "machine-learning",
    "product",
    "ux",
    "marketing",
    "leadership",
    "career",
    "productivity",
    "analysis",
    "tutorial",
    "opinion",
    "review",
    "interview",
    "curation",
    "daily",
    "weekly",
    "local",
    "global",
    "beginner",
    "advanced",
    "other",
)

MAX_SOURCE_CATEGORIES = 2
MAX_SOURCE_TAGS = 3

LANGUAGE_VALUES = set(LANGUAGE_OPTIONS)
SOURCE_TYPE_VALUES = set(SOURCE_TYPE_OPTIONS)
SOURCE_CATEGORY_VALUES = set(SOURCE_CATEGORY_OPTIONS)
SOURCE_TAG_VALUES = set(SOURCE_TAG_OPTIONS)


def parse_csv(value: str | None) -> list[str]:
    if not value:
        return []
    return [item for item in (part.strip() for part in value.split(",")) if item]


def join_csv(values: list[str]) -> str | None:
    items = [value.strip() for value in values if value.strip()]
    return ",".join(items) if items else None


def csv_contains(column: String, value: str):
    wrapped = "," + func.coalesce(column, "") + ","
    return wrapped.ilike(f"%,{value},%")
