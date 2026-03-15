from __future__ import annotations

import json
import re
from collections.abc import Iterable
from datetime import UTC, datetime
from typing import Any
from urllib.parse import urlparse

import httpx

from app.core.config import get_settings
from app.source_metadata import (
    LANGUAGE_VALUES,
    MAX_SOURCE_CATEGORIES,
    MAX_SOURCE_TAGS,
    SOURCE_CATEGORY_VALUES,
    SOURCE_TAG_VALUES,
    SOURCE_TYPE_VALUES,
)


TAG_KEYWORDS: dict[str, tuple[str, ...]] = {
    "ai": ("artificial intelligence", "openai", "anthropic", "ai ", " ai", "gpt", "genai"),
    "agents": ("agentic", "ai agent", "agents", "autonomous agent"),
    "llm": ("large language model", "language model", "llm", "foundation model"),
    "robotics": ("robot", "robotics", "automation robot", "humanoid"),
    "big-data": ("big data", "data lake", "data platform", "data pipeline"),
    "blockchain": ("blockchain", "smart contract", "web3", "distributed ledger"),
    "bioinformatics": ("bioinformatics", "computational biology", "genome analysis", "proteomics"),
    "opensource": ("open source", "opensource", "oss"),
    "startup": ("startup", "founder", "seed round", "series a", "venture-backed"),
    "venture-capital": ("venture capital", "vc", "funding round", "term sheet"),
    "investing": ("investing", "investor", "portfolio", "equity research", "stocks"),
    "economy": ("economy", "economic", "macro", "inflation", "gdp"),
    "research": ("research", "study", "paper", "preprint", "journal"),
    "crypto": ("crypto", "bitcoin", "ethereum", "solana", "defi", "blockchain"),
    "fintech": ("fintech", "payments", "digital bank", "banking tech"),
    "semiconductor": ("semiconductor", "chip", "wafer", "foundry", "tsmc", "nvidia"),
    "hardware": ("hardware", "server hardware", "gpu", "cpu", "computer components"),
    "infrastructure": ("infrastructure", "data center", "networking", "server fleet", "it infrastructure"),
    "embedded": ("embedded", "firmware", "microcontroller", "rtos", "embedded systems"),
    "iot": ("internet of things", "iot", "smart device", "connected device"),
    "xr": ("spatial computing", "extended reality", "augmented reality", "virtual reality", "mixed reality", "xr"),
    "enterprise": ("enterprise", "b2b", "saas", "cio", "workflow software"),
    "engineering": ("software architecture", "system design", "engineering org", "reliability engineering"),
    "programming": ("programming", "coding", "software development", "software engineer"),
    "programming-languages": ("programming language", "compiler", "rust", "go language", "python language", "java language"),
    "developer-tools": ("developer tools", "devtools", "sdk", "framework", "tooling", "build tool"),
    "webdev": ("javascript", "typescript", "react", "css", "html", "webdev"),
    "mobile": ("mobile", "ios", "android", "swift", "kotlin"),
    "backend": ("backend", "api", "server", "microservice", "database scaling"),
    "frontend": ("frontend", "ui", "design system", "client-side"),
    "devops": ("devops", "sre", "infrastructure", "ci/cd", "platform engineering"),
    "cloud": ("cloud", "aws", "gcp", "azure", "kubernetes"),
    "cybersecurity": ("cybersecurity", "infosec", "security breach", "threat intelligence"),
    "privacy": ("privacy", "data protection", "tracking", "surveillance"),
    "data": ("data", "analytics", "database", "warehouse", "etl"),
    "machine-learning": ("machine learning", "deep learning", "neural network", "model training"),
    "nlp": ("natural language processing", "nlp", "speech recognition", "text generation", "language understanding"),
    "biotech": ("biotech", "genomics", "drug discovery", "bioengineering"),
    "healthtech": ("healthtech", "digital health", "medical device", "clinical ai"),
    "climate": ("climate", "emissions", "carbon", "sustainability", "climate tech"),
    "energy": ("energy", "battery", "grid", "nuclear", "solar", "wind power"),
    "sustainable-tech": ("sustainable tech", "green computing", "energy efficient computing", "low carbon software"),
    "product": ("product management", "product strategy", "roadmap", "product team"),
    "ux": ("ux", "user experience", "interaction design", "design research"),
    "ecommerce": ("ecommerce", "retail tech", "shopify", "marketplace", "online store"),
    "marketing": ("marketing", "growth", "seo", "demand gen", "brand strategy"),
    "creator-economy": ("creator economy", "creator business", "substack", "patreon", "youtube creator"),
    "social-media": ("social media", "tiktok", "instagram", "social platform", "creator platform"),
    "policy": ("policy", "regulation", "antitrust", "compliance", "public policy"),
    "government": ("government", "public sector", "agency", "municipal", "federal"),
    "legal": ("legal", "law", "court", "litigation", "regulatory filing"),
    "media": ("media business", "publishing", "newsroom", "streaming business", "media industry"),
    "healthcare": ("healthcare", "hospital", "clinical care", "patient care", "medical practice"),
    "education": ("education", "edtech", "curriculum", "classroom", "higher education"),
    "mobility": ("mobility", "transportation", "ride hailing", "ev platform", "autonomous driving"),
    "consumer": ("consumer tech", "consumer behavior", "household spending", "consumer app"),
    "gaming": ("gaming", "game engine", "esports", "game development", "video games"),
    "space": ("space", "satellite", "launch vehicle", "orbital", "aerospace"),
    "leadership": ("leadership", "management", "executive", "organizational"),
    "career": ("career", "hiring", "job market", "interview prep"),
    "productivity": ("productivity", "workflow", "habits", "time management"),
    "analysis": ("analysis", "deep dive", "breakdown", "explainer"),
    "tutorial": ("tutorial", "guide", "how to", "walkthrough"),
    "opinion": ("opinion", "essay", "commentary", "perspective"),
    "review": ("review", "hands-on", "benchmark", "tested"),
    "interview": ("interview", "q&a", "conversation with"),
    "curation": ("curation", "roundup", "must-read", "reading list"),
    "daily": ("daily", "every day", "morning brief"),
    "weekly": ("weekly", "this week", "week in review"),
    "local": ("local", "city hall", "regional", "community news"),
    "global": ("global", "international", "worldwide", "geopolitics"),
    "breaking-news": ("breaking", "developing story", "live updates"),
    "beginner": ("beginner", "intro", "getting started", "for newcomers"),
    "advanced": ("advanced", "expert", "deep technical", "internals"),
}

TYPE_KEYWORDS: dict[str, tuple[str, ...]] = {
    "newsletter": ("newsletter", "weekly digest", "daily digest", "substack"),
    "podcast": ("podcast", "episode", "listen", "audio show"),
    "forum": ("forum", "community thread", "discussion board", "ask hn"),
    "documentation": ("documentation", "reference", "release notes", "docs"),
    "research": ("research", "paper", "preprint", "journal", "study"),
    "video": ("video", "youtube", "livestream", "watch"),
    "news": ("news", "breaking", "reporter", "coverage"),
    "magazine": ("magazine", "feature story", "editorial", "column"),
    "blog": ("blog", "post", "engineering blog", "personal site"),
}

CATEGORY_KEYWORDS: dict[str, tuple[str, ...]] = {
    "ai": ("artificial intelligence", "ai ", " ai", "gpt", "llm", "agentic"),
    "tech": ("software", "engineering", "developer", "startup tech", "computing"),
    "developer-tools": ("framework", "sdk", "api platform", "tooling", "developer tools"),
    "business": ("business", "strategy", "management", "operations"),
    "finance": ("finance", "markets", "capital", "investment"),
    "crypto": ("crypto", "bitcoin", "ethereum", "blockchain"),
    "science": ("science", "scientific", "research lab", "peer reviewed"),
    "health": ("health", "medical", "clinical", "wellness"),
    "education": ("education", "learning", "teaching", "curriculum"),
    "design": ("design", "ux", "ui", "creative process"),
    "culture": ("culture", "society", "books", "arts"),
    "entertainment": ("entertainment", "film", "tv", "celebrity"),
    "gaming": ("gaming", "game", "esports"),
    "sports": ("sports", "nba", "nfl", "soccer", "baseball"),
    "lifestyle": ("lifestyle", "personal growth", "home life"),
    "travel": ("travel", "trip", "aviation", "destination"),
    "food": ("food", "restaurant", "recipe", "cooking"),
    "fashion": ("fashion", "beauty", "luxury"),
    "hobby": ("hobby", "craft", "maker", "collecting"),
    "automotive": ("automotive", "car", "ev", "transportation"),
    "politics": ("politics", "election", "campaign", "legislature"),
    "government": ("government", "public sector", "regulator", "agency"),
    "security": ("security", "cybersecurity", "privacy", "threat"),
    "environment": ("environment", "climate", "conservation", "energy transition"),
    "media": ("media", "publishing", "journalism", "creator"),
    "real-estate": ("real estate", "housing", "property", "mortgage"),
    "shopping": ("shopping", "retail", "commerce", "consumer brand"),
    "legal": ("legal", "law", "court", "compliance"),
    "industry": ("manufacturing", "supply chain", "industrial", "semiconductor"),
}

CATEGORY_TAG_MAP: dict[str, tuple[str, ...]] = {
    "ai": ("ai", "agents", "llm", "machine-learning", "robotics", "nlp"),
    "tech": ("engineering", "programming", "cloud", "infrastructure", "data"),
    "developer-tools": ("developer-tools", "programming-languages", "programming", "embedded", "webdev"),
    "business": ("startup", "enterprise", "venture-capital", "leadership", "marketing"),
    "finance": ("investing", "economy", "fintech", "venture-capital"),
    "crypto": ("crypto", "blockchain", "investing", "policy"),
    "science": ("research", "bioinformatics", "biotech", "space", "climate"),
    "health": ("healthcare", "healthtech", "biotech", "bioinformatics"),
    "education": ("education", "tutorial", "beginner", "career"),
    "design": ("ux", "product", "consumer"),
    "culture": ("media", "opinion", "analysis", "interview"),
    "entertainment": ("media", "creator-economy", "review", "interview"),
    "gaming": ("gaming", "xr", "review", "analysis"),
    "sports": ("gaming", "analysis", "daily", "breaking-news"),
    "lifestyle": ("consumer", "productivity", "opinion", "review"),
    "travel": ("mobility", "review", "local", "global"),
    "food": ("consumer", "review", "local", "opinion"),
    "fashion": ("consumer", "creator-economy", "review", "analysis"),
    "hobby": ("tutorial", "review", "beginner", "iot"),
    "automotive": ("mobility", "hardware", "energy", "review"),
    "politics": ("policy", "government", "analysis", "breaking-news"),
    "government": ("government", "policy", "analysis", "local"),
    "security": ("cybersecurity", "privacy", "infrastructure", "analysis"),
    "environment": ("climate", "energy", "sustainable-tech", "analysis"),
    "media": ("media", "creator-economy", "social-media", "analysis"),
    "real-estate": ("consumer", "investing", "analysis", "local"),
    "shopping": ("ecommerce", "consumer", "review", "analysis"),
    "legal": ("legal", "policy", "government", "opinion"),
    "industry": ("hardware", "semiconductor", "infrastructure", "enterprise"),
}

LANGUAGE_PATTERNS: dict[str, str] = {
    "ko": r"[\uac00-\ud7af]",
    "ja": r"[\u3040-\u30ff]",
    "zh": r"[\u4e00-\u9fff]",
    "ar": r"[\u0600-\u06ff]",
    "ru": r"[\u0400-\u04ff]",
    "hi": r"[\u0900-\u097f]",
}


def _clean_text(value: object | None) -> str:
    text = str(value or "")
    text = re.sub(r"<[^>]+>", " ", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def _combined_text(metadata: dict[str, object], entries: Iterable[dict[str, object]]) -> str:
    parts = [
        _clean_text(metadata.get("title")),
        _clean_text(metadata.get("description")),
        _clean_text(metadata.get("site_url")),
    ]
    for entry in entries:
        parts.extend(
            [
                _clean_text(entry.get("title")),
                _clean_text(entry.get("summary")),
                _clean_text(entry.get("content_text")),
            ]
        )
    return " ".join(part.lower() for part in parts if part)


def _contains_keyword(text: str, keyword: str) -> bool:
    escaped = re.escape(keyword.strip().lower())
    if not escaped:
        return False
    return re.search(rf"(?<!\w){escaped}(?!\w)", text.lower()) is not None


def detect_tags_from_text(text: str) -> list[str]:
    lowered = text.lower()
    matches: list[str] = []
    for tag, keywords in TAG_KEYWORDS.items():
        if tag not in SOURCE_TAG_VALUES:
            continue
        if any(_contains_keyword(lowered, keyword) for keyword in keywords):
            matches.append(tag)
        if len(matches) >= MAX_SOURCE_TAGS:
            break
    return matches


def _infer_type_from_text(text: str, site_url: str) -> tuple[str | None, str, str]:
    host = (urlparse(site_url).hostname or "").lower()
    lowered = f"{text.lower()} {host}"
    host_hints = {
        "newsletter": ("substack.com", "beehiiv.com", "buttondown.email"),
        "video": ("youtube.com", "vimeo.com"),
        "podcast": ("podbean.com", "buzzsprout.com", "simplecast.com"),
        "documentation": ("docs.", "developer.", "reference."),
    }
    for source_type, hosts in host_hints.items():
        if any(host.startswith(item) or item in host for item in hosts):
            return source_type, "high", f"host pattern matched {source_type}"

    for source_type, keywords in TYPE_KEYWORDS.items():
        if source_type not in SOURCE_TYPE_VALUES:
            continue
        if any(_contains_keyword(lowered, keyword) for keyword in keywords):
            confidence = "high" if source_type in {"newsletter", "podcast", "documentation"} else "medium"
            return source_type, confidence, f"keyword pattern matched {source_type}"
    return None, "low", "not enough type evidence"


def _infer_language(metadata: dict[str, object], text: str) -> tuple[str | None, str, str]:
    metadata_language = _clean_text(metadata.get("language")).lower()
    if metadata_language in LANGUAGE_VALUES:
        return metadata_language, "high", "feed metadata provided language"

    for code, pattern in LANGUAGE_PATTERNS.items():
        if re.search(pattern, text):
            return code, "medium", f"detected {code} script in metadata or samples"

    if re.search(r"[a-z]{3,}", text):
        return "en", "low", "defaulted to English based on latin text"
    return None, "low", "not enough language evidence"


def _infer_categories(text: str, tags: list[str], source_type: str | None) -> tuple[list[str], str, str]:
    lowered = text.lower()
    matches: list[str] = []
    for category, keywords in CATEGORY_KEYWORDS.items():
        if category not in SOURCE_CATEGORY_VALUES:
            continue
        if any(_contains_keyword(lowered, keyword) for keyword in keywords):
            matches.append(category)
        if len(matches) >= MAX_SOURCE_CATEGORIES:
            break

    if len(matches) < MAX_SOURCE_CATEGORIES:
        for category, mapped_tags in CATEGORY_TAG_MAP.items():
            if category not in SOURCE_CATEGORY_VALUES or category in matches:
                continue
            if any(tag in tags for tag in mapped_tags):
                matches.append(category)
            if len(matches) >= MAX_SOURCE_CATEGORIES:
                break

    if not matches and source_type in {"documentation", "research"}:
        matches = ["developer-tools" if source_type == "documentation" else "science"]

    confidence = "high" if len(matches) >= 2 else "medium" if matches else "low"
    reason = "matched category keywords or tag mappings" if matches else "not enough category evidence"
    return matches[:MAX_SOURCE_CATEGORIES], confidence, reason


def _normalize_title(title: str) -> str:
    normalized = re.sub(r"^\[[^\]]+\]\s*", "", title.lower())
    normalized = re.sub(r"[^a-z0-9\u00c0-\u024f\u0400-\u04ff\u0600-\u06ff\u0900-\u097f\u3040-\u30ff\u4e00-\u9fff\s]", " ", normalized)
    normalized = re.sub(r"\s+", " ", normalized)
    return normalized.strip()


def _score_entry(entry: dict[str, object], index: int) -> tuple[int, int, int]:
    title = _clean_text(entry.get("title"))
    summary = _clean_text(entry.get("summary")) or _clean_text(entry.get("content_text"))
    return (
        1 if summary else 0,
        min(len(title), 120),
        -index,
    )


def select_autofill_samples(entries: list[dict[str, object]], target_count: int = 3, fallback_count: int = 5) -> list[dict[str, object]]:
    filtered = [entry for entry in entries if _clean_text(entry.get("title"))]
    ranked = sorted(
        enumerate(filtered),
        key=lambda item: (
            item[1].get("published_at") if isinstance(item[1].get("published_at"), datetime) else datetime.min.replace(tzinfo=UTC),
            *_score_entry(item[1], item[0]),
        ),
        reverse=True,
    )
    ranked_entries = [entry for _, entry in ranked]

    selected: list[dict[str, object]] = []
    seen_titles: set[str] = set()

    for entry in ranked_entries:
        title = _normalize_title(_clean_text(entry.get("title")))
        if len(title) < 8 or title in seen_titles:
            continue
        title_tokens = set(title.split())
        if any(len(title_tokens & set(_normalize_title(_clean_text(item.get("title"))).split())) >= max(3, len(title_tokens) // 2) for item in selected):
            continue
        seen_titles.add(title)
        selected.append(entry)
        if len(selected) >= target_count:
            break

    if len(selected) >= target_count:
        return selected

    for entry in ranked_entries:
        if entry in selected:
            continue
        selected.append(entry)
        if len(selected) >= fallback_count:
            break
    return selected


def _trim_sample(entry: dict[str, object]) -> dict[str, object]:
    summary = _clean_text(entry.get("summary")) or _clean_text(entry.get("content_text"))
    return {
        "title": _clean_text(entry.get("title")),
        "summary": summary[:400] or None,
        "published_at": entry.get("published_at").isoformat() if entry.get("published_at") else None,
        "feed_url": _clean_text(entry.get("feed_url")) or None,
    }


def _extract_json_object(text: str) -> dict[str, Any]:
    fenced = re.search(r"\{.*\}", text, flags=re.DOTALL)
    if not fenced:
        raise ValueError("No JSON object found in Gemini response.")
    data = json.loads(fenced.group(0))
    if not isinstance(data, dict):
        raise ValueError("Gemini response was not a JSON object.")
    return data


def _normalize_llm_selection(payload: dict[str, Any]) -> dict[str, Any]:
    language = _clean_text(payload.get("language")).lower() or None
    source_type = _clean_text(payload.get("type")).lower() or None
    categories = [
        item
        for item in dict.fromkeys(_clean_text(item).lower() for item in payload.get("categories", []) if _clean_text(item))
        if item in SOURCE_CATEGORY_VALUES
    ][:MAX_SOURCE_CATEGORIES]
    tags = [
        item
        for item in dict.fromkeys(_clean_text(item).lower() for item in payload.get("tags", []) if _clean_text(item))
        if item in SOURCE_TAG_VALUES
    ][:MAX_SOURCE_TAGS]

    return {
        "language": language if language in LANGUAGE_VALUES else None,
        "type": source_type if source_type in SOURCE_TYPE_VALUES else None,
        "categories": categories,
        "tags": tags,
    }


async def _request_gemini_autofill(payload: dict[str, Any]) -> dict[str, Any]:
    settings = get_settings()
    if not settings.gemini_api_key:
        raise ValueError("Gemini API key is not configured.")

    prompt = {
        "task": "Classify this RSS source using only the allowed values.",
        "allowed_language_values": sorted(LANGUAGE_VALUES),
        "allowed_type_values": sorted(SOURCE_TYPE_VALUES),
        "allowed_category_values": sorted(SOURCE_CATEGORY_VALUES),
        "allowed_tag_values": sorted(SOURCE_TAG_VALUES),
        "rules": [
            "Return strict JSON only.",
            f"Choose at most {MAX_SOURCE_CATEGORIES} categories.",
            f"Choose at most {MAX_SOURCE_TAGS} tags.",
            "If unsure, use 'other' only when it is the best available option.",
        ],
        "source": payload,
    }

    url = f"https://generativelanguage.googleapis.com/v1beta/models/{settings.gemini_model}:generateContent"
    async with httpx.AsyncClient(timeout=settings.gemini_timeout_seconds) as client:
        response = await client.post(
            url,
            params={"key": settings.gemini_api_key},
            json={
                "contents": [
                    {
                        "parts": [
                            {
                                "text": json.dumps(prompt, ensure_ascii=True),
                            }
                        ]
                    }
                ],
                "generationConfig": {
                    "temperature": 0.1,
                    "responseMimeType": "application/json",
                },
            },
        )
        response.raise_for_status()
        data = response.json()

    candidates = data.get("candidates") or []
    if not candidates:
        raise ValueError("Gemini returned no candidates.")
    parts = candidates[0].get("content", {}).get("parts", [])
    text = "".join(str(part.get("text") or "") for part in parts if isinstance(part, dict))
    return _normalize_llm_selection(_extract_json_object(text))


async def autofill_source_metadata(bundle: dict[str, object]) -> dict[str, Any]:
    metadata = bundle.get("metadata", {})
    entries = bundle.get("entries", [])
    if not isinstance(metadata, dict):
        metadata = {}
    if not isinstance(entries, list):
        entries = []

    initial_samples = select_autofill_samples(entries, target_count=3, fallback_count=5)
    text = _combined_text(metadata, initial_samples)

    language, language_confidence, language_reason = _infer_language(metadata, text)
    source_type, type_confidence, type_reason = _infer_type_from_text(text, _clean_text(metadata.get("site_url")))
    tags = detect_tags_from_text(text)
    categories, categories_confidence, categories_reason = _infer_categories(text, tags, source_type)
    tag_confidence = "high" if len(tags) >= 2 else "medium" if tags else "low"
    tag_reason = "matched tag keywords in metadata and samples" if tags else "not enough tag evidence"

    result = {
        "language": language,
        "type": source_type,
        "categories": categories,
        "tags": tags[:MAX_SOURCE_TAGS],
        "source": "heuristic",
        "confidence": {
            "language": language_confidence,
            "type": type_confidence,
            "categories": categories_confidence,
            "tags": tag_confidence,
        },
        "reasoning": {
            "language": language_reason,
            "type": type_reason,
            "categories": categories_reason,
            "tags": tag_reason,
        },
        "samples_used": len(initial_samples),
    }

    should_call_llm = any(level == "low" for level in result["confidence"].values())
    if not should_call_llm:
        return result

    llm_samples = select_autofill_samples(entries, target_count=5, fallback_count=5)
    llm_payload = {
        "site_url": _clean_text(metadata.get("site_url")),
        "title": _clean_text(metadata.get("title")),
        "description": _clean_text(metadata.get("description")),
        "feed_format": _clean_text(metadata.get("feed_format")),
        "heuristic": {
            "language": language,
            "type": source_type,
            "categories": categories,
            "tags": tags[:MAX_SOURCE_TAGS],
        },
        "samples": [_trim_sample(entry) for entry in llm_samples],
    }

    try:
        llm_result = await _request_gemini_autofill(llm_payload)
    except Exception:
        return result

    merged = {
        "language": llm_result.get("language") or result["language"],
        "type": llm_result.get("type") or result["type"],
        "categories": llm_result.get("categories") or result["categories"],
        "tags": llm_result.get("tags") or result["tags"],
        "source": "mixed",
        "confidence": {
            "language": "high" if llm_result.get("language") else result["confidence"]["language"],
            "type": "high" if llm_result.get("type") else result["confidence"]["type"],
            "categories": "high" if llm_result.get("categories") else result["confidence"]["categories"],
            "tags": "high" if llm_result.get("tags") else result["confidence"]["tags"],
        },
        "reasoning": {
            "language": "Gemini autofill suggestion" if llm_result.get("language") else result["reasoning"]["language"],
            "type": "Gemini autofill suggestion" if llm_result.get("type") else result["reasoning"]["type"],
            "categories": "Gemini autofill suggestion" if llm_result.get("categories") else result["reasoning"]["categories"],
            "tags": "Gemini autofill suggestion" if llm_result.get("tags") else result["reasoning"]["tags"],
        },
        "samples_used": len(llm_samples),
    }
    return merged
