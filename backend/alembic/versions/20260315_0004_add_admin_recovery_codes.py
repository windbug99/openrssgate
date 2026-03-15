"""add admin recovery codes

Revision ID: 20260315_0004
Revises: 20260315_0003
Create Date: 2026-03-15 23:55:00
"""

from __future__ import annotations

from alembic import op
import sqlalchemy as sa


revision = "20260315_0004"
down_revision = "20260315_0003"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("admin_users", sa.Column("recovery_codes_hashes", sa.Text(), nullable=True))


def downgrade() -> None:
    op.drop_column("admin_users", "recovery_codes_hashes")
