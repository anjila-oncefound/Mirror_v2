

-- ============================================================
-- BUCKET 1: IDENTITY (5 tables)
-- ============================================================

CREATE TABLE member_identity (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id                   UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    date_of_birth               DATE,
    country_of_birth            TEXT,
    gender_identity             TEXT,
    sexual_orientation          TEXT,
    ethnicities                 TEXT[],
    nationalities               TEXT[],
    citizenships                TEXT[],
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
    marital_status    TEXT, -- ['married', 'divorced', 'unmarried', 'open', 'widowed']
    marital_history   TEXT[],
    residency_status  TEXT, -- ['permanent residence', 'temporary', 'citizenship']
    country_of_residence        TEXT,
    state_region                TEXT,
    city                        TEXT,
    postal_code                 TEXT,
    household_size    INTEGER,
    housing_type      TEXT,
    housing_ownership TEXT,
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
    birth_year      DATE,    -- store full date; compute age at query time
    gender          TEXT,
    dependency      TEXT, -- Handicapped, child, special needs, financial dependents
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
    birth_year  DATE,
    raw_source  JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);