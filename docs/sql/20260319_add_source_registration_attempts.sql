CREATE TABLE source_registration_attempts (
  id VARCHAR(36) PRIMARY KEY,
  source_id VARCHAR(36) NULL REFERENCES sources(id),
  rss_url VARCHAR(2048) NOT NULL,
  site_url VARCHAR(2048) NULL,
  title VARCHAR(255) NULL,
  result VARCHAR(32) NOT NULL,
  result_reason VARCHAR(255) NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX ix_source_registration_attempts_created_at
  ON source_registration_attempts (created_at);
