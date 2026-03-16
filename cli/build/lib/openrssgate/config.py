from __future__ import annotations

import os


DEFAULT_API_BASE_URL = "https://openrssgate-production.up.railway.app/v1"


def get_api_base_url() -> str:
    return os.getenv("OPENRSSGATE_API_BASE_URL", DEFAULT_API_BASE_URL).rstrip("/")
