SELECT
    company,
    layoff_date,
    LAG(layoff_date) OVER (PARTITION BY company ORDER BY layoff_date) AS prev_date,
    julianday(layoff_date)
      - julianday(LAG(layoff_date) OVER (PARTITION BY company ORDER BY layoff_date)) AS gap_days
FROM layoffs
ORDER BY company, layoff_date;