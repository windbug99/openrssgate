# Claude Desktop Local MCP Setup

`개발자 > 로컬 MCP 서버` 에서는 stdio 프로세스를 등록합니다. 이 프로젝트는 원격 HTTP MCP와 별도로 로컬 stdio MCP 진입점도 제공합니다.

현재 실사용 기준:

- Claude Desktop 무료 플랜이라 원격 MCP 커넥터를 추가할 수 없으면 이 문서의 stdio 방식을 사용합니다.
- 이 경우 Claude Desktop은 배포 서버가 아니라 로컬 Python 프로세스와 로컬 DB를 보게 됩니다.
- 공개 배포 데이터가 아니라 로컬 SQLite 데이터가 보이는 점을 전제로 사용해야 합니다.

## Claude Desktop 등록 값

아래 값은 예시입니다. 실제 등록 시에는 자신의 저장소 절대경로로 바꿔야 합니다.

```text
명령어
/absolute/path/to/openrssgate/backend/.venv/bin/python

인수
/absolute/path/to/openrssgate/backend/scripts/mcp_stdio_server.py
```

## 사전 준비

```bash
cd backend
source .venv/bin/activate
.venv/bin/alembic upgrade head
```

로컬 stdio 방식은 `uvicorn` 실행이 필요 없습니다. Claude Desktop이 직접 MCP 프로세스를 실행합니다.

로컬 DB 스키마가 오래되면 `ai_reviewed_at` 같은 컬럼 누락으로 tool call이 실패할 수 있으므로, 먼저 아래를 실행해 최신 상태로 맞추는 것이 안전합니다.

```bash
cd backend
source .venv/bin/activate
REPO_ROOT="$(pwd)/.."
DATABASE_URL="sqlite:///$REPO_ROOT/backend/rssgateway.db" .venv/bin/alembic stamp 20260312_0002
sqlite3 "$REPO_ROOT/backend/rssgateway.db" < "$REPO_ROOT/docs/20260315_add_ai_review_columns.sql"
DATABASE_URL="sqlite:///$REPO_ROOT/backend/rssgateway.db" .venv/bin/alembic upgrade head
```

## 현재 제공 도구

- `search_sources`
- `get_source`
- `get_source_status`
- `get_stats`
- `get_recent_feeds`
- `get_source_feeds`
- `list_feeds`
- `get_feed`
- `get_source_feed`
- `validate_source`
- `autofill_source`
- `create_source`

## 확인용 프롬프트

```text
등록된 RSS Source를 보여줘
최근 Feed를 보여줘
특정 Source의 최신 글 목록을 보여줘
```
