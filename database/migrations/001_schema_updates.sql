-- Migration 001: schema.sql updates
-- Date: 2026-02-18
-- Changes: Add registration_country to members, fix is_active NOT NULL on user_profiles

-- 1. Add registration_country to members
ALTER TABLE members ADD COLUMN IF NOT EXISTS registration_country TEXT;

-- 2. Fix is_active constraint (original had typo 'NONULL' — column is likely nullable)
ALTER TABLE user_profiles ALTER COLUMN is_active SET NOT NULL;
ALTER TABLE user_profiles ALTER COLUMN is_active SET DEFAULT true;

-- 3. Update members status constraint: 'blacklisted' → 'blocked'
UPDATE members SET status = 'blocked' WHERE status = 'blacklisted';
ALTER TABLE members DROP CONSTRAINT IF EXISTS chk_members_status;
ALTER TABLE members ADD CONSTRAINT chk_members_status
  CHECK (status IN ('active', 'inactive', 'blocked'));
