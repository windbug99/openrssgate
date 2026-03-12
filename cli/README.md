# CLI

## Run

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python -m rssgate.main list
python -m rssgate.main feeds --since 24h
```

Set `RSSGATE_API_BASE_URL` to the backend base URL if needed.
