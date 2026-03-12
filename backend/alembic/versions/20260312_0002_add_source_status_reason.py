"""add source status reason

Revision ID: 20260312_0002
Revises: 20260312_0001
Create Date: 2026-03-12 22:30:00
"""

from __future__ import annotations

from alembic import op
import sqlalchemy as sa


revision = "20260312_0002"
down_revision = "20260312_0001"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("sources", sa.Column("status_reason", sa.String(length=255), nullable=True))


def downgrade() -> None:
    op.drop_column("sources", "status_reason")
