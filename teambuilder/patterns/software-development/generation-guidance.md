# Software Development Pattern — Generation Guidance

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

> **Critical guidance: BMM exists. This pattern is for specialty teams only.**
>
> BMAD ships a first-party software-development module called **BMM** (BMad Method). It already provides `bmad-agent-pm`, `bmad-agent-architect`, `bmad-agent-dev`, `bmad-agent-qa`, `bmad-agent-sm` and a full sprint workflow. If the user's request can be met by that team, **tell them to install BMM** instead of generating anything:
>
> ```
> npx bmad-method install --modules bmm
> ```
>
> This pattern is for the case BMM does not cover: **specialty software teams** — security, reliability, performance, ML, platform, accessibility, database, mobile, etc.

## When to Apply This Pattern

Trigger this pattern when the user's discovery surface matches **all** of these:

- Domain is `technical-development` (or clearly software-adjacent)
- User mentions **at least one specialty** that BMM does not cover well: security, reliability, SRE, performance, ML, platform/infra, accessibility, databases, mobile platform depth
- User describes **specialty workflows or artifacts**: threat model, postmortem, SLO/error budget, perf investigation, model validation, WCAG audit, IaC drift, chaos testing
- User describes **operational concerns** beyond feature delivery: SLOs, CVE backlog, p95 latency, model drift, WCAG conformance, incident response

Do **not** apply this pattern when:

- User says "I need a team to build my app" → redirect to BMM
- User describes a standard Scrum team (PM / Dev / QA / SM / Architect) → redirect to BMM
- User doesn't know what specialties they need → do deeper discovery; the default should be BMM
- User's "technical" concerns are actually product concerns (prioritization, roadmapping) → BMM + Product module

## Team Composition — Specialty Roles Only

Pick **4–6** specialty roles that match the user's operational concerns. Do **not** include generic PM / Dev / QA / SM / Architect — those are BMM.

### Common Specialty Roles

- **Security Engineer** — AppSec, threat modeling, CVE triage, ship-gate authority on security grounds
- **Site Reliability Engineer (SRE)** — SLOs, error budgets, incident command, postmortems, chaos engineering
- **Performance Engineer** — profiling, tail latency, regression gates, capacity modeling
- **ML Engineer** — offline eval, model validation, drift, model cards, promotion authority
- **Platform Engineer** — k8s, IaC, developer platforms, golden paths, drift detection
- **Accessibility Specialist** — WCAG conformance, assistive-tech testing, release sign-off authority
- **Database Architect** — schema design, query plans, online migrations, replication
- **Mobile Lead** — iOS/Android depth, release trains, crash triage
- **Data Engineer** — pipeline reliability, data quality, SLA enforcement on datasets

### Selection Heuristics

| User's primary concern | Starting specialty set |
|---|---|
| "Our site keeps falling over" | SRE + Performance + Platform |
| "We just passed SOC-2 and need to keep it" | Security + SRE + Platform |
| "We're launching an ML product" | ML Engineer + Data Engineer + SRE + Platform |
| "Public sector launch, a11y mandatory" | Accessibility + Security + SRE |
| "Mobile app performance and crashes" | Mobile Lead + Performance + SRE |
| "Platform team for the rest of eng" | Platform + SRE + Security + DBA |

Adjust based on user's specific wording during discovery.

### Always Include

- **At least one specialist with ship-gate / promotion authority** — that's the core of the specialty-team collaboration model. Without authority, specialists are just consultants.
- **An incident-aware specialist** (SRE is the default; can be substituted by Security Engineer for a security-focused team) — specialty teams need someone who owns the reactive side of the work.

### Never Include

- Generic Product Manager (use BMM)
- Generic Software Developer (use BMM)
- Generic QA / Test Engineer (use BMM)
- Generic Scrum Master (use BMM)
- Generic Solutions Architect (use BMM)
- Any role the user's discovery doesn't explicitly justify

## Persona Guidelines

Each specialty persona must include all of the following, or it will feel generic:

1. **Specific background with a scar.** Years of experience alone is not enough. The persona needs a specific operational memory — a breach, an incident, a failed model, a regression they owned. This is what makes them feel weathered instead of textbook.
2. **Authentic specialty vocabulary.** Security → CVSS, EPSS, SBOM, STRIDE, blast radius. SRE → SLO, SLI, error budget, burn rate, toil, durable artifact. Performance → p95/p99, flame graph, regression budget, tail latency. ML → frozen holdout, fairness slice, shadow deploy, drift, model card. Accessibility → WCAG 2.2, success criterion number, AT test matrix, IAAP.
3. **Strong opinions that distinguish them from other specialists in the same category.** Not every Security Engineer rates exploitability above severity; not every SRE bans the phrase "root cause"; not every MLE refuses to promote without a frozen holdout. These opinions are what make personas feel like individuals.
4. **Authority explicitly stated.** What can this specialist unilaterally block or promote? Write it down in the `role` field of the manifest.
5. **Operational tone, not aspirational tone.** "We ensure system reliability" → bad. "I've run 47 postmortems and can tell you the root cause of every one" → good.

## Workflow Guidelines

Specialty workflows look different from sprint ceremonies. Apply this shape:

- **3–10 steps.** Specialty workflows are walkthroughs, not meeting agendas.
- **One lead specialist per workflow.** Others participate consultatively, but ownership is unambiguous.
- **End in a decision or a named artifact.** Ship-gate, promotion, action items with owners, regression guard, threat model, postmortem document, validation readout. Not "we discussed it."
- **Consultative steps are short.** A targeted input from another specialist, not a parallel investigation.
- **Artifacts go to specific output paths.** `{output_folder}/security/threat-models/`, `{output_folder}/reliability/postmortems/`, `{output_folder}/performance/investigations/`, `{output_folder}/ml/validations/`. Not a single dumping ground.

### Recommended Workflows (Pick 2–4)

- Security Audit & Threat Model
- Reliability Incident Postmortem
- Performance Profile & Optimize
- ML Model Validation Pipeline
- Accessibility Conformance Audit
- Platform Drift Detection & Remediation
- Database Migration Review
- Capacity Forecast & Planning

## File Shapes (v6)

Every user-facing specialty agent is a directory under `{output_folder}/teams/{team-name}/agents/bmad-agent-{role}/` containing:

- `SKILL.md` — frontmatter (`name`, `description`) plus markdown body: persona, on-activation steps, capabilities table, working rules, rules.
- `bmad-skill-manifest.yaml` — the 9-field manifest: `type: agent`, `name`, `displayName`, `title`, `icon`, `capabilities`, `role`, `identity`, `communicationStyle`, `principles`, `module: teams-{team-name}`.

Every team workflow is a directory under `{output_folder}/teams/{team-name}/skills/bmad-skill-{workflow-name}/` containing:

- `SKILL.md` — frontmatter (`name`, `description`, optional `argument-hint`) plus body that references `./workflow.md`.
- `workflow.md` — the step-by-step instructions with lead-agent assignments.
- `template.md` — only if the workflow produces a structured document following a strict template.

Installation is automatic via `npx bmad-method install --custom-content {path-to-team}`. **Do not edit BMAD's internal manifests manually.** The install command handles all registration, slash-command wiring, and skill directory population. Manual manifest editing is a v5-era anti-pattern that no longer applies.

## Critical Success Factors

- ✅ **All specialist roles, no generalists.** If a generated agent would fit on a BMM team, it belongs on BMM, not here.
- ✅ **Authentic specialty terminology** in every persona and workflow.
- ✅ **Ship-gate or promotion authority** for at least one specialist.
- ✅ **Specialty workflows end in named artifacts**, not meeting summaries.
- ✅ **Strong persona opinions** that distinguish specialists from their peers in the same category.
- ✅ **Cross-specialist consults are short** — targeted input, not shadow workflows.
- ✅ **BMM disambiguation is honored** — generated README makes it clear this team complements, not replaces, BMM.

## Anti-Patterns

- ❌ Generating a "Product Manager" or "Developer" from this pattern (use BMM)
- ❌ Personas that read like textbook definitions ("a Security Engineer is responsible for security")
- ❌ Workflows with no authority and no artifact (pure meeting agendas)
- ❌ Teams that duplicate BMM's roles under different names
- ❌ Specialists with no strong opinions — a real specialist always has opinions
- ❌ Manual `_bmad/teams/{name}` manifest edits (install handles this)

## Output

Generate:

- 4–6 specialty agents under `agents/bmad-agent-*/`
- 2–4 specialty workflow skills under `skills/bmad-skill-*/`
- A `TEAM_README.md` that **explicitly states this team complements BMM**, not replaces it, and recommends BMM for any standard dev team need

**Specialty depth. Swim-lane authority. Authentic vocabulary. Named artifacts. Complements BMM — does not replace it.**
