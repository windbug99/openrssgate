from __future__ import annotations

import json
from dataclasses import dataclass
from datetime import UTC, datetime
from typing import Any

import httpx

from app.core.config import get_settings
from app.services.review import ReviewDecision, review_source_bundle
from app.services.source_autofill import _extract_json_object, _trim_sample, select_autofill_samples


AI_REVIEW_ELIGIBLE_REASONS = {
    "spam_like_title",
    "too_few_entries",
    "repetitive_entry_titles",
    "missing_published_dates",
    "stale_feed",
}
AI_REVIEW_ALLOWED_CONFIDENCE = {"low", "medium", "high"}


@dataclass(frozen=True)
class SourceReviewResult:
    initial_decision: ReviewDecision
    final_decision: ReviewDecision
    review_source: str
    ai_review_reason: str | None = None
    ai_review_confidence: str | None = None


def _duplicate_title_ratio(entries: list[dict[str, object]]) -> float:
    titles = [str(entry.get("title") or "").strip().lower() for entry in entries if str(entry.get("title") or "").strip()]
    if not titles:
        return 0.0
    return 1 - (len(set(titles)) / len(titles))


def _missing_published_ratio(entries: list[dict[str, object]]) -> float:
    if not entries:
        return 0.0
    missing_count = sum(1 for entry in entries if entry.get("published_at") is None)
    return missing_count / len(entries)


def _latest_published_at(entries: list[dict[str, object]]) -> str | None:
    valid_published = [published_at for published_at in (entry.get("published_at") for entry in entries) if isinstance(published_at, datetime)]
    if not valid_published:
        return None
    latest_published = max(valid_published)
    latest_published_utc = (
        latest_published if latest_published.tzinfo else latest_published.replace(tzinfo=UTC)
    ).astimezone(UTC)
    return latest_published_utc.isoformat()


def should_ai_review(decision: ReviewDecision) -> bool:
    return decision.status in {"hidden", "rejected"} and decision.reason in AI_REVIEW_ELIGIBLE_REASONS


def build_validate_message(
    result: SourceReviewResult,
) -> str:
    final_decision = result.final_decision
    initial_decision = result.initial_decision
    reason_messages = {
        "spam_like_title": "자동 검토 결과 스팸성 소스로 판단되었습니다.",
        "no_feed_entries": "자동 검토 결과 피드 엔트리가 없어 등록 대상이 아닙니다.",
        "too_few_entries": "자동 검토 결과 엔트리가 너무 적어 공개 보류 대상으로 판단되었습니다.",
        "repetitive_entry_titles": "자동 검토 결과 엔트리 제목 패턴이 반복적이라 공개 보류 대상으로 판단되었습니다.",
        "missing_published_dates": "자동 검토 결과 발행일 정보가 부족해 공개 보류 대상으로 판단되었습니다.",
        "stale_feed": "자동 검토 결과 장기간 업데이트되지 않은 소스로 판단되었습니다.",
        "auto_approved": "등록 가능한 RSS로 확인되었습니다.",
    }

    if final_decision.status == "active":
        if initial_decision.status != "active" and result.review_source == "ai":
            return "초기 자동 검토에서는 보류 대상이었지만, AI 재검토 결과 등록 가능한 정상 소스로 판단되었습니다."
        return "등록 가능한 RSS로 확인되었습니다."

    base_message = reason_messages.get(final_decision.reason, "자동 검토 결과 등록 보류 또는 거절 대상으로 판단되었습니다.")
    if result.review_source == "ai":
        return f"{base_message} AI 재검토 후에도 이 결과가 유지되었습니다."
    if result.review_source == "rule_fallback":
        return f"{base_message} AI 재검토는 완료되지 않아 1차 검증 결과를 표시합니다."
    return base_message


def _normalize_ai_review_result(payload: dict[str, Any], initial_decision: ReviewDecision) -> dict[str, str | bool | None]:
    should_override = bool(payload.get("should_override"))
    recommended_status = str(payload.get("recommended_status") or "").strip().lower()
    confidence = str(payload.get("confidence") or "").strip().lower()
    reason = str(payload.get("reason") or "").strip() or None

    allowed_statuses = {"active", initial_decision.status}
    if recommended_status not in allowed_statuses:
        recommended_status = initial_decision.status
    if confidence not in AI_REVIEW_ALLOWED_CONFIDENCE:
        confidence = "low"

    return {
        "should_override": should_override,
        "recommended_status": recommended_status,
        "confidence": confidence,
        "reason": reason,
    }


async def _request_gemini_review(payload: dict[str, Any], initial_decision: ReviewDecision) -> dict[str, str | bool | None]:
    settings = get_settings()
    if not settings.gemini_api_key:
        raise ValueError("Gemini API key is not configured.")

    prompt = {
        "task": "Review whether a rule-based moderation decision for an RSS source should be overridden.",
        "allowed_statuses": ["active", initial_decision.status],
        "rules": [
            "Return strict JSON only.",
            "Use active only when the source is clearly legitimate and the rule-based decision should be overridden.",
            "If uncertain, keep the original status.",
            "Base the decision only on the provided metadata, samples, and rule-based signals.",
        ],
        "response_schema": {
            "should_override": "boolean",
            "recommended_status": "active or original status only",
            "confidence": "low | medium | high",
            "reason": "short English sentence",
        },
        "source": payload,
    }

    url = f"https://generativelanguage.googleapis.com/v1beta/models/{settings.gemini_model}:generateContent"
    async with httpx.AsyncClient(timeout=settings.gemini_timeout_seconds) as client:
        response = await client.post(
            url,
            params={"key": settings.gemini_api_key},
            json={
                "contents": [{"parts": [{"text": json.dumps(prompt, ensure_ascii=True)}]}],
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
    return _normalize_ai_review_result(_extract_json_object(text), initial_decision)


async def review_source_bundle_with_ai(
    metadata: dict[str, object],
    entries: list[dict[str, object]],
    *,
    duplicate_site_url_exists: bool = False,
) -> SourceReviewResult:
    initial_decision = review_source_bundle(
        metadata=metadata,
        entries=entries,
        duplicate_site_url_exists=duplicate_site_url_exists,
    )
    if not should_ai_review(initial_decision):
        return SourceReviewResult(
            initial_decision=initial_decision,
            final_decision=initial_decision,
            review_source="rule",
        )

    samples = select_autofill_samples(entries, target_count=5, fallback_count=5)
    payload = {
        "rss_url": str(metadata.get("rss_url") or "").strip(),
        "site_url": str(metadata.get("site_url") or "").strip(),
        "title": str(metadata.get("title") or "").strip(),
        "description": str(metadata.get("description") or "").strip() or None,
        "feed_format": str(metadata.get("feed_format") or "").strip() or None,
        "initial_review": {
            "status": initial_decision.status,
            "reason": initial_decision.reason,
        },
        "signals": {
            "entry_count": len(entries),
            "duplicate_title_ratio": round(_duplicate_title_ratio(entries), 3),
            "missing_published_ratio": round(_missing_published_ratio(entries), 3),
            "latest_published_at": _latest_published_at(entries),
        },
        "samples": [_trim_sample(entry) for entry in samples],
    }

    try:
        ai_result = await _request_gemini_review(payload, initial_decision)
    except Exception:
        return SourceReviewResult(
            initial_decision=initial_decision,
            final_decision=initial_decision,
            review_source="rule_fallback",
        )

    final_decision = initial_decision
    if (
        ai_result["should_override"]
        and ai_result["recommended_status"] == "active"
        and ai_result["confidence"] == "high"
    ):
        final_decision = ReviewDecision(status="active", reason="ai_override")

    return SourceReviewResult(
        initial_decision=initial_decision,
        final_decision=final_decision,
        review_source="ai",
        ai_review_reason=str(ai_result["reason"] or "") or None,
        ai_review_confidence=str(ai_result["confidence"] or "") or None,
    )
