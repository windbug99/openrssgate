# Admin Web MVP 작업리스트

## 목표

- `admin.` 웹페이지에서 관리자 로그인
- 이메일 + 비밀번호 + TOTP 2차 인증
- `pending_review`, `hidden`, `rejected` Source 조회
- Source 상태 변경
- Source 삭제

## 작업리스트

- [x] 관리자 계정/세션/TOTP 저장 모델 추가
- [x] 관리자 로그인 API 추가
- [x] TOTP 설정/검증 API 추가
- [x] 보호된 관리자 Source 목록/상세 API 추가
- [x] 보호된 관리자 Source 상태 변경 API 추가
- [x] 보호된 관리자 Source 삭제 API 추가
- [ ] Alembic 마이그레이션 추가 및 적용 확인
- [ ] 관리자 프론트 API 클라이언트 추가
- [ ] `/admin/login` 페이지 추가
- [ ] `/admin/setup-otp` 페이지 추가
- [ ] `/admin/sources` 목록 페이지 추가
- [ ] `/admin/sources/[sourceId]` 상세 페이지 추가
- [ ] 상태 변경/삭제 액션 연결
- [ ] 관리자 인증 토큰 저장 방식 보강
- [ ] 감사 로그 조회 UI 추가
- [ ] 관리자 복구 코드 UX 추가
- [ ] 테스트 보강

## 비고

- 현재 구현은 MVP 기준이며, 초기 관리자 계정은 환경변수 `ADMIN_BOOTSTRAP_EMAIL`, `ADMIN_BOOTSTRAP_PASSWORD`로 부트스트랩합니다.
- TOTP는 Google Authenticator 호환 `otpauth://` URI를 반환합니다.
- 현재 프론트 토큰 저장은 단순 구현을 우선하며, 이후 HttpOnly 쿠키 기반으로 강화하는 것이 좋습니다.
