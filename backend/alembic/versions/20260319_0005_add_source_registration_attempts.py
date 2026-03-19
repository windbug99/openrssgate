"""add source registration attempts

Revision ID: 20260319_0005
Revises: 20260315_0004
Create Date: 2026-03-19 18:00:00
"""

from __future__ import annotations

from alembic import op
import sqlalchemy as sa


revision = "20260319_0005"
down_revision = "20260315_0004"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "source_registration_attempts",
        sa.Column("id", sa.String(length=36), nullable=False),
        sa.Column("source_id", sa.String(length=36), nullable=True),
        sa.Column("rss_url", sa.String(length=2048), nullable=False),
        sa.Column("site_url", sa.String(length=2048), nullable=True),
        sa.Column("title", sa.String(length=255), nullable=True),
        sa.Column("result", sa.String(length=32), nullable=False),
        sa.Column("result_reason", sa.String(length=255), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("(CURRENT_TIMESTAMP)"), nullable=False),
        sa.ForeignKeyConstraint(["source_id"], ["sources.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_source_registration_attempts_created_at", "source_registration_attempts", ["created_at"], unique=False)


def downgrade() -> None:
    op.drop_index("ix_source_registration_attempts_created_at", table_name="source_registration_attempts")
    op.drop_table("source_registration_attempts")
