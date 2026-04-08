# Refine Team — Workflow

Targeted improvement workflow. Takes a generated team plus its validation report and makes surgical fixes without regenerating what already works.

## Variables to Capture

```yaml
team_name: ""
team_path: ""               # absolute path to the team
current_team: {}            # all current agent + workflow definitions
validation_report: {}       # parsed from VALIDATION_REPORT.md
quality_score: 0            # current (pre-refinement) score
issues: []                  # all validation issues by severity

refinement_focus: ""
refinement_type: ""         # improve_personas | add_missing_expertise | enhance_workflows | adjust_team_size | change_collaboration | fix_domain_expertise
iteration_count: 0          # current iteration (1-based)

agents_to_revise: []
workflows_to_revise: []
agents_to_preserve: []
workflows_to_preserve: []

revised_agents: []
revised_workflows: []
changes_summary: []

new_quality_score: 0
score_improvement: 0
remaining_issues: []
remaining_critical_issues: 0
```

## Step 1 — Load Current Team and Validation Report

**Action:** Read the team under `{team_path}` and parse its `VALIDATION_REPORT.md`.

Extract:
- `team_name` from team `config.yaml`
- `current_team` — all agent directories and workflow skill directories
- `validation_report` — score, rating, issues by severity, fix suggestions
- `quality_score` — the current pre-refinement score
- `issues` — all issues ordered by severity

**Analyze:**
- Which agents have issues?
- Which workflows have issues?
- Which team-level aspects need work?
- Which components passed cleanly (these are preserved)?

Track `iteration_count` — increment by 1 each time this skill runs on the same team. If `iteration_count > max_refinement_iterations` (default 3), warn the user and recommend regeneration.

## Step 2 — Determine Refinement Focus

Work with the user to pick what to refine.

**Option A — user specifies focus:**
Ask: "What would you like to improve about this team?" Capture the user's words in `refinement_focus`.

**Option B — suggest based on issues:**
If the user is unsure, present the top priorities from the validation report:

```
Based on validation, I recommend focusing on:

1. {highest_priority_issue} ({severity}, +{potential_improvement} points)
2. {second_priority_issue}  ({severity}, +{potential_improvement} points)
3. {third_priority_issue}   ({severity}, +{potential_improvement} points)

Which would you like to tackle first?
```

**Option C — auto-focus on critical:**
If critical issues are present: "There are {critical_count} critical issue(s) that must be fixed. I'll focus on those first."

**Classify `refinement_type`:**

| Type | When |
|------|------|
| `improve_personas` | Generic or similar-sounding agents |
| `add_missing_expertise` | Key concern not covered by any specialist |
| `enhance_workflows` | Vague steps, invalid agent references, missing outputs |
| `adjust_team_size` | Team too small (gaps) or too large (consolidation needed) |
| `change_collaboration` | Collaboration model doesn't match user preference |
| `fix_domain_expertise` | Shallow or surface-level domain knowledge |

## Step 3 — Identify Components to Revise (and Preserve)

Based on `refinement_type`, identify exactly which agents and workflows need revision.

**For `improve_personas`:**
- Identify agents with similar communication styles
- Identify agents with generic identities
- Identify agents with weak or platitude principles
- Store in `agents_to_revise`

**For `add_missing_expertise`:**
- Identify which concerns lack specialists
- Determine new agent roles needed
- Plan where they fit in team structure

**For `enhance_workflows`:**
- Identify workflows with vague steps
- Identify workflows with invalid agent references
- Identify workflows missing outputs
- Store in `workflows_to_revise`

**For `adjust_team_size`:**
- Too small → identify gaps to fill
- Too large → identify agents to consolidate or remove

**For `change_collaboration`:**
- Identify how the collaboration model needs to shift
- Determine which agents are affected

**For `fix_domain_expertise`:**
- Identify agents that should have domain expertise but don't
- Gather domain terminology from the requirements document
- Plan expertise enhancements

**Critical — identify what to KEEP.** List agents and workflows that:
- Passed all validation checks
- Have no issues
- The user is satisfied with

These will be preserved unchanged. Store in `agents_to_preserve` and `workflows_to_preserve`.

## Step 4 — Perform Targeted Revisions

Make focused improvements to identified components. Work with `bmad-agent-persona-improver` whenever you revise a persona — their feedback loop is just as valuable during refinement as during initial generation.

### Revising agent personas

For each agent in `agents_to_revise`:

1. **Review current persona** — what's the specific issue? Which validation check failed?
2. **Targeted fix:**
   - Communication style too generic → create distinctive style
   - Identity lacks specifics → add concrete background
   - Principles are platitudes → express strong opinions
   - Too similar to another agent → dramatically differentiate
   - Lacks domain expertise → add domain terminology and context
3. **Preserve what works** — if the role description is good, keep it. Only change what needs fixing.
4. **Verify distinctness** — compare revised persona to other agents. Ensure it's sufficiently different. Check domain expertise is authentic.

**Example refinement:**

```
Original (generic):
  communicationStyle: "Professional and clear communication"

Revised (specific):
  communicationStyle: "Direct and data-driven. Leads with numbers.
  Starts every analysis with 'Let's look at the metrics.' Uses
  precise language and avoids ambiguity. Challenges assumptions
  with 'What's the data say?' Patient with explanation but
  intolerant of speculation without evidence."
```

### Adding new agents (for missing expertise/concerns)

1. **Define the role** — what concern does it address? What expertise does it bring?
2. **Generate persona** following the same quality standards as initial generation (paired with persona-improver).
3. **Integrate into the team** — where does the new agent fit? How does it collaborate with existing agents? Update `TEAM_README.md` and relevant workflow references.

### Enhancing workflows

For each workflow in `workflows_to_revise`:

1. **Review issues** — vague steps, invalid agent references, missing outputs, unclear collaboration
2. **Revise targeted sections** — don't rewrite the whole workflow if only one step is problematic. Fix specific steps that failed validation.
3. **Verify completeness** — `SKILL.md` + `workflow.md` (+ `template.md` if applicable) all present, agent references valid, steps actionable.

**Example refinement:**

```
Original (vague):
  Step 1: Gather requirements

Revised (specific):
  Step 1: Requirements elicitation
  Lead: Strategy Lead
  Action: Interview user about business objectives (specific metrics),
          constraints (budget, timeline, resources), stakeholders
          (names, roles, influence), and success criteria (measurable).
  Output: {output_folder}/requirements-doc.md
```

### Adjusting team size

- **Adding agents:** generate new agents with quality personas, ensure they fill real gaps, integrate into the collaboration model.
- **Removing/consolidating agents:** identify least critical agents, consider consolidating similar roles, update workflows that referenced removed agents.

### Changing collaboration model

Update the coordinator agent if needed, revise workflow collaboration patterns, update team `config.yaml`, ensure consistency across all agents.

### Fixing domain expertise

- Review requirements for domain terminology
- Enhance domain expert agents with real terminology
- Add domain-specific challenges to principles
- Demonstrate understanding through concrete credentials and context

Store revised/new components in `revised_agents`, `revised_workflows`, and log every change in `changes_summary` (what changed and why).

## Step 5 — Integrate Changes

Combine preserved components with revised components into the updated team.

**Build updated team:**
```
Preserved agents (no issues)
+ Revised agents (targeted improvements)
+ New agents (if added)
= Complete updated team
```

Same for workflows.

**Verify consistency:**
- All agent references in workflows still valid?
- Team size within acceptable range?
- Collaboration model coherent?
- All concerns addressed?

Write all revised files back to `{team_path}/` — directly overwriting the files that changed. The team directory remains the single source of truth.

## Step 6 — Re-Validate Refined Team

Invoke `bmad-skill-validate-team` on the refined team, passing:

- `team_path` (same)
- Original requirements document
- Note that this is refinement iteration `iteration_count`

Validation will:
1. Run all checks on the revised team
2. Calculate `new_quality_score`
3. Identify `remaining_issues`
4. Write a new `VALIDATION_REPORT.md` (overwriting the previous one)

Compare results:
- `new_quality_score` vs `quality_score`
- `score_improvement = new_quality_score - quality_score`
- `remaining_issues` = issues still present

## Step 7 — Write Refinement Report

Write `{team_path}/REFINEMENT_REPORT.md` summarizing:

- Iteration number
- Refinement focus and type
- Components revised (agents and workflows, with brief description of what changed)
- Components preserved
- Score before → after
- Remaining issues (summary)
- Recommendation for next step

## Step 8 — Present Refinement Results

Show the user:

```
Refinement complete!

Quality Score: {quality_score} → {new_quality_score}  (+{score_improvement} points)

Changes made:
- {change 1}
- {change 2}
- ...

{verdict line matched to new_quality_score}

Remaining issues:
- [severity] {issue title}
- ...
(or: None! All validation checks passed.)
```

**Verdict lines:**

- `new_quality_score >= 95` → "Excellent quality achieved! Ready to install."
- `new_quality_score >= 85` → "Good quality! {if score_improvement >= 10: 'Significant improvement!'} Ready to install or refine further (optional)."
- `new_quality_score >= 75` → "Acceptable quality reached. {if remaining_critical_issues == 0: 'No critical issues remaining.'} Install now or continue refining?"
- `new_quality_score < 75` → "Quality improved but still has issues. {if remaining_critical_issues > 0: '{count} critical issues remaining.'} Continue refining? (Iteration {iteration_count}/3)"

## Step 9 — Offer Next Steps

**If `new_quality_score >= 85`:**
```
Options:
1. Install team now — quality is good
2. Make additional refinements — polish to excellent
3. View detailed validation report
```

**If `new_quality_score >= 75` and `< 85`:**
```
Options:
1. Install team now — acceptable quality
2. Continue refining — target 85+ (recommended)
3. View remaining issues
4. Start over with a different approach
```

**If `new_quality_score < 75`:**
```
Options:
1. Continue refining — address remaining issues ({remaining_critical_issues} critical)
2. View detailed validation report
3. Regenerate team — fresh start
4. Install anyway — use as-is (not recommended)
```

**If `iteration_count >= 3`:**
```
You've done 3 refinement iterations.

Current score: {new_quality_score}
Total improvement: +{total_improvement} points from original

Options:
1. Install current version — you've made good progress
2. One more refinement round — target a specific issue
3. Regenerate — sometimes a fresh start is faster
```

**Decision handling:**

- **Refine again** → return to Step 2 (new focus), increment `iteration_count`.
- **Install** → tell the user to run `npx bmad-method install --custom-content "{team_path}" -y`. BMAD registers everything automatically. Remind them to configure `.mcp.json` memory path and restart Claude Code.
- **Regenerate** → hand back to `bmad-skill-discover-team-needs` with notes on what should change.
- **View report** → display `VALIDATION_REPORT.md`, return to options.

## Refinement Strategies (cheat sheet)

| Strategy | Best for | Expected improvement |
|----------|----------|----------------------|
| **Fix critical first** | Teams with 1–3 critical issues | Variable, often +10–20 |
| **Quick wins** | Teams close to threshold (72–84) | +5–10 (often pushes over 85) |
| **Persona polish** | Generic or similar-sounding agents | +10–15 |
| **Domain enhancement** | Lacking authentic domain expertise | +8–12 |
| **Workflow specificity** | Vague workflow steps | +6–10 |
| **Concern coverage** | Missing specialist for a key concern | +10–15 |

## Common Refinement Scenarios

### "Agents sound too similar"
**Focus:** `improve_personas`
**Actions:** identify 3–4 most similar agents; dramatically vary communication styles (formal vs casual vs technical); add distinctive personality markers; ensure different backgrounds and perspectives.

### "Missing domain expertise"
**Focus:** `fix_domain_expertise`
**Actions:** review requirements for domain context; enhance domain-expert agents with real terminology; add domain-specific challenges to principles; demonstrate understanding in identity.

### "Workflows are too vague"
**Focus:** `enhance_workflows`
**Actions:** make steps specific and actionable; add explicit agent assignments; define concrete outputs; specify collaboration patterns.

### "Key concern not addressed"
**Focus:** `add_missing_expertise`
**Actions:** create a specialist agent for the concern; integrate into team structure; update workflows to include the new agent; verify concern coverage.

## Quality Checks During Refinement

**After Step 4 (revisions):**
- Are revised personas truly distinct now?
- Is domain expertise authentic?
- Are workflow steps specific?
- Did you preserve what was working?

**Before Step 6 (re-validation):**
- Did revisions address the target issues?
- Are all agent references in workflows still valid?
- Is team composition still sensible?
- Did you make targeted changes, not wholesale rewrites?

## Special Cases

- **Refinement not improving score after 2 iterations:** suggest regeneration instead. May need a different approach; the original generation may have fundamental issues.
- **Score decreases after refinement (rare):** revisions introduced new issues. Roll back to the previous version and try a different refinement approach.
- **User wants wholesale changes** (different domain, purpose, or dramatically different team size): suggest regeneration — refinement is for polishing, not transforming.

## Success Criteria

Refinement succeeds when:

1. Quality score improves by ≥ 5 points
2. Target issues are resolved or significantly improved
3. Good aspects of the team are preserved
4. The new score meets the user's threshold
5. The user is satisfied with the refined team

---

**Refinement Complete → Re-Validate → Install or Continue**
