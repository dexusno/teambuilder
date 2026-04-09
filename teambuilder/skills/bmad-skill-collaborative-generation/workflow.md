# Collaborative Generation — Master Workflow

Four phases. Each phase has a lead agent, completion criteria, and a defined hand-off. Do not skip phases. Do not run them in parallel.

## Phase 1 — Discovery
**Lead:** `bmad-agent-team-architect` (via `bmad-skill-discover-team-needs`)
**Participants:** team-architect only
**Other agents are NOT involved in this phase.**

**Steps:**
1. Team Architect invokes `bmad-skill-discover-team-needs` to run the 10-step interview.
2. Capture all discovery variables (primary task, domain, scope, complexity, scale, team size, collaboration style, key concerns, domain-specific context, required expertise, workflow preference).
3. Produce `team-requirements-{timestamp}.md` in `{output_folder}/teams/{team-name}/`.

**Completion criteria:**
- [ ] Requirements document exists
- [ ] User needs clearly captured
- [ ] Domain and scope identified

## Phase 2 — Paired Generation
**Lead:** `bmad-agent-team-architect`
**Participants:** team-architect + `bmad-agent-persona-improver` (real-time pair) + `bmad-agent-tool-scout` (final step)

**Collaboration mode:** real-time paired. Persona Improver advises *during* generation, not after.

### Step 1 — Design Structure
**Agent:** team-architect (alone)
**Inputs:** requirements document
**Outputs:** team composition (agent count, roles, collaboration model, workflow list)

Team Architect determines:
- Number of agents needed (4–12 based on scope/complexity)
- Role for each agent
- Which agents are user-facing (`bmad-agent-*` with `type: agent`) vs skill-only (`bmad-skill-*`)
- Collaboration model (sequential / parallel / iterative / consultative / agile / governance / creative-process)
- Workflow list (typically 2–5 workflows the team will need)

Persona Improver observes silently in this step.

### Step 2 — Paired Agent Generation
**Agents:** team-architect + persona-improver (simultaneous)
**Inputs:** team structure + requirements document
**Outputs:** agent files under `{output_folder}/teams/{team-name}/agents/`

For **each** agent:

1. **Team Architect drafts** the agent:
   - `SKILL.md` with frontmatter (`name`, `description`) + body (overview, capabilities table, on-activation steps)
   - `bmad-skill-manifest.yaml` with `type: agent` and persona fields (`displayName`, `title`, `icon`, `capabilities`, `role`, `identity`, `communicationStyle`, `principles`, `module: teams-{team-name}`)
2. **Persona Improver reviews immediately:**
   - "Too generic — add specific background"
   - "Communication style could describe anyone — what's distinctive?"
   - "Principles are bland — what does this agent really value?"
   - "Domain credential is missing — add a real one"
3. **Team Architect incorporates feedback immediately:**
   - Revises identity with concrete details
   - Adds distinctive communication patterns
   - Sharpens principles with strong opinions
   - Adds authentic domain markers
4. **Persona Improver confirms** improvement or requests further refinement.
5. Move to next agent.

**Efficiency rules:**
- 2–3 feedback exchanges per agent (no more)
- Specific, actionable suggestions only
- No lengthy debates
- NO separate review pass after all agents are done — quality is built in here.

**Architecture rules (v6):**
- Each user-facing agent has both `SKILL.md` AND `bmad-skill-manifest.yaml` (with `type: agent`).
- Each skill-only "sub-agent" has only `SKILL.md` (no `bmad-skill-manifest.yaml`, or one without `type: agent`).
- Names follow `bmad-agent-*` (user-facing) or `bmad-skill-*` (skill-only), lowercase, hyphens only.
- Names match directory names exactly.

### Step 3 — Generate Workflow Skills
**Agent:** team-architect
**Inputs:** team structure + agent definitions
**Outputs:** workflow skill directories under `{output_folder}/teams/{team-name}/skills/`

For each team workflow, create a directory `skills/bmad-skill-{workflow-name}/` containing:
- `SKILL.md` — frontmatter (`name`, `description`) + body that references `./workflow.md`
- `workflow.md` — step-by-step instructions with agent assignments at each step
- `template.md` — output document template (only if the workflow produces a structured document)

Workflows should be 3–10 steps. Each step needs a clear action, agent assignment, expected output, and (optionally) a user-checkpoint marker.

Persona Improver does **not** critique workflows in this step (not their domain).

### Step 4 — Create Team Config and README
**Agent:** team-architect
**Outputs:**
- `{output_folder}/teams/{team-name}/config.yaml` — team metadata (name, version, generated_date, requirements_summary, agent list, workflow list)
- `{output_folder}/teams/{team-name}/TEAM_README.md` — team overview, what each agent does, when to use which workflow, install instructions
- `{output_folder}/teams/{team-name}/module.yaml` — module manifest so the generated team itself becomes installable as a BMAD custom module

The `module.yaml` enables the user to later install the generated team into any BMAD project via the standard fully-non-interactive install command:
```
npx bmad-method@6.2.2 install --directory "{absolute-path-to-project-root}" -y --modules bmm --tools claude-code --custom-content "{absolute-path-to-team}"
```
(See `bmad-skill-generate-team/workflow.md` Step 10 for the flag-by-flag reasoning. Do NOT omit any flag — BMAD drops into an interactive TUI if any of `--directory`, `-y`, `--modules`, or `--tools` is missing, and an LLM-driven agent cannot answer interactive prompts.)

### Step 5 — Tool Scout Research
**Agent:** `bmad-agent-tool-scout`
**Inputs:** team domain, agent roles, workflow requirements
**Outputs:** `{output_folder}/teams/{team-name}/TOOL_RECOMMENDATIONS.md`

Tool Scout analyzes the team and recommends MCP servers, APIs, and CLI tools. Categorizes as Essential / Recommended / Optional. Includes installation instructions and `.mcp.json` configuration snippets. Presents 2–5 tools (not exhaustive).

**Completion criteria for Phase 2:**
- [ ] All agent files created
- [ ] All workflow skills created
- [ ] Team `config.yaml`, `TEAM_README.md`, `module.yaml` created
- [ ] Tool recommendations document created

## Phase 3 — Critical Review
**Lead:** `bmad-agent-quality-guardian`
**Participants:** quality-guardian only

### Step 1 — Comprehensive Review
**Inputs:** all generated files + original requirements
**Outputs:** quality score (0–100) + structured assessment

Quality Guardian invokes `bmad-skill-validate-team` and scores:

1. **Agent quality (40 points):**
   - Persona distinctness across the team
   - Background specificity
   - Communication style differentiation
   - Domain expertise authenticity
   - Architecture compliance: each user-facing agent has both `SKILL.md` and `bmad-skill-manifest.yaml`; names follow conventions; manifest fields populated
2. **Workflow quality (30 points):**
   - Practicality
   - Clarity
   - Completeness
3. **Team coherence (30 points):**
   - Coverage of all key concerns
   - No role overlap
   - Appropriate size for scope
   - Required expertise present
   - Coordinator/orchestrator present

Then identifies issues by severity (Critical / High / Medium / Low) and produces specific, actionable recommendations.

### Step 2 — Generate Validation Report
**Outputs:** `{output_folder}/teams/{team-name}/VALIDATION_REPORT.md`

The report contains: overall score and rating; score breakdown by dimension; assessment of strengths and issues; priority improvements ranked by severity; final recommendation.

**Recommendation bands:**
- 95–100: Install immediately
- 85–94: Ready to use
- 75–84: Refinement recommended
- 60–74: Refinement required
- <60: Regenerate recommended

**Completion criteria for Phase 3:**
- [ ] Quality score calculated
- [ ] Validation report created
- [ ] Recommendation made

## Phase 4 — User Decision
**Lead:** team-architect
**Participants:** team-architect + quality-guardian (joint presentation)

### Step 1 — Present Results
Team Architect presents structure and composition; Quality Guardian presents the score, key strengths, issues, and recommendation. Together they ask the user:

1. **Install now** (typically if score ≥ 85)
2. **Refine** based on Quality Guardian's recommendations
3. **Regenerate** with adjusted requirements

### Step 2 — Handle Decision

**If INSTALL:**

1. Give the user (or run via a `Bash` tool call if the user has authorized it) the **fully non-interactive install command**. Every single flag is required — BMAD drops into an interactive clack TUI if any of them is missing, and an LLM agent cannot answer clack prompts:

   **Windows:**
   ```powershell
   npx bmad-method@6.2.2 install --directory "{absolute-path-to-project-root}" -y --modules bmm --tools claude-code --custom-content "{absolute-path-to-team}"
   ```

   **Linux / macOS:**
   ```bash
   npx bmad-method@6.2.2 install --directory "{absolute-path-to-project-root}" -y --modules bmm --tools claude-code --custom-content "{absolute-path-to-team}"
   ```

   Replace `{absolute-path-to-project-root}` with the user's actual project root (the directory that already contains `_bmad/`) — not the generated team path. Replace `{absolute-path-to-team}` with the generated team's absolute path, typically `{output_folder}/teams/{team-name}/`.

   **Common mistake to avoid:** running `npx bmad-method install --custom-content "<team-path>" -y` without `--directory`. BMAD will prompt for the installation directory and block forever if a non-interactive caller cannot answer.

   This is the same `--custom-content` flow that installed TeamBuilder itself. BMAD will:
   - Copy the team into `_bmad/teams-{team-name}/`
   - Auto-generate manifest entries for every agent and skill
   - Install all skills into `.claude/skills/`
   - Update `manifest.yaml` to list the generated team as a custom module

2. Confirm `.mcp.json` is configured to point the memory server at `{output_folder}/teams/{team-name}/memory.jsonl` so the new team has its own persistent memory.
3. Tell the user to **restart Claude Code** so it picks up the new skills directory (`.claude/skills/` is read on startup).
4. List the new agent slash-invocations they'll see (one per `bmad-agent-*` in the generated team).
5. Mention that the team has its own `bmad-skill-save-session` and `bmad-skill-memory-guide` (copied from TeamBuilder's templates) for cross-session continuity.

**If REFINE:** route to `bmad-skill-refine-team`. Focus on Quality Guardian's priority issues. Re-validate after refinement. Up to 3 iterations.

**If REGENERATE:** ask what requirements should change, then return to Phase 1 with the adjusted inputs.

**Completion criteria for Phase 4:**
- [ ] Results presented to user
- [ ] User decision captured
- [ ] Appropriate follow-up action initiated

## Settings

```yaml
max_feedback_loops_per_agent: 3      # Phase 2 paired generation
require_consensus: false             # Persona Improver advises, Team Architect decides
minimum_quality_score: 60            # Below this → recommend regeneration
recommended_quality_score: 85        # At or above → ready to install
output_folder_default: "_bmad-output/teams"
```

## Success Criteria

- Quality score ≥ 85
- All agents have distinct, memorable personas
- Workflows are practical and actionable
- User satisfied with the team
- Team installable via the standard `--custom-content` flow

## Why This Architecture Works

- **Paired generation prevents issues early** — much cheaper than fixing them after the fact.
- **Real-time feedback is faster than separate review cycles.**
- **Single critical review is sufficient** when generation quality is high.
- **Clear phases prevent rework.**
- **The user sees results once, not intermediate drafts.**
- **Generated teams are themselves BMAD custom modules**, so installation reuses the same proven `--custom-content` machinery as TeamBuilder itself. No special-case install code anywhere.
