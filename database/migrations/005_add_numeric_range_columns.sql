-- Migration 005: Add numeric min/max columns for range-queryable bracket fields
-- Date: 2026-02-20
--
-- TEXT bracket columns (e.g. "9 - 49 employees", "Below 2500 SGD") are not
-- queryable with range operators. Adding INTEGER min/max pairs enables:
--   WHERE company_size_min >= 10
--   WHERE personal_income_max <= 5000
--
-- The original TEXT column stays as the display/canonical label.
-- The AI interview pipeline normalizes free-text → bracket + min/max at write time.
-- Original user answer preserved in raw_source JSONB.

-- ══════════════════════════════════════════════════
-- member_employment_entries: company_size
-- ══════════════════════════════════════════════════
ALTER TABLE member_employment_entries ADD COLUMN company_size_min INTEGER;
ALTER TABLE member_employment_entries ADD COLUMN company_size_max INTEGER;

COMMENT ON COLUMN member_employment_entries.company_size_min IS 'Lower bound of company_size bracket (e.g. 50 for "50-99 employees")';
COMMENT ON COLUMN member_employment_entries.company_size_max IS 'Upper bound of company_size bracket (NULL for open-ended e.g. "10000+")';

-- ══════════════════════════════════════════════════
-- member_employment_entries: company_annual_revenue
-- ══════════════════════════════════════════════════
ALTER TABLE member_employment_entries ADD COLUMN company_revenue_min BIGINT;
ALTER TABLE member_employment_entries ADD COLUMN company_revenue_max BIGINT;

COMMENT ON COLUMN member_employment_entries.company_revenue_min IS 'Lower bound of company_annual_revenue in base currency units';
COMMENT ON COLUMN member_employment_entries.company_revenue_max IS 'Upper bound of company_annual_revenue (NULL for open-ended)';

-- ══════════════════════════════════════════════════
-- member_financial: personal_income_bracket
-- ══════════════════════════════════════════════════
ALTER TABLE member_financial ADD COLUMN personal_income_min INTEGER;
ALTER TABLE member_financial ADD COLUMN personal_income_max INTEGER;

COMMENT ON COLUMN member_financial.personal_income_min IS 'Lower bound of personal_income_bracket in income_currency units';
COMMENT ON COLUMN member_financial.personal_income_max IS 'Upper bound of personal_income_bracket (NULL for open-ended)';

-- ══════════════════════════════════════════════════
-- member_financial: household_income_bracket
-- ══════════════════════════════════════════════════
ALTER TABLE member_financial ADD COLUMN household_income_min INTEGER;
ALTER TABLE member_financial ADD COLUMN household_income_max INTEGER;

COMMENT ON COLUMN member_financial.household_income_min IS 'Lower bound of household_income_bracket in income_currency units';
COMMENT ON COLUMN member_financial.household_income_max IS 'Upper bound of household_income_bracket (NULL for open-ended)';

-- ══════════════════════════════════════════════════
-- member_financial: total_net_worth
-- ══════════════════════════════════════════════════
ALTER TABLE member_financial ADD COLUMN net_worth_min BIGINT;
ALTER TABLE member_financial ADD COLUMN net_worth_max BIGINT;

COMMENT ON COLUMN member_financial.net_worth_min IS 'Lower bound of total_net_worth bracket';
COMMENT ON COLUMN member_financial.net_worth_max IS 'Upper bound of total_net_worth bracket (NULL for open-ended)';

-- ══════════════════════════════════════════════════
-- member_financial: assets_under_management
-- ══════════════════════════════════════════════════
ALTER TABLE member_financial ADD COLUMN aum_min BIGINT;
ALTER TABLE member_financial ADD COLUMN aum_max BIGINT;

COMMENT ON COLUMN member_financial.aum_min IS 'Lower bound of assets_under_management bracket';
COMMENT ON COLUMN member_financial.aum_max IS 'Upper bound of assets_under_management bracket (NULL for open-ended)';

-- ══════════════════════════════════════════════════
-- member_property: estimated_property_value
-- ══════════════════════════════════════════════════
ALTER TABLE member_property ADD COLUMN property_value_min BIGINT;
ALTER TABLE member_property ADD COLUMN property_value_max BIGINT;

COMMENT ON COLUMN member_property.property_value_min IS 'Lower bound of estimated_property_value bracket';
COMMENT ON COLUMN member_property.property_value_max IS 'Upper bound of estimated_property_value bracket (NULL for open-ended)';

-- ══════════════════════════════════════════════════
-- Indexes for common range queries
-- ══════════════════════════════════════════════════
CREATE INDEX idx_employment_company_size_range ON member_employment_entries (company_size_min, company_size_max);
CREATE INDEX idx_financial_income_range ON member_financial (personal_income_min, personal_income_max);
CREATE INDEX idx_financial_net_worth_range ON member_financial (net_worth_min, net_worth_max);
CREATE INDEX idx_financial_aum_range ON member_financial (aum_min, aum_max);
CREATE INDEX idx_property_value_range ON member_property (property_value_min, property_value_max);
