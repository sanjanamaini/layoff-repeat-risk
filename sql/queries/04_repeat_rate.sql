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
    SELECT company,
           layoff_date,
           SUM(new_round) OVER (PARTITION BY company ORDER BY layoff_date) AS round_num
    FROM flagged
),
company_rounds AS (
    SELECT company,
           MIN(layoff_date)                                  AS first_round,
           MIN(CASE WHEN round_num = 2 THEN layoff_date END) AS second_round
    FROM rounds
    GROUP BY company
)
SELECT COUNT(*) AS eligible_companies,
       SUM(CASE WHEN julianday(second_round) - julianday(first_round) <= 180
                THEN 1 ELSE 0 END) AS cut_again_within_6mo,
       ROUND(100.0 * SUM(CASE WHEN julianday(second_round) - julianday(first_round) <= 180
                              THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_cut_again
FROM company_rounds
WHERE first_round <= '2026-03-24';   -- data ends 2026-09-20; 180 days earlier