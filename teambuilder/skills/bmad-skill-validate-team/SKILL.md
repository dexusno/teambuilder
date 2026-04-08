---
name: bmad-skill-validate-team
description: "Automated quality assessment of generated teams. Runs 30+ validation checks across agent, workflow, and team-coherence levels using templates/validation-rules.yaml, calculates a 0-100 quality score with severity-weighted deductions, and produces a VALIDATION_REPORT.md with actionable recommendations. Invoked by bmad-agent-quality-guardian during Phase 3 of collaborative-generation, or directly when a user wants a critical review of an existing team."
---

# Validate Team — Workflow Skill

Automated quality assessment of generated teams. This is the final checkpoint before the user sees the team — it catches issues the paired generation should have prevented and turns them into a structured, actionable report.

## Overview

Runs three categories of validation checks:

- **Agent checks** — role clarity, persona quality, domain expertise, distinctness, architecture compliance
- **Workflow checks** — completeness, actionability, agent references, coherence
- **Team checks** — coverage, team size, collaboration model, domain alignment

The checks are loaded from `{project-root}/_bmad/teambuilder/templates/validation-rules.yaml`. Each failed check deducts points weighted by severity. The final score is mapped to a rating (Excellent / Good / Acceptable / Needs Work / Regenerate) and a recommended action.

## On Activation

1. Invoke `bmad-init` with `--module=teambuilder` to load configuration (quality thresholds, validation weights).
2. Expect either a team path (invoked directly) or the output of `bmad-skill-generate-team` (invoked from `bmad-skill-collaborative-generation` Phase 3).
3. Read fully and follow `./workflow.md`.
4. On completion, write the validation report to `{output_folder}/teams/{team-name}/VALIDATION_REPORT.md` and return score + rating + recommended action to the caller.

## Output

`{output_folder}/teams/{team-name}/VALIDATION_REPORT.md` following `./template.md`.

## Execution

Read fully and follow the instructions in `./workflow.md`.
