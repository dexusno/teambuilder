# ITIL / Domain Expert Pattern - Collaboration Model

## Collaboration Style: Formal with Structured Touchpoints

This pattern uses formal collaboration appropriate for governance contexts requiring documentation, approval workflows, and stakeholder coordination.

## Team Structure

```
                    CM Practice Owner
                    (Strategic Lead)
                           |
        ┌──────────────────┼──────────────────┐
        |                  |                   |
   CM Manager         CM Analyst          CM Auditor
  (Operations)       (Analysis)           (Quality)
        |                  |                   |
        └──────────────────┴───────────────────┘
                           |
        ┌──────────────────┼──────────────────┐
        |                                      |
Representatives (7)                    Platform Liaison
- Change Rep                           (Technical Bridge)
- Incident Rep
- Problem Rep
- Asset Rep
- Service Catalogue Rep
- Release Rep
- Security Rep
```

## Primary Interaction Patterns

### 1. Strategic Direction (Practice Owner-Led)
**When:** Policy development, stakeholder management, practice planning
**Participants:** Practice Owner + relevant subset
**Pattern:** Owner convenes, frames decision, gathers input, decides
**Cadence:** Monthly or as-needed

### 2. Operational Coordination (Manager-Led)
**When:** Day-to-day execution, issue resolution, tactical decisions
**Participants:** Manager + Analyst + relevant reps + Platform Liaison
**Pattern:** Manager coordinates, agents execute, report progress
**Cadence:** Weekly or daily as needed

### 3. Representative Touchpoints (Bilateral)
**When:** Interface management, requirements gathering, feedback
**Participants:** Specific Rep + CM Manager/Analyst + Platform Liaison
**Pattern:** Rep brings practice perspective, CM team responds, liaison provides technical view
**Cadence:** Bi-weekly per practice

### 4. Quality Reviews (Auditor-Led)
**When:** Compliance verification, audit prep, quality assessment
**Participants:** Auditor + relevant agents
**Pattern:** Auditor requests evidence, reviews, provides findings
**Cadence:** Quarterly formal, ad-hoc as needed

### 5. Technical Alignment (Liaison-Led)
**When:** Requirements translation, technical feasibility, implementation planning
**Participants:** Platform Liaison + CM Analyst + relevant reps
**Pattern:** Liaison translates requirements to technical specs, identifies constraints
**Cadence:** As-needed for initiatives

## Communication Flows

### Demand Flow (Requirements Coming In)
```
Consuming Practice → Representative → CM Manager/Analyst → Technical Assessment (Liaison) → Feasibility Response
```

Example: Change needs faster CI data updates
1. Change Manager tells Change Rep
2. Change Rep brings requirement to CM Manager
3. CM Manager + Analyst assess current capability
4. Platform Liaison evaluates technical options
5. CM Manager responds to Change Rep with proposal

### Guidance Flow (Expertise Going Out)
```
CM Team → Representative → Consuming Practice
```

Example: Best practices for using CI relationship data
1. CM Analyst creates guidance document
2. Change Rep reviews from Change perspective
3. Change Rep delivers guidance to Change team
4. Change Rep reports adoption/issues back to CM

### Decision Flow (Strategic)
```
Issue/Opportunity → Practice Owner → Stakeholder Input → Platform Liaison (technical) + Auditor (compliance) → Practice Owner Decision → Communication
```

### Escalation Flow
```
Rep or Agent → CM Manager → (if unresolved) → CM Practice Owner → (if needed) → Senior Leadership
```

## Collaboration Mechanisms

### Formal Touchpoints
- **Practice Review:** Monthly, Practice Owner + Manager + Auditor, review metrics and strategic initiatives
- **Representative Sync:** Bi-weekly, each Rep + CM Manager, interface health check
- **Quality Audit:** Quarterly, Auditor-led, compliance and quality verification
- **Platform Alignment:** Monthly, Platform Liaison + CM Analyst, technical roadmap sync

### Informal Collaboration
- **Daily questions:** Agents help each other as needed
- **Ad-hoc consults:** Platform Liaison available for technical questions
- **Quick clarifications:** Reps can reach out to CM team anytime

### Document-Based Collaboration
- **Policy drafts:** Circulated for async review and feedback
- **Requirements docs:** Representatives provide written input
- **Audit reports:** Formal written findings and remediation plans
- **Interface agreements:** Bilateral documents with sign-off

## Decision-Making Authority

**Strategic Decisions:**
- Practice Owner has final authority
- Input from Manager, Auditor, key Representatives
- Formal governance board approval for major policy

**Operational Decisions:**
- CM Manager has authority within established policy
- Can make day-to-day operational calls
- Escalates policy-impacting decisions to Owner

**Technical Decisions:**
- Platform Liaison advises on technical approach
- CM Analyst provides technical recommendations
- Final approval by Manager or Owner depending on scope

**Quality Standards:**
- Auditor sets quality/compliance requirements
- Practice Owner can override with documented rationale
- External compliance frameworks are non-negotiable

## Cross-Practice Coordination

### Representative Dual Mandate
Representatives actively work in both directions:

**Inbound (to CM):**
- Bring practice requirements
- Explain use cases and scenarios
- Prioritize needs
- Escalate issues

**Outbound (from CM):**
- Deliver CM guidance and standards
- Explain CM capabilities and constraints
- Train practice on CM data usage
- Gather feedback on CM services

### Multi-Practice Initiatives
When multiple practices involved:
1. CM Practice Owner convenes relevant Representatives
2. Each Rep presents their practice perspective
3. CM team (Manager + Analyst + Liaison) proposes solution
4. Representatives negotiate trade-offs
5. Consensus or Practice Owner decision
6. Reps communicate back to their practices

## Conflict Resolution

**Rep-to-Rep Conflicts:**
- CM Manager facilitates
- Focus on practice needs, not politics
- Platform Liaison provides technical reality check
- Practice Owner decides if no consensus

**Practice-to-Practice:**
- Representatives bring to CM Manager
- Manager escalates to Practice Owner
- Owner may involve senior leadership
- Documented resolution with rationale

**Technical Feasibility Disputes:**
- Platform Liaison provides options with trade-offs
- CM Analyst validates technical assessment
- Practice Owner makes business decision
- Document constraints and decisions

## Success Patterns

This collaboration model succeeds when:
1. ✅ Representatives actively work both directions (not just demand)
2. ✅ Platform Liaison prevents requirements-implementation gap
3. ✅ Practice Owner handles strategy, Manager handles operations
4. ✅ Auditor ensures quality without blocking progress
5. ✅ Formal touchpoints happen consistently
6. ✅ Informal collaboration fills gaps
7. ✅ Decisions are documented with rationale

## Adaptation Guidelines

**For Smaller Teams (8-9 agents):**
- Combine touchpoints (rep syncs monthly instead of bi-weekly)
- Owner may handle some Manager duties
- Fewer formal meetings, more informal coordination

**For More Agile Contexts:**
- Keep structure but reduce formality
- Shorter approval cycles
- More async collaboration
- Faster decision-making

**For Non-ITIL Domains:**
- Keep structural pattern (core + reps + liaison)
- Adapt touchpoints to domain norms
- Maintain dual-mandate principle for reps
- Adjust formality to organizational culture

---

**This collaboration model teaches formal governance coordination. Apply structure to user's domain with appropriate formality level.**
