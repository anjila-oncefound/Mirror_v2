-- ============================================================
-- TRIGGERS: auto-set updated_at on every table that has it
-- ============================================================

DO $$
DECLARE
    t TEXT;
BEGIN
    FOREACH t IN ARRAY ARRAY[
        'user_profiles',
        'members',
        'member_identity',
        'member_sensory_profile',
        'member_physical_profile',
        'member_neuro_profile',
        'member_household',
        'member_household_dependents',
        'member_health',
        'member_health_conditions',
        'member_health_mental',
        'member_health_addiction',
        'member_health_medical_participation',
        'member_health_allergies',
        'member_employment',
        'member_education',
        'member_employment_entries',
        'member_employment_qualifications',
        'member_financial',
        'member_financial_institutions',
        'member_financial_cards',
        'member_financial_investments',
        'member_property',
        'member_property_vehicles',
        'member_technology_behaviour',
        'member_technology_devices',
        'member_technology_platforms',
        'member_consumption',
        'member_consumption_entries',
        'member_lifestyle',
        'member_lifestyle_activities',
        'member_experiences_research_history',
        'member_experiences_narratives',
        'member_intentions',
        'member_intentions_goals',
        'member_intentions_purchases',
        'member_media_subscriptions',
        'member_media_habits'
        -- NOTE: member_consents and member_data_requests are
        -- append-only (no updated_at) — triggers not needed
    ]
    LOOP
        EXECUTE format(
            'CREATE TRIGGER set_updated_at BEFORE UPDATE ON %I
             FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at()',
            t
        );
    END LOOP;
END;
$$;