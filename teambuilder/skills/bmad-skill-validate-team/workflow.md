# Validate Team — Workflow

Automated quality assessment using rule-based validation. Runs 30+ checks across agent, workflow, and team-coherence levels; calculates a severity-weighted 0–100 score; produces a VALIDATION_REPORT.md with actionable recommendations.

## Variables to Capture

```yaml
team_name: ""
team_path: ""               # absolute path to the team directory
generated_agents: []
generated_workflows: []
requirements_document: ""   # path

validation_rules: {}        # loaded from validation-rules.yaml
agent_checks_passed: 0
agent_checks_total: 0
workflow_checks_passed: 0
workflow_checks_total: 0
team_checks_passed: 0
team_checks_total: 0

critical_issues: []
high_issues: []
medium_issues: []
low_issues: []

quality_score: 0
quality_rating: ""          # Excellent | Good | Acceptable | Needs Improvement | Requires Refinement
recommended_action: ""
fix_suggestions: []
refinement_priorities: []
```

## Step 1 — Load Validation Rules

**Action:** Load validation rules from `{project-root}/_bmad/teambuilder/templates/validation-rules.yaml`.

Extract three categories:
- `agent_checks` — role clarity, persona quality, domain expertise, distinctness, structure
- `workflow_checks` — completeness, actionability, agent references, coherence
- `team_checks` — coverage, team size, collaboration model, domain alignment

Store in `validation_rules`.

## Step 2 — Run Agent-Level Checks

For each agent in `generated_agents`, run all agent validation checks.

**Role clarity:**
- Each agent has a distinct, non-overlapping role (role similarity < 60%)?
- Role description is specific, not vague?

**Persona quality:**
- Identity has specific background (not "experienced professional")?
- Communication style is distinctive (not generic)?
- Principles show clear values (not platitudes)?
- Agent is memorable (has personality markers)?

**Domain expertise:**
- Uses domain-specific terminology?
- Shows domain understanding in identity or principles?

**Distinctness:**
- Agents don't sound alike (communication styles vary)?
- No duplicate personas (identity similarity < 70%)?

**Architecture compliance (v6):**
- User-facing agent has both `SKILL.md` AND `bmad-skill-manifest.yaml` with `type: agent`?
- Skill-only agent has just `SKILL.md` (or no `type: agent`)?
- Names follow `bmad-agent-*` (lowercase, hyphens only), directory name matches `name` field?
- Manifest has all 9 required fields populated (`type`, `name`, `displayName`, `title`, `icon`, `capabilities`, `role`, `identity`, `communicationStyle`, `principles`, `module`)?

**Pattern similarity:**
- Not too similar to pattern library examples (< 50% similarity)?

For each failed check, record: issue description, severity (critical / high / medium / low), score_impact from the rule, and a fix_suggestion.

Count `agent_checks_passed` and `agent_checks_total`.

## Step 3 — Run Workflow-Level Checks

For each workflow skill in `generated_workflows`, run all workflow validation checks.

**Completeness:**
- Has `SKILL.md` with frontmatter (`name`, `description`)?
- Has `workflow.md` with step-by-step instructions?
- Has `template.md` if the workflow produces a structured document?
- Output location is specified?

**Actionability:**
- Steps are specific, not vague ("Step 1: Gather information" fails; "Step 1: Interview user about X, Y, Z, produce foo.md" passes)?
- Agent assignments are clear at each step?
- Outputs are measurable?

**Agent references:**
- References valid agent names from the team (not placeholders or stale names)?
- Agent roles match the capabilities called out at each step?

**Coherence:**
- Steps follow a logical sequence?
- Collaboration patterns are clear?
- Workflow length is 3–10 steps?

Record failed checks with severity, score_impact, fix_suggestion. Count `workflow_checks_passed` and `workflow_checks_total`.

## Step 4 — Run Team-Level Checks

Analyze the team as a whole.

**Coverage:**
- Has a coordinator or decision-maker?
- Has a domain expert?
- Every key concern from requirements addressed by a specialist?
- Complete functional coverage (analysis, execution, quality/review)?

**Team size:**
- Appropriate for scope?
- Not too small (< 4 agents)?
- Not too large (> 12 agents)?

**Collaboration model:**
- Clear collaboration structure?
- No isolated agents?

**Domain alignment:**
- Team aligned with discovered domain?
- Addresses the user's specific context (from `domain_specific_1/2/3`)?

**Quality indicators:**
- Has a distinctive team character?
- Agents complement rather than overlap?

Record failed checks, count `team_checks_passed` and `team_checks_total`.

## Step 5 — Calculate Quality Score

Start with `base_score = 100`.

For each failed check, deduct:

```
if severity == "critical":  deduction = score_impact × 1.5
elif severity == "high":    deduction = score_impact × 1.2
elif severity == "medium":  deduction = score_impact × 1.0
else:                       deduction = score_impact × 0.5  # low

base_score -= deduction
```

`quality_score = max(0, base_score)`

**Bonus points** (add after deductions, cap at 100):
- Has standout personas: +5
- Exceptional domain expertise: +3
- Highly varied communication styles: +3

Final: `quality_score = min(100, base_score + bonuses)`

## Step 6 — Determine Rating

| Score range | Rating |
|-------------|--------|
| 95–100 | Excellent |
| 85–94 | Good |
| 75–84 | Acceptable |
| 60–74 | Needs Improvement |
| <60 | Requires Refinement |

Store in `quality_rating`.

## Step 7 — Organize Issues by Severity

Categorize all validation issues:

- `critical_issues` — must be fixed before install
- `high_issues` — strongly recommended to fix
- `medium_issues` — improvements that would enhance quality
- `low_issues` — minor polish items

Within each severity level, prioritize by:
1. Impact on the user's `primary_task`
2. Scope of impact (affects many agents vs one)
3. Ease of fix

## Step 8 — Generate Fix Suggestions

For the top issues, create actionable fix suggestions with:
- **What's wrong** — clear problem statement
- **Why it matters** — impact on team quality
- **How to fix** — specific action to take
- **Example** — before/after when helpful

Store in `fix_suggestions`.

Identify top 3–5 `refinement_priorities`:
1. Critical issues first
2. High-impact improvements
3. Quick wins (easy fixes with good impact)

## Step 9 — Determine Recommended Action

| Score | `recommended_action` |
|-------|---------------------|
| ≥ 95 | "Install immediately — Excellent quality!" |
| ≥ 85 | "Ready to install. Minor refinements optional." |
| ≥ 75 | "Acceptable quality. Refinement recommended before installation." |
| ≥ 60 | "Needs improvement. Refinement required." |
| < 60 | "Requires significant refinement before installation — consider regenerating." |

## Step 10 — Generate Validation Report

Fill in `./template.md` with all captured variables and write to:

```
{output_folder}/teams/{team-name}/VALIDATION_REPORT.md
```

The report contains:
1. Executive summary — score, rating, recommended action
2. Validation results — passed/total for each category
3. Critical issues (if any)
4. High-priority issues (if any)
5. Medium and low improvement opportunities
6. Fix suggestions (top 5–10, prioritized)
7. Strengths (what the team does well)
8. Next steps (install path or refinement path)

## Step 11 — Present Results to User

Show the user a concise summary:

```
Validation complete!

Quality Score: {quality_score}/100 ({quality_rating})

Agent Quality:    {agent_checks_passed}/{agent_checks_total} checks passed
Workflow Quality: {workflow_checks_passed}/{workflow_checks_total} checks passed
Team Coherence:   {team_checks_passed}/{team_checks_total} checks passed

{if critical_issues non-empty: "⚠️  {count} critical issue(s) found"}

{verdict line matched to the score band}

What would you like to do?
1. View full validation report
2. Install team now (if score sufficient)
3. Refine team to improve quality
4. Regenerate with adjusted requirements
```

**Option handling:**

- **View report** — display or open `VALIDATION_REPORT.md`, then return to the options.
- **Install** — only available if `quality_score >= 75` (or user override). Tell the user to run: `npx bmad-method install --custom-content "{team_path}" -y` — BMAD will register the team automatically. Remind them to configure `.mcp.json` memory path and restart Claude Code.
- **Refine** — hand off to `bmad-skill-refine-team`, passing the validation report and issues.
- **Regenerate** — return to discovery with a note about what should change.

## Special Cases

- **Perfect score (100%):** rare. Present: "Perfect score! This is an exceptionally high-quality team. Install immediately."
- **Very low score (< 50%):** recommend regeneration, not refinement. "This team has significant quality issues. Recommend regeneration with clearer requirements rather than iterative refinement."
- **Critical issues present even at acceptable overall score:** hard-block install. "Critical issues found that must be fixed before installation. These are non-negotiable. Please refine or regenerate."
- **All checks pass but low score:** investigate — likely a scoring calculation error. Default to "Good" rating and allow installation, but note the anomaly.

## Success Criteria

Validation succeeds when:

1. All checks executed without errors
2. Quality score calculated accurately and defensibly
3. Issues identified and categorized by severity
4. Every issue has a specific, actionable fix suggestion tied to a concrete file or agent
5. A clear recommendation is given to the user
6. The report is written to disk and accessible

---

**Validation Complete → User Decision → Install or Refine**
