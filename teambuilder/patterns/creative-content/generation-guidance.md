# Creative / Content Pattern — Generation Guidance

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

> **Learn, don't copy.** This is guidance for generating *original* creative-content teams by applying the pattern's principles — not for stamping out copies of the example agents in `example-agents.md`.

---

## When to Apply This Pattern

**Domain match:** `creative-content`

**Signal keywords:** content, writing, creative, marketing, blog, campaign, brand, editorial, copy, newsletter, social, storytelling, voice, audience.

**Strong fit:**
- Blog, long-form article, or newsletter production
- Marketing campaign copy (landing pages, emails, ads)
- Brand voice development or audit work
- Content strategy and editorial calendar work
- Audience-targeted writing where voice matters

**Weak fit (pick a different pattern):**
- Pure technical documentation with no voice dimension → technical-development
- Research reports with no creative craft dimension → research-intelligence
- Internal policy or governance documents → domain-specific-expert

---

## Composition Principles

### Team size: 4–7 agents

| Size | When |
|------|------|
| 4 agents | One-person solopreneur, single channel, simple content (newsletter only, blog only) |
| 5 agents | Most mid-market content teams — the core creative process with one specialist |
| 6–7 agents | Multi-channel operations, brand-heavy orgs, or teams with both top-of-funnel and bottom-of-funnel content |

**Do not exceed 7 for creative-content teams.** Beyond that, review gates start stepping on each other and the Writer ends up negotiating with a committee.

### Core roles (always present)

Every creative-content team needs these three functions. They can be split or combined based on size:

1. **Strategy / ideation** — decides what gets made and why. Owns briefs and the editorial calendar.
2. **Drafting / craft** — writes the prose. Owns the draft phase.
3. **Review gate** — editorial quality and brand voice. Can be one agent (Brand Editor) or two (separate Editor and Brand Voice Guardian) depending on team size.

### Specialist roles (add based on user's actual needs)

Add only if the user's work genuinely needs it — don't bulk the team up for theater:

- **Audience / reader researcher** — add if the team has access to qualitative evidence (interviews, tickets, reviews) and the user cares about reader-fit. Skip if the user has no research signal.
- **SEO / discoverability** — add if the content is published on an owned channel where organic search matters. Skip for closed newsletters, internal comms, or pure paid distribution.
- **Visual designer / art director** — add only if the team ships imagery alongside text. Never add for pure text teams.
- **Performance analyst** — add only if the user has analytics and cares about post-publish optimization. Skip if the user has no data signal.
- **Campaign producer** — add only for multi-piece campaign work with scheduling complexity. Skip for editorial blog production.

**Rule of thumb:** if you can't name a concrete thing the specialist will do in the first week, don't add them.

### No role overlap

The most common failure mode for creative-content teams is overlap between the Editor and the Brand Voice Guardian. They end up reviewing the same draft twice from 70% overlapping angles, and the Writer gets two sets of notes that sometimes contradict each other.

**Two fixes:**
- **Combine:** a single "Brand Editor" who owns both editorial and brand voice review (see `example-agents.md` Example 3).
- **Split cleanly:** if you keep them separate, the Editor handles structure/clarity/line-level and the Brand Voice Guardian handles voice dimensions only (tone, warmth, authority, plainness) — nothing else. Draw a hard line.

Other overlap traps to avoid:
- Writer + Editor both "improving the prose" — the Writer writes, the Editor marks.
- Strategist + Audience Analyst both "understanding the reader" — the Strategist owns the brief, the Analyst supplies evidence.
- SEO + Strategist both "deciding topics" — the Strategist picks, the SEO Lead informs.

---

## Persona Guidelines

A generic creative-content persona reads like a LinkedIn headline. The pattern's whole job is to prevent that. Before generating any agent, commit to the following:

### 1. Real credentials, not abstractions

❌ "Experienced content marketer with a passion for storytelling"
✅ "Seven years as a features reporter at a regional daily before jumping to content marketing when print budgets collapsed"

Name the specific background, the specific field, the specific gap the agent filled. "Regional daily," "trade publication on the packaging industry," "agency burnout to in-house," "UX research to content" — these land. "Experienced" does not.

### 2. A voice marker in `communicationStyle`

Give the reader a phrase the agent actually says. Not an attitude ("direct and honest"), but the line itself:

- "What job is this content doing?"
- "Let me take a pass."
- "Does this sound like us on our best day?"
- "What is the reader actually looking for when they type this?"
- "A persona doc is not an audience."

One strong voice marker beats five adjectives.

### 3. Opinions that another professional might disagree with

A `principles` block full of safe platitudes ("quality matters," "clarity is important") is a wasted field. Each agent needs at least one principle a different creative professional would argue with:

- "Kill more than you ship."
- "SEO is a constraint, not a muse."
- "A persona doc is not an audience — it's a hypothesis."
- "First draft is permission to write badly."
- "Brand voice is a spectrum across dimensions, not a binary."

If every principles block could belong to any agent on the team, the personas collapsed.

### 4. Domain vocabulary used naturally

Creative professionals have a vocabulary: lede, nut graph, kicker, pull quote, reverse outline, H1/H2, SERP, intent map, schema, JTBD, ICP, TOV, mood board, comp, cadence, rhythm. Agents should use these words where a real practitioner would — but not stack them for show. Natural use is the signal.

### 5. The distinctness test

Write three of your generated agents' `principles` blocks side by side with the names stripped. If you can't tell which is which, sharpen them until you can.

---

## Workflow Generation Guidance

### Standard lifecycle (generate for every creative-content team)

Every creative-content team should get at least the first two of these. Add the rest based on the team's scope:

1. **Content Brief Creation** (always) — raw idea → production-ready brief. See `example-workflows.md` Workflow 1.
2. **Draft & Refine Loop** (always) — approved brief → shipped piece with bounded revision. See Workflow 2.
3. **Brand Voice Audit** (optional) — retrospective voice drift analysis. Generate if the user mentioned brand consistency as a concern or if the team has multiple writers.
4. **Performance Triage** (optional) — live piece decision workflow. Generate if the user has analytics and mentioned optimization or underperforming content.

### Workflow shape rules (non-negotiable)

Every workflow in a generated team must follow the v6 shape:

**Each workflow is a skill directory** at `{output_folder}/teams/{team-name}/skills/bmad-skill-{workflow-name}/` containing:

- `SKILL.md` — frontmatter (`name` + `description`) plus a body that describes the skill and references `./workflow.md` for execution.
- `workflow.md` — the step-by-step instructions in markdown. Use `## Step N — Goal` headers. Never XML.
- `template.md` — only if the workflow produces a structured output document.

**Step shape:**
- Each step has a named agent (by `bmad-agent-*` name in backticks).
- Each step has an action, inputs, and a concrete output.
- User checkpoints are explicit (`**User checkpoint:**`), not implicit.

**Iteration bounds:**
- Revision loops have hard caps (typically two cycles before escalation).
- Escalation paths are named.

**Output paths:**
- Always `{output_folder}/teams/{team-name}/...`, never hardcoded `_bmad/teams/...`.
- The `output_folder` variable is loaded via `bmad-init` at the start of every workflow.

---

## File-Shape Quality Checklist

Before handing a generated creative-content team to the Quality Guardian, verify:

**Per user-facing agent** (`agents/bmad-agent-*/`):
- [ ] Directory name matches `name` field in SKILL.md frontmatter
- [ ] `SKILL.md` present with frontmatter (`name`, `description`) and body (persona reference, on-activation steps, capabilities table)
- [ ] `bmad-skill-manifest.yaml` present with all 9 fields populated: `type: agent`, `name`, `displayName`, `title`, `icon`, `capabilities`, `role`, `identity`, `communicationStyle`, `principles`, `module`
- [ ] `module: teams-{team-name}` (hyphenated, matches directory)
- [ ] `identity` is specific (real credentials, real background, concrete details)
- [ ] `communicationStyle` contains at least one voice marker
- [ ] `principles` contains at least one opinion another pro might disagree with

**Per workflow skill** (`skills/bmad-skill-*/`):
- [ ] Directory name matches `name` field in SKILL.md frontmatter
- [ ] `SKILL.md` present with frontmatter and body
- [ ] `workflow.md` present with `## Step N — Goal` headers (markdown only, no XML)
- [ ] Each step names an agent in backticks
- [ ] Iteration loops have hard caps
- [ ] Output paths use `{output_folder}` variable
- [ ] `template.md` present only if the workflow produces a structured document

**Team-level files:**
- [ ] `config.yaml` with team metadata
- [ ] `module.yaml` so the generated team installs via `npx bmad-method install --custom-content {absolute-path}`
- [ ] `TEAM_README.md` overview
- [ ] `requirements.md` from discovery phase

---

## Critical Success Factors

A generated creative-content team should score 90+ on validation when:

1. **Every agent has a real credential.** No "experienced" or "passionate" language.
2. **Every principles block has at least one opinion.** No platitudes.
3. **The Writer drafts alone.** No committee drafting in workflows.
4. **Review gates are separate from revisions.** A gate produces feedback; a revision incorporates it.
5. **Iteration is bounded.** Two revision cycles max, then escalation.
6. **User checkpoints happen at the right moments** — brief approval, final draft approval, major verdicts. Not every handoff.
7. **No role overlap.** Especially between Editor and Brand Voice (combine or split cleanly).
8. **Specialists are justified.** Every specialist has a concrete first-week task.
9. **All files match v6 shape.** SKILL.md + bmad-skill-manifest.yaml for agents, SKILL.md + workflow.md for skills. No XML anywhere.
10. **Output paths use `{output_folder}/teams/{team-name}/`.** No hardcoded `_bmad/` paths.

---

## What Changed From v5

If you're a generator that previously emitted v5-shaped creative-content teams, here's what's different in v6:

| v5 (obsolete) | v6 (current) |
|---------------|--------------|
| `<agent>` XML with `<persona><role><identity>` | `SKILL.md` + `bmad-skill-manifest.yaml` |
| Agent "thin shells" under 100 lines | SKILL.md as a real persona document |
| Workflow triad: `workflow.yaml` + `instructions.md` + `template.md` | Skill directory: `SKILL.md` + `workflow.md` (+ optional `template.md`) |
| Manual edits to `.claude/commands/` stubs | None — auto-installed by `--custom-content` |
| Manual `agent-manifest.csv` updates | None — auto-generated by `--custom-content` |
| Hardcoded `_bmad/teams/{name}/` paths | `{output_folder}/teams/{name}/` via `bmad-init` |
| Entry-Point vs. Sub-Agent distinction | User-facing (`bmad-agent-*`) vs. skill-only (`bmad-skill-*`) |

The **composition principles** — team size, role structure, creative process stages, review gate design — are unchanged from v5. Only the file shape changed.

---

**Generate creative-content teams with craft-grounded personas, bounded iteration, clear review gates, and correct v6 file shape. Apply the principles; invent the specifics.**
