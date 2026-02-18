-- ============================================================
-- Mirror v2 — Foundation Schema
-- Run this FIRST — everything else depends on it
-- ============================================================

-- EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";

-- ============================================================
-- UPDATED_AT TRIGGER FUNCTION
-- ============================================================

CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- USER PROFILES (every authenticated user — staff or client)
-- ============================================================
-- Linked to Supabase auth.users. Every login gets a row here.
-- Role determines what they can see/do via RLS.
--
-- Staff (admin/manager) are invited by an existing admin:
--   1. Admin invites via supabase.auth.admin.inviteUserByEmail()
--   2. Insert into user_profiles with role = 'admin' or 'manager'
--
-- Clients (future) get invited to view their projects:
--   1. Admin invites client contact via Supabase Auth
--   2. Insert into user_profiles with role = 'client'
--   3. Link to clients table via clients.user_id

CREATE TABLE user_profiles ( -- Research Network Managers
    id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name        TEXT NOT NULL,
    email       TEXT UNIQUE NOT NULL,
    role        TEXT NOT NULL DEFAULT 'manager',
    -- 'admin', 'manager', 'client', 'member'
    is_active   BOOLEAN NOT NULL DEFAULT true,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- AUTH HELPER: user_role() — used in all RLS policies
-- ============================================================

CREATE OR REPLACE FUNCTION public.user_role()
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT role FROM user_profiles
    WHERE id = auth.uid() AND is_active = true
$$;

-- ============================================================
-- CORE: MEMBERS
-- ============================================================

CREATE TABLE members ( -- Participants
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID UNIQUE REFERENCES user_profiles(id),  -- nullable until member gets portal access
    email       TEXT UNIQUE NOT NULL,
    phone       TEXT,
    full_name   TEXT NOT NULL,
    registration_country TEXT,
    status      TEXT NOT NULL DEFAULT 'active', -- active, innactive, blocked
    source      TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
