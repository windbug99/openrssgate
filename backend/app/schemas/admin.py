from __future__ import annotations

from datetime import datetime

from pydantic import BaseModel, Field


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
