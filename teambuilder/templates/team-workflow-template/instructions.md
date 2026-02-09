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

<!-- No final tool-learning step needed here.
     Tool learnings are captured automatically when the user saves the session via [SS] Save Session.
     The save-session.md shared workflow handles both tool learning review and session context. -->

</workflow>
