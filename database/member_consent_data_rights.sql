-- ============================================================
-- BUCKET 14: CONSENT & DATA RIGHTS (6 tables)
-- ============================================================
-- PDPA-compliant design covering all 11 obligations:
-- Consent, Purpose Limitation, Notification, Access,
-- Correction, Accuracy, Protection, Retention, Transfer,
-- Breach Notification, Data Portability, Accountability.
--
-- ALL tables in this bucket are APPEND-ONLY.
-- No updated_at columns. No update triggers.
-- Compliance records are immutable audit trails.
-- ============================================================

-- 1. DPO Registry (Accountability Obligation — mandatory per PDPC)
CREATE TABLE dpos (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name         TEXT NOT NULL,
    email        TEXT NOT NULL UNIQUE,
    jurisdiction TEXT NOT NULL DEFAULT 'SG',
    active       BOOLEAN NOT NULL DEFAULT true,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Consent & Agreement Records (Consent + Purpose Limitation + Notification + NDAs)
CREATE TABLE member_consents (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id      UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    project_id     UUID REFERENCES projects(id),              -- nullable: global consents have no project
    dpo_id         UUID REFERENCES dpos(id),
    consent_type   TEXT NOT NULL,                              -- 'data_processing', 'study_participation', 'nda', 'media_release'
    scope          TEXT,
    purposes       TEXT[],
    consent_status TEXT NOT NULL DEFAULT 'granted',
    granted_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    withdrawn_at   TIMESTAMPTZ,
    expires_at     TIMESTAMPTZ,
    jurisdiction   TEXT,                                       -- 'SG-PDPA', etc. — nullable for NDAs
    legal_basis    TEXT,                                       -- nullable for NDAs
    version        TEXT,
    ip_address     TEXT,
    raw_source     JSONB,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. Data Subject Requests (Access + Correction + Portability)
CREATE TABLE member_data_requests (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id       UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    dpo_id          UUID REFERENCES dpos(id),
    request_type    TEXT NOT NULL,
    request_subtype TEXT,
    status          TEXT NOT NULL DEFAULT 'pending',
    requested_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at    TIMESTAMPTZ,
    handled_by      UUID REFERENCES dpos(id),
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 4. Data Retention Policies (Retention Limitation — HIGH RISK)
CREATE TABLE member_data_retention (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id        UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    data_scope       TEXT NOT NULL,
    purpose          TEXT NOT NULL,
    retain_until     TIMESTAMPTZ NOT NULL,
    disposed_at      TIMESTAMPTZ,
    dpo_id           UUID REFERENCES dpos(id),
    retention_reason TEXT NOT NULL,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 5. Data Access Audit Log (Protection Obligation)
-- ON DELETE SET NULL: log survives member deletion, link severed
CREATE TABLE data_access_logs (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id   UUID REFERENCES members(id) ON DELETE SET NULL,
    accessed_by UUID NOT NULL,
    table_name  TEXT NOT NULL,
    action      TEXT NOT NULL,
    accessed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    ip_address  TEXT,
    purpose     TEXT NOT NULL
);

-- 6. Cross-Border Data Transfers (Transfer Limitation)
-- ON DELETE SET NULL: transfer record survives member deletion
CREATE TABLE data_transfers (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id           UUID REFERENCES members(id) ON DELETE SET NULL,
    data_scope          TEXT NOT NULL,
    destination_country TEXT NOT NULL,
    recipient_type      TEXT NOT NULL,
    safeguards          TEXT NOT NULL,
    transferred_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at          TIMESTAMPTZ,
    dpo_approved        UUID REFERENCES dpos(id),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- INDEXES: see indexing.sql
