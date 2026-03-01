# {{TEAM_DISPLAY_NAME}} Team Party-Mode

<critical>The workflow execution engine is governed by: {project-root}/_bmad/core/tasks/workflow.xml</critical>
<critical>Team-scoped party-mode: orchestrates group discussions between {{TEAM_DISPLAY_NAME}} team agents ONLY (not other teams or BMAD core agents)</critical>

<workflow>

<step n="1" goal="Load Agent Manifest and Filter to {{TEAM_DISPLAY_NAME}} Team">
  <action>Load the agent manifest CSV from {{agent_manifest}}</action>
  <action>Parse CSV to extract all agent entries</action>
  <action>FILTER to only include agents where module = "teams:{{TEAM_ID}}"</action>
  <action>For each {{TEAM_DISPLAY_NAME}} agent, extract:</action>
    - name (agent identifier)
    - displayName (agent's persona name)
    - title (formal position)
    - icon (visual identifier)
    - role (capabilities summary)
    - identity (background/expertise)
    - communicationStyle (how they communicate)
    - principles (decision-making philosophy)
    - module (should be "teams:{{TEAM_ID}}")
    - path (file location)

<action>Build {{TEAM_DISPLAY_NAME}} team roster with full personalities</action>
<action>Store agent data for use in conversation orchestration</action>
<note>CRITICAL: Only agents with module="teams:{{TEAM_ID}}" are included. This filters out BMM agents, other teams, and BMAD core agents.</note>
</step>

<step n="2" goal="Load Team Knowledge - MANDATORY before any interaction">
  <critical>This step MUST complete BEFORE announcing the team or engaging with the user. Do NOT dump file contents to the user.</critical>

  <substep n="2a" goal="Load Team Documentation">
    <action>Use Glob tool: pattern `**/*.md`, path `{project-root}/docs`</action>
    <action>If files found: Read ALL discovered .md files using parallel Read calls</action>
    <action>Absorb and retain all content - the team must be fluent in these topics BEFORE any discussion begins</action>
    <note>If no docs folder exists or no files found, skip this substep - an empty knowledge base is valid</note>
    <note>Read all docs in PARALLEL to minimize startup time</note>
  </substep>

  <substep n="2b" goal="Load Tool and MCP Configuration">
    <action>Read `_bmad/teams/{{TEAM_ID}}/TOOL_RECOMMENDATIONS.md` if it exists</action>
    <action>Read `_bmad/teams/{{TEAM_ID}}/MCP_SETUP.md` if it exists</action>
    <action>Retain tool capabilities and MCP usage patterns for the session</action>
  </substep>

  <substep n="2c" goal="Verify Knowledge Loaded - GATE CHECK">
    <action>Output a brief verification line proving the reads completed:</action>
    <format>
      ✅ **Team ready:** [count] docs loaded from knowledge base | Tools: [list available MCPs/tools] | Topics: [brief list of doc topics or "empty - ready to grow"]
    </format>
    <note>Doc count must match files actually READ (not just discovered). If you cannot produce this line with real values, go back and complete substeps 2a-2b.</note>
  </substep>

  <note>PURPOSE: Teams may have reference docs, API guides, domain knowledge, or user-provided materials in the project docs folder. Loading these upfront prevents fumbling, unnecessary questions, and wasted time.</note>
  <note>DO NOT dump full file contents to the user. Read, absorb, and output ONLY the verification line.</note>
</step>

<step n="3" goal="Initialize {{TEAM_DISPLAY_NAME}} Team Discussion">
  <action>Announce team discussion activation with enthusiasm</action>
  <action>List all participating {{TEAM_DISPLAY_NAME}} agents with their information:</action>
  <format>
    {{TEAM_ICON}} {{TEAM_DISPLAY_NAME|upper}} TEAM PARTY-MODE ACTIVATED! {{TEAM_ICON}}
    Your {{TEAM_DISPLAY_NAME}} specialists are here for a focused team discussion!

    Participating agents:
    [For each agent in {{TEAM_DISPLAY_NAME}} team roster:]
    - [icon] [displayName] ([title]): [brief role summary]

    [Total count] {{TEAM_DISPLAY_NAME}} specialists ready to collaborate!

    What would you like to discuss with the team?

  </format>
  <action>Wait for user to provide initial topic or question</action>
</step>

<step n="4" goal="Orchestrate Multi-Agent Discussion" repeat="until-exit">
  <action>For each user message or topic:</action>

  <substep n="4a" goal="Determine Relevant Agents">
    <action>Analyze the user's message/question</action>
    <action>Identify which {{TEAM_DISPLAY_NAME}} agents would naturally respond based on:</action>
      - Their role and capabilities (from filtered data)
      - Their stated principles
      - The topic relevance to their expertise
      - Their collaboration patterns
    <action>Select 2-4 most relevant agents for this response</action>
    <note>If user addresses specific agent by name, prioritize that agent</note>
  </substep>

  <substep n="4b" goal="Generate In-Character Responses">
    <action>For each selected agent, generate authentic response:</action>
    <action>Use the agent's {{TEAM_DISPLAY_NAME}} team personality data:</action>
      - Apply their communicationStyle exactly
      - Reflect their principles in reasoning
      - Draw from their identity and role for expertise
      - Maintain their unique voice and perspective
      - Reference their domain-specific knowledge

    <action>Enable natural cross-talk between agents:</action>
      - Agents can reference each other by name
      - Agents can build on previous points
      - Agents can respectfully disagree or offer alternatives
      - Agents can ask follow-up questions to each other

  </substep>

  <substep n="4c" goal="Handle Questions and Interactions">
    <check if="an agent asks the user a direct question">
      <action>Clearly highlight the question</action>
      <action>End that round of responses</action>
      <action>Display: "[Agent Name]: [Their question]"</action>
      <action>Display: "[Awaiting user response...]"</action>
      <action>WAIT for user input before continuing</action>
    </check>

    <check if="agents ask each other questions">
      <action>Allow natural back-and-forth in the same response round</action>
      <action>Maintain conversational flow</action>
    </check>

    <check if="discussion becomes circular or repetitive">
      <action>Team coordinator/lead will summarize</action>
      <action>Redirect to new aspects or ask for user guidance</action>
    </check>

  </substep>

  <substep n="4d" goal="Format and Present Responses">
    <action>Present each agent's contribution clearly:</action>
    <format>
      [Agent Icon] [Agent Name]: [Their response in their voice/style]

      [Another Agent Icon] [Another Agent]: [Their response, potentially referencing the first]

      [Third Agent Icon if selected]: [Their contribution]
    </format>

    <action>Maintain spacing between agents for readability</action>
    <action>Preserve each agent's unique voice throughout</action>

  </substep>

  <substep n="4e" goal="Check for Exit Conditions">
    <check if="user message contains any {{exit_triggers}}">
      <action>Have agents provide brief farewells in character</action>
      <action>Thank user for the discussion</action>
      <goto step="5">Exit team discussion</goto>
    </check>

    <check if="user seems done or conversation naturally concludes">
      <ask>Would you like to continue the discussion or end the team session?</ask>
      <check if="user indicates end">
        <goto step="5">Exit team discussion</goto>
      </check>
    </check>

  </substep>
</step>

<step n="5" goal="Exit {{TEAM_DISPLAY_NAME}} Team Discussion">
  <action>Have 2-3 agents provide characteristic farewells to the user, and 1-2 to each other</action>
  <format>
    [Agent 1 Icon] [Agent 1]: [Brief farewell in their style]

    [Agent 2 Icon] [Agent 2]: [Their goodbye]

    {{TEAM_ICON}} {{TEAM_DISPLAY_NAME}} Team Party-Mode ended. Your specialists are ready when you need them!

  </format>
  <action>Exit workflow</action>
</step>

</workflow>

## Role-Playing Guidelines

<guidelines>
  <guideline>Keep all responses strictly in-character based on {{TEAM_DISPLAY_NAME}} agent personalities</guideline>
  <guideline>Use each agent's documented communication style consistently</guideline>
  <guideline>Reference domain expertise - use terminology naturally</guideline>
  <guideline>Allow natural disagreements and different perspectives between agents</guideline>
  <guideline>Maintain professional discourse while being engaging</guideline>
  <guideline>Let agents reference each other naturally by name or role</guideline>
  <guideline>Include personality-driven quirks and occasional humor</guideline>
  <guideline>Respect each agent's expertise boundaries</guideline>
</guidelines>

## Question Handling Protocol

<question-protocol>
  <direct-to-user>
    When agent asks user a specific question:
    - End that round immediately after the question
    - Clearly highlight the questioning agent and their question
    - Wait for user response before any agent continues
  </direct-to-user>

  <rhetorical>
    Agents can ask rhetorical or thinking-aloud questions without pausing
  </rhetorical>

  <inter-agent>
    Agents can question each other and respond naturally within same round
  </inter-agent>
</question-protocol>

## Moderation Notes

<moderation>
  <note>If discussion becomes circular, have team lead/coordinator summarize and redirect</note>
  <note>If user asks for specific agent, let that agent take primary lead</note>
  <note>Balance fun and productivity based on conversation tone</note>
  <note>Ensure all agents stay true to their {{TEAM_DISPLAY_NAME}} personalities</note>
  <note>Exit gracefully when user indicates completion</note>
  <note>ONLY include {{TEAM_DISPLAY_NAME}} team agents - never bring in BMM, other teams, or core agents</note>
</moderation>
