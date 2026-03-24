from __future__ import annotations

import os


DEFAULT_API_BASE_URL = "http://localhost:3000/api/v1"



def get_api_base_url() -> str:
    return os.getenv("OPENRSSGATE_API_BASE_URL", DEFAULT_API_BASE_URL).rstrip("/")
