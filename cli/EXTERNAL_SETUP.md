# 외부 설정 가이드

이 문서는 저장소 내부 구현이 끝난 뒤, `openrssgate` CLI를 실제로 배포하기 위해 사용자가 직접 해야 하는 외부 작업을 단계별로 정리한 문서입니다.

현재 저장소 안에는 아래 항목이 이미 준비되어 있습니다.

- PyPI 배포용 패키지 메타데이터
- GitHub Actions 릴리스 workflow
- Homebrew formula 템플릿 및 생성 스크립트
- Homebrew tap 반영 workflow 초안

현재 `openrssgate 0.1.2` 기준으로 아래 외부 설정과 첫 배포 검증은 완료되었습니다.

현재 권장 실행 명령은 `org`이며, `openrssgate`는 하위 호환 alias로 유지됩니다.

완료된 항목:

- PyPI Trusted Publishing 연결
- GitHub Actions 릴리스 workflow 실행
- Homebrew tap 저장소 생성 및 workflow 연동
- `pipx install openrssgate` 검증
- `brew install openrssgate` 검증

아래 내용은 다음 버전 릴리스 때 반복할 참고 절차입니다.

---

## 1단계. PyPI 프로젝트 준비

목표: `pip install openrssgate`가 실제로 동작하도록 준비합니다.

### 해야 할 일

1. PyPI 계정으로 로그인합니다.
2. `openrssgate` 패키지 이름이 비어 있는지 확인합니다.
3. 가능하면 `openrssgate` 프로젝트를 먼저 생성하거나 첫 배포를 준비합니다.
4. GitHub Actions에서 안전하게 배포할 수 있도록 Trusted Publishing을 설정합니다.

### 권장 방법

PyPI API Token을 장기 보관하는 방식보다 `Trusted Publishing`을 권장합니다.

### 확인해야 할 값

- 패키지 이름: `openrssgate`
- GitHub 저장소 경로: 실제 저장소와 일치해야 함
- Workflow 파일: `.github/workflows/release-openrssgate-cli.yml`

### 작업이 끝났는지 확인하는 방법

- PyPI 설정 화면에서 GitHub 저장소와 workflow가 연결되어 있는지 확인
- 첫 배포 이후 `https://pypi.org/project/openrssgate/` 접근 가능 여부 확인

---

## 2단계. GitHub 저장소 설정

목표: GitHub Actions가 PyPI 배포와 Homebrew tap 반영을 수행할 수 있게 합니다.

### 해야 할 일

1. GitHub 저장소의 `Settings > Actions`로 이동합니다.
2. GitHub Actions 실행이 허용되어 있는지 확인합니다.
3. OIDC 기반 배포를 위해 workflow가 `id-token: write`를 사용할 수 있는 상태인지 확인합니다.
4. Homebrew tap 반영에 필요한 secrets를 등록합니다.

### 등록해야 할 GitHub Secrets

- `OPENRSSGATE_HOMEBREW_TAP_REPOSITORY`
  예: `your-org/homebrew-tap`
- `OPENRSSGATE_HOMEBREW_TAP_TOKEN`
  Homebrew tap 저장소에 push 가능한 토큰

### 어디에 등록하나요

GitHub 저장소:
`Settings > Secrets and variables > Actions > New repository secret`

### 작업이 끝났는지 확인하는 방법

- 두 secret가 저장소에 등록되어 있는지 확인
- workflow 실행 화면에서 secret 미설정 오류가 없는지 확인

---

## 3단계. Homebrew tap 저장소 준비

목표: `brew install openrssgate`가 동작할 수 있도록 별도 tap 저장소를 준비합니다.

### 해야 할 일

1. GitHub에 Homebrew tap 저장소를 만듭니다.
2. 저장소 이름은 보통 `homebrew-tap` 형태로 만듭니다.
3. 저장소 루트에 `Formula/` 디렉터리를 준비합니다.
4. GitHub Actions가 이 저장소에 push할 수 있도록 token 권한을 확인합니다.

### 권장 형태

- 저장소 이름 예시: `homebrew-tap`
- 설치 명령 예시:

```bash
brew tap <owner>/tap
brew install openrssgate
```

### 작업이 끝났는지 확인하는 방법

- tap 저장소가 GitHub에 생성되어 있는지 확인
- `Formula/` 디렉터리가 있는지 확인
- Actions에서 사용할 token으로 push 가능한지 확인

---

## 4단계. 첫 릴리스 실행

목표: 실제로 `openrssgate`를 PyPI와 Homebrew 쪽으로 배포합니다.

### 해야 할 일

1. CLI 버전을 올립니다.
2. 버전이 아래 3개 파일에 모두 동일하게 들어갔는지 확인합니다.
3. Git 태그를 생성해 push합니다.
4. GitHub Actions 릴리스 workflow가 성공하는지 확인합니다.
5. 생성된 Homebrew formula artifact를 기준으로 tap 반영 workflow를 실행합니다.

### 버전을 수정해야 하는 파일

- `cli/pyproject.toml`
- `cli/setup.py`
- `cli/openrssgate/__init__.py`

### 태그 예시

```bash
git tag openrssgate-cli-v0.1.2
git push origin openrssgate-cli-v0.1.2
```

### 실행되는 workflow

- PyPI 배포:
  `.github/workflows/release-openrssgate-cli.yml`
- Homebrew tap 반영:
  `.github/workflows/publish-openrssgate-homebrew.yml`

### Homebrew workflow 실행에 필요한 값

- `version`
  예: `0.1.2`
- `formula_artifact_run_id`
  앞 단계 릴리스 workflow에서 생성된 artifact가 포함된 GitHub Actions run id

### 작업이 끝났는지 확인하는 방법

- GitHub Actions에서 release workflow가 성공했는지 확인
- PyPI에 `openrssgate` 새 버전이 올라왔는지 확인
- Homebrew tap 저장소에 `Formula/openrssgate.rb`가 반영되었는지 확인

---

## 5단계. 최종 설치 검증

목표: 사용자가 실제로 설치 가능한지 확인합니다.

### PyPI 설치 검증

```bash
pipx install openrssgate
org --help
org list
```

### Homebrew 설치 검증

```bash
brew tap windbug99/homebrew-tap
brew install openrssgate
org --help
org list
```

### 확인 포인트

- `org` 명령이 정상 실행되는지
- `--help`가 출력되는지
- API base URL 환경변수를 주었을 때 실제 조회가 되는지

참고:

- `brew install openrssgate`는 패키지 설치 명령입니다.
- 설치 후 실행은 `org`를 기본으로 사용합니다.
- `openrssgate`가 남아 있더라도 배포 검증은 `org` 기준으로 진행하는 것이 맞습니다.

---

## 실제로 사용자가 해야 하는 핵심 작업 요약

아래 항목은 제가 이 저장소 안에서 대신 끝낼 수 없고, 직접 설정하셔야 합니다.

1. 새 버전 번호 결정
2. GitHub tag 기반 릴리스 실행
3. Homebrew formula workflow 실행
4. PyPI / Homebrew 실제 설치 재검증

---

## 참고 문서

- 릴리스 절차: [RELEASE.md](/Users/tomato/cursor/openrssgate/cli/RELEASE.md)
- GitHub Actions: [GITHUB_ACTIONS.md](/Users/tomato/cursor/openrssgate/cli/GITHUB_ACTIONS.md)
- Homebrew 준비: [homebrew/README.md](/Users/tomato/cursor/openrssgate/cli/homebrew/README.md)
