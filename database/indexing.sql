-- ============================================================
-- ALL INDEXES — single source of truth
-- Run LAST after all tables are created
-- ============================================================

-- ============================================================
-- MEMBER_ID indexes on every 1:N table
-- ============================================================

-- Bucket 1: Identity
CREATE INDEX idx_identity_languages_member           ON member_identity_languages(member_id);
-- Bucket 2: Household
CREATE INDEX idx_household_dependents_member          ON member_household_dependents(member_id);
CREATE INDEX idx_household_pets_member                ON member_household_pets(member_id);
-- Bucket 3: Health
CREATE INDEX idx_health_conditions_member             ON member_health_conditions(member_id);
CREATE INDEX idx_health_allergies_member              ON member_health_allergies(member_id);
-- Bucket 4: Employment & Education
CREATE INDEX idx_employment_entries_member            ON member_employment_entries(member_id);
CREATE INDEX idx_employment_skills_member             ON member_employment_skills(member_id);
CREATE INDEX idx_employment_qualifications_member     ON member_employment_qualifications(member_id);
-- Bucket 5: Financial
CREATE INDEX idx_financial_institutions_member        ON member_financial_institutions(member_id);
CREATE INDEX idx_financial_cards_member               ON member_financial_cards(member_id);
CREATE INDEX idx_financial_cards_banking              ON member_financial_cards(banking_id);
CREATE INDEX idx_financial_investments_member         ON member_financial_investments(member_id);
-- Bucket 6: Property
CREATE INDEX idx_property_vehicles_member             ON member_property_vehicles(member_id);
CREATE INDEX idx_property_entries_member              ON member_property_entries(member_id);
-- Bucket 7: Technology
CREATE INDEX idx_technology_devices_member            ON member_technology_devices(member_id);
CREATE INDEX idx_technology_platforms_member           ON member_technology_platforms(member_id);
CREATE INDEX idx_technology_non_use_member             ON member_technology_non_use(member_id);
-- Bucket 8: Consumption & Services
CREATE INDEX idx_consumption_entries_member            ON member_consumption_entries(member_id);
-- Bucket 9: Lifestyle
CREATE INDEX idx_lifestyle_activities_member           ON member_lifestyle_activities(member_id);
CREATE INDEX idx_lifestyle_travel_member               ON member_lifestyle_travel(member_id);
-- Bucket 10: Experiences
CREATE INDEX idx_experiences_life_events_member        ON member_experiences_life_events(member_id);
CREATE INDEX idx_experiences_narratives_member         ON member_experiences_narratives(member_id);
-- Bucket 11: Beliefs
CREATE INDEX idx_belief_expressions_member             ON belief_expressions(member_id);
CREATE INDEX idx_belief_themes_member                  ON belief_emergent_themes(member_id);
CREATE INDEX idx_belief_themes_expression              ON belief_emergent_themes(expression_id);
-- Bucket 12: Intentions
CREATE INDEX idx_intentions_goals_member               ON member_intentions_goals(member_id);
CREATE INDEX idx_intentions_purchases_member            ON member_intentions_purchases(member_id);
-- Bucket 13: Media & Entertainment
CREATE INDEX idx_media_subscriptions_member            ON member_media_subscriptions(member_id);
CREATE INDEX idx_media_habits_member                   ON member_media_habits(member_id);
-- Bucket 14: Consent & Data Rights
CREATE INDEX idx_consents_member                       ON member_consents(member_id);
CREATE INDEX idx_consents_member_status                ON member_consents(member_id, consent_status);
CREATE INDEX idx_consents_project                      ON member_consents(project_id) WHERE project_id IS NOT NULL;

-- ============================================================
-- PROJECT / INTERVIEW indexes
-- ============================================================

CREATE INDEX idx_pq_project              ON project_questions(project_id);
CREATE INDEX idx_is_project              ON interview_sessions(project_id);
CREATE INDEX idx_is_member               ON interview_sessions(member_id);
CREATE INDEX idx_is_project_member       ON interview_sessions(project_member_id);
CREATE INDEX idx_sr_session              ON session_responses(session_id);
CREATE INDEX idx_sr_question             ON session_responses(question_id);

-- ============================================================
-- SEARCHABLE TEXT fields (normalized with LOWER(TRIM()))
-- ============================================================

-- Bucket 1: Identity
CREATE INDEX idx_identity_languages_language           ON member_identity_languages(LOWER(TRIM(language)));
-- Bucket 3: Health
CREATE INDEX idx_health_conditions_name                ON member_health_conditions(LOWER(TRIM(condition_name)));
CREATE INDEX idx_health_allergies_allergen             ON member_health_allergies(LOWER(TRIM(allergen)));
-- Bucket 4: Employment
CREATE INDEX idx_employment_skills_skill               ON member_employment_skills(LOWER(TRIM(skill)));
CREATE INDEX idx_employment_entries_job_title           ON member_employment_entries(LOWER(TRIM(job_title)));
CREATE INDEX idx_employment_entries_company             ON member_employment_entries(LOWER(TRIM(company_name)));
CREATE INDEX idx_employment_entries_industry            ON member_employment_entries(LOWER(TRIM(industry)));
CREATE INDEX idx_employment_qualifications_name         ON member_employment_qualifications(LOWER(TRIM(qualification_name)));
-- Bucket 5: Financial
CREATE INDEX idx_financial_institutions_name            ON member_financial_institutions(LOWER(TRIM(institution_name)));
-- Bucket 6: Property
CREATE INDEX idx_property_vehicles_make                ON member_property_vehicles(LOWER(TRIM(make)));
-- Bucket 7: Technology
CREATE INDEX idx_technology_platforms_name              ON member_technology_platforms(LOWER(TRIM(platform_name)));
CREATE INDEX idx_technology_devices_brand               ON member_technology_devices(LOWER(TRIM(brand)));
-- Bucket 8: Consumption & Services
CREATE INDEX idx_consumption_entries_brand              ON member_consumption_entries(LOWER(TRIM(brand)));
-- Bucket 9: Lifestyle
CREATE INDEX idx_lifestyle_activities_activity          ON member_lifestyle_activities(LOWER(TRIM(activity)));
CREATE INDEX idx_lifestyle_travel_country               ON member_lifestyle_travel(LOWER(TRIM(country)));
-- Bucket 11: Beliefs
CREATE INDEX idx_belief_themes_theme                    ON belief_emergent_themes(LOWER(TRIM(theme)));
-- Bucket 13: Media & Entertainment
CREATE INDEX idx_media_subscriptions_service            ON member_media_subscriptions(LOWER(TRIM(service_name)));
CREATE INDEX idx_media_habits_title                     ON member_media_habits(LOWER(TRIM(title)));
CREATE INDEX idx_media_habits_genre                     ON member_media_habits(LOWER(TRIM(genre)));
CREATE INDEX idx_media_habits_media_type                ON member_media_habits(LOWER(TRIM(media_type)));

-- ============================================================
-- BELIEF filtering
-- ============================================================

CREATE INDEX idx_belief_expressions_domain ON belief_expressions(member_id, domain);
CREATE INDEX idx_belief_expressions_active ON belief_expressions(status) WHERE status = 'active';

-- ============================================================
-- VECTOR (HNSW for approximate nearest neighbor)
-- ============================================================

CREATE INDEX idx_experiences_life_events_vec ON member_experiences_life_events
    USING hnsw (description_embedding vector_cosine_ops);
CREATE INDEX idx_experiences_narratives_vec ON member_experiences_narratives
    USING hnsw (embedding vector_cosine_ops);
CREATE INDEX idx_belief_expressions_vec ON belief_expressions
    USING hnsw (embedding vector_cosine_ops);
-- Note: member_intentions has 6 vector columns.
-- Index only when search patterns emerge. Premature HNSW indexes waste memory.
