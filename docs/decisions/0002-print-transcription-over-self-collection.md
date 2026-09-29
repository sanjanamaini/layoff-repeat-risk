# 0002 — Transcribed layoffs.fyi's own print output instead of self-collecting or scraping

**Status:** survives audit, with a caveat carried forward

## The claim
Reading Sanjana's own browser-generated print-to-PDF of the layoffs.fyi table and transcribing
it into a CSV is a legitimate data-collection method — not equivalent to scraping — because it
uses an action the site itself permitted (print), rather than circumventing a restriction the
site owner put in place.

## Reasoning
layoffs.fyi's Airtable-backed table had both bulk CSV download and copy-to-clipboard explicitly
disabled by the base owner. Automated scraping was already rejected earlier in this project for
ToS reasons. Print-to-PDF was not blocked, and Sanjana generated the PDF herself through normal
browser use, not through any workaround. Claude then read the already-generated images and
transcribed the visible table data, which was independently re-checked row by row against the
CSV with zero discrepancies found.

## Adversarial audit
This reasoning is defensible but not iron-clad, and the earlier answer overstated the
certainty:

1. **"Not blocked" isn't the same as "intended to be permitted."** The owner may simply not
   have thought to block browser printing, rather than having implicitly approved it as an
   extraction channel. Two explicit blocks (download, copy) is a clear signal of intent to
   restrict bulk use; the absence of a third block doesn't cancel that signal.
2. **Volume matters.** Transcribing a couple of rows off a screenshot is unambiguously fine.
   Transcribing 442 rows via a 248-page print is bulk extraction in substance, even if the
   mechanism (print) wasn't technically blocked. A skeptical reader could reasonably call this
   "scraping via a different technical door," not something categorically different from
   scraping.
3. **Attribution isn't the same as permission.** "Free to use with attribution" (layoffs.fyi's
   stated terms) most plausibly describes citing their published data, not necessarily bulk
   reconstruction of their full underlying table via a workaround. This is a real interpretive
   gap, not a settled point.

## Verdict
**Survives as the pragmatic choice given the alternatives** (scraping was already rejected as
worse; the Kaggle/GitHub mirrors were too stale to use), but the writeup and README must:
- Attribute layoffs.fyi clearly and prominently, not as a footnote.
- Describe the collection method honestly ("transcribed from the site's own table via a
  printed export") rather than implying a clean official export existed.
- Note as an open item: if this project is ever made more public-facing than a portfolio piece
  (e.g. published, shared with the layoffs.fyi team, or scaled up), reach out to layoffs.fyi
  directly for explicit permission rather than relying on this interpretation indefinitely.
