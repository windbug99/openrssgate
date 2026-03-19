from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, ForeignKey, Index, Integer, String, Text, UniqueConstraint, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.database import Base


class Source(Base):
    __tablename__ = "sources"
    __table_args__ = (
        UniqueConstraint("rss_url", name="uq_sources_rss_url"),
        Index("ix_sources_status_last_fetched_at", "status", "last_fetched_at"),
        Index("ix_sources_language_type", "language", "type"),
    )

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    rss_url: Mapped[str] = mapped_column(String(2048), nullable=False)
    site_url: Mapped[str] = mapped_column(String(2048), nullable=False)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[str | None] = mapped_column(Text())
    favicon_url: Mapped[str | None] = mapped_column(String(2048))
    language: Mapped[str | None] = mapped_column(String(16))
    source_type: Mapped[str | None] = mapped_column("type", String(32))
    categories: Mapped[str | None] = mapped_column(String(255))
    tags: Mapped[str | None] = mapped_column(String(255))
    status: Mapped[str] = mapped_column(String(32), default="active", nullable=False)
    status_reason: Mapped[str | None] = mapped_column(String(255))
    ai_reviewed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    ai_review_source: Mapped[str | None] = mapped_column(String(32))
    ai_review_reason: Mapped[str | None] = mapped_column(Text())
    ai_review_confidence: Mapped[str | None] = mapped_column(String(16))
    ai_review_decision: Mapped[str | None] = mapped_column(String(32))
    feed_format: Mapped[str | None] = mapped_column(String(32))
    fetch_interval_minutes: Mapped[int] = mapped_column(Integer, default=60, nullable=False)
    last_fetched_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    last_published_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    consecutive_fail_count: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    registered_by: Mapped[str] = mapped_column(String(32), default="web", nullable=False)
    registered_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    feeds: Mapped[list[Feed]] = relationship(back_populates="source", cascade="all, delete-orphan")
    moderation_events: Mapped[list[AdminAuditLog]] = relationship(back_populates="source")
    registration_attempts: Mapped[list[SourceRegistrationAttempt]] = relationship(back_populates="source")


class Feed(Base):
    __tablename__ = "feeds"
    __table_args__ = (
        UniqueConstraint("source_id", "guid", name="uq_feeds_source_guid"),
        Index("ix_feeds_source_published_at", "source_id", "published_at"),
        Index("ix_feeds_published_at", "published_at"),
    )

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    source_id: Mapped[str] = mapped_column(String(36), ForeignKey("sources.id"), nullable=False)
    guid: Mapped[str] = mapped_column(String(512), nullable=False)
    title: Mapped[str] = mapped_column(String(512), nullable=False)
    feed_url: Mapped[str] = mapped_column(String(2048), nullable=False)
    author: Mapped[str | None] = mapped_column(String(255))
    summary: Mapped[str | None] = mapped_column(Text())
    content: Mapped[str | None] = mapped_column(Text())
    published_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    source: Mapped[Source] = relationship(back_populates="feeds")


class AdminUser(Base):
    __tablename__ = "admin_users"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    email: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(String(512), nullable=False)
    totp_secret: Mapped[str | None] = mapped_column(String(128))
    totp_enabled: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    recovery_codes_hashes: Mapped[str | None] = mapped_column(Text())
    last_login_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    sessions: Mapped[list[AdminSession]] = relationship(back_populates="user", cascade="all, delete-orphan")
    audit_logs: Mapped[list[AdminAuditLog]] = relationship(back_populates="admin_user")


class AdminSession(Base):
    __tablename__ = "admin_sessions"
    __table_args__ = (Index("ix_admin_sessions_expires_at", "expires_at"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    admin_user_id: Mapped[str] = mapped_column(String(36), ForeignKey("admin_users.id"), nullable=False)
    token_hash: Mapped[str] = mapped_column(String(128), unique=True, nullable=False)
    otp_verified_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    user: Mapped[AdminUser] = relationship(back_populates="sessions")


class AdminAuditLog(Base):
    __tablename__ = "admin_audit_logs"
    __table_args__ = (Index("ix_admin_audit_logs_created_at", "created_at"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    admin_user_id: Mapped[str | None] = mapped_column(String(36), ForeignKey("admin_users.id"))
    source_id: Mapped[str | None] = mapped_column(String(36), ForeignKey("sources.id"))
    action: Mapped[str] = mapped_column(String(64), nullable=False)
    reason: Mapped[str | None] = mapped_column(String(255))
    from_status: Mapped[str | None] = mapped_column(String(32))
    to_status: Mapped[str | None] = mapped_column(String(32))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    admin_user: Mapped[AdminUser | None] = relationship(back_populates="audit_logs")
    source: Mapped[Source | None] = relationship(back_populates="moderation_events")


class SourceRegistrationAttempt(Base):
    __tablename__ = "source_registration_attempts"
    __table_args__ = (Index("ix_source_registration_attempts_created_at", "created_at"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    source_id: Mapped[str | None] = mapped_column(String(36), ForeignKey("sources.id"))
    rss_url: Mapped[str] = mapped_column(String(2048), nullable=False)
    site_url: Mapped[str | None] = mapped_column(String(2048))
    title: Mapped[str | None] = mapped_column(String(255))
    result: Mapped[str] = mapped_column(String(32), nullable=False)
    result_reason: Mapped[str | None] = mapped_column(String(255))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    source: Mapped[Source | None] = relationship(back_populates="registration_attempts")
