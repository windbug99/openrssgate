from __future__ import annotations

import json
import sys
from typing import Any
from pathlib import Path

from fastapi import HTTPException

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from app.db.database import SessionLocal
from app.mcp.server import call_tool, get_mcp_tool_manifest

PROTOCOL_VERSION = "2025-03-26"


def _tool_definitions() -> list[dict[str, Any]]:
    tools = get_mcp_tool_manifest()["tools"]
    normalized: list[dict[str, Any]] = []
    for tool in tools:
        item = dict(tool)
        if "input_schema" in item and "inputSchema" not in item:
            item["inputSchema"] = item.pop("input_schema")
        normalized.append(item)
    return normalized


def _write(message: dict[str, Any]) -> None:
    sys.stdout.write(json.dumps(message, ensure_ascii=False, separators=(",", ":")) + "\n")
    sys.stdout.flush()


def _error_response(request_id: Any, code: int, message: str) -> dict[str, Any]:
    return {"jsonrpc": "2.0", "id": request_id, "error": {"code": code, "message": message}}


def _handle_initialize(request_id: Any) -> dict[str, Any]:
    return {
        "jsonrpc": "2.0",
        "id": request_id,
        "result": {
            "protocolVersion": PROTOCOL_VERSION,
            "capabilities": {"tools": {}},
            "serverInfo": {"name": "rss-gateway-stdio", "version": "0.1.0"},
        },
    }


def _handle_tools_list(request_id: Any) -> dict[str, Any]:
    return {"jsonrpc": "2.0", "id": request_id, "result": {"tools": _tool_definitions()}}


def _tool_error_result(code: str, message: str) -> dict[str, Any]:
    error = {"code": code, "message": message}
    return {
        "content": [{"type": "text", "text": json.dumps({"error": error}, ensure_ascii=False)}],
        "structuredContent": {"error": error},
        "isError": True,
    }


def _handle_tools_call(request_id: Any, params: dict[str, Any]) -> dict[str, Any]:
    name = params.get("name")
    arguments = params.get("arguments", {})

    try:
        with SessionLocal() as db:
            payload = call_tool(db, str(name), arguments if isinstance(arguments, dict) else {})
    except HTTPException as exc:
        detail = exc.detail if isinstance(exc.detail, dict) else {"code": "tool_error", "message": str(exc.detail)}
        return {"jsonrpc": "2.0", "id": request_id, "result": _tool_error_result(str(detail["code"]), str(detail["message"]))}
    except Exception as exc:
        return {"jsonrpc": "2.0", "id": request_id, "result": _tool_error_result("internal_error", str(exc))}

    result = payload["result"]
    return {
        "jsonrpc": "2.0",
        "id": request_id,
        "result": {
            "content": [{"type": "text", "text": json.dumps(result, ensure_ascii=False)}],
            "structuredContent": result,
            "isError": False,
        },
    }


def main() -> int:
    for raw_line in sys.stdin:
        line = raw_line.strip()
        if not line:
            continue

        try:
            message = json.loads(line)
        except json.JSONDecodeError:
            _write(_error_response(None, -32700, "Parse error"))
            continue

        if not isinstance(message, dict):
            _write(_error_response(None, -32600, "Invalid Request"))
            continue

        method = message.get("method")
        request_id = message.get("id")
        params = message.get("params", {})

        try:
            if method == "initialize":
                _write(_handle_initialize(request_id))
            elif method == "notifications/initialized":
                continue
            elif method == "tools/list":
                _write(_handle_tools_list(request_id))
            elif method == "tools/call":
                if not isinstance(params, dict):
                    _write(_error_response(request_id, -32602, "Invalid params"))
                    continue
                _write(_handle_tools_call(request_id, params))
            elif method == "ping":
                _write({"jsonrpc": "2.0", "id": request_id, "result": {}})
            elif method == "shutdown":
                _write({"jsonrpc": "2.0", "id": request_id, "result": {}})
                return 0
            elif method == "exit":
                return 0
            elif method is None:
                continue
            else:
                _write(_error_response(request_id, -32601, f"Method not found: {method}"))
        except Exception as exc:  # pragma: no cover
            _write(_error_response(request_id, -32000, str(exc)))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
