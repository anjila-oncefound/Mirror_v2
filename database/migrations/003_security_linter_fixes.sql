-- Migration 003: Fix Supabase security linter warnings
-- Date: 2026-02-18

-- ============================================================
-- 1. Fix mutable search_path on all functions
-- ============================================================

-- get_member_profile: set search_path
ALTER FUNCTION public.get_member_profile(UUID) SET search_path = public;

-- trigger_set_updated_at: set search_path
ALTER FUNCTION public.trigger_set_updated_at() SET search_path = public;

-- user_role: set search_path
ALTER FUNCTION public.user_role() SET search_path = public;

-- ============================================================
-- 2. Move vector extension out of public schema
-- ============================================================

CREATE SCHEMA IF NOT EXISTS extensions;
ALTER EXTENSION vector SET SCHEMA extensions;

-- ============================================================
-- 3. Revoke public access on materialized view
-- ============================================================

REVOKE SELECT ON public.member_belief_summary FROM anon;
REVOKE SELECT ON public.member_belief_summary FROM authenticated;

-- Grant back only to authenticated users who pass RLS
-- (MV doesn't support RLS directly, so restrict at role level)
GRANT SELECT ON public.member_belief_summary TO authenticated;
