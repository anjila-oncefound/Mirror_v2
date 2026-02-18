-- ============================================================
  -- 2. PROJECT QUESTIONS — the actual questions
  -- ============================================================
CREATE TABLE project_questions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    section_id      UUID NOT NULL REFERENCES project_question_sections(id) ON DELETE CASCADE,
    project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,

    question_text   TEXT NOT NULL,            -- "How often do you purchase organic food?"
    question_type   TEXT NOT NULL
        CHECK (question_type IN (
            'text', 'textarea', 'number', 'date'
        )),

    -- Type-specific config
    -- options         JSONB,                    -- single/multi_select: [{"value":"a","label":"Daily"}, ...]
                                            -- rating: {"min":1, "max":10, "labels":{"1":"Low","10":"High"}}
    -- validation      JSONB,                    -- {"required":true, "min":0, "max":100, "maxLength":500}

    is_required     BOOLEAN NOT NULL DEFAULT false,
    sort_order      INTEGER NOT NULL DEFAULT 0,

    -- Optional: maps this question's answer to a bucket column
    -- NOT used for auto-population in v1 — just metadata for future ETL
    -- bucket_mapping  JSONB,                    -- {"table":"member_financial","column":"annual_income"}

    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_pq_project ON project_questions(project_id);
CREATE INDEX idx_pq_section ON project_questions(section_id);

-- ============================================================
-- 3. INTERVIEW SESSIONS — the actual interview event
-- ============================================================
CREATE TABLE interview_sessions (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id        UUID NOT NULL REFERENCES projects(id),
    member_id         UUID NOT NULL REFERENCES members(id),
    project_member_id UUID REFERENCES project_members(id),   -- links to recruitment lifecycle

    session_type      TEXT,                   -- 'IDI', 'focus_group', 'survey' (inherits from project default)
    status            TEXT NOT NULL DEFAULT 'scheduled'
        CHECK (status IN ('scheduled', 'in_progress', 'completed','cancelled', 'no_show')),

    scheduled_at      TIMESTAMPTZ, 
    started_at        TIMESTAMPTZ,
    completed_at      TIMESTAMPTZ,
    conducted_by      UUID REFERENCES user_profiles(id),
    notes             TEXT,

    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_is_project ON interview_sessions(project_id);
CREATE INDEX idx_is_member ON interview_sessions(member_id);
CREATE INDEX idx_is_project_member ON interview_sessions(project_member_id);

-- ============================================================
-- 4. SESSION RESPONSES — answers to questions
-- ============================================================
CREATE TABLE session_responses (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id      UUID NOT NULL REFERENCES interview_sessions(id) ON DELETE CASCADE,
    question_id     UUID NOT NULL REFERENCES project_questions(id),

    -- Single column for the primary response value
    response_value  TEXT,                     -- works for text, number-as-string, selected value, date, boolean
    -- Structured data for complex types
    -- response_data   JSONB,                    -- multi_select: ["val1","val2"], or any structured payload

    answered_at     TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(session_id, question_id)           -- one answer per question per session
);

CREATE INDEX idx_sr_session ON session_responses(session_id);
CREATE INDEX idx_sr_question ON session_responses(question_id);