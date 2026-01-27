# Team Requirements Document

**Generated:** {{timestamp}}
**For:** {{user_name}}
**TeamBuilder Version:** 2.0

---

## User Need

### Primary Task
{{primary_task}}

### Elaboration
{{primary_task_elaboration}}

---

## Domain Classification

**Primary Domain:** {{domain}}

**Domain Context:**
{{domain_context}}

**Rationale:** Based on user's description and keywords, this work is classified as {{domain}}. This classification informs which patterns and composition principles will guide team generation.

---

## Scope & Scale

| Aspect | Classification | Implications |
|--------|----------------|--------------|
| **Scope** | {{scope}} | {{#if scope == "one-time"}}Team structure optimized for project delivery{{else}}Team designed for ongoing collaboration{{/if}} |
| **Complexity** | {{complexity}} | {{#if complexity == "simple"}}Focused team, fewer agents{{else if complexity == "moderate"}}Balanced team size and expertise{{else}}Comprehensive team with deep expertise{{/if}} |
| **Scale** | {{scale}} | {{#if scale == "small"}}Casual collaboration style appropriate{{else if scale == "medium"}}Balanced structure{{else}}Formal collaboration patterns recommended{{/if}} |

---

## Team Preferences

### Team Size
**Preferred Range:** {{team_size_preference}} agents

**Rationale:** User preference aligned with scope and complexity.

### Collaboration Style
**Preferred Style:** {{collaboration_style}}

**What This Means:**
{{#if collaboration_style == "formal"}}
- Structured roles and clear hierarchies
- Formal handoffs between agents
- Document-driven processes
- Good for: Governance, compliance, large organizations
{{else if collaboration_style == "agile"}}
- Sprint-based workflows
- Iterative processes
- Regular ceremonies (planning, standups, retros)
- Good for: Development, dynamic work, fast-paced projects
{{else if collaboration_style == "consultative"}}
- Multi-perspective discussions
- Advisory approach
- Collaborative decision-making
- Good for: Strategy, complex decisions, stakeholder alignment
{{else if collaboration_style == "casual"}}
- Flexible interactions
- Less formal structure
- Collaborative and exploratory
- Good for: Creative work, research, innovation
{{else}}
- Balanced approach
- Adapts to context
- Mix of formal and informal
- Good for: General purpose, varied work
{{/if}}

### Workflow Preference
**Preferred Style:** {{workflow_preference}}

**Workflow Design:**
{{#if workflow_preference == "guided"}}
- Step-by-step workflows
- Clear instructions at each stage
- Structured processes
{{else if workflow_preference == "flexible"}}
- Adaptable workflows
- User-directed processes
- Minimal prescribed structure
{{else}}
- Detailed comprehensive workflows
- Clear checkpoints and milestones
- Thorough documentation
{{/if}}

### Output Preference
**Preferred Outputs:** {{output_preference}}

---

## Key Concerns & Challenges

The following concerns were identified as critical and should drive specialist agent creation:

1. **{{key_concern_1}}**
   - Priority: High
   - Requires: Specialist agent with this expertise

2. **{{key_concern_2}}**
   - Priority: High
   - Requires: Specialist agent with this expertise

3. **{{key_concern_3}}**
   - Priority: High
   - Requires: Specialist agent with this expertise

{{#if key_concern_4}}
4. **{{key_concern_4}}**
   - Priority: Medium
   - Requires: Agent with capability in this area
{{/if}}

{{#if key_concern_5}}
5. **{{key_concern_5}}**
   - Priority: Medium
   - Requires: Agent with capability in this area
{{/if}}

**Generation Instruction:** Team MUST include specialist agents that address each of these concerns. These are not optional nice-to-haves.

---

## Domain-Specific Context

### Context Details

**Context 1:** {{domain_specific_1}}

**Context 2:** {{domain_specific_2}}

**Context 3:** {{domain_specific_3}}

### Domain Requirements

{{#if domain == "research-intelligence"}}
**Research/Intelligence Specific:**
- Sources: {{domain_specific_1}}
- Verification approach: {{domain_specific_2}}
- Deliverable format: {{domain_specific_3}}

**Team Must Include:**
- Search/query specialist
- Source evaluation expert
- Synthesis analyst
- Fact checker or verifier

{{else if domain == "planning-strategy"}}
**Planning/Strategy Specific:**
- Stakeholders: {{domain_specific_1}}
- Planning horizon: {{domain_specific_2}}
- Risk focus: {{domain_specific_3}}

**Team Must Include:**
- Strategic planner or visionary
- Stakeholder manager
- Risk analyst
- Project coordinator

{{else if domain == "creative-content"}}
**Creative/Content Specific:**
- Content type: {{domain_specific_1}}
- Brand/style: {{domain_specific_2}}
- Optimization needs: {{domain_specific_3}}

**Team Must Include:**
- Content strategist
- Writer/creator
- Editor/reviewer
- SEO or optimization specialist (if needed)

{{else if domain == "technical-development"}}
**Technical/Development Specific:**
- Tech stack: {{domain_specific_1}}
- Methodology: {{domain_specific_2}}
- Quality requirements: {{domain_specific_3}}

**Team Must Include:**
- Architect or technical lead
- Developer(s)
- Quality assurance / tester
- Scrum master or coordinator (if Agile)

{{else if domain == "operations-support"}}
**Operations/Support Specific:**
- Processes/services: {{domain_specific_1}}
- SLA/performance: {{domain_specific_2}}
- Tools/systems: {{domain_specific_3}}

**Team Must Include:**
- Operations coordinator
- Process specialist
- Support specialist
- Tools/automation expert (if applicable)

{{else if domain == "domain-specific-expert"}}
**Domain Expert Specific:**
- Specific domain: {{domain_specific_1}}
- Regulations/standards: {{domain_specific_2}}
- Domain challenges: {{domain_specific_3}}

**Team Must Include:**
- Domain expert / practice owner
- Compliance or regulatory specialist
- Domain-specific analyst
- Cross-domain liaisons (if needed)

{{/if}}

---

## Expertise Requirements

### Required Expertise
{{#if required_expertise}}
**Must Have:** {{required_expertise}}

This expertise is NON-NEGOTIABLE. At least one agent must have deep knowledge in this area.
{{else}}
No specific expertise requirements beyond domain knowledge.
{{/if}}

### Expertise Gaps or Concerns
{{#if missing_expertise}}
**User Concerned About:** {{missing_expertise}}

Generation should address this gap explicitly.
{{/if}}

---

## Discovery Summary

{{discovery_summary}}

**Key Takeaways:**
1. User needs: {{primary_task}}
2. Domain: {{domain}} with specific context in {{domain_specific_1}}
3. Critical concerns: {{key_concern_1}}, {{key_concern_2}}, {{key_concern_3}}
4. Team size: {{team_size_preference}}, Style: {{collaboration_style}}
5. Must-have expertise: {{required_expertise}}

---

## Generation Guidance

### For Generation Engine

{{generation_guidance}}

### Composition Instructions

**Team Structure:**
1. **Primary Coordinator/Decision-Maker** (Required)
   - Orchestrates team
   - Makes final decisions
   - Matches {{collaboration_style}} style

2. **Domain Expert(s)** (Required)
   - Deep expertise in {{domain}}
   - Understands context from {{domain_specific_1}}, {{domain_specific_2}}, {{domain_specific_3}}
   - Uses domain-specific terminology

3. **Specialist Agents for Key Concerns** (Required for each concern)
   - Agent addressing {{key_concern_1}}
   - Agent addressing {{key_concern_2}}
   - Agent addressing {{key_concern_3}}
   - [Additional specialists as needed]

4. **Support Roles** (As appropriate for team size)
   - Analyst or researcher
   - Quality reviewer or auditor
   - Communication or documentation specialist
   - [Others based on domain]

**Team Size Target:** {{team_size_preference}} agents

### Persona Generation Instructions

**Critical Requirements:**
1. **Use domain-specific terminology** from this document
2. **Address key concerns** in agent capabilities
3. **Vary communication styles** dramatically (formal, casual, technical, creative)
4. **Create distinct identities** with specific backgrounds
5. **Match collaboration style** ({{collaboration_style}})
6. **Include required expertise** ({{required_expertise}})

**Quality Markers:**
- Each agent should feel like a real colleague, not a generic bot
- Communication styles should be memorably different
- Domain expertise should be authentic (not surface-level)
- Concerns from user should be clearly covered

### Workflow Generation Instructions

**Style:** {{workflow_preference}}

**Focus:** {{output_preference}}

**Requirements:**
1. Workflows should produce {{output_preference}}
2. Collaboration pattern: {{collaboration_style}}
3. Steps should be actionable, not vague
4. Agent assignments must reference actual team agents
5. Outputs should be concrete artifacts (documents, decisions, etc.)

---

## Pattern Library Guidance

### Recommended Patterns to Study

Based on {{domain}} classification:

**Primary Pattern:** {{domain}} pattern
- Study agent composition
- Study collaboration model
- Study workflow structure
- **LEARN principles, DO NOT COPY**

**Secondary Patterns:**
- Review other patterns for diversity
- Learn composition principles
- Understand quality markers

### Anti-Pattern Warnings

❌ **Do NOT:**
- Copy pattern agents with different names
- Use generic "professional" personas
- Create agents with overlapping roles
- Ignore user's specific context
- Miss required expertise
- Overlook key concerns

✅ **DO:**
- Generate fresh agents inspired by principles
- Create memorable, distinct personas
- Use terminology from this document
- Address every key concern
- Include required expertise
- Reflect user's collaboration preference

---

## Validation Criteria

When this team is generated, it will be validated against:

### Must-Pass (Critical):
- [ ] All key concerns addressed by specialist agents
- [ ] Domain expertise clearly present
- [ ] Required expertise included ({{required_expertise}})
- [ ] Team size within range ({{team_size_preference}})
- [ ] Primary coordinator present
- [ ] Agent roles are distinct (no overlap)
- [ ] Personas are specific (not generic)

### Quality Targets:
- [ ] Domain-specific terminology used
- [ ] Communication styles vary significantly
- [ ] Agents feel like real colleagues
- [ ] Workflows are actionable and specific
- [ ] Collaboration model matches preference
- [ ] Overall quality score: 85%+

---

## Next Steps

1. ✅ Discovery complete
2. **→ GENERATION** (next: generate-team workflow)
3. Validation (automatic)
4. User review and decision (install or refine)

**Estimated time to generated team:** 2-3 minutes

---

**This requirements document serves as the complete specification for team generation. All information needed to create a perfectly tailored team is captured above.**

---

_Generated by TeamBuilder Discovery Workflow v2.0_
_User confirmed accuracy: {{confirmation_timestamp}}_
