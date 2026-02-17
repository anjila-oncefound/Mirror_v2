-- ============================================================
-- BUCKET 10: EXPERIENCES (3 tables) — VECTOR-ENABLED
-- ============================================================

CREATE TABLE member_experiences (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id         UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    previous_research BOOLEAN,
    research_types    TEXT[],
    research_topics   TEXT,
    raw_source        JSONB,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_experiences_life_events (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id             UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    event_type            TEXT,
    year                  INTEGER,
    brief_description     TEXT,
    description_embedding VECTOR(1536),
    impact_level          TEXT,
    raw_source            JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_experiences_narratives (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id           UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    experience_category TEXT,
    narrative           TEXT,
    themes              TEXT[],
    embedding           VECTOR(1536),
    raw_source          JSONB,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- BUCKET 11: BELIEFS (2 tables + 1 materialized view) — VECTOR-ENABLED
-- ============================================================

CREATE TABLE belief_expressions (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id   UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    domain      TEXT NOT NULL,
    prompt_used TEXT,
    raw_text    TEXT NOT NULL,
    embedding   VECTOR(1536) NOT NULL,
    captured_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    source_type TEXT NOT NULL,
    project_id  UUID,
    session_id  UUID,
    language    TEXT NOT NULL DEFAULT 'en',
    word_count  INTEGER NOT NULL DEFAULT 0,
    is_sensitive BOOLEAN DEFAULT false,
    reviewed    BOOLEAN DEFAULT false,
    status      TEXT NOT NULL DEFAULT 'active'
);

CREATE TABLE belief_emergent_themes (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expression_id  UUID NOT NULL REFERENCES belief_expressions(id) ON DELETE CASCADE,
    member_id      UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    theme          TEXT NOT NULL,
    confidence     FLOAT NOT NULL,
    theme_category TEXT,
    discovered_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    model_version  TEXT NOT NULL
);

-- ============================================================
-- BUCKET 12: INTENTIONS (3 tables) — VECTOR-ENABLED
-- ============================================================

CREATE TABLE member_intentions (
    id                                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id                           UUID NOT NULL UNIQUE REFERENCES members(id) ON DELETE CASCADE,
    -- Pain Points
    frustrations                        TEXT,
    frustrations_embedding              VECTOR(1536),
    unmet_needs                         TEXT,
    unmet_needs_embedding               VECTOR(1536),
    switching_considerations            TEXT,
    switching_considerations_embedding  VECTOR(1536),
    -- Life Intentions
    career_intentions                   TEXT,
    career_intentions_embedding         VECTOR(1536),
    life_changes_considered             TEXT,
    life_changes_embedding              VECTOR(1536),
    concerns_worries                    TEXT,
    concerns_worries_embedding          VECTOR(1536),
    raw_source                          JSONB,
    created_at                          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_intentions_goals (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id        UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    goal_category    TEXT,
    goal_description TEXT,
    goal_embedding   VECTOR(1536),
    timeframe        TEXT,
    priority         TEXT,
    raw_source       JSONB,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_intentions_purchases (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id          UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    intended_purchase  TEXT,
    purchase_embedding VECTOR(1536),
    category           TEXT,
    timeframe          TEXT,
    stage              TEXT,
    raw_source         JSONB,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);