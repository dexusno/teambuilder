# Refine Team Workflow Instructions

Targeted improvement workflow for generated teams with quality issues.

## Overview

This workflow improves team quality through focused, surgical changes rather than wholesale regeneration. It preserves what's working well and fixes what isn't. This approach is faster and maintains the good aspects of the original generation.

## Critical Principles

1. **Targeted, not wholesale** - Fix specific issues, don't regenerate everything
2. **Preserve quality** - Keep agents/workflows that passed validation
3. **Focus on highest impact** - Address critical and high-severity issues first
4. **Iterative improvement** - Multiple small refinements better than one big one
5. **User guidance** - Let user prioritize what matters most to them

---

## Refinement Process

<step n="1" goal="Load Current Team & Validation Report">

<action>
Load the current team and its validation report to understand what needs improvement.
</action>

<load>
- {{team_name}} - Team identifier
- {{current_team}} - All current agent and workflow definitions
- {{validation_report}} - Full validation results
- {{quality_score}} - Current score
- {{issues}} - All validation issues by severity
</load>

<analyze>
Categorize issues:
- **Critical issues** (must fix)
- **High-priority issues** (should fix)
- **Medium issues** (nice to fix)
- **Low issues** (polish)

Identify affected components:
- Which agents have issues?
- Which workflows have issues?
- Which team-level aspects need work?
</analyze>

</step>

---

<step n="2" goal="Determine Refinement Focus">

<action>
Work with user to determine what to refine.
</action>

<options>

**Option A: User Specifies Focus**
Ask: "What would you like to improve about this team?"
- User provides specific feedback
- Capture in {{refinement_focus}}

**Option B: Suggest Based on Issues**
If user unsure, suggest top priorities:
```
Based on validation, I recommend focusing on:

1. {{highest_priority_issue}} ({{severity}}, +{{potential_improvement}} points)
2. {{second_priority_issue}} ({{severity}}, +{{potential_improvement}} points)
3. {{third_priority_issue}} ({{severity}}, +{{potential_improvement}} points)

Which would you like to tackle first?
```

**Option C: Auto-Focus on Critical**
If critical issues present:
"There are {{critical_count}} critical issues that must be fixed. I'll focus on those."

</options>

<refinement_types>

Classify refinement into type:
- **improve_personas**: Make agents more distinct or specific
- **add_missing_expertise**: Add specialists for uncovered concerns
- **enhance_workflows**: Make workflows more actionable
- **adjust_team_size**: Add or remove agents
- **change_collaboration**: Adjust collaboration model
- **fix_domain_expertise**: Enhance domain authenticity

Store in {{refinement_type}}
</refinement_types>

</step>

---

<step n="3" goal="Identify Components to Revise">

<action>
Based on refinement focus, identify exactly which agents/workflows need revision.
</action>

<identification>

**For improve_personas:**
- Identify agents with similar communication styles
- Identify agents with generic personas
- Identify agents with weak principles
Store in {{agents_to_revise}}

**For add_missing_expertise:**
- Identify which concerns lack specialists
- Determine new agent roles needed
- Plan where they fit in team structure

**For enhance_workflows:**
- Identify workflows with vague steps
- Identify workflows with invalid agent references
- Identify workflows missing outputs
Store in {{workflows_to_revise}}

**For adjust_team_size:**
- If too small: Identify gaps to fill
- If too large: Identify agents to consolidate or remove

**For change_collaboration:**
- Identify how collaboration model needs to shift
- Determine which agents affected

**For fix_domain_expertise:**
- Identify agents that should have domain expertise but don't
- Gather domain terminology from requirements
- Plan expertise enhancements

</identification>

<preserve>

**CRITICAL: Identify what to KEEP**

List agents/workflows that:
- Passed all validation checks
- Have no issues
- User is satisfied with

These will be preserved unchanged in refined team.

</preserve>

</step>

---

<step n="4" goal="Perform Targeted Revisions">

<action>
Make focused improvements to identified components.
</action>

<revisions>

**Revising Agent Personas:**

For each agent in {{agents_to_revise}}:

1. **Review current persona**
   - What's the specific issue?
   - What validation check failed?

2. **Targeted fix**
   - If communication style too generic → Create distinctive style
   - If identity lacks specifics → Add concrete background
   - If principles are platitudes → Express strong opinions
   - If too similar to another agent → Dramatically differentiate
   - If lacks domain expertise → Add domain terminology and context

3. **Preserve what works**
   - If role description is good, keep it
   - If some aspects of persona are strong, maintain them
   - Only change what needs fixing

4. **Verify distinctness**
   - Compare revised persona to other agents
   - Ensure sufficiently different
   - Check domain expertise is authentic

Example refinement:
```
Original (generic):
  communication_style: "Professional and clear communication"

Revised (specific):
  communication_style: "Direct and data-driven. Leads with numbers.
  Starts every analysis with 'Let's look at the metrics.' Uses
  precise language and avoids ambiguity. Challenges assumptions with
  'What's the data say?' Patient with explanation but intolerant of
  speculation without evidence."
```

**Adding New Agents:**

For missing expertise/concerns:

1. **Define role** for new agent
   - What concern does it address?
   - What expertise does it bring?

2. **Generate persona** following quality guidelines
   - Specific background
   - Distinctive communication style
   - Clear principles
   - Domain-appropriate

3. **Integrate into team**
   - Where does new agent fit?
   - How does it collaborate with existing agents?
   - Update team structure

**Enhancing Workflows:**

For each workflow in {{workflows_to_revise}}:

1. **Review issues**
   - Vague steps → Make specific
   - Invalid agent references → Update to actual agents
   - Missing outputs → Define concrete artifacts
   - Unclear collaboration → Specify agent interactions

2. **Revise targeted sections**
   - Don't rewrite entire workflow if only one step is problematic
   - Fix specific steps that failed validation
   - Enhance agent assignments

3. **Verify completeness**
   - All three files present (yaml, instructions, template)?
   - Agent references valid?
   - Steps actionable?

Example refinement:
```
Original (vague):
  Step 1: Gather requirements

Revised (specific):
  Step 1: Requirements Elicitation
  Agent: Strategy Lead
  Action: Interview user about business objectives (specific metrics),
          constraints (budget, timeline, resources), stakeholders
          (names, roles, influence), and success criteria (measurable)
  Output: requirements-doc.md
```

**Adjusting Team Size:**

If adding agents:
- Generate new agents with quality personas
- Ensure they fill real gaps
- Integrate into collaboration model

If removing/consolidating agents:
- Identify least critical agents
- Consider consolidating similar roles
- Update workflows that referenced removed agents

**Changing Collaboration Model:**

If adjusting collaboration:
- Update coordinator agent if needed
- Revise workflow collaboration patterns
- Update team configuration
- Ensure consistency across agents

</revisions>

<store>
All revised/new components in:
- {{revised_agents}} - Updated and new agents
- {{revised_workflows}} - Updated workflows
- {{changes_summary}} - What changed and why
</store>

</step>

---

<step n="5" goal="Integrate Changes">

<action>
Combine preserved components with revised components into updated team.
</action>

<integration>

**Build Updated Team:**

Preserved agents (no issues)
  + Revised agents (targeted improvements)
  + New agents (if added)
  = Complete updated team

Preserved workflows (no issues)
  + Revised workflows (targeted improvements)
  + New workflows (if added)
  = Complete updated workflows

**Verify Consistency:**
- All agent references in workflows still valid?
- Team size within acceptable range?
- Collaboration model coherent?
- All concerns addressed?

**Generate Changes Summary:**
Document what changed:
- Which agents revised and how
- Which agents added/removed
- Which workflows updated
- Expected impact on quality score

</integration>

</step>

---

<step n="6" goal="Re-Validate Refined Team">

<action>
Run validation workflow on refined team to measure improvement.
</action>

<validation>
Trigger validate-team workflow with:
- Revised team (agents + workflows)
- Original requirements document
- Note this is refinement iteration

Validation will:
1. Run all checks on revised team
2. Calculate new quality score
3. Identify remaining issues
4. Generate validation report

</validation>

<comparison>
Compare results:
- {{new_quality_score}} vs {{quality_score}}
- {{score_improvement}} = new - old
- {{remaining_issues}} = issues still present

</comparison>

</step>

---

<step n="7" goal="Present Refinement Results">

<action>
Show user what improved and what remains.
</action>

<presentation>

```
Refinement Complete!

Quality Score: {{quality_score}} → {{new_quality_score}} (+{{score_improvement}} points)

Changes Made:
{{#for each change in changes_summary}}
- {{change.description}}
{{/for}}

{{#if new_quality_score >= 95}}
🎉 Excellent quality achieved! Ready to install.

{{else if new_quality_score >= 85}}
✅ Good quality! {{#if score_improvement >= 10}}Significant improvement!{{/if}}
Ready to install or refine further (optional).

{{else if new_quality_score >= 75}}
✓ Acceptable quality reached. {{#if remaining_critical_issues == 0}}No critical issues remaining.{{/if}}
Install now or continue refining?

{{else}}
⚠️  Quality improved but still has issues.
{{#if remaining_critical_issues > 0}}
{{remaining_critical_issues}} critical issues remaining.
{{/if}}
Continue refining? (Iteration {{iteration_count}}/3)

{{/if}}

Remaining Issues:
{{#if remaining_issues.length > 0}}
{{#for each issue in remaining_issues | top 5}}
- [{{issue.severity}}] {{issue.title}}
{{/for}}
{{else}}
None! All validation checks passed.
{{/if}}
```

</presentation>

</step>

---

<step n="8" goal="Offer Next Steps">

<action>
Present options based on new quality score.
</action>

<options>

**If new_quality_score >= 85:**
```
Options:
1. Install team now - Quality is good!
2. Make additional refinements - Polish to excellent
3. View detailed validation report
```

**If new_quality_score >= 75 and < 85:**
```
Options:
1. Install team now - Acceptable quality
2. Continue refining - Target 85%+ (recommended)
3. View remaining issues
4. Start over with different approach
```

**If new_quality_score < 75:**
```
Options:
1. Continue refining - Address remaining issues ({{remaining_critical_issues}} critical)
2. View detailed validation report
3. Regenerate team - Fresh start
4. Install anyway - Use as-is (not recommended)
```

**If iteration_count >= 3:**
```
You've done 3 refinement iterations.

Current score: {{new_quality_score}}
Improvement: +{{total_improvement}} points from original

Options:
1. Install current version - You've made good progress
2. One more refinement round - Target specific issue
3. Regenerate - Sometimes fresh start is faster
```

</options>

<iteration_decision>

If user chooses to refine again:
- Return to step 2 (Determine Refinement Focus)
- Work on next priority issue
- Track iteration count
- Maximum 3-4 iterations recommended

If user chooses to install:
- Proceed to installation
- Team ready at `_bmad/teams/{{team_name}}/`

If user chooses to regenerate:
- Return to discovery or generation
- Fresh start with lessons learned

If user chooses to view report:
- Show full validation report
- Return to options

</iteration_decision>

</step>

---

## Refinement Strategies

### Strategy 1: Fix Critical First
Best for: Teams with 1-3 critical issues
Process:
1. Address all critical issues
2. Re-validate
3. If score acceptable, install; else continue

### Strategy 2: Quick Wins
Best for: Teams close to threshold (72-84%)
Process:
1. Identify easy fixes with good impact
2. Make 3-5 small improvements
3. Re-validate
4. Often pushes over 85% threshold

### Strategy 3: Persona Polish
Best for: Teams with generic or similar agents
Process:
1. Focus entirely on making agents distinct
2. Revise 3-4 most problematic agent personas
3. Dramatically vary communication styles
4. Add personality markers

### Strategy 4: Domain Enhancement
Best for: Teams lacking authentic domain expertise
Process:
1. Review requirements for domain terminology
2. Enhance domain expert agent(s)
3. Add domain terminology to specialists
4. Reference domain-specific challenges

### Strategy 5: Workflow Specificity
Best for: Teams with vague workflows
Process:
1. Rewrite vague steps to be specific
2. Add explicit agent assignments
3. Define concrete outputs
4. Specify collaboration patterns

---

## Common Refinement Scenarios

### Scenario: "Agents sound too similar"
**Focus:** improve_personas
**Actions:**
- Identify 3-4 most similar agents
- Dramatically vary communication styles (formal vs casual vs technical)
- Add distinctive personality markers
- Ensure different backgrounds and perspectives

**Expected Improvement:** +10-15 points

### Scenario: "Missing domain expertise"
**Focus:** fix_domain_expertise
**Actions:**
- Review requirements for domain context
- Enhance domain expert agents with terminology
- Add domain-specific challenges to principles
- Demonstrate understanding in identity

**Expected Improvement:** +8-12 points

### Scenario: "Workflows are too vague"
**Focus:** enhance_workflows
**Actions:**
- Make steps specific and actionable
- Add explicit agent assignments
- Define concrete outputs
- Specify collaboration

**Expected Improvement:** +6-10 points

### Scenario: "Key concern not addressed"
**Focus:** add_missing_expertise
**Actions:**
- Create specialist agent for concern
- Integrate into team structure
- Update workflows to include new agent
- Verify concern coverage

**Expected Improvement:** +10-15 points

---

## Quality Checks During Refinement

### After Step 4 (Revisions):
- Are revised personas truly distinct now?
- Is domain expertise authentic?
- Are workflow steps specific?
- Did you preserve what was working?

### Before Step 6 (Re-validation):
- Did revisions address the target issues?
- Are all agent references in workflows valid?
- Is team composition still sensible?
- Did you make targeted changes (not wholesale rewrites)?

---

## Success Criteria

Refinement succeeds when:
1. ✅ Quality score improves by 5+ points
2. ✅ Target issues resolved or significantly improved
3. ✅ Good aspects of team preserved
4. ✅ New quality score meets user's threshold
5. ✅ User is satisfied with refined team

---

## Special Cases

### Refinement Not Improving Score
If after 2 iterations score hasn't improved significantly:
- Suggest regeneration instead
- May need different approach
- Current generation may have fundamental issues

### Score Decreases After Refinement
Rare but possible if revisions introduce new issues:
- Roll back to previous version
- Try different refinement approach
- May need more targeted fixes

### User Wants Wholesale Changes
If user wants to change fundamental aspects (domain, purpose, team size dramatically):
- Suggest regeneration instead of refinement
- Refinement is for polishing, not transforming

---

**Refinement Complete → Re-Validate → Install or Continue**
