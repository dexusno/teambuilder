# Tool Learning Review

This is a reusable workflow step for reviewing and saving tool learnings to memory MCP.
It can be included as the final step in any team workflow, or invoked standalone.

## Instructions

<step n="1" goal="Review Tool Learnings">

<ask>Before we wrap up, let's capture any tool learnings from this session.

Did any of the following happen?
1. A tool/API/MCP call **failed** and you found a **working method** after trying alternatives
2. You discovered a **CLI command pattern** that wasn't obvious
3. You found specific **parameter requirements** for an MCP method
4. You learned a **configuration trick** for a tool or service

If yes, briefly describe what you learned. If nothing new, just say "nothing new".</ask>

</step>

<step n="2" goal="Classify and Save Learnings">

<check if="user reports tool learnings">

<action>Load memory guide from {project-root}/_bmad/teams/{team-name}/memory-guide.md</action>

<action>For each learning reported, classify it:

**GeneralKnowledge test (ALL must be true):**
1. About a tool, CLI command, MCP method, API behavior, or shell technique?
2. Would help ANY project (not just this one)?
3. About how software/APIs/services work in general?
4. Contains NO project names, team names, or project-specific references?

If ALL true → GeneralKnowledge, name as `general:{category}:{topic}`
If ANY false → ProjectKnowledge, name as `{team-name}:{category}:{topic}`
</action>

<action>Save to memory MCP:
- Use `create_entities` with name, entityType (GeneralKnowledge or ProjectKnowledge), and observations array
- Observation should describe the working method clearly enough to reproduce it
- If entity already exists, use `add_observations` to add the new learning
</action>

<action>Confirm what was saved: "Saved {count} tool learning(s) to memory. These will be available next session."</action>

</check>

<check if="no tool learnings to report">
<action>Acknowledge: "No new tool learnings this session. Moving on."</action>
</check>

</step>
