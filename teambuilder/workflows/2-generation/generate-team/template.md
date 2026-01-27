# Team Generation Summary

**Team Name:** {{team_name}}
**Generated:** {{timestamp}}
**TeamBuilder Version:** 2.0

---

## Generation Overview

✅ Team successfully generated from user requirements
✅ {{agent_count}} agents created with distinct personas
✅ {{workflow_count}} workflows designed
✅ Package ready for validation

---

## Team Composition

### Team Name
**{{team_name}}**

### Team Description
{{team_description}}

### Domain & Context
- **Primary Domain:** {{domain}}
- **Collaboration Style:** {{collaboration_style}}
- **Team Size:** {{agent_count}} agents ({{team_size_preference}} requested)

---

## Generated Agents

{{#for each agent in generated_agents}}
### {{loop_index}}. {{agent.display_name}}
**Role:** {{agent.title}}
**Icon:** {{agent.icon}}

**What This Agent Does:**
{{agent.role}}

**Background:**
{{agent.identity}}

**Communication Style:**
{{agent.communication_style}}

**Key Principles:**
{{agent.principles}}

**File:** `_bmad/teams/{{team_name}}/agents/{{agent.name}}.md`

---
{{/for}}

## Team Structure

### Coordinator
**{{coordinator_agent.display_name}}** - {{coordinator_agent.title}}
- Primary decision-maker and team orchestrator
- Matches {{collaboration_style}} collaboration style

### Domain Experts
{{#for each expert in domain_experts}}
- **{{expert.display_name}}** - {{expert.title}}
  Deep expertise in {{domain}} with understanding of {{domain_context}}
{{/for}}

### Specialists (Addressing Key Concerns)
{{#for each specialist in specialists}}
- **{{specialist.display_name}}** - {{specialist.title}}
  Addresses: {{specialist.concern_addressed}}
{{/for}}

### Support Roles
{{#for each support in support_agents}}
- **{{support.display_name}}** - {{support.title}}
  Provides: {{support.capability}}
{{/for}}

---

## Generated Workflows

{{#for each workflow in generated_workflows}}
### {{loop_index}}. {{workflow.name}}

**Description:** {{workflow.description}}

**Purpose:** {{workflow.purpose}}

**Steps:** {{workflow.step_count}} steps

**Key Agents Involved:**
{{#for each agent in workflow.agents}}
- {{agent.display_name}} ({{agent.role_in_workflow}})
{{/for}}

**Outputs:**
{{#for each output in workflow.outputs}}
- {{output.file}} - {{output.description}}
{{/for}}

**Workflow Path:** `_bmad/teams/{{team_name}}/workflows/{{workflow.name}}/`

---
{{/for}}

## Collaboration Model

**Style:** {{collaboration_style}}

### How This Team Works Together

{{#if collaboration_style == "formal"}}
This team uses a formal collaboration model:
- Clear hierarchy with {{coordinator_agent.display_name}} as primary coordinator
- Structured handoffs between agents
- Document-driven processes
- Formal decision-making protocols

**Agent Interaction Pattern:**
User → Coordinator → Relevant Expert/Specialist → Support Agents → Coordinator → User

**Decision-Making:**
- {{coordinator_agent.display_name}} makes final decisions
- Specialists provide expert input
- Formal approval processes

{{else if collaboration_style == "agile"}}
This team uses an agile collaboration model:
- {{coordinator_agent.display_name}} acts as Scrum Master / facilitator
- Sprint-based workflows
- Regular touchpoints (planning, standups, retros)
- Iterative delivery

**Agent Interaction Pattern:**
- Daily standups (async): Quick status from all agents
- Sprint planning: {{coordinator_agent.display_name}} + team
- Execution: Agents work autonomously on tasks
- Review & retro: Collaborative reflection

**Decision-Making:**
- Team consensus with {{coordinator_agent.display_name}} facilitation
- Quick decisions to maintain velocity
- Retrospectives for process improvement

{{else if collaboration_style == "consultative"}}
This team uses a consultative collaboration model:
- {{coordinator_agent.display_name}} facilitates multi-agent discussions
- Multiple perspectives encouraged
- Collaborative analysis and recommendations
- Advisory approach to decisions

**Agent Interaction Pattern:**
User poses challenge → {{coordinator_agent.display_name}} convenes relevant experts → Multi-agent discussion → Synthesis of perspectives → Recommendations → User decision

**Decision-Making:**
- User retains final authority
- Team provides diverse perspectives
- {{coordinator_agent.display_name}} synthesizes recommendations

{{else if collaboration_style == "casual"}}
This team uses a casual collaboration model:
- Flexible agent interactions
- Informal collaboration
- Ad-hoc teaming based on need
- Exploratory and creative approach

**Agent Interaction Pattern:**
- User can interact with any agent directly
- Agents collaborate as needed (no fixed structure)
- {{coordinator_agent.display_name}} available for guidance but not gatekeeper
- Emergent collaboration patterns

**Decision-Making:**
- Flexible based on context
- User drives process
- Agents provide input as relevant

{{else}}
This team uses a flexible collaboration model:
- Balanced approach adapting to context
- {{coordinator_agent.display_name}} provides structure when needed
- Mix of formal and informal interactions
- Adjusts based on task requirements

**Agent Interaction Pattern:**
- Formal structure for complex/critical work
- Informal collaboration for exploration
- {{coordinator_agent.display_name}} adjusts approach based on situation

**Decision-Making:**
- Varies by decision type
- Important decisions: Structured process
- Routine decisions: Flexible and fast

{{/if}}

---

## Requirements Coverage

### Primary Task Addressed
✅ **User Need:** {{primary_task}}
**How Team Addresses It:** This team is specifically composed to tackle {{primary_task}} through {{team_approach_summary}}.

### Key Concerns Coverage
{{#for each concern in key_concerns}}
✅ **Concern:** {{concern}}
**Addressed By:** {{agent_addressing_concern}} - {{how_addressed}}
{{/for}}

### Required Expertise
✅ **Expertise Required:** {{required_expertise}}
**Present In:** {{agents_with_expertise}} have the required expertise, demonstrated through {{expertise_evidence}}.

### Domain Context Integration
✅ **Domain:** {{domain}}
✅ **Context Elements:**
- {{domain_specific_1}} - Integrated into {{integration_detail_1}}
- {{domain_specific_2}} - Reflected in {{integration_detail_2}}
- {{domain_specific_3}} - Addressed by {{integration_detail_3}}

---

## Pattern Library Learning

### Patterns Studied
{{#for each pattern in loaded_patterns}}
- **{{pattern.name}}** ({{pattern.type}})
  Learned: {{pattern.key_learning}}
{{/for}}

### Principles Applied
This team was generated by learning from pattern library principles, NOT by copying pattern agents. Key principles applied:

1. **Distinct Personas:** Each agent has unique communication style and background
2. **Domain Expertise:** Agents use terminology and context from requirements ({{domain_terminology_examples}})
3. **Concern Coverage:** Every key concern has dedicated specialist
4. **Actionable Workflows:** Steps are specific with clear agent assignments
5. **Collaboration Alignment:** Team structure matches {{collaboration_style}} preference

### Quality Indicators
{{#for each indicator in quality_indicators}}
✅ {{indicator}}
{{/for}}

---

## Installation Package Contents

The following files have been generated and are ready for installation:

### Configuration
- `_bmad/teams/{{team_name}}/config.yaml` - Team metadata and configuration

### Agents ({{agent_count}} files)
{{#for each agent in generated_agents}}
- `_bmad/teams/{{team_name}}/agents/{{agent.name}}.md`
{{/for}}

### Workflows ({{workflow_count}} workflows, {{workflow_file_count}} files)
{{#for each workflow in generated_workflows}}
- `_bmad/teams/{{team_name}}/workflows/{{workflow.name}}/workflow.yaml`
- `_bmad/teams/{{team_name}}/workflows/{{workflow.name}}/instructions.md`
- `_bmad/teams/{{team_name}}/workflows/{{workflow.name}}/template.md`
{{/for}}

### Documentation
- `_bmad/teams/{{team_name}}/TEAM_README.md` - How to use this team
- `_bmad/teams/{{team_name}}/GENERATION_SUMMARY.md` - This file

---

## Next Steps

### Immediate: Validation
✅ Generation complete
→ **Next:** Automatic validation workflow

The validation workflow will:
1. Check all agents for quality (distinctness, domain expertise, role clarity)
2. Verify workflows are actionable and reference valid agents
3. Confirm team coverage is complete
4. Calculate quality score (0-100%)
5. Generate detailed validation report

**Expected:** 2-3 minutes for validation

### After Validation: User Decision

Based on validation quality score:

**95-100% (Excellent):**
- Ready to install immediately
- High-quality team with standout personas
- Recommended action: Install

**85-94% (Good):**
- Ready to use
- Minor improvements possible but not necessary
- Recommended action: Install (or refine if desired)

**75-84% (Acceptable):**
- Functional but has quality gaps
- Refinement recommended
- Recommended action: Review issues, refine targeted areas

**<75% (Needs Work):**
- Quality issues need addressing
- Refinement required before installation
- Recommended action: Refine based on validation report

---

## Generation Metadata

**Generation Process:**
- Requirements loaded: {{requirements_load_time}}
- Patterns studied: {{patterns_studied_count}}
- Agent generation: {{agent_generation_time}}
- Workflow design: {{workflow_generation_time}}
- Total generation time: {{total_generation_time}}

**Quality Self-Checks:**
- Persona distinctness: ✅ Verified
- Domain expertise: ✅ Authentic
- Concern coverage: ✅ Complete
- Workflow actionability: ✅ Verified
- Collaboration alignment: ✅ Matches {{collaboration_style}}

**Pattern Similarity:**
- Pattern copying detected: {{pattern_similarity_check}}
- Generation is original: ✅ Confirmed

---

## Team Identity

This team is designed specifically for:
**{{primary_task}}**

With expertise in:
**{{domain}}** ({{domain_context}})

Addressing concerns about:
{{#for each concern in key_concerns}}
- {{concern}}
{{/for}}

Working in a:
**{{collaboration_style}}** collaboration style

**This is a custom team created uniquely for these requirements. It is not a pre-built template or pattern copy.**

---

**Status:** ✅ Generation Complete → Validation In Progress

_Generated by TeamBuilder v2.0 Dynamic Generation Engine_
_Based on requirements document: {{requirements_document}}_
