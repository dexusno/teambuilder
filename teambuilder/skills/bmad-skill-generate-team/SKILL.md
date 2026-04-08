---
name: bmad-skill-generate-team
description: "Core generation engine that transforms a team-requirements document into a complete, installable AI agent team. Loads pattern library examples to learn composition principles, then creates original agents, workflow skills, and team metadata files under {output_folder}/teams/{team-name}/. Invoked as Phase 2 of bmad-skill-collaborative-generation, in real-time pairing with bmad-agent-persona-improver."
---

# Generate Team — Workflow Skill

Core generation engine that creates custom AI agent teams from requirements. Produces a complete, installable team package that BMAD can register automatically via `npx bmad-method install --custom-content`.

## Overview

This skill transforms a team-requirements document (from `bmad-skill-discover-team-needs`) into a complete AI agent team with distinct personas and actionable workflow skills. The generation process uses the pattern library to learn composition principles, then creates an entirely new team tailored to the user's specific needs.

**Architecture (v6):**
- **User-facing agents** → directory `agents/bmad-agent-{name}/` with `SKILL.md` + `bmad-skill-manifest.yaml` (where `type: agent`)
- **Skill-only sub-agents** → directory `agents/bmad-agent-{name}/` with just `SKILL.md`, or included as a specialist referenced from workflows
- **Team workflows** → directory `skills/bmad-skill-{workflow-name}/` with `SKILL.md` + `workflow.md` (+ `template.md` when the workflow produces a structured document)

## Critical Principles

1. **LEARN from patterns, NEVER COPY** — patterns teach principles, not templates
2. **Distinct personas are non-negotiable** — each agent must be memorable and unique
3. **Domain expertise must be authentic** — use terminology and context from requirements
4. **Address every key concern** — each concern gets a specialist agent
5. **Collaboration model must match user preference** — formal, agile, consultative, etc.
6. **Pair in real time with `bmad-agent-persona-improver`** — quality is built in during generation, not patched in after

## On Activation

1. Invoke `bmad-init` with `--module=teambuilder` to load configuration.
2. Expect a requirements document path to be passed in by the calling skill (typically `bmad-skill-collaborative-generation`).
3. Read fully and follow `./workflow.md`.
4. On completion, return the generated team path to the caller so Phase 3 (validation) can pick it up.

## Execution

Read fully and follow the instructions in `./workflow.md`.
