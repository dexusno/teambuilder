---
name: bmad-skill-refine-team
description: "Targeted improvement workflow for generated teams with quality issues. Fixes specific problems surgically rather than regenerating wholesale, preserves what passed validation, and re-runs bmad-skill-validate-team to measure improvement. Up to 3 iterations. Invoked from bmad-skill-collaborative-generation Phase 4 when the user chooses 'Refine', or directly from bmad-agent-team-guide when a user wants to improve an existing team."
---

# Refine Team — Workflow Skill

Targeted improvement workflow for generated teams that need polish. This skill makes surgical changes to underperforming components while preserving everything that passed validation — faster than regenerating, and it maintains the good parts of the original generation.

## Overview

Given a generated team and its validation report, this skill:

1. Analyzes the issues by severity
2. Works with the user to pick a refinement focus
3. Identifies which agents/workflows need revision and which to preserve
4. Makes targeted revisions (working with `bmad-agent-persona-improver` for persona changes)
5. Re-validates via `bmad-skill-validate-team`
6. Presents the before/after score and offers next-step options

## Critical Principles

1. **Targeted, not wholesale** — fix specific issues, don't regenerate everything
2. **Preserve quality** — keep agents and workflows that passed validation
3. **Focus on highest impact** — address critical and high-severity issues first
4. **Iterative improvement** — multiple small refinements beat one big one
5. **User guidance** — let the user prioritize what matters most to them

## On Activation

1. Invoke `bmad-init` with `--module=teambuilder` to load configuration (quality thresholds, `max_refinement_iterations`).
2. Expect a team path and a validation report path from the caller.
3. Read fully and follow `./workflow.md`.
4. On completion, return new score, remaining issues, and the user's chosen next step (install / refine again / regenerate).

## Output

Updates in place:
- Revised agent files under `{team_path}/agents/`
- Revised workflow skill files under `{team_path}/skills/`
- New `{team_path}/VALIDATION_REPORT.md` (from the re-validation run)
- `{team_path}/REFINEMENT_REPORT.md` — summary of what changed and the score improvement

## Execution

Read fully and follow the instructions in `./workflow.md`.
