from __future__ import annotations

from datetime import datetime

from pydantic import BaseModel, Field, field_validator

from app.source_metadata import LANGUAGE_VALUES, MAX_SOURCE_CATEGORIES, MAX_SOURCE_TAGS, SOURCE_CATEGORY_VALUES, SOURCE_TAG_VALUES, SOURCE_TYPE_VALUES


class AdminLoginRequest(BaseModel):
    email: str = Field(min_length=3, max_length=255)
    password: str = Field(min_length=8, max_length=255)
    otp_code: str | None = Field(default=None, min_length=6, max_length=8)
    recovery_code: str | None = Field(default=None, min_length=5, max_length=32)


class AdminSessionResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    requires_totp_setup: bool
    user: "AdminUserResponse"


class AdminUserResponse(BaseModel):
    id: str
    email: str
    totp_enabled: bool
    last_login_at: datetime | None


class AdminTotpSetupResponse(BaseModel):
    secret: str
    otpauth_url: str
    manual_entry_key: str


class AdminTotpVerifyRequest(BaseModel):
    code: str = Field(min_length=6, max_length=8)


class AdminRecoveryCodesResponse(BaseModel):
    recovery_codes: list[str]


class AdminTotpVerifyResponse(BaseModel):
    user: AdminUserResponse
    recovery_codes: list[str]


class AdminSourceStatusUpdateRequest(BaseModel):
    status: str = Field(pattern="^(active|hidden|rejected)$")
    reason: str | None = Field(default=None, max_length=255)


class AdminSourceResponse(BaseModel):
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
    registered_at: datetime
    last_fetched_at: datetime | None
    last_published_at: datetime | None
    consecutive_fail_count: int
    ai_reviewed_at: datetime | None
    ai_review_source: str | None
    ai_review_reason: str | None
    ai_review_confidence: str | None
    ai_review_decision: str | None


class AdminSourceListResponse(BaseModel):
    items: list[AdminSourceResponse]
    page: int
    limit: int
    total: int


class AdminSourceUpdateRequest(BaseModel):
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


class AdminAuditLogResponse(BaseModel):
    id: str
    admin_user_email: str | None
    source_id: str | None
    source_title: str | None
    action: str
    reason: str | None
    from_status: str | None
    to_status: str | None
    created_at: datetime


class AdminAuditLogListResponse(BaseModel):
    items: list[AdminAuditLogResponse]
