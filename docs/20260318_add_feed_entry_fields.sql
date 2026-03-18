-- Manual migration for persisting feed entry author, summary, and content.
-- These columns are nullable because many feeds do not provide all three fields.

ALTER TABLE feeds ADD COLUMN author VARCHAR(255);
ALTER TABLE feeds ADD COLUMN summary TEXT;
ALTER TABLE feeds ADD COLUMN content TEXT;
