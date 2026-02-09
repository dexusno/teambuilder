# Save Session Context

This file is loaded when a user selects "Save session for next time" from any agent's menu.
It gathers project state and writes it to the team's session-context.md file.

## Instructions

<step n="1" goal="Gather Session State">

Ask the user about the current session to capture project state:

<ask>Let me save our session context for next time. Quick summary:

1. **What did we work on today?** (main tasks, features, investigations)
2. **Where did we leave off?** (current status, what's in progress)
3. **What's next?** (planned next steps, priorities)
4. **Any important decisions made?** (choices, tradeoffs, direction changes)
5. **Key file locations?** (configs, outputs, important paths discovered)

You can answer all at once or I'll ask follow-ups.</ask>

</step>

<step n="2" goal="Write Session Context">

<action>Compile the user's responses into a structured session context document</action>

<action>Write the following to `_bmad/teams/{team-name}/session-context.md`:</action>

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
