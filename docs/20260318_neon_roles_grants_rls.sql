-- Neon/Postgres bootstrap SQL for OpenRSSGate.
--
-- What this does:
-- 1. Creates a runtime role for the FastAPI app.
-- 2. Creates a migration role for Alembic.
-- 3. Grants least-privilege table/sequence/schema access.
-- 4. Enables RLS on sensitive admin tables and allows only these roles.
--
-- Replace these placeholders before executing:
--   CHANGE_ME_APP_PASSWORD
--   CHANGE_ME_MIGRATION_PASSWORD
--
-- Optional adjustments:
-- - Change role names if needed.
-- - Change schema name if you do not use `public`.
--
-- Run this as a sufficiently privileged Postgres role.

BEGIN;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'openrssgate_app') THEN
        CREATE ROLE openrssgate_app
            LOGIN
            PASSWORD 'CHANGE_ME_APP_PASSWORD'
            NOSUPERUSER
            NOCREATEDB
            NOCREATEROLE
            NOINHERIT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'openrssgate_migrator') THEN
        CREATE ROLE openrssgate_migrator
            LOGIN
            PASSWORD 'CHANGE_ME_MIGRATION_PASSWORD'
            NOSUPERUSER
            NOCREATEDB
            NOCREATEROLE
            NOINHERIT;
    END IF;
END $$;


GRANT CONNECT ON DATABASE postgres TO openrssgate_app;
GRANT CONNECT ON DATABASE postgres TO openrssgate_migrator;

GRANT USAGE ON SCHEMA public TO openrssgate_app;
GRANT USAGE, CREATE ON SCHEMA public TO openrssgate_migrator;


REVOKE ALL ON TABLE admin_users FROM PUBLIC;
REVOKE ALL ON TABLE admin_sessions FROM PUBLIC;
REVOKE ALL ON TABLE admin_audit_logs FROM PUBLIC;
REVOKE ALL ON TABLE feeds FROM PUBLIC;
REVOKE ALL ON TABLE sources FROM PUBLIC;
REVOKE ALL ON TABLE alembic_version FROM PUBLIC;


GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE sources TO openrssgate_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE feeds TO openrssgate_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE admin_users TO openrssgate_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE admin_sessions TO openrssgate_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE admin_audit_logs TO openrssgate_app;
GRANT SELECT, UPDATE ON TABLE alembic_version TO openrssgate_app;


GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO openrssgate_migrator;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO openrssgate_migrator;
GRANT ALL PRIVILEGES ON ALL ROUTINES IN SCHEMA public TO openrssgate_migrator;


ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO openrssgate_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO openrssgate_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO openrssgate_migrator;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON SEQUENCES TO openrssgate_migrator;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON ROUTINES TO openrssgate_migrator;


ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_audit_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS admin_users_app_all ON admin_users;
DROP POLICY IF EXISTS admin_users_migrator_all ON admin_users;
DROP POLICY IF EXISTS admin_sessions_app_all ON admin_sessions;
DROP POLICY IF EXISTS admin_sessions_migrator_all ON admin_sessions;
DROP POLICY IF EXISTS admin_audit_logs_app_all ON admin_audit_logs;
DROP POLICY IF EXISTS admin_audit_logs_migrator_all ON admin_audit_logs;

CREATE POLICY admin_users_app_all
ON admin_users
FOR ALL
TO openrssgate_app
USING (true)
WITH CHECK (true);

CREATE POLICY admin_users_migrator_all
ON admin_users
FOR ALL
TO openrssgate_migrator
USING (true)
WITH CHECK (true);

CREATE POLICY admin_sessions_app_all
ON admin_sessions
FOR ALL
TO openrssgate_app
USING (true)
WITH CHECK (true);

CREATE POLICY admin_sessions_migrator_all
ON admin_sessions
FOR ALL
TO openrssgate_migrator
USING (true)
WITH CHECK (true);

CREATE POLICY admin_audit_logs_app_all
ON admin_audit_logs
FOR ALL
TO openrssgate_app
USING (true)
WITH CHECK (true);

CREATE POLICY admin_audit_logs_migrator_all
ON admin_audit_logs
FOR ALL
TO openrssgate_migrator
USING (true)
WITH CHECK (true);

COMMIT;
