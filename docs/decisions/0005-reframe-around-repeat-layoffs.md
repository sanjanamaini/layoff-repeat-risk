# 0005 — Reframe the analysis around repeat layoffs

**Status:** proposed

## The claim
The SQL + Power BI layer should center on one question: "After a company's first layoff, how likely
is a second round, and how soon does it come?" A descriptive dashboard of who laid off how many is
not useful to anyone making a decision.

## Reasoning
Sanjana challenged the original plan on 2026-09-28: companies already know why they are laying
people off, so a "who cut how much" dashboard tells them nothing. Agreed. The useful audience is
the people affected by the decision, not the company making it:
- Employees at a company that just cut, deciding whether to stay.
- Job seekers deciding whether to join a company that recently cut.
- Lenders (e.g. Citi), for whom repeat cuts can be an early warning of distress.
Companies never publish "we will probably cut again", so the repeat rate is new information.

Feasibility check (rough counts by Claude, to be rebuilt properly in her own SQL): 375 companies,
41 with more than one event. Of 142 companies whose first cut was before 2026-03-01, 31 cut again.

## Adversarial audit
- **Censoring.** A company that first cut in August 2026 has had almost no time to cut again.
  Including it understates the repeat rate. Needs a follow-up window cutoff, and the cutoff choice
  should be stated and justified, not hidden.
- **Left censoring (raised 2026-09-28 from her question "what does NULL mean?").** Data starts
  2025-09-01, so a company's "first" event in the data may not be its first layoff ever (e.g. Meta
  and Amazon cut heavily in 2022-23). Phrase findings as "X% of companies that had a layoff went on to
  have another", never "X% of first-time layoffs are followed by another".
- **Why only 12 months (her reasoning, stated 2026-09-28).** The window is deliberate: she chose the
  last 12 months because of the global conflicts of the past year and her view that layoffs have
  risen over that period, so the study is about company behaviour in this specific period. That makes
  left censoring less of a flaw: "first layoff in the window" means "first layoff in this period",
  which is the question being asked. Audit: the claim that layoffs *increased* cannot be shown from
  this dataset, since it contains no earlier year to compare with. It needs an outside source
  (e.g. layoffs.fyi's own yearly totals) before it goes in the README or an interview answer.
- **Small n.** About 31 repeat companies. A single headline rate is defensible; per-industry or
  per-country repeat rates will mostly be too thin to claim.
- **No outcome data.** Nothing here shows whether repeat-cutters later failed. The claim is
  "repeat cuts are common", never "repeat cuts predict failure".
- **Source bias.** layoffs.fyi skews toward tech and toward companies that make news. The finding is
  about companies this tracker covers, not all companies.
- **Duplicate or same-announcement events.** Two rows for the same company a few days apart may be
  one announcement reported twice rather than two rounds. Check gaps between events before counting.

## Verdict
Open question until her queries exist. Revisit the cutoff choice and the duplicate check then.
