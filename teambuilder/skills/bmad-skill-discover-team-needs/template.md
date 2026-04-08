# Team Requirements Document

**Generated:** {timestamp}
**For:** {user_name}
**TeamBuilder Version:** 3.0

---

## User Need

### Primary Task
{primary_task}

### Elaboration
{primary_task_elaboration}

---

## Domain Classification

**Primary Domain:** {domain}

**Domain Context:**
{domain_context}

**Rationale:** Based on the user's description and keywords, this work is classified as {domain}. This classification informs which patterns and composition principles will guide team generation.

---

## Scope & Scale

| Aspect | Classification |
|--------|----------------|
| Scope | {scope} |
| Complexity | {complexity} |
| Scale | {scale} |

---

## Team Preferences

**Preferred team size:** {team_size_preference} agents
**Collaboration style:** {collaboration_style}
**Workflow preference:** {workflow_preference}
**Output preference:** {output_preference}

---

## Key Concerns & Challenges

The following concerns were identified as critical and MUST drive specialist agent creation:

1. **{key_concern_1}** — Priority: High — Requires specialist agent
2. **{key_concern_2}** — Priority: High — Requires specialist agent
3. **{key_concern_3}** — Priority: High — Requires specialist agent
4. **{key_concern_4}** — Priority: Medium (if present)
5. **{key_concern_5}** — Priority: Medium (if present)

**Generation instruction:** Team MUST include specialist agents that address each of these concerns. These are not optional nice-to-haves.

---

## Domain-Specific Context

- **Context 1:** {domain_specific_1}
- **Context 2:** {domain_specific_2}
- **Context 3:** {domain_specific_3}

---

## Expertise Requirements

**Required (must-have):** {required_expertise}
**Gap user is concerned about:** {missing_expertise}

---

## Discovery Summary

{discovery_summary}

**Key takeaways:**
1. User needs: {primary_task}
2. Domain: {domain} with specific context in {domain_specific_1}
3. Critical concerns: {key_concern_1}, {key_concern_2}, {key_concern_3}
4. Team size: {team_size_preference}, Style: {collaboration_style}
5. Must-have expertise: {required_expertise}

---

## Generation Guidance

{generation_guidance}

### Composition Instructions

**Team structure must include:**

1. **Primary Coordinator / Decision-Maker** (Required) — orchestrates the team, makes final decisions, matches {collaboration_style} style.
2. **Domain Expert(s)** (Required) — deep expertise in {domain}, understands context from `domain_specific_*`, uses domain-specific terminology.
3. **Specialist agents for each key concern** (Required, one per concern):
   - Agent addressing {key_concern_1}
   - Agent addressing {key_concern_2}
   - Agent addressing {key_concern_3}
   - Additional specialists as needed
4. **Support roles** (as appropriate for team size) — analyst/researcher, quality reviewer, documentation specialist, etc.

**Team size target:** {team_size_preference} agents.

### Persona Generation Requirements

Critical:
1. Use domain-specific terminology from this document.
2. Address each key concern in agent capabilities.
3. Vary communication styles dramatically (formal, casual, technical, creative).
4. Create distinct identities with specific backgrounds.
5. Match the collaboration style ({collaboration_style}).
6. Include the required expertise ({required_expertise}).

Quality markers:
- Each agent should feel like a real colleague, not a generic bot.
- Communication styles should be memorably different.
- Domain expertise should be authentic, not surface-level.
- Concerns from the user should be clearly covered.

### Workflow Generation Requirements

- Workflows should produce {output_preference}.
- Collaboration pattern: {collaboration_style}.
- Steps should be actionable, not vague.
- Agent assignments must reference actual team agents.
- Outputs should be concrete artifacts.

---

## Pattern Library Guidance

**Primary pattern to study:** the `{domain}` pattern (or closest match).
**Secondary patterns:** review for diversity.

**Anti-pattern warnings:**
- ❌ Do NOT copy pattern agents with different names.
- ❌ Do NOT use generic "professional" personas.
- ❌ Do NOT create agents with overlapping roles.
- ❌ Do NOT ignore the user's specific context.

- ✅ DO generate fresh agents inspired by principles.
- ✅ DO create memorable, distinct personas.
- ✅ DO use terminology from this document.
- ✅ DO address every key concern.

---

## Validation Targets

Must-pass (critical):
- [ ] All key concerns addressed by specialist agents
- [ ] Domain expertise clearly present
- [ ] Required expertise included ({required_expertise})
- [ ] Team size within range ({team_size_preference})
- [ ] Primary coordinator present
- [ ] Agent roles distinct (no overlap)
- [ ] Personas specific (not generic)

Quality targets:
- [ ] Domain-specific terminology used
- [ ] Communication styles vary significantly
- [ ] Workflows actionable and specific
- [ ] Collaboration model matches preference
- [ ] Overall quality score ≥ 85

---

## Next Steps

1. ✅ Discovery complete
2. → **GENERATION** (next: `bmad-skill-generate-team`)
3. Validation (automatic via `bmad-skill-validate-team`)
4. User review and decision (install or refine)

**Estimated time to generated team:** 2–3 minutes

---

_Generated by TeamBuilder Discovery Workflow v3.0_
