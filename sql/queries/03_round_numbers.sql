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
)
SELECT company,
       layoff_date,
       gap_days,
       new_round,
       SUM(new_round) OVER (PARTITION BY company ORDER BY layoff_date) AS round_num
FROM flagged
ORDER BY company, layoff_date;