# OpenRSSGate CLI

## Install

Local install with `pipx`:

```bash
cd /Users/tomato/cursor/openrssgate/cli
pipx install .
```

After PyPI release:

```bash
pipx install openrssgate
```

or:

```bash
pip install openrssgate
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
brew tap <owner>/tap
brew install openrssgate
```

## Run

```bash
openrssgate list
openrssgate feeds --since 7d
openrssgate stats
openrssgate validate https://example.com/rss.xml
openrssgate feed <feed_id>
```

Set `OPENRSSGATE_API_BASE_URL` to the backend base URL if needed.

```bash
export OPENRSSGATE_API_BASE_URL=https://openrssgate-production.up.railway.app/v1
openrssgate list
openrssgate feeds --q openai --tag ai --since 7d
```
