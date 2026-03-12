# OpenRSSGate CLI

## Install

Local install with `pipx`:

```bash
cd /Users/tomato/cursor/rssgate/cli
pipx install .
```

Install directly from GitHub:

```bash
pipx install "git+https://github.com/<owner>/openrssgate.git#subdirectory=cli"
```

## Run

```bash
openrssgate list
openrssgate feeds --since 7d
```

Set `RSSGATE_API_BASE_URL` to the backend base URL if needed.

```bash
export RSSGATE_API_BASE_URL=https://openrssgate-production.up.railway.app/v1
openrssgate list
openrssgate feeds --since 7d
```

Legacy compatibility:

```bash
rssgate list
```
