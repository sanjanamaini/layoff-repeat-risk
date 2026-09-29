# Steelman log

Every non-trivial judgment call in this project gets its own decision doc (`NNNN-slug.md`,
see `TEMPLATE.md`), adversarially audited by Claude rather than rubber-stamped. This file is
the index and running summary. New entries go on top.

| # | Decision | Verdict | Notes |
|---|----------|---------|-------|
| [0003](0003-ibm-hr-analytics-as-dataset-2.md) | IBM HR Analytics as Dataset 2 | Survives, conditional | Must lead with the real layoffs evidence in any writeup, not the IBM dataset; model must visibly not just be attrition prediction under a new name |
| [0002](0002-print-transcription-over-self-collection.md) | Print-transcription instead of self-collection/scraping | Survives, with caveat | Defensible but not certain permission — attribute prominently, describe collection method honestly, revisit if this ever goes beyond a portfolio piece |
| [0001](0001-global-scope-over-india-only.md) | Global scope instead of India-only | Revised | Keep India as a filtered secondary lens (free, same data) to recover the narrative hook global scope gave up |

## Open items carried across decisions
- The "no one's combined a layoffs dataset with a retention-priority-scoring model" claim
  (0001) is a working assumption from a quick search, not a verified fact — don't overstate it
  in the final writeup.
- Data collection method (0002) should be described accurately, not glossed as a clean export.
- The scoring model (not yet built) needs to actually be criteria-transparent and evidence-
  grounded in practice, or decision 0003's justification fails retroactively.
