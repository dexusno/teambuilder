# ITIL / Domain Expert Pattern Overview

## Pattern Purpose

This pattern creates large, governance-focused teams for specialized domains requiring formal processes, cross-functional coordination, and comprehensive documentation. Originally designed for ITIL practice management, it applies to any domain where expertise, compliance, and stakeholder coordination are critical.

## Problem This Pattern Solves

**Challenge:** Organizations need specialized teams to manage complex domains (ITIL practices, compliance, governance, specialized expertise areas) that:
- Span multiple organizational functions
- Require deep domain expertise
- Must maintain formal documentation and policies
- Need to coordinate with many stakeholders
- Have compliance or regulatory requirements

**Traditional Approach Falls Short:**
- Single "expert" agent lacks breadth
- Generic assistants don't understand domain nuances
- Small teams miss cross-functional perspectives
- Informal approaches inadequate for governance

**This Pattern's Solution:**
- Large team (10-12 agents) with role specialization
- Core practice team for governance
- Representatives from consuming practices (dual perspective)
- Formal collaboration with structured workflows
- Document-producing outputs (policies, procedures, agreements)

## Team Composition Rationale

### Why 10-12 Agents?

**Core Team (4 agents):**
- Practice Owner: Strategic leadership, policy, stakeholder management
- Manager: Operational coordination, day-to-day execution
- Analyst: Technical analysis, impact assessment, data
- Auditor: Quality assurance, compliance verification

**Specialist Representatives (5-7 agents):**
- Each represents a consuming practice or stakeholder group
- Dual mandate: Demand requirements FROM practice AND provide guidance TO practice
- Examples: Change Rep, Incident Rep, Security Rep, Asset Rep

**Liaison (1 agent):**
- Platform/Technical Liaison: Bridges practice and implementation

### Why Formal Collaboration?

Governance domains require:
- Documented decisions for audit trails
- Approval workflows for policy changes
- Stakeholder sign-off on agreements
- Compliance verification steps

Informal approaches lack necessary rigor.

### Why Representatives?

Representatives solve the "silos" problem:
- Understand BOTH their practice AND the domain practice
- Can articulate requirements clearly
- Provide informed feedback, not just demands
- Enable cross-practice coordination

## Key Innovations

### 1. Practice-as-Product Model (from IT4IT)

Treating organizational practice as product:
- **Product Owner:** Practice Owner
- **Customers:** Consuming practices (Change, Incident, etc.)
- **Deliverables:** Services the practice provides
- **Quality:** Measured by customer satisfaction and compliance

**Application Beyond ITIL:**
- Legal department as "product" serving business units
- Data governance as "product" serving data consumers
- Compliance function as "product" serving organization

### 2. Dual-Mandate Representatives

Representatives have TWO responsibilities:
1. **Demand:** Articulate their practice's requirements
2. **Advise:** Provide expert guidance back to their practice

Example: Change Representative
- Demands: "We need CI data with accuracy SLAs for impact assessment"
- Advises: "Here's how CM data should be used in change records"

**Why This Works:**
- Reduces friction between practices
- Ensures requirements are realistic
- Builds shared understanding
- Creates partnership, not supplier-customer dynamic

### 3. Strategic vs Operational Split

Large teams benefit from role separation:
- **Practice Owner:** Strategy, policy, stakeholder relationships, long-term vision
- **Manager:** Daily operations, coordination, execution, problem-solving

**Application:**
- Any domain with both strategic and tactical aspects
- Teams of 8+ agents
- Organizations with formal hierarchies

### 4. Platform Liaison Pattern

Governance teams often disconnect from technical implementation:
- Practice defines requirements
- Technical team implements
- Gap emerges due to different languages/perspectives

**Platform Liaison bridges this:**
- Understands both practice governance AND technical platforms
- Translates requirements to technical specifications
- Explains technical constraints in practice terms
- Prevents "requirements that can't be implemented"

## Example Use Cases

### 1. ITIL Configuration Management Practice
- **Context:** Large healthcare organization, 100,000+ CIs, patient safety dependencies
- **Team:** CM Owner, CM Manager, CM Analyst, CM Auditor + 7 practice reps + Platform Liaison
- **Deliverables:** CM Policy, Interface Agreements, RACI Matrix, Audit Reports
- **Success:** Improved practice maturity, reduced audit findings, clear cross-practice coordination

### 2. Legal Compliance Team (Financial Services)
- **Context:** Bank with SOX, GDPR, and financial regulations
- **Team:** Compliance Lead, Operations Manager, Legal Analyst, Audit Specialist + Reps (Finance, IT, HR, Sales, Risk) + Regulatory Liaison
- **Deliverables:** Compliance Policies, Training Materials, Audit Prep, Violation Response
- **Success:** Zero major findings in audit, proactive compliance culture

### 3. Data Governance Team (Enterprise)
- **Context:** Large corporation with data quality and privacy concerns
- **Team:** Data Governance Lead, DG Manager, Data Steward, Quality Auditor + Reps (Analytics, Engineering, Legal, Security) + Platform Architect
- **Deliverables:** Data Policies, Stewardship Framework, Quality Standards, Privacy Procedures
- **Success:** Improved data quality metrics, GDPR compliance, trusted analytics

### 4. Healthcare Patient Safety Team
- **Context:** Hospital system managing patient safety processes
- **Team:** Safety Officer, Program Manager, Clinical Analyst, Quality Auditor + Reps (ER, Surgery, ICU, Pharmacy, Radiology) + IT Liaison
- **Deliverables:** Safety Protocols, Incident Response Procedures, Root Cause Analysis Framework
- **Success:** Reduced adverse events, faster incident response, better reporting culture

### 5. Information Security Governance
- **Context:** Tech company with security compliance requirements
- **Team:** CISO, Security Manager, Security Architect, Compliance Auditor + Reps (Dev, Ops, Product, Legal, HR) + Security Tools Liaison
- **Deliverables:** Security Policies, Access Control Standards, Incident Response Plan, Compliance Reports
- **Success:** SOC 2 certification, reduced security incidents, developer-friendly security

## When to Use This Pattern

### Strong Fit Indicators:
✅ Domain requires specialized expertise (ITIL, legal, compliance, governance)
✅ Multiple stakeholder groups consume services from domain
✅ Formal documentation required (policies, procedures, agreements)
✅ Regulatory or compliance requirements
✅ Enterprise or large organization context
✅ Strategic AND operational aspects both important
✅ Cross-functional coordination essential

### Weak Fit Indicators:
❌ Simple tactical tasks
❌ Fast-paced agile work
❌ Small team or startup context
❌ Creative or exploratory projects
❌ Informal collaboration adequate
❌ No compliance requirements
❌ Single stakeholder or isolated domain

## Pattern Strengths

**Comprehensive Coverage:** Large team covers all bases - strategy, operations, quality, cross-functional
**Authentic Cross-Practice Understanding:** Representatives bring real perspectives
**Governance Rigor:** Formal processes appropriate for compliance domains
**Scalable:** Structure scales to complex organizational contexts
**Clear Accountability:** Roles well-defined, decision authority clear

## Pattern Limitations

**Size:** 10-12 agents may be overwhelming for simple use cases
**Formality:** Structured approach may feel heavy for agile contexts
**Complexity:** More agents = more coordination overhead
**Learning Curve:** Users need to understand role distinctions
**Overkill Risk:** Can be too much for straightforward tasks

## Adaptation Guidelines

### Making It Smaller (8-9 agents):
- Combine roles: Manager+Analyst, Owner+Auditor
- Reduce representatives to 4-5 key practices
- Keep dual-mandate pattern even with fewer reps

### Making It More Agile:
- Keep structure but change collaboration to "flexible"
- Reduce documentation requirements
- Faster decision cycles
- More informal touchpoints

### Adapting to Non-ITIL Domains:
- Keep structure: Core team + Representatives + Liaison
- Replace practice reps with domain-appropriate stakeholders
- Maintain dual-mandate principle (demand + advise)
- Adjust terminology to domain norms

## Success Metrics

This pattern succeeds when:
1. ✅ All stakeholder groups feel represented
2. ✅ Cross-functional coordination improves
3. ✅ Policy/documentation is clear and current
4. ✅ Compliance metrics improve (fewer findings)
5. ✅ Practice maturity increases
6. ✅ "Customers" (consuming groups) are satisfied
7. ✅ Strategic and operational balance maintained

## Learning Objectives for Generation

When studying this pattern, learn:

1. **How to structure large teams** (core + specialists + liaison)
2. **Dual-mandate representative model** (demand + advise)
3. **Formal collaboration patterns** (approval workflows, documentation)
4. **Role separation** (strategic vs operational vs quality)
5. **Cross-functional coordination** (how agents from different domains interact)
6. **Governance mindset** (compliance, policy, stakeholder management)

Then **apply these principles** to generate original teams for user's domain.

---

**Remember:** This pattern teaches structure and principles. Don't copy the CM team - create an original team using these learnings for user's specific domain.
