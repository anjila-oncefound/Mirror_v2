-- ============================================================
-- FUNCTION: get_member_profile(UUID) → JSONB
-- ============================================================
-- One call, one round trip, all tables assembled into
-- clean nested JSON. Runs as SECURITY INVOKER so RLS applies
-- to every sub-query. Vector columns excluded from output
-- (6KB+ each, useless for display — use dedicated search
-- functions for similarity queries).
--
-- Split into 3 jsonb_build_object() calls merged with ||
-- because PostgreSQL limits functions to 100 arguments.
-- ============================================================

CREATE OR REPLACE FUNCTION get_member_profile(p_member_id UUID)
RETURNS JSONB
LANGUAGE sql
STABLE
SECURITY INVOKER
AS $fn$
SELECT
-- ============================================================
-- PART 1: Core + Buckets 1-6 (26 pairs = 52 args)
-- ============================================================
jsonb_build_object(
    -- Core
    'member', (
        SELECT row_to_json(t) FROM members t
        WHERE t.id = p_member_id
    ),

    -- Bucket 1: Identity
    'identity', (
        SELECT row_to_json(t) FROM member_identity t
        WHERE t.member_id = p_member_id
    ),
    'languages', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_identity_languages t
        WHERE t.member_id = p_member_id
    ),
    'sensory_profile', (
        SELECT row_to_json(t) FROM member_sensory_profile t
        WHERE t.member_id = p_member_id
    ),
    'physical_profile', (
        SELECT row_to_json(t) FROM member_physical_profile t
        WHERE t.member_id = p_member_id
    ),
    'neuro_profile', (
        SELECT row_to_json(t) FROM member_neuro_profile t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 2: Household
    'household', (
        SELECT row_to_json(t) FROM member_household t
        WHERE t.member_id = p_member_id
    ),
    'dependents', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_household_dependents t
        WHERE t.member_id = p_member_id
    ),
    'pets', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_household_pets t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 3: Health
    'health', (
        SELECT row_to_json(t) FROM member_health t
        WHERE t.member_id = p_member_id
    ),
    'health_conditions', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_health_conditions t
        WHERE t.member_id = p_member_id
    ),
    'health_mental', (
        SELECT row_to_json(t) FROM member_health_mental t
        WHERE t.member_id = p_member_id
    ),
    'health_addiction', (
        SELECT row_to_json(t) FROM member_health_addiction t
        WHERE t.member_id = p_member_id
    ),
    'health_medical_participation', (
        SELECT row_to_json(t) FROM member_health_medical_participation t
        WHERE t.member_id = p_member_id
    ),
    'health_allergies', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_health_allergies t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 4: Employment & Education
    'employment', (
        SELECT row_to_json(t) FROM member_employment t
        WHERE t.member_id = p_member_id
    ),
    'education', (
        SELECT row_to_json(t) FROM member_education t
        WHERE t.member_id = p_member_id
    ),
    'employment_entries', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_employment_entries t
        WHERE t.member_id = p_member_id
    ),
    'employment_skills', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_employment_skills t
        WHERE t.member_id = p_member_id
    ),
    'employment_qualifications', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_employment_qualifications t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 5: Financial
    'financial', (
        SELECT row_to_json(t) FROM member_financial t
        WHERE t.member_id = p_member_id
    ),
    'financial_institutions', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_financial_institutions t
        WHERE t.member_id = p_member_id
    ),
    'financial_cards', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_financial_cards t
        WHERE t.member_id = p_member_id
    ),
    'financial_investments', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_financial_investments t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 6: Property
    'property', (
        SELECT row_to_json(t) FROM member_property t
        WHERE t.member_id = p_member_id
    ),
    'property_vehicles', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_property_vehicles t
        WHERE t.member_id = p_member_id
    )
)

||

-- ============================================================
-- PART 2: Buckets 7-12 (21 pairs = 42 args)
-- ============================================================
jsonb_build_object(
    -- Bucket 7: Technology
    'technology_behaviour', (
        SELECT row_to_json(t) FROM member_technology_behaviour t
        WHERE t.member_id = p_member_id
    ),
    'technology_devices', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_technology_devices t
        WHERE t.member_id = p_member_id
    ),
    'technology_platforms', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_technology_platforms t
        WHERE t.member_id = p_member_id
    ),
    'technology_non_use', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_technology_non_use t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 8: Consumption & Services
    'consumption', (
        SELECT row_to_json(t) FROM member_consumption t
        WHERE t.member_id = p_member_id
    ),
    'consumption_entries', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_consumption_entries t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 9: Lifestyle
    'lifestyle', (
        SELECT row_to_json(t) FROM member_lifestyle t
        WHERE t.member_id = p_member_id
    ),
    'lifestyle_activities', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_lifestyle_activities t
        WHERE t.member_id = p_member_id
    ),
    'lifestyle_travel', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_lifestyle_travel t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 10: Experiences (vectors excluded)
    'research_history', (
        SELECT row_to_json(t) FROM member_experiences_research_history t
        WHERE t.member_id = p_member_id
    ),
    'experiences_life_events', (
        SELECT COALESCE(json_agg(json_build_object(
            'id', t.id,
            'event_type', t.event_type,
            'year', t.year,
            'brief_description', t.brief_description,
            'impact_level', t.impact_level,
            'created_at', t.created_at
        )), '[]'::json)
        FROM member_experiences_life_events t
        WHERE t.member_id = p_member_id
    ),
    'experiences_narratives', (
        SELECT COALESCE(json_agg(json_build_object(
            'id', t.id,
            'experience_category', t.experience_category,
            'narrative', t.narrative,
            'themes', t.themes,
            'created_at', t.created_at,
            'updated_at', t.updated_at
        )), '[]'::json)
        FROM member_experiences_narratives t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 11: Beliefs (vectors excluded, active only)
    'belief_expressions', (
        SELECT COALESCE(json_agg(json_build_object(
            'id', t.id,
            'domain', t.domain,
            'prompt_used', t.prompt_used,
            'raw_text', t.raw_text,
            'captured_at', t.captured_at,
            'source_type', t.source_type,
            'language', t.language,
            'word_count', t.word_count,
            'is_sensitive', t.is_sensitive,
            'reviewed', t.reviewed,
            'status', t.status
        )), '[]'::json)
        FROM belief_expressions t
        WHERE t.member_id = p_member_id AND t.status = 'active'
    ),
    'belief_themes', (
        SELECT COALESCE(json_agg(json_build_object(
            'id', t.id,
            'expression_id', t.expression_id,
            'theme', t.theme,
            'confidence', t.confidence,
            'theme_category', t.theme_category,
            'discovered_at', t.discovered_at,
            'model_version', t.model_version
        )), '[]'::json)
        FROM belief_emergent_themes t
        WHERE t.member_id = p_member_id
    ),
    'belief_summary', (
        SELECT COALESCE(json_agg(json_build_object(
            'domain', t.domain,
            'expression_count', t.expression_count,
            'last_captured', t.last_captured,
            'top_themes', t.top_themes
        )), '[]'::json)
        FROM member_belief_summary t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 12: Intentions (vectors excluded)
    'intentions', (
        SELECT json_build_object(
            'id', t.id,
            'frustrations', t.frustrations,
            'unmet_needs', t.unmet_needs,
            'switching_considerations', t.switching_considerations,
            'career_intentions', t.career_intentions,
            'life_changes_considered', t.life_changes_considered,
            'concerns_worries', t.concerns_worries,
            'created_at', t.created_at,
            'updated_at', t.updated_at
        )
        FROM member_intentions t
        WHERE t.member_id = p_member_id
    ),
    'intentions_goals', (
        SELECT COALESCE(json_agg(json_build_object(
            'id', t.id,
            'goal_category', t.goal_category,
            'goal_description', t.goal_description,
            'timeframe', t.timeframe,
            'priority', t.priority,
            'created_at', t.created_at
        )), '[]'::json)
        FROM member_intentions_goals t
        WHERE t.member_id = p_member_id
    ),
    'intentions_purchases', (
        SELECT COALESCE(json_agg(json_build_object(
            'id', t.id,
            'intended_purchase', t.intended_purchase,
            'category', t.category,
            'timeframe', t.timeframe,
            'stage', t.stage,
            'created_at', t.created_at
        )), '[]'::json)
        FROM member_intentions_purchases t
        WHERE t.member_id = p_member_id
    )
)

||

-- ============================================================
-- PART 3: Buckets 13-14 + Interview Sessions (7 pairs = 14 args)
-- ============================================================
jsonb_build_object(
    -- Bucket 13: Media & Entertainment
    'media_subscriptions', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_media_subscriptions t
        WHERE t.member_id = p_member_id
    ),
    'media_habits', (
        SELECT COALESCE(json_agg(t), '[]'::json)
        FROM member_media_habits t
        WHERE t.member_id = p_member_id
    ),

    -- Bucket 14: Consent & Data Rights (all append-only)
    'consents', (
        SELECT COALESCE(json_agg(t ORDER BY t.granted_at DESC), '[]'::json)
        FROM member_consents t
        WHERE t.member_id = p_member_id
    ),
    'data_requests', (
        SELECT COALESCE(json_agg(t ORDER BY t.requested_at DESC), '[]'::json)
        FROM member_data_requests t
        WHERE t.member_id = p_member_id
    ),
    'data_retention', (
        SELECT COALESCE(json_agg(t ORDER BY t.retain_until), '[]'::json)
        FROM member_data_retention t
        WHERE t.member_id = p_member_id
    ),
    'data_transfers', (
        SELECT COALESCE(json_agg(t ORDER BY t.transferred_at DESC), '[]'::json)
        FROM data_transfers t
        WHERE t.member_id = p_member_id
    ),

    -- Interview Sessions
    'interview_sessions', (
        SELECT COALESCE(json_agg(t ORDER BY t.scheduled_at DESC), '[]'::json)
        FROM interview_sessions t
        WHERE t.member_id = p_member_id
    )
);
$fn$;
