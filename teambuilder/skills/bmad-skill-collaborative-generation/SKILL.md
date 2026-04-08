---
name: bmad-skill-collaborative-generation
description: "Master TeamBuilder workflow that orchestrates the full pipeline for generating a custom AI agent team: discovery → paired generation with real-time quality feedback → critical review and scoring → user decision (install / refine / regenerate). Uses the team-architect, persona-improver, quality-guardian, and tool-scout agents in coordinated phases. Use when the user wants to create a new team end-to-end."
---

# Collaborative Team Generation — Master Workflow

The flagship TeamBuilder workflow. Coordinates four agents through four phases to produce a high-quality custom AI agent team for the user's domain.

## Participating Agents

| Agent | Role |
|-------|------|
| `bmad-agent-team-architect` | Discovery lead, structural designer, generation coordinator |
| `bmad-agent-persona-improver` | Persona quality specialist, real-time consultant during generation |
| `bmad-agent-quality-guardian` | Final quality validator, critical reviewer |
| `bmad-agent-tool-scout` | MCP / tool researcher, recommends integrations for the new team |

## On Activation

1. Invoke `bmad-init` with `--module=teambuilder` to load configuration.
2. Verify the four participating agents are installed (check `_bmad/_config/agent-manifest.csv` for the four `bmad-agent-team-*`/`bmad-agent-persona-*`/`bmad-agent-quality-*`/`bmad-agent-tool-*` entries). If any are missing, STOP and report which agent is unavailable.
3. Read fully and follow the workflow in `./workflow.md`.

## Outputs

A complete generated team produced under `{output_folder}/teams/{team-name}/` containing:

- `requirements.md` (from discovery)
- `agents/bmad-agent-*/SKILL.md` + `bmad-skill-manifest.yaml` (one directory per user-facing agent)
- `skills/bmad-skill-*/SKILL.md` (+ `workflow.md` + `template.md` per team workflow)
- `TOOL_RECOMMENDATIONS.md` (from tool-scout)
- `VALIDATION_REPORT.md` (from quality-guardian)
- `TEAM_README.md` (overview)
- `config.yaml` (team metadata)

## Notes

- All BMAD manifest registration, `.claude/skills/` installation, and module discovery happens **automatically** when the user later runs `npx bmad-method install --custom-content {output_folder}/teams/{team-name}` to install the generated team. This skill does NOT manually edit BMAD's internal manifests — that's a v5-era pattern that no longer applies.
- The workflow is resumable: if the user breaks off mid-pipeline, the current phase state can be inferred from which output files exist.
- Quality is built in **during** generation via the team-architect ↔ persona-improver pairing, not via a separate review pass.
