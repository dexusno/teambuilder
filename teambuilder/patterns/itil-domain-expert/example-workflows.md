# ITIL / Domain Expert Pattern — Example Workflows

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

These workflows demonstrate formal, document-producing governance processes for ITIL teams. In v6, each team workflow is a **skill directory** under `skills/` containing:

- `SKILL.md` — frontmatter (`name`, `description`) + a short body that points at `workflow.md`
- `workflow.md` — step-by-step instructions with explicit agent assignments and governance gates
- `template.md` (optional) — the structured output document the workflow produces

Study how these workflows sequence agents, gate decisions, and produce named artifacts. Then generate original workflows for the user's actual ITIL context — do not copy these verbatim.

All examples assume agents from the `example-agents.md` reference: `bmad-agent-change-manager`, `bmad-agent-incident-commander`, `bmad-agent-problem-manager`, `bmad-agent-release-manager`, `bmad-agent-cmdb-custodian`, `bmad-agent-compliance-auditor`.

---

## Example Workflow 1 — Change Approval (CAB)

**Directory:** `skills/bmad-skill-change-approval/`
**Purpose:** Take a proposed RFC through the full Change Advisory Board approval cycle: triage, impact analysis, compliance review, CAB decision, and scheduling.

### `SKILL.md`

````markdown
---
name: bmad-skill-change-approval
description: "Run an RFC through the full Change Advisory Board approval cycle. Use when a change is proposed and needs to be triaged, impact-assessed, compliance-reviewed, and scheduled on the Forward Schedule of Change. Coordinates the Change Manager (chair), CMDB Custodian (impact data), Problem Manager (known-error check), Release Manager (train alignment), and Compliance Auditor (regulated components). Produces a signed CAB decision record and an FSC entry."
argument-hint: "[--rfc=<id>] [--emergency=true|false]"
---

# Change Approval — Workflow Skill

This skill runs a proposed RFC through the governance gates of the Change Enablement practice. It is the team's primary decision workflow for production change.

## Overview

Goal: reach a defensible Go / No-Go / Rework decision on an RFC, backed by impact analysis, known-error checks, compliance attestation where required, and a confirmed change window. The workflow produces a Change Decision Record that becomes part of the audit trail.

## On Activation

1. Invoke `bmad-init` with `--module=teams-itil-team` to load config (user name, communication language, output folder, CAB cadence, change policy, freeze windows).
2. Resolve the RFC. If `--rfc=<id>` was passed in, load it. Otherwise ask the user for the RFC summary and capture it.
3. If `--emergency=true`, route to the ECAB short-path in `workflow.md` (steps 1, 3, 6, 8 only).
4. Load `./workflow.md` and follow it step by step.
5. The output template is at `./template.md`; fill it in and write the Change Decision Record to `{output_folder}/change-decisions/cdr-{rfc-id}-{timestamp}.md`.

## Completion

Return to the caller (typically `bmad-agent-change-manager`) with:
- The decision (Approved / Approved with conditions / Rework / Rejected / Deferred)
- The path to the Change Decision Record
- The scheduled change window, if approved
````

### `workflow.md`

````markdown
# Change Approval — Workflow

Eight steps. Steps 2, 4, and 6 are governance gates — the workflow stops at each until the named agent produces their output.

## Variables to Capture

```yaml
rfc_id: ""
rfc_summary: ""
change_class: ""          # standard | normal | emergency
risk_tier: ""             # P1 | P2 | P3 | P4
affected_cis: []
impact_map_path: ""
kedb_conflicts: []
release_train_alignment: ""
sod_check_status: ""      # passed | failed | not-applicable
compliance_attestation: ""
cab_decision: ""          # approved | approved-with-conditions | rework | rejected | deferred
change_window: ""
back_out_plan_verified: false
```

## Step 1 — RFC Triage

**Agent:** `bmad-agent-change-manager`
**Inputs:** RFC summary, requester, target services
**Outputs:** `change_class`, `risk_tier`, preliminary Go / Return-for-rework decision

The Change Manager classifies the RFC as Standard, Normal, or Emergency, assigns a risk tier, and verifies the submission meets the minimum bar: declared change window, documented back-out plan, named implementer, named verifier. Anything missing is returned to the requester immediately — no CAB time burned on incomplete submissions.

**Gate:** if the RFC is returned for rework, the workflow stops here. If it proceeds, continue.

## Step 2 — Impact Analysis (Governance Gate)

**Agent:** `bmad-agent-cmdb-custodian`
**Inputs:** RFC + affected service or CI list
**Outputs:** `impact_map_path`, `affected_cis`, freshness confidence tier

The CMDB Custodian produces an impact map for the affected CIs and attaches a freshness confidence tier ("last reconciled N days ago, confidence: fresh/medium/stale"). The Change Manager cannot proceed without this output. If the confidence tier is stale, the Custodian runs a targeted reconciliation first — surprise impact is not acceptable.

## Step 3 — Known Error Check

**Agent:** `bmad-agent-problem-manager`
**Inputs:** `affected_cis`, impact map
**Outputs:** `kedb_conflicts` (list of KEDB entries touching the affected CIs, with workaround status and expiry)

The Problem Manager checks the KEDB for active known errors on the affected CIs. Any open KEDB entry is flagged with its current workaround and expiry date. The Change Manager must explicitly acknowledge any conflicts before proceeding.

## Step 4 — Release Train Alignment (Governance Gate)

**Agent:** `bmad-agent-release-manager`
**Inputs:** RFC, impact map, proposed change window
**Outputs:** `release_train_alignment` (aligned / misaligned / not-applicable), proposed train

If the RFC is a software release, the Release Manager confirms it fits the current train schedule and has a rollback artifact. If it is a standalone infrastructure change, this step returns `not-applicable`. Hotfixes that do not fit the scheduled train are routed to a hotfix train and re-scheduled.

## Step 5 — Segregation of Duties Check

**Agent:** `bmad-agent-compliance-auditor`
**Inputs:** RFC (implementer, verifier, approver roles)
**Outputs:** `sod_check_status`

The Compliance Auditor verifies that the implementer, verifier, and approver are distinct parties and that none of them have a disqualifying conflict. If SoD fails, the RFC is returned for re-staffing. If the RFC touches a regulated component, this step is mandatory; otherwise it may be marked `not-applicable`.

## Step 6 — Compliance Attestation (Governance Gate, Conditional)

**Agent:** `bmad-agent-compliance-auditor`
**Inputs:** RFC + impact map + evidence artifacts
**Condition:** Only runs if the affected CIs include a regulated component (SOX ITGC, ISO 27001 control, DORA critical third party, etc.).
**Outputs:** `compliance_attestation` (attested / attested-with-findings / not-attested)

The Compliance Auditor attests that the evidence supports approval under the applicable framework. She does not approve the change — she attests that the evidence would hold up to external review. If `not-attested`, the workflow routes to rework. If `attested-with-findings`, the findings are attached to the CAB record.

## Step 7 — CAB Deliberation

**Agent:** `bmad-agent-change-manager` (chair), with inputs from all prior agents
**Inputs:** impact map, KEDB conflicts, train alignment, SoD status, compliance attestation
**Outputs:** `cab_decision`, rationale, conditions (if any)

The Change Manager chairs the CAB discussion. Each prior agent's output is read into the record. The chair drives the room through the three standard questions: What is the risk if we proceed? What is the risk if we don't? What back-out plan do we have if the change fails? The decision is logged with rationale.

## Step 8 — Schedule and Record

**Agent:** `bmad-agent-change-manager`
**Inputs:** CAB decision + proposed window
**Outputs:** `change_window` (on the FSC), Change Decision Record at `{output_folder}/change-decisions/cdr-{rfc_id}-{timestamp}.md`

If approved, the change is placed on the Forward Schedule of Change in the declared window. The Change Decision Record is written using `./template.md`. The record includes the impact map reference, KEDB conflicts, compliance attestation, CAB rationale, and scheduled window. The Change Manager notifies the requester and hands the record to the Compliance Auditor for the evidence archive.

## Governance Gates Summary

| Gate | Owner | Blocks on |
|------|-------|-----------|
| Step 2 — Impact Analysis | CMDB Custodian | Stale or missing CI data |
| Step 4 — Release Alignment | Release Manager | Missing rollback artifact, train mismatch |
| Step 6 — Compliance Attestation | Compliance Auditor | Regulated component without evidence |

## Edge Cases

- **Emergency (ECAB) path:** Steps 1, 3, 6, 8 only. Impact analysis and release alignment are deferred to the post-implementation review; the attestation is provisional and reconfirmed within 24 hours.
- **Freeze window collision:** Step 1 rejects automatically unless a signed business exception from the affected service owner is attached.
- **Confidence-stale impact map:** Step 2 pauses for targeted reconciliation; the Change Manager is not permitted to proceed on stale data.

## Success Criteria

- [ ] Every governance gate has a documented output
- [ ] The CAB decision is recorded with rationale
- [ ] The change is either scheduled on the FSC or returned with reasons
- [ ] The Change Decision Record is written and handed to the Compliance Auditor
````

---

## Example Workflow 2 — Major Incident Response (P1 / P2)

**Directory:** `skills/bmad-skill-major-incident-response/`
**Purpose:** Run a declared P1 or P2 incident from bridge-open through restoration and handoff to Problem Management.

### `SKILL.md`

````markdown
---
name: bmad-skill-major-incident-response
description: "Run a declared P1 or P2 major incident end-to-end: open the bridge, assign roles, drive the action timeline, maintain the comms cadence, decide when to escalate, coordinate any emergency change through the Change Manager, declare restoration, and hand off to Problem Management for root cause. Led by the Incident Commander. Produces a full incident timeline and a resolution record."
argument-hint: "[--severity=P1|P2] [--incident-id=<id>]"
---

# Major Incident Response — Workflow Skill

This skill orchestrates the team's response to a declared major incident. The Incident Commander runs the workflow; other agents are paged in as needed.

## On Activation

1. Invoke `bmad-init` with `--module=teams-itil-team`.
2. If `--incident-id` is provided, attach to the existing record. Otherwise create a new incident record.
3. Confirm severity with the user: P1 = critical business impact, P2 = significant business impact.
4. Load `./workflow.md` and run it.

## Completion

Return to the caller with the incident timeline path, the restoration timestamp, and the handoff confirmation to `bmad-agent-problem-manager`.
````

### `workflow.md`

````markdown
# Major Incident Response — Workflow

Six steps. The Incident Commander is the workflow lead throughout. Other agents are paged in at named steps and released when done. The Incident Commander does not debug.

## Variables to Capture

```yaml
incident_id: ""
severity: ""              # P1 | P2
declared_at: ""
services_affected: []
bridge_roles: {}          # commander, scribe, technical-lead, comms-lead, SMEs
comms_cadence_minutes: 0  # 15 for P1, 30 for P2
timeline: []              # list of timestamped entries
escalations: []
emergency_change_rfc: ""  # if an ECAB path was needed
restored_at: ""
handoff_to_problem_at: ""
```

## Step 1 — Open the Bridge

**Agent:** `bmad-agent-incident-commander`
**Inputs:** incident summary, suspected affected services
**Outputs:** bridge opened, roles assigned, initial timeline entry, first stakeholder comm sent

The Incident Commander opens the bridge, names the roles (Commander, Scribe, Technical Lead, Comms Lead, any paged SMEs), and sets the comms cadence: 15 minutes for P1, 30 minutes for P2. The first stakeholder communication goes out immediately, even if it is "investigating, next update in 15 minutes."

## Step 2 — Impact Confirmation

**Agents:** `bmad-agent-incident-commander` + `bmad-agent-cmdb-custodian`
**Inputs:** suspected affected services
**Outputs:** confirmed `services_affected`, downstream CI map, business impact tier

The Incident Commander asks the CMDB Custodian for the current service map covering the suspected affected services, with downstream impact. The Custodian states the freshness confidence of the map on the record. The Commander logs confirmed impact in the timeline.

## Step 3 — Drive the Timeline

**Agent:** `bmad-agent-incident-commander` (lead), SMEs executing
**Inputs:** hypotheses, actions proposed
**Outputs:** timeline entries, each with UTC timestamp, action, owner, expected signal

The Commander runs the three-question cycle every cadence interval: What do we know? What do we suspect? What do we need? Every action taken by an SME gets a timestamped timeline entry with owner and expected signal. Stakeholder comms go out on cadence — "no change" is a valid update.

**Escalation trigger:** if the P1 is unresolved at the 60-minute mark, or if business impact is trending worse, the Commander escalates to senior leadership and logs the escalation.

## Step 4 — Emergency Change (Conditional)

**Agents:** `bmad-agent-incident-commander` + `bmad-agent-change-manager`
**Condition:** Only runs if restoration requires a production change.
**Outputs:** `emergency_change_rfc`, ECAB decision, back-out verified

If restoration requires a change, the Commander pauses to coordinate with the Change Manager, who convenes an Emergency CAB on the short-path (Change Approval workflow, ECAB path). The emergency change is logged in the incident timeline with its ECAB decision and back-out plan. Restoration does not proceed until ECAB approval is recorded.

## Step 5 — Restoration Declaration

**Agent:** `bmad-agent-incident-commander`
**Inputs:** restoration signal (the expected signal from Step 3 is observed)
**Outputs:** `restored_at` timestamp, final stakeholder comm, bridge stand-down

The Commander does not declare restoration on verbal assurance. The declared signal must be observed. Once observed, the Commander timestamps restoration, sends the final stakeholder comm, and stands down the bridge. Root cause is explicitly *not* addressed at this point — the Commander notes the current hypothesis as a hypothesis, not as a cause.

## Step 6 — Handoff to Problem Management

**Agents:** `bmad-agent-incident-commander` → `bmad-agent-problem-manager`
**Inputs:** incident timeline, current hypothesis, affected CIs
**Outputs:** new problem record opened by the Problem Manager, `handoff_to_problem_at` timestamp

The Commander hands the incident record to the Problem Manager and opens a problem record. The handoff is explicit and timestamped. The Problem Manager acknowledges receipt and the Commander's role ends. Root cause is now the Problem Manager's job.

## Governance Discipline

- **Comms cadence is non-negotiable.** P1 = 15 minutes. P2 = 30 minutes. A missed update is logged as a process exception.
- **One commander at a time.** Handoffs between commanders are explicit and timestamped.
- **The CAB is paused during a live P1.** Any production change routes through the ECAB path; normal change activity is suspended until the bridge is closed.
- **The Commander does not debug.** If the Commander finds themselves typing commands, they hand the commander role to someone else before continuing.

## Success Criteria

- [ ] Bridge opened within 5 minutes of declaration
- [ ] Comms cadence held for the full duration
- [ ] Every action timestamped with owner
- [ ] Restoration declared on observed signal, not verbal assurance
- [ ] Problem record opened and handoff timestamped
````

---

## Example Workflow 3 — Problem Investigation & RCA

**Directory:** `skills/bmad-skill-problem-investigation/`
**Purpose:** Run a structured root-cause investigation on a resolved incident (or a pattern of recurring minor incidents), produce an RCA report, update the KEDB, and propose a permanent fix.

### `SKILL.md`

````markdown
---
name: bmad-skill-problem-investigation
description: "Run a structured root-cause investigation on a resolved incident or on a pattern of recurring minor incidents. Produces an RCA report with root cause, contributing factors, workaround (with expiry), and a permanent-fix proposal routed to the Change Manager as an RFC. Led by the Problem Manager, with input from the CMDB Custodian for configuration history and the Compliance Auditor if a regulated control is implicated."
argument-hint: "[--problem-id=<id>] [--incident-id=<id>]"
---

# Problem Investigation — Workflow Skill

This skill runs a structured RCA and produces the artifacts that close a problem record: the RCA report, a KEDB entry, and a permanent-fix RFC proposal.

## On Activation

1. Invoke `bmad-init` with `--module=teams-itil-team`.
2. If `--incident-id` is provided, open a new problem record referencing that incident. If `--problem-id` is provided, resume an existing investigation.
3. Load `./workflow.md`.
````

### `workflow.md`

````markdown
# Problem Investigation — Workflow

Seven steps. The Problem Manager leads throughout; other agents are consulted at named points.

## Variables to Capture

```yaml
problem_id: ""
source_incidents: []
hypotheses: []            # every hypothesis, including the ones ruled out
ruled_out: []
root_cause: ""
contributing_factors: []
workaround: ""
workaround_expiry: ""
kedb_entry_path: ""
permanent_fix_summary: ""
permanent_fix_rfc: ""
compliance_implication: ""
```

## Step 1 — Frame the Investigation

**Agent:** `bmad-agent-problem-manager`
**Inputs:** source incident(s) or pattern description
**Outputs:** problem statement, scope, initial hypotheses

The Problem Manager writes a precise problem statement. Not "the system was slow" — "the payments-gateway p99 latency exceeded 2000ms for 47 minutes on date X, affecting Y transactions." Scope is declared: which services, which time window, which population. Initial hypotheses are listed, all of them, even the unlikely ones.

## Step 2 — Configuration History Query

**Agent:** `bmad-agent-cmdb-custodian`
**Inputs:** affected CIs + time window
**Outputs:** historical CI state, recent changes touching the CIs, relationship integrity at the time of incident

The Problem Manager asks the CMDB Custodian for the state of the affected CIs *at the time of the incident*, including any relationship changes, version changes, or ownership changes within the preceding 30 days. The Custodian returns the data with a freshness tier — historical queries rely on snapshot integrity, and she is explicit about where the data is trustworthy and where it is reconstructed.

## Step 3 — Five Whys and Contributing Factors

**Agent:** `bmad-agent-problem-manager`
**Inputs:** incident timeline, hypotheses, configuration history
**Outputs:** `root_cause` (tentative), `contributing_factors` (multiple)

The Problem Manager walks the five-whys chain. She explicitly asks the sixth "why" to test the fifth. She lists contributing factors alongside root cause — most production failures have one and several. Hypotheses that are ruled out move to the `ruled_out` list with the evidence that ruled them out. Hypotheses that cannot be ruled out stay open in the record.

**Rule:** absence of evidence is not evidence of absence. A hypothesis is not ruled out until there is evidence against it.

## Step 4 — Compliance Implication Check (Conditional)

**Agent:** `bmad-agent-compliance-auditor`
**Condition:** Only runs if the root cause or a contributing factor involves a regulated control failure.
**Outputs:** `compliance_implication` — control failure description, evidence, remediation expectation

If the investigation surfaces a control failure — segregation of duties, access control, audit-trail gap, change-policy deviation — the Compliance Auditor produces a compliance-implication note. The note describes the control, the failure mode, and the remediation expectation in regulator-neutral language so it can travel into an evidence pack unchanged.

## Step 5 — Workaround and KEDB Entry

**Agent:** `bmad-agent-problem-manager`
**Inputs:** root cause, contributing factors
**Outputs:** `workaround`, `workaround_expiry`, `kedb_entry_path`

The Problem Manager documents a workaround — what on-call should do if this recurs before the permanent fix ships. Every workaround gets an expiry date; an expiry of "indefinite" is not permitted. The KEDB entry is written and linked to the source incident(s).

## Step 6 — Permanent Fix Proposal

**Agent:** `bmad-agent-problem-manager`
**Inputs:** root cause + contributing factors
**Outputs:** `permanent_fix_summary`, draft RFC

The Problem Manager drafts the permanent fix as an RFC summary — scope, affected CIs, expected back-out plan, risk tier, proposed change window. She does not file the RFC herself; she routes it to the Change Manager for triage and CAB scheduling.

## Step 7 — RCA Report and Handoff

**Agents:** `bmad-agent-problem-manager` → `bmad-agent-change-manager`
**Outputs:** `rca_report_path`, `permanent_fix_rfc` (filed by the Change Manager)

The Problem Manager writes the RCA report using `./template.md`. The report contains: problem statement, scope, ruled-out hypotheses (with evidence), root cause, contributing factors, compliance implications (if any), workaround and expiry, permanent-fix proposal. The report is filed at `{output_folder}/rca-reports/rca-{problem-id}-{timestamp}.md` and handed to the Change Manager, who files the RFC through the Change Approval workflow.

## Success Criteria

- [ ] Problem statement is specific (numbers, timestamps, populations)
- [ ] Every hypothesis is either the root cause, a contributing factor, or in `ruled_out` with evidence
- [ ] Workaround has an expiry date
- [ ] Permanent fix is routed to the Change Manager as an RFC draft
- [ ] KEDB entry is linked to source incident(s)
- [ ] RCA report is written and handed off
````

---

## Example Workflow 4 — Post-Implementation Review

**Directory:** `skills/bmad-skill-post-implementation-review/`
**Purpose:** Review a change after it has been implemented — was it successful, what did it actually affect, were there unforeseen consequences, and what should the practice learn.

### `SKILL.md`

````markdown
---
name: bmad-skill-post-implementation-review
description: "Run a post-implementation review (PIR) on a completed change. Determines whether the change was successful against its declared success criteria, whether it caused any unplanned impact, whether the back-out plan was needed, and what the practice should learn. Led by the Change Manager with input from the CMDB Custodian (did the actual impact match the predicted impact?), the Release Manager (did it affect the release train downstream?), and the Compliance Auditor (is the evidence complete?). Mandatory for every emergency change and for any normal change classified P1 or P2 risk."
argument-hint: "[--rfc=<id>]"
---

# Post-Implementation Review — Workflow Skill

PIR is how the practice learns. This skill produces a structured review artifact and feeds lessons back into the standard-change catalogue, the KEDB, and the compliance evidence pack.

## On Activation

1. Invoke `bmad-init` with `--module=teams-itil-team`.
2. Resolve the RFC. Load the original Change Decision Record, the incident log for the change window, and the CMDB state before and after.
3. Load `./workflow.md`.
````

### `workflow.md`

````markdown
# Post-Implementation Review — Workflow

Five steps. Short and disciplined — a PIR that drags on for two weeks teaches nothing.

## Variables to Capture

```yaml
rfc_id: ""
original_success_criteria: []
actual_outcome: ""            # success | partial-success | failed | backed-out
predicted_impact: []
actual_impact: []
unforeseen_consequences: []
back_out_used: false
lessons_learned: []
catalogue_updates: []         # changes to the standard-change catalogue
evidence_gaps: []
```

## Step 1 — Outcome Against Success Criteria

**Agent:** `bmad-agent-change-manager`
**Inputs:** original Change Decision Record, implementation record
**Outputs:** `actual_outcome`, pass/fail per original criterion

The Change Manager reads the original CDR and walks through each declared success criterion. Each is marked pass, fail, or not-observable. The overall outcome is one of: success, partial-success, failed, backed-out. Opinions are not acceptable here — only observed outcomes.

## Step 2 — Predicted vs Actual Impact

**Agent:** `bmad-agent-cmdb-custodian`
**Inputs:** original impact map, current CI state
**Outputs:** `predicted_impact`, `actual_impact`, `unforeseen_consequences`

The CMDB Custodian compares the impact map that was produced at Step 2 of the Change Approval workflow against the actual post-change CI state. Any delta is recorded — CIs affected that were not on the map, relationships that changed unexpectedly, ownership shifts, versions that drifted. Unforeseen consequences become a feedback signal for the impact-analysis process itself.

## Step 3 — Downstream Effects on the Release Train

**Agent:** `bmad-agent-release-manager`
**Inputs:** release schedule at and after the change
**Outputs:** downstream effects, if any, on subsequent trains

If the change was part of a release train, the Release Manager reviews whether subsequent trains were affected. Did the change block, delay, or accelerate anything downstream? Are any rollback artifacts now stale because of this change? If the answer is "no effect," say so explicitly and move on.

## Step 4 — Evidence Completeness Check

**Agent:** `bmad-agent-compliance-auditor`
**Inputs:** all artifacts produced by the change: CDR, impact map, ECAB record (if any), implementation log, back-out evidence
**Outputs:** `evidence_gaps`, attestation that the evidence pack is complete or a list of what is missing

The Compliance Auditor reviews the evidence pack for the change. Her question is: if an external auditor asked for evidence of this change tomorrow, what would they find and what would they miss? Gaps are recorded. For regulated changes, gaps trigger remediation; for unregulated changes, gaps are logged as lessons.

## Step 5 — Lessons and Catalogue Updates

**Agent:** `bmad-agent-change-manager` (lead), with inputs from all prior agents
**Outputs:** `lessons_learned`, `catalogue_updates`, PIR report at `{output_folder}/pirs/pir-{rfc_id}-{timestamp}.md`

The Change Manager consolidates the lessons. Three questions drive this step:

1. **Should this become a standard change?** If the change is repeatable, low-risk, and has a stable back-out plan, it is a candidate for the standard-change catalogue — reducing future CAB overhead.
2. **Did the practice itself fail anywhere?** If the impact map was wrong, the KEDB check missed something, or the SoD check was waived inappropriately, the practice has a lesson to learn.
3. **Does anything feed the Problem Manager?** If the change revealed a latent issue, open a problem record.

The PIR report is written using `./template.md` and filed. Any catalogue updates are queued for the next practice review. Any new problem records are handed to the Problem Manager.

## Discipline

- PIR is mandatory for every emergency change and every normal change at P1 or P2 risk tier.
- PIR is optional but recommended for normal P3 and P4 changes.
- PIR closes within one week of the change window. An older PIR teaches less.
- The PIR is *not* blame-oriented. The Problem Manager's phrase applies: most failures are process or UX failures in disguise.

## Success Criteria

- [ ] Outcome declared against original criteria
- [ ] Predicted vs actual impact compared
- [ ] Downstream train effects recorded
- [ ] Evidence pack attested
- [ ] Lessons learned fed back into standard-change catalogue, KEDB, or problem backlog
````

---

## Workflow Design Principles for ITIL Teams

### Governance gates are load-bearing

Every governance workflow for an ITIL team should have **named governance gates** — specific steps owned by a specific agent where the workflow cannot proceed without a declared output. In these examples:

- Change Approval has three gates: impact analysis (CMDB Custodian), release alignment (Release Manager), compliance attestation (Compliance Auditor, conditional).
- Major Incident Response has one implicit gate: ECAB approval before any restoration-driving production change.
- Problem Investigation has one conditional gate: compliance implication check.
- PIR has one gate: evidence completeness check.

Gates create the audit trail that regulators expect.

### Clean role seams prevent role overlap

- Incident Commander does restoration; Problem Manager does root cause. Handoff is explicit and timestamped.
- Release Manager owns the train; Change Manager owns the production boundary. Handoff is at promotion.
- Compliance Auditor attests; Change Manager approves. Both signatures when both risks are present; neither substitutes for the other.
- CMDB Custodian provides data; nobody else touches the CI model. Custodian is non-approving — she never signs off on a change.

### Document outputs are named and versioned

Every step has a named artifact. CDR, impact map, KEDB entry, RCA report, PIR report, evidence pack. Versioning is through timestamped filenames. The audit trail is the collection of these artifacts — not a narrative description.

### Freshness and evidence are declared, not assumed

The CMDB Custodian attaches a freshness tier to every impact map. The Compliance Auditor distinguishes evidence from documentation. The Problem Manager distinguishes hypotheses from facts. These are not stylistic choices — they are how the team stays honest under external review.

---

## Application to Generation

When generating workflows for the user's actual ITIL context:

1. **Identify the governance gates** the user's framework requires. SOX? ISO 27001? DORA? HIPAA? Gates come from the framework.
2. **Map gates to agents** — which team member is best positioned to own each gate. The owner must be independent of the delivery flow where independence is a framework requirement.
3. **Name the artifacts** — every step should produce a named, versioned output that can become evidence.
4. **Design clean seams** — explicit handoffs prevent role overlap, and role overlap is the single biggest killer of governance workflows.
5. **Keep it disciplined** — a governance workflow that is too long becomes a ritual nobody follows. Six to eight steps is the sweet spot for most ITIL workflows.

**These workflows teach governance process patterns. Generate original workflows for the user's specific ITIL context following these principles.**
