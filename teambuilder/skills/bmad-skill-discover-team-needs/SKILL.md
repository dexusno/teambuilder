---
name: bmad-skill-discover-team-needs
description: "Discover what kind of AI agent team the user needs through a guided 10-step interview with domain-specific question branching. Use when the user wants to start building a new team, or when the team-guide agent invokes this as the first phase of collaborative-generation. Captures requirements into a structured document for the generation phase."
argument-hint: "[--auto-continue=true|false]"
---

# Discover Team Needs — Workflow Skill

This skill captures user requirements for team generation through a guided 10-step interview. It is the first phase of the TeamBuilder collaborative-generation pipeline and produces a `team-requirements-{timestamp}.md` document that the next phase consumes.

## Overview

Goal: gather enough context to generate a highly customized team with relevant expertise and appropriate structure. The questions adapt based on the user's domain — healthcare teams need different context than software teams.

## On Activation

1. Invoke the `bmad-init` skill with `--module=teambuilder` to load configuration values (`user_name`, `communication_language`, `output_folder`, plus all TeamBuilder discovery settings).
2. Load the workflow definition from `./workflow.md` and follow it step by step.
3. The output document template is at `./template.md` — fill it in with captured variables and write it to `{output_folder}/teams/team-requirements-{timestamp}.md`.
4. When complete, return control to the calling skill (typically `bmad-skill-collaborative-generation`) with the path to the requirements document.

## Critical Success Factors

1. **Ask open-ended questions first** — let the user explain in their own words.
2. **Listen for domain signals** — the user's terminology reveals the domain.
3. **Branch intelligently** — domain-specific questions unlock generation quality.
4. **Capture concerns explicitly** — these drive specialist agent creation.
5. **Summarize and confirm** — ensure understanding before generation begins.

## Execution

Read fully and follow the instructions in `./workflow.md`.
