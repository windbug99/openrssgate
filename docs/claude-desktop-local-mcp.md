# Claude Desktop Local MCP Setup

`개발자 > 로컬 MCP 서버` 에서는 stdio 프로세스를 등록합니다. 이 프로젝트는 원격 HTTP SSE MCP와 별도로 로컬 stdio MCP 진입점도 제공합니다.

## Claude Desktop 등록 값

```text
명령어
/Users/tomato/cursor/openrssgate/backend/.venv/bin/python

인수
/Users/tomato/cursor/openrssgate/backend/scripts/mcp_stdio_server.py
```

## 사전 준비

```bash
cd /Users/tomato/cursor/openrssgate/backend
source .venv/bin/activate
.venv/bin/alembic upgrade head
```

로컬 stdio 방식은 `uvicorn` 실행이 필요 없습니다. Claude Desktop이 직접 MCP 프로세스를 실행합니다.

## 현재 제공 도구

- `search_sources`
- `get_source`
- `get_recent_feeds`
- `get_source_feeds`

## 확인용 프롬프트

```text
등록된 RSS Source를 보여줘
최근 Feed를 보여줘
특정 Source의 최신 글 목록을 보여줘
```
