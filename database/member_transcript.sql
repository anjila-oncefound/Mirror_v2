-- ============================================================
-- INTERVIEW TRANSCRIPT STORAGE
-- ============================================================

CREATE TABLE member_interview_responses (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id       UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    session_id      UUID,
    sequence_number INTEGER,
    question        TEXT,
    answer          TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);