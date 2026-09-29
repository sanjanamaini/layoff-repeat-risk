# 0003 — IBM HR Analytics as the workforce dataset for the retention-scoring model

**Status:** survives audit, with a framing requirement carried forward

## The claim
Using the IBM HR Analytics Employee Attrition dataset (a very commonly used Kaggle dataset)
doesn't cost meaningful originality, because the differentiator is the scoring model and
criteria built on top of it, not the raw workforce data.

## Reasoning
The dataset has the right shape (employee-level performance, tenure, cost, satisfaction
fields) for a retention-priority score. It's synthetic, which is disclosed rather than hidden.
Its ubiquity is a risk for the "attrition prediction" use case it's normally used for, but this
project repurposes it for a different task (retention-priority scoring, not attrition
prediction), and pairs it with a real, uncommon dataset (the 442-row global layoffs set) for
benchmarking.

## Adversarial audit
1. **First-impression risk is real and understated.** An interviewer or reviewer who's seen
   dozens of IBM-HR-dataset portfolio projects may register "oh, this again" on recognizing the
   filename or field names, before getting to the novel scoring layer. That reaction happens
   fast and is hard to fully undo with good work downstream. The original reasoning treated
   this risk as fully neutralized by the model layer; it's mitigated, not neutralized.
2. **"Repurposed for a new use case" needs to be demonstrated, not asserted.** If the actual
   built model ends up looking similar to a standard attrition-prediction workflow (train a
   classifier on `Attrition`, output a risk score), the "it's repurposed" defense collapses.
   The retention-priority score needs to visibly NOT use `Attrition` as its target and instead
   be a transparent weighted score justified by the evidence in Dataset 1 — otherwise this
   decision's justification doesn't hold in practice.

## Verdict
**Survives**, conditional on execution: the eventual writeup and dashboard must lead with the
real, uncommon dataset (the layoffs evidence) and the evidence-grounded weighting logic, never
lead with "I used the IBM HR dataset." The IBM dataset should read as raw material the project
transforms, not as the headline. If the finished model ends up resembling a standard attrition
classifier rather than a criteria-transparent priority score, this decision needs to be
revisited.
