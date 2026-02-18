-- ============================================================
-- BUCKET 3: HEALTH (6 tables) — SENSITIVE
-- ============================================================

-- RLS: senior_manager+
CREATE TABLE member_health (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id          UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    general_health     TEXT,
    disabilities       TEXT[],
    uses_assistive_tech TEXT[],
    raw_source         JSONB,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RLS: senior_manager+
CREATE TABLE member_health_conditions (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id          UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    condition_category TEXT,
    condition_name     TEXT,
    status             TEXT,
    diagnosed_year     INTEGER,
    notes              TEXT,
    raw_source         JSONB,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RLS: admin_only — compliance override for extreme privacy
CREATE TABLE member_health_mental (
    id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id              UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    mental_health_history  TEXT[],
    mental_health_status   TEXT,
    currently_in_therapy   BOOLEAN,
    raw_source             JSONB,
    created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at             TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RLS: admin_only — compliance override for extreme privacy
CREATE TABLE member_health_addiction (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id         UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    addiction_history  TEXT[],
    recovery_status   TEXT,
    recovery_duration INTEGER,
    raw_source        JSONB,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RLS: senior_manager+
CREATE TABLE member_health_medical_participation (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id           UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    in_clinical_trial   BOOLEAN,
    clinical_trial_type TEXT,
    regular_medications BOOLEAN,
    medication_count    INTEGER,
    raw_source          JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RLS: senior_manager+
CREATE TABLE member_health_allergies (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id             UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    allergen              TEXT,
    severity              TEXT,
    type                  TEXT,
    is_clinically_diagnosed BOOLEAN DEFAULT false,
    raw_source            JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- BUCKET 4: EMPLOYMENT & EDUCATION (5 tables)
-- ============================================================

CREATE TABLE member_employment (
    id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id              UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    employment_status      TEXT, -- ['full-time', 'part-time', 'contract', 'freelance', 'unemployed', 'gig work', 'retired']
    employment_type        TEXT[],
    total_work_hours_weekly INTEGER,
    raw_source             JSONB,
    created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at             TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_education (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id           UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    highest_education   TEXT,
    field_of_study      TEXT,
    currently_studying  BOOLEAN,
    current_study_level TEXT,
    raw_source          JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_employment_entries (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id               UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    is_primary              BOOLEAN,
    job_title               TEXT,
    company_name            TEXT,
    company_size            TEXT,
    company_type            TEXT,
    company_annual_revenue  TEXT,
    industry                TEXT,
    seniority_level         TEXT,
    years_in_role           INTEGER,
    years_in_industry       INTEGER,
    employment_arrangement  TEXT,
    raw_source              JSONB,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_employment_skills (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id   UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    skill       TEXT,
    proficiency TEXT,
    skill_type  TEXT,
    raw_source  JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_employment_qualifications (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id          UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    qualification_type TEXT,
    qualification_name TEXT,
    institution        TEXT,
    year_obtained      INTEGER,
    is_current         BOOLEAN,
    raw_source         JSONB,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);