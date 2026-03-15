from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.feeds import router as feeds_router
from app.api.admin import router as admin_router
from app.api.ops import router as ops_router
from app.api.sources import public_router as public_sources_router
from app.api.sources import router as sources_router
from app.mcp.server import router as mcp_router
from app.core.config import get_settings
from app.services.cache import response_cache
from app.services.rate_limit import RateLimitExceededError, read_rate_limiter

settings = get_settings()


@asynccontextmanager
async def lifespan(_: FastAPI):
    response_cache.configure(settings.redis_url if settings.response_cache_enabled else None)
    yield

app = FastAPI(
    title=settings.app_name,
    description=(
        "RSS Gateway indexes public RSS/Atom feeds and exposes source/feed metadata "
        "through REST, MCP-style endpoints, and CLI-compatible responses."
    ),
    version="0.1.0",
    lifespan=lifespan,
    openapi_tags=[
        {"name": "sources", "description": "Public source registration and source discovery endpoints."},
        {"name": "feeds", "description": "Public feed listing endpoints backed by the indexed source set."},
        {"name": "admin", "description": "Protected admin authentication and source moderation endpoints."},
        {"name": "mcp", "description": "Read-only MCP-compatible manifest, SSE, and tool call endpoints."},
    ],
    swagger_ui_parameters={"defaultModelsExpandDepth": -1},
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_allowed_origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)


@app.exception_handler(HTTPException)
async def http_exception_handler(_: Request, exc: HTTPException) -> JSONResponse:
    if isinstance(exc.detail, dict) and "code" in exc.detail and "message" in exc.detail:
        return JSONResponse(status_code=exc.status_code, content={"error": exc.detail})
    return JSONResponse(status_code=exc.status_code, content={"error": {"code": "http_error", "message": str(exc.detail)}})


@app.get("/health", tags=["health"], summary="Health check", description="Simple process health endpoint for local and deploy smoke checks.")
def health() -> dict[str, str]:
    return {"status": "ok"}


def _request_ip(request: Request) -> str:
    forwarded_for = request.headers.get("x-forwarded-for", "")
    if forwarded_for:
        return forwarded_for.split(",")[0].strip()
    return request.client.host if request.client else "unknown"


def _is_public_read_path(path: str) -> bool:
    if not path.startswith(settings.api_prefix):
        return False
    if path.startswith(f"{settings.api_prefix}/ops"):
        return False
    if path.startswith(f"{settings.api_prefix}/sources") or path.startswith(f"{settings.api_prefix}/feeds"):
        return True
    return path == f"{settings.api_prefix}/stats"


@app.middleware("http")
async def public_read_rate_limit_middleware(request: Request, call_next):
    if request.method == "GET" and settings.public_read_rate_limit_enabled and _is_public_read_path(request.url.path):
        try:
            read_rate_limiter.enforce(
                ip=_request_ip(request),
                path=request.url.path,
                window_seconds=settings.public_read_window_seconds,
                max_attempts=settings.public_read_max_requests,
            )
        except RateLimitExceededError as exc:
            return JSONResponse(
                status_code=429,
                content={"error": {"code": "rate_limited", "message": str(exc)}},
            )
    return await call_next(request)

app.include_router(sources_router, prefix=settings.api_prefix)
app.include_router(public_sources_router, prefix=settings.api_prefix)
app.include_router(feeds_router, prefix=settings.api_prefix)
app.include_router(ops_router, prefix=settings.api_prefix)
app.include_router(admin_router, prefix=settings.api_prefix)
app.include_router(mcp_router)
