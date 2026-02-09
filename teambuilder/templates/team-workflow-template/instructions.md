# {{Workflow Name}} Instructions

## Workflow

<workflow>
<critical>The workflow execution engine is governed by: {project-root}/_bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>Communicate all responses in {communication_language}</critical>
<critical>CHECKPOINT PROTOCOL: After EVERY template-output tag, you MUST follow workflow.xml substep 2c: SAVE content to file immediately, SHOW checkpoint separator, DISPLAY generated content, PRESENT options [a]Advanced Elicitation/[c]Continue/[p]Party-Mode/[y]YOLO, WAIT for user response. Never batch saves or skip checkpoints.</critical>

<step n="1" goal="{{First Step Goal}}">

{{Step description and context}}

<ask>{{Question to gather user input}}</ask>

<action>{{Action to perform based on input}}</action>

<template-output>{{section_variables}}</template-output>

</step>

---

<step n="2" goal="{{Second Step Goal}}">

{{Step description}}

<action>{{Primary action}}</action>

<check if="{{condition}}">
  <action>{{Conditional action}}</action>
</check>

<template-output>{{section_variables}}</template-output>

</step>

---

<!-- Additional steps as needed for this workflow's domain -->
<!-- Each step should have a clear goal, actions, and a template-output checkpoint -->

---

<step n="final" goal="Review & Save Learnings">

<action>Summarize what was accomplished in this workflow</action>

<ask>Did any tool tasks fail then succeed during this workflow? If yes, describe the working method you discovered.</ask>

<check if="user reports a learned method">
  <action>Load memory guide from {project-root}/_bmad/teams/{{team-name}}/memory-guide.md for entity classification rules</action>
  <action>Classify the learning: Does it pass ALL 4 GeneralKnowledge tests? If yes, create as GeneralKnowledge. If ANY test fails, create as ProjectKnowledge.</action>
  <action>Create entity in memory MCP using create_entities with correct entityType and naming convention from memory-guide.md</action>
</check>

<check if="no tool learnings to report">
  <action>Acknowledge and proceed to completion</action>
</check>

<template-output>workflow_summary, learnings_saved</template-output>

</step>

</workflow>
