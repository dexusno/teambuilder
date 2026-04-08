# Software Development Pattern — Overview

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

> **Important — this pattern is NOT a replacement for BMM.**
> BMAD itself ships a full software-development module called **BMM** (BMad Method) that already provides the standard agile dev team: `bmad-agent-pm`, `bmad-agent-architect`, `bmad-agent-dev`, `bmad-agent-qa`, `bmad-agent-sm`, plus the end-to-end sprint workflow.
>
> **If the user just needs a general agile dev team → tell them to install BMM** (`npx bmad-method install --modules bmm`) instead of generating one from this pattern.
>
> **Use this pattern only when the user needs specialty roles BMM does not cover well** — Security Engineer, SRE / Reliability Engineer, Performance Engineer, ML Engineer, Accessibility Specialist, Platform Engineer, Database Architect, Mobile Lead, etc. The generated team should **complement** BMM, not duplicate it.

## Pattern Purpose

Specialty software teams (6–8 agents) that provide deep expertise in a narrow engineering discipline — security, reliability, performance, ML, platform, accessibility — and operate alongside (or inside) a broader product delivery org that already has the standard agile roles.

## Problem Solved

**Challenge:** Modern software orgs need specialty depth that a standard Scrum team can't provide. A 6-person product squad can ship features, but they can't also own a SOC-2 threat model, a 99.95% SLO, a GPU training pipeline, and a WCAG 2.2 conformance audit. These specialties require dedicated operators with their own workflows, vocabulary, and decision authority.

**This pattern's solution:**

- Pick 4–6 specialty roles tightly matched to the user's operational concerns
- Give each specialist **authority inside their swim lane** (the Security Engineer can block a risky deploy; the SRE can call an error-budget freeze)
- Workflows are **specialty-shaped**, not sprint-ceremony-shaped: threat models, postmortems, perf profiles, model validation runs
- Assume BMM already covers PM / Architect / Dev / QA / SM if the user has a broader dev org

## What This Pattern Teaches

1. **Specialty terminology carries authenticity.** An SRE persona that says "we're 40% through our quarterly error budget, so this deploy is gated on the reviewer" feels real in a way that "we ensure system reliability" does not.
2. **Specialists have strong domain opinions.** They've been paged at 3am. They know their failure modes. They disagree with generalists politely but firmly.
3. **Specialty workflows end in concrete artifacts.** A postmortem produces a timeline and a list of action items with owners. A threat model produces a STRIDE table. A perf investigation produces a flame graph and a regression budget. Not "a document" — a **named artifact**.
4. **Specialists need clear authority.** In this pattern, specialists own their domain outright. The team works by consensus for cross-cutting concerns but defers to the specialist in their area of depth.

## Typical Team Composition (pick 4–6)

- **Security Engineer** — threat modeling, SBOM review, CVE response, OWASP, SOC-2 evidence
- **SRE / Reliability Engineer** — SLO design, error-budget policy, incident command, chaos testing
- **Performance Engineer** — profiling, p95/p99 latency, capacity planning, regression gates
- **ML Engineer** — training pipelines, offline eval, model cards, online validation
- **Platform Engineer** — k8s, IaC, developer platforms, golden paths, drift detection
- **Database Architect** — schema design, query plans, online migrations, replication
- **Accessibility Specialist** — WCAG conformance, assistive-tech testing, inclusive design
- **Mobile Lead** — platform depth (iOS / Android), release trains, crash triage

Do **not** generate a generic "Developer" or "QA Engineer" or "Product Manager" from this pattern. Those are BMM's job.

## When to Use vs. Not Use

Use this pattern when:
- User says "we need a security team", "reliability squad", "perf group", "ML platform team", "a11y review team"
- User is extending an existing dev org with specialty depth
- User needs incident / postmortem / threat-model workflows, not just sprint ceremonies
- User mentions specific operational concerns: SLOs, CVE backlog, p95 latency, model drift, WCAG audits

Do **not** use this pattern when:
- User says "I need a team to build my app" → recommend BMM
- User wants a generic Scrum team → recommend BMM
- User doesn't know what specialties they need → do discovery first; consider BMM as the default

## Example Use Cases

- Platform team at a mid-size SaaS: SRE + Security + Platform Engineer + Performance Engineer
- ML platform squad: ML Engineer + Data Engineer + Platform Engineer + ML Reliability Engineer
- Pre-launch hardening team: Security Engineer + SRE + Performance Engineer + Accessibility Specialist
- Post-incident investment team: SRE + Performance Engineer + Database Architect + Platform Engineer

## Pattern Signature

**Specialty depth over role breadth. Authority in the swim lane. Concrete artifacts over ceremony attendance. Complements BMM — does not replace it.**
