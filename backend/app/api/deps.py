from fastapi import Depends
from sqlalchemy.orm import Session

from app.db.database import get_db


DbSession = Depends(get_db)


def get_session(db: Session = DbSession) -> Session:
    return db
