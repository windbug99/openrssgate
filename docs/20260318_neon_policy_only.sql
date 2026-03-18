-- Policy-only SQL for Neon/Postgres after RLS has already been enabled
-- in the Neon console.
--
-- Step 1. Run this to see the current DB role used by your session:
--   SELECT current_user, session_user;
--
-- Step 2. Replace `YOUR_APP_ROLE` below with that role name.
--
-- Example:
--   TO openrssgate_owner

BEGIN;

DROP POLICY IF EXISTS admin_users_allow_app ON admin_users;
DROP POLICY IF EXISTS admin_sessions_allow_app ON admin_sessions;
DROP POLICY IF EXISTS admin_audit_logs_allow_app ON admin_audit_logs;

CREATE POLICY admin_users_allow_app
ON admin_users
FOR ALL
TO neondb_owner
USING (true)
WITH CHECK (true);

CREATE POLICY admin_sessions_allow_app
ON admin_sessions
FOR ALL
TO neondb_owner
USING (true)
WITH CHECK (true);

CREATE POLICY admin_audit_logs_allow_app
ON admin_audit_logs
FOR ALL
TO neondb_owner
USING (true)
WITH CHECK (true);

COMMIT;
