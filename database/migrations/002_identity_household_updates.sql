-- Migration 002: Identity & Household updates
-- Date: 2026-02-18
-- Changes:
--   Identity: remove country_of_residence, city (moved to household)
--   Household: add residency_status, country_of_residence, state_region, city, postal_code; remove household_income
--   Dependents: special_needs BOOLEAN → dependency TEXT, birth_year INTEGER → DATE
--   Pets: age_years INTEGER → birth_year DATE

-- ============================================================
-- 1. MEMBER_HOUSEHOLD — add new address/residency columns FIRST
-- ============================================================

ALTER TABLE member_household ADD COLUMN IF NOT EXISTS residency_status TEXT;
ALTER TABLE member_household ADD COLUMN IF NOT EXISTS country_of_residence TEXT;
ALTER TABLE member_household ADD COLUMN IF NOT EXISTS state_region TEXT;
ALTER TABLE member_household ADD COLUMN IF NOT EXISTS city TEXT;
ALTER TABLE member_household ADD COLUMN IF NOT EXISTS postal_code TEXT;

-- ============================================================
-- 2. MEMBER_IDENTITY — migrate data to household, then drop
-- ============================================================

-- Migrate existing data to household (columns exist now)
UPDATE member_household h
SET country_of_residence = i.country_of_residence,
    city = i.city
FROM member_identity i
WHERE h.member_id = i.member_id
  AND i.country_of_residence IS NOT NULL;

-- Now safe to drop
ALTER TABLE member_identity DROP COLUMN IF EXISTS country_of_residence;
ALTER TABLE member_identity DROP COLUMN IF EXISTS city;

-- Remove household_income (moved to member_financial)
ALTER TABLE member_household DROP COLUMN IF EXISTS household_income;

-- ============================================================
-- 3. MEMBER_HOUSEHOLD_DEPENDENTS — update columns
-- ============================================================

-- special_needs BOOLEAN → dependency TEXT (broader: 'handicapped', 'child', 'special_needs', 'financial_dependent')
ALTER TABLE member_household_dependents ADD COLUMN IF NOT EXISTS dependency TEXT;
UPDATE member_household_dependents SET dependency = 'special_needs' WHERE special_needs = true;
ALTER TABLE member_household_dependents DROP COLUMN IF EXISTS special_needs;

-- birth_year INTEGER → birth_year DATE
ALTER TABLE member_household_dependents ALTER COLUMN birth_year TYPE DATE USING make_date(birth_year, 1, 1);

-- ============================================================
-- 4. MEMBER_HOUSEHOLD_PETS — age_years → birth_year
-- ============================================================

-- Add birth_year, migrate from age_years, drop age_years
ALTER TABLE member_household_pets ADD COLUMN IF NOT EXISTS birth_year DATE;
UPDATE member_household_pets SET birth_year = make_date(EXTRACT(YEAR FROM now())::INTEGER - age_years, 1, 1) WHERE age_years IS NOT NULL;
ALTER TABLE member_household_pets DROP COLUMN IF EXISTS age_years;
