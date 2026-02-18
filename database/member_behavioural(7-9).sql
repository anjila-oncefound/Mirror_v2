-- ============================================================
-- BUCKET 7: TECHNOLOGY (4 tables)
-- ============================================================

CREATE TABLE member_technology_behaviour (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id       UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    screen_time_daily TEXT,
    digital_comfort TEXT,
    digital_skills  TEXT,
    privacy_concern TEXT,
    raw_source      JSONB,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_technology_devices (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id        UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    device_type      TEXT,
    brand            TEXT,
    model            TEXT,
    operating_system TEXT,
    is_primary       BOOLEAN,
    ownership        TEXT,
    raw_source       JSONB,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_technology_platforms (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id          UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    platform_name      TEXT,
    platform_category  TEXT,
    usage_frequency    TEXT,
    usage_recency      TEXT,
    is_paid_subscriber BOOLEAN,
    raw_source         JSONB,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- "Absence is data" — captures what members deliberately avoid
CREATE TABLE member_technology_non_use (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id        UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    platform_avoided TEXT,
    category_avoided TEXT,
    reason           TEXT,
    raw_source       JSONB,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- BUCKET 8: CONSUMPTION & SERVICES (2 tables)
-- ============================================================

CREATE TABLE member_consumption (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id           UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    shopping_preference TEXT,
    raw_source          JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_consumption_entries (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id        UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    category         TEXT,
    brand            TEXT,
    has_subscription BOOLEAN,
    monthly_cost     NUMERIC,
    currency         TEXT,
    duration         INTEGER,
    usage_type       TEXT,
    usage_frequency TEXT,
    usage_recency   TEXT,
    spend_level      TEXT,
    loyalty          TEXT,
    raw_source       JSONB,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- BUCKET 9: LIFESTYLE (3 tables)
-- ============================================================

CREATE TABLE member_lifestyle (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id               UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    -- Diet
    diet_type               TEXT[],
    diet_reason             TEXT,
    cooking_frequency       TEXT,
    eating_out_frequency    TEXT,
    -- Alcohol & Tobacco
    alcohol_consumption     TEXT,
    tobacco_use             TEXT,
    vaping                  TEXT,
    -- Exercise & Fitness
    exercise_frequency      TEXT,
    exercise_types          TEXT[],
    gym_membership          BOOLEAN,
    -- Travel
    travel_frequency        TEXT,
    -- Sleep & Routine
    sleep_hours             TEXT,
    chronotype              TEXT,
    work_schedule           TEXT,
    -- Community / Subculture
    community_affiliations  TEXT[],
    subculture_identity     TEXT,
    raw_source              JSONB,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_lifestyle_activities (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id   UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    activity    TEXT,
    category    TEXT,
    frequency   TEXT,
    intensity   TEXT,
    years_doing INTEGER,
    spend_level TEXT,
    raw_source  JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_lifestyle_travel (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id        UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    country          TEXT,
    travel_type      TEXT[],
    travel_interests TEXT[],
    visit_date       DATE,
    trip_type        TEXT,
    raw_source       JSONB,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);