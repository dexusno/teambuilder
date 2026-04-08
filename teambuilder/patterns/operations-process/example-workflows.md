# Operations / Process Excellence Pattern — Example Workflows

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

> **Learn, don't copy.** Real generated teams should produce fresh workflows tuned to their specific process, cadence, and metrics. These three are reference shapes — DMAIC as the long-cycle default, a kaizen event as the rapid-intervention alternative, and a value-stream mapping workshop as the analytical entry point. Use them to learn *structure* (phase gates, data-first ordering, explicit control phase) and *agent assignment discipline*, then design your own.

Each team workflow is a **skill directory** containing `SKILL.md` (the agent-facing entry point) and `workflow.md` (the step-by-step instructions). No XML, no workflow triads, no `.claude/commands/` stubs — v6 auto-installs everything via `--custom-content`.

---

## Workflow 1 — DMAIC Improvement Cycle

The structured long-cycle default. Use when the problem has measurable history, a quantifiable business impact, and the organization will tolerate a 4–12 week improvement window.

### `skills/bmad-skill-dmaic-cycle/SKILL.md`

```markdown
---
name: bmad-skill-dmaic-cycle
description: "Run a full DMAIC improvement cycle (Define → Measure → Analyze → Improve → Control) on a recurring operational problem. Use when the user has a measurable process with a business-case-sized pain point and is willing to invest 4–12 weeks in a rigorous improvement, not a quick fix. The cycle has explicit phase gates with Go / Iterate / Stop decisions and will not let the team skip Measure or Control."
argument-hint: "[--project-name=<name>] [--sponsor=<email>]"
---

# DMAIC Improvement Cycle — Workflow Skill

This skill runs the team through the five DMAIC phases with quality gates between each. It is led by `bmad-agent-process-improvement-lead` and coordinates the Metrics Analyst, Lean Sigma Coach, Root Cause Investigator, and Operations Coordinator through their specialist roles.

## Overview

Goal: produce a durable, measured improvement with a working control plan, not just a closed ticket. The cycle is deliberately gated — each phase hands off a specific artifact and the Process Improvement Lead must approve that artifact before the next phase begins.

## On Activation

1. Invoke `bmad-init` with `--module=teams-operations-team` to load configuration (`user_name`, `communication_language`, `output_folder`, plus any team-specific DMAIC settings).
2. Confirm the five required agents are installed: `bmad-agent-process-improvement-lead`, `bmad-agent-metrics-analyst`, `bmad-agent-lean-sigma-coach`, `bmad-agent-root-cause-investigator`, `bmad-agent-operations-coordinator`. If any are missing, STOP and report which one.
3. Read fully and follow `./workflow.md`.
4. Outputs live under `{output_folder}/dmaic/{project-name}/`.

## Critical Success Factors

1. **Do not skip Measure.** A baseline you didn't measure is a baseline you don't have.
2. **Verify root causes with data.** A plausible cause is a hypothesis, not a conclusion.
3. **Pilot with a rollback plan.** No exceptions.
4. **Close on the control plan, not the celebration.** The project is not done until the control chart has run at least one cycle and the 30-day audit passes.

## Execution

Follow `./workflow.md` step by step. Do not parallelize phases. Do not let Define-phase enthusiasm bleed into Analyze-phase conclusions.
```

### `skills/bmad-skill-dmaic-cycle/workflow.md`

```markdown
# DMAIC Improvement Cycle — Workflow

Five phases, gated. Each phase has a lead agent, a specific artifact, and a gate decision.

## Phase 1 — Define

**Lead:** `bmad-agent-process-improvement-lead`
**Supporting:** `bmad-agent-lean-sigma-coach` (voice of customer), `bmad-agent-metrics-analyst` (initial data sketch)

### Step 1 — Problem Statement and Business Case

**Agent:** `bmad-agent-process-improvement-lead`
**Action:** Draft an A3-style problem statement in measurable terms. Not "tickets take too long" — "P2 incident MTTR has drifted from median 2.1h (Q3) to median 6.4h (Q1), affecting 340 tickets/quarter, estimated $180K/year in engineer time and SLA credits."
**Output:** `define/problem-statement.md`

### Step 2 — Voice of Customer

**Agent:** `bmad-agent-lean-sigma-coach`
**Action:** Identify the internal or external customer, their critical-to-quality characteristics, and what "good enough" looks like from their view. Talk to real people, not process owners.
**Output:** `define/voc.md`

### Step 3 — SIPOC and Scope Boundary

**Agents:** `bmad-agent-process-improvement-lead` + `bmad-agent-lean-sigma-coach`
**Action:** Build a SIPOC diagram (Suppliers, Inputs, Process, Outputs, Customers). Draw an explicit in-scope / out-of-scope boundary on it.
**Output:** `define/sipoc.md`

### Gate D → M

**Decider:** `bmad-agent-process-improvement-lead`
**Criteria:** problem stated in measurable terms; business case in dollars or hours; customer CTQs identified; scope bounded; sponsor confirmed.
**Decision:** Go / Iterate / Stop.

## Phase 2 — Measure

**Lead:** `bmad-agent-metrics-analyst`
**Supporting:** `bmad-agent-lean-sigma-coach` (process observation), `bmad-agent-operations-coordinator` (data access)

### Step 4 — Operational Definitions and Data-Collection Plan

**Agent:** `bmad-agent-metrics-analyst`
**Action:** Write operational definitions for every metric. Design the collection plan: sample size (with power calc), frequency, method, collector, storage.
**Output:** `measure/collection-plan.md`

### Step 5 — Measurement-System Analysis

**Agent:** `bmad-agent-metrics-analyst`
**Action:** Run Gage R&R for continuous data or attribute-agreement analysis for categorical. Refuse to proceed if the measurement system consumes more than 30% of tolerance.
**Output:** `measure/msa-report.md`

### Step 6 — Baseline Capability and Stability

**Agent:** `bmad-agent-metrics-analyst`
**Action:** Collect at least 25 data points under current conditions. Report stability (control chart), then capability (Cp/Cpk, sigma level, defect rate). Classify variation as common vs special cause.
**Output:** `measure/baseline-report.md` with embedded I-MR chart

### Step 7 — Current-State Value Stream Map

**Agents:** `bmad-agent-lean-sigma-coach` (facilitates) + full team
**Action:** Gemba walk first, then draw the current-state VSM on paper at the actual work location. Capture process time, lead time, wait time, inventory, and handoffs.
**Output:** `measure/current-state-vsm.md`

### Gate M → A

**Decider:** `bmad-agent-process-improvement-lead`
**Metrics gate:** measurement system < 30% study variation; baseline established with ≥ 25 points; stability confirmed; value-add ratio calculated.
**Decision:** Go / Iterate / Stop.

## Phase 3 — Analyze

**Lead:** `bmad-agent-root-cause-investigator`
**Supporting:** `bmad-agent-metrics-analyst` (hypothesis testing), `bmad-agent-lean-sigma-coach` (waste eyes)

### Step 8 — Waste and Variation Analysis

**Agent:** `bmad-agent-lean-sigma-coach`
**Action:** Walk the VSM and tag each step with DOWNTIME waste categories. Tag mura (unevenness) and muri (overburden) separately from muda.
**Output:** `analyze/waste-map.md`

### Step 9 — Structured Root-Cause Analysis

**Agent:** `bmad-agent-root-cause-investigator`
**Action:** For each of the top 3 Pareto contributors, build a fishbone diagram, then run 5-Whys on each plausible branch. Never single-thread. Stop only at systemic causes.
**Output:** `analyze/fishbone-and-5whys.md`

### Step 10 — Hypothesis Verification

**Agents:** `bmad-agent-root-cause-investigator` + `bmad-agent-metrics-analyst`
**Action:** Each candidate root cause is a hypothesis. Verify with data: does the metric move when the cause is present vs absent? Use appropriate statistical tests with effect sizes, not just p-values.
**Output:** `analyze/verified-causes.md`

### Gate A → I

**Decider:** `bmad-agent-process-improvement-lead`
**Metrics gate:** at least one root cause verified with data; vital few separated from trivial many; team consensus on verified causes.
**Decision:** Go / Iterate / Stop.

## Phase 4 — Improve

**Lead:** `bmad-agent-operations-coordinator`
**Supporting:** full team for solution generation; `bmad-agent-lean-sigma-coach` for lean sanity check

### Step 11 — Countermeasure Generation

**Agents:** full team, facilitated by `bmad-agent-lean-sigma-coach`
**Action:** Brainstorm countermeasures for each verified root cause. Prefer poka-yoke (mistake-proofing) → standard work → training → awareness, in that order. Score on an impact/effort matrix.
**Output:** `improve/countermeasure-matrix.md`

### Step 12 — Lean Sanity Check

**Agent:** `bmad-agent-lean-sigma-coach`
**Action:** Run the selected countermeasures through the lean checklist: does this improve flow or move the bottleneck? Does it reduce mura and muri? Does it establish standard work or depend on heroics?
**Output:** `improve/lean-check.md`

### Step 13 — Pilot Design

**Agent:** `bmad-agent-operations-coordinator`
**Action:** Design a pilot with explicit hypothesis, success criteria tied to the baseline, timebox, scope boundary, data-collection plan, rollback trigger, and rollback procedure. Refuse to proceed without a rollback plan.
**Output:** `improve/pilot-plan.md`

### Step 14 — Pilot Execution

**Agents:** `bmad-agent-operations-coordinator` (runs), `bmad-agent-metrics-analyst` (measures)
**Action:** Execute the pilot in scope. Collect data per plan. Daily standups during the pilot window.
**Output:** `improve/pilot-log.md` + daily metric snapshots

### Step 15 — Statistical Validation

**Agent:** `bmad-agent-metrics-analyst`
**Action:** Compare pilot results to baseline with hypothesis test + effect size. Plot as I-MR chart. Classify improvement as a shift, a variation reduction, or both.
**Output:** `improve/validation-report.md`

### Gate I → C

**Decider:** `bmad-agent-process-improvement-lead`
**Metrics gate:** pilot met success criteria; improvement is statistically significant with a meaningful effect size; no unintended side-effects observed; rollback did not have to be invoked.
**Decision:** Go / Iterate / Stop.

## Phase 5 — Control

**Lead:** `bmad-agent-operations-coordinator`
**Supporting:** `bmad-agent-metrics-analyst` (control charts), `bmad-agent-root-cause-investigator` (failure-mode review)

### Step 16 — Standard Work Documentation

**Agent:** `bmad-agent-operations-coordinator`
**Action:** Write the new standard work so a new hire could follow it on day one. Include visuals where the process is physical. Review with frontline workers and revise based on their feedback before publishing.
**Output:** `control/standard-work.md`

### Step 17 — Control Plan

**Agents:** `bmad-agent-metrics-analyst` (chart) + `bmad-agent-operations-coordinator` (response actions)
**Action:** Build a control chart with Western Electric rules. Define trigger thresholds, who watches, frequency, and pre-agreed response actions for each trigger.
**Output:** `control/control-plan.md` + live control chart

### Step 18 — Rollout Beyond Pilot

**Agent:** `bmad-agent-operations-coordinator`
**Action:** Plan and execute rollout to the full in-scope area. Walk every shift on day one. Ask "what's awkward?" at every visit.
**Output:** `control/rollout-log.md`

### Step 19 — 30-Day Audit

**Agent:** `bmad-agent-operations-coordinator`
**Action:** Thirty days after full rollout, audit the process against standard work. Review the control chart for drift. Interview frontline workers.
**Output:** `control/30-day-audit.md`

### Step 20 — Handoff and Closure

**Agent:** `bmad-agent-process-improvement-lead`
**Action:** Only after the 30-day audit passes. Transfer ownership to the process owner in writing. Document lessons learned. Celebrate with names.
**Output:** `control/closure-report.md`

### Final Gate — Project Closure

**Decider:** `bmad-agent-process-improvement-lead`
**Metrics gate:** standard work published; control chart running; 30-day audit passed; process owner signed off; 90-day audit scheduled on the calendar.
**Decision:** Close / Extend.

## Settings

```yaml
baseline_minimum_samples: 25
msa_tolerance_threshold: 0.30
phase_gate_require_explicit_approval: true
pilot_requires_rollback_plan: true
close_requires_30_day_audit: true
output_folder_default: "_bmad-output/dmaic"
```

## Success Criteria

- Baseline and final capability documented
- Root causes verified with data, not asserted
- Pilot rolled back zero times
- Improvement statistically significant with non-trivial effect size
- Control chart active at closure
- 30-day audit passed
```

---

## Workflow 2 — Kaizen Event (Rapid Improvement)

Use when the problem is bounded, the frontline is available for a concentrated block, and the team can carve out 3–5 consecutive days to go from current-state to implemented quick wins.

### `skills/bmad-skill-kaizen-event/SKILL.md`

```markdown
---
name: bmad-skill-kaizen-event
description: "Run a 3-to-5-day kaizen event: a concentrated improvement sprint that takes a bounded process from current-state observation through future-state design to implemented quick wins inside the week. Use when the problem is well-bounded, the frontline can be freed for the event days, and the organization wants visible improvement fast — without skipping root-cause depth or sustainability."
argument-hint: "[--event-name=<name>] [--days=3|4|5]"
---

# Kaizen Event — Workflow Skill

Led by `bmad-agent-lean-sigma-coach`, with the full team participating. This is not a meeting — it is a gemba-first, hands-on, frontline-included improvement sprint.

## Overview

A kaizen event compresses the DMAIC cycle into a focused window for a bounded problem. Data collection and charter happen *before* Day 1. The event itself is for observation, root-cause work, future-state design, and actual implementation of quick wins. Sustainability is handled in the 30/90 day follow-up.

## On Activation

1. Invoke `bmad-init` with `--module=teams-operations-team`.
2. Verify all five team agents are installed.
3. Confirm the pre-event work is complete (charter, baseline data, frontline availability).
4. Follow `./workflow.md` day by day.

## Critical Success Factors

1. **Frontline participation is non-negotiable.** If the people doing the work are not in the room, it's not a kaizen event.
2. **Go to the gemba on Day 1 within the first 90 minutes.** Do not improve from the conference room.
3. **Implement at least one quick win during the event.** Momentum beats perfection.
4. **Do not close without a 30-day audit scheduled.**

## Execution

Follow `./workflow.md`.
```

### `skills/bmad-skill-kaizen-event/workflow.md`

```markdown
# Kaizen Event — Workflow

Pre-event (1–2 weeks out) → 3–5 event days → 30/90 day follow-up.

## Pre-Event (T-14 to T-1)

### Step 1 — Event Charter

**Agent:** `bmad-agent-process-improvement-lead`
**Action:** Bounded problem statement, specific measurable goal for the event week, scope, sponsor, frontline roster, resource commitments.
**Output:** `charter.md`

### Step 2 — Baseline Data

**Agent:** `bmad-agent-metrics-analyst`
**Action:** Pull the last 90 days of available data for the in-scope process. If no data exists, spend two days of the pre-event window running a rapid observation study. Produce baseline metric, capability, and Pareto of failure modes.
**Output:** `pre-event/baseline.md`

### Step 3 — Logistics

**Agent:** `bmad-agent-operations-coordinator`
**Action:** Room, supplies (sticky notes, markers, butcher paper, cameras), frontline cover so participants are actually freed from their day jobs, executive kickoff and readout slots on the calendar.
**Output:** `pre-event/logistics.md`

## Day 1 — Understand

### Step 4 — Kickoff (08:00–09:00)

**Agent:** `bmad-agent-process-improvement-lead`
**Action:** Sponsor speaks for 5 minutes. Lead presents charter, goals, ground rules. Lean Sigma Coach gives a 20-minute intro to the tools the team will use this week — on the actual problem, not slides.

### Step 5 — Gemba Walk (09:00–11:00)

**Agent:** `bmad-agent-lean-sigma-coach`, full team
**Action:** Walk the actual process. Observe, time steps, photograph, ask frontline workers open questions. No laptops, no whiteboards.
**Output:** `day1/gemba-notes.md` + photos

### Step 6 — Current-State Value Stream Map (11:00–16:00)

**Agents:** full team, facilitated by `bmad-agent-lean-sigma-coach`
**Action:** Build the CSVSM on butcher paper at the work location. Add data boxes, inventory triangles, information flows. Tag DOWNTIME waste, mura, and muri. Metrics Analyst calculates lead time, process time, value-add ratio.
**Output:** `day1/current-state-vsm.md` + photo

### Step 7 — Day 1 Debrief (16:00–17:00)

**Agent:** `bmad-agent-process-improvement-lead`
**Action:** What did we see that surprised us? Where is the biggest waste? What's the top-three failure mode by Pareto?

## Day 2 — Analyze

### Step 8 — Root-Cause Deep Dive (08:00–12:00)

**Agent:** `bmad-agent-root-cause-investigator`
**Action:** For the top three Pareto contributors, build fishbones and run 5-Whys. Never single-thread. Metrics Analyst verifies each candidate cause against the baseline data on the spot.
**Output:** `day2/verified-causes.md`

### Step 9 — Future-State Design (13:00–17:00)

**Agents:** full team, facilitated by `bmad-agent-lean-sigma-coach`
**Action:** Design the future-state VSM. Apply flow, pull, leveling, standard work. Lean Sigma Coach gates: does this actually change the bottleneck or just move it? Reduce mura and muri first, then muda.
**Output:** `day2/future-state-vsm.md`

## Day 3 — Implement Quick Wins

### Step 10 — Action List (08:00–09:00)

**Agent:** `bmad-agent-operations-coordinator`
**Action:** Translate the future state into a numbered action list. Each item has an owner, a date, and is tagged as either "implement this week" or "post-event." Aim for at least three this-week items.
**Output:** `day3/action-list.md`

### Step 11 — Hands-On Implementation (09:00–16:00)

**Agents:** `bmad-agent-operations-coordinator` (coordinates), full team + frontline (executes)
**Action:** Actually build the quick wins. Move equipment, print labels, write the first draft of standard work, install the poka-yoke. Test with live work.
**Output:** `day3/implementation-log.md` + before/after photos

### Step 12 — Day 3 Measurement (16:00–17:00)

**Agent:** `bmad-agent-metrics-analyst`
**Action:** Measure the process after the quick wins using the same operational definitions as the baseline. Small sample is fine; the point is directional.
**Output:** `day3/initial-results.md`

## Day 4–5 — Standardize and Report Out

### Step 13 — Standard Work Draft (Day 4 morning)

**Agent:** `bmad-agent-operations-coordinator`
**Action:** Draft the new standard work with photos. Walk it with frontline. Revise.
**Output:** `day4/standard-work-v1.md`

### Step 14 — Post-Event Action Plan (Day 4 afternoon)

**Agent:** `bmad-agent-operations-coordinator`
**Action:** Detail every post-event action with owner, date, and dependencies. Schedule the 30-day audit on the calendar before leaving the room.
**Output:** `day4/post-event-plan.md`

### Step 15 — Report Out (Day 5, 10:00–11:00)

**Agent:** `bmad-agent-process-improvement-lead`, with full team presenting their pieces
**Action:** Present to the sponsor and affected management: charter, before/after, root causes found, quick wins implemented, measured improvement so far, post-event action list, and 30/90-day audit schedule. Thank the frontline participants by name.
**Output:** `day5/readout.md`

## Post-Event

### Step 16 — Weekly Follow-Up (T+7, T+14, T+21)

**Agent:** `bmad-agent-operations-coordinator`
**Action:** Work the post-event action list. Weekly 30-minute check-ins. Remove obstacles.

### Step 17 — 30-Day Audit

**Agents:** `bmad-agent-operations-coordinator` (audit) + `bmad-agent-metrics-analyst` (metrics)
**Action:** Has the improvement held? Is the standard work being followed? What has drifted?
**Metrics gate:** improvement ≥ 80% of the Day-5 measurement; no new failure modes introduced.
**Output:** `post-event/30-day-audit.md`

### Step 18 — 90-Day Audit and Closure

**Agent:** `bmad-agent-process-improvement-lead`
**Action:** Final audit. Formal handoff to process owner. Document lessons learned and feed them into the team memory for future events.
**Output:** `post-event/closure-report.md`

## Success Criteria

- At least three quick wins implemented during the event week
- Post-event action list ≥ 80% complete by day 30
- 30-day audit passed
- Frontline participants report psychological safety during the event
- Sponsor signed off at readout
```

---

## Workflow 3 — Value Stream Mapping Workshop

Use when the team needs to understand a full end-to-end flow before deciding what to improve, or when the user has said "things are slow" but has no specific Pareto yet.

### `skills/bmad-skill-value-stream-mapping/SKILL.md`

```markdown
---
name: bmad-skill-value-stream-mapping
description: "Run a value-stream mapping workshop that goes from a product or service family choice, through a gemba walk of the actual flow, through current-state and future-state maps, to an implementation roadmap of specific improvement projects. Use as the analytical entry point when the user knows something is slow or wasteful but does not yet have a specific target metric or root cause."
argument-hint: "[--family=<name>]"
---

# Value Stream Mapping Workshop — Workflow Skill

Facilitated by `bmad-agent-lean-sigma-coach` with measurement support from `bmad-agent-metrics-analyst`. Produces a roadmap of improvement projects, not a finished improvement.

## Overview

VSM is diagnostic. You walk the actual path of a product or service from request to delivery, map what's really happening (not what the SOP says), calculate flow metrics, design a target future state, and break the gap into a sequenced list of improvement projects. Those projects then feed DMAIC cycles or kaizen events.

## On Activation

1. Invoke `bmad-init` with `--module=teams-operations-team`.
2. Ask the user to pick a single product or service family. If they pick "everything," push back — VSM works on one family at a time.
3. Follow `./workflow.md`.

## Execution

Follow `./workflow.md`.
```

### `skills/bmad-skill-value-stream-mapping/workflow.md`

```markdown
# Value Stream Mapping Workshop — Workflow

Nine steps. One day for a simple family, two days for a complex one.

## Step 1 — Family Selection

**Agent:** `bmad-agent-process-improvement-lead`
**Action:** Pick one product or service family with a clear start and end point. If multiple families share most of the same process steps, pick the highest-volume one. Refuse to map "everything."
**Output:** `family-definition.md`

## Step 2 — Team Assembly

**Agent:** `bmad-agent-lean-sigma-coach`
**Action:** Include at least one person from every process step. At least half the team must be frontline. Two-pizza rule: if the room has more than 8 people, you're doing it wrong.
**Output:** `team-roster.md`

## Step 3 — Gemba Walk

**Agents:** full team, led by `bmad-agent-lean-sigma-coach`
**Action:** Walk the actual path from the customer request end, backwards to the upstream supplier end. Observe. Photograph. Time steps with a stopwatch. Count inventory at each handoff.
**Output:** `gemba-observations.md` + photos

## Step 4 — Current-State Map

**Agents:** full team, facilitated by `bmad-agent-lean-sigma-coach`
**Action:** Build the current-state map on butcher paper. Process boxes, inventory triangles, information flows, data boxes (cycle time, changeover, uptime, batch size, number of operators). Draw the customer icon on the right, supplier on the left.
**Output:** `current-state-vsm.md`

## Step 5 — Metric Calculation

**Agent:** `bmad-agent-metrics-analyst`
**Action:** Calculate total lead time, total process time, value-add ratio (process time / lead time), bottleneck step, and takt time (customer demand rate / available work time). Identify constraint per Theory of Constraints.
**Metrics gate:** value-add ratio reported, takt time vs longest cycle time comparison made, constraint identified.
**Output:** `metrics-summary.md`

## Step 6 — Waste Tagging

**Agent:** `bmad-agent-root-cause-investigator`
**Action:** Walk the map and mark every instance of DOWNTIME waste. Separately mark mura (unevenness — e.g., Monday spikes) and muri (overburden — e.g., operators working through lunch to stay on takt).
**Output:** `waste-tagged-vsm.md`

## Step 7 — Future-State Design

**Agents:** full team, facilitated by `bmad-agent-lean-sigma-coach`
**Action:** Apply the future-state questions in order:
  1. What is the takt time?
  2. Will we build to finished goods or ship to order?
  3. Where can we introduce continuous flow?
  4. Where must we use a supermarket pull system?
  5. At what single point will we schedule production (the pacemaker)?
  6. How will we level the mix at the pacemaker (heijunka)?
  7. What increment of work will we release (pitch)?
  8. What process improvements (kaizen bursts) do we need?
**Output:** `future-state-vsm.md`

## Step 8 — Gap Analysis

**Agent:** `bmad-agent-metrics-analyst`
**Action:** Quantify gap between current and future state metrics. Flag the biggest movers.
**Output:** `gap-analysis.md`

## Step 9 — Implementation Roadmap

**Agents:** `bmad-agent-process-improvement-lead` + `bmad-agent-operations-coordinator`
**Action:** Break the future-state into a sequenced list of improvement projects. Each project needs: scope, target metric, rough effort, suggested workflow (DMAIC cycle or kaizen event), and sequencing dependency. Projects run in priority order, not parallel.
**Output:** `implementation-roadmap.md`

## Success Criteria

- Single family mapped end to end
- Value-add ratio calculated and honest (usually sub-10%, often sub-5%)
- Constraint identified
- Future state shows flow or a deliberate pull system, not just "less waste"
- Roadmap has ≥ 3 specific next projects with owners and suggested workflow type
```

---

## Workflow choice heuristic

| Situation | Use |
|-----------|-----|
| Clear measurable problem, 4–12 week window, need statistical rigor | **DMAIC Cycle** |
| Bounded problem, frontline freed for a week, need visible results fast | **Kaizen Event** |
| Unclear root cause, "things are slow," need to understand full flow first | **VSM Workshop** |

A real team may run a VSM workshop first to produce a roadmap, then execute the top roadmap items as either DMAIC cycles (if they need the statistical discipline) or kaizen events (if they're well-bounded and frontline is available). Do not run two in parallel on the same family — you'll just burn the frontline.
