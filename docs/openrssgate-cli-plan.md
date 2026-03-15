# OpenRSSGate Admin CLI 최소 구현 계획

> 작성일: 2026년 3월
> 버전: v0.2

---

## 1. 목적

운영자에게 지금 필요한 기능은 아래 세 가지뿐입니다.

- `hidden`, `rejected` Source 조회
- Source 상태 변경
- Source 삭제

그 외 운영 확인은 웹사이트에서 처리합니다. 따라서 관리자 CLI는 범위를 넓히지 않고, 기존 운영 API를 감싸는 얇은 인터페이스로 구현합니다.

---

## 2. 현재 백엔드 기준

현재 서버에는 아래 운영 API가 이미 있습니다.

- `GET /v1/ops/sources?status=hidden`
- `GET /v1/ops/sources?status=rejected`
- `POST /v1/ops/sources/{source_id}/status`

현재 서버에는 아직 아래 API가 없습니다.

- `DELETE /v1/ops/sources/{source_id}`

따라서 관리자 CLI는 다음 원칙으로 설계합니다.

- 이미 있는 API는 그대로 감싼다.
- 없는 기능은 CLI에서 우회하지 않는다.
- 삭제는 백엔드 삭제 API가 추가된 뒤에만 제공한다.

---

## 3. 명령어 범위

```text
org admin sources list --status hidden
org admin sources list --status rejected

org admin sources set-status <source_id> active
org admin sources set-status <source_id> hidden --reason "manual_review"
org admin sources set-status <source_id> rejected --reason "spam"

org admin sources delete <source_id> --force
```

설명:

- `list`: `hidden`, `rejected` 상태 Source 조회
- `set-status`: Source 상태를 `active`, `hidden`, `rejected`로 변경
- `delete`: Source 영구 삭제. 백엔드 삭제 API가 추가된 후 활성화

`hide`, `activate`, `reject` 같은 세부 명령으로 나누지 않고 `set-status` 하나로 통일합니다. 명령 수를 줄이고, 현재 상태 변경 API 모델과도 직접 맞출 수 있기 때문입니다.

---

## 4. 상세 명령어

### 4.1 `org admin sources list`

숨김 또는 거절된 Source를 조회합니다.

```bash
org admin sources list --status hidden
org admin sources list --status rejected
org admin sources list --status hidden --json
```

백엔드 매핑:

- `GET /v1/ops/sources?status=hidden`
- `GET /v1/ops/sources?status=rejected`

텍스트 출력 예시:

```text
src_123  Example Blog        hidden    stale_feed          2026-03-14
src_456  Spam Newsletter     hidden    manual_review       2026-03-13
src_789  Fake Source         rejected  spam                2026-03-12
```

JSON 출력 원칙:

- API 응답 구조를 크게 바꾸지 않는다.
- 상위 키는 `items`를 유지한다.

예시:

```json
{
  "items": [
    {
      "id": "src_123",
      "rss_url": "https://example.com/feed.xml",
      "title": "Example Blog",
      "status": "hidden",
      "status_reason": "stale_feed",
      "ai_reviewed_at": null,
      "ai_review_source": null,
      "ai_review_reason": null,
      "ai_review_confidence": null,
      "ai_review_decision": null,
      "registered_at": "2026-03-14T10:00:00Z",
      "last_fetched_at": "2026-03-14T12:00:00Z",
      "consecutive_fail_count": 0
    }
  ]
}
```

### 4.2 `org admin sources set-status`

Source 상태를 수동으로 변경합니다.

```bash
org admin sources set-status src_123 active
org admin sources set-status src_123 hidden --reason "manual_review"
org admin sources set-status src_123 rejected --reason "spam"
org admin sources set-status src_123 active --json
```

허용 상태:

- `active`
- `hidden`
- `rejected`

백엔드 매핑:

- `POST /v1/ops/sources/{source_id}/status`

요청 예시:

```json
{
  "status": "hidden",
  "reason": "manual_review"
}
```

텍스트 출력 예시:

```text
src_123  active -> hidden  reason=manual_review
```

JSON 출력 예시:

```json
{
  "id": "src_123",
  "status": "hidden",
  "status_reason": "manual_review"
}
```

### 4.3 `org admin sources delete`

Source를 영구 삭제합니다.

```bash
org admin sources delete src_123
org admin sources delete src_123 --force
```

현재 상태:

- CLI 명령 스펙만 정의
- 백엔드 삭제 API 추가 전까지는 구현하지 않음

필요한 백엔드 API:

- `DELETE /v1/ops/sources/{source_id}`

`--force`가 없으면 확인 프롬프트를 보여주고, `--force`가 있으면 바로 요청합니다.

---

## 5. 인증 방식

관리자 CLI는 일반 사용자용 API Key와 별도로 운영용 키를 사용합니다.

권장 방식:

- CLI 설정의 `admin_key`
- 요청 헤더의 `X-Ops-Key`
- 서버 환경변수의 `OPS_API_KEY`

예시:

```bash
org config --admin-key YOUR_OPS_KEY
```

CLI는 관리자 명령 실행 시 아래 헤더를 붙입니다.

```http
X-Ops-Key: YOUR_OPS_KEY
```

주의:

- 현재 서버는 `X-API-Key`도 운영 인증으로 허용하지만, 관리자 CLI는 `X-Ops-Key`만 사용하도록 고정하는 편이 좋습니다.
- 현재 `GET /v1/ops/sources`는 키 보호가 없으므로, 관리자 CLI를 도입하면 조회 API도 같은 운영 키로 보호하는 것을 권장합니다.

---

## 6. 출력 원칙

모든 관리자 명령은 두 가지 출력 형식을 지원합니다.

- 기본: 사람이 읽기 쉬운 텍스트
- `--json`: 자동화 및 에이전트용 JSON

원칙:

- JSON은 항상 단일 객체
- 에러도 JSON 객체로 출력
- JSON 구조는 서버 응답을 가능한 한 유지
- 성공 시 exit code `0`
- 실패 시 exit code `1`

예시:

```bash
org admin sources list --status hidden --json
org admin sources set-status src_123 active --json
```

---

## 7. 구현 구조

```text
cli/
├── org/
│   ├── main.py
│   ├── config.py
│   ├── client.py
│   └── commands/
│       └── admin_sources.py
├── tests/
│   └── test_admin_sources.py
└── pyproject.toml
```

최소 구현에서는 관리자 Source 명령만 먼저 둡니다. 관리자 기능을 여러 파일로 과분하게 쪼개지 않습니다.

권장 내부 함수:

- `list_sources(status: str, json_output: bool)`
- `set_source_status(source_id: str, status: str, reason: str | None, json_output: bool)`
- `delete_source(source_id: str, force: bool, json_output: bool)`

---

## 8. 구현 순서

### Phase 1

- `org config --admin-key`
- `org admin sources list --status hidden|rejected`
- `org admin sources set-status <id> <status>`

### Phase 2

- 백엔드 `DELETE /v1/ops/sources/{source_id}` 추가
- `org admin sources delete <id> [--force]`

### Phase 3

- `/v1/ops/sources` 조회에도 운영 키 적용
- 필요 시 감사 로그 필드 추가

---

## 9. 사용 예시

```bash
# 숨김 Source 조회
org admin sources list --status hidden

# 거절된 Source 조회
org admin sources list --status rejected

# 수동 복구
org admin sources set-status src_123 active --reason "manual_restore"

# 수동 숨김
org admin sources set-status src_123 hidden --reason "manual_review"

# 스팸 판정
org admin sources set-status src_123 rejected --reason "spam"
```

---

이 문서는 현재 백엔드 구현 상태와 실제 운영 필요 범위에 맞춘 최소 관리자 CLI 계획서입니다.
