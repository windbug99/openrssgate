from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.feeds import router as feeds_router
from app.api.ops import router as ops_router
from app.api.sources import router as sources_router
from app.mcp.server import router as mcp_router
from app.core.config import get_settings

settings = get_settings()


@asynccontextmanager
async def lifespan(_: FastAPI):
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
        {"name": "mcp", "description": "Read-only MCP-compatible manifest, SSE, and tool call endpoints."},
    ],
    swagger_ui_parameters={"defaultModelsExpandDepth": -1},
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_allowed_origins,
    allow_credentials=False,
    allow_methods=["GET", "POST", "OPTIONS"],
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

app.include_router(sources_router, prefix=settings.api_prefix)
app.include_router(feeds_router, prefix=settings.api_prefix)
app.include_router(ops_router, prefix=settings.api_prefix)
app.include_router(mcp_router)
