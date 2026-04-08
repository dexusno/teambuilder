# Planning / Strategy Pattern — Example Workflows

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

Three example workflows for a consultative planning team. Each is a v6 workflow skill: a directory under `skills/` containing `SKILL.md` and `workflow.md` (and optionally `template.md` when the workflow produces a structured document).

All three reference the example agents by their `bmad-agent-*` names from `example-agents.md`: `bmad-agent-strategic-planner`, `bmad-agent-stakeholder-liaison`, `bmad-agent-risk-analyst`, `bmad-agent-decision-facilitator`, `bmad-agent-scenario-modeler`, `bmad-agent-implementation-coordinator`.

**Learn, don't copy.** Real teams should design their own workflows with the principles these illustrate: framing before analysis, every lens gets a turn, explicit synthesis, documented dissent, auditable decision record, user decides.

---

## 1. Strategic Roadmap Workshop

A full consultative workshop that turns an ambiguous strategic situation into an annotated roadmap with multiple options and a recommended path. Typically runs 45–75 minutes.

**`bmad-skill-strategic-roadmap-workshop/SKILL.md`**

```markdown
---
name: bmad-skill-strategic-roadmap-workshop
description: "Run a consultative strategic roadmap workshop. Takes an ambiguous strategic situation through framing, multi-lens analysis, option generation, risk-adjusted evaluation, and synthesis into an annotated roadmap with 2-4 options and a recommended path. Led by the Strategic Planner; every agent on the team contributes a lens. Use when the user needs to set or refresh a strategy, build a roadmap, or align a team on a multi-year direction."
argument-hint: "[--horizon=<years>] [--decision=<short-label>]"
---

# Strategic Roadmap Workshop — Workflow Skill

This skill runs the full consultative roadmap workshop for a strategy team. It produces an annotated decision record and a roadmap with explicit trade-offs, documented dissent, and a recommended path — not a single "answer."

## Overview

Goal: take an ambiguous strategic situation through framing, multi-lens analysis, risk-adjusted evaluation, and synthesis. The output is something the user can defend in a steering committee and come back to when assumptions change.

## On Activation

1. Invoke `bmad-init` with `--module=teams-strategy-team` to load configuration.
2. Load the workflow definition from `./workflow.md` and follow it step by step.
3. Fill the output template at `./template.md` and write it to `{output_folder}/strategy/roadmap-{slug}-{timestamp}.md`.
4. Return control to the calling agent with the path to the decision record.

## Critical Success Factors

1. **Framing first** — do not start analysis until the decision, horizon, and constraints are explicit.
2. **Every lens speaks** — no lens may be skipped, even under time pressure.
3. **Explicit trade-offs** — every option carries its trade-off in writing.
4. **Dissent captured** — disagreement is documented, not buried.
5. **User decides** — the workshop ends in a user decision gate, not an agent decision.

## Execution

Read fully and follow the instructions in `./workflow.md`.
```

**`bmad-skill-strategic-roadmap-workshop/workflow.md`**

```markdown
# Strategic Roadmap Workshop — Workflow

A six-step consultative workshop that holds a strategy team together through the arc of framing → analysis → options → evaluation → synthesis → user decision.

## Participating Agents

| Agent | Lens |
|-------|------|
| `bmad-agent-strategic-planner` | Framing, horizon, synthesis |
| `bmad-agent-stakeholder-liaison` | Power/interest, alignment |
| `bmad-agent-risk-analyst` | Risk register, premortem |
| `bmad-agent-scenario-modeler` | Futures, sensitivity |
| `bmad-agent-decision-facilitator` | Process, matrix, decision record |
| `bmad-agent-implementation-coordinator` | Feasibility, first 90 days |

## Step 1 — Frame the Decision
**Lead:** `bmad-agent-strategic-planner`
**Other agents:** observe

The Strategic Planner opens with four questions, and refuses to move on until they are answered:

1. What decision are we actually making?
2. On what horizon?
3. What are the non-negotiable constraints?
4. What would "a good answer" look like, specifically?

**Output:** a one-paragraph decision frame written to the decision record.

**Checkpoint:** the user confirms the frame before analysis begins. If the user disagrees, the Strategic Planner rewrites and re-confirms.

## Step 2 — Multi-Lens Situation Analysis
**Lead:** `bmad-agent-strategic-planner` (facilitates)
**Participants:** all agents, speaking in order

Each agent speaks from their lens for 2–4 minutes without interruption:

- **Strategic Planner** — theory of change, current strategic position (Five Forces / Playing to Win as scaffolding)
- **Stakeholder Liaison** — power/interest grid, current alignment state, likely coalition pressures
- **Risk Analyst** — top five risks by probability × impact, base rates from comparable initiatives
- **Scenario Modeler** — the two most uncertain, most impactful drivers, and a first-cut 2×2
- **Implementation Coordinator** — current capacity, dependency posture, what the org can actually absorb

Cross-examination is allowed after all five have spoken. Agents may challenge each other; personal attacks are not permitted. The Strategic Planner arbitrates.

**Output:** a situation section in the decision record with one paragraph per lens.

## Step 3 — Generate Options
**Lead:** `bmad-agent-strategic-planner` + `bmad-agent-scenario-modeler`
**Goal:** 3–5 distinct strategic options, not variations on one

The Strategic Planner generates candidate options using opportunity solution tree (OST) thinking: the strategic objective at the root, branches for different theories of how to get there. The Scenario Modeler stress-tests each branch with a "what would have to be true?" question.

**Filter:** any option that no agent can defend is cut. Any option that every agent agrees is "obviously best" is flagged for extra scrutiny — strategic consensus is often a sign of insufficient option exploration.

**Output:** 3–5 options, each with a one-sentence description and a one-sentence theory of change.

## Step 4 — Multi-Lens Evaluation
**Lead:** `bmad-agent-decision-facilitator`
**Participants:** all agents

The Decision Facilitator draws the decision matrix. Rows are options; columns are criteria (strategic fit, risk posture, stakeholder feasibility, scenario robustness, execution feasibility, cost/speed). Criteria are weighted *before* scoring, by the user if present, otherwise by the Strategic Planner with visible assumptions.

Each lens scores the criterion it owns:

- Strategic Planner → strategic fit
- Risk Analyst → risk posture (lower risk = higher score, weighted by severity)
- Scenario Modeler → scenario robustness (how many of the four futures does this option survive?)
- Stakeholder Liaison → stakeholder feasibility
- Implementation Coordinator → execution feasibility
- Decision Facilitator → cost/speed and overall matrix integrity

**Output:** weighted decision matrix in the decision record. Scores are shown, not just the totals.

## Step 5 — Premortem and Synthesis
**Lead:** `bmad-agent-risk-analyst` (premortem) then `bmad-agent-strategic-planner` (synthesis)

**5a — Premortem (Risk Analyst leads, 5 minutes):** assume the top-scoring option has failed 18 months from now. Work backwards. What killed it? Each agent names one failure mode from their lens. The Risk Analyst attaches mitigations.

**5b — Synthesis (Strategic Planner leads, 5 minutes):** integrate the lenses into a recommendation. Name the trade-off. Name the assumption the recommendation most depends on. Name the thing the team is explicitly *not* choosing.

**Decision gate — dissent:** the Decision Facilitator asks each agent, by name, whether they consent to the recommendation (not whether they enthusiastically agree — consent, not consensus). Dissent is documented in the record, attributed to the lens.

**Output:** a recommended option with its top three caveats, its key assumption, its three biggest risks with mitigations, and any documented dissent.

## Step 6 — Present and Hand Over to User
**Lead:** `bmad-agent-strategic-planner` + `bmad-agent-decision-facilitator` (jointly)
**Other agents:** available for user questions

The Strategic Planner presents the frame, the options, and the recommendation. The Decision Facilitator presents the matrix and the documented dissent. The user asks questions; any agent may answer from their lens. The Implementation Coordinator offers a first-90-days outline if the user is ready to commit.

**Decision gate — user:**

- **Accept the recommendation** → Implementation Coordinator produces the first 90 days document.
- **Accept a different option** → Decision Facilitator updates the record with the user's choice and the reason; Implementation Coordinator drafts the first 90 days for that option.
- **Defer** → Decision Facilitator notes the deferral and the trigger condition for re-opening the decision.

The workshop ends when the user has made — or explicitly deferred — a decision, and the decision record is complete.

## Completion Criteria

- [ ] Decision frame confirmed by user in Step 1
- [ ] All five lenses represented in Step 2
- [ ] 3–5 options generated in Step 3
- [ ] Weighted matrix produced in Step 4
- [ ] Premortem run in Step 5a
- [ ] Explicit dissent capture in Step 5b
- [ ] User decision or explicit deferral in Step 6
- [ ] Decision record written to `{output_folder}/strategy/`
```

---

## 2. Stakeholder Alignment Session

A focused workshop for situations where the strategy is roughly known but the path to alignment is not. Stakeholder Liaison leads; the rest of the team supports. Typically 30–45 minutes.

**`bmad-skill-stakeholder-alignment-session/SKILL.md`**

```markdown
---
name: bmad-skill-stakeholder-alignment-session
description: "Run a focused stakeholder alignment session for a planned initiative. Produces a stakeholder map, a power/interest grid, a sequenced engagement plan, and a set of anticipated objections with responses. Led by the Stakeholder Liaison with support from the rest of the strategy team. Use when the user has a plan and needs to align the organization around it."
argument-hint: "[--initiative=<short-label>]"
---

# Stakeholder Alignment Session — Workflow Skill

Produces a complete stakeholder alignment plan for an initiative: who matters, what they want, in what order to talk to them, and what to say when they push back.

## On Activation

1. Invoke `bmad-init` with `--module=teams-strategy-team`.
2. Read and follow `./workflow.md`.
3. Output document template is `./template.md`; save the result to `{output_folder}/strategy/alignment-{slug}-{timestamp}.md`.

## Critical Success Factors

1. **Interests, not positions** — the map captures what people actually want, not what they say first.
2. **Sequence is the plan** — the output is an ordered engagement path, not an undifferentiated list.
3. **Anticipated objections** — the team rehearses the hard conversations before they happen.
4. **Ethical line** — surface reality, do not engineer outcomes the user has not approved.
```

**`bmad-skill-stakeholder-alignment-session/workflow.md`**

```markdown
# Stakeholder Alignment Session — Workflow

A five-step session focused on turning a known plan into a concrete, sequenced alignment strategy.

## Participating Agents

| Agent | Role in this workflow |
|-------|----------------------|
| `bmad-agent-stakeholder-liaison` | Lead throughout |
| `bmad-agent-strategic-planner` | Anchors the plan being aligned |
| `bmad-agent-risk-analyst` | Adds political-risk lens |
| `bmad-agent-implementation-coordinator` | Reconciles RACI to the alignment plan |
| `bmad-agent-decision-facilitator` | Produces the engagement record |

## Step 1 — Anchor the Initiative
**Lead:** `bmad-agent-strategic-planner`

The Strategic Planner states the initiative in one paragraph: the change, the horizon, the measurable outcome, and the current level of explicit sponsorship. The user confirms.

**Output:** one-paragraph initiative anchor written to the alignment record.

## Step 2 — Stakeholder Mapping
**Lead:** `bmad-agent-stakeholder-liaison`

The Stakeholder Liaison drives the team through mapping:

1. **Who is in the picture?** List every individual and group that can materially help or harm the initiative.
2. **What do they want — really?** For each, capture the *interest* behind the likely *position*.
3. **What does this initiative cost them?** Time, status, budget, political capital.
4. **What could it give them?** Same categories.

The Risk Analyst contributes base-rate observations on who typically resists this kind of change.

**Output:** stakeholder list with interest / cost / benefit for each.

## Step 3 — Power / Interest Grid
**Lead:** `bmad-agent-stakeholder-liaison`

Place each stakeholder on a 2×2 (power vs interest). Four quadrants drive four engagement strategies:

- **High power, high interest** → manage closely, early and often
- **High power, low interest** → keep satisfied, minimum-viable engagement
- **Low power, high interest** → keep informed, harvest goodwill
- **Low power, low interest** → monitor

The Decision Facilitator writes the grid to the alignment record.

**Output:** power/interest grid in the decision record, with explicit quadrant strategies.

## Step 4 — Sequenced Engagement Plan
**Lead:** `bmad-agent-stakeholder-liaison` + `bmad-agent-implementation-coordinator`

Design the order of conversations. The Stakeholder Liaison sequences based on coalition-building logic (who must say yes before whom); the Implementation Coordinator reconciles the sequence to the RACI of the underlying initiative so the people accountable for execution are in the loop at the right moment.

For each conversation, capture:

- Who
- When (relative order, not calendar date)
- Opening framing
- The one concession available if pushed
- The non-negotiable

**Output:** ordered engagement plan in the alignment record.

## Step 5 — Objection Rehearsal and User Decision
**Lead:** `bmad-agent-stakeholder-liaison` + `bmad-agent-risk-analyst`
**Participants:** all agents

The team anticipates the five hardest objections the initiative will face, and drafts a one-paragraph response to each. The Risk Analyst flags any objection that is actually pointing at a real problem in the plan — in that case, the objection is not an objection, it is feedback, and the initiative should change.

**Ethical check:** the Stakeholder Liaison explicitly confirms that no part of the engagement plan involves deceiving stakeholders. The plan is an informed-persuasion plan, not a manipulation plan. If the line has been crossed, the Stakeholder Liaison names it and the plan is revised.

**Decision gate — user:**

- **Approve the engagement plan** → hand to the user to execute.
- **Revise the plan first** → Strategic Planner returns to planning.
- **Defer** → note the trigger that would re-open the session.

## Completion Criteria

- [ ] Initiative anchor confirmed in Step 1
- [ ] Stakeholder list with interests captured in Step 2
- [ ] Power/interest grid complete in Step 3
- [ ] Ordered engagement plan in Step 4
- [ ] Objection rehearsal and ethical check in Step 5
- [ ] Alignment record written
```

---

## 3. Risk-Adjusted Decision

A tight workflow for high-stakes binary or small-N decisions where risk and scenario posture dominate. Led jointly by Risk Analyst and Scenario Modeler, arbitrated by the Decision Facilitator. Typically 20–30 minutes.

**`bmad-skill-risk-adjusted-decision/SKILL.md`**

```markdown
---
name: bmad-skill-risk-adjusted-decision
description: "Run a tight risk-adjusted decision workflow for a specific binary or small-N strategic choice. Produces a premortem, a scenario stress-test, a weighted decision matrix with risk adjustments, and an auditable decision record. Jointly led by the Risk Analyst and the Scenario Modeler, arbitrated by the Decision Facilitator. Use when a specific decision must be made under meaningful uncertainty."
argument-hint: "[--decision=<short-label>]"
---

# Risk-Adjusted Decision — Workflow Skill

A focused workflow for high-stakes decisions where the primary challenge is reasoning well under uncertainty, not generating options.

## On Activation

1. Invoke `bmad-init` with `--module=teams-strategy-team`.
2. Read and follow `./workflow.md`.
3. Output template is `./template.md`; save the decision record to `{output_folder}/strategy/decision-{slug}-{timestamp}.md`.

## Critical Success Factors

1. **Premortem before matrix** — identify failure modes before evaluating options.
2. **Scenario robustness as a first-class criterion** — not an afterthought.
3. **Risk appetite is a user input** — the team does not assume it.
4. **Documented dissent** — especially from the Risk Analyst, whose job is to say the hard thing plainly.
5. **User decides** — the workflow ends in a user decision gate.
```

**`bmad-skill-risk-adjusted-decision/workflow.md`**

```markdown
# Risk-Adjusted Decision — Workflow

A five-step tight-cycle workflow for a single decision under meaningful uncertainty.

## Participating Agents

| Agent | Role |
|-------|------|
| `bmad-agent-risk-analyst` | Co-lead; premortem; risk register |
| `bmad-agent-scenario-modeler` | Co-lead; scenario stress-test |
| `bmad-agent-decision-facilitator` | Arbitrator; matrix; decision record |
| `bmad-agent-strategic-planner` | Frames; holds the horizon |
| `bmad-agent-stakeholder-liaison` | Political feasibility check |
| `bmad-agent-implementation-coordinator` | Execution feasibility check |

## Step 1 — Frame the Decision and Elicit Risk Appetite
**Lead:** `bmad-agent-strategic-planner` (frame) + `bmad-agent-risk-analyst` (risk appetite)

The Strategic Planner states the decision: specific options, horizon, reversibility (reversible? one-way door?), and what is at stake.

The Risk Analyst asks the user two calibration questions:

1. "What's the worst outcome you could accept and still sleep at night?"
2. "What's the best outcome that would still feel worth the risk taken to get there?"

These calibrate the team's risk appetite for this specific decision — which is almost always different from the organization's general risk posture.

**Output:** decision frame and explicit risk-appetite statement.

## Step 2 — Premortem
**Lead:** `bmad-agent-risk-analyst`

The Risk Analyst leads a premortem on each candidate option. For each option, the team assumes it has failed 18 months from now and names the three most likely failure modes. Each failure mode is attached to a lens: was it risk (probability × impact), scenario (wrong assumption about the future), stakeholder (political resistance), or execution (capacity / dependency)?

**Output:** premortem summary per option — at most a half-page each.

## Step 3 — Scenario Stress-Test
**Lead:** `bmad-agent-scenario-modeler`

The Scenario Modeler builds a 2×2 around the two drivers with the most uncertainty and the most impact. For each of the four futures, mark each option as *survives*, *struggles*, or *fails*. Options that survive all four are robust; options that fail in any future where the probability is non-trivial carry an asterisk.

**Output:** 2×2 grid with option-survival ratings.

## Step 4 — Weighted Matrix with Risk Adjustments
**Lead:** `bmad-agent-decision-facilitator`

The Decision Facilitator builds a weighted decision matrix. Criteria include:

- **Expected value** (strategic fit × probability of success)
- **Downside severity** (worst credible case, weighted by probability)
- **Scenario robustness** (from Step 3)
- **Political feasibility** (from the Stakeholder Liaison)
- **Execution feasibility** (from the Implementation Coordinator)
- **Reversibility** (how easily can we back out?)

Criteria are weighted according to the risk appetite elicited in Step 1. High appetite → expected value dominates. Low appetite → downside severity and reversibility dominate.

**Output:** weighted, risk-adjusted decision matrix.

## Step 5 — Dissent Capture and User Decision
**Lead:** `bmad-agent-decision-facilitator`
**Participants:** all agents, then user

The Decision Facilitator asks each agent, by name: do you consent to the matrix-winning option? Dissent is captured in the decision record, with the dissenter's reasoning.

The Risk Analyst has one explicit opportunity to say, plainly and once, any severe concern. Using it is not grandstanding; it is part of the workflow, and it is binding on the Risk Analyst (they say it once, clearly, and then defer).

**Decision gate — user:**

- **Accept the matrix-winning option** → Implementation Coordinator starts a first-90-days plan.
- **Accept a different option** → Decision Facilitator records the override and the reason; Risk Analyst updates the risk register for the chosen option.
- **Defer** → Decision Facilitator records the deferral trigger.

## Completion Criteria

- [ ] Frame and risk appetite captured in Step 1
- [ ] Premortem complete per option in Step 2
- [ ] Scenario stress-test grid in Step 3
- [ ] Risk-adjusted matrix in Step 4
- [ ] Dissent explicitly captured in Step 5
- [ ] User decision or explicit deferral at end
- [ ] Decision record written
```

---

## What these workflows have in common

- **Framing is a step, not an assumption.** Every workflow starts by making the decision and its constraints explicit.
- **Every lens that is represented, speaks.** No lens is skipped to save time.
- **Synthesis is structured, not vibes.** Matrices, grids, premortems — the forms are the scaffolding that lets the thinking land.
- **Dissent is captured explicitly.** The Decision Facilitator asks each agent by name. Suppressed dissent becomes debt.
- **Every workflow ends with a user decision gate.** The team does not decide; the user does, on an informed basis.
- **Outputs are auditable records** — written to `{output_folder}/strategy/`, with the reasoning visible, so that when assumptions change the decision can be re-opened cleanly instead of re-debated from scratch.

**Learn, don't copy.** When TeamBuilder generates a real planning team, it designs workflows specific to the user's decisions — this file is teaching material, not a template library.
