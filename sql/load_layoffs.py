"""Load layoffs_global_12mo.csv into a local SQLite database (sql/layoffs.db).

Blank num_laid_off / pct_workforce values are kept as NULL, not zero: a blank means
"not reported", and treating it as 0 would silently understate layoff sizes.
"""

import csv
import sqlite3
from datetime import datetime
from pathlib import Path

HERE = Path(__file__).resolve().parent
CSV_PATH = HERE.parent / "layoffs_global_12mo.csv"
DB_PATH = HERE / "layoffs.db"

# Same company spelled two ways in the source. SQL treats them as different companies;
# Power BI (case-insensitive) caught it on 2026-09-28. See docs/decisions/0008.
NAME_FIXES = {
    "Tiktok": "TikTok",
    "theGist": "The Gist",
}


def to_int(value):
    value = value.strip().replace(",", "")
    return int(value) if value else None


def to_fraction(value):
    value = value.strip().rstrip("%")
    return float(value) / 100 if value else None


def to_iso(value):
    return datetime.strptime(value.strip(), "%m/%d/%Y").date().isoformat()


def main():
    with open(CSV_PATH, encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    DB_PATH.unlink(missing_ok=True)
    con = sqlite3.connect(DB_PATH)
    con.execute(
        """
        CREATE TABLE layoffs (
            id            INTEGER PRIMARY KEY,
            company       TEXT NOT NULL,
            location_hq   TEXT NOT NULL,
            country       TEXT NOT NULL,
            industry      TEXT NOT NULL,
            layoff_date   TEXT NOT NULL,   -- ISO YYYY-MM-DD
            num_laid_off  INTEGER,         -- NULL = not reported
            pct_workforce REAL             -- 0.10 = 10%; NULL = not reported
        )
        """
    )
    con.executemany(
        "INSERT INTO layoffs (company, location_hq, country, industry, layoff_date, num_laid_off, pct_workforce) "
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
            (
                NAME_FIXES.get(r["company"].strip(), r["company"].strip()),
                r["location_hq"].strip(),
                r["country"].strip(),
                r["industry"].strip(),
                to_iso(r["date"]),
                to_int(r["num_laid_off"]),
                to_fraction(r["pct_workforce"]),
            )
            for r in rows
        ],
    )
    con.commit()

    total, no_count, no_pct = con.execute(
        "SELECT COUNT(*), SUM(num_laid_off IS NULL), SUM(pct_workforce IS NULL) FROM layoffs"
    ).fetchone()
    first, last = con.execute("SELECT MIN(layoff_date), MAX(layoff_date) FROM layoffs").fetchone()
    con.close()

    print(f"Loaded {total} rows into {DB_PATH.name} ({first} to {last})")
    print(f"num_laid_off not reported: {no_count}  |  pct_workforce not reported: {no_pct}")


if __name__ == "__main__":
    main()
