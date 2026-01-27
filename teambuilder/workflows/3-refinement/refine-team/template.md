# Team Refinement Report

**Team Name:** {{team_name}}
**Refinement Iteration:** {{iteration_count}}
**Completed:** {{timestamp}}

---

## Refinement Summary

### Score Improvement

<div style="padding: 15px; background: #f0f8ff; border-radius: 8px; text-align: center;">

## {{quality_score}} → {{new_quality_score}}

### +{{score_improvement}} points

{{#if score_improvement >= 15}}
🚀 **Excellent improvement!**
{{else if score_improvement >= 10}}
✅ **Significant improvement**
{{else if score_improvement >= 5}}
✓ **Good progress**
{{else if score_improvement > 0}}
↗️ **Minor improvement**
{{else}}
⚠️  **No improvement** - Different approach needed
{{/if}}

</div>

---

## Changes Made

### Refinement Focus
**Primary Focus:** {{refinement_focus}}
**Refinement Type:** {{refinement_type}}

### Components Revised

{{#if revised_agents.length > 0}}
#### Agents Revised ({{revised_agents.length}})

{{#for each agent in revised_agents}}
**{{agent.display_name}}**
- **What Changed:** {{agent.changes_description}}
- **Why:** {{agent.reason_for_change}}
- **Impact:** {{agent.expected_impact}}

{{#if agent.before_after}}
**Before:**
```
{{agent.before_snippet}}
```

**After:**
```
{{agent.after_snippet}}
```
{{/if}}

---
{{/for}}
{{/if}}

{{#if new_agents.length > 0}}
#### Agents Added ({{new_agents.length}})

{{#for each agent in new_agents}}
**{{agent.display_name}}** - {{agent.title}}
- **Role:** {{agent.role}}
- **Why Added:** {{agent.addition_reason}}
- **Addresses:** {{agent.concern_addressed}}

---
{{/for}}
{{/if}}

{{#if removed_agents.length > 0}}
#### Agents Removed ({{removed_agents.length}})

{{#for each agent in removed_agents}}
- **{{agent.display_name}}** - {{agent.removal_reason}}
{{/for}}

---
{{/if}}

{{#if revised_workflows.length > 0}}
#### Workflows Revised ({{revised_workflows.length}})

{{#for each workflow in revised_workflows}}
**{{workflow.name}}**
- **What Changed:** {{workflow.changes_description}}
- **Why:** {{workflow.reason_for_change}}
- **Impact:** {{workflow.expected_impact}}

---
{{/for}}
{{/if}}

{{#if preserved_count > 0}}
#### Components Preserved

**{{preserved_count}} agents** and **{{preserved_workflows_count}} workflows** were kept unchanged because they passed validation.

✅ Preserved what was working well
{{/if}}

---

## Validation Results Comparison

### Before Refinement

| Category | Passed | Total | Pass Rate |
|----------|--------|-------|-----------|
| Agent Checks | {{old_agent_checks_passed}} | {{old_agent_checks_total}} | {{old_agent_pass_rate}}% |
| Workflow Checks | {{old_workflow_checks_passed}} | {{old_workflow_checks_total}} | {{old_workflow_pass_rate}}% |
| Team Checks | {{old_team_checks_passed}} | {{old_team_checks_total}} | {{old_team_pass_rate}}% |

**Quality Score:** {{quality_score}}/100 ({{old_quality_rating}})

**Issues:**
- Critical: {{old_critical_count}}
- High: {{old_high_count}}
- Medium: {{old_medium_count}}
- Low: {{old_low_count}}

### After Refinement

| Category | Passed | Total | Pass Rate | Change |
|----------|--------|-------|-----------|--------|
| Agent Checks | {{new_agent_checks_passed}} | {{new_agent_checks_total}} | {{new_agent_pass_rate}}% | {{agent_improvement}} |
| Workflow Checks | {{new_workflow_checks_passed}} | {{new_workflow_checks_total}} | {{new_workflow_pass_rate}}% | {{workflow_improvement}} |
| Team Checks | {{new_team_checks_passed}} | {{new_team_checks_total}} | {{new_team_pass_rate}}% | {{team_improvement}} |

**Quality Score:** {{new_quality_score}}/100 ({{new_quality_rating}})

**Issues:**
- Critical: {{new_critical_count}} ({{critical_change}})
- High: {{new_high_count}} ({{high_change}})
- Medium: {{new_medium_count}} ({{medium_change}})
- Low: {{new_low_count}} ({{low_change}})

---

## Issues Resolved

{{#if resolved_issues.length > 0}}
✅ **{{resolved_issues.length}} issues resolved:**

{{#for each issue in resolved_issues}}
- **{{issue.title}}** ({{issue.severity}}) - {{issue.resolution}}
{{/for}}
{{else}}
No new issues resolved in this iteration.
{{/if}}

---

## Remaining Issues

{{#if remaining_critical_issues.length > 0}}
### ❌ Critical Issues ({{remaining_critical_issues.length}})

{{#for each issue in remaining_critical_issues}}
**{{issue.title}}**
- **Problem:** {{issue.description}}
- **Fix:** {{issue.fix_suggestion}}

---
{{/for}}
{{/if}}

{{#if remaining_high_issues.length > 0}}
### ⚠️  High-Priority Issues ({{remaining_high_issues.length}})

{{#for each issue in remaining_high_issues}}
- **{{issue.title}}** - {{issue.fix_suggestion}}
{{/for}}

---
{{/if}}

{{#if remaining_medium_issues.length > 0}}
### ⚡ Medium Issues ({{remaining_medium_issues.length}})

{{#for each issue in remaining_medium_issues}}
- {{issue.title}}
{{/for}}

---
{{/if}}

{{#if total_remaining_issues == 0}}
### 🎉 No Issues Remaining!

All validation checks passed. Team is ready to install.
{{/if}}

---

## Recommendations

{{#if new_quality_score >= 95}}
### 🌟 Excellent Quality - Install Now!

Your team has reached exceptional quality. All critical improvements have been made.

**Next Step:** Install this team and start using it!

{{else if new_quality_score >= 85}}
### ✅ Good Quality - Ready to Install

Your team has good quality with {{#if remaining_critical_issues.length == 0}}no critical issues{{/if}}.

**Options:**
1. **Install now** - Team is ready to use (recommended)
2. **Polish further** - Make minor improvements to reach excellent

{{#if score_improvement >= 10}}
You've made significant progress (+{{score_improvement}} points). Good work!
{{/if}}

{{else if new_quality_score >= 75}}
### ✓ Acceptable Quality

Your team has reached acceptable quality.

{{#if remaining_critical_issues.length > 0}}
⚠️  **However:** {{remaining_critical_issues.length}} critical issues remain.
Recommend one more refinement round to address these.
{{else}}
No critical issues remaining. You can install or continue polishing.
{{/if}}

**Options:**
1. **Install now** - Functional team
2. **Refine once more** - Target 85%+ (recommended)
3. **Focus on:** {{next_refinement_focus}}

{{else}}
### ⚠️  Needs More Work

Quality has improved (+{{score_improvement}}) but more refinement needed.

**Critical Issues:** {{remaining_critical_issues.length}}
**High-Priority Issues:** {{remaining_high_issues.length}}

**Recommended Next Steps:**
{{#for each recommendation in refinement_recommendations}}
{{loop_index}}. {{recommendation.action}} (Expected: +{{recommendation.points}} points)
{{/for}}

{{#if iteration_count >= 3}}
**Note:** You've done {{iteration_count}} refinement iterations. Consider:
- Install current version (you've made {{total_improvement}} points of progress)
- OR regenerate with clearer requirements (fresh start)
{{/if}}

{{/if}}

---

## Refinement Effectiveness

### What Worked Well

{{#for each success in refinement_successes}}
✅ {{success}}
{{/for}}

### Challenges

{{#if refinement_challenges.length > 0}}
{{#for each challenge in refinement_challenges}}
⚠️  {{challenge}}
{{/for}}
{{/if}}

### Lessons Learned

{{#for each lesson in lessons_learned}}
💡 {{lesson}}
{{/for}}

---

## Next Refinement Recommendations

{{#if iteration_count < 3 and new_quality_score < 85}}

### Suggested Focus for Next Iteration

**Priority 1:** {{next_priority_1}}
- **Why:** {{priority_1_rationale}}
- **Expected Improvement:** +{{priority_1_points}} points

**Priority 2:** {{next_priority_2}}
- **Why:** {{priority_2_rationale}}
- **Expected Improvement:** +{{priority_2_points}} points

**Priority 3:** {{next_priority_3}}
- **Why:** {{priority_3_rationale}}
- **Expected Improvement:** +{{priority_3_points}} points

**Estimated Total Improvement:** +{{estimated_next_improvement}} points
**Projected Score After Next Refinement:** ~{{projected_score}}

{{else if iteration_count >= 3}}

### Refinement Fatigue Warning

You've completed {{iteration_count}} refinement iterations with {{total_improvement}} total improvement.

**Current Options:**
1. **Install current version** - You've made good progress, team is functional
2. **One final focused refinement** - Address single highest-priority issue
3. **Regenerate** - Sometimes a fresh start with clearer requirements is faster

{{else}}

### Ready to Install!

No further refinement needed. Your team quality is excellent.

{{/if}}

---

## Detailed Changes Log

{{#for each change in detailed_changes_log}}
### Change {{loop_index}}: {{change.component_type}} - {{change.component_name}}

**Issue Addressed:** {{change.issue_addressed}}

**Change Type:** {{change.change_type}}

**Before:**
```
{{change.before}}
```

**After:**
```
{{change.after}}
```

**Validation Impact:**
- Checks newly passed: {{change.checks_passed}}
- Expected score impact: +{{change.score_impact}} points

---
{{/for}}

---

## Refinement Statistics

| Metric | Value |
|--------|-------|
| **Iteration Number** | {{iteration_count}} |
| **Score Improvement (This Round)** | +{{score_improvement}} points |
| **Total Improvement** | +{{total_improvement}} points |
| **Agents Revised** | {{revised_agents.length}} |
| **Agents Added** | {{new_agents.length}} |
| **Agents Removed** | {{removed_agents.length}} |
| **Workflows Revised** | {{revised_workflows.length}} |
| **Issues Resolved** | {{resolved_issues.length}} |
| **Issues Remaining** | {{total_remaining_issues}} |
| **Refinement Time** | {{refinement_time}} |

---

## User Decision

{{#if new_quality_score >= 85}}
### Ready for Installation

Your refined team is ready to use!

**To install:**
```
Proceed with installation? (yes/no)
```

Team will be installed to: `_bmad/teams/{{team_name}}/`

{{else if new_quality_score >= 75}}
### Decision Point

Your team has acceptable quality but could be improved further.

**Options:**
1. Install now (functional team)
2. Refine once more (target 85%+)
3. View remaining issues

**What would you like to do?**

{{else}}
### Refinement Needed

Additional refinement recommended to reach installation quality.

**Options:**
1. Continue refining (address {{remaining_critical_issues.length}} critical issues)
2. View detailed validation report
3. Regenerate team
4. Install anyway (not recommended)

**What would you like to do?**

{{/if}}

---

## Refinement Metadata

**Refinement Engine:** TeamBuilder v2.0
**Refinement Type:** {{refinement_type}}
**Iteration:** {{iteration_count}}/3
**Started:** {{refinement_start_time}}
**Completed:** {{refinement_end_time}}
**Duration:** {{refinement_duration}}

**Original Quality Score:** {{original_quality_score}} (before any refinements)
**Current Quality Score:** {{new_quality_score}}
**Total Progress:** +{{total_improvement}} points

---

_This refinement report shows targeted improvements made to your team. Refinement preserves what works well and fixes what doesn't, resulting in better quality faster than full regeneration._

_Report saved: {{report_filename}}_
