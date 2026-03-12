#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

python -m alembic upgrade head
exec python -m app.collector.worker
