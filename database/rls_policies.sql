-- ============================================================
-- ROW LEVEL SECURITY POLICIES
-- ============================================================
-- Roles: admin (full access), manager (read most, restricted from sensitive)
-- public.user_role() defined in schema.sql
-- Run AFTER all tables are created
-- ============================================================

-- ============================================================
-- HELPER: shorthand for role checks
-- ============================================================
-- admin  = public.user_role() = 'admin'
-- staff  = public.user_role() IN ('admin', 'manager')

-- ============================================================
-- AUTH: user_profiles
-- ============================================================
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Users can read their own row
CREATE POLICY user_profiles_select_own ON user_profiles
    FOR SELECT USING (id = auth.uid());

-- Admin can read all
CREATE POLICY user_profiles_select_admin ON user_profiles
    FOR SELECT USING (public.user_role() = 'admin');

-- Admin can insert/update/delete
CREATE POLICY user_profiles_insert_admin ON user_profiles
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY user_profiles_update_admin ON user_profiles
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY user_profiles_delete_admin ON user_profiles
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- CORE: members
-- ============================================================
ALTER TABLE members ENABLE ROW LEVEL SECURITY;

CREATE POLICY members_select ON members
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY members_insert ON members
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY members_update ON members
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY members_delete ON members
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 1: IDENTITY (5 tables)
-- manager+ SELECT, admin UPDATE
-- member_neuro_profile: admin only
-- ============================================================
ALTER TABLE member_identity ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_identity_languages ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_sensory_profile ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_physical_profile ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_neuro_profile ENABLE ROW LEVEL SECURITY;

-- Standard identity tables: manager+ SELECT, admin write
CREATE POLICY identity_select ON member_identity
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY identity_insert ON member_identity
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY identity_update ON member_identity
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY identity_delete ON member_identity
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY identity_languages_select ON member_identity_languages
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY identity_languages_insert ON member_identity_languages
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY identity_languages_update ON member_identity_languages
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY identity_languages_delete ON member_identity_languages
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY sensory_select ON member_sensory_profile
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY sensory_insert ON member_sensory_profile
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY sensory_update ON member_sensory_profile
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY sensory_delete ON member_sensory_profile
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY physical_select ON member_physical_profile
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY physical_insert ON member_physical_profile
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY physical_update ON member_physical_profile
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY physical_delete ON member_physical_profile
    FOR DELETE USING (public.user_role() = 'admin');

-- Neuro: ADMIN ONLY (compliance override)
CREATE POLICY neuro_select ON member_neuro_profile
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY neuro_insert ON member_neuro_profile
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY neuro_update ON member_neuro_profile
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY neuro_delete ON member_neuro_profile
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 2: HOUSEHOLD (3 tables)
-- manager+ SELECT, admin write
-- ============================================================
ALTER TABLE member_household ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_household_dependents ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_household_pets ENABLE ROW LEVEL SECURITY;

CREATE POLICY household_select ON member_household
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY household_insert ON member_household
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY household_update ON member_household
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY household_delete ON member_household
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY household_dependents_select ON member_household_dependents
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY household_dependents_insert ON member_household_dependents
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY household_dependents_update ON member_household_dependents
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY household_dependents_delete ON member_household_dependents
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY household_pets_select ON member_household_pets
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY household_pets_insert ON member_household_pets
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY household_pets_delete ON member_household_pets
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 3: HEALTH (6 tables) — ADMIN ONLY (all sensitive)
-- ============================================================
ALTER TABLE member_health ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_health_conditions ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_health_mental ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_health_addiction ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_health_medical_participation ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_health_allergies ENABLE ROW LEVEL SECURITY;

CREATE POLICY health_select ON member_health
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY health_insert ON member_health
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY health_update ON member_health
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY health_delete ON member_health
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY health_conditions_select ON member_health_conditions
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY health_conditions_insert ON member_health_conditions
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY health_conditions_update ON member_health_conditions
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY health_conditions_delete ON member_health_conditions
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY health_mental_select ON member_health_mental
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY health_mental_insert ON member_health_mental
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY health_mental_update ON member_health_mental
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY health_mental_delete ON member_health_mental
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY health_addiction_select ON member_health_addiction
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY health_addiction_insert ON member_health_addiction
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY health_addiction_update ON member_health_addiction
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY health_addiction_delete ON member_health_addiction
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY health_medical_select ON member_health_medical_participation
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY health_medical_insert ON member_health_medical_participation
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY health_medical_update ON member_health_medical_participation
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY health_medical_delete ON member_health_medical_participation
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY health_allergies_select ON member_health_allergies
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY health_allergies_insert ON member_health_allergies
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY health_allergies_update ON member_health_allergies
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY health_allergies_delete ON member_health_allergies
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 4: EMPLOYMENT & EDUCATION (5 tables)
-- manager+ SELECT, admin write
-- ============================================================
ALTER TABLE member_employment ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_education ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_employment_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_employment_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_employment_qualifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY employment_select ON member_employment
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY employment_insert ON member_employment
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY employment_update ON member_employment
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY employment_delete ON member_employment
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY education_select ON member_education
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY education_insert ON member_education
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY education_update ON member_education
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY education_delete ON member_education
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY employment_entries_select ON member_employment_entries
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY employment_entries_insert ON member_employment_entries
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY employment_entries_update ON member_employment_entries
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY employment_entries_delete ON member_employment_entries
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY employment_skills_select ON member_employment_skills
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY employment_skills_insert ON member_employment_skills
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY employment_skills_update ON member_employment_skills
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY employment_skills_delete ON member_employment_skills
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY employment_qualifications_select ON member_employment_qualifications
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY employment_qualifications_insert ON member_employment_qualifications
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY employment_qualifications_update ON member_employment_qualifications
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY employment_qualifications_delete ON member_employment_qualifications
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 5: FINANCIAL (4 tables) — ADMIN ONLY (sensitive)
-- ============================================================
ALTER TABLE member_financial ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_financial_institutions ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_financial_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_financial_investments ENABLE ROW LEVEL SECURITY;

CREATE POLICY financial_select ON member_financial
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY financial_insert ON member_financial
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY financial_update ON member_financial
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY financial_delete ON member_financial
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY financial_institutions_select ON member_financial_institutions
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY financial_institutions_insert ON member_financial_institutions
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY financial_institutions_update ON member_financial_institutions
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY financial_institutions_delete ON member_financial_institutions
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY financial_cards_select ON member_financial_cards
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY financial_cards_insert ON member_financial_cards
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY financial_cards_update ON member_financial_cards
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY financial_cards_delete ON member_financial_cards
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY financial_investments_select ON member_financial_investments
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY financial_investments_insert ON member_financial_investments
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY financial_investments_update ON member_financial_investments
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY financial_investments_delete ON member_financial_investments
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 6: PROPERTY (3 tables)
-- manager+ SELECT, admin write
-- ============================================================
ALTER TABLE member_property ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_property_vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_property_entries ENABLE ROW LEVEL SECURITY;

CREATE POLICY property_select ON member_property
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY property_insert ON member_property
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY property_update ON member_property
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY property_delete ON member_property
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY property_vehicles_select ON member_property_vehicles
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY property_vehicles_insert ON member_property_vehicles
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY property_vehicles_update ON member_property_vehicles
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY property_vehicles_delete ON member_property_vehicles
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY property_entries_select ON member_property_entries
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY property_entries_insert ON member_property_entries
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY property_entries_update ON member_property_entries
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY property_entries_delete ON member_property_entries
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 7: TECHNOLOGY (4 tables)
-- manager+ SELECT, admin write
-- ============================================================
ALTER TABLE member_technology_behaviour ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_technology_devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_technology_platforms ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_technology_non_use ENABLE ROW LEVEL SECURITY;

CREATE POLICY tech_behaviour_select ON member_technology_behaviour
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY tech_behaviour_insert ON member_technology_behaviour
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY tech_behaviour_update ON member_technology_behaviour
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY tech_behaviour_delete ON member_technology_behaviour
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY tech_devices_select ON member_technology_devices
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY tech_devices_insert ON member_technology_devices
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY tech_devices_update ON member_technology_devices
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY tech_devices_delete ON member_technology_devices
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY tech_platforms_select ON member_technology_platforms
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY tech_platforms_insert ON member_technology_platforms
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY tech_platforms_update ON member_technology_platforms
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY tech_platforms_delete ON member_technology_platforms
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY tech_non_use_select ON member_technology_non_use
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY tech_non_use_insert ON member_technology_non_use
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY tech_non_use_update ON member_technology_non_use
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY tech_non_use_delete ON member_technology_non_use
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 8: CONSUMPTION & SERVICES (2 tables)
-- manager+ SELECT, admin write
-- ============================================================
ALTER TABLE member_consumption ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_consumption_entries ENABLE ROW LEVEL SECURITY;

CREATE POLICY consumption_select ON member_consumption
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY consumption_insert ON member_consumption
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY consumption_update ON member_consumption
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY consumption_delete ON member_consumption
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY consumption_entries_select ON member_consumption_entries
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY consumption_entries_insert ON member_consumption_entries
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY consumption_entries_update ON member_consumption_entries
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY consumption_entries_delete ON member_consumption_entries
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 9: LIFESTYLE (3 tables)
-- manager+ SELECT, admin write
-- ============================================================
ALTER TABLE member_lifestyle ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_lifestyle_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_lifestyle_travel ENABLE ROW LEVEL SECURITY;

CREATE POLICY lifestyle_select ON member_lifestyle
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY lifestyle_insert ON member_lifestyle
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY lifestyle_update ON member_lifestyle
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY lifestyle_delete ON member_lifestyle
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY lifestyle_activities_select ON member_lifestyle_activities
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY lifestyle_activities_insert ON member_lifestyle_activities
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY lifestyle_activities_update ON member_lifestyle_activities
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY lifestyle_activities_delete ON member_lifestyle_activities
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY lifestyle_travel_select ON member_lifestyle_travel
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY lifestyle_travel_insert ON member_lifestyle_travel
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY lifestyle_travel_update ON member_lifestyle_travel
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY lifestyle_travel_delete ON member_lifestyle_travel
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 10: EXPERIENCES (3 tables)
-- manager+ SELECT, admin write
-- ============================================================
ALTER TABLE member_experiences_research_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_experiences_life_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_experiences_narratives ENABLE ROW LEVEL SECURITY;

CREATE POLICY experiences_research_select ON member_experiences_research_history
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY experiences_research_insert ON member_experiences_research_history
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY experiences_research_update ON member_experiences_research_history
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY experiences_research_delete ON member_experiences_research_history
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY experiences_life_events_select ON member_experiences_life_events
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY experiences_life_events_insert ON member_experiences_life_events
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY experiences_life_events_update ON member_experiences_life_events
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY experiences_life_events_delete ON member_experiences_life_events
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY experiences_narratives_select ON member_experiences_narratives
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY experiences_narratives_insert ON member_experiences_narratives
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY experiences_narratives_update ON member_experiences_narratives
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY experiences_narratives_delete ON member_experiences_narratives
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 11: BELIEFS (2 tables)
-- manager+ SELECT, admin write
-- (MV member_belief_summary inherits from source tables)
-- ============================================================
ALTER TABLE belief_expressions ENABLE ROW LEVEL SECURITY;
ALTER TABLE belief_emergent_themes ENABLE ROW LEVEL SECURITY;

CREATE POLICY belief_expressions_select ON belief_expressions
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY belief_expressions_insert ON belief_expressions
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY belief_expressions_update ON belief_expressions
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY belief_expressions_delete ON belief_expressions
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY belief_themes_select ON belief_emergent_themes
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY belief_themes_insert ON belief_emergent_themes
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY belief_themes_update ON belief_emergent_themes
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY belief_themes_delete ON belief_emergent_themes
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 12: INTENTIONS (3 tables)
-- manager+ SELECT, admin write
-- ============================================================
ALTER TABLE member_intentions ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_intentions_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_intentions_purchases ENABLE ROW LEVEL SECURITY;

CREATE POLICY intentions_select ON member_intentions
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY intentions_insert ON member_intentions
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY intentions_update ON member_intentions
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY intentions_delete ON member_intentions
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY intentions_goals_select ON member_intentions_goals
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY intentions_goals_insert ON member_intentions_goals
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY intentions_goals_update ON member_intentions_goals
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY intentions_goals_delete ON member_intentions_goals
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY intentions_purchases_select ON member_intentions_purchases
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY intentions_purchases_insert ON member_intentions_purchases
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY intentions_purchases_update ON member_intentions_purchases
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY intentions_purchases_delete ON member_intentions_purchases
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 13: MEDIA & ENTERTAINMENT (2 tables)
-- manager+ SELECT, admin write
-- ============================================================
ALTER TABLE member_media_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_media_habits ENABLE ROW LEVEL SECURITY;

CREATE POLICY media_subscriptions_select ON member_media_subscriptions
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY media_subscriptions_insert ON member_media_subscriptions
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY media_subscriptions_update ON member_media_subscriptions
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY media_subscriptions_delete ON member_media_subscriptions
    FOR DELETE USING (public.user_role() = 'admin');

CREATE POLICY media_habits_select ON member_media_habits
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY media_habits_insert ON member_media_habits
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY media_habits_update ON member_media_habits
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY media_habits_delete ON member_media_habits
    FOR DELETE USING (public.user_role() = 'admin');

-- ============================================================
-- BUCKET 14: CONSENT & DATA RIGHTS (6 tables)
-- member_consents: manager+ SELECT/INSERT, admin UPDATE, no DELETE
-- everything else: admin only
-- ============================================================
ALTER TABLE dpos ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_consents ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_data_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_data_retention ENABLE ROW LEVEL SECURITY;
ALTER TABLE data_access_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE data_transfers ENABLE ROW LEVEL SECURITY;

-- DPOs: admin only
CREATE POLICY dpos_select ON dpos
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY dpos_insert ON dpos
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY dpos_update ON dpos
    FOR UPDATE USING (public.user_role() = 'admin');

-- Consents: manager+ can read and create, admin can update, NO DELETE
CREATE POLICY consents_select ON member_consents
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY consents_insert ON member_consents
    FOR INSERT WITH CHECK (public.user_role() IN ('admin', 'manager'));
CREATE POLICY consents_update ON member_consents
    FOR UPDATE USING (public.user_role() = 'admin');
-- No DELETE policy — consent records are immutable

-- Data requests: admin only
CREATE POLICY data_requests_select ON member_data_requests
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY data_requests_insert ON member_data_requests
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY data_requests_update ON member_data_requests
    FOR UPDATE USING (public.user_role() = 'admin');

-- Data retention: admin only
CREATE POLICY data_retention_select ON member_data_retention
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY data_retention_insert ON member_data_retention
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY data_retention_update ON member_data_retention
    FOR UPDATE USING (public.user_role() = 'admin');

-- Access logs: admin only
CREATE POLICY access_logs_select ON data_access_logs
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY access_logs_insert ON data_access_logs
    FOR INSERT WITH CHECK (public.user_role() = 'admin');

-- Data transfers: admin only
CREATE POLICY transfers_select ON data_transfers
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY transfers_insert ON data_transfers
    FOR INSERT WITH CHECK (public.user_role() = 'admin');

-- ============================================================
-- OPERATIONS & PROJECTS
-- ============================================================
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_financials ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_cost_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_filters ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_communications ENABLE ROW LEVEL SECURITY;
ALTER TABLE global_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE interview_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_responses ENABLE ROW LEVEL SECURITY;

-- Clients: manager+ SELECT, admin write
CREATE POLICY clients_select ON clients
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY clients_insert ON clients
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY clients_update ON clients
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY clients_delete ON clients
    FOR DELETE USING (public.user_role() = 'admin');

-- Projects: manager+ SELECT, admin INSERT/UPDATE
CREATE POLICY projects_select ON projects
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY projects_insert ON projects
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY projects_update ON projects
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY projects_delete ON projects
    FOR DELETE USING (public.user_role() = 'admin');

-- Project financials: admin only
CREATE POLICY project_financials_select ON project_financials
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY project_financials_insert ON project_financials
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY project_financials_update ON project_financials
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY project_financials_delete ON project_financials
    FOR DELETE USING (public.user_role() = 'admin');

-- Project cost items: admin only
CREATE POLICY project_cost_items_select ON project_cost_items
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY project_cost_items_insert ON project_cost_items
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY project_cost_items_update ON project_cost_items
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY project_cost_items_delete ON project_cost_items
    FOR DELETE USING (public.user_role() = 'admin');

-- Project filters: manager+ SELECT, admin write
CREATE POLICY project_filters_select ON project_filters
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY project_filters_insert ON project_filters
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY project_filters_update ON project_filters
    FOR UPDATE USING (public.user_role() = 'admin');
CREATE POLICY project_filters_delete ON project_filters
    FOR DELETE USING (public.user_role() = 'admin');

-- Project members: manager+ SELECT/INSERT/UPDATE, admin DELETE
CREATE POLICY project_members_select ON project_members
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY project_members_insert ON project_members
    FOR INSERT WITH CHECK (public.user_role() IN ('admin', 'manager'));
CREATE POLICY project_members_update ON project_members
    FOR UPDATE USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY project_members_delete ON project_members
    FOR DELETE USING (public.user_role() = 'admin');

-- Project communications: manager+ SELECT/INSERT
CREATE POLICY project_comms_select ON project_communications
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY project_comms_insert ON project_communications
    FOR INSERT WITH CHECK (public.user_role() IN ('admin', 'manager'));

-- Global settings: admin only
CREATE POLICY global_settings_select ON global_settings
    FOR SELECT USING (public.user_role() = 'admin');
CREATE POLICY global_settings_insert ON global_settings
    FOR INSERT WITH CHECK (public.user_role() = 'admin');
CREATE POLICY global_settings_update ON global_settings
    FOR UPDATE USING (public.user_role() = 'admin');

-- Project questions: manager+ SELECT/INSERT/UPDATE, admin DELETE
CREATE POLICY project_questions_select ON project_questions
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY project_questions_insert ON project_questions
    FOR INSERT WITH CHECK (public.user_role() IN ('admin', 'manager'));
CREATE POLICY project_questions_update ON project_questions
    FOR UPDATE USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY project_questions_delete ON project_questions
    FOR DELETE USING (public.user_role() = 'admin');

-- Interview sessions: manager+ SELECT/INSERT/UPDATE
CREATE POLICY interview_sessions_select ON interview_sessions
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY interview_sessions_insert ON interview_sessions
    FOR INSERT WITH CHECK (public.user_role() IN ('admin', 'manager'));
CREATE POLICY interview_sessions_update ON interview_sessions
    FOR UPDATE USING (public.user_role() IN ('admin', 'manager'));

-- Session responses: manager+ SELECT/INSERT/UPDATE
CREATE POLICY session_responses_select ON session_responses
    FOR SELECT USING (public.user_role() IN ('admin', 'manager'));
CREATE POLICY session_responses_insert ON session_responses
    FOR INSERT WITH CHECK (public.user_role() IN ('admin', 'manager'));
CREATE POLICY session_responses_update ON session_responses
    FOR UPDATE USING (public.user_role() IN ('admin', 'manager'));
