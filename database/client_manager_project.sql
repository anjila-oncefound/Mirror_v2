-- ============================================================
-- CLIENTS (company/org that commissions research)
-- ============================================================
-- user_id is nullable — not all clients have login access yet.
-- When a client gets portal access, link their user_profiles row.

CREATE TABLE clients (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID UNIQUE REFERENCES user_profiles(id),  -- nullable until client gets login
    client_name     TEXT NOT NULL,
    contact_name    TEXT,
    contact_email   TEXT,
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- PROJECTS
-- ============================================================

CREATE TABLE projects (
    id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_code             TEXT UNIQUE NOT NULL,  -- user-friendly ID (e.g. "SG-2026-042")
    client_id                UUID NOT NULL REFERENCES clients(id),
    manager_id               UUID REFERENCES user_profiles(id),
    created_by               UUID NOT NULL REFERENCES user_profiles(id),
    project_name             TEXT NOT NULL,
    project_description      TEXT,

    -- Session config
    session_type             TEXT,          -- 'IDI', 'Focus Group', 'Survey', etc.
    session_language         TEXT,
    session_frequency        TEXT,
    session_duration_minutes INTEGER,

    -- Matching targets
    target_match_count       INTEGER,
    target_start_date        DATE,
    target_completion_date   DATE,

    -- Status (project lifecycle only)
    project_stage            TEXT NOT NULL DEFAULT 'draft',
    -- 'draft', 'pending_approval', 'approved', 'recruiting',
    -- 'in_field', 'completed', 'cancelled'

    created_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Auto-assign: when a manager creates a project, they become the manager
-- (admins can reassign later). Handled via application logic:
--   if (user.role === 'manager') project.manager_id = user.id

-- ============================================================
-- PROJECT FINANCIALS (separated — auditable, independent status)
-- ============================================================

CREATE TABLE project_financials (
    id                             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id                     UUID NOT NULL UNIQUE REFERENCES projects(id),
    currency                       TEXT NOT NULL DEFAULT 'SGD',
    incentive_per_participant      NUMERIC(10,2),
    screening_cost_per_participant NUMERIC(10,2),
    qualification_rate             NUMERIC(5,2),  -- percentage
    scheduling_rate                NUMERIC(5,2),  -- percentage
    discount                       NUMERIC(10,2) DEFAULT 0,
    tax_rate                       NUMERIC(5,2) DEFAULT 15.00,
    calculated_total               NUMERIC(12,2),
    adjusted_total                 NUMERIC(12,2), -- client override
    payment_status                 TEXT NOT NULL DEFAULT 'unpaid',
    -- 'unpaid', 'invoiced', 'partially_paid', 'paid'
    created_at                     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- PROJECT COST LINE ITEMS (replaces research_cost JSONB)
-- ============================================================

CREATE TABLE project_cost_items (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id  UUID NOT NULL REFERENCES projects(id),
    cost_type   TEXT NOT NULL,  -- 'recruitment', 'incentive', 'venue', 'transcription', etc.
    description TEXT,
    amount      NUMERIC(10,2) NOT NULL,
    currency    TEXT NOT NULL DEFAULT 'SGD',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- PROJECT FILTERS (replaces filters JSONB)
-- ============================================================

CREATE TABLE project_filters (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id  UUID NOT NULL REFERENCES projects(id),
    bucket      TEXT NOT NULL,    -- which data bucket to filter on
    field       TEXT NOT NULL,    -- which field within that bucket
    operator    TEXT NOT NULL,    -- 'equals', 'contains', 'in', 'range', 'gt', 'lt'
    value       JSONB NOT NULL,   -- flexible: "Male", ["SG","MY"], {"min":25,"max":40}
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Example filters:
-- { bucket: 'identity', field: 'gender', operator: 'equals', value: '"Male"' }
-- { bucket: 'identity', field: 'age', operator: 'range', value: '{"min":25,"max":40}' }
-- { bucket: 'employment', field: 'industry', operator: 'in', value: '["Tech","Finance"]' }

-- ============================================================
-- PROJECT MEMBERS (replaces UUID arrays — the junction table)
-- ============================================================

CREATE TABLE project_members (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id  UUID NOT NULL REFERENCES projects(id),
    member_id   UUID NOT NULL REFERENCES members(id),
    match_status TEXT NOT NULL DEFAULT 'potential',
    -- 'potential', 'qualified', 'invited', 'confirmed',
    -- 'completed', 'no_show', 'disqualified', 'declined'
    matched_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    matched_by  UUID REFERENCES user_profiles(id),
    notes       TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(project_id, member_id)
);

-- ============================================================
-- COMMUNICATIONS (flat rows, not JSONB blobs)
-- ============================================================

CREATE TABLE project_communications (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id  UUID NOT NULL REFERENCES projects(id),
    member_id   UUID NOT NULL REFERENCES members(id),
    direction   TEXT NOT NULL,    -- 'outbound', 'inbound'
    msg_type    TEXT NOT NULL,    -- 'email', 'sms', 'whatsapp', 'system'
    subject     TEXT,
    body_html   TEXT,
    from        TEXT,
    to          TEXT,
    bcc         TEXT,
    cc          TEXT,
    sent_by     UUID REFERENCES user_profiles(id),
    sent_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    read_at     TIMESTAMPTZ, -- Will come from headers, see resend api
    status      TEXT NOT NULL DEFAULT 'sent', 
    -- 'draft', 'sent', 'delivered', 'read', 'failed', 'bounced'
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- GLOBAL SETTINGS (key-value, simple)
-- ============================================================

CREATE TABLE global_settings (
    key         TEXT PRIMARY KEY,
    value       JSONB NOT NULL,
    updated_by  UUID REFERENCES user_profiles(id),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Seed defaults:
-- INSERT INTO global_settings (key, value) VALUES
--   ('estimated_qualification_rate', '0.60'),
--   ('estimated_attendance_rate', '0.85'),
--   ('screening_cost_per_participant', '5.00'),
--   ('default_currency', '"SGD"'),
--   ('default_tax_rate', '15.00');