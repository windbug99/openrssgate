from __future__ import annotations

import os


def get_api_base_url() -> str:
    return os.getenv("OPENRSSGATE_API_BASE_URL", "http://127.0.0.1:8000/v1").rstrip("/")
