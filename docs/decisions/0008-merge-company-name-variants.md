# 0008 — Merge two company-name spelling variants

**Status:** survives audit

## The claim
"Tiktok" and "TikTok" are one company, and "theGist" and "The Gist" are one company. The loader
(`sql/load_layoffs.py`, `NAME_FIXES`) maps each variant to one spelling. The raw CSV is left untouched.

## Reasoning
Power BI refused a one-to-many relationship on `company_lookup[company]` because it found "TikTok"
twice. Power BI compares text case-insensitively; SQLite's `GROUP BY` is case-sensitive, so the SQL
had treated "Tiktok" and "TikTok" as two companies. A scan of all names (ignoring case and
punctuation, plus a similarity check) found one more pair: "theGist" / "The Gist", both Tel Aviv,
both 2025-09-03, both a 100% shutdown, i.e. the same event entered twice. The only other close pair,
"N-able Technologies" / "Noa Technologies", is two different companies and is left alone.

It is not known whether the variant spellings came from layoffs.fyi or from the transcription of the
browser-print PDF.

## Adversarial audit
- **Effect on results.** Companies 375 to 373. Headline 17/165 (10.3%) becomes 17/164 (10.4%);
  3-month 11/276 (4.0%); 9-month 22/90 (24.4%); "Other" industry 20 to 19 eligible. TikTok becomes
  one company with 3 events and 2 rounds (cut again within 6 months), but its first round
  (2026-07-01) is after the eligibility cut-off, so it doesn't enter the headline.
- **The Gist duplicate row** stays as two events; the 14-day rule already merges them into one round,
  so it cannot inflate the repeat count. Event totals (442) include it.
- **Residual risk.** Other variants that differ by more than case/punctuation (e.g. a rebrand) would
  not be caught by this scan.

## Verdict
**Survives.** Fixed in the loader, database rebuilt, all exports regenerated.
