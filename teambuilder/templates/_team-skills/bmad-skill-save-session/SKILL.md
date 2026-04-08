---
name: bmad-skill-save-session
description: "Save the current session's context and tool learnings to persistent team storage. Use when the user selects 'Save session' from any team agent's menu, at the natural end of a working session, or whenever they want continuity into the next session. Captures tool learnings into Memory MCP (classified via the memory guide) and writes a session-context.md file that the team will pick up next time."
---

# Save Session — Team Workflow Skill

This skill is copied into every generated team during TeamBuilder's `bmad-skill-generate-team` step. It gives the team a first-class way to save session state and tool-learning observations so the next session starts warm.

## Purpose

When invoked, this skill:

1. Reviews the current session for reusable tool/MCP/CLI learnings and stores them in Memory MCP using the team's `bmad-skill-memory-guide` for classification.
2. Compiles a human-readable summary of what was worked on, where things stand, what's next, key decisions, and key file locations.
3. Writes the summary to `{output_folder}/teams/{team_name}/session-context.md` so any team agent can read it at the start of the next session.

## When It Fires

- A user selects the "Save Session" / `SS` menu item from any `bmad-agent-*` in the team.
- A workflow in the team reaches its "Review & Save Learnings" final step and invokes this skill.
- The user explicitly asks to save progress before stopping.

## On Activation

1. Invoke `bmad-init` with `--module=teams-{team_name}` to load the team's config (`user_name`, `output_folder`, `communication_language`, team-specific values).
2. If config loading fails, STOP and report the missing path.
3. Load the team's `bmad-skill-memory-guide` for classification rules before saving any memory entries.
4. Read fully and follow the instructions in `./workflow.md`.

## Outputs

- Zero or more new/updated entities in Memory MCP (typed `GeneralKnowledge` or `ProjectKnowledge` per the memory guide).
- `{output_folder}/teams/{team_name}/session-context.md` (overwritten each save with the latest compiled state).

## Execution

Read fully and follow the instructions in `./workflow.md`.
