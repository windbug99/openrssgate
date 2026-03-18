# RSS Gateway 서비스 기획 및 구현 계획

> 작성일: 2026년 3월  
> 버전: v0.1 (기획안)

---

## 1. 서비스 개요

### 1.1 서비스 정의

RSS Gateway는 전 세계 블로그와 웹사이트의 RSS를 중앙에서 인덱싱하고, 사람과 AI 모두가 표준화된 API로 접근할 수 있는 **RSS 중앙 게이트웨이 서비스**입니다.

### 1.2 핵심 목적

| 목적 | 설명 |
|------|------|
| RSS 중앙화 | 분산된 RSS를 한 곳에 등록하고 인덱스를 항상 최신 상태로 유지 |
| AI 접근성 | MCP 서버를 통해 Claude 등 LLM이 Source/Feed 정보를 도구로 활용 |
| 게이트웨이 역할 | 등록된 Source를 통해 원본 블로그와 RSS XML로 연결되는 진입점 제공 |

### 1.3 서비스 범위 (v1.0)

**포함**
- Source(RSS) 등록 및 Source Index 관리
- Feed 메타 정보 주기적 수집 (제목, URL, 발행일)
- REST API 제공
- MCP 서버 운영
- 웹 프론트 페이지 (익명 Source 등록 / Source 탐색 / Source Index 업데이트 시간 표시)
- CLI 도구 (AI Agent / 개발자용 조회 인터페이스)

**미포함 (차후 RSS Reader 서비스)**
- 사용자 구독 관리
- Feed 본문 저장
- 번역/요약 등 LLM 처리
- 개인화 추천

### 1.4 OpenRSSGate와 Reader 서비스의 역할 분리

OpenRSSGate는 공용 RSS 인덱스와 무료 조회 API를 제공하는 게이트웨이 역할에 집중합니다. 등록된 RSS Source를 수집하고, Source 및 Feed의 메타데이터를 표준화해 외부 서비스, 개발자, AI Agent, 별도 Reader 서비스가 활용할 수 있도록 제공합니다.

반면 Reader 서비스는 최종 사용자 경험과 수익화 기능을 담당합니다. 구독 관리, 읽음 상태, 저장, 알림, 개인화, AI 요약/번역 등은 Reader에서 제공하고, OpenRSSGate는 그 기반이 되는 Source/Feed 메타 인덱스를 공급하는 구조로 분리합니다.

**OpenRSSGate에서 제공하는 범위**

- RSS Source 등록 및 유효성 검증
- Source 메타데이터 저장 및 검색
- Feed 메타데이터 수집 및 조회
- Source/Feed 목록 조회 API
- 태그, 카테고리, 언어, 시간 기준 필터링
- MCP, CLI, 외부 서비스 연동용 무료 API
- 운영용 상태 관리 및 기본 통계 API

**OpenRSSGate에서 제공하지 않는 범위**

- 원문 본문 저장 및 제공
- preview, summary, full-content API
- 사용자 계정 및 로그인
- 구독 관리, 읽음 상태, 북마크
- 알림, 추천, 개인화 피드
- AI 요약, 번역, 질의응답
- 결제 및 유료 플랜 기능

**별도 Reader 서비스에서 제공하는 범위**

- 사용자 계정 기반 구독 관리
- 읽음 상태, 저장, 폴더 분류
- 원문 본문 확보 및 캐싱
- AI 요약, 번역, 주제별 정리
- 개인화 추천 및 사용자별 탐색 UX
- 결제, 플랜, 권한 관리

이 구조의 핵심 원칙은 OpenRSSGate를 `공용 데이터 레이어`, Reader를 `사용자 경험 및 수익화 레이어`로 명확히 분리하는 것입니다. 이렇게 해야 공개 API의 운영 비용과 유료 기능의 원가 구조가 섞이지 않고, 제품 포지셔닝도 분명하게 유지할 수 있습니다.

---

## 2. 서비스 구조

### 2.1 전체 아키텍처

```
[블로거 / 일반 사용자]     [개발자 / AI Agent]
   웹 프론트 페이지              CLI 도구
         │                        │
         └──────────┬─────────────┘
                    │ Source 등록
                    ▼
┌──────────────────────────────────────┐
│             RSS Gateway              │
│                                      │
│  ┌──────────┐  ┌──────┐  ┌────────┐  │
│  │ REST API │  │ 웹UI │  │MCP 서버│  │
│  └──────────┘  └──────┘  └────────┘  │
│               │                      │
│  ┌────────────────────────────────┐  │
│  │       Source Index DB          │  │
│  └────────────────────────────────┘  │
│               │                      │
│  ┌────────────────────────────────┐  │
│  │      Feed 수집기 (Cron)        │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
         │                    │
         ▼                    ▼
[사용자 / 외부 서비스]   [LLM (Claude 등)]
```

### 2.2 데이터 흐름

```
1. 블로거/사용자가 웹 프론트에서 Source(RSS URL) 등록
2. 수집기가 주기적으로 각 Source의 RSS XML을 fetch
3. 제목/URL/발행일 등 Feed 메타정보만 파싱하여 DB에 저장 (Source Index 업데이트)
4. 사용자/LLM이 API, CLI 또는 MCP로 Source/Feed 조회
5. 필요 시 원본 블로그 또는 RSS XML로 연결
```

---

## 3. 핵심 기능 정의

### 3.1 Source 등록 및 관리

| 기능 | 설명 |
|------|------|
| Source 등록 | RSS URL 입력, 유효성 검증 후 Source로 등록 |
| 중복 방지 | 동일 RSS URL 중복 등록 차단 |
| 메타 정보 자동 수집 | 등록 시 블로그 이름, 설명, favicon 등 자동 파싱 |
| 메타 정보 관리 | 언어, 카테고리, 태그 등 수동 입력 가능 |

### 3.2 Source Index 수집 (크론잡)

수집기는 등록된 RSS URL에 주기적으로 HTTP 요청을 보내 소스 메타정보를 수집합니다.

**용어 정의**

| 용어 | 설명 |
|------|------|
| Source | RSS를 제공하는 블로그/사이트. 사용자가 등록하는 단위 |
| Feed | Source에서 발행되는 개별 글/콘텐츠 |

**DB 스키마**

```
sources 테이블 (RSS 소스 정보)

  [기본 식별 정보]
  ├── id                       UUID, PK
  ├── rss_url                  RSS XML 주소 (UNIQUE)
  ├── site_url                 블로그/사이트 원문 주소
  ├── title                    블로그/채널 이름
  ├── description              블로그 소개 (RSS에서 자동 수집)
  ├── favicon_url              파비콘 이미지 URL
  └── cover_image_url          대표 이미지 URL (OGP 이미지 등)

  [분류 정보]
  ├── language                 기본 언어 (ko, en, ja 등)
  ├── country                  발행 국가 (KR, US 등)
  ├── category                 콘텐츠 유형 (blog / news / magazine / podcast / newsletter)
  └── tags                     분야 태그 3~5개 (["IT", "AI", "반도체"])

  [수집 및 상태 정보]
  ├── status                   active / hidden / deleted / pending_review
  ├── feed_format              피드 형식 (rss2 / atom / json_feed)
  ├── fetch_interval_minutes   수집 주기 (분) - 차등 수집에 활용
  ├── last_fetched_at          마지막 수집 시각 (웹 프론트 표시용)
  ├── last_published_at        마지막 Feed 발행 시각 (활성도 판단 기준)
  └── consecutive_fail_count   연속 수집 실패 횟수 (N회 이상 시 자동 비활성)

  [품질 및 통계 정보]
  ├── total_feeds_count        전체 수집 Feed 수
  ├── avg_publish_interval_hours  평균 발행 주기 (시간) - Reader의 업데이트 빈도 표시용
  ├── report_score             누적 신고 점수
  └── ai_reviewed_at           AI 마지막 검토 시각

  [등록 출처 정보]
  ├── registered_by            등록 경로 (web / cli / api / mcp)
  ├── registered_at            등록 시각
  └── source_ip_hash           등록자 IP 해시 (어뷰징 추적, 비식별)

feeds 테이블 (개별 피드 정보)
  ├── id                       UUID, PK
  ├── source_id                소속 Source (FK)
  ├── guid                     고유 ID (중복 방지)
  ├── title                    글 제목
  ├── feed_url                 글 원문 링크
  └── published_at             발행일
```

**MVP 권장 제약 조건**

```
sources
├── UNIQUE(rss_url)
├── INDEX(status, last_fetched_at)
└── INDEX(language, category)

feeds
├── UNIQUE(source_id, guid)
├── INDEX(source_id, published_at DESC)
└── INDEX(published_at DESC)
```

`guid`가 비어 있거나 신뢰할 수 없는 경우를 대비해, 구현에서는 아래 우선순위로 `entry_identity`를 생성해 저장하는 것을 권장합니다.

```
1. guid가 존재하면 guid 사용
2. guid가 없으면 feed_url 사용
3. guid와 feed_url 모두 불안정하면 title + published_at 해시 사용
```

즉, DB 컬럼 이름은 `guid`를 유지하더라도 실제 입력값은 "중복 판정용 안정 식별자"로 다루는 것이 안전합니다.

**Feed 보존 기간 정책**

```
보존 기간: 30일
├── 30일 이내 Feed  → 정상 보존
└── 30일 초과 Feed  → 매일 새벽 크론잡으로 자동 삭제 (TTL)
```

RSS의 본질은 현재의 새로운 콘텐츠 소비이므로 아카이브 목적의 장기 보존은 게이트웨이 역할 범위를 벗어납니다. 30일은 Reader 연동 서비스의 "못 읽은 글 나중에 보기" 패턴을 커버하는 최소한의 기준선입니다.

| Source 수 | 30일 Feed 수 (평균 1건/일) | 저장 용량 |
|-----------|--------------------------|---------|
| 1,000개 | 30,000건 | ~9MB |
| 10,000개 | 300,000건 | ~90MB |
| 100,000개 | 3,000,000건 | ~850MB |

NeonDB 무료 10GB 기준으로 10만 Source까지 여유롭게 수용 가능합니다.

**MVP 상태값 운영 규칙**

| 상태 | 공개 조회 | 수집 대상 | 설명 |
|------|----------|----------|------|
| `active` | 포함 | 포함 | 정상 공개 Source |
| `hidden` | 제외 | 제외 | 운영상 숨김 처리 |
| `deleted` | 제외 | 제외 | 삭제 처리된 Source |
| `pending_review` | 제외 | 제외 | 신규 등록 직후 자동 검증 대기 상태 |
| `rejected` | 제외 | 제외 | 자동 검증 또는 운영 판단상 등록 거절 |

현재 구현에서는 웹 익명 등록이 먼저 `pending_review`로 생성된 뒤, 1차 규칙 기반 자동 검증을 거쳐 아래처럼 상태 전이됩니다.

```
pending_review
├── active    : 메타데이터와 엔트리 수가 충분하고 자동 승인 가능
├── hidden    : 피드 자체는 유효하지만 설명 누락, 엔트리 부족 등 저신뢰 상태
└── rejected  : 잘못된 제목, 엔트리 없음 등 등록 거절이 명확한 상태
```

현재 구현된 자동 검증 규칙은 다음과 같습니다.

```
rejected
├── generic_or_invalid_title
├── no_feed_entries
├── duplicate_site_url
└── spam_like_title

hidden
├── too_few_entries
├── repetitive_entry_titles
├── missing_published_dates
├── stale_feed
└── missing_description

active
└── auto_approved
```



```
MVP 단계 필수
├── id, rss_url, site_url, title, description
├── favicon_url, language, category, tags
├── status, feed_format
├── last_fetched_at, last_published_at, consecutive_fail_count
└── registered_by, registered_at

Phase 2 이후 추가
├── country, cover_image_url
├── avg_publish_interval_hours, total_feeds_count
├── report_score, ai_reviewed_at
└── source_ip_hash
```

**수집 주기 전략 (차등 적용)**

| 분류 | 기준 | 수집 주기 |
|------|------|----------|
| 활성 Source | 최근 7일 이내 업데이트 | 1시간 |
| 일반 Source | 최근 30일 이내 업데이트 | 6시간 |
| 비활성 Source | 30일 이상 업데이트 없음 | 24시간 |

**수집 작업 순서**

```
1. DB에서 수집 대상 Source 목록 조회
2. 각 rss_url로 HTTP GET 요청 (RSS XML fetch)
3. XML 파싱 (feedparser)
4. 새 피드인지 guid로 중복 확인
5. 신규 항목만 feeds에 INSERT
6. sources 테이블의 last_fetched_at 업데이트
7. [매일 새벽] 30일 초과 Feed 자동 삭제 (TTL 크론잡)
```

**MVP 수집기 동작 규칙**

```
수집 대상 조건
- status = active
- 현재 시각 >= last_fetched_at + fetch_interval_minutes

HTTP fetch 규칙
- 요청 타임아웃: 10초
- 최대 리다이렉트: 5회
- User-Agent: rss-gateway-bot/0.1 (+서비스 URL)

실패 처리
- fetch 또는 파싱 실패 시 consecutive_fail_count += 1
- 성공 시 consecutive_fail_count = 0
- 5회 연속 실패 시 fetch_interval_minutes를 24시간으로 상향

성공 처리
- last_fetched_at 갱신
- 신규 Feed가 있으면 last_published_at 갱신
- Feed 수 기준 total_feeds_count 갱신은 Phase 2에서 추가
```

**MVP 배포 운영 방식**

초기에는 Railway에서 API 서버와 수집기를 같은 코드베이스로 운영하되, 프로세스는 분리하는 것을 권장합니다.

```
권장 구성
- web service: FastAPI API + MCP endpoint
- worker service: APScheduler 수집기 전용 프로세스
```

이렇게 하면 API 인스턴스 재시작이나 스케일링 때문에 수집기가 중복 실행되는 문제를 줄일 수 있습니다.

### 3.3 REST API

**Base URL**: `https://api.rssgateway.io/v1`

| Method | Endpoint | 설명 |
|--------|----------|------|
| GET | `/sources` | 등록된 Source 목록 조회 |
| POST | `/sources` | 웹 프론트 전용 Source 등록 |
| POST | `/sources/validate` | 등록 전 RSS URL 유효성 검증 |
| GET | `/sources/{source_id}` | 특정 RSS 정보 조회 |
| GET | `/sources/{source_id}/status` | 특정 Source 수집 상태 조회 |
| GET | `/sources/{source_id}/feeds` | 특정 Source의 Feed 목록 조회 |
| GET | `/sources/{source_id}/feeds/{feed_id}` | 특정 Feed 상세 조회 |
| GET | `/feeds` | 전체 Feed 통합 조회 (검색/필터 가능) |
| GET | `/feeds/{feed_id}` | 특정 Feed 상세 조회 |
| GET | `/stats` | 전체 Source / Feed 집계 조회 |

**주요 쿼리 파라미터**

```
GET /sources
  ?keyword=AI          키워드 검색
  ?language=ko         언어 필터
  ?category=blog       카테고리 필터
  ?tag=tech            태그 필터
  ?type=blog           Source 타입 필터
  ?page=1&limit=20     페이지네이션

GET /feeds
  ?since=24h           최근 N시간 이내
  ?source_id=xxx       특정 Source 필터
  ?language=ko         언어 필터
  ?q=openai            Feed 제목 검색
  ?type=blog           Source 타입 기준 필터
  ?category=tech       Source 카테고리 기준 필터
  ?tag=ai              Source 태그 기준 필터

GET /sources/{source_id}/status
  공개 응답: active Source만 조회 가능
  반환: last_fetched_at, last_published_at, consecutive_fail_count,
       fetch_interval_minutes, is_stale

POST /sources/validate
  rss_url 필수
  선택값: language, type, categories, tags
  반환: valid, rss_url, site_url, title, language, type,
       categories, tags, feed_format

GET /stats
  반환: total_sources, active_sources, total_feeds, feeds_last_24h
```

**MVP 엔드포인트 상세 규격**

`POST /sources`

요청 예시

```json
{
  "rss_url": "https://blog.example.com/rss.xml",
  "language": "ko",
  "category": "blog",
  "tags": ["AI", "tech"]
}
```

처리 규칙

```
1. rss_url 필수
2. language, category, tags는 선택
3. tags는 최대 5개, 각 값은 20자 이내
4. 서버가 RSS fetch 후 site_url, title, description, favicon_url 자동 채움
5. 동일 rss_url이 이미 존재하면 409 Conflict
6. 유효하지 않은 RSS면 400 Bad Request
```

응답 예시

```json
{
  "id": "f6f2b2b4-8fd1-4f11-a1c1-1b97d6baf001",
  "rss_url": "https://blog.example.com/rss.xml",
  "site_url": "https://blog.example.com",
  "title": "Example Blog",
  "description": "AI and engineering notes",
  "favicon_url": "https://blog.example.com/favicon.ico",
  "language": "ko",
  "category": "blog",
  "tags": ["AI", "tech"],
  "status": "active",
  "registered_by": "web",
  "registered_at": "2026-03-12T09:00:00Z"
}
```

`GET /sources`

```
기본 정렬: last_published_at DESC NULLS LAST, registered_at DESC
기본 page=1, limit=20
최대 limit=100
반환 대상: status = active 만 포함
```

`GET /feeds`

```
기본 정렬: published_at DESC
기본 page=1, limit=20
최대 limit=100
since 형식: 1h / 24h / 7d
반환 대상: active Source에 속한 Feed만 포함
```

`GET /feeds/{feed_id}`

```
Feed 단건 상세 조회
응답에는 source 메타 일부를 포함
반환 대상: active Source에 속한 Feed만 포함
```

**에러 응답 규격**

```json
{
  "error": {
    "code": "duplicate_source",
    "message": "This RSS URL is already registered."
  }
}
```

MVP에서는 최소한 아래 코드들을 고정해두는 것이 좋습니다.

| HTTP | code | 의미 |
|------|------|------|
| `400` | `invalid_rss_url` | 형식 오류 또는 파싱 불가 |
| `404` | `source_not_found` | Source 없음 |
| `409` | `duplicate_source` | 이미 등록된 RSS URL |
| `429` | `rate_limited` | 등록 또는 조회 제한 초과 |

### 3.4 MCP 서버

LLM이 게이트웨이 API를 도구(Tool)로 호출할 수 있도록 MCP 서버를 운영합니다.

**전송 방식**: HTTP SSE (공개 서비스, URL 접근)

**MCP Tool 목록**

| Tool 이름 | 설명 |
|-----------|------|
| `search_sources` | 키워드/언어/태그로 Source 검색 |
| `get_source` | 특정 Source 상세 정보 조회 |
| `get_recent_feeds` | 최근 N시간 이내 발행된 Feed 목록 조회 |
| `get_source_feeds` | 특정 Source의 최근 Feed 목록 조회 |

**MCP Tool 설명 예시**

```
search_sources:
  "등록된 RSS Source 목록을 검색합니다.
   키워드로 Source를 찾거나 언어/카테고리/태그로 필터링할 수 있습니다.
   예: 'AI 관련 한국어 블로그 찾아줘' → keyword=AI, language=ko, category=blog"

get_recent_feeds:
  "최근 N시간 이내 발행된 Feed를 조회합니다.
   특정 Source 또는 전체 Source 대상으로 조회 가능합니다.
   예: '오늘 IT 기술 블로그 글 목록 보여줘' → tag=IT, since=24h"
```

### 3.5 웹 프론트 페이지

로그인 없이 누구나 사용할 수 있는 익명 기반 웹 인터페이스입니다.

**페이지 구성**

| 페이지 | 주요 기능 |
|--------|----------|
| 홈 | 서비스 소개, Source 등록 입력창, 통계 (전체 Source 수, 전체 Feed 수 등) |
| Source 탐색 | 등록된 전체 Source 검색/필터 (키워드, 언어, 카테고리, 태그), 마지막 Source Index 업데이트 시간 표시 |
| API 문서 | 개발자용 REST API / MCP / CLI 사용 가이드 |

**Source 등록 UX 흐름**

```
1. RSS URL 입력
2. [확인] 버튼 클릭 → RSS URL 유효성 실시간 검증
3. 유효하면 블로그 이름/설명/favicon 자동 미리보기
4. 언어, 카테고리, 태그 입력 (선택)
5. [등록] 버튼 → 완료 (로그인 불필요)
```

**웹 등록 시 서버 검증 규칙**

```
허용
- 공개 http/https URL
- 실제로 접근 가능한 RSS/Atom/JSON Feed

차단
- localhost
- 127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
- file://, ftp:// 등 비HTTP 스킴
- HTML 페이지만 존재하고 피드가 아닌 URL
```

**웹 등록 Rate Limit 권장값**

```
- 동일 IP당 분당 5회 검증 요청
- 동일 IP당 일일 20개 Source 등록
```

**Source 탐색 화면 표시 항목**

```
[favicon] [블로그 이름]  [언어]  [카테고리]  [태그]
마지막 Feed 수집: 2026-03-11 14:32  ← Source Index 마지막 수집 시각
최근 Feed: [글 제목] - 2026-03-11
```

**기술 스택**

| 항목 | 기술 |
|------|------|
| 프레임워크 | Next.js |
| 스타일 | Tailwind CSS |
| 인증 | 없음 (완전 익명) |
| 배포 | Vercel |

---

### 3.6 CLI 도구

CLI는 단순 편의 도구가 아니라 **MCP와 동등한 LLM 조회 인터페이스**입니다. MCP를 지원하지 않는 LLM 환경에서도 CLI를 통해 게이트웨이에 접근할 수 있으며, AI Agent가 bash Tool Use로 직접 실행하는 것이 주요 사용 시나리오입니다.

**LLM 연동 인터페이스 비교**

```
MCP 지원 환경 (Claude.ai 등)
  → MCP 서버로 연결

MCP 미지원 환경 (ChatGPT, Gemini, 기타 Agent 등)
  → CLI를 bash Tool Use로 실행
     $ openrssgate feeds --tag AI --lang ko --since 24h --json
```

두 인터페이스가 동일한 게이트웨이 API를 바라보므로 결과가 동일합니다.

**AI Agent 사용 시나리오**

```
사용자: "오늘 AI 관련 한국어 블로그 글 요약해줘"
        ↓
AI Agent
  $ openrssgate feeds --tag AI --lang ko --since 24h --json
  → JSON 결과 수신 → 파싱 → 요약 제공
```

**주요 명령어**

```bash
# 등록된 RSS 목록 조회
openrssgate list
openrssgate list --tag AI --lang ko

# Feed 조회
openrssgate feeds <source_id>
openrssgate feeds --tag AI --lang ko --since 24h
```

**출력 형식**

AI Agent가 파싱하기 쉽도록 JSON 출력을 필수 지원합니다.

```bash
# 기본: 사람이 읽기 좋은 텍스트
openrssgate list

# AI Agent / 스크립트 연동용 JSON (모든 명령어에 지원)
openrssgate list --json
openrssgate feeds --tag AI --since 24h --json
```

**설치 방법**

| 대상 | 설치 방법 | 시기 |
|------|----------|------|
| AI Agent / 개발자 (Python 환경) | `pip install openrssgate` | MVP |
| Mac 일반 사용자 | `brew tap <owner>/tap && brew install openrssgate` | Phase 2 |
| 바이너리 직접 설치 | `curl -L https://rssgateway.io/install.sh \| sh` | Phase 2 |

**기술 스택**

| 항목 | 기술 |
|------|------|
| 언어 | Python |
| CLI 프레임워크 | Typer |
| 출력 | 텍스트 (기본) / JSON (`--json` 옵션, 전 명령어 지원) |
| 배포 | PyPI (`pip install openrssgate`) → brew / 바이너리 (Phase 2) |

---

## 4. 기술 스택

### 4.1 전체 스택

| 영역 | 기술 | 선택 이유 |
|------|------|----------|
| 언어 | Python | feedparser 생태계, FastMCP 지원, LLM 연동 용이 |
| API 프레임워크 | FastAPI | 비동기 처리, 자동 문서화 (Swagger) |
| MCP 프레임워크 | FastMCP | Python 기반 MCP 서버 구현 최적 |
| 웹 프론트 | Next.js + Tailwind CSS | 빠른 개발, Vercel 배포 최적 |
| CLI 도구 | Python + Typer | PyPI 배포, API와 동일 언어로 유지보수 용이 |
| DB | PostgreSQL (NeonDB) | 안정성, 전문 검색 지원, 무료 10GB |
| 캐시 | Redis | API 응답 캐싱, 크론잡 중복 실행 방지 |
| 수집기 | APScheduler | FastAPI 내장, 초기엔 별도 서버 불필요 |
| RSS 파싱 | feedparser | Python RSS/Atom 파싱 표준 라이브러리 |
| HTTP 클라이언트 | httpx | 비동기 HTTP 요청 |

### 4.2 인프라

| 영역 | 서비스 | 비고 |
|------|--------|------|
| DB | NeonDB | PostgreSQL, 무료 10GB, 브랜치 기능 |
| API 서버 | Railway | 간편 배포, $5~10/월 |
| 웹 프론트 | Vercel | Next.js 최적, 무료 티어로 시작 |
| CLI | PyPI | pip install openrssgate |
| 코드 관리 | GitHub | CI/CD 연동 |
| 도메인 | 전용 도메인 | 예: rssgateway.io |

**초기 배포 구조 권장안**

```
Vercel
└── frontend

Railway
├── api service      # FastAPI + MCP SSE endpoint
├── collector worker # APScheduler 전용
└── Redis            # 캐시/락 (Phase 2)

NeonDB
└── PostgreSQL
```

MVP에서는 Redis 없이도 시작할 수 있지만, 수집기 중복 실행 제어가 필요해지는 시점부터 도입합니다.

---

## 5. 프로젝트 구조

```
rss-gateway/
├── backend/                      # FastAPI 서버
│   ├── app/
│   │   ├── api/
│   │   │   ├── sources.py         # Source 등록/조회 API
│   │   │   └── feeds.py           # Feed 조회 API
│   │   ├── mcp/
│   │   │   └── server.py         # MCP 서버 (FastMCP)
│   │   ├── collector/
│   │   │   └── scheduler.py      # 수집기 크론잡 (APScheduler)
│   │   ├── db/
│   │   │   ├── models.py         # DB 모델 (SQLAlchemy)
│   │   │   └── database.py       # DB 연결 설정
│   │   ├── schemas/
│   │   │   ├── source.py          # Pydantic 스키마
│   │   │   └── feed_schema.py         # Feed Pydantic 스키마
│   │   └── main.py               # 진입점
│   ├── tests/
│   ├── .env
│   └── requirements.txt
│
├── frontend/                     # Next.js 웹 프론트
│   ├── pages/
│   │   ├── index.tsx             # 홈 (서비스 소개 + Source 등록)
│   │   ├── explore.tsx           # Source 탐색 (Source Index 업데이트 시간 포함)
│   │   └── docs.tsx              # API 문서
│   ├── components/
│   └── package.json
│
├── cli/                          # CLI 도구 (openrssgate)
│   ├── openrssgate/
│   │   ├── main.py               # Typer CLI 진입점
│   │   ├── commands/
│   │   │   ├── list.py           # openrssgate list
│   │   │   └── feeds.py          # openrssgate feeds
│   ├── setup.py
│   └── README.md
│
└── README.md
```

---

## 6. 인증 및 보안

### 6.1 API 인증

| 접근 유형 | 인증 방식 |
|-----------|----------|
| RSS 조회 (읽기) | 무인증 (공개) |
| 웹 프론트 Source 등록 | 무인증 (익명 등록) |
| CLI / MCP 접근 | 무인증 (조회 전용) |
| Source 수정/삭제 | 운영자 내부 기능 또는 Phase 2 이후 재정의 |

### 6.2 어뷰징 방지 (v1.0 기본)

v1.0에서는 등록 단계의 기본 방어만 적용합니다.

| 정책 | 내용 |
|------|------|
| Rate Limit | IP 기준 분당 요청 수 제한 |
| Source 등록 제한 | IP당 일일 최대 등록 가능 Source 수 제한 |
| 유효성 검증 | 등록 시 RSS URL 실제 접근 가능 여부 확인 |
| 중복 방지 | 동일 RSS URL 재등록 차단 |

### 6.2.1 익명 등록 검증 파이프라인 (차후 개선방안)

웹 프론트 익명 등록을 유지하면서 어뷰징 대응을 강화하기 위해, 향후 `2단계 자동 검증 파이프라인`을 추가할 수 있습니다.

**목표 상태**

```
신규 등록 Source
  ↓
status = pending_review
  ↓
1차 규칙 기반 자동 검증
  ↓
통과 시 active / 애매하면 AI 검토 / 실패 시 hidden 또는 rejected
```

**1차 규칙 기반 자동 검증**

비용이 낮고 확실한 판정이 가능한 항목은 AI 없이 먼저 처리합니다.

```
검사 항목 예시
1. URL 형식 검사
2. localhost / private IP / 내부망 대역 차단
3. HTTP fetch 가능 여부 및 타임아웃 검사
4. RSS / Atom / JSON Feed 파싱 가능 여부
5. rss_url, site_url 기준 중복 등록 검사
6. 비정상 리다이렉트 또는 과도한 리다이렉트 차단
7. 최근 Feed 개수 부족, 제목 반복 패턴 등 명백한 저품질 신호 감지
```

**2차 AI 검토**

규칙 기반 검사로 확정하기 어려운 경우에만 AI Agent가 보조 판정을 수행합니다.

```
AI 검토 대상 예시
1. 광고성 / 스팸성 콘텐츠 여부
2. 동일 사이트의 변형 RSS인지 여부
3. 콘텐츠 발행 패턴이 비정상인지 여부
4. 사람이 볼 만한 정상 Source인지 최종 보조 판단
```

**상태 전이 예시**

| 상태 | 의미 |
|------|------|
| `pending_review` | 등록 직후, 자동 검증 대기 상태 |
| `active` | 검증 통과 후 공개 조회 가능 |
| `hidden` | 운영상 노출 중단, 내부 검토 대상 |
| `rejected` | 자동 검증 또는 AI 검토 실패 |
| `deleted` | 삭제 처리 |

이 파이프라인은 MVP 필수 범위는 아니며, 웹 익명 등록이 안정화된 뒤 Phase 2~3에서 도입하는 것을 목표로 합니다.

### 6.3 커뮤니티 기반 어뷰징 방지 (고도화 계획)

게이트웨이는 로그인을 제공하지 않으므로, **외부 서비스(RSS Reader 등)가 신고를 대신 수집하고 게이트웨이 신고 API로 전송**하는 구조를 채택합니다. 게이트웨이는 신고를 받고 AI가 판단하는 역할만 담당합니다.

**신고 흐름**

```
[RSS Reader / 외부 서비스]
  로그인한 사용자가 신고 버튼 클릭
        ↓
  서비스 자체 API Key로 게이트웨이에 신고 전송
  POST /sources/{source_id}/report
  { "type": "spam", "reporter": "rss-reader-service" }
        ↓
[게이트웨이 신고 API]
  신고 누적 → 임계값 도달 → AI Agent 자동 판단
        ↓
  ┌──────────────┬───────────────┬──────────────┐
  자동 비활성화    숨김+운영자알림   신고 기각
  (명확한 스팸)   (판단 애매)     (정상 Source)
```

**신고 유형 및 가중치**

| 신고 유형 | 설명 | 가중치 |
|----------|------|--------|
| `spam` | 상업성 광고 Source | 높음 |
| `harmful` | 유해 콘텐츠 | 높음 |
| `inaccessible` | RSS URL 장기 접근 불가 | 중간 |
| `duplicate` | 동일 블로그 중복 등록 | 낮음 |

**AI Agent 판단 기준**

신고 점수가 임계값에 도달하면 AI가 해당 Source를 직접 확인합니다.

```
확인 항목:
1. RSS URL 실제 접근 가능 여부
2. 최근 Feed 10개 내용 → 스팸성 여부 판단
3. Feed 발행 패턴 이상 여부 (하루 수백 건 등)
4. 신고 유형과 실제 내용 일치 여부
```

**신고 API 접근 제어**

```
- 등록된 서비스의 API Key 필수 (익명 신고 불가)
- 서비스당 동일 Source에 하루 N건 신고 제한
- 신고 출처(reporter) 기록 → AI 판단 시 참고
- 신고가 기각되면 해당 서비스의 신고 가중치 하락
```

**DB 추가 항목**

```
source_reports 테이블
├── source_id      신고 대상 Source
├── report_type    신고 유형
├── reporter       신고 출처 서비스명
├── weight         신고 가중치
└── created_at     신고 시각

sources 테이블 추가 컬럼 (Phase 2)
├── report_score   누적 신고 점수
├── status         active / hidden / deleted / pending_review
└── ai_reviewed_at AI 마지막 검토 시각
```

---

## 7. 구현 로드맵

### Phase 1: MVP (1~2개월)

```
목표: 기본 동작하는 게이트웨이

[x] DB 스키마 설계 및 생성 (NeonDB)
[x] Source 등록/조회 REST API 구현 (/sources, /feeds)
[x] Source Index 수집기 구현 (APScheduler)
[x] 조회 전용 MCP 서버 구현 (FastMCP)
[x] 웹 프론트 MVP (홈 + Source 등록 + Source 탐색)
[x] CLI 도구 기본 명령어 구현 (list / feeds)
[x] Claude Desktop으로 MCP 연결 검증
[x] Railway + Vercel 배포
```

### Phase 2: 안정화 (2~3개월)

```
목표: 운영 품질 확보

핵심
[x] `POST /v1/sources/validate` 공개 API 추가
[x] `GET /v1/stats` 공개 API 추가
[x] `GET /v1/feeds` 검색/필터 확장 (`q`, `tag`, `category`, `type`)
[x] `GET /v1/sources/{source_id}/status` 공개 API 추가 (`active`만 허용)
[x] 웹 Source 등록 Rate Limiting 적용
[x] 조회 API Rate Limiting 적용
[x] 차등 수집 주기 적용
[x] 모니터링 및 알림 설정

선택
[x] `GET /v1/feeds/{feed_id}` 공개 API 추가
[x] CLI 공개 배포 완료 (`pipx install openrssgate`, `brew install openrssgate`)
    - PyPI 0.1.1 배포 및 설치 검증 완료
    - Homebrew tap (`windbug99/homebrew-tap`) 배포 및 설치 검증 완료

추가 안정화 과제
[x] API Key 인증 시스템
[x] API 응답 Redis 캐싱
[x] Source 등록 `pending_review` 상태 및 운영 상태 전이 정비
[x] 1차 규칙 기반 자동 검증 도입
[x] 운영용 상태 변경 API 구현
[x] API 문서 정비 (Swagger)
```

### Phase 3: 선택적 확장 (3개월 이후)

```
목표: 규모 확장 및 품질 관리

비고: v1.0 출시와 현재 운영 안정화의 필수 범위는 아니며, 트래픽 증가, 외부 연동 확대,
어뷰징 대응 고도화가 실제로 필요해질 때 조건부로 진행합니다.

[ ] 수집기 Worker 분리
[ ] 전문 검색 고도화
[ ] RSS Reader 서비스 연동 준비
[ ] 신고 API 구현 (외부 서비스 연동용)
[ ] 2차 AI 보조 검토 파이프라인 구축
[ ] AI Agent 어뷰징 판단 파이프라인 구축
[ ] Source 신뢰도 점수 시스템
```

### 7.1 현재 진행 상태 (2026-03-13)

```
완료
- Alembic 기반 스키마 및 마이그레이션 구조 준비
- NeonDB 대상 `alembic upgrade head` 적용 완료
- Railway API / collector worker 배포
- Vercel 프론트 배포
- 공개 도메인 연결 및 기본 환경변수 설정
- Claude Desktop local MCP 검증
- 웹 익명 등록 Rate Limiting 적용
- Source 자동 검증 및 상태 전이(`pending_review / active / hidden / rejected`) 구현
- 자동 검증 규칙 고도화(`duplicate_site_url`, `repetitive_entry_titles`, `stale_feed` 등)
- 운영용 상태 요약 및 상태별 Source 조회 API 추가
- 운영용 Source 상태 변경 API 추가 (`/v1/ops/sources/{id}/status`)
- `POST /v1/sources/validate` 공개 API 추가
- `GET /v1/stats` 공개 API 추가
- `GET /v1/feeds` 검색/필터 확장 (`q`, `tag`, `category`, `type`)
- `GET /v1/feeds/{feed_id}` 공개 API 추가
- `GET /v1/sources/{source_id}/status` 공개 API 추가
- 공개 GET API 대상 조회 Rate Limiting 적용
- `/v1/ops/alerts` 운영 알림 API 및 점검 스크립트 추가
- 서비스 API Key 기반 보호 dependency 추가 (`X-API-Key`, `X-Ops-Key`)
- stats / ops summary 응답 캐시 레이어 추가 (Redis 사용 가능, 미설정 시 로컬 fallback)
- Source별 `fetch_interval_minutes` 기반 차등 수집 주기 적용

확인 필요
- Railway API/worker 장기 안정성 모니터링
- Vercel Preview/이전 배포 이력 정리
- CLI PyPI / Homebrew 공개 배포 및 설치 검증 완료
- Redis 실환경 연결 및 TTL 운영값 확정
- PyPI / GitHub / Homebrew tap 외부 설정 완료
```

### 7.2 다음 작업 단계

```
우선순위 1: 운영 안정화
1. Railway API/worker 헬스체크 및 실패 로그 모니터링 정리
2. CORS, 배포 환경변수, 수집 주기 운영값 재점검
3. 기본 운영 문서(장애 대응, 재배포 절차) 간단 정리

우선순위 2: 공개 API 후속 정리
4. Swagger 및 README에 신규 공개 API 예시 추가
5. CLI/프론트에서 신규 공개 API 연동 범위 점검

우선순위 3: 서비스 보호
6. hidden / rejected 상태 운영 기준 구체화
7. 운영자용 검토/복구 인터페이스 추가
8. 자동 검증 규칙 추가 고도화 및 점수화
9. Redis 실환경 연결 및 캐시 무효화 기준 점검

우선순위 4: 배포 완성도
10. CLI 차기 버전 릴리스 운영 정리
11. Vercel / Railway 모니터링 및 알림 설정
12. Preview/old deployment 정리 및 보안 배너 잔여 이력 정리
```

### 7.3 바로 진행할 작업 순서

```
Step 1. 신규 공개 API 문서 반영
- `POST /v1/sources/validate`, `GET /v1/stats`, `GET /v1/feeds/{feed_id}`, `GET /v1/sources/{source_id}/status` 예시 추가
- `GET /v1/feeds` 추가 필터 (`q`, `tag`, `category`, `type`) 사용 예시 정리

Step 2. Railway 운영값 정리
- API / worker 환경변수 최종 점검
- Neon 비밀번호 재발급 후 DATABASE_URL 교체
- 수집 주기 운영값 확정

Step 3. 운영 알림 실환경 연결
- `/v1/ops/summary`, `/v1/ops/alerts`, `scripts/check_ops_alerts.py` 기준으로 배포 환경 점검
- Railway / 외부 모니터링 서비스에서 실패 알림 채널 연결

Step 4. 운영 검토 체계 보강
- hidden / rejected 상태별 운영 기준과 복구 규칙 정리
- 운영자용 검토 인터페이스(`/admin` 또는 `admin.` 서브도메인) 추가

Step 5. 자동 검증 규칙 고도화
- 현재 규칙 위에 도메인 평판, 제목 품질 점수, 발행 빈도 점수 추가
- 필요 시 AI 보조 검토로 넘기는 기준 정의

Step 6. 운영 가시성 추가
- /v1/ops/summary 및 /v1/ops/sources 를 기준으로 모니터링
- 상태별 건수와 최근 실패 Source 점검 루틴 정리

Step 7. CLI 및 배포 마무리
- CLI PyPI 배포 기준과 배포 계정 정리
- 릴리스 버전 정책과 설치 가이드 점검

Step 8. 운영 관측성 추가
- Railway 로그 점검 기준 정리
- Redis 실환경 연결과 캐시 TTL 검증
```

---

## 8. 확장성 계획

### 8.1 Source 규모별 대응

| Source 수 | 인프라 구성 | 예상 비용 |
|-----------|-----------|----------|
| ~1,000개 | 단일 서버 + NeonDB | $10~20/월 |
| ~10,000개 | 수집기 Worker 분리 | $30~50/월 |
| ~100,000개 | Worker 수평 확장 + Redis 큐 | $50~100/월 |

### 8.2 RSS Reader 서비스 연동

게이트웨이와 RSS Reader는 **통합 구조**로 설계합니다.

```
Gateway (공통 백엔드)
├── /api/gateway/*   → AI / 외부 접근용 (공개)
└── /api/reader/*    → 로그인 사용자용 (인증 필요)
```

Source Index DB와 수집 인프라를 공유하므로 중복 없이 Reader 서비스를 추가할 수 있습니다.

---

## 9. 주요 의사결정 기록

| 항목 | 결정 | 이유 |
|------|------|------|
| Feed 보존 기간 | 30일 | RSS는 현재 콘텐츠 소비가 본질, 30일이 Reader 연동 최소 기준선이자 DB 효율 균형점 |
| 용어 정의 | Source (RSS 제공 블로그/사이트), Feed (개별 글) | RSS 생태계 표준 용어 기반, 다양한 콘텐츠 유형 포괄 |
| Feed 수집 방식 | 주기적 캐싱 (옵션 B) | 안정적 응답, 원본 블로그 부하 없음 |
| Feed 저장 범위 | 메타정보만 (제목/URL/발행일) | 저작권 이슈 회피, DB 경량 유지 |
| MCP 전송 방식 | HTTP SSE | 공개 서비스, URL로 누구나 접근 가능 |
| DB | NeonDB | Supabase 무료 소진, 10GB 무료, 브랜치 기능 |
| Reader 통합 여부 | 게이트웨이와 통합 | 수집 인프라 공유, 중복 제거 |
| 초기 검증 방법 | Claude Desktop MCP 연결 | 가장 빠른 검증 방법 |
| 웹 프론트 인증 | 없음 (완전 익명) | 게이트웨이는 인프라 역할, 로그인 불필요 |
| Source 등록 채널 | 웹 프론트만 허용 | 공개 등록 창구를 하나로 제한해 어뷰징 대응 단순화 |
| 익명 등록 검증 전략 | 1차 규칙 기반, 2차 AI 보조 검토로 확장 예정 | 비용과 정확도를 함께 관리하기 위한 단계적 검증 구조 |
| 웹 프론트 프레임워크 | Next.js | Vercel 배포 최적, 빠른 개발 |
| CLI / MCP 권한 | 조회 전용 | LLM 연동은 유지하되 익명 등록 남용을 방지 |
| CLI 목적 | MCP와 동등한 LLM 조회 인터페이스 | MCP 미지원 환경에서 bash Tool Use로 동일한 조회 경험 제공 |
| CLI 언어 | Python + Typer | 백엔드와 동일 언어, PyPI 배포 용이, AI 환경 친화적 |
| 어뷰징 신고 방식 | 외부 서비스가 신고 API 호출 | 게이트웨이 단순 유지, 신고 품질은 외부 서비스 로그인으로 보장 |

---

*본 문서는 기획 단계의 계획서이며, 구현 진행에 따라 업데이트됩니다.*
