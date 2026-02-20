-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.belief_emergent_themes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  expression_id uuid NOT NULL,
  member_id uuid NOT NULL,
  theme text NOT NULL,
  confidence double precision NOT NULL,
  theme_category text,
  discovered_at timestamp with time zone NOT NULL DEFAULT now(),
  model_version text NOT NULL,
  CONSTRAINT belief_emergent_themes_pkey PRIMARY KEY (id),
  CONSTRAINT belief_emergent_themes_expression_id_fkey FOREIGN KEY (expression_id) REFERENCES public.belief_expressions(id),
  CONSTRAINT belief_emergent_themes_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.belief_expressions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  domain text NOT NULL,
  prompt_used text,
  raw_text text NOT NULL,
  embedding USER-DEFINED NOT NULL,
  captured_at timestamp with time zone NOT NULL DEFAULT now(),
  source_type text NOT NULL,
  project_id uuid,
  session_id uuid,
  language text NOT NULL DEFAULT 'en'::text,
  word_count integer NOT NULL DEFAULT 0,
  is_sensitive boolean DEFAULT false,
  reviewed boolean DEFAULT false,
  status text NOT NULL DEFAULT 'active'::text,
  CONSTRAINT belief_expressions_pkey PRIMARY KEY (id),
  CONSTRAINT belief_expressions_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.clients (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid UNIQUE,
  client_name text NOT NULL,
  contact_name text,
  contact_email text,
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT clients_pkey PRIMARY KEY (id),
  CONSTRAINT clients_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.data_access_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid,
  accessed_by uuid NOT NULL,
  table_name text NOT NULL,
  action text NOT NULL,
  accessed_at timestamp with time zone NOT NULL DEFAULT now(),
  ip_address text,
  purpose text NOT NULL,
  CONSTRAINT data_access_logs_pkey PRIMARY KEY (id),
  CONSTRAINT data_access_logs_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.data_transfers (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid,
  data_scope text NOT NULL,
  destination_country text NOT NULL,
  recipient_type text NOT NULL,
  safeguards text NOT NULL,
  transferred_at timestamp with time zone NOT NULL DEFAULT now(),
  expires_at timestamp with time zone,
  dpo_approved uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT data_transfers_pkey PRIMARY KEY (id),
  CONSTRAINT data_transfers_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id),
  CONSTRAINT data_transfers_dpo_approved_fkey FOREIGN KEY (dpo_approved) REFERENCES public.dpos(id)
);
CREATE TABLE public.dpos (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  jurisdiction text NOT NULL DEFAULT 'SG'::text,
  active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT dpos_pkey PRIMARY KEY (id)
);
CREATE TABLE public.global_settings (
  key text NOT NULL,
  value jsonb NOT NULL,
  updated_by uuid,
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT global_settings_pkey PRIMARY KEY (key),
  CONSTRAINT global_settings_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.interview_sessions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  member_id uuid NOT NULL,
  project_member_id uuid,
  session_type text,
  status text NOT NULL DEFAULT 'scheduled'::text CHECK (status = ANY (ARRAY['scheduled'::text, 'in_progress'::text, 'completed'::text, 'cancelled'::text, 'no_show'::text])),
  scheduled_at timestamp with time zone,
  started_at timestamp with time zone,
  completed_at timestamp with time zone,
  conducted_by uuid,
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT interview_sessions_pkey PRIMARY KEY (id),
  CONSTRAINT interview_sessions_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id),
  CONSTRAINT interview_sessions_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id),
  CONSTRAINT interview_sessions_project_member_id_fkey FOREIGN KEY (project_member_id) REFERENCES public.project_members(id),
  CONSTRAINT interview_sessions_conducted_by_fkey FOREIGN KEY (conducted_by) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.member_consents (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  project_id uuid,
  dpo_id uuid,
  consent_type text NOT NULL,
  scope text,
  purposes ARRAY,
  consent_status text NOT NULL DEFAULT 'granted'::text,
  granted_at timestamp with time zone NOT NULL DEFAULT now(),
  withdrawn_at timestamp with time zone,
  expires_at timestamp with time zone,
  jurisdiction text,
  legal_basis text,
  version text,
  ip_address text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_consents_pkey PRIMARY KEY (id),
  CONSTRAINT member_consents_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id),
  CONSTRAINT member_consents_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id),
  CONSTRAINT member_consents_dpo_id_fkey FOREIGN KEY (dpo_id) REFERENCES public.dpos(id)
);
CREATE TABLE public.member_consumption (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  shopping_preference text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_consumption_pkey PRIMARY KEY (id),
  CONSTRAINT member_consumption_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_consumption_entries (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  category text,
  brand text,
  has_subscription boolean,
  monthly_cost numeric,
  currency text,
  duration integer,
  usage_type text,
  usage_frequency text,
  usage_recency text,
  spend_level text,
  loyalty text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_consumption_entries_pkey PRIMARY KEY (id),
  CONSTRAINT member_consumption_entries_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_data_requests (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  dpo_id uuid,
  request_type text NOT NULL,
  request_subtype text,
  status text NOT NULL DEFAULT 'pending'::text,
  requested_at timestamp with time zone NOT NULL DEFAULT now(),
  completed_at timestamp with time zone,
  handled_by uuid,
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_data_requests_pkey PRIMARY KEY (id),
  CONSTRAINT member_data_requests_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id),
  CONSTRAINT member_data_requests_dpo_id_fkey FOREIGN KEY (dpo_id) REFERENCES public.dpos(id),
  CONSTRAINT member_data_requests_handled_by_fkey FOREIGN KEY (handled_by) REFERENCES public.dpos(id)
);
CREATE TABLE public.member_data_retention (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  data_scope text NOT NULL,
  purpose text NOT NULL,
  retain_until timestamp with time zone NOT NULL,
  disposed_at timestamp with time zone,
  dpo_id uuid,
  retention_reason text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_data_retention_pkey PRIMARY KEY (id),
  CONSTRAINT member_data_retention_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id),
  CONSTRAINT member_data_retention_dpo_id_fkey FOREIGN KEY (dpo_id) REFERENCES public.dpos(id)
);
CREATE TABLE public.member_education (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  highest_education text,
  field_of_study text,
  currently_studying boolean,
  current_study_level text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_education_pkey PRIMARY KEY (id),
  CONSTRAINT member_education_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_employment (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  employment_status text,
  employment_type ARRAY,
  total_work_hours_weekly integer,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_employment_pkey PRIMARY KEY (id),
  CONSTRAINT member_employment_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_employment_entries (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  is_primary boolean,
  job_title text,
  company_name text,
  company_size text,
  company_size_min integer,
  company_size_max integer,
  company_type text,
  company_annual_revenue text,
  company_revenue_min bigint,
  company_revenue_max bigint,
  industry text,
  seniority_level text,
  years_in_role integer,
  years_in_industry integer,
  employment_arrangement text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  decision_maker text,
  hirer text,
  CONSTRAINT member_employment_entries_pkey PRIMARY KEY (id),
  CONSTRAINT member_employment_entries_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_employment_qualifications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  qualification_type text,
  qualification_name text,
  institution text,
  year_obtained integer,
  is_current boolean,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_employment_qualifications_pkey PRIMARY KEY (id),
  CONSTRAINT member_employment_qualifications_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_employment_skills (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  skill text,
  proficiency text,
  skill_type text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_employment_skills_pkey PRIMARY KEY (id),
  CONSTRAINT member_employment_skills_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);

CREATE TABLE public.member_experiences_life_events (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  event_type text,
  year integer,
  brief_description text,
  description_embedding USER-DEFINED,
  impact_level text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_experiences_life_events_pkey PRIMARY KEY (id),
  CONSTRAINT member_experiences_life_events_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);

CREATE TABLE public.member_experiences_narratives (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  experience_category text,
  narrative text,
  themes ARRAY,
  embedding USER-DEFINED,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_experiences_narratives_pkey PRIMARY KEY (id),
  CONSTRAINT member_experiences_narratives_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);

CREATE TABLE public.member_experiences_research_history (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  previous_research boolean,
  research_types ARRAY,
  research_topics text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_experiences_research_history_pkey PRIMARY KEY (id),
  CONSTRAINT member_experiences_research_history_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_financial (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  income_type text,
  personal_income_bracket text,
  personal_income_min integer,
  personal_income_max integer,
  household_income_bracket text,
  household_income_min integer,
  household_income_max integer,
  income_unknown boolean,
  income_currency text,
  total_net_worth text,
  net_worth_min bigint,
  net_worth_max bigint,
  wealth_indicators ARRAY,
  assets_under_management text,
  aum_min bigint,
  aum_max bigint,
  asset_locations ARRAY,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_financial_pkey PRIMARY KEY (id),
  CONSTRAINT member_financial_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_financial_cards (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  banking_id uuid NOT NULL,
  member_id uuid NOT NULL,
  card_type text,
  card_tier text,
  rewards_type text,
  is_primary boolean,
  opened_year integer,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_financial_cards_pkey PRIMARY KEY (id),
  CONSTRAINT member_financial_cards_banking_id_fkey FOREIGN KEY (banking_id) REFERENCES public.member_financial_institutions(id),
  CONSTRAINT member_financial_cards_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_financial_institutions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  institution_type text,
  institution_name text,
  relationship_type ARRAY,
  is_primary boolean,
  products_held ARRAY,
  frequency text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_financial_institutions_pkey PRIMARY KEY (id),
  CONSTRAINT member_financial_institutions_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_financial_investments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  investment_type text,
  platform text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_financial_investments_pkey PRIMARY KEY (id),
  CONSTRAINT member_financial_investments_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_health (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  general_health text,
  disabilities ARRAY,
  uses_assistive_tech ARRAY,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_health_pkey PRIMARY KEY (id),
  CONSTRAINT member_health_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_health_addiction (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  addiction_history ARRAY,
  recovery_status text,
  recovery_duration integer,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_health_addiction_pkey PRIMARY KEY (id),
  CONSTRAINT member_health_addiction_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_health_allergies (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  allergen text,
  severity text,
  type text,
  is_clinically_diagnosed boolean DEFAULT false,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_health_allergies_pkey PRIMARY KEY (id),
  CONSTRAINT member_health_allergies_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_health_conditions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  condition_category text,
  condition_name text,
  status text,
  diagnosed_year integer,
  notes text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_health_conditions_pkey PRIMARY KEY (id),
  CONSTRAINT member_health_conditions_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_health_medical_participation (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  in_clinical_trial boolean,
  clinical_trial_type text,
  regular_medications boolean,
  medication_count integer,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_health_medical_participation_pkey PRIMARY KEY (id),
  CONSTRAINT member_health_medical_participation_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_health_mental (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  mental_health_history ARRAY,
  mental_health_status text,
  currently_in_therapy boolean,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_health_mental_pkey PRIMARY KEY (id),
  CONSTRAINT member_health_mental_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_household (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  marital_status text,
  marital_history ARRAY,
  household_size integer,
  housing_type text,
  housing_ownership text,
  pets ARRAY,
  pets_count integer,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  residency_status text,
  country_of_residence text,
  state_region text,
  city text,
  postal_code text,
  children_count integer,
  CONSTRAINT member_household_pkey PRIMARY KEY (id),
  CONSTRAINT member_household_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_household_dependents (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  relationship text,
  birth_year date,
  gender text,
  education_level text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  dependency text,
  CONSTRAINT member_household_dependents_pkey PRIMARY KEY (id),
  CONSTRAINT member_household_dependents_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_household_pets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  pet_type text,
  breed text,
  name text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  birth_year date,
  CONSTRAINT member_household_pets_pkey PRIMARY KEY (id),
  CONSTRAINT member_household_pets_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_identity (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  date_of_birth date,
  gender_identity text,
  sexual_orientation text,
  ethnicities ARRAY,
  nationalities ARRAY,
  citizenships ARRAY,
  religion text,
  socioeconomic_self_assessment text,
  communication_preferences ARRAY,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  country_of_birth text,
  CONSTRAINT member_identity_pkey PRIMARY KEY (id),
  CONSTRAINT member_identity_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_identity_languages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  language text NOT NULL,
  proficiency text NOT NULL,
  is_primary boolean DEFAULT false,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_identity_languages_pkey PRIMARY KEY (id),
  CONSTRAINT member_identity_languages_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_intentions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  frustrations text,
  frustrations_embedding USER-DEFINED,
  unmet_needs text,
  unmet_needs_embedding USER-DEFINED,
  switching_considerations text,
  switching_considerations_embedding USER-DEFINED,
  career_intentions text,
  career_intentions_embedding USER-DEFINED,
  life_changes_considered text,
  life_changes_embedding USER-DEFINED,
  concerns_worries text,
  concerns_worries_embedding USER-DEFINED,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_intentions_pkey PRIMARY KEY (id),
  CONSTRAINT member_intentions_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_intentions_goals (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  goal_category text,
  goal_description text,
  goal_embedding USER-DEFINED,
  timeframe text,
  priority text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_intentions_goals_pkey PRIMARY KEY (id),
  CONSTRAINT member_intentions_goals_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_intentions_purchases (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  intended_purchase text,
  purchase_embedding USER-DEFINED,
  category text,
  timeframe text,
  stage text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_intentions_purchases_pkey PRIMARY KEY (id),
  CONSTRAINT member_intentions_purchases_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_lifestyle (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  diet_type ARRAY,
  diet_reason text,
  cooking_frequency text,
  eating_out_frequency text,
  alcohol_consumption text,
  tobacco_use text,
  vaping text,
  exercise_frequency text,
  exercise_types ARRAY,
  gym_membership boolean,
  travel_frequency text,
  sleep_hours text,
  chronotype text,
  work_schedule text,
  community_affiliations ARRAY,
  subculture_identity text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_lifestyle_pkey PRIMARY KEY (id),
  CONSTRAINT member_lifestyle_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_lifestyle_activities (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  activity text,
  category text,
  frequency text,
  intensity text,
  years_doing integer,
  spend_level text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_lifestyle_activities_pkey PRIMARY KEY (id),
  CONSTRAINT member_lifestyle_activities_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_lifestyle_travel (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  country text,
  travel_type ARRAY,
  travel_interests ARRAY,
  visit_date date,
  trip_type text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_lifestyle_travel_pkey PRIMARY KEY (id),
  CONSTRAINT member_lifestyle_travel_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_media_habits (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  media_type text,
  title text,
  genre text,
  frequency text,
  platform text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_media_habits_pkey PRIMARY KEY (id),
  CONSTRAINT member_media_habits_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_media_subscriptions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  service_name text,
  content_type text,
  plan_tier text,
  shared_account boolean DEFAULT false,
  hours_per_week text,
  favorite_genres ARRAY,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_media_subscriptions_pkey PRIMARY KEY (id),
  CONSTRAINT member_media_subscriptions_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_neuro_profile (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  neurodivergence_conditions ARRAY,
  diagnosis_status text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_neuro_profile_pkey PRIMARY KEY (id),
  CONSTRAINT member_neuro_profile_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_physical_profile (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  height_cm numeric,
  weight_kg numeric,
  handedness text,
  physical_notes text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_physical_profile_pkey PRIMARY KEY (id),
  CONSTRAINT member_physical_profile_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_property (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  significant_assets ARRAY,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  estimated_property_value text,
  property_value_min bigint,
  property_value_max bigint,
  CONSTRAINT member_property_pkey PRIMARY KEY (id),
  CONSTRAINT member_property_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_property_entries (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  property_type text,
  ownership text,
  country text,
  city text,
  is_primary boolean NOT NULL DEFAULT false,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_property_entries_pkey PRIMARY KEY (id),
  CONSTRAINT member_property_entries_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_property_vehicles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  vehicle_type text,
  ownership text,
  payment numeric,
  currency text,
  make text,
  model text,
  year integer,
  fuel_type text,
  is_primary boolean,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_property_vehicles_pkey PRIMARY KEY (id),
  CONSTRAINT member_property_vehicles_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_sensory_profile (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  smell_sensitivity text,
  taste_sensitivity text,
  colour_vision text,
  hearing text,
  touch_sensitivity text,
  sensory_notes text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_sensory_profile_pkey PRIMARY KEY (id),
  CONSTRAINT member_sensory_profile_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_technology_behaviour (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL UNIQUE,
  screen_time_daily text,
  digital_comfort text,
  digital_skills text,
  privacy_concern text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_technology_behaviour_pkey PRIMARY KEY (id),
  CONSTRAINT member_technology_behaviour_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_technology_devices (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  device_type text,
  brand text,
  model text,
  operating_system text,
  is_primary boolean,
  ownership text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_technology_devices_pkey PRIMARY KEY (id),
  CONSTRAINT member_technology_devices_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_technology_non_use (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  platform_avoided text,
  category_avoided text,
  reason text,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_technology_non_use_pkey PRIMARY KEY (id),
  CONSTRAINT member_technology_non_use_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.member_technology_platforms (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  platform_name text,
  platform_category text,
  usage_frequency text,
  usage_recency text,
  is_paid_subscriber boolean,
  raw_source jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT member_technology_platforms_pkey PRIMARY KEY (id),
  CONSTRAINT member_technology_platforms_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id)
);
CREATE TABLE public.members (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid UNIQUE,
  email text NOT NULL UNIQUE,
  phone text,
  full_name text NOT NULL,
  status text NOT NULL DEFAULT 'active'::text CHECK (status = ANY (ARRAY['active'::text, 'inactive'::text, 'blocked'::text])),
  source text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  registration_country text,
  CONSTRAINT members_pkey PRIMARY KEY (id),
  CONSTRAINT members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.project_communications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  member_id uuid NOT NULL,
  direction text NOT NULL,
  msg_type text NOT NULL,
  subject text,
  body_html text,
  sender text,
  reciever text,
  bcc text,
  cc text,
  sent_by uuid,
  sent_at timestamp with time zone NOT NULL DEFAULT now(),
  read_at timestamp with time zone,
  status text NOT NULL DEFAULT 'sent'::text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT project_communications_pkey PRIMARY KEY (id),
  CONSTRAINT project_communications_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id),
  CONSTRAINT project_communications_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id),
  CONSTRAINT project_communications_sent_by_fkey FOREIGN KEY (sent_by) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.project_cost_items (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  cost_type text NOT NULL,
  description text,
  amount numeric NOT NULL,
  currency text NOT NULL DEFAULT 'SGD'::text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT project_cost_items_pkey PRIMARY KEY (id),
  CONSTRAINT project_cost_items_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id)
);
CREATE TABLE public.project_filters (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  bucket text NOT NULL,
  field text NOT NULL,
  operator text NOT NULL,
  value jsonb NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT project_filters_pkey PRIMARY KEY (id),
  CONSTRAINT project_filters_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id)
);
CREATE TABLE public.project_financials (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL UNIQUE,
  currency text NOT NULL DEFAULT 'SGD'::text,
  incentive_per_participant numeric,
  screening_cost_per_participant numeric,
  qualification_rate numeric,
  scheduling_rate numeric,
  discount numeric DEFAULT 0,
  tax_rate numeric DEFAULT 15.00,
  calculated_total numeric,
  adjusted_total numeric,
  payment_status text NOT NULL DEFAULT 'unpaid'::text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT project_financials_pkey PRIMARY KEY (id),
  CONSTRAINT project_financials_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id)
);
CREATE TABLE public.project_members (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  member_id uuid NOT NULL,
  match_status text NOT NULL DEFAULT 'potential'::text,
  matched_at timestamp with time zone NOT NULL DEFAULT now(),
  matched_by uuid,
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT project_members_pkey PRIMARY KEY (id),
  CONSTRAINT project_members_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id),
  CONSTRAINT project_members_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id),
  CONSTRAINT project_members_matched_by_fkey FOREIGN KEY (matched_by) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.project_questions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  question_text text NOT NULL,
  question_type text NOT NULL CHECK (question_type = ANY (ARRAY['text'::text, 'textarea'::text, 'number'::text, 'date'::text])),
  is_required boolean NOT NULL DEFAULT false,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT project_questions_pkey PRIMARY KEY (id),
  CONSTRAINT project_questions_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id)
);
CREATE TABLE public.projects (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_code text NOT NULL UNIQUE,
  client_id uuid NOT NULL,
  manager_id uuid,
  created_by uuid NOT NULL,
  project_name text NOT NULL,
  project_description text,
  session_type text,
  session_language text,
  session_frequency text,
  session_duration_minutes integer,
  target_match_count integer,
  target_start_date date,
  target_completion_date date,
  project_stage text NOT NULL DEFAULT 'draft'::text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT projects_pkey PRIMARY KEY (id),
  CONSTRAINT projects_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.user_profiles(id),
  CONSTRAINT projects_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id),
  CONSTRAINT projects_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.user_profiles(id)
);
CREATE TABLE public.session_responses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL,
  question_id uuid NOT NULL,
  response_value text,
  answered_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT session_responses_pkey PRIMARY KEY (id),
  CONSTRAINT session_responses_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.interview_sessions(id),
  CONSTRAINT session_responses_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.project_questions(id)
);
CREATE TABLE public.user_profiles (
  id uuid NOT NULL,
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  role text NOT NULL DEFAULT 'manager'::text CHECK (role = ANY (ARRAY['admin'::text, 'manager'::text, 'client'::text, 'member'::text])),
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT user_profiles_pkey PRIMARY KEY (id),
  CONSTRAINT user_profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);