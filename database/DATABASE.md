# Mirror v2 — Database Architecture

> Last updated: 2026-02-17
> Status: Schema designed, pre-development (no data yet)
> Source spec: `Member-Data-Bucket-Specification-v1.2.docx.pdf` (34 pages, Dec 2025)

---

## Overview

The database has two layers:

1. **Member Data** (14 buckets, ~52 tables + 1 MV) — structured profile data for research participants
2. **Operations** (10 tables) — projects, clients, matching, communications, auth

All tables live in a single PostgreSQL database on Supabase with `pgcrypto` and `pgvector` extensions.

---

## Architecture Diagram

```
auth.users (Supabase Auth)
    │
    ▼
user_profiles (role: admin | manager | client | member)
    │              │              │
    ▼              ▼              ▼
projects      clients.user_id  members.user_id
(manager_id)  (nullable)       (nullable)
    │
    ├── project_financials    (1:1)
    ├── project_cost_items    (1:N)
    ├── project_filters       (1:N)  ──→ queries across 14 member buckets
    ├── project_members       (N:M)  ──→ members
    └── project_communications(1:N)  ──→ members

members ──→ 14 data buckets (star topology, all FK to members.id)
```

---

## SQL File Map

| File | Contents |
|---|---|
| `schema.sql` | Extensions, `trigger_set_updated_at()`, `members` core table |
| `member_identity_household.sql` | Bucket 1: Identity (5 tables), Bucket 2: Household (2 tables) |
| `member_health_employment.sql` | Bucket 3: Health (6 tables), Bucket 4: Employment & Education (5 tables) |
| `member_financial_property.sql` | Bucket 5: Financial (4 tables), Bucket 6: Property (2 tables) |
| `member_behavioural(7-9).sql` | Bucket 7: Technology (4 tables), Bucket 8: Consumption & Services (2 tables), Bucket 9: Lifestyle (3 tables) |
| `member_vector.sql` | Bucket 10: Experiences (3 tables), Bucket 11: Beliefs (2 tables), Bucket 12: Intentions (3 tables) |
| `member_media_entertainment.sql` | Bucket 13: Media & Entertainment (2 tables) + indexes + triggers |
| `member_consent_data_rights.sql` | Bucket 14: Consent & Data Rights (6 tables) + indexes |
| `member_transcript.sql` | Interview responses (1 table) |
| `belief_summary.sql` | Materialized view: `member_belief_summary` |
| `indexing.sql` | All indexes for buckets 1-12 (member_id, searchable text, belief, vector HNSW) |
| `auto_update.sql` | `updated_at` triggers for all mutable tables |
| `get_member_profile.sql` | `get_member_profile(UUID)` function — assembles all tables into JSON |
| `client_manager_project.sql` | Operations: user_profiles, clients, projects, financials, filters, matching, comms, settings |

---

## Authentication & Roles

Auth is handled by Supabase Auth (`auth.users`). Every authenticated user gets a `user_profiles` row.

### Roles

| Role | Who | How they're created |
|---|---|---|
| `admin` | Internal staff, full access | Invited by existing admin via `supabase.auth.admin.inviteUserByEmail()` |
| `manager` | Internal staff, project-scoped | Invited by admin, auto-assigned to projects they create |
| `client` | External company (future) | Invited by admin, linked to `clients.user_id` |
| `member` | Research participant (future) | Signs up or is invited, linked to `members.user_id` |

### Access model

| Action | Admin | Manager | Client (future) | Member (future) |
|---|---|---|---|---|
| Create project | Yes, assign any manager | Yes, auto-assigned to self | No | No |
| See all projects | Yes | Only their own | Only their own | No |
| See financials | Yes, across pipeline | Only their projects | Only their projects | No |
| See member data | Yes (by sensitivity tier) | Yes (by sensitivity tier) | No | Own data only |
| Edit member profile | No (data is imported) | No | No | Own data only |

### RLS Pattern

```sql
-- Admin: full access
EXISTS (SELECT 1 FROM user_profiles WHERE id = auth.uid() AND role = 'admin' AND is_active)

-- Manager: project-scoped
manager_id = auth.uid() AND EXISTS (SELECT 1 FROM user_profiles WHERE id = auth.uid() AND role = 'manager' AND is_active)

-- Sensitivity tiers (on member data tables):
-- Standard:        role IN ('admin', 'manager')
-- Sensitive:       role IN ('admin')           -- or senior_manager if added
-- Highly sensitive: role = 'admin'              -- mental health, addiction
```

### Adding a new role

`role` is a TEXT column. To add a new role (e.g. `senior_manager`):

1. Insert a `user_profiles` row with the new role — no migration needed
2. Add the role to relevant RLS policies: `WHERE role IN ('admin', 'senior_manager')`
3. (Recommended) Add a CHECK constraint to prevent typos:

```sql
ALTER TABLE user_profiles
    DROP CONSTRAINT IF EXISTS user_profiles_role_check,
    ADD CONSTRAINT user_profiles_role_check
        CHECK (role IN ('admin', 'senior_manager', 'manager', 'coordinator', 'client', 'member'));
```

### Future portal access

Both `clients` and `members` have a nullable `user_id` column. When they need login access:

1. Invite them via Supabase Auth
2. Create a `user_profiles` row with the appropriate role
3. Set `clients.user_id` or `members.user_id` to the auth user ID
4. RLS policies already handle it — zero schema migration

---

## The 14 Member Data Buckets

### Table Convention

Every member table follows the same pattern:

```sql
id          UUID PRIMARY KEY DEFAULT gen_random_uuid()
member_id   UUID NOT NULL [UNIQUE] REFERENCES members(id) ON DELETE CASCADE
-- UNIQUE for 1:1 tables, omitted for 1:N tables
[domain columns]
raw_source  JSONB           -- original import data for debugging/reconciliation
created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()  -- omitted on append-only tables
```

### Bucket 1: Identity (5 tables)

| Table | Relationship | Purpose |
|---|---|---|
| `member_identity` | 1:1 | Demographics: DOB, gender, ethnicity, nationality, religion, location |
| `member_identity_languages` | 1:N | Languages spoken with proficiency |
| `member_sensory_profile` | 1:1 | Smell, taste, colour vision, hearing, touch sensitivity |
| `member_physical_profile` | 1:1 | Height, weight, handedness |
| `member_neuro_profile` | 1:1 | Neurodivergence conditions (separate table for RLS isolation) |

### Bucket 2: Household (2 tables)

| Table | Relationship | Purpose |
|---|---|---|
| `member_household` | 1:1 | Marital status, housing, pets |
| `member_household_dependents` | 1:N | Children, dependents with age/gender/needs |

### Bucket 3: Health (6 tables) — SENSITIVE

| Table | Relationship | RLS | Purpose |
|---|---|---|---|
| `member_health` | 1:1 | senior_manager+ | General health, disabilities, assistive tech |
| `member_health_conditions` | 1:N | senior_manager+ | Medical conditions with status |
| `member_health_mental` | 1:1 | admin_only | Mental health history and status |
| `member_health_addiction` | 1:1 | admin_only | Addiction and recovery |
| `member_health_medical_participation` | 1:1 | senior_manager+ | Clinical trials, medications |
| `member_health_allergies` | 1:N | senior_manager+ | Allergens with severity |

### Bucket 4: Employment & Education (5 tables)

| Table | Relationship | Purpose |
|---|---|---|
| `member_employment` | 1:1 | Employment status, type, work hours |
| `member_education` | 1:1 | Highest education, field of study, currently studying |
| `member_employment_entries` | 1:N | Individual jobs: title, company, industry, seniority, company_annual_revenue |
| `member_employment_skills` | 1:N | Skills with proficiency and type |
| `member_employment_qualifications` | 1:N | Degrees, certificates, licences |

**Design decision:** Education was separated from employment (2026-02-17). A person's education exists independently of whether they're employed. `member_employment` is purely work status, `member_education` is purely learning.

### Bucket 5: Financial (4 tables) — SENSITIVE

| Table | Relationship | Purpose |
|---|---|---|
| `member_financial` | 1:1 | Income, net worth, assets |
| `member_financial_banking` | 1:N | Financial institutions (banks, brokerages, robo-advisors, crypto exchanges) |
| `member_financial_cards` | 1:N (FK to banking) | Credit/debit cards linked to banking relationships |
| `member_financial_investments` | 1:N | Investment types and platforms |

**Note:** `member_financial_banking` covers all financial institutions, not just banks. A Syfe or Tiger Brokers account goes here with `institution_type = 'Robo-advisor'` or `'Brokerage'`.

### Bucket 6: Property (2 tables)

| Table | Relationship | Purpose |
|---|---|---|
| `member_property` | 1:1 | Primary residence, additional properties, significant assets |
| `member_property_vehicles` | 1:N | Vehicles with make/model/fuel/payment |

### Bucket 7: Technology (4 tables)

| Table | Relationship | Purpose |
|---|---|---|
| `member_technology_behaviour` | 1:1 | Screen time, digital comfort, privacy concern |
| `member_technology_devices` | 1:N | Devices: type, brand, model, OS |
| `member_technology_platforms` | 1:N | Platform usage: name, category, frequency, paid subscriber |
| `member_technology_non_use` | 1:N | Deliberately avoided platforms with reason ("Absence is data") |

**Convention:** Job search platforms (SEEK, LinkedIn for job hunting, Indeed) go here with `platform_category = 'job_search'`.

### Bucket 8: Consumption & Services (2 tables)

| Table | Relationship | Purpose |
|---|---|---|
| `member_consumption` | 1:1 | Shopping preferences |
| `member_consumption_entries` | 1:N | Products AND services: brand, category, subscription, cost, frequency |

**Design decision:** Renamed from `member_consumption_products` (2026-02-17). Table now covers both products (coffee, Nike) and services (Singtel mobile, gym membership). Use `has_subscription` and `usage_type` to distinguish.

**Convention for overlapping data:**
- Singtel mobile plan → `member_consumption_entries` (the spend dimension)
- Singtel CAST viewing habits → `member_media_habits` (the content dimension)
- Netflix billing → `member_consumption_entries`
- Netflix content preferences → `member_media_subscriptions`

### Bucket 9: Lifestyle (3 tables)

| Table | Relationship | Purpose |
|---|---|---|
| `member_lifestyle` | 1:1 | Diet, alcohol, exercise, sleep, chronotype, community |
| `member_lifestyle_activities` | 1:N | Hobbies and activities with frequency/intensity |
| `member_lifestyle_travel` | 1:N | Travel history by country |

### Bucket 10: Experiences (3 tables) — VECTOR-ENABLED

| Table | Relationship | Purpose |
|---|---|---|
| `member_experiences` | 1:1 | Previous research participation |
| `member_experiences_life_events` | 1:N | Life events with `description_embedding VECTOR(1536)` |
| `member_experiences_narratives` | 1:N | Extended narratives with `embedding VECTOR(1536)` |

### Bucket 11: Beliefs (2 tables + 1 MV) — VECTOR-ENABLED

| Table | Relationship | Purpose |
|---|---|---|
| `belief_expressions` | 1:N | Raw belief text + `embedding VECTOR(1536)` + domain + source_type |
| `belief_emergent_themes` | 1:N (FK to expressions) | AI-discovered themes with confidence scores |
| `member_belief_summary` | MV | Aggregated view: expression count, top themes per domain |

**Key concept:** Domains are conversation territories (money, work, family, health), not categories. Beliefs can contradict each other — that's by design.

### Bucket 12: Intentions (3 tables) — VECTOR-ENABLED

| Table | Relationship | Purpose |
|---|---|---|
| `member_intentions` | 1:1 | Pain points + life intentions, each with its own VECTOR(1536) column (6 vectors total) |
| `member_intentions_goals` | 1:N | Goals with `goal_embedding VECTOR(1536)` |
| `member_intentions_purchases` | 1:N | Purchase intentions with `purchase_embedding VECTOR(1536)` |

### Bucket 13: Media & Entertainment (2 tables)

| Table | Relationship | Purpose |
|---|---|---|
| `member_media_subscriptions` | 1:N | Streaming services: plan tier, shared account, hours/week, favorite genres |
| `member_media_habits` | 1:N | Specific content: titles, genres, frequency, platform |

### Bucket 14: Consent & Data Rights (6 tables) — APPEND-ONLY

| Table | Relationship | Purpose |
|---|---|---|
| `dpos` | standalone | Data Protection Officer registry |
| `member_consents` | 1:N | Consent records with jurisdiction, legal basis, version |
| `member_data_requests` | 1:N | Access/correction/portability requests |
| `member_data_retention` | 1:N | Retention policies with deadlines |
| `data_access_logs` | 1:N | Who accessed what, when, why (ON DELETE SET NULL) |
| `data_transfers` | 1:N | Cross-border transfers with safeguards (ON DELETE SET NULL) |

**All tables in this bucket are immutable.** No `updated_at` columns. No update triggers. Compliance records are audit trails.

### Other

| Table | Purpose |
|---|---|
| `member_interview_responses` | Raw interview Q&A with session_id and sequence |

---

## Operations Tables

| Table | Purpose |
|---|---|
| `user_profiles` | Every authenticated user (admin, manager, client, member). FK to `auth.users` |
| `clients` | Companies commissioning research. Nullable `user_id` for future portal access |
| `projects` | Research projects with session config, targets, lifecycle stage |
| `project_financials` | 1:1 with project. Currency, incentives, costs, tax, payment status |
| `project_cost_items` | Line items: recruitment, incentive, venue, transcription, etc. |
| `project_filters` | Filter criteria per project: bucket + field + operator + value |
| `project_members` | Junction table: which members matched to which projects, with status |
| `project_communications` | Messages to/from members per project |
| `global_settings` | Key-value config (qualification rate, attendance rate, screening cost) |

### Project lifecycle

```
draft → pending_approval → approved → recruiting → in_field → completed
                                                            → cancelled
```

Payment lifecycle (independent, on `project_financials`):
```
unpaid → invoiced → partially_paid → paid
```

### Matching flow

```
1. Admin/Manager defines project_filters (bucket + field + operator + value)
2. Query engine scans member data buckets
3. Matching members inserted into project_members (status: 'potential')
4. Manager reviews → status: 'qualified'
5. System sends invite via project_communications
6. Member responds → status: 'confirmed' / 'declined'
7. Session completes → status: 'completed' / 'no_show'
```

---

## Indexing Strategy

### Member ID indexes (every 1:N table)
Every table that references `members(id)` as a non-unique FK has a `member_id` index. This prevents full table scans when loading a member profile.

### Searchable text indexes
Normalized with `LOWER(TRIM())` on commonly filtered fields: skills, job titles, company names, industries, qualifications, brands, platforms, activities, allergens, etc.

### Vector indexes (HNSW)
Three HNSW indexes for approximate nearest-neighbor search:
- `belief_expressions.embedding`
- `member_experiences_life_events.description_embedding`
- `member_experiences_narratives.embedding`

`member_intentions` has 6 vector columns but no HNSW indexes yet — index when search patterns emerge. Premature HNSW indexes waste memory.

### Consent/compliance indexes
GIN index on `member_consents.purposes` for array containment queries. Partial indexes on `status = 'granted'` and `status = 'pending'` for common compliance queries.

---

## Design Decisions Log

| Date | Decision | Rationale |
|---|---|---|
| 2025-12-06 | Spec finalized with 12 buckets | Stress-tested against 10 edge-case personas |
| 2026-02-10 | CTO session: tech stack, schema design | Supabase + pgvector, star topology, 4-tier sensitivity |
| 2026-02-16 | 12 → 14 buckets | Added Media & Entertainment (Bucket 13), Consent & Data Rights (Bucket 14). Expanded Household (+pets), Financial (+insurance). Deprecated JSONB behavioral approach — Buckets 7-9 use typed tables |
| 2026-02-17 | Education split from Employment | `member_education` created as 1:1 table. Education exists independently of employment status |
| 2026-02-17 | Consumption renamed to "Consumption & Services" | `member_consumption_products` → `member_consumption_entries`. Now covers both products (coffee) and services (Singtel mobile) |
| 2026-02-17 | `company_annual_revenue` added to `member_employment_entries` | Company revenue data needed for B2B research targeting |
| 2026-02-17 | `managers` table → `user_profiles` table | Futureproof auth: single table for admin, manager, client (future), member (future). All FK to `auth.users` |
| 2026-02-17 | `clients.user_id` + `members.user_id` added (nullable) | Preparation for client portal and member self-service. No migration needed when activated |

---

## Table Count Summary

| Layer | Count |
|---|---|
| Core | 1 (members) |
| Bucket 1-14 member tables | 51 |
| Materialized views | 1 (member_belief_summary) |
| Interview responses | 1 |
| Operations tables | 10 |
| **Total** | **64 tables + 1 MV** |

---

## What's NOT Built Yet

- [ ] RLS policies (designed, not written)
- [ ] CHECK constraints on role/status enums
- [ ] Database triggers for project auto-assignment
- [ ] Matching/filter query engine
- [ ] Vector embedding generation pipeline
- [ ] Data migration from PanelFox
- [ ] Seed data for `global_settings`
- [ ] Seed data for `dpos` (DPO registry)
