-- Neon/Postgres RLS template for OpenRSSGate.
--
-- Assumptions:
-- 1. The application connects with a dedicated DB role, not a superuser.
-- 2. The backend server is the only component that should read/write admin tables.
-- 3. Public/client DB access is not used.
--
-- Replace these placeholders before executing:
--   app_backend_role    -> the role used by the FastAPI backend at runtime
--   migration_role      -> the role used for Alembic migrations
--
-- This template enables RLS only on sensitive admin tables.
-- `feeds`, `sources`, and `alembic_version` are intentionally left alone.


BEGIN;

ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_audit_logs ENABLE ROW LEVEL SECURITY;

-- Optional: uncomment if you want table owners to also be bound by policies.
-- Be careful: FORCE RLS can break admin access if policies are incomplete.
-- ALTER TABLE admin_users FORCE ROW LEVEL SECURITY;
-- ALTER TABLE admin_sessions FORCE ROW LEVEL SECURITY;
-- ALTER TABLE admin_audit_logs FORCE ROW LEVEL SECURITY;


DROP POLICY IF EXISTS admin_users_backend_all ON admin_users;
DROP POLICY IF EXISTS admin_users_migration_all ON admin_users;
DROP POLICY IF EXISTS admin_sessions_backend_all ON admin_sessions;
DROP POLICY IF EXISTS admin_sessions_migration_all ON admin_sessions;
DROP POLICY IF EXISTS admin_audit_logs_backend_all ON admin_audit_logs;
DROP POLICY IF EXISTS admin_audit_logs_migration_all ON admin_audit_logs;


CREATE POLICY admin_users_backend_all
ON admin_users
FOR ALL
TO app_backend_role
USING (true)
WITH CHECK (true);

CREATE POLICY admin_users_migration_all
ON admin_users
FOR ALL
TO migration_role
USING (true)
WITH CHECK (true);


CREATE POLICY admin_sessions_backend_all
ON admin_sessions
FOR ALL
TO app_backend_role
USING (true)
WITH CHECK (true);

CREATE POLICY admin_sessions_migration_all
ON admin_sessions
FOR ALL
TO migration_role
USING (true)
WITH CHECK (true);


CREATE POLICY admin_audit_logs_backend_all
ON admin_audit_logs
FOR ALL
TO app_backend_role
USING (true)
WITH CHECK (true);

CREATE POLICY admin_audit_logs_migration_all
ON admin_audit_logs
FOR ALL
TO migration_role
USING (true)
WITH CHECK (true);


COMMIT;
