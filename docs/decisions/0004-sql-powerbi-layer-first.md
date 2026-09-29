# 0004 — Build the SQL + Power BI layer now, before the retention-scoring model

**Status:** proposed

## The claim
Shipping a SQL + Power BI analysis of the layoffs dataset first (who is cutting, how deep, is it
accelerating) is worth doing before the retention-scoring model, because it closes her two weakest
evidenced skills (SQL, Power BI) in time for a referred Citi application (req 26981632, closes
2026-09-30) that names SQL and a BI tool.

## Reasoning
- Dataset 1 is already collected and verified row by row (442 rows, 2025-09-01 to 2026-09-20), so no
  collection time is needed.
- The scoring model is a separate, coaching-only deliverable that hasn't started; this layer doesn't
  replace it, it becomes phase 1 of the same project.
- Power BI over Tableau (Citi names Tableau): her resume already lists Power BI with no artifact,
  and she has started a Power BI course. Tableau is not claimed anywhere.
- SQLite as the database: zero setup. Power BI reads exported query results (CSV), not SQLite directly.

## Adversarial audit
- **Missing data is large.** 150 of 442 rows (34%) have no reported headcount and 204 (46%) have no
  reported % of workforce. Any "total people laid off" figure is a floor, not a total, and must be
  labelled that way on the dashboard. Blanks are loaded as NULL, never 0.
- **Small n.** 442 events is enough to show SQL technique, not enough for strong statistical claims
  about sub-segments (e.g. one country with 3 events). Findings on thin slices need a count shown.
- **Source bias.** layoffs.fyi skews toward tech and toward companies that make news. It is not a
  census of all layoffs. The question is "what does this tracker show", not "what happened in the economy".
- **Rushing for a deadline** could produce a thin project. Mitigation: the resume bullet is only
  written if she can explain each query herself; otherwise the Citi application goes out without it.

## Verdict
Open question until the queries exist. Revisit once she has written them.
