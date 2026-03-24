import { pgTable, text, varchar, timestamp, integer, boolean, index, unique } from "drizzle-orm/pg-core";
import { sql } from "drizzle-orm";

export const sources = pgTable("sources", {
  id: varchar("id", { length: 36 }).primaryKey().$defaultFn(() => crypto.randomUUID()),
  rss_url: varchar("rss_url", { length: 2048 }).notNull(),
  site_url: varchar("site_url", { length: 2048 }).notNull(),
  title: varchar("title", { length: 255 }).notNull(),
  description: text("description"),
  favicon_url: varchar("favicon_url", { length: 2048 }),
  language: varchar("language", { length: 16 }),
  type: varchar("type", { length: 32 }),
  categories: varchar("categories", { length: 255 }), // CSV string
  tags: varchar("tags", { length: 255 }), // CSV string
  status: varchar("status", { length: 32 }).default("active").notNull(),
  status_reason: varchar("status_reason", { length: 255 }),
  ai_reviewed_at: timestamp("ai_reviewed_at", { withTimezone: true }),
  ai_review_source: varchar("ai_review_source", { length: 32 }),
  ai_review_reason: text("ai_review_reason"),
  ai_review_confidence: varchar("ai_review_confidence", { length: 16 }),
  ai_review_decision: varchar("ai_review_decision", { length: 32 }),
  feed_format: varchar("feed_format", { length: 32 }),
  fetch_interval_minutes: integer("fetch_interval_minutes").default(60).notNull(),
  last_fetched_at: timestamp("last_fetched_at", { withTimezone: true }),
  last_published_at: timestamp("last_published_at", { withTimezone: true }),
  consecutive_fail_count: integer("consecutive_fail_count").default(0).notNull(),
  registered_by: varchar("registered_by", { length: 32 }).default("web").notNull(),
  registered_at: timestamp("registered_at", { withTimezone: true }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
  unique("uq_sources_rss_url").on(table.rss_url),
  index("ix_sources_status_last_fetched_at").on(table.status, table.last_fetched_at),
  index("ix_sources_language_type").on(table.language, table.type),
]);

export const feeds = pgTable("feeds", {
  id: varchar("id", { length: 36 }).primaryKey().$defaultFn(() => crypto.randomUUID()),
  source_id: varchar("source_id", { length: 36 }).notNull().references(() => sources.id, { onDelete: 'cascade' }),
  guid: varchar("guid", { length: 512 }).notNull(),
  title: varchar("title", { length: 512 }).notNull(),
  feed_url: varchar("feed_url", { length: 2048 }).notNull(),
  author: varchar("author", { length: 255 }),
  summary: text("summary"),
  content: text("content"),
  published_at: timestamp("published_at", { withTimezone: true }),
}, (table) => [
  unique("uq_feeds_source_guid").on(table.source_id, table.guid),
  index("ix_feeds_source_published_at").on(table.source_id, table.published_at),
  index("ix_feeds_published_at").on(table.published_at),
]);

export const adminUsers = pgTable("admin_users", {
  id: varchar("id", { length: 36 }).primaryKey().$defaultFn(() => crypto.randomUUID()),
  email: varchar("email", { length: 255 }).notNull().unique(),
  password_hash: varchar("password_hash", { length: 512 }).notNull(),
  totp_secret: varchar("totp_secret", { length: 128 }),
  totp_enabled: boolean("totp_enabled").default(false).notNull(),
  recovery_codes_hashes: text("recovery_codes_hashes"),
  last_login_at: timestamp("last_login_at", { withTimezone: true }),
  created_at: timestamp("created_at", { withTimezone: true }).default(sql`CURRENT_TIMESTAMP`).notNull(),
});

export const adminSessions = pgTable("admin_sessions", {
  id: varchar("id", { length: 36 }).primaryKey().$defaultFn(() => crypto.randomUUID()),
  admin_user_id: varchar("admin_user_id", { length: 36 }).notNull().references(() => adminUsers.id, { onDelete: 'cascade' }),
  token_hash: varchar("token_hash", { length: 128 }).notNull().unique(),
  otp_verified_at: timestamp("otp_verified_at", { withTimezone: true }),
  expires_at: timestamp("expires_at", { withTimezone: true }).notNull(),
  created_at: timestamp("created_at", { withTimezone: true }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
  index("ix_admin_sessions_expires_at").on(table.expires_at),
]);

export const adminAuditLogs = pgTable("admin_audit_logs", {
  id: varchar("id", { length: 36 }).primaryKey().$defaultFn(() => crypto.randomUUID()),
  admin_user_id: varchar("admin_user_id", { length: 36 }).references(() => adminUsers.id),
  source_id: varchar("source_id", { length: 36 }).references(() => sources.id),
  action: varchar("action", { length: 64 }).notNull(),
  reason: varchar("reason", { length: 255 }),
  from_status: varchar("from_status", { length: 32 }),
  to_status: varchar("to_status", { length: 32 }),
  created_at: timestamp("created_at", { withTimezone: true }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
  index("ix_admin_audit_logs_created_at").on(table.created_at),
]);

export const sourceRegistrationAttempts = pgTable("source_registration_attempts", {
  id: varchar("id", { length: 36 }).primaryKey().$defaultFn(() => crypto.randomUUID()),
  source_id: varchar("source_id", { length: 36 }).references(() => sources.id),
  rss_url: varchar("rss_url", { length: 2048 }).notNull(),
  site_url: varchar("site_url", { length: 2048 }),
  title: varchar("title", { length: 255 }),
  result: varchar("result", { length: 32 }).notNull(),
  result_reason: varchar("result_reason", { length: 255 }),
  created_at: timestamp("created_at", { withTimezone: true }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
  index("ix_source_registration_attempts_created_at").on(table.created_at),
]);
