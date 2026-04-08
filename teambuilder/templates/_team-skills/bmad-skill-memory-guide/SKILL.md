---
name: bmad-skill-memory-guide
description: "Reference skill for classifying entities stored in Memory MCP as GeneralKnowledge or ProjectKnowledge, with naming conventions and examples. Use when any team workflow is about to create or update a memory entity, when `bmad-skill-save-session` is capturing tool learnings, or when the team wants to search existing memory for reusable knowledge. This is a reference skill — it does not run a workflow, it provides classification rules."
---

# Memory Guide — Team Reference Skill

This is a **reference skill**, not a workflow. It is copied into every generated team by TeamBuilder's `bmad-skill-generate-team` step. Other skills (most notably `bmad-skill-save-session`) load it to decide how to classify memory entities and how to name them.

## Purpose

Memory MCP is the team's long-term store. Every entity saved there MUST be typed as either:

- `GeneralKnowledge` — reusable across any project
- `ProjectKnowledge` — specific to this team / project / domain

Classifying correctly is what makes cross-team consolidation possible: `GeneralKnowledge` entries from many teams can later be merged into a shared knowledge pool at `{project-root}/_bmad/teambuilder/memory/general-knowledge.jsonl`, while `ProjectKnowledge` stays local to the team.

## When It Fires

This skill is **read**, not run. Other skills load it before calling Memory MCP. Typical triggers:

- `bmad-skill-save-session` is about to persist tool learnings.
- A workflow step wants to record a project decision or configuration detail.
- An agent is searching memory for previously-discovered tool behavior.

## On Activation

If another skill loads this one as a reference:

1. Ensure `bmad-init --module=teams-{team_name}` has been called (by the caller) so the team name is resolved.
2. Read fully the classification and naming content in `./reference.md`.
3. Apply the rules; return control to the caller.

## Content

All classification rules, naming conventions, examples, and the Memory MCP tools cheat-sheet live in `./reference.md`. Read that file in full when you need to classify or name entities.

## Cross-Team Consolidation

`GeneralKnowledge` entities from every TeamBuilder-generated team can be consolidated into the shared TeamBuilder memory pool so future teams start with accumulated wisdom. `ProjectKnowledge` entities stay within the team that produced them. The classification decision made here, at write time, determines whether a learning ever becomes reusable — classify carefully.
