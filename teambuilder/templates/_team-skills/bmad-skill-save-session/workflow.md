# Save Session — Workflow

Captures tool learnings from the session into Memory MCP, then compiles and writes the team's session-context file.

## Prerequisites

- `bmad-init --module=teams-{team_name}` has been invoked on activation (see SKILL.md).
- The team's `bmad-skill-memory-guide` is loaded and available for classification reference.

## Step 1 — Capture Tool Learnings

**Goal:** Find reusable tool/MCP/CLI insights from this session and persist them to Memory MCP.

**Action:** Review your tool interactions from this entire session. Look for patterns worth remembering:

- Tool / MCP / CLI calls that **failed** then **succeeded** with a different approach or parameters
- Unexpected parameter requirements or formats you discovered
- Configuration tricks or workarounds that were not obvious
- Site-specific behaviors, rate limits, or access patterns

For each learning found:

1. Consult the team's `bmad-skill-memory-guide` (loaded on activation).
2. Classify using the 4-test: `GeneralKnowledge` (all four tests true) or `ProjectKnowledge` (any false).
3. Save to Memory MCP using `create_entities` with the correct `entityType` and naming convention from the memory guide.
4. If an entity already exists, use `add_observations` to append the new detail instead.

If no tool learnings are found, skip silently and proceed to Step 2.

## Step 2 — Compile Session State

**Goal:** Produce a human-readable compilation of where the session stands.

**Action:** Review the entire conversation from this session. You were present for all of it — compile the session context yourself from what happened. Extract:

1. **What we worked on** — tasks, features, investigations, discussions
2. **Where we left off** — current status, what is in progress, what is done
3. **What is next** — planned next steps, open questions, priorities discussed
4. **Key decisions made** — choices, trade-offs, direction changes
5. **Key file locations** — configs, outputs, important paths discovered or created (all under `{output_folder}/teams/{team_name}/` or `{project-root}` where relevant)

**Action:** Present the compiled summary to the user:

> "Here's what I've captured from our session:
>
> [your summary]
>
> Anything you'd like me to add or change before I save this?"

**Action:** Incorporate any corrections or additions the user provides.

## Step 3 — Write Session Context

**Goal:** Persist the compiled state to disk so the next session loads it automatically.

**Action:** Write the final session context to `{output_folder}/teams/{team_name}/session-context.md` using this template:

```markdown
# Session Context — {team_name}

**Last Updated:** {date}
**Updated By:** {agent_name}

## What We Worked On
{summary of tasks and activities}

## Current Status
{where things stand, what's in progress}

## Next Steps
{planned next actions, priorities}

## Key Decisions
{important choices made, trade-offs accepted}

## Key Locations
{important file paths, configs, outputs discovered}

## Notes
{any additional context for next session}
```

**Action:** Confirm to the user:

> "Session context saved to `{output_folder}/teams/{team_name}/session-context.md`. Next time any team agent activates, they'll pick up where we left off."

## Completion Criteria

- [ ] Tool learnings (if any) saved to Memory MCP with correct `entityType`
- [ ] Session summary reviewed and confirmed with user
- [ ] `session-context.md` written under `{output_folder}/teams/{team_name}/`
- [ ] User notified of successful save
