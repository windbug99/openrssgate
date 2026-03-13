-- Manual migration for the source metadata refactor.
-- Assumes the existing `sources` table already has:
--   language TEXT
--   category TEXT
--   tags TEXT
--
-- This script keeps the legacy `category` column in place for audit/rollback.
-- The application will read from `type` and `categories` after deployment.

ALTER TABLE sources ADD COLUMN type VARCHAR(32);
ALTER TABLE sources ADD COLUMN categories VARCHAR(255);

UPDATE sources
SET type = CASE
    WHEN category IS NULL OR TRIM(category) = '' THEN NULL
    WHEN LOWER(TRIM(category)) IN (
        'blog',
        'news',
        'magazine',
        'newsletter',
        'podcast',
        'forum',
        'documentation',
        'research',
        'video',
        'other'
    ) THEN LOWER(TRIM(category))
    ELSE NULL
END,
categories = CASE
    WHEN category IS NULL OR TRIM(category) = '' THEN NULL
    WHEN LOWER(TRIM(category)) IN (
        'tech',
        'business',
        'finance',
        'science',
        'health',
        'education',
        'design',
        'culture',
        'entertainment',
        'gaming',
        'sports',
        'lifestyle',
        'travel',
        'food',
        'fashion',
        'hobby',
        'automotive',
        'politics',
        'security',
        'environment',
        'media',
        'other'
    ) THEN LOWER(TRIM(category))
    ELSE NULL
END
WHERE category IS NOT NULL;

DROP INDEX IF EXISTS ix_sources_language_category;
CREATE INDEX IF NOT EXISTS ix_sources_language_type ON sources (language, type);

-- Optional cleanup after you verify the migration result:
-- UPDATE sources SET type = 'other' WHERE type IS NULL AND category IS NOT NULL AND TRIM(category) <> '';
-- ALTER TABLE sources DROP COLUMN category;
