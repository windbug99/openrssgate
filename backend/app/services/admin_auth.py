from __future__ import annotations

import base64
import json
import hashlib
import hmac
import secrets
import struct
from datetime import UTC, datetime, timedelta
from urllib.parse import quote

from fastapi import Cookie, Depends, Header, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.deps import get_session
from app.core.config import get_settings
from app.db.models import AdminSession, AdminUser

PBKDF2_ITERATIONS = 600_000
TOTP_STEP_SECONDS = 30
TOTP_DIGITS = 6
RECOVERY_CODE_COUNT = 8


def _utcnow() -> datetime:
    return datetime.now(UTC)


def hash_password(password: str, *, salt: bytes | None = None) -> str:
    actual_salt = salt or secrets.token_bytes(16)
    derived = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), actual_salt, PBKDF2_ITERATIONS)
    return f"pbkdf2_sha256${PBKDF2_ITERATIONS}${base64.b64encode(actual_salt).decode()}${base64.b64encode(derived).decode()}"


def verify_password(password: str, encoded_hash: str) -> bool:
    try:
        algorithm, iteration_text, salt_b64, hash_b64 = encoded_hash.split("$", 3)
    except ValueError:
        return False
    if algorithm != "pbkdf2_sha256":
        return False
    try:
        iterations = int(iteration_text)
        salt = base64.b64decode(salt_b64.encode())
        expected = base64.b64decode(hash_b64.encode())
    except (ValueError, TypeError):
        return False
    actual = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), salt, iterations)
    return secrets.compare_digest(actual, expected)


def generate_totp_secret() -> str:
    return base64.b32encode(secrets.token_bytes(20)).decode("ascii").rstrip("=")


def _hash_recovery_code(code: str) -> str:
    return hashlib.sha256(code.encode("utf-8")).hexdigest()


def generate_recovery_codes() -> tuple[list[str], str]:
    codes: list[str] = []
    hashes: list[str] = []
    for _ in range(RECOVERY_CODE_COUNT):
        left = secrets.token_hex(2).upper()
        right = secrets.token_hex(2).upper()
        code = f"{left}-{right}"
        codes.append(code)
        hashes.append(_hash_recovery_code(code))
    return codes, json.dumps(hashes)


def verify_and_consume_recovery_code(user: AdminUser, code: str) -> bool:
    if not user.recovery_codes_hashes:
        return False
    cleaned = code.strip().upper()
    try:
        hashes = json.loads(user.recovery_codes_hashes)
    except json.JSONDecodeError:
        return False
    if not isinstance(hashes, list):
        return False
    candidate_hash = _hash_recovery_code(cleaned)
    for index, value in enumerate(hashes):
        if isinstance(value, str) and secrets.compare_digest(value, candidate_hash):
            del hashes[index]
            user.recovery_codes_hashes = json.dumps(hashes)
            return True
    return False


def build_totp_uri(email: str, secret: str, issuer: str = "OpenRSSGate") -> str:
    label = quote(f"{issuer}:{email}")
    return f"otpauth://totp/{label}?secret={secret}&issuer={quote(issuer)}&algorithm=SHA1&digits={TOTP_DIGITS}&period={TOTP_STEP_SECONDS}"


def _normalize_base32(value: str) -> bytes:
    normalized = value.strip().replace(" ", "").upper()
    padding = "=" * ((8 - len(normalized) % 8) % 8)
    return base64.b32decode(normalized + padding, casefold=True)


def _totp_at(secret: str, for_time: int) -> str:
    counter = int(for_time // TOTP_STEP_SECONDS)
    key = _normalize_base32(secret)
    payload = struct.pack(">Q", counter)
    digest = hmac.new(key, payload, hashlib.sha1).digest()
    offset = digest[-1] & 0x0F
    code_int = (struct.unpack(">I", digest[offset : offset + 4])[0] & 0x7FFFFFFF) % (10**TOTP_DIGITS)
    return str(code_int).zfill(TOTP_DIGITS)


def verify_totp_code(secret: str, code: str, *, at_time: datetime | None = None) -> bool:
    cleaned = code.strip().replace(" ", "")
    if not cleaned.isdigit() or len(cleaned) != TOTP_DIGITS:
        return False
    moment = int((at_time or _utcnow()).timestamp())
    for skew in (-1, 0, 1):
        if secrets.compare_digest(_totp_at(secret, moment + skew * TOTP_STEP_SECONDS), cleaned):
            return True
    return False


def create_session_token(db: Session, user: AdminUser) -> str:
    settings = get_settings()
    raw_token = secrets.token_urlsafe(32)
    token_hash = hashlib.sha256(raw_token.encode("utf-8")).hexdigest()
    expires_at = _utcnow() + timedelta(hours=max(settings.admin_session_ttl_hours, 1))
    db.add(
        AdminSession(
            admin_user_id=user.id,
            token_hash=token_hash,
            expires_at=expires_at,
        )
    )
    db.commit()
    return raw_token


def _hash_session_token(token: str) -> str:
    return hashlib.sha256(token.encode("utf-8")).hexdigest()


def ensure_bootstrap_admin(db: Session) -> None:
    settings = get_settings()
    if db.scalar(select(AdminUser.id).limit(1)):
        return
    if not settings.admin_bootstrap_email or not settings.admin_bootstrap_password:
        return
    db.add(
        AdminUser(
            email=settings.admin_bootstrap_email.strip().lower(),
            password_hash=hash_password(settings.admin_bootstrap_password),
        )
    )
    db.commit()


def _load_admin_user_from_authorization(
    authorization: str | None = Header(default=None),
    admin_session_cookie: str | None = Cookie(default=None, alias="openrssgate_admin_session"),
    db: Session = Depends(get_session),
) -> tuple[AdminUser, AdminSession]:
    token = None
    if authorization and authorization.startswith("Bearer "):
        token = authorization.removeprefix("Bearer ").strip()
    elif admin_session_cookie:
        token = admin_session_cookie.strip()

    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "admin_auth_required", "message": "Admin authentication is required."},
        )

    session = db.scalar(select(AdminSession).where(AdminSession.token_hash == _hash_session_token(token)))
    if not session:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "invalid_admin_session", "message": "Admin session is invalid or expired."},
        )
    expires_at = session.expires_at
    if expires_at.tzinfo is None:
        expires_at = expires_at.replace(tzinfo=UTC)
    if expires_at < _utcnow():
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "invalid_admin_session", "message": "Admin session is invalid or expired."},
        )
    user = db.get(AdminUser, session.admin_user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "invalid_admin_session", "message": "Admin session is invalid or expired."},
        )
    return user, session


def require_admin_session(
    authorization: str | None = Header(default=None),
    admin_session_cookie: str | None = Cookie(default=None, alias="openrssgate_admin_session"),
    db: Session = Depends(get_session),
) -> AdminUser:
    user, session = _load_admin_user_from_authorization(
        authorization=authorization,
        admin_session_cookie=admin_session_cookie,
        db=db,
    )
    if session.otp_verified_at is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"code": "otp_verification_required", "message": "Two-factor verification is required."},
        )
    return user


def require_pending_admin_session(
    authorization: str | None = Header(default=None),
    admin_session_cookie: str | None = Cookie(default=None, alias="openrssgate_admin_session"),
    db: Session = Depends(get_session),
) -> tuple[AdminUser, AdminSession]:
    return _load_admin_user_from_authorization(
        authorization=authorization,
        admin_session_cookie=admin_session_cookie,
        db=db,
    )


def get_admin_session_by_token(db: Session, token: str) -> AdminSession | None:
    return db.scalar(select(AdminSession).where(AdminSession.token_hash == _hash_session_token(token)))
