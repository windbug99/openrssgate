from __future__ import annotations

from fastapi import Header, HTTPException, status

from app.core.config import get_settings


def require_service_api_key(
    x_api_key: str | None = Header(default=None),
    x_ops_key: str | None = Header(default=None),
) -> None:
    settings = get_settings()
    allowed_keys = [key for key in settings.service_api_keys if key]
    if settings.ops_api_key:
        allowed_keys.append(settings.ops_api_key)

    if not allowed_keys:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail={"code": "ops_key_not_configured", "message": "Operations API key is not configured."},
        )

    provided = x_api_key or x_ops_key
    if provided not in allowed_keys:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "invalid_ops_key", "message": "A valid operations API key is required."},
        )
