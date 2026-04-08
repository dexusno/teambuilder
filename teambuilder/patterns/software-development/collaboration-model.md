# Software Development Pattern — Collaboration Model

> **v6 architecture** — examples below use BMAD v6.2.2 shape: `SKILL.md` + `bmad-skill-manifest.yaml` for agents, `SKILL.md` + `workflow.md` for skills.

> Reminder: for generic agile dev teams, install BMM (`npx bmad-method install --modules bmm`). This pattern's collaboration model assumes specialty roles, not a standard Scrum team.

## Style: Agile Cadence + Specialist Authority + Incident Interrupts

Specialty teams don't run pure Scrum. They run a hybrid:

- **Lightweight sprint cadence** for planned work (2-week iterations, minimal ceremony)
- **Specialist authority** inside each swim lane (security, reliability, perf, ML, a11y)
- **Incident-driven interrupts** that can reshape priorities within the sprint

## Ceremonies (Minimal, Purposeful)

**Daily async standup** — each specialist posts what they're working on and any blockers. No 15-minute meeting; specialists are usually paged into deep work and can't afford a sync interrupt every morning.

**Sprint planning (lightweight, 30 min)** — short. Each specialist presents their candidate work. Team identifies cross-cutting dependencies. No story-point haggling — specialists estimate their own work because nobody else has the context.

**Specialty reviews (on demand)** — threat-model review, incident review, perf review, accessibility review, model-validation review. These replace a generic "code review" ritual. Each specialist leads reviews in their domain.

**Weekly operational review** — SLO burn, open CVEs, perf regressions, flaky tests, model drift. Short dashboard walk-through led by whichever specialist owns each signal.

**Postmortem (after every significant incident)** — blameless, timeline-driven, action-items-with-owners. The SRE runs it, but the whole team attends.

## Decision Authority

This is the core of the model. Specialists have **authority in their swim lane**, not just an advisory voice.

| Decision | Authority |
|---|---|
| Ship / no-ship on security grounds | Security Engineer (hard block) |
| Error-budget freeze | SRE (hard block) |
| Perf regression gate | Performance Engineer (hard block) |
| Model eligible for promotion to prod | ML Engineer (hard block) |
| WCAG conformance sign-off | Accessibility Specialist (hard block) |
| Cross-cutting priorities | Team consensus |
| Sprint scope | Team consensus, specialist escalation if blocked |

"Hard block" means the specialist can unilaterally prevent a release or decision in their domain. This is intentional. Specialties exist because the team trusts one person's judgment on deep, narrow technical calls.

## Interrupt Model

Specialty teams get interrupted. A P1 incident, a zero-day CVE, a customer-reported WCAG failure — these arrive on their own schedule. The model allocates roughly:

- **60% planned sprint work**
- **25% on-call / incident response**
- **15% operational improvement** (SLO work, tech debt in the specialty domain)

Specialists swap between planned and reactive work. The sprint plan is aspirational, not a commitment.

## Handoffs and Cross-Team Work

Most specialty work touches other teams. The model for cross-team handoff:

1. **Specialist drafts** the change or finding in their domain (threat model, SLO review, perf report, a11y audit).
2. **Peer specialist reviews** — another specialist on the team sanity-checks before it goes out.
3. **Presented to the receiving team** — as a concrete artifact, not a meeting invite.
4. **Action items tracked** — with owners and due dates, not "let's circle back."

## How This Differs from BMM's Standard Dev Team

| Dimension | BMM standard dev team | This specialty pattern |
|---|---|---|
| Primary rhythm | Sprint ceremonies | Sprint + incident interrupts |
| Decision authority | PM (what) / Architect (how) | Specialist in their swim lane |
| Core artifact | Working software | Specialty artifact (threat model, postmortem, perf report, model card) |
| Review ritual | Code review | Specialty review (threat / perf / a11y / model) |
| Typical output | Feature delivery | Risk reduced, SLO held, regression closed, model validated |

If the user needs the left column, install BMM. If they need the right column, generate from this pattern.

**Specialty authority, lightweight ceremony, incident-aware, artifact-driven.**
