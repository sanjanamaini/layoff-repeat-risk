WITH gaps AS (
    SELECT company,
           layoff_date,
           julianday(layoff_date)
             - julianday(LAG(layoff_date) OVER (PARTITION BY company ORDER BY layoff_date)) AS gap_days
    FROM layoffs
),
flagged AS (
    SELECT *,
           CASE WHEN gap_days IS NULL OR gap_days > 14 THEN 1 ELSE 0 END AS new_round
    FROM gaps
),
rounds AS (
    SELECT *,
           SUM(new_round) OVER (PARTITION BY company ORDER BY layoff_date) AS round_num
    FROM flagged
),
company_rounds AS (
    SELECT company,
           MIN(layoff_date)                                  AS first_round,
           MIN(CASE WHEN round_num = 2 THEN layoff_date END) AS second_round
    FROM rounds
    GROUP BY company
),
horizons (months, days) AS (
    VALUES (3, 90), (6, 180), (9, 270)
)
SELECT h.months                                        AS months_after_first_round,
       date('2026-09-20', '-' || h.days || ' days')    AS first_round_on_or_before,
       COUNT(*)                                        AS eligible_companies,
       SUM(CASE WHEN julianday(c.second_round) - julianday(c.first_round) <= h.days
                THEN 1 ELSE 0 END)                     AS cut_again,
       ROUND(100.0 * SUM(CASE WHEN julianday(c.second_round) - julianday(c.first_round) <= h.days
                              THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_cut_again
FROM horizons h
JOIN company_rounds c
  ON c.first_round <= date('2026-09-20', '-' || h.days || ' days')
GROUP BY h.months, h.days
ORDER BY h.months;