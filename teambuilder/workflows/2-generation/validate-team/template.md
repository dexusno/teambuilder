# Team Validation Report

**Team Name:** {{team_name}}
**Validated:** {{timestamp}}
**TeamBuilder Version:** 2.0

---

## Quality Score Card

<div style="text-align: center; padding: 20px; background: #f5f5f5; border-radius: 10px;">

# {{quality_score}}/100

### {{quality_rating}}

{{#if quality_score >= 95}}
🌟 **Exceptional Quality** - Install immediately!
{{else if quality_score >= 85}}
✅ **Good Quality** - Ready to use
{{else if quality_score >= 75}}
✓ **Acceptable Quality** - Refinement recommended
{{else if quality_score >= 60}}
⚠️  **Needs Improvement** - Refinement required
{{else}}
❌ **Requires Refinement** - Significant issues found
{{/if}}

</div>

---

## Validation Summary

### Overall Results

| Category | Passed | Total | Pass Rate |
|----------|--------|-------|-----------|
| **Agent Checks** | {{agent_checks_passed}} | {{agent_checks_total}} | {{agent_pass_rate}}% |
| **Workflow Checks** | {{workflow_checks_passed}} | {{workflow_checks_total}} | {{workflow_pass_rate}}% |
| **Team Checks** | {{team_checks_passed}} | {{team_checks_total}} | {{team_pass_rate}}% |
| **Overall** | {{total_checks_passed}} | {{total_checks_total}} | {{overall_pass_rate}}% |

### Issue Count by Severity

{{#if critical_issues.length > 0}}
- ❌ **Critical:** {{critical_issues.length}} (Must fix)
{{/if}}
{{#if high_issues.length > 0}}
- ⚠️  **High:** {{high_issues.length}} (Strongly recommended)
{{/if}}
{{#if medium_issues.length > 0}}
- ⚡ **Medium:** {{medium_issues.length}} (Improvements)
{{/if}}
{{#if low_issues.length > 0}}
- ℹ️  **Low:** {{low_issues.length}} (Polish)
{{/if}}

---

{{#if critical_issues.length > 0}}
## Critical Issues (Must Fix)

These issues are non-negotiable and must be addressed before installation.

{{#for each issue in critical_issues}}
### {{loop_index}}. {{issue.title}}

**Problem:** {{issue.description}}

**Impact:** {{issue.impact}}

**Affected:** {{issue.affected_component}}

**Fix:** {{issue.fix_suggestion}}

**Example:**
{{issue.example}}

---
{{/for}}

{{/if}}

{{#if high_issues.length > 0}}
## High-Priority Issues

These issues significantly impact quality and should be addressed.

{{#for each issue in high_issues}}
### {{loop_index}}. {{issue.title}}

**Problem:** {{issue.description}}

**Why It Matters:** {{issue.rationale}}

**Affected:** {{issue.affected_component}}

**How to Fix:** {{issue.fix_suggestion}}

---
{{/for}}

{{/if}}

{{#if medium_issues.length > 0}}
## Improvement Opportunities

These changes would enhance team quality.

{{#for each issue in medium_issues}}
- **{{issue.title}}:** {{issue.description}}
  - Fix: {{issue.fix_suggestion}}
{{/for}}

{{/if}}

{{#if low_issues.length > 0}}
## Polish Items

Minor improvements for exceptional quality.

{{#for each issue in low_issues}}
- {{issue.description}} → {{issue.fix_suggestion}}
{{/for}}

{{/if}}

---

## Agent Quality Analysis

{{#for each agent in generated_agents}}
### {{agent.display_name}}

**Overall:** {{agent.quality_assessment}}

{{#if agent.issues.length > 0}}
**Issues:**
{{#for each issue in agent.issues}}
- [{{issue.severity}}] {{issue.description}}
{{/for}}
{{else}}
✅ No issues found
{{/if}}

**Strengths:**
{{#for each strength in agent.strengths}}
- {{strength}}
{{/for}}

---
{{/for}}

---

## Workflow Quality Analysis

{{#if generated_workflows.length > 0}}

{{#for each workflow in generated_workflows}}
### {{workflow.name}}

**Overall:** {{workflow.quality_assessment}}

{{#if workflow.issues.length > 0}}
**Issues:**
{{#for each issue in workflow.issues}}
- [{{issue.severity}}] {{issue.description}}
{{/for}}
{{else}}
✅ No issues found
{{/if}}

**Strengths:**
{{#for each strength in workflow.strengths}}
- {{strength}}
{{/for}}

---
{{/for}}

{{else}}
No workflows were generated for this team.
{{/if}}

---

## Team Composition Analysis

### Coverage Assessment

{{#if has_coordinator}}
✅ **Coordinator Present:** {{coordinator_name}}
{{else}}
❌ **Missing Coordinator:** Team needs primary decision-maker
{{/if}}

{{#if has_domain_expert}}
✅ **Domain Expertise:** {{domain_experts_list}}
{{else}}
❌ **Missing Domain Expertise:** No deep domain expert found
{{/if}}

### Key Concerns Coverage

{{#for each concern in key_concerns_from_requirements}}
{{#if concern.addressed}}
✅ **{{concern.name}}** addressed by {{concern.agent_name}}
{{else}}
❌ **{{concern.name}}** NOT addressed - missing specialist
{{/if}}
{{/for}}

### Team Size

**Current:** {{agent_count}} agents
**Requested:** {{team_size_preference}}
**Assessment:** {{team_size_assessment}}

### Collaboration Model

**Style:** {{collaboration_style}}
**Assessment:** {{collaboration_assessment}}

---

## Top Recommendations

### Priority Fixes

These changes will have the biggest impact on quality:

{{#for each recommendation in refinement_priorities}}
{{loop_index}}. **{{recommendation.title}}**
   - **Impact:** {{recommendation.impact}}
   - **Action:** {{recommendation.action}}
   - **Expected Improvement:** +{{recommendation.score_improvement}} points
{{/for}}

### Quick Wins

Easy fixes that improve quality:

{{#for each quick_win in quick_wins}}
- {{quick_win.description}} ({{quick_win.effort}}, +{{quick_win.points}} points)
{{/for}}

---

## Team Strengths

What this team does well:

{{#for each strength in team_strengths}}
✅ {{strength}}
{{/for}}

---

## Pattern Comparison

### Pattern Similarity Check

{{#for each pattern in patterns_compared}}
- **{{pattern.name}}:** {{pattern.similarity_score}}% similar
  {{#if pattern.similarity_score > 50}}
  ⚠️  Too similar - team may be copying pattern rather than learning from it
  {{else}}
  ✅ Appropriately inspired by pattern principles
  {{/if}}
{{/for}}

### Generation Quality Indicators

{{#for each indicator in generation_quality_indicators}}
{{#if indicator.present}}
✅ {{indicator.name}}: {{indicator.assessment}}
{{else}}
❌ {{indicator.name}}: {{indicator.missing_reason}}
{{/if}}
{{/for}}

---

## Detailed Check Results

### Agent-Level Checks

{{#for each check_category in agent_check_categories}}
**{{check_category.name}}**

{{#for each check in check_category.checks}}
- {{#if check.passed}}✅{{else}}❌{{/if}} {{check.rule}}
  {{#if not check.passed}}
  - Issue: {{check.issue_description}}
  - Fix: {{check.fix_suggestion}}
  {{/if}}
{{/for}}

{{/for}}

### Workflow-Level Checks

{{#for each check_category in workflow_check_categories}}
**{{check_category.name}}**

{{#for each check in check_category.checks}}
- {{#if check.passed}}✅{{else}}❌{{/if}} {{check.rule}}
  {{#if not check.passed}}
  - Issue: {{check.issue_description}}
  - Fix: {{check.fix_suggestion}}
  {{/if}}
{{/for}}

{{/for}}

### Team-Level Checks

{{#for each check_category in team_check_categories}}
**{{check_category.name}}**

{{#for each check in check_category.checks}}
- {{#if check.passed}}✅{{else}}❌{{/if}} {{check.rule}}
  {{#if not check.passed}}
  - Issue: {{check.issue_description}}
  - Fix: {{check.fix_suggestion}}
  {{/if}}
{{/for}}

{{/for}}

---

## Score Breakdown

### Base Score
Starting score: 100 points

### Deductions

{{#for each deduction in score_deductions}}
- **{{deduction.rule}}** ({{deduction.severity}}): -{{deduction.points}} points
  {{deduction.reason}}
{{/for}}

**Total Deductions:** -{{total_deductions}} points

### Bonuses

{{#if bonuses.length > 0}}
{{#for each bonus in bonuses}}
- **{{bonus.reason}}**: +{{bonus.points}} points
{{/for}}

**Total Bonuses:** +{{total_bonuses}} points
{{else}}
No bonus points awarded.
{{/if}}

### Final Calculation

```
Base Score:        100
Deductions:       -{{total_deductions}}
Bonuses:          +{{total_bonuses}}
-------------------
Final Score:       {{quality_score}}/100
```

---

## Recommended Action

{{#if quality_score >= 95}}
### 🌟 Install Immediately

This team has exceptional quality with {{#if critical_issues.length == 0}}no critical issues{{/if}} and standout personas.

**Next Steps:**
1. Review team composition one final time
2. Install to `_bmad/teams/{{team_name}}/`
3. Start using your new team!

**Installation Command:**
```
Install this team? (yes/no)
```

{{else if quality_score >= 85}}
### ✅ Ready to Install

This team has good quality and is ready to use. Minor refinements are optional.

**Options:**
1. **Install now** - Team is functional and will serve you well
2. **Make minor refinements** - Polish to excellent quality (optional)

**If installing:**
- Team will be available at `_bmad/teams/{{team_name}}/`
- All {{agent_count}} agents ready to use
- {{workflow_count}} workflows available

**If refining:**
- Focus on: {{top_3_improvements}}
- Expected improvement: ~{{expected_score_gain}} points

{{else if quality_score >= 75}}
### ✓ Refinement Recommended

This team is acceptable but has quality gaps. Refinement recommended before installation.

**Key Issues to Address:**
{{#for each issue in top_refinement_priorities}}
{{loop_index}}. {{issue.title}} ({{issue.severity}})
{{/for}}

**Options:**
1. **Refine team** - Address issues above (recommended)
2. **Install anyway** - Use as-is (team is functional)
3. **Regenerate** - Start over with adjusted requirements

**If refining:**
- Expected time: 2-3 minutes per iteration
- Target score: 85%+
- Focus on {{refinement_focus_areas}}

{{else}}
### ⚠️  Refinement Required

This team has significant quality issues that should be addressed before installation.

**Critical Issues:**
{{#for each issue in critical_issues}}
- {{issue.title}}
{{/for}}

**High-Priority Issues:**
{{#for each issue in high_issues}}
- {{issue.title}}
{{/for}}

**Recommended Path:**
1. **Refine team** - Address critical and high-priority issues
2. **Re-validate** - Confirm improvements
3. **Install** - Once score reaches 85%+

**Alternative:**
- **Regenerate** - If many issues, might be faster to regenerate with clearer requirements

**Refinement Priorities:**
{{#for each priority in refinement_priorities}}
{{loop_index}}. {{priority.title}} (+{{priority.expected_improvement}} points)
{{/for}}

{{/if}}

---

## Requirements Alignment Check

### Original Requirements

**Primary Task:** {{primary_task_from_requirements}}

**Domain:** {{domain_from_requirements}}

**Key Concerns:**
{{#for each concern in key_concerns_from_requirements}}
- {{concern}}
{{/for}}

**Required Expertise:** {{required_expertise_from_requirements}}

### Alignment Assessment

{{#if fully_aligned}}
✅ **Fully Aligned** - Team addresses all requirements
{{else}}
⚠️  **Alignment Gaps** - Some requirements not fully addressed:
{{#for each gap in alignment_gaps}}
- {{gap.requirement}}: {{gap.gap_description}}
{{/for}}
{{/if}}

---

## Next Steps

### Immediate Options

1. **View Generation Summary** - See what was generated
2. **Install Team** - Make team available for use {{#if quality_score < 75}}(not recommended){{/if}}
3. **Refine Team** - Improve quality through targeted changes {{#if quality_score < 85}}(recommended){{/if}}
4. **Regenerate** - Start over with new/adjusted requirements

### After Installation

Once installed, you can:
- Invoke agents: `/bmad:teams:{{team_name}}:agents:{agent-name}`
- Use workflows from agent menus
- Collaborate via party mode
- Manually edit agents/workflows as needed

---

## Validation Metadata

**Validation Engine:** TeamBuilder v2.0
**Rules Version:** validation-rules.yaml v1.0
**Total Checks Run:** {{total_checks_total}}
**Execution Time:** {{validation_execution_time}}

**Quality Thresholds:**
- Excellent: 95+ points
- Good: 85-94 points
- Acceptable: 75-84 points
- Needs Improvement: 60-74 points
- Requires Refinement: <60 points

---

_This validation report provides transparency into team quality. You have final authority on whether to install, refine, or regenerate._

_Generated by TeamBuilder Validation System_
_Report saved: {{report_filename}}_
