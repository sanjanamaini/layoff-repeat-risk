# 0007 — Headline measure: second round within 6 months of the first

**Status:** survives audit

## The claim
The headline repeat rate is the share of companies that had a second layoff round **within 180 days
of their first round**, counting only companies whose first round was at least 180 days before the
data ends (first round on or before 2026-03-24; data ends 2026-09-20).

## Reasoning
Sanjana chose 6 months of follow-up because it "gives enough time for a second round". A fixed
window gives every company the same amount of time to show a second round, which makes the
comparison fair.

## Adversarial audit
- **6 months misses some second rounds.** Of the 39 companies with a second round (14-day rule),
  14 came within 3 months, 25 within 6 months, 35 within 9 months. So the claim holds for most, not
  all. The finding must be phrased "within 6 months", never "ever".
- **Fixed window vs "any time before the data ends".** Among the 165 eligible companies:
  - A. second round within 6 months: 17 (10.3%)
  - B. second round any time before 2026-09-20: 31 (18.8%)
  B gives early companies up to 12 months to repeat and later ones only 6, which is censoring in a
  subtler form. A is the fair measure and is the headline. Claude's earlier "roughly 1 in 5" figure
  was measure B and is withdrawn.
- **Sensitivity to the round rule (decision 0006):** 14 days: 10.3%, 30 days: 10.3%, 90 days: 6.7%.
  The 14-day choice does not drive the result; 90 days lowers it because it merges real second rounds
  into the first.
- **Small numerator.** 17 companies. Report the count next to the percentage and avoid splitting it
  by industry or country.
- **These figures are Claude's audit checks.** The published numbers must come from her own query.

## Verdict
**Survives.** Headline = measure A. Dashboard also shows the cumulative share with a second round by
3, 6 and 9 months, each computed only over companies observed long enough for that horizon.
