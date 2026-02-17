-- ============================================================
-- MATERIALIZED VIEW: Belief Summary (per member per domain)
-- ============================================================

CREATE MATERIALIZED VIEW member_belief_summary AS
SELECT
    be.member_id,
    be.domain,
    COUNT(*)::INTEGER AS expression_count,
    MAX(be.captured_at) AS last_captured,
    ARRAY(
        SELECT bet.theme
        FROM belief_emergent_themes bet
        WHERE bet.member_id = be.member_id
          AND bet.expression_id IN (
              SELECT sub.id FROM belief_expressions sub
              WHERE sub.member_id = be.member_id
                AND sub.domain = be.domain
                AND sub.status = 'active'
          )
        GROUP BY bet.theme
        ORDER BY AVG(bet.confidence) DESC
        LIMIT 5
    ) AS top_themes
FROM belief_expressions be
WHERE be.status = 'active'
GROUP BY be.member_id, be.domain;

CREATE UNIQUE INDEX idx_belief_summary_pk
    ON member_belief_summary(member_id, domain);