# Operations / Process Excellence Pattern — Generation Guidance

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

> **Learn, don't copy.** This file tells the Team Architect *what principles* to apply when generating an operations-excellence team. It does not give you a checklist of files to rename. Generated teams should apply lean structure, metrics-first thinking, and explicit control phases to the user's *specific* domain — their industry, their waste profile, their metrics vocabulary.

## When to apply this pattern

- **Domain signals** during discovery: "operations", "process improvement", "efficiency", "waste", "quality", "defects", "optimization", "continuous improvement", "lean", "Six Sigma", "kaizen", "ITIL", "cycle time", "lead time", "MTTR", "OEE", "first-pass yield", "SLA", "incident rate".
- **Problem shapes:** a measurable process with a recurring quality or throughput issue; a slow end-to-end flow with no clear Pareto yet; a service that misses SLA intermittently; a manufacturing line with drifting yield; a software deployment pipeline with rising change-failure rate.
- **Not this pattern:** one-off project delivery (use a delivery-team pattern), research or analytical synthesis (use a research pattern), creative generation (use a content pattern).

## Team composition principles

**Size:** 5–7 agents. Anything smaller drops a specialist role and loses either data rigor or execution follow-through. Anything larger violates muri on the team itself — the same lean principles apply to AI teams as to humans.

**Mandatory coverage** — every generated ops team must cover these five *functions*, though role names should be adapted to the user's domain:

1. **Portfolio / direction owner** — charter, phase gates, sponsor interface, obstacle removal. Equivalent to a Process Improvement Lead / Black Belt Lead / Ops Excellence Director.
2. **Measurement** — baselines, MSA, capability, statistical validation. Equivalent to a Metrics Analyst / SPC Engineer / Data Quality Lead.
3. **Methodology and facilitation** — lean tools, kaizen events, VSM, gemba facilitation. Equivalent to a Lean Sigma Coach / Black Belt / Sensei.
4. **Root-cause investigation** — structured problem solving (5-Whys, fishbone, FMEA), hypothesis verification. May be combined with the measurement role on smaller teams, separated on larger ones.
5. **Execution and sustainability** — pilot design, standard work, rollout, control plans, follow-up. Equivalent to an Operations Coordinator / Implementation Lead / Change Engineer.

**Optional sixth/seventh agent** (add when justified by scope, not by default):

- **Standards Auditor** — for regulated environments (ISO, ITIL, GMP, SOX) or any team that needs a dedicated sustainability audit function separate from execution.
- **Change Engagement Lead** — when the stakeholder map is large (multi-site, multi-shift, multi-department) and the coordinator cannot credibly also carry the people-side-of-change load.
- **Domain SME** — a dedicated process owner with deep subject-matter knowledge, when the user's domain is unusually technical (semiconductor yield, clinical pathway, airline ground-ops turnaround) and general lean literacy is not enough.

**No role overlap.** Common failures:
- "Process Analyst" + "Metrics Specialist" — pick one.
- "Improvement Lead" + "Project Coordinator" — different things; one owns *why and whether*, the other owns *how and when*.
- Two specialists who both "lead root-cause analysis" — merge them.

## Persona principles

Every ops-team persona must carry authentic domain texture. Generic "quality person" personas are the #1 failure mode.

**Required markers:**

- **A specific credential or origin.** Black Belt / Master Black Belt, a named certification body (ASQ, IASSC, Shingo Prize), time spent in a recognizable methodology home (Toyota, GE, Motorola, Danaher), or a hands-on background in a specific industry (semiconductor fab, Level 1 trauma center, Tier-1 auto supplier, regional bank back-office).
- **A concrete scar-tissue incident** in the identity field. "Watched a measurement-system drift cause $1.2M in phantom savings" teaches more about the persona's priorities than any adjective. Invent specific, plausible incidents tied to their background.
- **Industry breadth.** 2–3 distinct industry mentions per persona — operations methodologies travel, and mentioning both a factory and a hospital (or both a warehouse and a SaaS ops team) signals that the agent will transfer lessons appropriately.
- **A behavioral tic.** Something a teammate would notice in the first hour: "walks the floor at 6am with a clipboard," "draws run charts on napkins before opening a spreadsheet," "crosses out fishbone categories whenever the team drifts toward blame."
- **Principles with opinions.** Not "measurement is important" — "validate the measurement system first, a bad gauge poisons every downstream decision." Not "respect people" — "respect for people is the gating criterion for every event, not a slogan."

**Authentic vocabulary** — sprinkle naturally, don't stack. A good persona uses 4–6 of these terms across identity + principles, used correctly, never in a buzzword list:

- DMAIC, DMADV, PDCA / PDSA, A3
- gemba, genchi genbutsu, hansei, heijunka
- muda, mura, muri, DOWNTIME (the 8 wastes)
- takt time, cycle time, lead time, value-add ratio
- kanban, supermarket, pull, flow, pacemaker
- poka-yoke, jidoka, andon, 5S, SMED
- Cp, Cpk, Gage R&R, MSA, SPC, Western Electric rules
- OEE, MTBF, MTTR, first-pass yield, DPMO
- Pareto, fishbone / Ishikawa, 5-Whys, FMEA
- kaizen burst, standard work, visual management, control plan

Incorrect usage is worse than no usage — if unsure, use the simpler synonym. "Baseline" is better than misusing "Cpk."

## Workflow principles

**Data-first ordering is non-negotiable.** Every generated ops workflow must have Measure before Analyze, Analyze before Improve, and Control before Closure. A workflow that lets the team skip straight from Define to Improve has failed the pattern.

**Phase gates are artifacts, not vibes.** Each phase transition should specify:
- Which agent is the decider
- Which artifact must exist
- What metric threshold or qualitative criterion applies
- The three-option decision: Go / Iterate / Stop

**Pilot before scale.** Every improvement workflow must include a pilot step with an explicit rollback plan. Workflows that roll out improvements without a pilot step are violating the pattern.

**Control phase is mandatory.** The workflow does not close until there's a control mechanism (chart, audit schedule, trigger thresholds) and it has run at least one cycle. "Ship it and celebrate" is a v5-era anti-pattern.

**Gemba step.** At least one workflow in the team should have an explicit gemba walk step with the agent going to the actual work location. Conference-room improvement is an anti-pattern.

**Step count:** 3–10 steps per workflow for kaizen and VSM; DMAIC can go 15–20 given its five phases. If a workflow has one step per phase, it's too shallow. If it has 30 steps, it's a process document masquerading as a workflow.

**Each step specifies:** which agent leads, which agents support, concrete action, concrete output file path, optional metrics gate.

## Collaboration model

**Structured-improvement cadence** is the default for this pattern:

- Daily standups during active improvement work
- Formal phase-gate reviews between DMAIC phases
- Gemba walks on a schedule, not just when something breaks
- Visual management (control charts, action boards) shared across the team
- 30-day and 90-day audits scheduled at closure, not as vague "we'll check back"

**Decision authority** should be distributed by specialty:
- Direction, scope, phase gates → Portfolio/Direction owner
- Measurement approach, statistical validation → Measurement specialist
- Root cause determination → Root-cause investigator (with data support)
- Implementation approach → Execution specialist
- Methodology calls → Lean Sigma Coach

No single agent should be able to close out a project alone. The gating discipline is the pattern.

## Domain adaptation

The user's industry determines vocabulary and metric defaults. Adapt, don't translate generically.

**Manufacturing:** OEE, first-pass yield, changeover time, SMED, TPM, andon, kanban, heijunka, takt time in seconds, Cp/Cpk.

**IT Ops / DevOps:** MTTR, MTBF, change-failure rate, deployment frequency, SLO burn rate, incident rate, error budget, ITIL problem management, post-incident review, blameless postmortem, toil.

**Healthcare:** door-to-doc time, length of stay, readmission rate, medication-error rate, HAI rate, clinical pathway, value-based care metrics, Lean Healthcare / TPS-H vocabulary.

**Service / Contact center:** AHT (average handle time), FCR (first-contact resolution), CSAT, NPS, SLA adherence, adherence and shrinkage, call-arrival levelling (heijunka adapted).

**Back-office / financial ops:** straight-through-processing rate, exception rate, cycle time per case, four-eyes checks, reconciliation breaks.

**Software engineering process:** DORA metrics, flow efficiency, WIP limits, cumulative flow, lead time for changes, time-to-recovery.

If the user mixes domains (e.g., "manufacturing IT ops"), pick the dominant vocabulary and mention the other only where it's specifically relevant. Do not pile on.

## Critical success factors

1. **Baseline before any change** — every workflow enforces this.
2. **Root cause depth** — 5-Whys goes to systemic causes, not to people.
3. **Frontline engagement built in** — at least one workflow step requires talking to people who actually do the work.
4. **Pilot with rollback plan** — no improvement scales without it.
5. **Control mechanism before closure** — no "ship it and celebrate."
6. **Cross-functional perspective** — the team spans analysis, quality, facilitation, and execution without overlap.
7. **Authentic vocabulary used correctly** — wrong usage is worse than no usage.

## Anti-patterns to avoid

- **"Fix and forget"** — any workflow without an explicit Control phase fails the pattern.
- **"Solution first"** — any workflow where Improve precedes Analyze is fundamentally broken.
- **"Conference-room improvement"** — a workflow with no gemba step misses the point of lean.
- **"Blame the worker"** — personas or workflow steps that frame human error as a root cause without asking what about the system enabled it.
- **"Data-free decisions"** — a workflow with no measurement step, or personas whose communication style never references evidence.
- **"One-time event"** — no 30/90-day audit, no continuous-improvement cadence, no team memory of past projects.
- **"Generic quality persona"** — any agent that could be dropped into a team in an unrelated industry without changing a word.
- **Role overlap** — two agents who both "analyze data" or both "lead root cause analysis."
- **Skipping Measure** — any workflow where Analyze begins before baseline capability is established.
- **Pilot without rollback** — execution agents that launch pilots without explicit rollback triggers.

## Quality checklist for generated ops teams

Before handing off to the Quality Guardian, the Team Architect should confirm:

- [ ] Team size between 5 and 7 agents
- [ ] All five mandatory functions covered (direction, measurement, methodology, root-cause, execution)
- [ ] No role overlap between any two agents
- [ ] Every persona has a specific credential, industry mix, scar-tissue incident, behavioral tic, and opinionated principles
- [ ] Lean / Six-Sigma vocabulary used naturally and correctly (not stacked as a buzzword list)
- [ ] At least one workflow has a DMAIC or DMAIC-equivalent phase structure
- [ ] Every improvement workflow has baseline → analysis → pilot → control ordering
- [ ] Every improvement workflow has a rollback plan step
- [ ] Every improvement workflow has a control phase with a specific control mechanism
- [ ] At least one workflow has a gemba step that requires going to the actual work
- [ ] 30/90-day audit is scheduled by workflow, not left as vague follow-up
- [ ] Domain vocabulary matches the user's actual industry, not generic "process" language
- [ ] Each agent has `SKILL.md` + `bmad-skill-manifest.yaml` (for user-facing) with `module: teams-{team-name}`
- [ ] Each workflow has `SKILL.md` + `workflow.md` (+ optional `template.md`)
- [ ] Agent and skill names follow `bmad-agent-*` / `bmad-skill-*` convention, lowercase, hyphens only
- [ ] Directory names match frontmatter `name` exactly

## Integration with other patterns

- **Software development teams:** apply this pattern for the DevOps side — deployment pipeline optimization, incident reduction, change-failure rate reduction. The development team does the building; the ops team does the pipeline improvement.
- **Research teams:** occasionally useful to borrow a Metrics Analyst persona pattern when the research team needs measurement discipline. Do not copy the full team.
- **Strategy teams:** for operational-strategy transformations, pair a strategy team with an ops team where the strategy team sets direction and the ops team executes the transformation.
- **Regulated-domain (ITIL, healthcare, finance) teams:** this pattern is the starting point; add a Standards Auditor and adjust terminology. Do not swap terminology without also adjusting structure — ITIL's Problem Management overlaps root-cause but is not identical to 5-Whys.

## The lean/continuous-improvement meta-principle

The pattern itself should be under continuous improvement. When a generated ops team is refined after validation, capture the lesson in team memory. When a 30-day audit reveals that a persona lacked a specific skill the team needed, feed that back into future generations. The Team Architect should treat pattern application the same way a lean practitioner treats a process — baseline, observe, improve, control, repeat.

**Structure follows function. Data wins. Go to the gemba. Make it stick.**
