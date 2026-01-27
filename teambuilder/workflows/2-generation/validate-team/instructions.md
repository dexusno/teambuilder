# Validate Team Workflow Instructions

Automated quality assessment of generated teams using rule-based validation.

## Overview

This workflow runs 30+ validation checks across agent, workflow, and team levels to ensure generated teams meet quality standards. It calculates a quality score (0-100%) and provides detailed recommendations for improvement.

---

## Validation Process

<step n="1" goal="Load Validation Rules">

<action>
Load validation rules from `_bmad/teambuilder/templates/validation-rules.yaml`
</action>

<load>
Extract three categories of rules:
- **agent_checks** - Role clarity, persona quality, domain expertise, distinctness, structure
- **workflow_checks** - Completeness, actionability, agent references, coherence
- **team_checks** - Coverage, team size, collaboration model, domain alignment

Store in {{validation_rules}}
</load>

</step>

---

<step n="2" goal="Run Agent-Level Checks">

<action>
For each agent in {{generated_agents}}, run all agent validation checks.
</action>

<checks>

**Role Clarity:**
- Each agent has distinct, non-overlapping role? (Check role similarity <60%)
- Role description is specific, not vague?

**Persona Quality:**
- Identity has specific background (not "experienced professional")?
- Communication style is distinctive (not generic)?
- Principles show clear values (not platitudes)?
- Agent is memorable (has personality markers)?

**Domain Expertise:**
- Uses domain-specific terminology?
- Shows domain understanding in identity or principles?

**Distinctness:**
- Agents don't sound the same (communication styles vary)?
- No duplicate personas (identity similarity <70%)?

**Structural Requirements:**
- All required fields present (role, identity, communication_style, principles)?
- Valid XML structure?
- Has at least one menu item?

**Pattern Similarity:**
- Not too similar to pattern examples (<50% similarity)?

</checks>

<scoring>
For each failed check:
- Record issue with severity (critical, high, medium, low)
- Note score_impact from validation rule
- Store fix_suggestion

Count:
- {{agent_checks_passed}} = checks that passed
- {{agent_checks_total}} = total checks run
</scoring>

</step>

---

<step n="3" goal="Run Workflow-Level Checks">

<action>
For each workflow in {{generated_workflows}}, run all workflow validation checks.
</action>

<checks>

**Completeness:**
- Has all three required files (workflow.yaml, instructions.md, template.md)?
- Variables are defined?
- Output is specified?

**Actionability:**
- Steps are specific, not vague?
- Agent assignments are clear?
- Has measurable outputs?

**Agent References:**
- References valid agent names from team?
- Agent roles match capabilities?

**Coherence:**
- Steps follow logical sequence?
- Collaboration patterns are clear?

</checks>

<scoring>
For each failed check:
- Record issue with severity
- Note score_impact
- Store fix_suggestion

Count:
- {{workflow_checks_passed}}
- {{workflow_checks_total}}
</scoring>

</step>

---

<step n="4" goal="Run Team-Level Checks">

<action>
Analyze team as whole, run team-level validation checks.
</action>

<checks>

**Coverage:**
- Has coordinator or decision-maker?
- Has domain expert?
- Key concerns from requirements addressed?
- Complete functional coverage (analysis, execution, quality/review)?

**Team Size:**
- Team size appropriate for scope?
- Not too small (<4 agents)?
- Not too large (>12 agents)?

**Collaboration Model:**
- Clear collaboration structure?
- No isolated agents?

**Domain Alignment:**
- Aligned with discovered domain?
- Addresses user's specific context?

**Quality Indicators:**
- Has distinctive team character?
- Agents complement each other?

</checks>

<scoring>
For each failed check:
- Record issue with severity
- Note score_impact
- Store fix_suggestion

Count:
- {{team_checks_passed}}
- {{team_checks_total}}
</scoring>

</step>

---

<step n="5" goal="Calculate Quality Score">

<action>
Calculate overall quality score using severity-weighted deductions.
</action>

<calculation>

Start with base_score = 100

For each failed check:
```
if severity == "critical":
    deduction = score_impact × 1.5
elif severity == "high":
    deduction = score_impact × 1.2
elif severity == "medium":
    deduction = score_impact × 1.0
else:  # low
    deduction = score_impact × 0.5

base_score -= deduction
```

Quality score = max(0, base_score)

**Bonus Points** (if applicable):
- Has standout personas: +5
- Exceptional domain expertise: +3
- Highly varied communication styles: +3

Final {{quality_score}} = min(100, base_score + bonuses)

</calculation>

<rating>
Determine {{quality_rating}} based on thresholds:
- 95-100: "Excellent"
- 85-94: "Good"
- 75-84: "Acceptable"
- 60-74: "Needs Improvement"
- <60: "Requires Refinement"
</rating>

</step>

---

<step n="6" goal="Organize Issues by Severity">

<action>
Categorize all validation issues by severity for reporting.
</action>

<categorize>
From all checks, organize issues into:
- {{critical_issues}} - Must be fixed
- {{high_issues}} - Strongly recommended to fix
- {{medium_issues}} - Improvements that would enhance quality
- {{low_issues}} - Minor polish items
</categorize>

<prioritize>
Within each severity level, prioritize by:
1. Impact on user's primary_task
2. Scope of impact (affects many agents vs one)
3. Ease of fix
</prioritize>

</step>

---

<step n="7" goal="Generate Fix Suggestions">

<action>
For top issues, provide specific, actionable fix suggestions.
</action>

<suggestions>
For each issue, create fix suggestion that includes:
- **What's wrong:** Clear problem statement
- **Why it matters:** Impact on team quality
- **How to fix:** Specific action to take
- **Example:** Before/after if helpful

Store in {{fix_suggestions}} array
</suggestions>

<refinement_priorities>
Identify top 3-5 priorities for refinement:
1. Critical issues first
2. High-impact improvements
3. Quick wins (easy fixes with good impact)

Store in {{refinement_priorities}}
</refinement_priorities>

</step>

---

<step n="8" goal="Determine Recommended Action">

<action>
Based on quality score and issues, recommend next steps.
</action>

<recommendation>

**If quality_score >= 95:**
{{recommended_action}} = "Install immediately - Excellent quality!"

**If quality_score >= 85:**
{{recommended_action}} = "Ready to install. Minor refinements optional."

**If quality_score >= 75:**
{{recommended_action}} = "Acceptable quality. Refinement recommended before installation."

**If quality_score >= 60:**
{{recommended_action}} = "Needs improvement. Refinement required."

**If quality_score < 60:**
{{recommended_action}} = "Requires significant refinement before installation."

</recommendation>

</step>

---

<step n="9" goal="Generate Validation Report">

<action>
Produce comprehensive validation report using template.
</action>

<report_sections>

1. **Executive Summary**
   - Quality score prominently displayed
   - Rating (Excellent/Good/Acceptable/etc.)
   - Recommended action

2. **Validation Results**
   - Agent checks: passed/total
   - Workflow checks: passed/total
   - Team checks: passed/total

3. **Critical Issues** (if any)
   - List all critical severity issues
   - Must be addressed before installation

4. **High-Priority Issues** (if any)
   - List all high severity issues
   - Strongly recommended to address

5. **Improvement Opportunities**
   - Medium and low severity issues
   - Would enhance quality

6. **Fix Suggestions**
   - Top 5-10 specific recommendations
   - Prioritized by impact

7. **Strengths** (highlight what's good)
   - What the team does well
   - Quality indicators present

8. **Next Steps**
   - Install path (if score sufficient)
   - Refinement path (if score low)
   - Options for user

</report_sections>

<output>
Save report to: `docs/validation-reports/validation-report-{{team_name}}-{{timestamp}}.md`
</output>

</step>

---

<step n="10" goal="Present Results to User">

<action>
Display validation results and offer next steps.
</action>

<presentation>

Show user:
```
Validation Complete!

Quality Score: {{quality_score}}/100 ({{quality_rating}})

Agent Quality: {{agent_checks_passed}}/{{agent_checks_total}} checks passed
Workflow Quality: {{workflow_checks_passed}}/{{workflow_checks_total}} checks passed
Team Quality: {{team_checks_passed}}/{{team_checks_total}} checks passed

{{#if critical_issues.length > 0}}
⚠️  {{critical_issues.length}} critical issue(s) found
{{/if}}

{{#if quality_score >= 95}}
🎉 Excellent quality! This team is ready to install immediately.
{{else if quality_score >= 85}}
✅ Good quality! Ready to use. Minor refinements optional.
{{else if quality_score >= 75}}
✓ Acceptable quality. Refinement recommended before installation.
{{else}}
⚠️  Quality needs improvement. Refinement required.
{{/if}}

What would you like to do?
1. View full validation report
2. Install team now (if score sufficient)
3. Refine team to improve quality
4. Regenerate with adjusted requirements
```

</presentation>

<options>

**Option 1: View Report**
- Display or open validation report
- User reviews details
- Then returns to options

**Option 2: Install**
- Only available if quality_score >= 75 (or user override)
- Installs team to `_bmad/teams/{{team_name}}/`
- Creates all agent and workflow files
- Team ready to use

**Option 3: Refine**
- Triggers refine-team workflow
- Passes validation report and issues
- Targeted improvement process

**Option 4: Regenerate**
- Returns to discovery (optional: adjust requirements)
- Full regeneration from scratch

</options>

</step>

---

## Special Cases

### Perfect Score (100%)
Rare but possible if:
- All checks pass
- Standout quality indicators present
- Bonus points earned

Present: "🌟 Perfect score! This is an exceptionally high-quality team. Install immediately!"

### Very Low Score (<50%)
Indicates major quality issues.

Present: "This team has significant quality issues. Recommend regeneration rather than refinement. Would you like to try again with clearer requirements?"

### Critical Issues Present
Even if overall score is acceptable, critical issues must be addressed.

Present: "⚠️  Critical issues found that must be fixed before installation. These are non-negotiable quality requirements. Please refine or regenerate."

### All Checks Pass But Low Score
Shouldn't happen with current rules, but if it does:

Investigate: Likely scoring calculation error. Default to "Good" rating and allow installation.

---

## Validation Report Template

The validation report (template.md) includes:

- **Quality Score Card:** Visual presentation of score and rating
- **Detailed Results:** Breakdown by check category
- **Issue Listing:** All issues organized by severity
- **Fix Suggestions:** Actionable recommendations
- **Strengths:** What team does well
- **Next Steps:** Clear options for user

---

## Success Criteria

Validation succeeds when:

1. ✅ All checks executed without errors
2. ✅ Quality score calculated accurately
3. ✅ Issues identified and categorized
4. ✅ Fix suggestions provided
5. ✅ Clear recommendation given to user
6. ✅ Report generated and accessible

**Validation Complete → User Decision → Install or Refine**
