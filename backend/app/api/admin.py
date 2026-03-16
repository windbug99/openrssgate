from __future__ import annotations

from datetime import UTC, datetime

from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy import func, select
from sqlalchemy.orm import Session, selectinload

from app.api.deps import get_session
from app.core.config import get_settings
from app.db.models import AdminAuditLog, AdminSession, AdminUser, Source
from app.schemas.admin import (
    AdminAuditLogListResponse,
    AdminAuditLogResponse,
    AdminLoginRequest,
    AdminRecoveryCodesResponse,
    AdminSessionResponse,
    AdminSourceListResponse,
    AdminSourceResponse,
    AdminSourceStatusUpdateRequest,
    AdminSourceUpdateRequest,
    AdminTotpSetupResponse,
    AdminTotpVerifyRequest,
    AdminTotpVerifyResponse,
    AdminUserResponse,
)
from app.source_metadata import csv_contains, join_csv, parse_csv
from app.services.admin_auth import (
    build_totp_uri,
    create_session_token,
    ensure_bootstrap_admin,
    generate_totp_secret,
    generate_recovery_codes,
    get_admin_session_by_token,
    require_admin_session,
    require_pending_admin_session,
    verify_password,
    verify_and_consume_recovery_code,
    verify_totp_code,
)

router = APIRouter(prefix="/admin", tags=["admin"])


def _set_admin_state_cookie(response: Response, state: str) -> None:
    settings = get_settings()
    response.set_cookie(
        key=settings.admin_state_cookie_name,
        value=state,
        httponly=False,
        secure=settings.admin_session_cookie_secure,
        samesite="lax",
        max_age=max(settings.admin_session_ttl_hours, 1) * 3600,
        path="/",
        domain=settings.admin_cookie_domain,
    )


def _serialize_admin_user(user: AdminUser) -> AdminUserResponse:
    return AdminUserResponse(
        id=user.id,
        email=user.email,
        totp_enabled=user.totp_enabled,
        last_login_at=user.last_login_at,
    )


def _serialize_source(source: Source) -> AdminSourceResponse:
    return AdminSourceResponse(
        id=source.id,
        rss_url=source.rss_url,
        site_url=source.site_url,
        title=source.title,
        description=source.description,
        favicon_url=source.favicon_url,
        language=source.language,
        type=source.source_type,
        categories=parse_csv(source.categories),
        tags=parse_csv(source.tags),
        status=source.status,
        status_reason=source.status_reason,
        registered_at=source.registered_at,
        last_fetched_at=source.last_fetched_at,
        last_published_at=source.last_published_at,
        consecutive_fail_count=source.consecutive_fail_count,
        ai_reviewed_at=source.ai_reviewed_at,
        ai_review_source=source.ai_review_source,
        ai_review_reason=source.ai_review_reason,
        ai_review_confidence=source.ai_review_confidence,
        ai_review_decision=source.ai_review_decision,
    )


def _serialize_audit_log(entry: AdminAuditLog) -> AdminAuditLogResponse:
    return AdminAuditLogResponse(
        id=entry.id,
        admin_user_email=entry.admin_user.email if entry.admin_user else None,
        source_id=entry.source_id,
        source_title=entry.source.title if entry.source else None,
        action=entry.action,
        reason=entry.reason,
        from_status=entry.from_status,
        to_status=entry.to_status,
        created_at=entry.created_at,
    )


@router.post("/auth/login", response_model=AdminSessionResponse)
def login_admin(payload: AdminLoginRequest, response: Response, db: Session = Depends(get_session)) -> AdminSessionResponse:
    ensure_bootstrap_admin(db)
    settings = get_settings()

    user = db.scalar(select(AdminUser).where(AdminUser.email == payload.email.strip().lower()))
    if not user or not verify_password(payload.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "invalid_admin_credentials", "message": "Email or password is invalid."},
        )

    if user.totp_enabled:
        otp_ok = bool(payload.otp_code and user.totp_secret and verify_totp_code(user.totp_secret, payload.otp_code))
        recovery_ok = bool(payload.recovery_code and verify_and_consume_recovery_code(user, payload.recovery_code))
        if not otp_ok and not recovery_ok:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail={"code": "invalid_otp_code", "message": "OTP code or recovery code is invalid."},
            )

    raw_token = create_session_token(db, user)
    session = get_admin_session_by_token(db, raw_token)
    if not session:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail={"code": "admin_session_create_failed", "message": "Admin session could not be created."},
        )

    if user.totp_enabled:
        session.otp_verified_at = datetime.now(UTC)
        user.last_login_at = datetime.now(UTC)
        db.add(session)
        db.add(user)
        db.commit()
        db.refresh(user)

    response.set_cookie(
        key=settings.admin_session_cookie_name,
        value=raw_token,
        httponly=True,
        secure=settings.admin_session_cookie_secure,
        samesite="lax",
        max_age=max(settings.admin_session_ttl_hours, 1) * 3600,
        path="/",
        domain=settings.admin_cookie_domain,
    )
    _set_admin_state_cookie(response, "verified" if user.totp_enabled else "pending")

    return AdminSessionResponse(
        access_token=raw_token,
        requires_totp_setup=not user.totp_enabled,
        user=_serialize_admin_user(user),
    )


@router.get("/auth/me", response_model=AdminUserResponse)
def get_current_admin(user: AdminUser = Depends(require_admin_session)) -> AdminUserResponse:
    return _serialize_admin_user(user)


@router.post("/auth/logout")
def logout_admin(
    response: Response,
    session_data: tuple[AdminUser, AdminSession] = Depends(require_pending_admin_session),
    db: Session = Depends(get_session),
) -> dict[str, str]:
    settings = get_settings()
    _, session = session_data
    if session:
        db.delete(session)
        db.commit()
    response.delete_cookie(key=settings.admin_session_cookie_name, path="/", samesite="lax", domain=settings.admin_cookie_domain)
    response.delete_cookie(key=settings.admin_state_cookie_name, path="/", samesite="lax", domain=settings.admin_cookie_domain)
    return {"status": "ok"}


@router.post("/auth/totp/setup", response_model=AdminTotpSetupResponse)
def setup_totp(
    session_data: tuple[AdminUser, AdminSession] = Depends(require_pending_admin_session),
    db: Session = Depends(get_session),
) -> AdminTotpSetupResponse:
    user, _ = session_data
    if user.totp_enabled and user.totp_secret:
        secret = user.totp_secret
    else:
        secret = generate_totp_secret()
        user.totp_secret = secret
        db.add(user)
        db.commit()
        db.refresh(user)
    otpauth_url = build_totp_uri(user.email, secret)
    return AdminTotpSetupResponse(secret=secret, manual_entry_key=secret, otpauth_url=otpauth_url)


@router.post("/auth/totp/verify", response_model=AdminTotpVerifyResponse)
def verify_totp(
    payload: AdminTotpVerifyRequest,
    response: Response,
    session_data: tuple[AdminUser, AdminSession] = Depends(require_pending_admin_session),
    db: Session = Depends(get_session),
) -> AdminTotpVerifyResponse:
    user, session = session_data
    if not user.totp_secret or not verify_totp_code(user.totp_secret, payload.code):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "invalid_otp_code", "message": "OTP code is invalid."},
        )

    user.totp_enabled = True
    recovery_codes, recovery_codes_hashes = generate_recovery_codes()
    user.recovery_codes_hashes = recovery_codes_hashes
    user.last_login_at = datetime.now(UTC)
    if session:
        session.otp_verified_at = datetime.now(UTC)
        db.add(session)
    db.add(user)
    db.commit()
    db.refresh(user)
    _set_admin_state_cookie(response, "verified")
    return AdminTotpVerifyResponse(user=_serialize_admin_user(user), recovery_codes=recovery_codes)


@router.post("/auth/recovery-codes/regenerate", response_model=AdminRecoveryCodesResponse)
def regenerate_recovery_codes(
    user: AdminUser = Depends(require_admin_session),
    db: Session = Depends(get_session),
) -> AdminRecoveryCodesResponse:
    recovery_codes, recovery_codes_hashes = generate_recovery_codes()
    user.recovery_codes_hashes = recovery_codes_hashes
    db.add(user)
    db.commit()
    return AdminRecoveryCodesResponse(recovery_codes=recovery_codes)


@router.get("/sources", response_model=AdminSourceListResponse)
def list_admin_sources(
    status: str | None = None,
    keyword: str | None = None,
    language: str | None = None,
    type: str | None = None,
    category: str | None = None,
    tag: str | None = None,
    page: int = 1,
    limit: int = 20,
    user: AdminUser = Depends(require_admin_session),
    db: Session = Depends(get_session),
) -> AdminSourceListResponse:
    _ = user
    query = select(Source)
    count_query = select(func.count()).select_from(Source)
    if status:
        query = query.where(Source.status == status)
        count_query = count_query.where(Source.status == status)
    if keyword:
        query = query.where(Source.title.ilike(f"%{keyword}%"))
        count_query = count_query.where(Source.title.ilike(f"%{keyword}%"))
    if language:
        query = query.where(Source.language == language)
        count_query = count_query.where(Source.language == language)
    if type:
        query = query.where(Source.source_type == type)
        count_query = count_query.where(Source.source_type == type)
    if category:
        query = query.where(csv_contains(Source.categories, category))
        count_query = count_query.where(csv_contains(Source.categories, category))
    if tag:
        query = query.where(csv_contains(Source.tags, tag))
        count_query = count_query.where(csv_contains(Source.tags, tag))

    capped_limit = min(max(limit, 1), 100)
    current_page = max(page, 1)
    total = db.scalar(count_query) or 0
    sources = db.scalars(
        query.order_by(Source.last_published_at.desc(), Source.registered_at.desc()).offset((current_page - 1) * capped_limit).limit(capped_limit)
    ).all()
    return AdminSourceListResponse(
        items=[_serialize_source(source) for source in sources],
        page=current_page,
        limit=capped_limit,
        total=total,
    )


@router.get("/sources/{source_id}", response_model=AdminSourceResponse)
def get_admin_source(source_id: str, user: AdminUser = Depends(require_admin_session), db: Session = Depends(get_session)) -> AdminSourceResponse:
    _ = user
    source = db.get(Source, source_id)
    if not source:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )
    return _serialize_source(source)


@router.get("/sources/{source_id}/audit-logs", response_model=AdminAuditLogListResponse)
def get_admin_source_audit_logs(
    source_id: str,
    user: AdminUser = Depends(require_admin_session),
    db: Session = Depends(get_session),
) -> AdminAuditLogListResponse:
    _ = user
    source = db.get(Source, source_id)
    if not source:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )

    entries = db.scalars(
        select(AdminAuditLog)
        .where(AdminAuditLog.source_id == source_id)
        .options(selectinload(AdminAuditLog.admin_user), selectinload(AdminAuditLog.source))
        .order_by(AdminAuditLog.created_at.desc())
        .limit(50)
    ).all()
    return AdminAuditLogListResponse(items=[_serialize_audit_log(entry) for entry in entries])


@router.get("/audit-logs", response_model=AdminAuditLogListResponse)
def list_admin_audit_logs(
    limit: int = 20,
    user: AdminUser = Depends(require_admin_session),
    db: Session = Depends(get_session),
) -> AdminAuditLogListResponse:
    _ = user
    capped_limit = min(max(limit, 1), 100)
    entries = db.scalars(
        select(AdminAuditLog)
        .options(selectinload(AdminAuditLog.admin_user), selectinload(AdminAuditLog.source))
        .order_by(AdminAuditLog.created_at.desc())
        .limit(capped_limit)
    ).all()
    return AdminAuditLogListResponse(items=[_serialize_audit_log(entry) for entry in entries])


@router.post("/sources/{source_id}/status", response_model=AdminSourceResponse)
def update_admin_source_status(
    source_id: str,
    payload: AdminSourceStatusUpdateRequest,
    user: AdminUser = Depends(require_admin_session),
    db: Session = Depends(get_session),
) -> AdminSourceResponse:
    source = db.get(Source, source_id)
    if not source:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )

    from_status = source.status
    source.status = payload.status
    source.status_reason = payload.reason or source.status_reason
    db.add(source)
    db.add(
        AdminAuditLog(
            admin_user_id=user.id,
            source_id=source.id,
            action="source.status_updated",
            reason=payload.reason,
            from_status=from_status,
            to_status=payload.status,
        )
    )
    db.commit()
    db.refresh(source)
    return _serialize_source(source)


@router.patch("/sources/{source_id}", response_model=AdminSourceResponse)
def update_admin_source(
    source_id: str,
    payload: AdminSourceUpdateRequest,
    user: AdminUser = Depends(require_admin_session),
    db: Session = Depends(get_session),
) -> AdminSourceResponse:
    source = db.get(Source, source_id)
    if not source:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )

    source.language = payload.language
    source.source_type = payload.type
    source.categories = join_csv(payload.categories)
    source.tags = join_csv(payload.tags)
    db.add(source)
    db.add(
        AdminAuditLog(
            admin_user_id=user.id,
            source_id=source.id,
            action="source.metadata_updated",
            reason="metadata_edit",
        )
    )
    db.commit()
    db.refresh(source)
    return _serialize_source(source)


@router.delete("/sources/{source_id}")
def delete_admin_source(
    source_id: str,
    reason: str | None = None,
    user: AdminUser = Depends(require_admin_session),
    db: Session = Depends(get_session),
) -> dict[str, object]:
    source = db.get(Source, source_id)
    if not source:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"code": "source_not_found", "message": "Source not found."},
        )

    deleted_snapshot = {
        "id": source.id,
        "title": source.title,
        "status": source.status,
    }
    db.add(
        AdminAuditLog(
            admin_user_id=user.id,
            source_id=source.id,
            action="source.deleted",
            reason=reason,
            from_status=source.status,
        )
    )
    db.flush()
    db.delete(source)
    db.commit()
    return {"deleted": deleted_snapshot}
