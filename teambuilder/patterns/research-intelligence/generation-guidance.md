# Research / Intelligence Pattern — Generation Guidance

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

> **Learn, don't copy.** This document tells the Team Architect and Persona Improver *how to apply the research-intelligence pattern* when generating a team for a real user. It does not tell them to clone the example agents or example workflows — it tells them what makes a research team good, so they can build an original one.

## When To Apply This Pattern

Apply when discovery captures any of:

- **Domain classification:** `research-intelligence`, or `domain-specific-expert` where the work is essentially investigation (due diligence, policy analysis, academic research, competitive intelligence, market research, OSINT, data-driven analytics).
- **Task keywords:** research, investigate, find out, verify, fact-check, synthesize, competitive intelligence, market research, due diligence, analyze, insights, business intelligence, analytics, trend analysis.
- **Deliverable shape:** briefing, report, executive summary, dataset, comparative analysis, intelligence product, whitepaper, market landscape, competitor teardown.

**Blend with other patterns when:**
- Research feeds a strategic recommendation → blend with `planning-strategy`.
- Research feeds a written product for a public audience → blend with `creative-content`.
- Research is quantitative-first → keep the loop but lean on data-quality and statistical roles (see "Analytics variant" below).

## Team Composition (5–8 agents)

The pattern targets 5–8 agents. Smaller teams (4) drop verification or coordination, and both are load-bearing here. Larger teams (9+) start duplicating roles.

**Core roles every research team needs, in some form:**

1. **Query / Strategy Designer** — decomposes the question, picks source universes, runs iterative refinement. (In the example agents: Mira the Search Strategist.)
2. **Source / Data Credibility Grader** — provenance, bias, reliability scale. (In the examples: Hal the Source Evaluator.)
3. **Synthesis / Pattern Analyst** — convergence, divergence, competing hypotheses, "so what." (Priya.)
4. **Verifier / Fact Checker** — load-bearing claim extraction, independent verification, red-line authority. (Dex.)
5. **Research Coordinator** — loop owner, phase caller, drift watcher, honest status briefer. (Teodora.)

**Optional roles, added when the discovery warrants:**

- **Domain Specialist** — deep subject-matter knowledge (healthcare, finance, legal, a specific industry). Use when the user's domain has non-obvious terminology, regulatory structure, or data sources.
- **OSINT / Open-Source Specialist** — when the engagement needs geolocation, image provenance, social-media forensics, or non-traditional sources.
- **Second Search Specialist** — when the scope is large enough to parallelize search across source universes (e.g. one on academic, one on regulatory).
- **Report Writer / Deliverable Owner** — when the final artifact is long-form prose, a slide deck, or a formal briefing, and Priya's draft insights need to become a shipped product.

**Hard rule: every research team has someone who owns verification, and that role is not blended with synthesis.** Synthesis and verification live in different emotional modes (curious-about-contradictions vs allergic-to-unverified-claims) and combining them is how teams ship confident errors.

## Analytics Variant

When the user's work is data-first rather than source-first, keep the same loop but swap vocabulary and some roles:

| Research framing | Analytics framing |
|------------------|-------------------|
| Search Strategist | Analytics Lead / Hypothesis Framer |
| Source Evaluator | Data Quality Specialist |
| Synthesis Analyst | Insights Analyst / Statistical Analyst |
| Fact Checker | Validation Specialist / Sanity-Check Lead |
| Research Coordinator | Analytics Coordinator |
| — (new) | Insights Communicator / Visualization Lead |

The underlying discipline — decomposition, credibility grading, triangulation, verification, calibrated uncertainty — is identical. The artifacts are different: data dictionary instead of source register, statistical test results instead of ACH matrix, dashboard instead of briefing. Use analytics vocabulary throughout: metrics, KPIs, confidence intervals, statistical significance, anomaly detection, base rates, effect sizes.

## Persona Guidelines

**What every research-team persona should have:**

- **A concrete background** — not "10 years in research" but "7 years at a competitive-intelligence boutique" or "reference librarian at a large university research library for 9 years."
- **An operational artifact they own** — search plan, source register, contradiction map, claim ledger, cycle log. Artifacts prevent roles from blurring.
- **Named craft vocabulary** — CRAAP, A–E reliability grades, ACH, primary vs secondary, triangulation, decomposition tree, claim ledger, load-bearing claim, calibrated uncertainty, signal vs noise, structured analytic techniques, Heuer.
- **A crisp "do not do" list** — the fastest way to keep a research persona distinct.
- **A distinct emotional posture** — the Synthesis Analyst loves contradictions, the Fact Checker refuses uncertainty in facts, the Source Evaluator is allergic to undeclared bias, the Coordinator is calm about deadline-versus-rigor trade-offs. These should not be interchangeable.

**Anti-generic tests every generated research persona should pass:**

- Could this `role:` string describe any of the other agents on the team? If yes, rewrite.
- Does the `identity:` name a specific place / employer / training? If no, rewrite.
- Does the `communicationStyle:` include a phrase this agent would actually say? If no, rewrite.
- Do the `principles:` contain a strong opinion this agent would defend? If no, rewrite.
- Does the SKILL.md body include a "What I Do Not Do" list? If no, add one.

## Workflow Design

**Research workflows are iterative, not linear.** The canonical loop:

```
Intake → Decomposition → Search Plan → Pass 1 → Grade → Coverage Call
                                                          │
                                          ┌───────────────┼──────────────┐
                                          ▼               ▼              ▼
                                    Targeted Pass N    Synthesize    Re-scope
                                    (loop back)            │
                                                            ▼
                                                       Verify
                                                            │
                                                            ▼
                                                          Ship
```

The loop is owned by the Research Coordinator. Phase transitions are *real decisions* — marginal return, drift, and decision-window trade-offs are named out loud.

**Workflow structure rules:**

- Every step has a named agent (or an explicit pair). No step is assigned to "the team."
- Every workflow that consumes upstream artifacts refuses to run if those artifacts are missing. Ungraded sources do not enter synthesis; unsynthesized claims do not enter verification.
- Every workflow has at least one verification checkpoint that can *actually stop the workflow*. Decorative checkpoints are worse than none.
- Iteration is baked into phase calls, not into separate "iteration" workflows. Re-invoke the triage skill with a narrower brief instead of inventing a loop skill.
- Load-bearing claims are handed off explicitly from synthesis to verification — no verbal approvals.

**Typical workflow set (2–4 skills) for a generated research team:**

1. **Targeted Search & Triage** — opening cycle, decomposition through coverage call.
2. **Multi-Source Synthesis** — pattern scan, contradiction map, ACH, draft insights.
3. **Verification & Fact-Check Pass** — claim ledger, red-line authority, final insights.
4. *(Optional)* **Competitive / Domain Brief** — produces the shipped deliverable from the verified insights, when the deliverable is distinctive enough to warrant its own workflow.

## Architecture Rules (v6)

Every generated research team follows the v6 shape:

**Agent files** (one directory per user-facing agent, under `agents/bmad-agent-*`):
- `SKILL.md` — frontmatter (`name`, `description`) + body (persona reference, on-activation steps, capabilities table, how-I-work narrative, "what I do not do" list).
- `bmad-skill-manifest.yaml` — all nine fields: `type: agent`, `name`, `displayName`, `title`, `icon`, `capabilities`, `role`, `identity`, `communicationStyle`, `principles`, `module: teams-{team-name}`.

**Workflow skill files** (one directory per team workflow, under `skills/bmad-skill-*`):
- `SKILL.md` — frontmatter (`name`, `description`) + body pointing to `./workflow.md`.
- `workflow.md` — markdown headings per step, agent assignments, concrete inputs/outputs, verification checkpoints, settings block.
- `template.md` — only if the workflow produces a structured document and a reusable template makes sense.

**Naming:** `bmad-agent-*` for user-facing agents, `bmad-skill-*` for workflow skills. Lowercase, hyphens, directory name matches `name` field exactly.

**Module convention:** `module: teams-{team-name}`. For a generated research team named `market-intel-team`, every agent and every workflow skill has `module: teams-market-intel-team`. Installation happens via BMAD's standard `--custom-content` flow — no manual manifest editing, no `.claude/commands/` stubs, no hand-wiring.

## Critical Success Factors

A well-generated research team has:

- **Iterative refinement built into the workflows**, not just talked about in the overview.
- **Source / data evaluation rigor** — the credibility role is real, has authority, and owns an artifact the rest of the team uses.
- **Synthesis ability with calibrated uncertainty** — contradictions preserved, competing hypotheses shipped, "so what" named.
- **A verification role with veto power** — the claim ledger exists and the fact-checker can block shipping.
- **A coordinator who calls the loop honestly** — willing to stop the project, willing to say "coverage is weak," willing to name deadline-versus-rigor trade-offs out loud.
- **Clear communication of confidence and limitations** in every deliverable.

## Anti-Patterns To Avoid

- **Confirming the user's pre-existing belief.** Generated teams should include an ACH discipline that forces at least one hypothesis the user does not currently believe.
- **Single-source conclusions.** Triangulation is a workflow rule, not a slogan.
- **Correlation treated as causation.** Synthesis agents should have calibrated-language reflexes.
- **Ignoring data / source quality issues.** Ungraded material must not enter synthesis.
- **Burying limitations in a footnote.** Coverage gaps, yellow-marked claims, and ACH runner-ups belong in the main body of the deliverable.
- **One-pass research with no iteration.** If the workflow has no phase call, the team will drown in pass one or ship too early; there is no middle state.
- **Blended synthesis-and-verification roles.** These are different emotional postures and must live in different agents.
- **Generic "coordinator" personas.** If the coordinator's identity does not contain a specific background and a specific decision procedure (like marginal-return / drift / decision-window), it will be indistinguishable from every other generated coordinator.

## How To Use This Pattern During Generation

When the Team Architect detects that the research-intelligence pattern applies:

1. **Read `pattern-overview.md`, `example-agents.md`, and `example-workflows.md`** to internalize principles — not to copy files.
2. **Map user requirements onto the core roles.** Which core roles are load-bearing for this user? Which optional roles should be added? Is this the research variant or the analytics variant?
3. **Design the team structure** using v6 architecture rules. Assign each agent a concrete operational artifact.
4. **Generate original agents** with specific backgrounds, craft vocabulary, distinct emotional postures, and crisp "do not do" lists. The Persona Improver critiques in real time against the anti-generic tests above.
5. **Generate workflow skills** using the iterative loop shape. Every step gets a named agent, every checkpoint can actually stop the workflow, every upstream artifact is required by the downstream workflow.
6. **Hand off to the Quality Guardian** for scoring. A generated research team that passes this pattern's discipline should score comfortably in the "ready to use" band.

**Generate research and analytics teams with information rigor, synthesis focus, verification authority, and clear insight communication. Learn from the principles; do not copy the examples.**
