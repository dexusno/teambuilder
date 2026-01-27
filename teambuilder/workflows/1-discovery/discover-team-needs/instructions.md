# Discovery Workflow Instructions

Guided question workflow to capture user requirements for team generation.

## Overview

This workflow captures user needs through 10 carefully designed steps with domain-specific branching. The goal is to gather enough context to generate a highly customized team with relevant expertise and appropriate structure.

## Critical Success Factors

1. **Ask open-ended questions first** - Let user explain in their own words
2. **Listen for domain signals** - User's terminology reveals domain
3. **Branch intelligently** - Domain-specific questions unlock quality
4. **Capture concerns explicitly** - These drive specialist agent creation
5. **Summarize and confirm** - Ensure understanding before generation

---

## Step-by-Step Execution

<step n="1" goal="Initial Need Capture">

<action>
Ask open-ended question to understand what user needs help with.
</action>

<question>
"What do you need help with? Tell me about the task, project, or challenge you're facing."
</question>

<listen_for>
- Keywords indicating domain (research, plan, create, build, analyze, manage)
- Scale indicators (one-time, ongoing, large project)
- Complexity signals (simple task vs complex initiative)
- Pain points or challenges
</listen_for>

<capture>
- {{primary_task}} - Direct quote or paraphrase
- Note key phrases and terminology
</capture>

<follow_up>
If answer is too brief: "Can you elaborate a bit more? What's the context or bigger picture?"
</follow_up>

</step>

---

<step n="2" goal="Domain Classification">

<action>
Based on user's description, classify into primary domain category.
</action>

<domains>
- **research-intelligence**: Keywords like research, find, investigate, analyze data, synthesize information
- **planning-strategy**: Keywords like plan, strategy, roadmap, prioritize, stakeholders, decisions
- **creative-content**: Keywords like create, write, design, campaign, brand, content, marketing
- **technical-development**: Keywords like build, code, develop, software, system, technical, engineer
- **operations-support**: Keywords like manage, coordinate, track, support, maintain, operations, service
- **domain-specific-expert**: Keywords indicating specialized field (healthcare, legal, finance, ITIL, etc.)
</domains>

<question>
"Based on what you've shared, it sounds like this is primarily a [DOMAIN] initiative. Does that sound right?"

If unclear: "Would you describe this more as research/analysis, planning/strategy, creative work, technical development, operational management, or specialized expertise in a specific field?"
</question>

<capture>
- {{domain}} - Selected domain category
- {{domain_context}} - Any additional context user provides
</capture>

<validation>
User confirms domain classification. If incorrect, adjust based on feedback.
</validation>

</step>

---

<step n="3" goal="Scope & Scale Assessment">

<action>
Understand the scope and scale of work to inform team size and structure.
</action>

<questions>
1. **Scope**: "Is this a one-time project, an ongoing initiative, or continuous work?"
   - Capture: {{scope}}

2. **Complexity**: "How would you rate the complexity? Simple and straightforward, moderately complex, or highly complex with many moving parts?"
   - Capture: {{complexity}}

3. **Scale**: "What's the scale? Small (just you), medium (small team), or large (organization-wide)?"
   - Capture: {{scale}}
</questions>

<rationale>
- Scope informs workflow design (one-time vs iterative)
- Complexity guides team size (simple = smaller team)
- Scale affects collaboration model (small = casual, large = formal)
</rationale>

</step>

---

<step n="4" goal="Team Size Preference">

<action>
Ask about team size preference to align with user comfort level.
</action>

<question>
"How many AI agents would feel right for this work?
- **Small team (4-6 agents)**: Focused, easier to manage, good for straightforward tasks
- **Medium team (6-8 agents)**: Balanced, covers most needs, most common choice
- **Large team (8-12 agents)**: Comprehensive expertise, best for complex/multifaceted work

What feels right for your situation?"
</question>

<capture>
- {{team_size_preference}} - User's preferred range
</capture>

<guidance>
If user is uncertain:
- Simple scope + low complexity → Suggest 4-6
- Moderate scope + moderate complexity → Suggest 6-8
- Complex scope + high complexity → Suggest 8-12
</guidance>

</step>

---

<step n="5" goal="Key Concerns Identification">

<action>
Identify 3-5 key concerns or challenges that should be addressed by team specialists.
</action>

<question>
"What are your main concerns or challenges with this work? What keeps you up at night about it?

For example: quality assurance, meeting deadlines, staying within budget, stakeholder alignment, technical complexity, risk management, regulatory compliance, etc.

Tell me your top 3-5 concerns."
</question>

<capture>
For each concern mentioned:
- {{key_concern_1}} - First concern
- {{key_concern_2}} - Second concern
- {{key_concern_3}} - Third concern
- {{key_concern_4}} - Fourth concern (if mentioned)
- {{key_concern_5}} - Fifth concern (if mentioned)
- {{key_concerns}} - Array of all concerns
</capture>

<rationale>
Key concerns drive specialist agent creation. User mentions "risk management" → team will have risk specialist.
</rationale>

<follow_up>
If user struggles: "Think about: What could go wrong? What's hardest about this? What expertise do you wish you had?"
</follow_up>

</step>

---

<step n="6" goal="Domain-Specific Questions" if="domain identified">

<action>
Ask 3-5 questions tailored to the specific domain. This is CRITICAL for quality generation.
</action>

<branch if="domain == 'research-intelligence'">

<questions>
1. "What sources or types of information will you be searching? (e.g., academic papers, market data, web sources, internal documents)"
   - Capture: {{domain_specific_1}}

2. "How will you verify information credibility? Do you need fact-checking or source evaluation?"
   - Capture: {{domain_specific_2}}

3. "What's the end deliverable? (e.g., comprehensive report, executive summary, dataset, comparative analysis)"
   - Capture: {{domain_specific_3}}
</questions>

</branch>

<branch if="domain == 'planning-strategy'">

<questions>
1. "Who are the key stakeholders involved? (internal team, executives, customers, partners)"
   - Capture: {{domain_specific_1}}

2. "What's your planning horizon? (short-term tactical, medium-term initiative, long-term strategic)"
   - Capture: {{domain_specific_2}}

3. "What types of risks concern you most? (technical, financial, organizational, market, regulatory)"
   - Capture: {{domain_specific_3}}
</questions>

</branch>

<branch if="domain == 'creative-content'">

<questions>
1. "What type of content? (blog posts, marketing copy, technical docs, social media, video scripts, creative writing)"
   - Capture: {{domain_specific_1}}

2. "Is there a brand voice or style guide to follow? Any specific tone requirements?"
   - Capture: {{domain_specific_2}}

3. "Do you need SEO optimization, audience targeting, or performance tracking?"
   - Capture: {{domain_specific_3}}
</questions>

</branch>

<branch if="domain == 'technical-development'">

<questions>
1. "What tech stack or platforms? (languages, frameworks, tools, infrastructure)"
   - Capture: {{domain_specific_1}}

2. "What development methodology? (Agile/Scrum, Kanban, Waterfall, ad-hoc)"
   - Capture: {{domain_specific_2}}

3. "What are your quality/testing requirements? (unit tests, integration tests, code review, CI/CD)"
   - Capture: {{domain_specific_3}}
</questions>

</branch>

<branch if="domain == 'operations-support'">

<questions>
1. "What processes or services are you managing? (IT operations, customer support, facilities, etc.)"
   - Capture: {{domain_specific_1}}

2. "What are your SLA or performance requirements?"
   - Capture: {{domain_specific_2}}

3. "What tools or systems do you use? (ticketing, monitoring, automation, ITSM)"
   - Capture: {{domain_specific_3}}
</questions>

</branch>

<branch if="domain == 'domain-specific-expert'">

<questions>
1. "What specific domain or field? (healthcare, legal, finance, ITIL, compliance, etc.)"
   - Capture: {{domain_specific_1}}

2. "What regulations, standards, or frameworks apply? (GDPR, HIPAA, SOX, ITIL, ISO, etc.)"
   - Capture: {{domain_specific_2}}

3. "What domain-specific challenges or requirements should the team understand?"
   - Capture: {{domain_specific_3}}
</questions>

</branch>

<rationale>
Domain-specific questions provide context that enables authentic domain expertise in generated agents. This is the difference between generic and excellent teams.
</rationale>

</step>

---

<step n="7" goal="Collaboration Style Preference">

<action>
Understand how user wants the team to collaborate.
</action>

<question>
"How should this team work together?

- **Formal**: Structured roles, clear hierarchies, formal handoffs (good for governance, compliance)
- **Agile**: Sprint-based, ceremonies, iterative (good for development, dynamic work)
- **Consultative**: Multi-perspective discussion, advisory (good for strategy, decisions)
- **Casual**: Flexible, collaborative, less structure (good for creative, exploratory work)
- **Flexible**: Balanced approach, adapts as needed

What collaboration style feels right?"
</question>

<capture>
- {{collaboration_style}} - User's preferred style
</capture>

<guidance>
If unsure, suggest based on domain:
- Domain-specific-expert → Formal
- Technical-development → Agile
- Planning-strategy → Consultative
- Creative-content → Casual
- Research-intelligence → Flexible
</guidance>

</step>

---

<step n="8" goal="Workflow Preference">

<action>
Understand user's workflow preference for how the team should guide them.
</action>

<question>
"How do you prefer to work with workflows?

- **Guided**: Step-by-step workflows that walk you through processes
- **Flexible**: Loose workflows that adapt to your needs
- **Structured**: Detailed, comprehensive workflows with clear checkpoints

What's your preference?"
</question>

<capture>
- {{workflow_preference}} - User's preferred workflow style
- {{output_preference}} - What type of outputs user expects (documents, decisions, analysis, creative work)
</capture>

<rationale>
Workflow preference informs how detailed generated workflows should be.
</rationale>

</step>

---

<step n="9" goal="Expertise Gap Check">

<action>
Identify any specific expertise the team must have.
</action>

<question>
"Is there any specific expertise or specialized knowledge this team absolutely must have?

For example: machine learning, legal compliance, healthcare regulations, specific technologies, industry knowledge, etc."
</question>

<capture>
- {{required_expertise}} - Must-have expertise
- {{missing_expertise}} - Any gaps user is concerned about
</capture>

<rationale>
Ensures critical expertise isn't missed in generation.
</rationale>

</step>

---

<step n="10" goal="Summary & Confirmation">

<action>
Summarize all captured requirements and confirm understanding.
</action>

<summary>
Present to user:

"Let me summarize what I understand:

**Your Need:** {{primary_task}}

**Domain:** {{domain}} ({{domain_context}})

**Scope:** {{scope}}, {{complexity}} complexity, {{scale}} scale

**Team Size:** {{team_size_preference}} agents

**Key Concerns:**
- {{key_concern_1}}
- {{key_concern_2}}
- {{key_concern_3}}
- [additional concerns]

**Domain Context:**
- {{domain_specific_1}}
- {{domain_specific_2}}
- {{domain_specific_3}}

**Collaboration Style:** {{collaboration_style}}

**Workflow Preference:** {{workflow_preference}}

**Required Expertise:** {{required_expertise}}

Does this accurately capture what you need?"
</summary>

<capture>
User confirmation: Yes → Proceed to generate requirements document
User correction: "Actually..." → Update variables and re-confirm
</capture>

</step>

---

## After All Steps Complete

<finalization>

1. **Generate Discovery Summary**
   - Synthesize all captured information
   - Highlight critical requirements
   - Note domain-specific context
   - Store in {{discovery_summary}}

2. **Create Generation Guidance**
   - Translate user needs into generation instructions
   - Emphasize key concerns for specialist agents
   - Note required expertise
   - Specify collaboration model
   - Store in {{generation_guidance}}

3. **Produce Requirements Document**
   - Use template.md format
   - Fill in all variables
   - Save to output directory
   - Filename: `team-requirements-{{timestamp}}.md`

4. **Transition to Generation**
   - Automatically trigger generate-team workflow
   - Pass requirements document as input
   - User does not need to manually start next workflow

5. **User Communication**
   "Perfect! I've captured your requirements. Now I'll generate a custom team tailored to your needs. This will take about 2-3 minutes..."

</finalization>

---

## Special Cases

### User is Vague
If user provides minimal information:
- Ask follow-up questions: "Can you tell me more about..."
- Provide examples: "For instance, are you thinking about X or Y?"
- Offer scenarios: "Is this more like [scenario A] or [scenario B]?"

### Domain is Unclear
If domain doesn't fit standard categories:
- Default to "domain-specific-expert"
- Ask: "What would you call this field or area of work?"
- Use their terminology in {{domain_context}}

### User Wants Small Team for Complex Work
If mismatch between team size and complexity:
- Gently suggest: "Given the complexity, a medium team (6-8) might serve you better. Still want small?"
- Respect user's choice
- Note constraint in generation guidance

### User Lists Many Concerns (>5)
If user mentions 6+ concerns:
- Acknowledge all: "I hear you on all of these..."
- Prioritize: "Which 3-5 are most critical?"
- Note others in generation guidance

### Multiple Domains Apply
If work spans domains:
- Ask: "Which aspect is primary?"
- Note secondary domains in {{domain_context}}
- Generation will blend patterns

---

## Quality Markers for Discovery

✅ **Good Discovery:**
- Captures specific domain context, not generic
- Identifies concrete concerns that drive specialist agents
- Understands user's collaboration preferences
- Gathers terminology and context for authentic expertise
- User confirms accuracy

❌ **Poor Discovery:**
- Generic information ("user wants help with project")
- No domain-specific questions asked
- Key concerns not identified
- User terminology not captured
- Rushed through steps

---

## Variables Reference

All variables from workflow.yaml must be populated:

**Required Variables:**
- primary_task
- domain
- scope, complexity, scale
- team_size_preference
- key_concerns (array with 3-5 items)
- collaboration_style
- workflow_preference

**Domain-Specific Variables:**
- domain_specific_1, 2, 3 (populated based on domain branch)

**Optional Variables:**
- required_expertise
- missing_expertise
- domain_context

**Generated Variables:**
- discovery_summary (final synthesis)
- generation_guidance (instructions for generator)

---

## Handoff to Generation

When discovery completes, the requirements document contains everything needed for generation:

1. **User's need in their words** (primary_task)
2. **Domain classification** with context
3. **Scope and scale** for sizing
4. **Key concerns** for specialist agents
5. **Domain-specific context** for authentic expertise
6. **Collaboration and workflow preferences**
7. **Required expertise** constraints

The generation workflow uses this document to create a perfectly tailored team.

---

**Discovery Complete → Generate Team → Validate Quality → Install or Refine**
