-- ============================================================
-- BUCKET 13: MEDIA & ENTERTAINMENT (2 tables)
-- ============================================================

CREATE TABLE member_media_subscriptions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id       UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    service_name    TEXT,
    content_type    TEXT,
    plan_tier       TEXT,
    shared_account  BOOLEAN DEFAULT false,
    hours_per_week  TEXT,
    favorite_genres TEXT[],
    raw_source      JSONB,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE member_media_habits (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id   UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    media_type  TEXT,
    title       TEXT,
    genre       TEXT,
    frequency   TEXT,
    platform    TEXT,
    raw_source  JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- INDEXES: member_id
CREATE INDEX idx_media_subscriptions_member  ON member_media_subscriptions(member_id);
CREATE INDEX idx_media_habits_member         ON member_media_habits(member_id);

-- INDEXES: searchable text fields (normalized)
CREATE INDEX idx_media_subscriptions_service ON member_media_subscriptions(LOWER(TRIM(service_name)));
CREATE INDEX idx_media_habits_title          ON member_media_habits(LOWER(TRIM(title)));
CREATE INDEX idx_media_habits_genre          ON member_media_habits(LOWER(TRIM(genre)));
CREATE INDEX idx_media_habits_media_type     ON member_media_habits(LOWER(TRIM(media_type)));

-- TRIGGERS: auto-set updated_at
CREATE TRIGGER set_updated_at BEFORE UPDATE ON member_media_subscriptions
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON member_media_habits
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();
