# ITIL / Domain Expert Pattern - Example Workflows

These workflows demonstrate formal, document-producing processes for governance domains.

## Example Workflow 1: CM Policy Framework Development

**Purpose:** Develop comprehensive CM policy covering scope, standards, roles, processes

**Steps:**

```markdown
Step 1: Policy Scope Definition
  Agent: CM Practice Owner
  Action: Define policy scope - what's in/out, what standards apply,
          which practices covered. Review organizational context,
          regulatory requirements, and practice maturity level.
  Output: policy-scope.md

Step 2: Stakeholder Requirements Gathering
  Agents: CM Practice Owner + All Representatives
  Action: Each representative articulates their practice's CM requirements.
          Change Rep: impact assessment needs
          Incident Rep: CI troubleshooting needs
          Security Rep: compliance and access control needs
          [etc for all representatives]
  Collaboration: Round-robin input gathering, document all requirements
  Output: stakeholder-requirements.md

Step 3: Policy Draft Creation
  Agents: CM Practice Owner + CM Manager + CM Analyst
  Action: CM Owner drafts policy structure and principles
          CM Manager adds operational procedures
          CM Analyst adds technical standards and data requirements
  Output: cm-policy-draft-v1.md

Step 4: Technical Feasibility Review
  Agent: Platform Liaison
  Action: Review policy requirements against platform capabilities.
          Identify implementation constraints, suggest alternatives
          for non-feasible requirements. Document technical approach.
  Output: technical-feasibility-assessment.md

Step 5: Policy Refinement
  Agents: CM Practice Owner + Platform Liaison
  Action: Revise policy based on technical assessment. Adjust requirements
          to be implementable while meeting governance needs.
  Output: cm-policy-draft-v2.md

Step 6: Compliance Verification
  Agent: CM Auditor
  Action: Review policy against compliance frameworks (ITIL, ISO, SOX, etc).
          Verify audit requirements met. Identify gaps or risks.
  Output: compliance-review.md

Step 7: Representative Review
  Agents: All Representatives
  Action: Each rep reviews policy from their practice perspective.
          Confirms requirements met. Raises concerns or gaps.
  Collaboration: Async review with consolidated feedback
  Output: representative-feedback.md

Step 8: Final Policy Approval
  Agent: CM Practice Owner
  Action: Incorporate feedback, finalize policy, obtain approval
          from governance board or leadership.
  Output: cm-policy-final.md (approved)

Step 9: Communication Plan
  Agents: CM Practice Owner + CM Manager
  Action: Develop communication and training plan for policy rollout.
  Output: policy-communication-plan.md
```

**Workflow Characteristics:**
- 9 steps - comprehensive process
- Multiple agents with clear assignments
- Formal review and approval
- Document outputs at each stage
- Compliance verification included
- Stakeholder involvement explicit

---

## Example Workflow 2: Practice Interface Agreement Creation

**Purpose:** Formalize service agreement between CM and consuming practice

**Steps:**

```markdown
Step 1: Interface Identification
  Agents: CM Manager + Specific Representative
  Action: Identify touchpoints between CM and consuming practice.
          What does consuming practice need from CM?
          What does CM need from consuming practice?
  Output: interface-touchpoints.md

Step 2: Service Definition
  Agents: CM Manager + CM Analyst + Representative
  Action: Define specific services CM provides to consuming practice:
          - CI data accuracy levels
          - Update timeliness
          - Query response times
          - Support model
  Output: service-definition.md

Step 3: Requirements Documentation
  Agent: Representative (from consuming practice perspective)
  Action: Document consuming practice requirements in detail.
          Scenarios, use cases, frequency, criticality.
  Output: practice-requirements.md

Step 4: Capability Assessment
  Agents: CM Manager + Platform Liaison
  Action: Assess CM capability to meet requirements. Identify gaps.
          Determine what's achievable now vs future.
  Output: capability-assessment.md

Step 5: SLA Negotiation
  Agents: CM Manager + Representative
  Action: Negotiate realistic SLAs based on capability and requirements.
          Balance practice needs with CM capacity.
  Collaboration: Iterative negotiation
  Output: proposed-slas.md

Step 6: RACI Definition
  Agents: CM Manager + Representative
  Action: Define Responsible, Accountable, Consulted, Informed
          for each interface point.
  Output: interface-raci.md

Step 7: Agreement Drafting
  Agent: CM Manager
  Action: Create formal interface agreement document incorporating
          services, SLAs, RACI, escalation paths.
  Output: interface-agreement-draft.md

Step 8: Review and Sign-off
  Agents: CM Practice Owner + Representative + Consuming Practice Owner
  Action: Review agreement, negotiate final points, obtain sign-off
          from both practice owners.
  Output: interface-agreement-final.md (signed)
```

**Workflow Characteristics:**
- Bilateral agreement between practices
- Representative central to process
- Negotiation and balance (not dictation)
- RACI formalization
- Sign-off from both sides
- Creates formal, documented agreement

---

## Key Workflow Design Principles

### 1. Formal Structure
- Clear steps with goals
- Review and approval stages
- Sign-off and documentation
- Audit trail creation

### 2. Agent Assignments
- Specific agents per step
- Multi-agent collaboration explicit
- Clear decision authority
- Representative involvement at right points

### 3. Document Outputs
- Every step produces artifact
- Version control (draft v1, v2, final)
- Approved versions marked
- Templates referenced

### 4. Stakeholder Coordination
- Multiple perspectives included
- Representatives gather input
- Approval from appropriate authority
- Communication plan for rollout

### 5. Compliance Integration
- Auditor reviews for compliance
- Verification steps included
- Standards and frameworks referenced
- Gap identification and remediation

---

## Workflow Patterns for Governance

### Pattern A: Policy/Standard Development
1. Scope → Requirements → Draft → Technical Review → Refinement → Compliance Check → Stakeholder Review → Approval → Communication

### Pattern B: Agreement/Interface Creation
1. Identify → Define → Assess → Negotiate → Document → Review → Sign-off

### Pattern C: Audit Preparation
1. Scope Audit → Gather Evidence → Gap Analysis → Remediation Plan → Verification → Audit Execution → Findings Response

### Pattern D: Improvement Initiative
1. Assessment → Gap Identification → Prioritization → Initiative Planning → Execution → Verification → Communication

---

## Application to Generation

When generating workflows for user's governance domain:

**Maintain formal structure:**
- Review/approval steps
- Document outputs
- Compliance verification
- Stakeholder sign-off

**Adapt to user's domain:**
- Use their governance frameworks
- Reference their stakeholders
- Apply their approval processes
- Match their formality level

**Keep it actionable:**
- Specific actions, not vague
- Clear agent assignments
- Concrete outputs
- Realistic step counts (5-10 steps)

---

**These workflows teach governance process patterns. Generate original workflows for user's domain following these principles.**
