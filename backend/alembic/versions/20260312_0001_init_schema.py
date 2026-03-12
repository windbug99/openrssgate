"""init schema

Revision ID: 20260312_0001
Revises:
Create Date: 2026-03-12 17:30:00
"""

from __future__ import annotations

from alembic import op
import sqlalchemy as sa


revision = "20260312_0001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "sources",
        sa.Column("id", sa.String(length=36), nullable=False),
        sa.Column("rss_url", sa.String(length=2048), nullable=False),
        sa.Column("site_url", sa.String(length=2048), nullable=False),
        sa.Column("title", sa.String(length=255), nullable=False),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("favicon_url", sa.String(length=2048), nullable=True),
        sa.Column("language", sa.String(length=16), nullable=True),
        sa.Column("category", sa.String(length=32), nullable=True),
        sa.Column("tags", sa.String(length=255), nullable=True),
        sa.Column("status", sa.String(length=32), nullable=False),
        sa.Column("feed_format", sa.String(length=32), nullable=True),
        sa.Column("fetch_interval_minutes", sa.Integer(), nullable=False),
        sa.Column("last_fetched_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("last_published_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("consecutive_fail_count", sa.Integer(), nullable=False),
        sa.Column("registered_by", sa.String(length=32), nullable=False),
        sa.Column("registered_at", sa.DateTime(timezone=True), server_default=sa.text("(CURRENT_TIMESTAMP)"), nullable=False),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("rss_url", name="uq_sources_rss_url"),
    )
    op.create_index("ix_sources_language_category", "sources", ["language", "category"], unique=False)
    op.create_index("ix_sources_status_last_fetched_at", "sources", ["status", "last_fetched_at"], unique=False)

    op.create_table(
        "feeds",
        sa.Column("id", sa.String(length=36), nullable=False),
        sa.Column("source_id", sa.String(length=36), nullable=False),
        sa.Column("guid", sa.String(length=512), nullable=False),
        sa.Column("title", sa.String(length=512), nullable=False),
        sa.Column("feed_url", sa.String(length=2048), nullable=False),
        sa.Column("published_at", sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(["source_id"], ["sources.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("source_id", "guid", name="uq_feeds_source_guid"),
    )
    op.create_index("ix_feeds_published_at", "feeds", ["published_at"], unique=False)
    op.create_index("ix_feeds_source_published_at", "feeds", ["source_id", "published_at"], unique=False)


def downgrade() -> None:
    op.drop_index("ix_feeds_source_published_at", table_name="feeds")
    op.drop_index("ix_feeds_published_at", table_name="feeds")
    op.drop_table("feeds")
    op.drop_index("ix_sources_status_last_fetched_at", table_name="sources")
    op.drop_index("ix_sources_language_category", table_name="sources")
    op.drop_table("sources")
