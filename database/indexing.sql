-- ============================================================
-- INDEXES: member_id on every 1:N table
-- ============================================================

CREATE INDEX idx_identity_languages_member      ON member_identity_languages(member_id);
CREATE INDEX idx_household_dependents_member     ON member_household_dependents(member_id);
CREATE INDEX idx_household_pets_member           ON member_household_pets(member_id);
CREATE INDEX idx_health_conditions_member        ON member_health_conditions(member_id);
CREATE INDEX idx_health_allergies_member          ON member_health_allergies(member_id);
CREATE INDEX idx_employment_entries_member        ON member_employment_entries(member_id);
CREATE INDEX idx_employment_skills_member         ON member_employment_skills(member_id);
CREATE INDEX idx_employment_qualifications_member ON member_employment_qualifications(member_id);
CREATE INDEX idx_financial_banking_member         ON member_financial_banking(member_id);
CREATE INDEX idx_financial_cards_member           ON member_financial_cards(member_id);
CREATE INDEX idx_financial_cards_banking          ON member_financial_cards(banking_id);
CREATE INDEX idx_financial_investments_member     ON member_financial_investments(member_id);
CREATE INDEX idx_property_vehicles_member         ON member_property_vehicles(member_id);
CREATE INDEX idx_technology_devices_member        ON member_technology_devices(member_id);
CREATE INDEX idx_technology_platforms_member       ON member_technology_platforms(member_id);
CREATE INDEX idx_technology_non_use_member         ON member_technology_non_use(member_id);
CREATE INDEX idx_consumption_entries_member         ON member_consumption_entries(member_id);
CREATE INDEX idx_lifestyle_activities_member       ON member_lifestyle_activities(member_id);
CREATE INDEX idx_lifestyle_travel_member           ON member_lifestyle_travel(member_id);
CREATE INDEX idx_experiences_life_events_member     ON member_experiences_life_events(member_id);
CREATE INDEX idx_experiences_narratives_member      ON member_experiences_narratives(member_id);
CREATE INDEX idx_belief_expressions_member          ON belief_expressions(member_id);
CREATE INDEX idx_belief_themes_member               ON belief_emergent_themes(member_id);
CREATE INDEX idx_belief_themes_expression           ON belief_emergent_themes(expression_id);
CREATE INDEX idx_intentions_goals_member            ON member_intentions_goals(member_id);
CREATE INDEX idx_intentions_purchases_member        ON member_intentions_purchases(member_id);
CREATE INDEX idx_interview_responses_member         ON member_interview_responses(member_id);
CREATE INDEX idx_interview_responses_session        ON member_interview_responses(session_id);

-- INDEXES: searchable text fields (all normalized with LOWER(TRIM()))
-- Bucket 1: Identity
CREATE INDEX idx_identity_languages_language        ON member_identity_languages(LOWER(TRIM(language)));
-- Bucket 3: Health
CREATE INDEX idx_health_conditions_name             ON member_health_conditions(LOWER(TRIM(condition_name)));
CREATE INDEX idx_health_allergies_allergen           ON member_health_allergies(LOWER(TRIM(allergen)));
-- Bucket 4: Employment
CREATE INDEX idx_employment_skills_skill            ON member_employment_skills(LOWER(TRIM(skill)));
CREATE INDEX idx_employment_entries_job_title        ON member_employment_entries(LOWER(TRIM(job_title)));
CREATE INDEX idx_employment_entries_company          ON member_employment_entries(LOWER(TRIM(company_name)));
CREATE INDEX idx_employment_entries_industry         ON member_employment_entries(LOWER(TRIM(industry)));
CREATE INDEX idx_employment_qualifications_name      ON member_employment_qualifications(LOWER(TRIM(qualification_name)));
-- Bucket 5: Financial
CREATE INDEX idx_financial_banking_institution       ON member_financial_banking(LOWER(TRIM(institution_name)));
-- Bucket 6: Property
CREATE INDEX idx_property_vehicles_make              ON member_property_vehicles(LOWER(TRIM(make)));
-- Bucket 7: Technology
CREATE INDEX idx_technology_platforms_name           ON member_technology_platforms(LOWER(TRIM(platform_name)));
CREATE INDEX idx_technology_devices_brand            ON member_technology_devices(LOWER(TRIM(brand)));
-- Bucket 8: Consumption & Services
CREATE INDEX idx_consumption_entries_brand            ON member_consumption_entries(LOWER(TRIM(brand)));
-- Bucket 9: Lifestyle
CREATE INDEX idx_lifestyle_activities_activity       ON member_lifestyle_activities(LOWER(TRIM(activity)));
CREATE INDEX idx_lifestyle_travel_country            ON member_lifestyle_travel(LOWER(TRIM(country)));
-- Bucket 11: Beliefs
CREATE INDEX idx_belief_themes_theme                 ON belief_emergent_themes(LOWER(TRIM(theme)));

-- INDEXES: belief filtering
CREATE INDEX idx_belief_expressions_domain ON belief_expressions(member_id, domain);
CREATE INDEX idx_belief_expressions_active ON belief_expressions(status) WHERE status = 'active';

-- INDEXES: vector (HNSW for approximate nearest neighbor)
CREATE INDEX idx_experiences_life_events_vec ON member_experiences_life_events
    USING hnsw (description_embedding vector_cosine_ops);
CREATE INDEX idx_experiences_narratives_vec ON member_experiences_narratives
    USING hnsw (embedding vector_cosine_ops);
CREATE INDEX idx_belief_expressions_vec ON belief_expressions
    USING hnsw (embedding vector_cosine_ops);
-- Note: member_intentions has 6 vector columns.
-- Index only when search patterns emerge. Premature HNSW indexes waste memory.