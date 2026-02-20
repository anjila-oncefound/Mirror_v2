-- ============================================================
-- BUCKET 5: FINANCIAL (4 tables) — SENSITIVE
-- ============================================================

-- RLS: admin
CREATE TABLE member_financial (
    id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id                UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    income_type              TEXT,
    personal_income_bracket  TEXT,
    household_income_bracket TEXT,
    income_unknown           BOOLEAN,
    income_currency          TEXT,
    total_net_worth          TEXT,
    wealth_indicators        TEXT[],
    assets_under_management  TEXT,
    asset_locations          TEXT[],
    raw_source               JSONB,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RLS: admin
CREATE TABLE member_financial_institutions (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id         UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    institution_type  TEXT,
    institution_name  TEXT,
    relationship_type TEXT[],
    is_primary        BOOLEAN,
    products_held     TEXT[],
    frequency         TEXT,
    raw_source        JSONB,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- FKs to both banking (ownership) and members (RLS)
CREATE TABLE member_financial_cards (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    banking_id  UUID NOT NULL REFERENCES member_financial_institutions(id) ON DELETE CASCADE,
    member_id   UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    card_type   TEXT,
    card_tier   TEXT,
    rewards_type TEXT,
    is_primary  BOOLEAN,
    opened_year INTEGER,
    raw_source  JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RLS: admin
CREATE TABLE member_financial_investments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id       UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    investment_type TEXT,
    platform        TEXT,
    raw_source      JSONB,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- BUCKET 6: PROPERTY (2 tables)
-- ============================================================

CREATE TABLE member_property (
    id                           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id                    UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    significant_assets           TEXT[],        -- 'jewelry', 'art', 'collectibles' —non-property assets
    raw_source                   JSONB,
    created_at                   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_property_vehicles (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id   UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    vehicle_type TEXT,
    ownership   TEXT,
    payment     NUMERIC,
    currency    TEXT,
    make        TEXT,
    model       TEXT,
    year        INTEGER,
    fuel_type   TEXT,
    is_primary  BOOLEAN,
    raw_source  JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_property_entries (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id       UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    property_type   TEXT,          -- 'house', 'apartment', 'condo', 'land', 'commercial'
    ownership       TEXT,          -- 'owned', 'mortgaged', 'rented_out', 'inherited'
    country         TEXT,
    city            TEXT,
    is_primary      BOOLEAN NOT NULL DEFAULT false,
    raw_source      JSONB,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);