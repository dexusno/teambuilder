# Save Session Context

This file is loaded when a user selects "Save session for next time" from any agent's menu.
It compiles project state from the conversation and writes it to the team's session-context.md file.

## Instructions

<step n="1" goal="Compile Session State">

<action>Review the entire conversation from this session. You were present for all of it - compile the session context yourself from what happened. Extract:

1. **What we worked on** - tasks, features, investigations, discussions
2. **Where we left off** - current status, what's in progress, what's done
3. **What's next** - planned next steps, open questions, priorities discussed
4. **Key decisions made** - choices, tradeoffs, direction changes
5. **Key file locations** - configs, outputs, important paths discovered or created
</action>

<action>Present your compiled summary to the user:

"Here's what I've captured from our session:

[your summary]

Anything you'd like me to add or change before I save this?"
</action>

<action>Incorporate any corrections or additions the user provides.</action>

</step>

<step n="2" goal="Write Session Context">

<action>Write the final session context to `_bmad/teams/{team-name}/session-context.md`:</action>

```markdown
# Session Context - {team-name}

**Last Updated:** {date}
**Updated By:** {agent_name}

## What We Worked On
{summary of tasks and activities}

## Current Status
{where things stand, what's in progress}

## Next Steps
{planned next actions, priorities}

## Key Decisions
{important choices made, tradeoffs accepted}

## Key Locations
{important file paths, configs, outputs discovered}

## Notes
{any additional context for next session}
```

<action>Confirm to user: "Session context saved! Next time any team agent activates, they'll pick up where we left off."</action>

</step>
