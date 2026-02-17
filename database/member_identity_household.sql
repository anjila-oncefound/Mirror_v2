

-- ============================================================
-- BUCKET 1: IDENTITY (5 tables)
-- ============================================================

CREATE TABLE member_identity (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id                   UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    date_of_birth               DATE,
    gender_identity             TEXT,
    sexual_orientation          TEXT,
    ethnicities                 TEXT[],
    nationalities               TEXT[],
    citizenships                TEXT[],
    country_of_residence        TEXT,
    city                        TEXT,
    religion                    TEXT,
    socioeconomic_self_assessment TEXT,
    communication_preferences   TEXT[],
    raw_source                  JSONB,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_identity_languages (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id   UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    language    TEXT NOT NULL,
    proficiency TEXT NOT NULL,
    is_primary  BOOLEAN DEFAULT false,
    raw_source  JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_sensory_profile (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id         UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    smell_sensitivity TEXT,
    taste_sensitivity TEXT,
    colour_vision     TEXT,
    hearing           TEXT,
    touch_sensitivity TEXT,
    sensory_notes     TEXT,
    raw_source        JSONB,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_physical_profile (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id      UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    height_cm      NUMERIC,
    weight_kg      NUMERIC,
    handedness     TEXT,
    physical_notes TEXT,
    raw_source     JSONB,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Compliance override: separate table for RLS isolation regardless of score
CREATE TABLE member_neuro_profile (
    id                         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id                  UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    neurodivergence_conditions TEXT[],
    diagnosis_status           TEXT,
    raw_source                 JSONB,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                 TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- BUCKET 2: HOUSEHOLD (3 tables)
-- ============================================================

CREATE TABLE member_household (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id         UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    marital_status    TEXT,
    marital_history   TEXT[],
    household_size    INTEGER,
    housing_type      TEXT,
    housing_ownership TEXT,
    household_income  INTEGER,
    pets              TEXT[],
    pets_count        INTEGER,
    raw_source        JSONB,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_household_dependents (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id       UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    relationship    TEXT,
    birth_year      INTEGER,    -- not DATE; compute age at query time
    gender          TEXT,
    special_needs   BOOLEAN,
    education_level TEXT,
    raw_source      JSONB,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_household_pets (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id   UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    pet_type    TEXT,        -- 'Dog', 'Cat', 'Fish', etc.
    breed       TEXT,        -- 'Golden Retriever', 'Persian', etc.
    name        TEXT,
    age_years   INTEGER,
    raw_source  JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);