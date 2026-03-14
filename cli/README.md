# OpenRSSGate CLI

## Install

권장 설치 방식은 `pipx` 또는 Homebrew입니다.

Local install with `pipx`:

```bash
cd /Users/tomato/cursor/openrssgate/cli
pipx install .
```

After PyPI release:

```bash
pipx install openrssgate
openrssgate list
```

If `~/.local/bin` is not on your shell `PATH` yet:

```bash
pipx ensurepath
source ~/.zshrc
openrssgate list
```

Install directly from GitHub before the PyPI release:

```bash
pipx install "git+https://github.com/<owner>/openrssgate.git#subdirectory=cli"
```

Release steps are documented in [RELEASE.md](/Users/tomato/cursor/openrssgate/cli/RELEASE.md).
Homebrew tap packaging notes are documented in [homebrew/README.md](/Users/tomato/cursor/openrssgate/cli/homebrew/README.md).
External service setup steps are documented in [EXTERNAL_SETUP.md](/Users/tomato/cursor/openrssgate/cli/EXTERNAL_SETUP.md).

After Homebrew tap release:

```bash
brew tap windbug99/homebrew-tap
brew install openrssgate
openrssgate list
```

Verified release:

- PyPI: `openrssgate==0.1.1`
- Homebrew tap: `windbug99/homebrew-tap`

## Run

The CLI uses the deployed OpenRSSGate API by default. Set `OPENRSSGATE_API_BASE_URL` only if you want to target a custom server.

```bash
openrssgate list
openrssgate feeds --q openai --tag ai --since 7d
openrssgate stats
openrssgate validate https://example.com/rss.xml
openrssgate feed <feed_id>
```

To target a local or self-hosted backend:

```bash
export OPENRSSGATE_API_BASE_URL=http://127.0.0.1:8000/v1
openrssgate list
```
