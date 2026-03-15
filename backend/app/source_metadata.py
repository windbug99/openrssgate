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
    "ai",
    "tech",
    "developer-tools",
    "business",
    "finance",
    "crypto",
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
    "government",
    "security",
    "environment",
    "media",
    "real-estate",
    "shopping",
    "legal",
    "industry",
    "other",
)

SOURCE_TAG_OPTIONS = (
    "ai",
    "agents",
    "llm",
    "robotics",
    "big-data",
    "blockchain",
    "bioinformatics",
    "opensource",
    "startup",
    "venture-capital",
    "investing",
    "economy",
    "research",
    "crypto",
    "fintech",
    "semiconductor",
    "hardware",
    "infrastructure",
    "embedded",
    "iot",
    "xr",
    "enterprise",
    "engineering",
    "programming",
    "programming-languages",
    "developer-tools",
    "webdev",
    "mobile",
    "backend",
    "frontend",
    "devops",
    "cloud",
    "cybersecurity",
    "privacy",
    "data",
    "machine-learning",
    "nlp",
    "biotech",
    "healthtech",
    "climate",
    "energy",
    "sustainable-tech",
    "product",
    "ux",
    "ecommerce",
    "marketing",
    "creator-economy",
    "social-media",
    "policy",
    "government",
    "legal",
    "media",
    "healthcare",
    "education",
    "mobility",
    "consumer",
    "gaming",
    "space",
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
    "breaking-news",
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
