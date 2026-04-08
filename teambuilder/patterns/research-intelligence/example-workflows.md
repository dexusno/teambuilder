# Research / Intelligence Pattern — Example Workflows

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

> **Learn, don't copy.** These three workflow skills illustrate the *shape* of good research workflows in v6 — iterative loops, explicit verification checkpoints, clear agent assignments at every step, and a coordinator who decides when to stop. A generated team should borrow the shape, not the filenames.

Each workflow below is shown as a complete skill directory: a `SKILL.md` that describes when to invoke the skill, and a `workflow.md` with step-by-step instructions. Agents are referenced by their `bmad-agent-*` names from `example-agents.md` (Mira the Search Strategist, Hal the Source Evaluator, Priya the Synthesis Analyst, Dex the Fact Checker, Teodora the Research Coordinator).

The `module` for these skills is `teams-research-team` — the same convention used by the agents.

---

## Workflow 1 — Targeted Search & Triage

The opening move. Turns a fuzzy question into a search plan, runs the first pass, grades the hits, and decides whether another pass is worth it. This is the workflow the team runs first on almost every engagement.

### `skills/bmad-skill-targeted-search-and-triage/SKILL.md`

```markdown
---
name: bmad-skill-targeted-search-and-triage
description: "Run the opening research cycle on a new or newly-refined question. Decomposes the question, designs a multi-source search plan, executes pass one, grades the results, and decides whether another pass is worth running. Use at the very start of a research engagement or whenever a prior cycle produced low signal and the team needs to reset. Produces a search plan, a source register, and a coverage report."
argument-hint: "[research-question]"
---

# Targeted Search & Triage — Workflow Skill

Opening cycle of the iterative research loop. This is where fuzzy asks become executable search plans, and where the team discovers whether the question is answerable from the sources available.

## Overview

Goal: produce a graded source register that covers enough of the decomposition tree to start synthesis — or, if that is not achievable, produce a crisp report of *why not* so the research engagement can be re-scoped before burning more time.

## On Activation

1. Invoke `bmad-init` with `--module=teams-research-team` to load configuration (`user_name`, `communication_language`, `output_folder`, research-team settings).
2. Expect either a raw research question from the user or a refined brief from `bmad-agent-research-coordinator`.
3. Load the workflow definition from `./workflow.md` and follow it step by step.
4. When complete, return control to the caller with paths to the search plan, the source register, and the coverage report.

## Critical Success Factors

1. **Decompose before searching.** No keywords until the question is broken into sub-questions.
2. **Pick source universes deliberately.** Different sub-questions belong in different archives.
3. **Grade as you go.** Ungraded hits are not findings.
4. **Call the cycle honestly.** If coverage is weak, say so; do not paper over gaps.
5. **Preserve the decomposition tree.** It is the spine the whole engagement leans on.

## Execution

Read fully and follow the instructions in `./workflow.md`.
```

### `skills/bmad-skill-targeted-search-and-triage/workflow.md`

```markdown
# Targeted Search & Triage — Workflow

Opening cycle of the iterative research loop. Five steps plus a decision point. The decision point is real — do not skip it.

## Step 1 — Intake & Decomposition
**Agent:** `bmad-agent-search-strategist` (Mira), with `bmad-agent-research-coordinator` (Teodora) observing.
**Inputs:** raw research question from the user, plus any existing context (prior cycle outputs, deliverable target, decision window).
**Outputs:** a decomposition tree — 3 to 7 sub-questions, each typed as factual, comparative, mechanistic, or forecasting.

**Actions:**
1. Mira restates the research question in one sentence and confirms it with the user or the calling workflow.
2. Mira names the decision or deliverable the research is feeding. No decision, no scope.
3. Mira breaks the question into 3–7 sub-questions, types each one, and flags any that are unanswerable from public sources (proposing proxies for those).
4. Teodora opens the cycle log with `Cycle 1 — intake` and records the decomposition tree as the baseline against which drift will later be measured.

**Checkpoint:** do not proceed if the user (or calling workflow) has not confirmed the decomposition tree. A bad decomposition here will cost three cycles to fix later.

## Step 2 — Source Universe Selection & Search Plan
**Agent:** Mira (alone).
**Inputs:** decomposition tree.
**Outputs:** search plan document. For each sub-question: (a) which source universes will be searched, (b) the query strategy for each, (c) an effort budget in minutes.

**Actions:**
1. For each sub-question, Mira picks source universes deliberately — academic, SEC/regulatory, industry analyst, OSINT/news, trade press, social (only for sentiment), internal archives. She justifies each choice in one sentence.
2. Mira drafts Boolean or faceted queries appropriate to each universe.
3. Mira assigns an effort budget per sub-question. Nothing gets an open-ended budget.
4. Mira explicitly notes known-biased sources she expects to hit so Hal isn't surprised.

**Checkpoint:** Teodora reviews the plan for coverage against the decomposition tree. If any sub-question has no plan, the tree or the plan is wrong.

## Step 3 — Pass-One Execution
**Agent:** Mira executes (or delegates to a search sub-skill), with results flowing to `bmad-agent-source-evaluator` (Hal) in small batches.
**Inputs:** search plan.
**Outputs:** raw hits tagged by sub-question and source universe, ready for grading.

**Actions:**
1. Mira runs queries in the order laid out in the plan.
2. She stops each sub-question at its effort budget whether she's satisfied or not — that's the point of the budget.
3. She hands hits to Hal in batches of 10–20 as they come in, so grading can run in parallel with searching.
4. She keeps a running note on which queries produced signal and which did not. This feeds query refinement in Step 5.

## Step 4 — Grading & Source Register
**Agent:** Hal (Source Evaluator).
**Inputs:** raw hits from Step 3.
**Outputs:** source register — every hit assigned an A / B / C / D / E grade, with a one-line note on provenance, date, and independence.

**Actions:**
1. Hal applies the CRAAP test and assigns an A–E grade to each source.
2. For any hit that looks independent but actually traces back to a single origin (wire-story recycling), Hal collapses it and notes the chain.
3. Hal flags single-source load-bearing claims with `FLAG-SINGLE-SOURCE` so Dex can pick them up later.
4. Hal emits a short provenance note on every C-grade-or-lower source. Ungraded hits do not enter the register.

**Checkpoint:** Hal has the authority to refuse entry to any source he cannot provenance. If a sub-question has no A- or B-grade sources after this step, the cycle is signaling a structural problem — record it in the cycle log.

## Step 5 — Coverage Report & Phase Call
**Agent:** Teodora (Coordinator), with Mira and Hal.
**Inputs:** decomposition tree, search plan, source register.
**Outputs:** coverage report and a phase-call decision.

**Actions:**
1. Teodora walks the decomposition tree and marks each sub-question as: *covered* (enough A/B sources), *thin* (only C-grade or fewer than expected), *dark* (no usable sources), or *drifted* (someone searched for something that isn't on the tree).
2. Teodora writes the coverage report in 10–15 lines, honest about gaps.
3. Teodora calls the phase transition in one sentence with a reason. Options:
   - **Proceed to synthesis** — enough coverage to hand to Priya.
   - **Run a targeted second pass** — re-open Step 2 for the thin or drifted branches only, not the whole tree. Route to this skill again with the refined brief.
   - **Re-scope with the user** — coverage is structurally weak; the question is not answerable as stated. Pause the engagement and brief the user.
4. Teodora updates the cycle log with the decision and reason.

**Verification checkpoint:** this is a real decision, not a formality. Teodora will not proceed to synthesis on coverage she judges weak, and she will not run a second pass just to feel thorough — marginal return is the call.

## Outputs Summary

- `search-plan-{timestamp}.md` — decomposition tree + query strategy + budgets
- `source-register-{timestamp}.md` — graded source list with provenance notes
- `coverage-report-{timestamp}.md` — tree coverage map + phase-call decision
- Entry in `cycle-log.md`

## Settings

```yaml
max_sub_questions: 7
min_sub_questions: 3
default_effort_budget_minutes_per_branch: 45
grades_accepted_into_register: ["A", "B", "C", "D"]   # E is logged but not used
require_coverage_report_before_synthesis: true
```
```

---

## Workflow 2 — Multi-Source Synthesis with Competing Hypotheses

The synthesis cycle. Takes the graded source register from Workflow 1 and turns it into a small number of load-bearing insights, with contradictions preserved and alternative hypotheses scored. This is where the research produces value — or fails to.

### `skills/bmad-skill-multi-source-synthesis/SKILL.md`

```markdown
---
name: bmad-skill-multi-source-synthesis
description: "Run the synthesis cycle on a graded source register. Produces a pattern scan, a contradiction map, an Analysis of Competing Hypotheses (ACH) matrix, and a draft insights document. Use after `bmad-skill-targeted-search-and-triage` has produced a coverage report that Teodora has called as ready for synthesis. Hands off load-bearing claims to the fact-check pass."
---

# Multi-Source Synthesis — Workflow Skill

Takes a graded source register and produces load-bearing insights without collapsing the contradictions that make the insights credible in the first place.

## Overview

Goal: deliver a draft insights document backed by a pattern scan, a contradiction map, and an ACH matrix. The output is *not* a final report — it is the synthesis layer the final report will later rest on.

## On Activation

1. Invoke `bmad-init` with `--module=teams-research-team`.
2. Require a source register produced by `bmad-skill-targeted-search-and-triage` and a coverage report in which the Research Coordinator has called the phase as ready for synthesis. If either is missing, refuse and route back to triage.
3. Load the workflow definition from `./workflow.md` and follow it step by step.

## Critical Success Factors

1. **Grade-gated input.** Never synthesize ungraded material.
2. **Contradictions are diagnostic.** Preserve them; do not smooth them away.
3. **ACH discipline.** Score each piece of evidence against each hypothesis; ship the whole matrix.
4. **Calibrated language.** "Consistent with," "weakly supports," "decisively rules out" — not "proves."
5. **Decision-facing.** Synthesis that doesn't answer "so what for the decision?" has not synthesized yet.

## Execution

Read fully and follow the instructions in `./workflow.md`.
```

### `skills/bmad-skill-multi-source-synthesis/workflow.md`

```markdown
# Multi-Source Synthesis — Workflow

Four steps. Run them in order. Do not let the draft insights move forward without the ACH matrix and the contradiction map behind them.

## Step 1 — Pattern Scan (Convergence)
**Agent:** `bmad-agent-synthesis-analyst` (Priya).
**Inputs:** graded source register, decomposition tree, coverage report.
**Outputs:** convergence map — where independent A/B sources agree, grouped by sub-question.

**Actions:**
1. Priya walks the decomposition tree sub-question by sub-question.
2. For each, she lists the claims on which independent A- or B-grade sources agree. Independence check: two sources that both cite the same primary do not count as two.
3. She names the convergence in one sentence per sub-question — the "cheap insight" layer.
4. She flags any claim where convergence exists but the load-bearing number is not yet verified — these go to Dex later.

## Step 2 — Divergence & Contradiction Map
**Agent:** Priya, with `bmad-agent-source-evaluator` (Hal) consulted on provenance questions.
**Inputs:** convergence map, source register.
**Outputs:** contradiction map — each disagreement typed by *kind* (definitional, measurement, time-period, standpoint, methodological) and attributed to which sources hold which position.

**Actions:**
1. Priya identifies every meaningful disagreement between graded sources. She wants these — they are the most informative part of the dataset.
2. She types each disagreement: definitional (they mean different things), measurement (they measured differently), time-period (the world changed between them), standpoint (known bias), methodological (different frameworks).
3. When the kind is unclear, she consults Hal on provenance before categorizing.
4. She writes a one-line gloss on each contradiction: *what would it take to resolve this?*

**Checkpoint:** a contradiction map with zero entries is almost always wrong. If the sources all agree, either the question is trivial or the sourcing is echo-chamber. Priya flags this to Teodora before proceeding.

## Step 3 — Analysis of Competing Hypotheses
**Agent:** Priya.
**Inputs:** convergence map, contradiction map, source register.
**Outputs:** ACH matrix — 3 to 5 hypotheses scored against each piece of diagnostic evidence as *consistent*, *inconsistent*, or *neutral*, plus a one-paragraph reading.

**Actions:**
1. Priya lists 3–5 hypotheses that could explain the evidence. She deliberately includes at least one she does not currently believe — ACH only works against an honest slate.
2. She scores every piece of diagnostic evidence against every hypothesis. Evidence that is *consistent with everything* is not diagnostic and is noted but not weighted.
3. She identifies the hypothesis with the fewest inconsistencies and writes a one-paragraph reading: the winning hypothesis, the runner-up, and the specific evidence that separates them.
4. She names what new evidence would flip the reading. This is the honest shelf-life of the synthesis.

## Step 4 — Draft Insights & Handoff
**Agent:** Priya, with `bmad-agent-research-coordinator` (Teodora) reviewing and `bmad-agent-fact-checker` (Dex) receiving the load-bearing-claim list.
**Inputs:** convergence map, contradiction map, ACH matrix.
**Outputs:** draft insights document + load-bearing-claim list for Dex.

**Actions:**
1. Priya writes the draft insights document: 3–7 insights, each in calibrated language, each traceable to the specific convergence / contradiction / ACH row it rests on.
2. Every insight ends with a one-line *so what* for the decision the research is feeding.
3. Priya pulls every load-bearing claim out of the insights — dates, numbers, quotes, attributions, causal chains — and hands the list to Dex for the fact-check pass.
4. Teodora reviews for premature certainty, smoothed contradictions, and drift away from the decomposition tree. She either calls the phase forward to verification or sends the draft back for revision. She does not mark up the prose — that's Priya's.

**Verification checkpoint:** no insight that rests on a C-grade-or-lower source ships to the fact-check pass without a hedge in the prose. This is a hard rule.

## Outputs Summary

- `convergence-map-{timestamp}.md`
- `contradiction-map-{timestamp}.md`
- `ach-matrix-{timestamp}.md`
- `draft-insights-{timestamp}.md`
- `load-bearing-claims-{timestamp}.md` (handed to Dex)
- Entry in `cycle-log.md`

## Settings

```yaml
min_hypotheses_in_ach: 3
max_hypotheses_in_ach: 5
require_contradiction_map: true        # empty contradiction map raises a flag
min_insights: 3
max_insights: 7
hedge_required_for_grade: ["C", "D"]
```
```

---

## Workflow 3 — Verification & Fact-Check Pass

The last mile. Pulls every load-bearing claim out of the draft, verifies each against independent sources, and produces the claim ledger. This is the only workflow in which a single agent holds a veto over shipping.

### `skills/bmad-skill-verification-and-fact-check/SKILL.md`

```markdown
---
name: bmad-skill-verification-and-fact-check
description: "Run the verification pass on a draft insights document or a near-final report. Extracts load-bearing claims, verifies each against independent sources, and produces a red/yellow/green claim ledger. Use after `bmad-skill-multi-source-synthesis` has produced draft insights that Teodora has called ready for verification. The Fact Checker holds a hard veto on any red-marked claim."
---

# Verification & Fact-Check Pass — Workflow Skill

Last cycle before the research ships. Every load-bearing claim in the draft gets independently verified or it does not ship as written.

## Overview

Goal: produce a claim ledger in which every load-bearing claim is green, or the draft is revised until they all are. Yellow claims require a hedge in the prose. Red claims cannot ship — period.

## On Activation

1. Invoke `bmad-init` with `--module=teams-research-team`.
2. Require a draft insights document (or near-final report) plus the load-bearing-claim list from `bmad-skill-multi-source-synthesis`, plus the source register. If any of these are missing, refuse.
3. Load the workflow definition from `./workflow.md` and follow it step by step.

## Critical Success Factors

1. **Independent verification is the rule, not the exception.** Re-citing the author against themselves is not verification.
2. **Every load-bearing claim gets a row.** No verbal approvals.
3. **Red lines are load-bearing.** The Fact Checker's veto is the whole point.
4. **Honest yellows.** A hedge in the prose is legitimate; fudging a claim into green is not.

## Execution

Read fully and follow the instructions in `./workflow.md`.
```

### `skills/bmad-skill-verification-and-fact-check/workflow.md`

```markdown
# Verification & Fact-Check Pass — Workflow

Three steps plus a dissent path. The dissent path is rare but it is not optional.

## Step 1 — Claim Extraction
**Agent:** `bmad-agent-fact-checker` (Dex), with `bmad-agent-synthesis-analyst` (Priya) on call for clarifying questions.
**Inputs:** draft insights document, load-bearing-claim list from synthesis.
**Outputs:** claim ledger (empty) — every load-bearing claim extracted verbatim into a ledger row.

**Actions:**
1. Dex walks the draft insights document and pulls every claim that would meaningfully change the reader's conclusion if it were wrong. Load-bearing means: dates, numbers, quotes, direct attributions, causal chains, named entities, and any "first / largest / only" superlatives.
2. Each claim goes into the ledger verbatim, with a pointer to where it sits in the draft.
3. Dex double-checks the list from synthesis against his own extraction. Claims Priya marked but Dex would not have, and vice versa, get discussed in a short exchange.
4. The ledger is empty at this point — no statuses yet.

**Checkpoint:** Dex does not start verification until the ledger is complete. Verifying while extracting leaks claims.

## Step 2 — Independent Verification
**Agent:** Dex.
**Inputs:** claim ledger, source register (for cross-reference only — the point is to verify against sources *other than* the one the draft cites), access to primary sources.
**Outputs:** claim ledger with every row marked green, yellow, or red, each with a note.

**Actions:**
1. For each claim, Dex identifies an independent source and verifies the claim against it. Independent means: not the source cited in the draft, and not a source that transitively cites the same primary.
2. He marks the row:
   - **Green** — independently verified, will stake his name on it.
   - **Yellow** — partially verified, or verified only against a non-A-grade source, or verified with caveats. The prose must hedge before ship.
   - **Red** — could not verify, or found contradicting evidence. Cannot ship as written.
3. Every status carries a note explaining *why*. "Green" with no note is the same as no approval.
4. For claims Dex cannot verify because the primary source does not exist in the form cited, he routes them to `bmad-agent-search-strategist` (Mira) for a targeted search — not to guess, but to confirm the primary is actually findable.
5. For quote claims, Dex traces to the original utterance. Close paraphrases flagged as quotes get red-marked.

**Checkpoint:** Dex refuses verification shortcuts regardless of deadline pressure. This is the moment bad claims slip through and Dex's job exists specifically to prevent that.

## Step 3 — Reconciliation & Ship Decision
**Agents:** Dex, Priya, and `bmad-agent-research-coordinator` (Teodora).
**Inputs:** completed claim ledger, draft insights document.
**Outputs:** final insights document ready for the deliverable layer, or a revised draft that goes back through this workflow.

**Actions:**
1. Dex presents the ledger. He reads the reds and yellows out loud — not the greens.
2. For each yellow, Priya either adds a hedge to the prose (preferred) or downgrades the claim to something the evidence actually supports.
3. For each red, the team has three options: (a) find independent corroboration and re-verify, (b) weaken the claim until it becomes defensible, or (c) cut the claim. Teodora calls which option applies.
4. The draft is revised. Dex re-verifies any changed rows.
5. When every row is green or yellow-with-hedge, Teodora calls the phase to *ship*.

**Dissent path:** if, after reconciliation, any claim Dex judged red is still in the draft unchanged, he files a one-paragraph written dissent in the claim ledger and the draft does not ship. This is the only hard veto in the entire research team's workflow stack. Teodora does not overrule it. The user can choose to override with eyes open, but they must do so explicitly in writing.

**Verification checkpoint:** this is the final gate. No load-bearing claim leaves this workflow unverified or unhedged.

## Outputs Summary

- `claim-ledger-{timestamp}.md` — every load-bearing claim with status and note
- `final-insights-{timestamp}.md` — revised draft ready to ship
- (rare) `fact-checker-dissent-{timestamp}.md` — only if Dex dissents
- Entry in `cycle-log.md`

## Settings

```yaml
require_independent_source_for_green: true
allow_hedge_for_yellow: true
block_ship_on_red: true
allow_user_override_of_dissent: true     # must be in writing
quote_verification_requires_primary_utterance: true
```
```

---

## What To Learn From These Three Workflows

1. **Every step has a named agent.** No step says "the team." Workflows that don't assign steps to agents are decoration.

2. **Verification checkpoints are real decisions, not formalities.** Teodora's phase call in Workflow 1, Priya's empty-contradiction-map flag in Workflow 2, and Dex's dissent path in Workflow 3 can all *stop the workflow*. If a checkpoint can't stop anything, it isn't a checkpoint.

3. **Workflows compose.** Workflow 1 produces what Workflow 2 consumes. Workflow 2 produces what Workflow 3 consumes. Each workflow refuses to run if its upstream inputs are missing, and that refusal is how the loop stays honest.

4. **The iterative loop lives in Workflow 1's Step 5.** "Run a targeted second pass" re-invokes the same skill with a narrower brief. You do not need a separate "iteration" workflow — the loop is built into the phase call.

5. **Output artifacts are files, not ideas.** Search plan, source register, coverage report, convergence map, contradiction map, ACH matrix, draft insights, claim ledger, final insights, cycle log. Each one is a concrete deliverable that later steps (or later workflows) can read.

Generate original research workflows in this spirit — borrow the shape and the discipline, not the filenames.
