# Generate Team — Workflow

Core generation engine. Takes a team-requirements document and produces a complete, installable team package under `{output_folder}/teams/{team-name}/`.

## Variables to Capture

Extracted from the requirements document in Step 1:

```yaml
primary_task: ""
domain: ""
team_size_preference: ""
key_concerns: []
collaboration_style: ""
workflow_preference: ""
required_expertise: ""
domain_context: ""
domain_specific_1: ""
domain_specific_2: ""
domain_specific_3: ""
team_name: ""               # derived from domain + primary task (kebab-case)
agent_roles: []             # populated in Step 4
generated_agents: []        # populated in Step 5
generated_workflows: []     # populated in Step 7
primary_pattern: ""         # populated in Step 2
loaded_patterns: []
pattern_learnings: {}
collaboration_model: ""     # populated in Step 8
```

## Step 1 — Load Requirements Document

**Action:** Read the requirements document that was passed in (from `bmad-skill-discover-team-needs`).

**Extract all variables.** If any required variable is missing, STOP and report the error to the caller — generation cannot proceed without the user's discovery output.

**Derive `team_name`** as a kebab-case identifier rooted in the domain and primary task (e.g. `home-automation-team`, `healthcare-compliance-squad`). Keep it short, memorable, and lowercase.

## Step 2 — Load Pattern Library

**Action:** Load relevant patterns from the pattern library at `{project-root}/_bmad/teambuilder/patterns/`.

**Primary pattern selection** (based on `domain`):
- `research-intelligence` → `research-intelligence`
- `planning-strategy` → `planning-strategy`
- `creative-content` → `creative-content`
- `technical-development` → `software-development`
- `operations-support` → `operations-process` or `software-development` (whichever fits better)
- `domain-specific-expert` → `itil-domain-expert`

**Secondary patterns:** load 1–2 additional for diversity. Prefer one with a different team size and one with a different collaboration model.

**For each selected pattern,** load these files from the pattern directory:
- `metadata.yaml` — pattern characteristics
- `example-agents.md` — agent archetype examples
- `example-workflows.md` — workflow structure examples
- `collaboration-model.md` — how agents interact
- `generation-guidance.md` — composition principles

**Context window optimization:** if patterns are too large, load the primary in full and summaries only for secondaries. Prioritize `example-agents.md` and `generation-guidance.md`.

## Step 3 — Study Pattern Learnings

**Critical:** You are extracting PRINCIPLES, not a library of agents to copy.

If you find yourself thinking "I'll use this pattern's research strategist agent," you are doing it WRONG. Instead think: "I learned that research agents benefit from query-refinement expertise and iterative search patterns — I'll create a NEW agent with these principles for the user's specific domain."

Study patterns for:

1. **Persona quality markers** — how do example agents have specific backgrounds? What makes communication styles distinct? How do principles reveal unique perspectives?
2. **Role composition** — how are roles structured (coordinator + experts + specialists + support)? What ensures no overlap?
3. **Domain expertise** — how is domain knowledge demonstrated? Terminology, context understanding, challenges referenced.
4. **Collaboration models** — how do agents work together (formal handoffs, agile ceremonies, consultative discussion)? Who talks to whom, when?
5. **Workflow design** — what makes workflows actionable? Specific steps, explicit assignments, concrete outputs.

Synthesize learnings into `pattern_learnings` for reference during generation.

## Step 4 — Define Agent Roles

**Required roles every team must have:**

1. **Primary coordinator / decision-maker** (always required, always user-facing)
   - Orchestrates the team; matches `collaboration_style`.
   - Examples: Project Manager, Practice Owner, Strategy Lead, Creative Director.
2. **Domain expert(s)** (1–2 required)
   - Deep expertise in `domain`, uses terminology from `domain_context`.
3. **Specialist for each key concern** (one per concern)
   - `key_concern_1` → specialist agent, etc.
4. **Support roles** as needed to reach team size — analyst, documentation specialist, quality reviewer, process coordinator.

**User-facing vs skill-only designation:**

- **User-facing** (`bmad-agent-*` with `SKILL.md` + `bmad-skill-manifest.yaml` type: agent) — primary interaction points the user invokes directly; has its own menu of workflows.
- **Skill-only** (can be represented as a focused sub-skill or simply as a persona referenced from team workflows) — participates in workflows run by user-facing agents, not invoked directly.

**Guideline:** most teams have 2–4 user-facing agents and the rest skill-only. A 6-agent team typically has 2–3 user-facing plus 3–4 skill-only.

**Count check against `team_size_preference`:**
- Too few → add support roles that enhance capability
- Too many → consolidate roles where sensible
- Just right → proceed

**Critical:** every key concern MUST be addressed by an agent. Non-negotiable.

Store in `agent_roles` array (each with name, role, type designation).

## Step 5 — Generate Agent Personas (paired with persona-improver)

This is the most critical step for quality. Work in **real-time pairing** with `bmad-agent-persona-improver`.

For each agent role:

1. **Draft a role description** — specific about capabilities, includes domain context, 1–2 sentences.
2. **Draft identity** — specific previous role (not "experienced professional"), concrete credentials, measurable achievements, personality details, 3–5 sentences.
3. **Draft communication style** — distinctive patterns or phrases, specific interaction preferences, personality-through-communication, 3–4 sentences.
4. **Draft principles** — strong opinions, clear priorities, philosophical stance, 3–5 principles.
5. **Pick an icon** — meaningful emoji for the role.

**After each field (or each full agent),** hand to `bmad-agent-persona-improver` for critique. They give 1–2 sentence actionable feedback. You incorporate immediately. Target: 2–3 exchanges per agent, no lengthy debates.

**Distinctness requirement:** if two agents could swap personas and still make sense, they are TOO SIMILAR. Rewrite.

**Domain expertise requirement:** use terminology from `domain_context`, reference challenges specific to `domain`. NOT "knows about healthcare" but "understands HIPAA compliance and patient-safety dependencies."

For each generated agent store:
- `name` (kebab-case id, e.g. `bmad-agent-risk-analyst`)
- `displayName`
- `title`
- `icon`
- `type` — `user-facing` or `skill-only`
- `role`
- `identity`
- `communicationStyle`
- `principles`

## Step 6 — Persona Quality Self-Check

Before writing files, verify with the persona-improver:

1. **Distinctness check** — do all agent communication styles sound dramatically different?
2. **Domain expertise check** — do domain-expert agents use terminology from requirements?
3. **Concern coverage check** — is each key concern addressed by a specialist?
4. **Memorability check** — can you remember each agent after reading once?
5. **Generic language check** — search for "experienced professional," "professional and clear," "believes in quality." Replace every hit.
6. **Type assignment check** — at least one user-facing agent (coordinator minimum)? Skill-only agents are truly supporting?

If any check fails, revise before proceeding.

## Step 7 — Design Team Workflows

**Number of workflows** (guideline):
- Small teams (4–6 agents): 2–4 workflows
- Medium teams (6–8 agents): 3–6 workflows
- Large teams (8–12 agents): 4–8 workflows

**Each workflow becomes a skill directory** under the generated team:

```
{output_folder}/teams/{team-name}/skills/bmad-skill-{workflow-name}/
  SKILL.md        # frontmatter (name, description) + body refers to ./workflow.md
  workflow.md     # step-by-step instructions with clear agent assignments
  template.md     # only if the workflow produces a structured document
```

**Each workflow must:**
- Have 3–10 steps
- Give each step a clear goal, specific action, agent assignment, concrete output
- Reference actual agent names from `generated_agents`
- Match `workflow_preference` (guided / flexible / structured)
- Align with `collaboration_style`
- End with a "Review & Save Learnings" step that invokes the team's own `bmad-skill-save-session`

**Workflow type hints by domain:**

| Domain | Typical workflows |
|--------|-------------------|
| research-intelligence | Comprehensive Research, Quick Lookup |
| planning-strategy | Strategic Planning, Risk Assessment |
| creative-content | Content Creation, Campaign Planning |
| technical-development | Feature Development, Code Review |
| operations-support | Incident Response, Process Improvement |
| domain-specific-expert | Governance workflow, Expert consultation |

**Workflow SKILL.md body template:**

```markdown
---
name: bmad-skill-{workflow-name}
description: "{specific description referencing team and domain}"
---

# {Workflow Title}

{One-paragraph overview of what the workflow does, who leads, what it produces.}

## On Activation

1. Invoke `bmad-init` with `--module=teams-{team-name}` to load team config.
2. Read fully and follow `./workflow.md`.

## Execution

Read fully and follow the instructions in `./workflow.md`.
```

Persona-improver does NOT critique workflows — not their domain.

Store each workflow in `generated_workflows` (name, lead agent, paths, contents).

## Step 8 — Define Collaboration Model

Based on `collaboration_style`, define how this team works together:

- **formal** — clear hierarchy with coordinator at top; formal handoffs between agents; document-driven processes; structured decision-making
- **agile** — sprint-based collaboration; daily standups (virtual); retrospectives and planning sessions; iterative delivery
- **consultative** — multi-agent discussions; advisory interactions; collaborative decision-making; perspective-sharing
- **casual** — flexible agent interactions; informal collaboration; ad-hoc teaming; exploratory approach
- **flexible** — balanced approach; adapts to context; mix of formal and informal

Specify:
- How agents communicate
- When agents collaborate vs work independently
- How decisions are made
- What ceremonies or touchpoints exist
- How the user interacts with the team (single point of contact vs open access)

Store in `collaboration_model`.

## Step 9 — Create Team Package

Create the complete file structure under `{output_folder}/teams/{team-name}/`.

### 9.1 — Team `config.yaml`

```yaml
module: teams-{team_name}
version: 1.0.0
generated_date: "{timestamp}"

team:
  name: "{team_name}"
  display_name: "{team_display_name}"
  description: "{team_description}"
  domain: "{domain}"
  team_size: {agent_count}
  collaboration_style: "{collaboration_style}"

source:
  generated_by: "TeamBuilder v3.0"
  requirements_doc: "./requirements.md"
  primary_pattern: "{primary_pattern}"

# Inherited from core (populated at install time)
user_name: ""
communication_language: English
document_output_language: English
output_folder: _bmad-output
```

### 9.2 — Team `module.yaml`

This is what makes the generated team itself an installable BMAD custom module. Without it, the `--custom-content` install flow cannot pick it up.

```yaml
code: teams-{team_name}
name: teams-{team_name}
displayName: "{team_display_name}"
version: 1.0.0
description: "{team_description}"
author: "TeamBuilder (generated)"
```

> **⚠️ CRITICAL — `code:` must use the `teams-` prefix**
>
> The generated `module.yaml` MUST have `code: teams-{team_name}` using the actual kebab-case team name (e.g. `code: teams-research-team`, `code: teams-home-automation-team`).
>
> **Why this is non-negotiable:**
> BMAD's `bmad-init` skill discovers modules by literal directory name match (`_bmad/{module_code}/config.yaml`). Generated teams must use the `teams-` prefix in their module code so:
>
> 1. BMAD's `--custom-content` installer copies them into `_bmad/teams-{team_name}/`
> 2. The team's agents can later call `bmad-init --module=teams-{team_name}` at runtime to load their config
> 3. Module names do not collide with built-in BMAD modules (`core`, `bmm`, `teambuilder`)
>
> A generated team **without this prefix** will silently fail config loading at runtime — every agent will report `init_required` and be unable to load its persona. This is the single most common cause of a "dead" generated team. Do not skip it, do not shorten it, do not substitute a different prefix.
>
> This rule is also enforced (as a Critical-severity check) in `templates/validation-rules.yaml`, so any generated team missing the prefix will fail validation.

### 9.3 — Requirements copy

Copy the original requirements document to `{output_folder}/teams/{team-name}/requirements.md` for traceability.

### 9.4 — User-facing agent files

For each user-facing agent, create a directory at `agents/bmad-agent-{name}/` containing:

- `SKILL.md` — frontmatter (`name`, `description`) + body with sections: title, Persona (refers to manifest), On Activation (with `bmad-init --module=teams-{team_name}`), Capabilities table with that agent's workflow menu items, Rules, any domain-specific prompts
- `bmad-skill-manifest.yaml` — 9-field schema:
  ```yaml
  type: agent
  name: bmad-agent-{name}
  displayName: {displayName}
  title: {title}
  icon: "{icon}"
  capabilities: "comma-separated list"
  role: "..."
  identity: "..."
  communicationStyle: "..."
  principles: "..."
  module: teams-{team_name}
  ```

Each user-facing agent's menu must include domain-specific workflow items PLUS the standard items:
- `MH` — redisplay menu help
- `CH` — chat freely
- `SS` — save session (invokes the team's `bmad-skill-save-session`)
- `PM` — party mode (invokes core `bmad-party-mode`, team-scoped)
- `DA` — dismiss

### 9.5 — Skill-only sub-agent files (if any)

For each skill-only sub-agent, create a directory at `agents/bmad-agent-{name}/` containing only `SKILL.md` — or represent the specialist as a persona section inside one of the team's workflow skills if there's no need for a dedicated directory.

### 9.6 — Workflow skill files

For each workflow in `generated_workflows`, create the skill directory at `skills/bmad-skill-{workflow-name}/` with `SKILL.md`, `workflow.md`, and `template.md` (if applicable).

### 9.7 — Team session-management skills

Every generated team gets its own copies of two first-class session-management skills, sourced from `{project-root}/_bmad/teambuilder/templates/_team-skills/`. The leading `_` on the directory name tells BMAD's recursive skill discovery to skip these files — they are *templates for generated teams*, not skills of the teambuilder module itself. They become real v6 skills only after they are copied into a generated team and that team is installed via `--custom-content`.

**Copy these entire skill directories into `{output_folder}/teams/{team_name}/skills/`:**

- `templates/_team-skills/bmad-skill-save-session/`  →  `skills/bmad-skill-save-session/` (contains `SKILL.md` + `workflow.md`)
- `templates/_team-skills/bmad-skill-memory-guide/`  →  `skills/bmad-skill-memory-guide/` (contains `SKILL.md` + `reference.md` — note: `reference.md`, not `workflow.md`, because this is a reference skill rather than a runnable workflow)

Note: when the skills land inside the generated team's `skills/` directory (no underscore prefix), BMAD will discover and install them normally on the next `--custom-content` install.

**After copying, replace placeholder variables in every copied file** (`SKILL.md`, `workflow.md`, `reference.md`):

- `{team_name}`       → the actual kebab-case team name (e.g. `research-team`)
- `{output_folder}`   → the resolved output folder from config (e.g. `_bmad-output`)
- `{project-root}`    → the actual project root path

Use a literal string replace across each file. Do not miss any occurrences — unreplaced placeholders will leak into the installed team and confuse runtime invocations.

### 9.8 — `TEAM_README.md`

Write a comprehensive overview including:
- Team purpose and domain
- Agent roster with roles and types (user-facing vs skill-only)
- How to use the team (which agent to invoke, when)
- Available workflows per agent
- Collaboration model
- Install instructions (see Step 10)
- Tips for success

### 9.9 — `GENERATION_SUMMARY.md`

Document:
- What was generated (agent count, workflow count)
- Requirements it addresses
- Agent type breakdown
- Quality self-check results
- Next steps (validation)

## Step 10 — Installation Instructions

Generate the user-facing install command in `TEAM_README.md`:

```
npx bmad-method install --custom-content "{absolute-path-to-team}" -y
```

This is the **same** `--custom-content` flow that installed TeamBuilder itself. BMAD will automatically:
- Copy the team into `_bmad/teams-{team_name}/`
- Register every agent in the BMAD agent manifest
- Install every skill into `.claude/skills/`
- List the team as a custom module in `manifest.yaml`

**You do NOT manually edit** `agent-manifest.csv`, `manifest.yaml`, or create `.claude/commands/` stubs. That's all v5-era plumbing that BMAD v6 handles automatically via `--custom-content`.

Also instruct the user to:
1. Configure `.mcp.json` so the memory server points at `{output_folder}/teams/{team-name}/memory.jsonl` (so the new team has its own persistent memory)
2. Restart Claude Code so new skills are discovered

## Step 11 — Hand Off to Validation

Pass to `bmad-skill-validate-team` (or return control to `bmad-skill-collaborative-generation` which will invoke it):

- `{generated_agents}` — all agent definitions
- `{generated_workflows}` — all workflow definitions
- `{team_name}` — team identifier
- `{team_path}` — absolute path to the generated team root
- Path to the original requirements document

Tell the user: "Team generation complete! Now validating quality... (this takes about 30 seconds)"

## Quality Assurance During Generation

### Self-checks

**After Step 5 (persona generation):**
- Are personas truly distinct or do some sound similar?
- Is domain expertise authentic or generic?
- Does each agent feel like a real person?

**After Step 7 (workflow design):**
- Does each workflow have 3–10 steps with clear agent assignments and concrete outputs?
- Are workflow steps specific and actionable?
- Do workflows reference actual team agent names?

**After Step 9 (team package):**
- Every user-facing agent has both `SKILL.md` and `bmad-skill-manifest.yaml`?
- Every workflow skill has `SKILL.md` and `workflow.md`?
- Team `config.yaml`, `module.yaml`, `TEAM_README.md` present?
- Names all follow `bmad-agent-*` / `bmad-skill-*` conventions, lowercase, hyphens only?

**Before Step 11 (handoff):**
- Does this team address the user's `primary_task`?
- Are all `key_concerns` covered by specialists?
- Is `required_expertise` present?
- Does the collaboration model match `collaboration_style`?

### Anti-pattern detection

Watch for and FIX these anti-patterns:

| Anti-pattern | Fix |
|--------------|-----|
| **Pattern copying** — "I'll use the research strategist from the pattern" | Create a new agent inspired by principles, not copied |
| **Generic personas** — "Professional and experienced" | Add specific background and personality |
| **Similar communication styles** — multiple agents "professional and clear" | Vary dramatically (formal, casual, technical, warm) |
| **Vague workflow steps** — "Step 1: Gather information" | "Step 1: Interview user about X, Y, Z specific aspects, produce `foo.md`" |
| **Missing concerns** — key concern not addressed by any agent | Add a specialist for that concern |

## Generation Success Criteria

Generation succeeds when:

1. All agents have distinct, memorable personas
2. Domain expertise is authentic (uses terminology from requirements)
3. Every key concern is addressed by a specialist
4. Collaboration model matches user preference
5. Every user-facing agent has `SKILL.md` + `bmad-skill-manifest.yaml`
6. Every workflow skill has `SKILL.md` + `workflow.md` (+ `template.md` if applicable)
7. Team package is complete: `config.yaml`, `module.yaml`, `requirements.md`, `TEAM_README.md`, `GENERATION_SUMMARY.md`
8. Session-management skills (`save-session`, `memory-guide`) are included

If ANY criterion is not met, REVISE before handing off to validation.

---

**Generation Complete → Validation → User Review → Install or Refine**
