# Software Development Pattern — Example Workflows

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

> **Reminder:** for standard agile ceremonies (sprint planning, standup, retro, code review), install BMM (`npx bmad-method install --modules bmm`). The workflows below are **specialty workflows** that specialty teams own — they produce concrete specialty artifacts (threat models, postmortems, perf reports, model validation runs), not sprint outcomes.

> **Learn, don't copy.** These workflows illustrate the shape of specialty work. When generating a real team, adapt the steps to the user's actual operational context.

---

## Workflow 1 — Security Audit & Threat Model

A structured walkthrough that takes a feature or system from "we want to ship this" to "here's a STRIDE threat model, an attack tree, a ranked finding list with owners and deadlines, and a ship-gate decision." Led by the Security Engineer with input from the Reliability and Performance engineers.

### `bmad-skill-security-audit-threat-model/SKILL.md`

```markdown
---
name: bmad-skill-security-audit-threat-model
description: "Produce a threat model and security audit for a feature or system. Runs a STRIDE walkthrough on the component view, an attack-tree walkthrough on the adversary view, triages findings into a ranked remediation list with owners and deadlines, and ends with an explicit ship-gate decision from the Security Engineer. Use when the team is about to expose new functionality, change an authN/authZ boundary, or handle new PII categories."
argument-hint: "[--feature-name=<name>] [--target-conformance=<soc2|iso27001|pci|none>]"
---

# Security Audit & Threat Model — Workflow Skill

This skill runs a structured security audit ending in an explicit ship-gate decision. It is designed for use by the platform team's Security Engineer (`bmad-agent-security-engineer`) with consultative input from the Reliability Engineer (`bmad-agent-reliability-engineer`) and Performance Engineer (`bmad-agent-performance-engineer`) where relevant.

## Overview

Goal: produce a defensible threat model, a ranked finding list, and a ship-gate decision. Not "a security document" — a named artifact the team can use.

## On Activation

1. Invoke `bmad-init` with `--module=teams-platform-team` to load configuration (SBOM path, threat register path, CVE feed source).
2. Verify `bmad-agent-security-engineer` is available. If missing, STOP.
3. Load the workflow definition from `./workflow.md` and follow it step by step.
4. Output artifact is written to `{output_folder}/security/threat-models/{feature-name}-{timestamp}.md`.

## Execution

Read fully and follow the instructions in `./workflow.md`.
```

### `bmad-skill-security-audit-threat-model/workflow.md`

```markdown
# Security Audit & Threat Model — Workflow

Specialty workflow owned by the Security Engineer. Seven steps, ends in a ship-gate decision.

## Step 1 — Scope the Audit

**Lead agent:** `bmad-agent-security-engineer` (Riya)

**Action:** Define what's in and out of scope. Capture the feature name, the trust boundaries being crossed, the data categories involved, and the target conformance regime (SOC-2, ISO 27001, PCI, or none).

**Output:** A scope statement at the top of the artifact. Anything outside this scope is explicitly not covered by this audit.

**User checkpoint:** confirm scope before proceeding. Scope creep mid-audit is how audits fail.

## Step 2 — Component View: STRIDE Walkthrough

**Lead agent:** Security Engineer

**Action:** Draw the component diagram (data flow, trust boundaries, external interfaces). For each component and each data flow crossing a trust boundary, walk STRIDE: Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege.

**Output:** A STRIDE table. Each row: component, flow, STRIDE category, candidate threat, current mitigation, residual risk.

## Step 3 — Adversary View: Attack Tree

**Lead agent:** Security Engineer

**Action:** Starting from the highest-value attacker goal (usually "exfiltrate user data" or "compromise authN"), build an attack tree. Each node is a sub-goal; each leaf is a concrete technique. For each leaf, note whether it is blocked, partially mitigated, or open.

**Output:** An attack tree diagram and a per-leaf status list.

## Step 4 — CVE & SBOM Cross-Check

**Lead agent:** Security Engineer

**Action:** Pull the current SBOM for the components in scope. Diff against the latest CVE feed. For any CVE hit, capture CVSS vector, EPSS percentile, and exploit-in-the-wild status.

**Output:** A CVE-SBOM hit list. Anything with EPSS > 0.10 or public exploit code is flagged "act now." Anything below that line is flagged "track."

## Step 5 — Consultative Input (Optional, Parallel)

**Lead agent:** Security Engineer; consultative input from `bmad-agent-reliability-engineer` (Marcus) and `bmad-agent-performance-engineer` (Ingrid)

**Action:** For any mitigation with operational cost (rate limiting, extra crypto, new auth flows), get the SRE's read on blast radius and the Performance Engineer's read on latency cost. This is a short consultative round, not a separate workflow.

**Output:** Notes added to each affected finding capturing the operational trade-off.

## Step 6 — Finding Triage & Remediation List

**Lead agent:** Security Engineer

**Action:** Take all findings from Steps 2–5 and produce a single ranked remediation list. Each finding gets:

- Category (STRIDE letter or CVE ID)
- Severity (Critical / High / Medium / Low) grounded in exploitability, not CVSS alone
- Affected component(s) and user journey
- Proposed remediation
- Owner (specific agent or team)
- Deadline
- Accepted-risk status (if applicable, with named accepter and review date)

**Output:** The remediation list, ordered by severity then by exploitability.

## Step 7 — Ship-Gate Decision

**Lead agent:** Security Engineer

**Action:** The Security Engineer issues an explicit decision:

- **Ship** — no blocking findings; medium/low findings tracked in the register.
- **Ship with conditions** — specific blocking findings must be remediated before exposure, with named owners and deadlines.
- **Do not ship** — fundamental issues require rework before the audit can be reconvened.

**Output:** The decision written clearly at the bottom of the artifact, signed by the Security Engineer (displayName), with the date.

**User checkpoint:** present the decision to the user. If "Ship with conditions," confirm the conditions are understood. If "Do not ship," agree on the rework path and when to re-run the audit.

## Artifact

The final artifact is a single markdown file at `{output_folder}/security/threat-models/{feature-name}-{timestamp}.md` containing: scope statement, STRIDE table, attack tree, CVE-SBOM hit list, remediation list, ship-gate decision.

## Rules

- This workflow produces a security artifact, not a meeting. If no artifact lands in the output folder, the workflow did not complete.
- Ship-gate decisions are public. "Do not ship" must be explained to the team, not issued silently.
- Accepted risks must have a named accepter and a review date, or they're not tracked, they're forgotten.
```

---

## Workflow 2 — Reliability Incident Postmortem

Blameless postmortem workflow owned by the Reliability Engineer. Produces a timeline, contributing factors, and durable action items with owners.

### `bmad-skill-reliability-incident-postmortem/SKILL.md`

```markdown
---
name: bmad-skill-reliability-incident-postmortem
description: "Run a blameless postmortem for a reliability incident. Produces a fact-checked timeline, a contributing-factors tree (not a single root cause), a list of durable action items with owners and deadlines, and a lessons-learned summary. Use after any P0/P1 incident, any user-visible outage longer than the SLO allows, or any near-miss the team wants to learn from."
argument-hint: "[--incident-id=<id>]"
---

# Reliability Incident Postmortem — Workflow Skill

Owned by the Reliability Engineer (`bmad-agent-reliability-engineer`). The Security Engineer participates if security was involved; the Performance Engineer participates if latency was a contributing factor.

## On Activation

1. Invoke `bmad-init` with `--module=teams-platform-team` to load configuration (SLO definitions, runbook index, incident log path).
2. Verify `bmad-agent-reliability-engineer` is available.
3. Load `./workflow.md` and follow it step by step.
4. Output artifact is written to `{output_folder}/reliability/postmortems/{incident-id}-{timestamp}.md`.

## Execution

Read fully and follow the instructions in `./workflow.md`.
```

### `bmad-skill-reliability-incident-postmortem/workflow.md`

```markdown
# Reliability Incident Postmortem — Workflow

Blameless. Timeline-driven. Ends in durable action items. Owned by the Reliability Engineer.

## Step 1 — Confirm Blamelessness

**Lead agent:** `bmad-agent-reliability-engineer` (Marcus)

**Action:** Open the postmortem by stating the ground rules out loud:

- We are looking for systemic contributing factors, not individual blame.
- "Human error" is not a root cause — it's a signal that the system allowed an error to have impact.
- Everyone's account is accepted as their honest recollection; timestamps settle conflicts.

**Output:** The ground rules written at the top of the artifact. No exceptions.

## Step 2 — Reconstruct the Timeline

**Lead agent:** Reliability Engineer

**Action:** Pull paging logs, chat history, commit history, deploy logs, and monitoring alerts. Reconstruct the timeline minute by minute from first signal to recovery. Every entry has a UTC timestamp, a source, and an actor (if human).

**Output:** A timeline table. Fact-checked — no interpretation yet, just events.

## Step 3 — Identify Contributing Factors (Not a Single Root Cause)

**Lead agent:** Reliability Engineer

**Action:** Walk the timeline and identify contributing factors — not a single "root cause." Incidents rarely have one. Capture each factor with evidence from the timeline.

Common contributing-factor categories: monitoring gap (signal was absent), alerting gap (signal existed but was not alerted), runbook gap (alert existed but no documented response), deploy pattern (risky change without guardrail), capacity (saturation not forecast), dependency (upstream service failure), recovery (rollback slower than expected), toil (operator action required that should have been automated).

**Output:** A contributing-factors tree. Each factor is specific and has timeline evidence.

## Step 4 — Consultative Input (If Applicable)

**Lead agent:** Reliability Engineer; consultative input from `bmad-agent-security-engineer` (Riya) if the incident had a security dimension, and from `bmad-agent-performance-engineer` (Ingrid) if latency was a factor.

**Action:** Bring in relevant specialists for their view on contributing factors in their domain. Keep the consult short — a few targeted questions, not a separate investigation.

**Output:** Notes from each consultative input added to the contributing factors.

## Step 5 — Durable Action Items

**Lead agent:** Reliability Engineer

**Action:** For each contributing factor, write one or more action items. Each action item must be:

- **Durable** — produces a lasting change in the system (new monitor, runbook entry, chaos test, automation, capacity headroom). "Be more careful" is not durable.
- **Owned** — by a specific agent or team, not "the team."
- **Deadlined** — with a review date.
- **Verifiable** — someone can check that it was actually done.

**Output:** A numbered action-item list.

## Step 6 — SLO & Error-Budget Impact

**Lead agent:** Reliability Engineer

**Action:** Document the SLI impact and error-budget burn from the incident. If the incident pushed the service past the error-budget policy threshold, call the freeze now and route feature work to reliability work per the policy.

**Output:** SLI/burn-rate numbers and any policy actions taken.

## Step 7 — Lessons Learned Summary

**Lead agent:** Reliability Engineer

**Action:** Write a short lessons-learned section — what the team now knows that it didn't before. Not "be more careful." More like "our deploy guardrail assumed X but the system actually does Y."

**Output:** A final summary paragraph. Honest, specific, not performative.

## Artifact

Final artifact at `{output_folder}/reliability/postmortems/{incident-id}-{timestamp}.md`: ground rules, timeline, contributing factors, action items, SLO impact, lessons learned.

## Rules

- Blameless is not optional. If someone's name appears as "the problem," the postmortem is broken.
- No single "root cause" — the phrase is banned from the template. Use "contributing factors."
- Action items without owners or deadlines are not tracked.
```

---

## Workflow 3 — Performance Profile & Optimize

Owned by the Performance Engineer. Runs from "something feels slow" to a measured before/after delta with a regression guard.

### `bmad-skill-performance-profile-optimize/SKILL.md`

```markdown
---
name: bmad-skill-performance-profile-optimize
description: "Investigate a perceived or measured performance issue, identify the hot path, propose an optimization, measure the before/after delta, and land a regression guard so the improvement doesn't drift. Use when tail latency has regressed, a specific user journey is slow, or a capacity model shows headroom loss."
argument-hint: "[--user-journey=<name>] [--baseline=<baseline-id>]"
---

# Performance Profile & Optimize — Workflow Skill

Owned by the Performance Engineer (`bmad-agent-performance-engineer`). The Reliability Engineer is a consultative participant because SLI definitions and error budgets frame the work.

## On Activation

1. Invoke `bmad-init` with `--module=teams-platform-team` to load configuration (baselines path, profiler endpoints, regression-budget config).
2. Verify `bmad-agent-performance-engineer` is available.
3. Load `./workflow.md` and execute step by step.
4. Output artifact at `{output_folder}/performance/investigations/{user-journey}-{timestamp}.md`.

## Execution

Read fully and follow the instructions in `./workflow.md`.
```

### `bmad-skill-performance-profile-optimize/workflow.md`

```markdown
# Performance Profile & Optimize — Workflow

Measurement-first. No optimization without a baseline. Owned by the Performance Engineer.

## Step 1 — Establish the Baseline

**Lead agent:** `bmad-agent-performance-engineer` (Ingrid)

**Action:** Pull current p50/p95/p99 on the user journey in question. Compare to the registered baseline. If there is no registered baseline, create one — this is the baseline going forward.

**Output:** A baseline block at the top of the artifact: p50, p95, p99, measurement window, sample size.

**Rule:** no optimization conversation proceeds without this block.

## Step 2 — Capture a Flame Graph on the Hot Path

**Lead agent:** Performance Engineer

**Action:** Use the continuous profiler (or a targeted trace if the profiler lacks coverage) to capture a flame graph covering the hot path during representative load. Identify the dominant stacks. Distinguish CPU time, IO wait, lock contention, and GC pauses from the flame graph shape.

**Output:** A flame graph reference (path or link) and a ranked list of dominant stacks with percentage-of-total-time.

## Step 3 — Identify the Bottleneck Honestly

**Lead agent:** Performance Engineer

**Action:** Name the bottleneck specifically. Not "the database" — "a full table scan on `orders` because the index doesn't cover the ORDER BY clause." Not "serialization" — "JSON encoding of a 40KB response for an endpoint called on every page load."

**Output:** A bottleneck statement. Specific enough that someone unfamiliar with the code could locate it.

## Step 4 — Consultative Input (If Applicable)

**Lead agent:** Performance Engineer; consultative input from `bmad-agent-reliability-engineer` (Marcus) on which user journey maps to which SLO, and from a Database Architect if one is on the team.

**Action:** Confirm the bottleneck falls inside a real SLI. If not, the optimization may not be worth doing — validate priority with the SRE.

**Output:** SLI/SLO mapping and priority confirmation.

## Step 5 — Propose the Optimization

**Lead agent:** Performance Engineer

**Action:** Propose the smallest change that plausibly addresses the bottleneck. Name the expected delta in p95 and p99 with a confidence range. State explicitly what could go wrong (GC pressure shifted elsewhere, memory increase, cache coherence).

**Output:** A proposal block: change, expected delta, risks, rollback plan.

## Step 6 — Measure Before/After

**Lead agent:** Performance Engineer

**Action:** After the change is deployed to a representative environment (or production behind a flag), re-measure p50/p95/p99 under the same load profile as Step 1. Compute the delta. If the delta does not match the proposal, stop and reconsider — do not declare victory on a partial improvement.

**Output:** Before/after table with deltas for each percentile.

## Step 7 — Land a Regression Guard

**Lead agent:** Performance Engineer

**Action:** Create or update the regression guard for this user journey so future changes that would regress past the new baseline are caught automatically. Register the new baseline.

**Output:** The regression guard configuration (CI check, canary gate, or continuous-profiling alert) and the updated baseline entry.

## Artifact

Final artifact at `{output_folder}/performance/investigations/{user-journey}-{timestamp}.md`: baseline, flame graph reference, bottleneck statement, SLI mapping, proposal, before/after, regression guard.

## Rules

- No baseline, no investigation. Full stop.
- "Faster" is not a result. "p95 dropped from 850ms to 470ms under the same load profile" is a result.
- Every optimization ships with a regression guard, or it drifts back within six weeks.
```

---

## Workflow 4 — ML Model Validation Pipeline

Owned by the ML Engineer. Runs from a candidate model to a promotion decision with offline eval, fairness slices, shadow deployment, and a model card.

### `bmad-skill-ml-model-validation-pipeline/SKILL.md`

```markdown
---
name: bmad-skill-ml-model-validation-pipeline
description: "Validate a candidate ML model for promotion to production. Runs offline eval on a frozen holdout, computes fairness slice metrics, plans and reviews a shadow deployment, writes or updates the model card, and issues a promotion decision. Use before any model promotion to prod serving — not after."
argument-hint: "[--model-name=<name>] [--candidate-version=<version>]"
---

# ML Model Validation Pipeline — Workflow Skill

Owned by the ML Engineer (`bmad-agent-ml-engineer`). The Security Engineer consults on PII and injection risks; the Reliability Engineer consults on serving-latency budgets.

## On Activation

1. Invoke `bmad-init` with `--module=teams-platform-team` to load configuration (model registry, eval dataset index, model card path).
2. Verify `bmad-agent-ml-engineer` is available.
3. Load `./workflow.md` and execute step by step.
4. Output artifact at `{output_folder}/ml/validations/{model-name}-{candidate-version}.md`.

## Execution

Read fully and follow the instructions in `./workflow.md`.
```

### `bmad-skill-ml-model-validation-pipeline/workflow.md`

```markdown
# ML Model Validation Pipeline — Workflow

Offline eval first. Frozen holdout, no peeking. Owned by the ML Engineer.

## Step 1 — Candidate Registration

**Lead agent:** `bmad-agent-ml-engineer` (Kenji)

**Action:** Register the candidate model in the model registry with: training data snapshot ID, code commit hash, hyperparameters, trainer identity, and training-time metrics. If any of these are missing, STOP — the candidate is not eligible for validation.

**Output:** Registry entry with all fields populated.

## Step 2 — Offline Eval on Frozen Holdout

**Lead agent:** ML Engineer

**Action:** Run offline eval on the frozen holdout — a dataset the training code cannot and did not see. Compute primary metrics (task-specific: AUC, NDCG, F1, BLEU, calibration error) with confidence intervals. Compare against the current production model under the same eval.

**Output:** Offline eval block: primary metrics with CIs, delta vs. prod, sample size.

**Rule:** "Better" requires the CI to not cross the prod baseline. A point-estimate lift inside the noise is a wash.

## Step 3 — Fairness Slices

**Lead agent:** ML Engineer

**Action:** Decompose primary metrics by the fairness slices defined on the model card (demographic, geographic, content-category, whatever applies). Flag any slice where the candidate regresses vs. prod even if the aggregate improves.

**Output:** A fairness-slice table. Each row: slice, prod metric, candidate metric, delta, flag.

## Step 4 — Consultative Input (As Needed)

**Lead agent:** ML Engineer; consultative input from `bmad-agent-security-engineer` (Riya) on PII in training data and prompt-injection risks for LLMs; from `bmad-agent-reliability-engineer` (Marcus) on serving-latency budgets and error-budget impact of online serving changes.

**Action:** Targeted consults, not full reviews. The ML Engineer owns the decision; the consults inform it.

**Output:** Consult notes attached to the validation document.

## Step 5 — Shadow Deployment Plan

**Lead agent:** ML Engineer

**Action:** Design a shadow deployment: the candidate runs alongside prod on live traffic, its predictions are logged but not served to users. Capture online metric parity vs. offline, feature-distribution drift vs. training data, and prediction-distribution drift vs. prod model.

**Output:** Shadow plan: traffic percentage, duration, metrics to log, early-stop criteria.

## Step 6 — Shadow Deployment Readout

**Lead agent:** ML Engineer

**Action:** After the shadow runs for the planned duration, produce the readout. Three questions:

1. Did online behavior match offline eval? If not, why? This is the single most common failure mode.
2. Is the feature distribution in live traffic consistent with the training distribution? Any drift?
3. Are fairness slices still intact on live traffic?

**Output:** Readout block: online vs. offline comparison, drift measurements, slice check.

## Step 7 — Model Card Update

**Lead agent:** ML Engineer

**Action:** Update (or create) the model card with: data sources, intended use, known failure modes, fairness slice performance, evaluation dates, and the candidate's validation results.

**Output:** Updated model card in the team's model card registry.

## Step 8 — Promotion Decision

**Lead agent:** ML Engineer

**Action:** Issue the promotion decision:

- **Promote** — the candidate passes offline eval with non-overlapping CIs, holds fairness slices, and matched offline-online in shadow. Route to production serving.
- **Promote with conditions** — passes overall but specific slices or traffic segments must be monitored; add the monitors before promoting.
- **Do not promote** — any of offline eval (CI overlap), fairness slice regression, or online-offline mismatch is a hard block.

**Output:** Decision block at the bottom of the artifact, signed by the ML Engineer, with date.

## Artifact

Final artifact at `{output_folder}/ml/validations/{model-name}-{candidate-version}.md`: registry entry, offline eval, fairness slices, consults, shadow plan, readout, model card update, promotion decision.

## Rules

- No frozen holdout, no promotion. "We eval'd it" without a frozen holdout means nothing.
- Online-offline mismatch is a red flag, not an acceptable finding — investigate it before promoting.
- Model cards are not optional. A model without a current card cannot be in production.
```

---

## What These Four Workflows Teach

- **Specialty workflows produce specialty artifacts.** Threat model, postmortem, perf investigation, model validation. Each one is a named, searchable, reusable document — not just "a meeting happened."
- **Each workflow is owned by one specialist.** The ownership is explicit in the workflow. Other specialists consult, but one person issues the decision at the end.
- **Each workflow ends in a decision.** Ship-gate, action items with owners, a regression guard, a promotion decision. Not "we discussed it."
- **Consultative participation is short and targeted.** The cross-specialist consults in Steps 4/5 of each workflow are deliberately small. Specialties collaborate; they don't committee.
- **No sprint ceremonies here.** Standup, planning, retro, code review are BMM's job. These workflows live alongside, not instead of, a sprint cadence.

## Reminder

**For standard agile ceremonies, install BMM.** For the workflows above — specialty workflows that end in specialty artifacts — this pattern is the right tool.

And: **learn, don't copy.** Adapt these workflows to the user's real stack, real conformance targets, real incident history, real model domains. The shape transfers; the specifics must come from the user.
