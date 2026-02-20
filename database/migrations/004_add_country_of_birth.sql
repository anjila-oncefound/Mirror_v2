-- Migration 004: Add country_of_birth to member_identity
-- Date: 2026-02-19

-- Add country_of_birth — permanent identity fact (like date_of_birth)
ALTER TABLE member_identity ADD COLUMN country_of_birth TEXT;
