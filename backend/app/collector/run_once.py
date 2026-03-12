from __future__ import annotations

import asyncio

from app.collector.scheduler import run_collection_cycle
from app.db.database import SessionLocal


async def main() -> None:
    with SessionLocal() as db:
        result = await run_collection_cycle(db)
    print(result)


if __name__ == "__main__":
    asyncio.run(main())
