# Creative / Content Pattern — Example Workflows

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

> **Learn, don't copy.** These workflows exist so the generator can study how creative-process workflows are structured: staged review gates, real iteration loops, clear agent handoffs, and checkpoints where the human gets to weigh in. When you generate a creative-content team, design fresh workflows for the actual work they'll do. Never copy these verbatim.

---

## What makes a creative-content workflow work

1. **Clear agent assignment at every step.** "The team reviews the draft" is not a step. "Priya runs editorial + voice review, Dee runs SEO pass" is a step.
2. **Review gates are separate from revision.** A gate produces feedback; a revision incorporates it. Conflating them produces mush.
3. **Iteration loops are bounded.** "Revise until perfect" is a recipe for thrash. "Up to two revision cycles, then ship or escalate" is a workflow.
4. **User checkpoints at the moments they matter.** The user approves the brief (not the topic brainstorm) and the final draft (not the line edits). Don't interrupt them for every handoff.
5. **Outputs are concrete files in a specific place.** Briefs, drafts, review notes, and final pieces all land in predictable paths so the team can find them later.
6. **Markdown step headers** (`## Step N — Goal`), never XML, never pseudo-code blocks.

The four examples below cover the full creative lifecycle from idea to published piece plus two specialized passes that run on demand.

---

## Workflow 1 — Content Brief Creation

**Purpose:** Turn a raw idea ("we should write about onboarding") into a brief the Writer can actually work from.

**When to run:** At the start of any new piece, before the Writer touches it.

**Outputs:** `{output_folder}/teams/{team-name}/briefs/brief-{slug}-{timestamp}.md`

### `skills/bmad-skill-content-brief/SKILL.md`

````markdown
---
name: bmad-skill-content-brief
description: "Turn a raw content idea into a production-ready brief covering audience, job-to-be-done, angle, takeaway, format, success criteria, and guardrails. Runs the ideation phase of the content creation workflow. Led by the Content Strategist with input from Audience Insights, and produces a brief the Writer can draft from without further clarification."
---

# Content Brief Creation — Workflow Skill

First stage of the creative content lifecycle. Produces a brief rigorous enough that the Writer never has to ask "who's this for?" mid-draft.

## On Activation

1. Invoke `bmad-init` with `--module=teams-creative-content-team`.
2. Load `./workflow.md` and follow it step by step.
3. Fill in `./template.md` with captured variables and write to `{output_folder}/teams/{team-name}/briefs/brief-{slug}-{timestamp}.md`.
4. Return the brief path to the caller.

## Critical Success Factors

- Every brief names a specific reader and a specific takeaway. No "thought leadership for decision-makers."
- Every brief has a kill condition — the scenario under which the strategist would walk away from the piece.
- The Writer approves the brief before drafting. No surprise briefs.

## Execution

Follow `./workflow.md`.
````

### `skills/bmad-skill-content-brief/workflow.md`

````markdown
# Content Brief Creation — Workflow

Seven steps. Led by `bmad-agent-content-strategist` with one consult from `bmad-agent-audience-insights` and one handoff to `bmad-agent-senior-writer`.

## Variables to Capture

```yaml
raw_idea: ""
target_reader: ""
reader_job: ""              # jobs-to-be-done framing
angle: ""
one_sentence_takeaway: ""
format: ""                  # blog-post, long-form, listicle, case-study, newsletter, etc.
target_length: ""
success_criteria: ""
guardrails: ""              # topics to avoid, sensitivities, legal notes
kill_condition: ""
brief_slug: ""
```

## Step 1 — Capture the Raw Idea

**Agent:** `bmad-agent-content-strategist`
**Action:** Ask the user for the idea in their own words. Don't edit yet; just capture.
**Output:** `raw_idea`

## Step 2 — Pressure-Test the Reader

**Agent:** `bmad-agent-content-strategist` consulting `bmad-agent-audience-insights`
**Action:** Margaux asks who this is for. Rafael pressure-tests the answer against real evidence: do we have interviews, tickets, or reviews that point to this reader having this problem? Mark the reader as Supported / Stale / Unsupported.
**Output:** `target_reader`, `reader_job`
**Checkpoint:** If the reader is Unsupported, flag it explicitly in the brief. Do not silently proceed.

## Step 3 — Find the Angle

**Agent:** `bmad-agent-content-strategist`
**Action:** Propose three angles — audience-pain, contrarian, evergreen. Recommend one. Note the trade-offs of the other two in the brief.
**Output:** `angle`

## Step 4 — Write the One-Sentence Takeaway

**Agent:** `bmad-agent-content-strategist`
**Action:** "By the end of this piece, the reader should be able to X." If you can't finish that sentence in one line, the brief isn't ready.
**Output:** `one_sentence_takeaway`

## Step 5 — Format, Length, and Success Criteria

**Agent:** `bmad-agent-content-strategist`
**Action:** Decide format and target length. Define success: what makes this piece worth having shipped? Engagement? Rankings? Sales enablement? Pipeline? Pick one primary, one secondary.
**Output:** `format`, `target_length`, `success_criteria`

## Step 6 — Guardrails and Kill Condition

**Agent:** `bmad-agent-content-strategist`
**Action:** Note topics to avoid, legal sensitivities, competitor mentions, and anything else that would cause a last-minute revision. Then name the kill condition: under what circumstances would you walk away from this piece?
**Output:** `guardrails`, `kill_condition`

## Step 7 — Writer Handoff and Approval

**Agent:** `bmad-agent-content-strategist` → `bmad-agent-senior-writer`
**Action:** Write the brief to `{output_folder}/teams/{team-name}/briefs/brief-{brief_slug}-{timestamp}.md` using `./template.md`. Present it to Theo. Theo confirms the brief is draftable or returns it with clarifying questions.
**User checkpoint:** After Theo confirms, present the brief to the user for sign-off before drafting begins.
**Output:** Finalized brief file path.

## Quality Markers

- Target reader is named specifically (not "marketers" — "heads of demand gen at Series B SaaS companies with 10–50 person marketing teams").
- Takeaway is one sentence.
- Kill condition is named.
- Writer has approved the brief.
````

---

## Workflow 2 — Draft & Refine Loop

**Purpose:** Take an approved brief through draft, review, and revision cycles until it's ready to ship.

**When to run:** After the brief is approved by the user and the Writer.

**Outputs:** `{output_folder}/teams/{team-name}/drafts/{slug}-v{n}.md`, final at `{output_folder}/teams/{team-name}/published/{slug}.md`

### `skills/bmad-skill-draft-and-refine/SKILL.md`

````markdown
---
name: bmad-skill-draft-and-refine
description: "Turn an approved brief into a shipped piece through a bounded draft → review → revise loop. Owned by the Senior Writer with the Brand Editor running the review gate and the SEO Lead running the optimization pass. Caps revision cycles at two and escalates cleanly if the piece isn't converging."
---

# Draft & Refine Loop — Workflow Skill

Core production workflow for the creative team. Strict on two things: review gates are separate from revision, and iteration is bounded.

## On Activation

1. Invoke `bmad-init` with `--module=teams-creative-content-team`.
2. Confirm an approved brief exists at the path provided by the caller; abort if not.
3. Load `./workflow.md` and follow it step by step.
4. Write each draft version to `{output_folder}/teams/{team-name}/drafts/{slug}-v{n}.md`.
5. On ship, promote the final draft to `{output_folder}/teams/{team-name}/published/{slug}.md`.

## Critical Success Factors

- The Writer drafts alone. No committee drafting.
- Review gates produce feedback; revisions incorporate it. Never blur them.
- Two revision cycles max. If the piece isn't converging, escalate to the Strategist.

## Execution

Follow `./workflow.md`.
````

### `skills/bmad-skill-draft-and-refine/workflow.md`

````markdown
# Draft & Refine Loop — Workflow

Six steps with a bounded revision loop at steps 3–4. Led by `bmad-agent-senior-writer` with the review gate run by `bmad-agent-brand-editor` and the optimization pass by `bmad-agent-seo-discoverability`.

## Step 1 — First Draft (Solo)

**Agent:** `bmad-agent-senior-writer` (alone — no committee)
**Inputs:** approved brief
**Action:** Theo drafts. First pass for structure, second pass for rhythm. Ugly is fine; thin is not. Output lands at `{output_folder}/teams/{team-name}/drafts/{slug}-v1.md`.
**Output:** `{slug}-v1.md`
**Time expectation:** 30–90 minutes of drafting time depending on length.

## Step 2 — Combined Review Gate

**Agent:** `bmad-agent-brand-editor`
**Inputs:** `{slug}-v1.md`, brand voice guide, brief
**Action:** Priya runs the combined editorial + brand voice review in a single pass: structural, line-level, and voice. Marks issues by severity (blocker / should-fix / nice-to-have) and offers a rewrite for every blocker. Writes review notes alongside the draft.
**Output:** `{slug}-v1-review.md`
**Rule:** Priya does not rewrite the piece at this step. She marks and suggests. The Writer owns the prose.

## Step 3 — Revision (Cycle 1)

**Agent:** `bmad-agent-senior-writer`
**Inputs:** `{slug}-v1.md`, `{slug}-v1-review.md`
**Action:** Theo works through blockers first, should-fixes second, nice-to-haves if time permits. He can push back on any single note by naming the craft reason, but the default is to take the feedback. Writes `{slug}-v2.md`.
**Output:** `{slug}-v2.md`

## Step 4 — Second-Pass Review and Optional Cycle 2

**Agent:** `bmad-agent-brand-editor` (then conditionally back to Writer)
**Action:** Priya re-reviews v2. Outcome is one of three:
  - **Ready for optimization** — green-light, move to Step 5.
  - **One more cycle** — specific remaining blockers only. Theo writes v3. Maximum one more loop.
  - **Escalate** — if the piece still isn't working after two cycles, escalate to `bmad-agent-content-strategist` to decide: ship, rework the brief, or kill.
**Output:** `{slug}-v2-review.md`, possibly `{slug}-v3.md` and `{slug}-v3-review.md`, possibly an escalation note.
**Hard cap:** No more than two revision cycles at this step.

## Step 5 — SEO & Discoverability Pass

**Agent:** `bmad-agent-seo-discoverability`
**Inputs:** latest approved draft
**Action:** Dee runs the optimization pass: H1/H2 structure, primary and secondary terms, internal links, metadata (title tag + meta description as mini writing assignments), schema if relevant. She proposes changes; the Writer accepts or rejects each one. She walks back any suggestion that hurts readability. Writes final draft.
**Output:** `{slug}-final.md`, `{slug}-metadata.md`
**Rule:** No keyword-stuffing the opening paragraph. Opening is the reader's contract.

## Step 6 — Ship Decision

**Agent:** `bmad-agent-content-strategist`
**Inputs:** `{slug}-final.md`, review history
**Action:** Margaux makes the final call. If everything checks out, promote to `{output_folder}/teams/{team-name}/published/{slug}.md` and hand back to the user for actual publication on their CMS. If not, escalate with a clear reason.
**User checkpoint:** Present the final draft to the user for sign-off before promotion.
**Output:** `published/{slug}.md`

## Iteration Budget

| Phase | Max cycles |
|-------|------------|
| Draft → Review (step 2–3) | 1 required |
| Review → Revise (step 4) | Up to 1 more |
| SEO pass (step 5) | 1 only |

Total revision cycles: **2 maximum** before escalation.

## Quality Markers

- Writer drafted alone, without stakeholder drafting-by-committee.
- Review notes named specific voice dimensions, not vibes.
- Every blocker came with a rewrite suggestion.
- SEO pass did not break the opening paragraph.
- User signed off on the final draft before promotion.
````

---

## Workflow 3 — Brand Voice Audit

**Purpose:** Audit an existing corpus (campaign, series, website section) for voice consistency and drift.

**When to run:** Quarterly, after a brand refresh, or when the team suspects voice has drifted across multiple writers.

**Outputs:** `{output_folder}/teams/{team-name}/audits/voice-audit-{scope}-{timestamp}.md`

### `skills/bmad-skill-brand-voice-audit/SKILL.md`

````markdown
---
name: bmad-skill-brand-voice-audit
description: "Audit an existing set of published pieces for brand voice consistency, voice drift, and voice guide gaps. Owned by the Brand Editor with the Audience Insights Analyst contributing reader-perception evidence. Produces a structured audit report with severity-ranked findings and concrete voice guide updates."
---

# Brand Voice Audit — Workflow Skill

Retrospective workflow. Not part of the production loop; run on demand when voice drift is suspected or after a brand refresh.

## On Activation

1. Invoke `bmad-init` with `--module=teams-creative-content-team`.
2. Load the current brand voice guide and the list of pieces to audit.
3. Load `./workflow.md` and follow it step by step.

## Critical Success Factors

- Use the voice dimensions from the guide, not vibes.
- Cite real sentences from real pieces. No abstraction without evidence.
- Every finding has a concrete voice guide update proposal.

## Execution

Follow `./workflow.md`.
````

### `skills/bmad-skill-brand-voice-audit/workflow.md`

````markdown
# Brand Voice Audit — Workflow

Five steps. Led by `bmad-agent-brand-editor` with evidence from `bmad-agent-audience-insights`.

## Step 1 — Define the Audit Scope

**Agent:** `bmad-agent-brand-editor`
**Action:** Name the corpus: which pieces, which time range, which channels. Typically 10–30 pieces for a meaningful audit. Fewer is anecdotal; more is exhausting and no clearer.
**Output:** `audit_scope`

## Step 2 — Score Each Piece Against Voice Dimensions

**Agent:** `bmad-agent-brand-editor`
**Action:** For each piece, score the relevant voice dimensions from the guide (warmth, precision, wit, authority, plainness, or whatever the actual guide uses) on a 1–5 scale. Mark drift with a concrete example sentence. Do not abstract; quote.
**Output:** `piece_scores`, `drift_examples`

## Step 3 — Reader-Perception Check

**Agent:** `bmad-agent-audience-insights`
**Action:** Rafael pulls any available reader evidence — review comments, support tickets mentioning content, interview quotes about how the brand "sounds" — and cross-references with the drift examples. Note cases where the voice on the page and the voice the reader perceives diverge.
**Output:** `reader_perception_notes`

## Step 4 — Pattern Identification

**Agent:** `bmad-agent-brand-editor`
**Action:** Step back from the piece-by-piece scoring and identify patterns. Is drift happening along a specific dimension? A specific writer? A specific content type? A specific time period? Rank patterns by severity.
**Output:** `drift_patterns`

## Step 5 — Audit Report and Voice Guide Update

**Agent:** `bmad-agent-brand-editor`
**Action:** Write the report. Include scope, scores, drift examples, reader-perception notes, patterns, and concrete voice guide updates (not "clarify warmth" — actual proposed language with before/after examples). Write to `{output_folder}/teams/{team-name}/audits/voice-audit-{scope}-{timestamp}.md`.
**User checkpoint:** Present the report and proposed voice guide updates for user approval before updating the guide.
**Output:** Audit report, optional voice guide patch.

## Quality Markers

- Scope is specific and bounded.
- Every drift finding has a quoted example.
- Reader-perception evidence is cited, not inferred.
- Voice guide updates are actual language, not directives to "clarify."
````

---

## Workflow 4 — Performance Triage Pass

**Purpose:** Take a live piece that's underperforming and decide what to do about it.

**When to run:** 30–60 days after publication, or when a piece is flagged by analytics as dramatically under- or over-performing.

**Outputs:** `{output_folder}/teams/{team-name}/triage/{slug}-triage-{timestamp}.md`

### `skills/bmad-skill-performance-triage/SKILL.md`

````markdown
---
name: bmad-skill-performance-triage
description: "Triage a live piece that's underperforming and decide whether to refresh, rewrite, repurpose, or retire it. Led by the SEO Lead with input from the Audience Insights Analyst and the Content Strategist. Produces a triage verdict and an action plan."
---

# Performance Triage — Workflow Skill

Short, bounded workflow. Not an audit — the point is a decision, not a report.

## On Activation

1. Invoke `bmad-init` with `--module=teams-creative-content-team`.
2. Confirm the piece exists and analytics data is accessible.
3. Load `./workflow.md` and follow it step by step.

## Critical Success Factors

- Decision-first, not analysis-first. You're picking one of four verdicts.
- 80/20 on fixes. Two or three changes, not forty.
- Escalate to a new brief if the piece needs a rewrite — don't patch a broken foundation.

## Execution

Follow `./workflow.md`.
````

### `skills/bmad-skill-performance-triage/workflow.md`

````markdown
# Performance Triage — Workflow

Four steps. Led by `bmad-agent-seo-discoverability` with consults from `bmad-agent-audience-insights` and `bmad-agent-content-strategist`.

## Step 1 — Read the Signals

**Agent:** `bmad-agent-seo-discoverability`
**Action:** Dee pulls the data: rankings, impressions, CTR, time-on-page, scroll depth, conversion path if relevant. Three questions only:
  1. Is it being seen (impressions)?
  2. Is it being clicked (CTR)?
  3. Is it being read (engagement)?
**Output:** `signal_read`

## Step 2 — Reader Evidence Consult

**Agent:** `bmad-agent-audience-insights`
**Action:** Rafael adds qualitative evidence if any exists — comments, reader feedback, support mentions. Five minutes, not five days. If there's nothing, say so; don't fabricate.
**Output:** `qual_evidence`

## Step 3 — Pick a Verdict

**Agent:** `bmad-agent-seo-discoverability` in consultation with `bmad-agent-content-strategist`
**Action:** Pick exactly one of:
  - **Refresh** — piece is sound, needs minor updates (new data, internal links, metadata rewrite). Two to three fixes, budgeted for an hour.
  - **Rewrite** — thesis is sound but execution is broken. Back to brief → draft loop.
  - **Repurpose** — take the good parts and use them somewhere else (newsletter, social, pillar page). Don't refresh the original.
  - **Retire** — piece no longer serves the audience or the brand. Take it down or no-index.
**Output:** `verdict`, `rationale`

## Step 4 — Action Plan and Owner

**Agent:** `bmad-agent-content-strategist`
**Action:** Margaux writes the action plan to `{output_folder}/teams/{team-name}/triage/{slug}-triage-{timestamp}.md`: verdict, rationale, specific changes, owner, and deadline. If verdict is Rewrite, create a new brief via `bmad-skill-content-brief` and link to it.
**User checkpoint:** Present the verdict and action plan to the user for approval before executing.
**Output:** Triage report, optional new brief link.

## Quality Markers

- Verdict is one of the four, not a hedge.
- Fixes are named specifically, not as "update and improve."
- Rewrite verdict always loops back through the brief workflow, not a direct patch.
````

---

## Cross-workflow notes

- **The Strategist owns the top and bottom of the lifecycle** (brief and ship decision). The Writer owns the middle. The Brand Editor and SEO Lead are gates, not drivers.
- **User checkpoints appear three times in the full lifecycle:** brief sign-off, final draft sign-off, triage verdict sign-off. Not every handoff.
- **Every workflow writes to `{output_folder}/teams/{team-name}/...`** — never to hardcoded `_bmad/teams/...` paths. The `output_folder` variable comes from `bmad-init`.
- **No XML tags, no pseudo-code blocks.** Markdown step headers (`## Step N — Goal`), agent names in backticks, fenced code blocks only for file content or config.

---

## Final reminder

**Learn, don't copy.** When you generate a creative-content team for the actual user in front of you, design workflows for the actual work they ship. A team that only writes newsletters doesn't need a Performance Triage workflow. A team doing one-off campaign copy doesn't need a quarterly voice audit. Apply the principles — bounded iteration, clear gate vs. revision separation, specific agent assignment, user checkpoints at the moments that matter — to whatever shape the user's work actually takes.
