-- Manual migration for persisting AI review audit fields on sources.
-- These columns are intentionally nullable because most sources will not
-- go through AI review. They are populated when a create-time moderation
-- review reaches the AI step or falls back after an AI attempt.

ALTER TABLE sources ADD COLUMN ai_reviewed_at TIMESTAMP;
ALTER TABLE sources ADD COLUMN ai_review_source VARCHAR(32);
ALTER TABLE sources ADD COLUMN ai_review_reason TEXT;
ALTER TABLE sources ADD COLUMN ai_review_confidence VARCHAR(16);
ALTER TABLE sources ADD COLUMN ai_review_decision VARCHAR(32);

CREATE INDEX IF NOT EXISTS ix_sources_ai_reviewed_at ON sources (ai_reviewed_at);
CREATE INDEX IF NOT EXISTS ix_sources_status_ai_reviewed_at ON sources (status, ai_reviewed_at);
