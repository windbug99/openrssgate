from app.core.config import Settings


def test_cors_allowed_origins_accepts_csv(monkeypatch) -> None:
    monkeypatch.setenv("CORS_ALLOWED_ORIGINS", "https://a.com,https://b.com")
    settings = Settings()

    assert settings.cors_allowed_origins == ["https://a.com", "https://b.com"]


def test_cors_allowed_origins_accepts_json_array(monkeypatch) -> None:
    monkeypatch.setenv("CORS_ALLOWED_ORIGINS", '["https://a.com", "https://b.com"]')
    settings = Settings()

    assert settings.cors_allowed_origins == ["https://a.com", "https://b.com"]


def test_cors_allowed_origins_accepts_empty_string(monkeypatch) -> None:
    monkeypatch.setenv("CORS_ALLOWED_ORIGINS", "")
    settings = Settings()

    assert settings.cors_allowed_origins == []


def test_service_api_keys_accepts_json_array(monkeypatch) -> None:
    monkeypatch.setenv("SERVICE_API_KEYS", '["key-a", "key-b"]')
    settings = Settings()

    assert settings.service_api_keys == ["key-a", "key-b"]
