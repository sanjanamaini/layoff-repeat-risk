# 0001 — Global layoffs scope instead of India-only

**Status:** revised (see verdict)

## The claim
Switching Dataset 1 from India-only to global doesn't cost meaningful originality, because
the project's real differentiator is the retention-scoring model layer, not the raw data
source — and no existing public project combines a layoffs dataset with a retention-priority
scoring model.

## Reasoning
India-only was originally chosen (2026-09-14) specifically to keep manual data-collection
volume low under a tight deadline. When that deadline stopped being the binding constraint
(2026-09-20 feasibility concern → "fuck the deadline" 2026-09-21), the reason for staying
India-only mostly evaporated. A search found no existing project pairing a layoffs dataset
with a retention-priority-scoring model, supporting the idea that the differentiator lives
in the model, not the data scope.

## Adversarial audit
Three things this reasoning glossed over:

1. **The "no one's done this" check wasn't rigorous.** It was two targeted web searches, not
   a systematic literature/portfolio review. Absence of evidence in a quick search is weak
   evidence of absence. Treat "no one's combined these" as a working assumption, not a
   verified fact, in any writeup.
2. **Global loses a real narrative hook.** "An India-based analyst studying India's own job
   market during the exact wave she's job-hunting in" is a compelling, authentic reason to
   have built this. "Global layoffs, no particular connection to the builder" is generic by
   comparison. This is a real cost the original reasoning didn't weigh, separate from the
   "originality" argument.
3. **The original tradeoff assumption turned out false.** India-only was chosen to avoid a
   slow self-collection process. In practice, the global 12-month dataset was fully collected
   and verified in one session (442 rows, via print-transcription of layoffs.fyi). The India
   subset of that same table would have taken the same effort — meaning the feasibility
   argument for going global was moot once the transcription method was found. The real
   choice was never "fast global vs. slow India," it was "which is the better story," and
   that question was never actually asked outright.

## Verdict
**Revised, not overturned.** Global scope stays as the primary dataset (the retention-scoring
differentiator argument holds), but the India narrative doesn't have to be abandoned — it's
free to keep, since it's the same data. Filter `layoffs_global_12mo.csv` by `country == India`
as a secondary lens/section in the analysis ("how does India's pattern compare to the global
wave") rather than dropping the India angle entirely. Costs nothing extra; recovers the
authenticity hook the original decision gave up.
