# TeamBuilder v3 — AI Agent Team Generator for BMAD v6

> **TeamBuilder v3.2.2 — built for BMAD Method v6.2.2**
> A BMAD v6 custom module that generates tailored AI agent teams through guided discovery, paired generation with real-time quality feedback, and critical validation scoring. Includes compatibility guardrails (`doctor`, `update`, channels), runtime drift warning, and CI smoke tests.

---

## Table of Contents

- [What is TeamBuilder?](#what-is-teambuilder)
- [What TeamBuilder IS](#what-teambuilder-is)
- [What TeamBuilder is NOT](#what-teambuilder-is-not)
- [How it works](#how-it-works)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Windows](#windows)
  - [Linux / macOS](#linux--macos)
  - [What the installer does](#what-the-installer-does)
  - [Reinstalling, updating, uninstalling](#reinstalling-updating-uninstalling)
- [First Team — Quick Start](#first-team--quick-start)
- [The Six TeamBuilder Agents](#the-six-teambuilder-agents)
- [The Five TeamBuilder Skills](#the-five-teambuilder-skills)
- [Pattern Library](#pattern-library)
- [Generated Teams](#generated-teams)
- [Memory System](#memory-system)
- [Configuration](#configuration)
- [Project Layout After Install](#project-layout-after-install)
- [Troubleshooting](#troubleshooting)
- [Development / Contributing](#development--contributing)
- [Version History](#version-history)
- [License](#license)
- [Disclaimer](#disclaimer)

---

## What is TeamBuilder?

TeamBuilder is a **custom module for [BMAD Method v6](https://github.com/bmad-code-org/BMAD-METHOD)** that helps you create specialized AI agent teams without hand-writing agent definitions or workflows. You answer questions about what you need, and TeamBuilder generates a team with distinct personas, authentic domain expertise, and practical workflows — then validates the result before you install it.

The BMAD Method is a framework built around Claude Code that lets you compose teams of AI agents with specific roles (analyst, architect, developer, QA, etc.) into a structured collaborative process. BMAD ships with a general software-development module (`bmm`). **TeamBuilder is where you go when `bmm` isn't what you need** — for example:

- A domain-specific governance team (ITIL, compliance, healthcare, legal)
- A research / intelligence team with verification discipline
- A planning / strategy team with distinct lenses (risk, stakeholders, scenarios)
- A creative / content team with editorial + brand-voice roles
- An operations / Lean / Six Sigma team
- A specialty software team (security, SRE, ML, accessibility) that complements `bmm` rather than duplicating it

TeamBuilder is itself a BMAD v6 custom module, installed via BMAD's native `--custom-content` mechanism. Every team it generates is **also a BMAD v6 custom module**, installable into any other BMAD project the same way. This means generated teams are first-class citizens: they show up in `bmad status`, register in the manifest CSVs, install their agents into `.claude/skills/` automatically, and use the same loading machinery as any other BMAD module.

---

## What TeamBuilder IS

- ✅ **A team generator.** Guided 10-question discovery produces a requirements document. A collaborative pipeline of four agents then designs, generates, validates, and packages a custom team.
- ✅ **A quality gate.** Every generated team is scored 0–100 against 42+ validation rules covering persona distinctness, workflow practicality, team coherence, architectural compliance, and naming conventions.
- ✅ **Pattern-driven.** The `patterns/` library contains six reference patterns (~55,000 words of v6-shape examples and composition guidance) that teach the generator. Generated teams apply these **principles** without copying the examples.
- ✅ **A persistent-memory system.** Each generated team gets its own Memory MCP file. Learnings are classified as `GeneralKnowledge` (reusable across projects) or `ProjectKnowledge` (team-specific) so cross-team knowledge can accumulate and be reused.
- ✅ **A session continuity layer.** Every generated team ships with a `bmad-skill-save-session` skill that captures tool learnings and compiles a session context file, so the next session picks up where you left off.
- ✅ **A proper BMAD v6 module.** Installs cleanly via `--custom-content`. No manual manifest editing. No `.claude/commands/` stubs. No workflow file triads. Everything BMAD 6.2.2 supports natively is used; nothing is hacked around it.
- ✅ **Free and open source.** MIT license. Fork it, extend it, submit PRs.

## What TeamBuilder is NOT

- ❌ **Not a replacement for BMM.** If you need a general agile software-development team (PM, architect, dev, QA, scrum master), install `bmm` instead — it ships with those roles and their workflows already. Use TeamBuilder for specialty teams or non-software domains.
- ❌ **Not an autonomous agent.** TeamBuilder generates a team for you to review, refine, and install. Nothing ships to production without your approval. Quality Guardian scores and recommends — you decide.
- ❌ **Not a production-ready AI system.** Generated teams are starting points. They work, they're coherent, and they're tailored, but you should still **read the generated personas and workflows before using them for real work**. Refine anything that doesn't match your context.
- ❌ **Not a magic prompt template.** Patterns are learning examples, not fill-in-the-blank templates. The generation pipeline learns composition principles from patterns and applies them to your specific domain — but that means quality depends on how specific and accurate your discovery answers are.
- ❌ **Not affiliated with Anthropic or the BMAD-METHOD project.** TeamBuilder is an independent community module that sits on top of BMAD. It does not speak for them and they do not endorse it.
- ❌ **Not a secrets manager.** Do NOT put API keys, passwords, or private data into agent personas, generated team files, or Memory MCP entries. The memory file is a plain-text JSONL file on your disk. Generated team files are committed to git by default (except `memory.jsonl` and `session-context.md`). Review the `.gitignore` and team files before committing.
- ❌ **Not a silver bullet for bad prompts.** Generated agents are as specific as your discovery answers. Vague answers → generic agents. Specific domain context with real terminology → authentic specialists.

---

## How it works

TeamBuilder runs a **four-phase collaborative pipeline** orchestrated by the `bmad-skill-collaborative-generation` skill. Four agents take turns leading phases:

| Phase | Name | Lead agent(s) | What happens |
|---|---|---|---|
| **1** | Discovery | `bmad-agent-team-architect` (via `bmad-skill-discover-team-needs`) | 10-question guided interview with domain-specific branching. Captures task, domain, scope, concerns, team-size preference, collaboration style. Output: `team-requirements-{timestamp}.md`. |
| **2** | Paired Generation | `bmad-agent-team-architect` + `bmad-agent-persona-improver` (real-time pair) | Team Architect drafts each agent and workflow. Persona Improver critiques immediately (2–3 exchanges per agent) before Team Architect moves on. Quality is built in **during** generation, not patched in after. Then `bmad-agent-tool-scout` researches MCP / CLI integrations. |
| **3** | Critical Review | `bmad-agent-quality-guardian` (via `bmad-skill-validate-team`) | Scores 0–100 against 42+ rules: Agent quality (40%), Workflow quality (30%), Team coherence (30%). Produces `VALIDATION_REPORT.md` with priority issues ranked by severity. |
| **4** | User Decision | `bmad-agent-team-architect` + `bmad-agent-quality-guardian` (joint presentation) | Team Architect presents structure; Quality Guardian presents score + findings. User chooses: **Install** / **Refine** / **Regenerate**. |

**Quality bands:**
- **95–100** — Exceptional. Install immediately.
- **85–94** — Good. Ready to use.
- **75–84** — Acceptable. Refinement recommended.
- **60–74** — Needs work. Refinement required.
- **<60** — Regenerate with adjusted requirements.

If you choose **Refine**, TeamBuilder's `bmad-skill-refine-team` makes targeted improvements against the priority issues Quality Guardian flagged (up to 3 iterations).

If you choose **Install**, BMAD's `--custom-content` installer picks up the generated team and installs it as a new custom module (named `teams-{your-team-name}`). Its agents appear in `.claude/skills/` immediately — just restart Claude Code.

---

## Requirements

| Requirement | Minimum | Notes |
|---|---|---|
| **Node.js** | **20.x** | BMAD 6.2.2 uses `styleText` from `node:util` which was added in Node 20. Node 18 WILL fail at install time with `The requested module 'node:util' does not provide an export named 'styleText'`. |
| **npm** | Ships with Node.js | Required to run `bmad-method` via `npx` |
| **git** | Any recent version | Installer git-clones this repo to a temp dir |
| **Claude Code** | Desktop app or CLI | TeamBuilder installs skills into `.claude/skills/` |
| **BMAD Method** | 6.2.2 (stable) | Installed automatically — do not pre-install it |
| **Operating System** | Windows 10+, macOS 11+, any modern Linux | PowerShell or bash |

> **Do NOT install BMAD separately before running TeamBuilder's installer.** The installer handles BMAD installation itself using a pinned, tested version (6.2.2). If you already have a BMAD install in the target directory, the TeamBuilder installer will either refuse (if TeamBuilder is already installed) or add itself to the existing install (if only `bmm` is present).

---

## Installation

### Windows

**Option A — Clone, then run** (recommended for first-time users):

```powershell
git clone https://github.com/dexusno/teambuilder.git C:\temp\teambuilder
cd C:\path\to\your\project      # any empty or bmm-only directory
C:\temp\teambuilder\scripts\install.ps1
```

**Option B — One-liner** (pulls the installer directly from GitHub):

First, create and enter your project folder (any empty or `bmm`-only directory works):

```powershell
mkdir my-project
cd my-project
```

Then copy and paste this single line to download and run the installer:

```powershell
iwr https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.ps1 -OutFile install.ps1; .\install.ps1
```

**Installer flags:**

| Flag | Effect |
|---|---|
| `-Yes` | Accept all defaults, no prompts |
| `-NoMcp` | Skip `.mcp.json` creation |
| `-NoPlaywright` | Keep Memory MCP, skip Playwright |
| `-Branch <name>` | Install from a specific git branch (default `main`) |
| `-LocalSource <path>` | Use a local TeamBuilder checkout instead of cloning (maintainer flow) |

Example:

```powershell
.\install.ps1 -Yes -NoPlaywright
```

### Linux / macOS

**Option A — Clone, then run:**

```bash
git clone https://github.com/dexusno/teambuilder.git /tmp/teambuilder
cd ~/path/to/your/project
bash /tmp/teambuilder/scripts/install.sh
```

**Option B — One-liner:**

First, create and enter your project folder:

```bash
mkdir my-project && cd my-project
```

Then copy and paste this single line to download and run the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

**Installer flags:**

| Flag | Effect |
|---|---|
| `-y` / `--yes` | Accept all defaults, no prompts |
| `--no-mcp` | Skip `.mcp.json` creation |
| `--no-playwright` | Keep Memory MCP, skip Playwright |
| `--branch NAME` | Install from a specific git branch (default `main`) |
| `--local-source PATH` | Use a local TeamBuilder checkout instead of cloning |

Example:

```bash
./install.sh -y --no-playwright
```

### What the installer does

1. **Checks prerequisites** — Node.js, npm, git. Warns if Claude Code CLI is not on PATH (the desktop app works fine too).
2. **Refuse-if-exists guard** — If `_bmad/teambuilder/` already exists, the installer refuses and points you at the (future) update/doctor scripts. If `_bmad/` exists but `teambuilder/` doesn't, it offers to add TeamBuilder to the existing BMAD install without touching `core` or `bmm`.
3. **Clones this repo to a temp dir** — so it always installs the right `teambuilder/` module contents regardless of where you ran it from.
4. **Runs BMAD's installer** — `npx bmad-method@6.2.2 install --directory . -y --modules bmm --tools claude-code --custom-content <temp>/teambuilder`. BMAD handles everything: copying the module, generating manifest CSVs, registering agents, installing skills into `.claude/skills/`.
5. **Writes `.mcp.json`** — configures the Memory MCP server with `MEMORY_FILE_PATH` pointing at `_bmad/teambuilder/memory/general-knowledge.jsonl` plus Playwright MCP (unless `-NoPlaywright`). If `.mcp.json` already exists, the installer leaves it alone.
6. **Creates `docs/`** — the team knowledge base directory. Agents read `.md` files from here on activation.
7. **Creates or updates `.gitignore`** — appends rules for team memory files and session contexts so local state doesn't pollute commits.
8. **Cleans up the temp clone.**
9. **Runs post-install sanity checks** — verifies `_bmad/teambuilder/config.yaml`, `_bmad/teambuilder/agents/`, `_bmad/teambuilder/skills/`, and the manifest CSVs are present. Counts teambuilder rows in the manifests and reports them.
10. **Prints a success message** with next steps and the full agent list.

### Reinstalling, updating, uninstalling

- **Diagnose problems** — `scripts/doctor.ps1` (Windows) or `scripts/doctor.sh` (Linux/macOS). Read-only health check that runs the full compatibility test suite plus `bmad status` and reports a structured pass/fail summary. Use this when something feels wrong, before filing a bug report, or after upgrading BMAD. Supports `-Json` / `--json` for scripts.
- **Update TeamBuilder in place** — `scripts/update.ps1` (Windows) or `scripts/update.sh` (Linux/macOS). Snapshots the current install to `_bmad/.tb-backup-{timestamp}/`, runs the compatibility check, applies the update via BMAD's `--custom-content` quick-update, re-runs the check, and offers rollback if anything went wrong. **Never touches `_bmad/teams-*/` (your generated teams are preserved).** Use `-Yes` for non-interactive, `-KeepBackup` to retain the snapshot, `-Force` to override pre-check failures.
- **Reinstall from scratch** — delete `_bmad/` manually, then run `scripts/install.*` again. **Warning:** deleting `_bmad/` also removes any generated teams stored under `_bmad/teams-*/`. Back them up first, or use `update.*` instead.
- **Uninstall only TeamBuilder** — delete `_bmad/teambuilder/` and rerun BMAD's installer: `npx bmad-method@6.2.2 install --directory . -y --modules bmm --tools claude-code`. BMAD will regenerate manifests without TeamBuilder.
- **Uninstall everything** — `npx bmad-method uninstall` (BMAD's built-in uninstall command).

---

## First Team — Quick Start

After installation, you should see:

```
+---------------------------------------------------+
|            Installation Complete!                 |
+---------------------------------------------------+
```

To create your first team:

1. **Restart Claude Code.** Skills are discovered on startup. If you had Claude Code open, close and reopen it — otherwise the new agents won't be visible.
2. **Open this directory** in Claude Code (the desktop app or via `claude .` in a terminal).
3. **Invoke the TeamBuilder Guide** by typing:
   ```
   /bmad-agent-team-guide
   ```
4. **Greet the guide** and pick `[CT]` (Create a new AI agent team) from the menu.
5. **Answer the 10 discovery questions** honestly and specifically. The more domain terminology you use, the more authentic the generated team will be.
6. **Let the pipeline run:**
   - Team Architect will design the structure (5–30 seconds)
   - Paired generation with Persona Improver will produce the agents and workflows (1–3 minutes depending on team size)
   - Tool Scout will research MCP/CLI integrations (10–30 seconds)
   - Quality Guardian will score and report (10–20 seconds)
7. **Review the validation report.** If the score is ≥85, install. If 75–84, refine. If <75, consider regenerating with better discovery answers.
8. **The team installs itself automatically.** TeamBuilder runs BMAD's `--custom-content` installer via a Bash tool call, copies the team into `_bmad/teams-{team-name}/`, registers every agent in the manifests, and lands every skill into `.claude/skills/`. No copy-paste required. If the install fails, the agent will tell you exactly what broke and point you at `scripts/doctor.*` for diagnosis.
9. **Restart Claude Code** (the one manual step). Claude Code only scans `.claude/skills/` at startup, so a restart is required before you can invoke your new team's agents. Close and reopen the desktop app, or `Ctrl+C` and relaunch the CLI.
10. **Talk to one of your new agents.** After restart, type `/bmad-agent-{name}` — they'll load their persona, greet you by name, and present a menu.

**Before you stop work**, always run `[SS] Save Session` on the agent you're working with. This captures any tool learnings into Memory MCP and writes a session context file that the team will auto-load next time. See [Memory System](#memory-system) below.

---

## The Six TeamBuilder Agents

All six are real, user-invokable agents installed to `.claude/skills/`. You can talk to any of them directly via their slash command — but in normal flow, you'll only talk to Team Guide and Memory Manager. The other four are orchestrated by the collaborative-generation pipeline.

| Slash command | Role | When to invoke directly |
|---|---|---|
| `/bmad-agent-team-guide` | **Main entry point.** Presents the menu (create team, refine team, view patterns, learn how it works, chat, party mode, dismiss). Orchestrates the full pipeline. | Always start here for team creation. |
| `/bmad-agent-team-architect` | **Structural designer.** Leads discovery, designs team composition, drives paired generation. | When you want to think through team structure without running the full pipeline. |
| `/bmad-agent-persona-improver` | **Persona quality specialist.** Gives real-time feedback on persona distinctness and authenticity during generation. | Rarely direct — mostly invoked via `bmad-skill-collaborative-generation`. |
| `/bmad-agent-quality-guardian` | **Final validator.** Scores generated teams 0–100 against 42+ rules. Writes `VALIDATION_REPORT.md`. | To re-validate an existing team after manual edits. |
| `/bmad-agent-tool-scout` | **MCP / tool researcher.** Recommends Memory, Playwright, Fetch, Filesystem, GitHub, and other MCP servers relevant to the team's domain. Writes `TOOL_RECOMMENDATIONS.md`. | To audit MCP coverage on an existing team. |
| `/bmad-agent-memory-manager` | **Cross-team memory curator.** Consolidates `GeneralKnowledge` entries from all your generated teams into `_bmad/teambuilder/memory/general-knowledge.jsonl`. Also manages session context and can scan projects for memory files. | End of a workday, or when cloning this repo to a new machine. |

---

## The Five TeamBuilder Skills

Skills are workflows invoked by agents (or by other skills). You generally don't invoke them directly — the Team Guide will.

| Skill | What it does |
|---|---|
| `bmad-skill-collaborative-generation` | The master orchestrator. Runs all four phases of the pipeline in order. |
| `bmad-skill-discover-team-needs` | 10-question guided interview with domain branching. Produces `team-requirements-{timestamp}.md`. |
| `bmad-skill-generate-team` | Creates the team's directory structure: `module.yaml`, `config.yaml`, agents, workflow skills, and the critical `code: teams-{name}` module code. Also copies `bmad-skill-save-session` and `bmad-skill-memory-guide` into the generated team's `skills/`. |
| `bmad-skill-validate-team` | Runs the 42+ rule validation from `templates/validation-rules.yaml`. Scores and produces the `VALIDATION_REPORT.md`. |
| `bmad-skill-refine-team` | Makes targeted improvements to a team based on Quality Guardian's priority issues. Up to 3 iterations. |

---

## Pattern Library

The `patterns/` directory contains six reference patterns that teach the generator how to compose teams for different domains. Each pattern is a complete set of composition principles, example agents (with full v6 `SKILL.md` + `bmad-skill-manifest.yaml` shape), example workflows, collaboration models, and generation guidance — about ~55,000 words of curated content in total across all six patterns.

| Pattern | Team type | When it applies |
|---|---|---|
| **itil-domain-expert** | Large formal governance (8–12 agents) | ITIL practices, change management, compliance, regulated industries, change advisory boards, problem management, incident command |
| **software-development** | Specialty software (6–8 agents) | **Not generic software dev — install `bmm` for that.** Use when you need security engineers, SREs, ML engineers, accessibility specialists, performance engineers that `bmm` doesn't provide. |
| **research-intelligence** | Iterative synthesis (5–8 agents) | Market research, competitive intelligence, literature reviews, fact-checking, multi-source verification, OSINT |
| **planning-strategy** | Consultative multi-lens (6–8 agents) | Strategic planning, decision support, risk analysis, scenario planning, stakeholder alignment, executive advisory |
| **creative-content** | Creative process (4–6 agents) | Content marketing, brand-aware writing, editorial workflows, SEO optimization, audience analysis |
| **operations-process** | Lean / Six Sigma (5–7 agents) | Continuous improvement, process optimization, DMAIC cycles, value stream mapping, kaizen events, root-cause analysis |

**Important:** patterns are **learning examples, not templates to copy**. The generation pipeline reads them to understand composition principles (role types, distinctness markers, collaboration models, quality thresholds) and then creates **original** agents and workflows for your specific domain. If your generated team looks like a pattern with different names, something went wrong — report it as a bug.

---

## Generated Teams

When TeamBuilder generates a team, it lands under `_bmad-output/teams/{team-name}/` with this exact structure:

```
_bmad-output/teams/your-team-name/
├── module.yaml                       # REQUIRED: code: teams-your-team-name
├── config.yaml                       # Team runtime config
├── agents/
│   ├── bmad-agent-{role1}/
│   │   ├── SKILL.md                  # Entry point (frontmatter + persona body)
│   │   └── bmad-skill-manifest.yaml  # type: agent + 11 persona fields
│   └── bmad-agent-{role2}/
│       └── ...
├── skills/
│   ├── bmad-skill-{workflow1}/
│   │   ├── SKILL.md
│   │   ├── workflow.md
│   │   └── template.md               # optional
│   ├── bmad-skill-save-session/      # copied from TeamBuilder templates
│   │   ├── SKILL.md
│   │   └── workflow.md
│   └── bmad-skill-memory-guide/      # copied from TeamBuilder templates
│       ├── SKILL.md
│       └── reference.md
├── TEAM_README.md                    # Human overview of the team
├── TOOL_RECOMMENDATIONS.md           # MCP/CLI suggestions from Tool Scout
├── VALIDATION_REPORT.md              # Quality Guardian's score and findings
├── memory.jsonl                      # Team-specific Memory MCP storage (git-ignored)
└── session-context.md                # Auto-populated by save-session (git-ignored)
```

### The `teams-` prefix convention

Every generated team's `module.yaml` uses `code: teams-{team-name}`. **This is non-negotiable.** BMAD's `bmad-init` skill looks up module configs by literal directory name match: `_bmad/{module_code}/config.yaml`. If the generated team uses just `{team-name}` without the `teams-` prefix:

- It might collide with a core module name (`core`, `bmm`, `teambuilder`).
- It won't be visually distinguishable from native modules in `_bmad/`.
- At runtime, the team's agents will silently fail config loading (`bmad-init` reports `init_required`).

The `teams-` prefix:
- Namespaces generated teams out of the way of native modules.
- Lets `bmad-init --module=teams-{team-name}` reliably find the team's `config.yaml`.
- Makes `_bmad/teams-research-team/` visually obviously a TeamBuilder-generated module.

This is enforced as a Critical-severity rule in `templates/validation-rules.yaml`. Teams that omit the prefix fail validation with a specific fix suggestion.

### Installing a generated team

**TeamBuilder installs generated teams automatically** at the end of the generation pipeline. The team-guide agent invokes BMAD's `--custom-content` installer via a Bash tool call, verifies the post-install state, and reports success or failure. You do not need to run any install command yourself.

**If you ever need to reinstall manually** (e.g., after cloning a team to a different project, or if an automatic install was interrupted), use this fully-non-interactive command — every flag is required, or BMAD drops into an interactive TUI that blocks automated callers:

```bash
npx bmad-method@6.2.2 install \
  --directory "<absolute-path-to-project-root>" \
  -y \
  --modules bmm \
  --tools claude-code \
  --custom-content "<absolute-path-to-generated-team>"
```

**Flag-by-flag**, all required:

| Flag | Without it |
|---|---|
| `--directory "<project-root>"` | BMAD prompts "Installation directory:" and blocks |
| `-y` | BMAD prompts for module and tool confirmations |
| `--modules bmm` | BMAD may prompt "which modules?" on quick-update |
| `--tools claude-code` | BMAD may prompt "which IDE?" on quick-update |
| `--custom-content "<team-path>"` | The actual install target |

Use **absolute paths** for both `--directory` and `--custom-content`. Relative paths are risky because BMAD may resolve them against a different CWD than you expect.

BMAD treats the install as a **quick-update** and adds the new module to the existing `_bmad/` install without touching `core`, `bmm`, or `teambuilder`. The generated team's agents and skills land in `.claude/skills/` automatically. Restart Claude Code to see them.

### Invoking generated team agents

Once installed, generated team agents are available as slash commands:

```
/bmad-agent-{role-name}           # talk to a specific team agent
```

They work exactly like any other BMAD agent: load config via `bmad-init`, greet the user, present a menu of capabilities, wait for input.

---

## Memory System

TeamBuilder uses [Memory MCP](https://www.npmjs.com/package/@modelcontextprotocol/server-memory) as each generated team's persistent knowledge graph. The MCP server stores entities (concepts, facts, tool learnings) in a JSONL file that persists across Claude Code sessions.

### Two entity types

Every memory entity must be typed as either:

- **`GeneralKnowledge`** — reusable across any project. Examples: CLI tricks, MCP server behaviors, API quirks, shell patterns. These are eligible for cross-team consolidation into a shared pool.
- **`ProjectKnowledge`** — specific to this team or project. Examples: domain-specific config, stakeholder preferences, project decisions, credentials (don't store credentials), site-specific auth flows.

The classification is decided at **write time** by the agent saving the entity. Once saved as `ProjectKnowledge`, it will never be consolidated into the shared pool even if the observation is actually general.

### Two storage locations

- **Team memory file:** `_bmad-output/teams/{team-name}/memory.jsonl` (configured via `.mcp.json` `MEMORY_FILE_PATH` env var). Contains both `GeneralKnowledge` and `ProjectKnowledge` entries for this specific team.
- **Cross-team consolidation target:** `_bmad/teambuilder/memory/general-knowledge.jsonl`. When the Memory Manager agent runs a consolidation pass, it scans all team memory files in the project, extracts `GeneralKnowledge` entries, and merges them here. New teams are seeded from this file so they start with accumulated wisdom.

### How learnings get captured

Every generated team has a `bmad-skill-save-session` skill. You invoke it by selecting `[SS]` from any team agent's menu at the end of a working session. It does two things:

1. **Reviews your session for tool learnings.** Looks for calls that failed then succeeded with different parameters, unexpected API behaviors, configuration workarounds, rate-limit discoveries, site-specific patterns. Saves each one to Memory MCP with the correct `entityType` after classifying via `bmad-skill-memory-guide`.
2. **Compiles a session summary.** What you worked on, where you left off, what's next, key decisions, important file locations. Writes it to `_bmad-output/teams/{team-name}/session-context.md`.

Next time you invoke any agent from that team, the session context is auto-loaded so the agent picks up where you left off without needing to re-explain your project.

### Cross-team consolidation

Over time, each team accumulates tool learnings. Some of those are genuinely general (e.g. "Memory MCP uses `MEMORY_FILE_PATH`, not `MEMORY_PATH`") and would benefit any team. The `bmad-agent-memory-manager` agent consolidates these:

```
/bmad-agent-memory-manager
```

Select the "Consolidate General Knowledge" option. Memory Manager will:

1. Scan every team memory file in the project.
2. Extract all `GeneralKnowledge` entries.
3. Deduplicate and merge them into `_bmad/teambuilder/memory/general-knowledge.jsonl`.
4. Report what was added.

From then on, every newly generated team starts with those consolidated learnings pre-loaded.

If you fork this repo, commit `general-knowledge.jsonl` to your fork. Your accumulated general knowledge persists across installs and benefits every future team you create. Team-specific `memory.jsonl` files are gitignored by default — they contain project-specific data.

### What NOT to put in memory

- ❌ API keys, tokens, passwords
- ❌ Personal / PII
- ❌ Content you wouldn't want in a plain-text JSONL file on your disk
- ❌ Anything you're not willing to see in a future consolidated pool

Memory Manager does **not** redact or encrypt. It is your responsibility to review what gets saved. If you're unsure, classify as `ProjectKnowledge` (which is never consolidated) or don't save it at all.

---

## Configuration

TeamBuilder's runtime configuration lives in `_bmad/teambuilder/config.yaml` after install. Key settings you might want to tune:

```yaml
# Quality thresholds (0-100)
quality_thresholds:
  excellent: 95    # install immediately
  good: 85         # ready to use
  acceptable: 75   # refinement recommended
  minimum: 60      # below this → regenerate

# Generation settings
generation:
  default_team_size: "6-8"
  min_agents: 4
  max_agents: 12
  require_coordinator: true
  require_domain_expert: true
  persona_distinctness_threshold: 0.6    # 0 = anything goes, 1 = must be completely distinct

# Validation weights (must sum to 1.0)
validation:
  agent_check_weight: 0.4
  workflow_check_weight: 0.3
  team_check_weight: 0.3
  max_refinement_iterations: 3

# Discovery
discovery:
  min_questions: 5
  max_questions: 10
  enable_domain_branching: true
```

Other knobs include: `user_preferences` (collaboration style defaults, auto-install threshold), `feature_flags` (enable/disable experimental features), and `refinement.supported_refinements` (which kinds of targeted changes Refine can make).

Most users should leave these alone. They're exposed for advanced cases.

---

## Project Layout After Install

```
your-project/
├── _bmad/                            # BMAD install root (don't edit directly)
│   ├── _config/                      # manifest CSVs + manifest.yaml (auto-generated)
│   │   ├── agent-manifest.csv
│   │   ├── skill-manifest.csv
│   │   ├── files-manifest.csv
│   │   └── manifest.yaml
│   ├── core/                         # BMAD core module (13 skills)
│   ├── bmm/                          # BMAD Method Module (general software dev agents)
│   └── teambuilder/                  # TeamBuilder custom module
│       ├── config.yaml
│       ├── agents/                   # 6 user-facing TeamBuilder agents
│       ├── skills/                   # 5 TeamBuilder workflow skills
│       ├── patterns/                 # 6 pattern libraries
│       ├── templates/
│       │   ├── _team-skills/         # Copied into generated teams at generation time
│       │   └── validation-rules.yaml
│       └── memory/
│           └── general-knowledge.jsonl
├── _bmad-output/                     # Output/work folder (default)
│   └── teams/                        # Generated teams (pre-install staging)
│       └── your-team-name/
├── _bmad/teams-your-team-name/       # Installed generated teams (after bmad install)
├── .claude/
│   └── skills/                       # Claude Code's skill index (auto-managed by BMAD)
├── docs/                             # Team knowledge base (reference docs, .md files)
├── .mcp.json                         # Memory + Playwright MCP server config
└── .gitignore                        # Includes TeamBuilder rules
```

---

## Troubleshooting

**Run `doctor.ps1` or `doctor.sh` first.** Most issues below can be auto-detected. The doctor script runs the full compatibility test suite (42+ checks) plus `bmad status` and reports a structured pass/fail summary in seconds. It is read-only and safe to run anytime.

```powershell
# Windows
.\scripts\doctor.ps1
```

```bash
# Linux/macOS
bash scripts/doctor.sh
```

**The installer says "TeamBuilder is already installed in this directory."**
You already have `_bmad/teambuilder/`. To **update** instead of reinstall, use `scripts/update.ps1` (Windows) or `scripts/update.sh` (Linux/macOS) — it preserves your generated teams. To **start over**, delete `_bmad/` manually (back up any generated teams in `_bmad/teams-*/` first) and rerun the installer.

**BMAD install fails with "Node.js not found" or version mismatch.**
Install Node.js 18 or newer from https://nodejs.org/ and re-run the installer. The installer checks `node --version` on startup.

**Claude Code doesn't see the new agents after install.**
Restart Claude Code completely. Skills are discovered on startup. If restarting doesn't help, check that `.claude/skills/bmad-agent-team-guide/SKILL.md` exists — BMAD's installer should have created it.

**`/bmad-agent-team-guide` fails with "config loading failed."**
Check that `_bmad/teambuilder/config.yaml` exists and is readable. If it's missing, rerun the installer. If `bmad-init` reports `init_required`, the install is incomplete — delete `_bmad/teambuilder/` and reinstall.

**Generated team agents report `init_required` at runtime.**
The generated team's `module.yaml` is missing the `code: teams-{name}` prefix. Edit `_bmad/teams-{name}/module.yaml` and add `code: teams-<exact-directory-name>` at the top. Restart Claude Code. If that doesn't fix it, regenerate the team (TeamBuilder's validation-rules.yaml flags this as a Critical issue — it should have been caught).

**`bmad status` doesn't list a generated team.**
The team was generated but not installed. Run the fully non-interactive install command from the project root: `npx bmad-method@6.2.2 install --directory "<project-root>" -y --modules bmm --tools claude-code --custom-content "<team-path>"`. If you omit `--directory` or `-y` or `--modules` or `--tools`, BMAD drops into an interactive TUI and will block a non-interactive caller.

**Memory MCP isn't persisting anything.**
Check `.mcp.json` — the `memory` server's `MEMORY_FILE_PATH` env var should point at an absolute path. Check that the file exists and is writable. Test by manually running: `echo '{}' >> <memory-file-path>`.

**The `docs/` folder isn't being auto-loaded.**
`docs/` is loaded by generated team agents on activation (not by TeamBuilder's own agents). This only matters after you've created and installed your first team.

**I want to completely start over.**
Delete `_bmad/` and `_bmad-output/` and `.claude/skills/` (back up any generated teams first!). Then rerun the installer.

---

## Development / Contributing

TeamBuilder is open to contributions. The repo layout:

```
teambuilder/                          # (this repo, named dexusno/teambuilder on GitHub)
├── README.md                         # (this file)
├── LICENSE                           # MIT
├── teambuilder/                      # The BMAD v6 custom module (installed to _bmad/teambuilder/)
│   ├── module.yaml                   # Module metadata (code: teambuilder, version: 3.0.0)
│   ├── config.yaml                   # Runtime config template
│   ├── agents/                       # 6 agents
│   ├── skills/                       # 5 skills
│   ├── patterns/                     # 6 pattern libraries
│   ├── templates/
│   │   ├── _team-skills/             # Templates copied into generated teams
│   │   │   ├── bmad-skill-save-session/
│   │   │   └── bmad-skill-memory-guide/
│   │   └── validation-rules.yaml     # 42+ rules driving bmad-skill-validate-team
│   └── memory/
│       └── general-knowledge.jsonl   # Seed for new teams (commit your consolidated knowledge)
├── scripts/
│   ├── install.ps1                   # Windows installer
│   ├── install.sh                    # Linux/macOS installer
│   └── README.md                     # Script usage notes
└── templates/                        # Legacy (kept for git history, not used at runtime)
```

**Running a local checkout against a sandbox project** without pushing:

```powershell
# Windows
cd C:\some\sandbox\project
D:\path\to\teambuilder\scripts\install.ps1 -Yes -LocalSource D:\path\to\teambuilder\teambuilder
```

```bash
# Linux/macOS
cd ~/some/sandbox/project
bash /path/to/teambuilder/scripts/install.sh -y --local-source /path/to/teambuilder/teambuilder
```

**Where the "module" is:** inside the repo, the BMAD v6 custom module lives at `teambuilder/teambuilder/` (repo → module-dir). The installer's `TEAMBUILDER_MODULE_PATH` constant points at the inner `teambuilder/` directory.

**Adding a new pattern:** create a new directory under `teambuilder/patterns/{your-pattern}/` with the six standard files (`metadata.yaml`, `pattern-overview.md`, `example-agents.md`, `example-workflows.md`, `collaboration-model.md`, `generation-guidance.md`). Mirror the shape of an existing pattern. Add a row for it under `patterns.pattern_list` in `teambuilder/config.yaml`.

**Adding a new validation rule:** edit `teambuilder/templates/validation-rules.yaml`. Rules are grouped by dimension (`agent_checks`, `workflow_checks`, `team_checks`) and have `severity` (critical / high / medium / low) and `score_impact` fields. The file documents its schema at the top.

**Testing:** at minimum, run `scripts/install.ps1 -Yes -LocalSource <path>` against a fresh empty directory and verify `bmad status` shows teambuilder as a Custom Module with version 3.0.0. Phase 4's smoke test (hand-crafted fake generated team) is a useful template for more thorough validation.

---

## Version History

| Version | Date | Notes |
|---|---|---|
| **3.2.2** | 2026-04-09 | **Fully automatic team install (the actual fix).** v3.2.1 made the install command non-interactive, but the generate-team and collaborative-generation workflows still told the user to *copy-paste and run* the command themselves. That defeats TeamBuilder's core design promise: end-to-end automation with no manual install steps. v3.2.2 rewrites `bmad-skill-generate-team` Step 10 into a 6-sub-step automation protocol (10.1 through 10.6) that tells the agent to **run the install itself via its Bash tool**, verify the post-install state (team directory, manifest rows, `.claude/skills/` population), and report success or failure with specific evidence. `bmad-skill-collaborative-generation` Phase 4 "If INSTALL" now delegates to Step 10 instead of showing the command to the user. The README "First Team Quick Start" step 8 and "Installing a generated team" section are rewritten accordingly. The only remaining manual step is restarting Claude Code so it re-scans `.claude/skills/` — a client-side thing TeamBuilder cannot do for the user. Memory MCP `.mcp.json` patches are still shown (not auto-applied) because `.mcp.json` is user-space config. |
| **3.2.1** | 2026-04-09 | **Hotfix: non-interactive install command.** The install command shown in `bmad-skill-generate-team`, `bmad-skill-collaborative-generation`, and three places in the README was missing `--directory`, `--modules bmm`, and `--tools claude-code` flags. Without them BMAD drops into an interactive clack TUI asking for the installation directory, which an LLM-driven team-guide agent cannot answer — it would hang forever. All five install-command templates now show the fully non-interactive form. The team-guide agent can now actually run the install via a Bash tool call without blocking on prompts. Reported by a real user who hit this on first team generation. No other code changes. |
| **3.2.0** | 2026-04-08 | **Channels + runtime drift warning + CI smoke test (Phase 6b).** Added `-Channel` / `--channel` flag to `install.*` and `update.*` (`stable` default, `beta` and `nightly` opt-in via npm `next` dist-tag). Non-stable channels print a yellow warning and require confirmation. Added a runtime drift check to `bmad-agent-team-guide` activation that loads `compatibility.json`, compares the installed BMAD version, and warns the user (non-fatal) if the version is blocked, untested-in-range, or out-of-range. Added GitHub Actions smoke-test workflow `.github/workflows/smoke-test.yml` running install + compat-check + doctor + bmad status across `{ubuntu, windows} × {Node 18, 20, 22}` on every push, PR, and daily cron. |
| **3.1.0** | 2026-04-08 | **Compatibility guardrails (Phase 6a).** Added `compatibility.json` (BMAD version matrix + structural invariants), `scripts/lib/compat-check.js` (zero-dependency Node engine), `scripts/doctor.{ps1,sh}` (read-only diagnostics), `scripts/update.{ps1,sh}` (safe in-place update with snapshot + rollback). Update never touches `_bmad/teams-*/`. All 7 Phase 6a tests pass: doctor on healthy install, doctor JSON output, doctor on corrupted install detects failure, update succeeds and re-validates, backup snapshot preservation, refusal on non-installed targets, cleanup. |
| **3.0.0** | 2026-04-08 | **Full port to BMAD v6.2.2 architecture.** SKILL.md + bmad-skill-manifest.yaml replace v5 XML agent files. 42+ validation rules rewritten for v6. 6 pattern libraries rewritten (~55,000 words of v6-shape examples). Team-skills templates become first-class skills in generated teams. Installer rewritten to use BMAD's `--custom-content` flow (no more manual manifest editing, no more `.claude/commands/` stubs). The critical `teams-{name}` module code convention for generated teams. |
| **2.0.0** | 2025-12-02 | Dynamic generation architecture with pattern library (BMAD v5) |
| **1.0.0** | 2025-11-29 | Initial pre-built ITIL Configuration Management team |

v3.x is **not backward compatible** with v2.x — the v5 architecture and v6 architecture are fundamentally different. If you have v2-generated teams, you'll need to regenerate them with v3 for use on BMAD v6.

v3.1 and v3.2 are fully backward compatible with v3.0 — `update.ps1` / `update.sh` will detect any v3.x install, snapshot it, and upgrade in place to the latest. See [CHANGELOG.md](CHANGELOG.md) for the full per-release diff.

---

## License

MIT License. See [LICENSE](LICENSE) for the full text. You are free to use, modify, and distribute this software. No warranty is provided — see the disclaimer below.

---

## Disclaimer

**TeamBuilder is an experimental, community-maintained tool. It is provided "as is" with no warranty, express or implied.**

By using TeamBuilder you acknowledge:

1. **Generated teams are suggestions, not guarantees.** TeamBuilder's generation pipeline produces coherent, structurally-correct, and domain-tailored teams, but the quality depends on your discovery answers, the pattern library, the underlying LLM, and BMAD's own correctness. You are responsible for reviewing every generated persona, workflow, and decision before using a team for real work. Read the `VALIDATION_REPORT.md` carefully. Refine anything that looks off.

2. **AI-generated content can be wrong.** Generated agents may produce confident-sounding but incorrect domain claims. Workflows may miss edge cases. Personas may reflect stereotypes. Do not use TeamBuilder-generated teams to make decisions with legal, financial, medical, safety, or other high-stakes consequences without independent human review.

3. **TeamBuilder is not affiliated with Anthropic.** TeamBuilder is a third-party tool that runs on top of Claude Code. It is not produced, endorsed, reviewed, or supported by Anthropic. Bug reports and feature requests should go to this repository, not to Anthropic.

4. **TeamBuilder is not affiliated with the BMAD-METHOD project.** TeamBuilder is an independent custom module that installs into BMAD v6 via the `--custom-content` flow. The BMAD Method is created and maintained by [bmad-code-org](https://github.com/bmad-code-org). Bug reports about BMAD itself should go there, not to this repository.

5. **Do not store secrets in TeamBuilder.** Generated team files, memory files, and session context files are stored as plain text on your local disk. Team files are committed to git by default (only `memory.jsonl` and `session-context.md` are gitignored). Do not put API keys, passwords, personal data, or any other secrets into agent personas, workflow files, or Memory MCP entries. TeamBuilder does not redact, encrypt, or sanitize content.

6. **Memory MCP runs locally by default.** The `@modelcontextprotocol/server-memory` package is run locally via `npx` and reads/writes only the file specified by `MEMORY_FILE_PATH`. No data is sent to external services under the default configuration. If you modify `.mcp.json` to use a different memory backend (remote, cloud, shared), understand the implications before doing so.

7. **Playwright MCP can execute browser automation.** If you enable Playwright MCP (the default), be aware that any agent using it can drive a real browser on your machine. Review automation commands before approving them. Playwright MCP does not sandbox or limit what URLs the browser visits.

8. **Updates can break existing installs.** BMAD and TeamBuilder both evolve. A future version of BMAD may introduce schema changes that break currently-installed TeamBuilder modules. The installer pins BMAD to version 6.2.2 for this reason, but if you manually install a different version, you may encounter breakage. A compatibility-check script (`doctor.ps1`) is planned for a future release.

9. **TeamBuilder does not modify any files outside the project directory it's installed into.** But `npx bmad-method install` modifies its own npm cache and may download packages. The installer writes to `_bmad/`, `_bmad-output/`, `.claude/skills/`, `.mcp.json`, `docs/`, and `.gitignore` in the current directory. Review the [What the installer does](#what-the-installer-does) section above for the full list.

10. **No support guarantee.** TeamBuilder is maintained in the author's spare time. Issues and PRs are welcome but response times are not guaranteed. Critical bugs should be reported via GitHub Issues at https://github.com/dexusno/teambuilder/issues. There is no commercial support, no SLA, and no hotline.

**Use TeamBuilder at your own risk. You are responsible for what you generate, what you install, what you commit, and what you run against production systems.**

---

## Links

- **TeamBuilder repository:** https://github.com/dexusno/teambuilder
- **Bug reports:** https://github.com/dexusno/teambuilder/issues
- **BMAD Method:** https://github.com/bmad-code-org/BMAD-METHOD
- **BMAD docs:** https://docs.bmad-method.org/
- **Claude Code:** https://claude.ai/product/claude-code
- **Memory MCP:** https://www.npmjs.com/package/@modelcontextprotocol/server-memory
- **Playwright MCP:** https://www.npmjs.com/package/@playwright/mcp
- **MCP servers directory:** https://github.com/modelcontextprotocol/servers

---

_TeamBuilder v3.2.2 — built with care, run with caution, and always read the validation report._
