WITH gaps AS (
    SELECT company,
           industry,
           country,
           num_laid_off,
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
company_summary AS (
    SELECT company,
           MIN(industry)                                     AS industry,
           GROUP_CONCAT(DISTINCT country)                    AS countries,
           COUNT(*)                                          AS num_events,
           MAX(round_num)                                    AS num_rounds,
           MIN(layoff_date)                                  AS first_round,
           MIN(CASE WHEN round_num = 2 THEN layoff_date END) AS second_round,
           MAX(CASE WHEN new_round = 1 THEN layoff_date END) AS latest_round,
           SUM(num_laid_off)                                 AS reported_laid_off
    FROM rounds
    GROUP BY company
)
SELECT company,
       industry,
       countries,
       num_rounds,
       num_events,
       first_round,
       latest_round,
       CAST(julianday(second_round) - julianday(first_round) AS INTEGER) AS days_to_second_round,
       CASE WHEN num_rounds > 1
            THEN CAST((julianday(latest_round) - julianday(first_round)) / (num_rounds - 1) AS INTEGER)
       END AS avg_days_between_rounds,
       CASE WHEN julianday(second_round) - julianday(first_round) <= 180 THEN 'Yes'
            WHEN first_round > '2026-03-24'                              THEN 'Too recent to tell'
            ELSE 'No'
       END AS cut_again_within_6m,
       reported_laid_off
FROM company_summary
ORDER BY num_rounds DESC, company;