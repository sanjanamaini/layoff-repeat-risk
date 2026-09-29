WITH gaps AS (
    SELECT company,
           industry,
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
           MIN(industry)                                     AS industry,
           MIN(layoff_date)                                  AS first_round,
           MIN(CASE WHEN round_num = 2 THEN layoff_date END) AS second_round
    FROM rounds
    GROUP BY company
),
eligible AS (
    SELECT industry,
           CASE WHEN julianday(second_round) - julianday(first_round) <= 180
                THEN 1 ELSE 0 END AS cut_again
    FROM company_rounds
    WHERE first_round <= '2026-03-24'
),
by_industry AS (
    SELECT industry,
           COUNT(*)       AS eligible_companies,
           SUM(cut_again) AS cut_again_within_6m
    FROM eligible
    GROUP BY industry
    UNION ALL
    SELECT 'ALL INDUSTRIES', COUNT(*), SUM(cut_again)
    FROM eligible
)
SELECT industry,
       eligible_companies,
       cut_again_within_6m,
       ROUND(100.0 * cut_again_within_6m / eligible_companies, 1) AS pct_cut_again,
       CASE WHEN eligible_companies < 10 THEN 'Too few companies to compare' END AS sample_note
FROM by_industry
ORDER BY industry = 'ALL INDUSTRIES' DESC, eligible_companies DESC, industry;