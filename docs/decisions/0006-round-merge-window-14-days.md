# 0006 — Events from the same company within 14 days count as one layoff round

**Status:** survives audit (revised from 90 days)

## The claim
A layoff "round" is one decision to cut. Tracker rows (events) from the same company that fall
within 14 days of the previous event belong to the same round. The headline repeat rate is
reported at 14 days, with a sensitivity check at 30 and 90 days.

## Reasoning
The tracker sometimes records one global layoff once per country. PayPal is the clearest case:
four rows in six days (Ireland 2026-08-31, India 09-02, United States 09-03, Israel 09-06), which is
one round, not four. Counting events as rounds would overstate repeat layoffs.

Sanjana's first proposal was 90 days, reasoning that global rollouts and notice periods take time.

## Adversarial audit
- **Notice periods don't create rows.** layoffs.fyi dates are announcement/report dates, not
  employees' exit dates, so notice periods don't split one layoff into several rows. The rollout
  argument stands; the notice-period argument doesn't apply to this data.
- **90 days chains separate rounds together.** Gaps are measured between consecutive events, so
  events every 6 weeks chain into one "round". Amazon (Oct 27, Dec 15, Jan 28, Mar 4, ...) collapsed
  to 2 rounds, Meta's 5 events to 1. That hides the serial cutting the project is meant to measure.
- **The data shows a natural break near 7 days.** Of 67 gaps between consecutive events, 12 are
  0 to 7 days, only 3 are 8 to 30 days, then 15 are 31 to 60 days. 14 days sits past that break
  with margin for slower multi-country rollouts.
- **Companies with 2+ rounds by window (before any censoring cutoff):** 7 days: 39, 30 days: 38,
  90 days: 28. The headline must be shown alongside the 30 and 90 day versions so a reader can see
  how much the choice matters.
- **Residual risk:** a genuine second round inside 14 days would be merged. Judged rare; no case
  seen in the data.

## Verdict
**Revised:** 90 days changed to 14 days, with a sensitivity check at 30 and 90 days. Decided by
Sanjana on 2026-09-28 after the audit above.
