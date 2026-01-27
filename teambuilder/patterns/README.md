# TeamBuilder Pattern Library

This directory contains reference patterns that teach the generation engine how to compose high-quality AI agent teams.

## ⚠️  CRITICAL: Patterns Are NOT Templates

**Patterns teach principles, they are NOT templates to copy.**

When the generation engine loads patterns, it:
1. **Studies** the examples to understand quality markers
2. **Learns** composition principles (role structure, persona variety, workflow design)
3. **Applies** these principles to create ORIGINAL teams tailored to user needs

The generation engine should NEVER:
- Copy pattern agents and rename them
- Fill in pattern templates with user's domain
- Generate agents that are >50% similar to pattern agents

## Pattern Structure

Each pattern contains 6 files:

### 1. metadata.yaml
- Pattern characteristics (team size, collaboration model, etc.)
- When to use this pattern
- Key learnings and composition principles

### 2. pattern-overview.md
- High-level description of pattern
- Problem it solves
- Team composition rationale
- Example use cases

### 3. example-agents.md
- 3-4 complete agent examples showing quality personas
- Demonstrates distinct communication styles
- Shows authentic domain expertise
- Illustrates memorable personalities

### 4. example-workflows.md
- 2-3 workflow examples showing actionable design
- Demonstrates specific steps with agent assignments
- Shows collaboration patterns
- Illustrates concrete outputs

### 5. collaboration-model.md
- How agents work together in this pattern
- Communication patterns
- Decision-making flow
- Handoff mechanisms

### 6. generation-guidance.md
- Explicit instructions for generation engine
- Quality markers to replicate
- Common pitfalls to avoid
- Composition principles to apply

## Available Patterns

### 1. ITIL / Domain Expert Pattern
**Directory:** `itil-domain-expert/`
**Type:** Large governance-focused team (12 agents)
**Best For:** ITIL practices, compliance, organizational governance, formal domains
**Key Learning:** Practice-as-Product model, dual-mandate representatives, formal collaboration

### 2. Software Development Pattern
**Directory:** `software-development/`
**Type:** Agile sprint-based team (6-8 agents)
**Best For:** Feature development, code projects, technical work
**Key Learning:** Scrum roles, sprint workflows, agile ceremonies, iterative delivery

### 3. Research / Intelligence Pattern
**Directory:** `research-intelligence/`
**Type:** Iterative search and synthesis team (6-8 agents)
**Best For:** Market research, competitive intelligence, academic research, investigation, data analysis, business intelligence
**Key Learning:** Query refinement, source evaluation, triangulation, synthesis, hypothesis-driven analysis

### 4. Planning / Strategy Pattern
**Directory:** `planning-strategy/`
**Type:** Consultative multi-perspective team (6-8 agents)
**Best For:** Strategic planning, business decisions, project design, stakeholder alignment
**Key Learning:** Multiple perspectives, risk analysis, consultative approach, decision support

### 5. Creative / Content Pattern
**Directory:** `creative-content/`
**Type:** Creative process team (6-7 agents)
**Best For:** Content creation, marketing, creative projects, brand work
**Key Learning:** Creative stages (ideation → creation → review → optimization), brand voice, audience focus

### 6. Operations / Process Excellence Pattern
**Directory:** `operations-process/`
**Type:** Structured improvement team (5-7 agents)
**Best For:** Process improvement, operational efficiency, continuous improvement, quality management, Lean/Six Sigma, Kaizen
**Key Learning:** DMAIC methodology, value stream mapping, root cause analysis, data-driven decisions, control for sustainability

## Using Patterns

### For Generation Engine

When generating a team:

1. **Classify User Domain**
   - Determine primary domain from discovery
   - Load corresponding primary pattern
   - Load 1-2 secondary patterns for diversity

2. **Study Patterns**
   - Read all 6 files for each loaded pattern
   - Extract composition principles
   - Note quality markers (what makes agents/workflows high quality)
   - Understand team structure rationale

3. **Learn, Don't Copy**
   - Understand WHY pattern agents are distinct
   - Learn HOW workflows are actionable
   - Study WHAT makes personas memorable
   - Apply PRINCIPLES to user's specific context

4. **Generate Original Team**
   - Create fresh agents inspired by principles
   - Use user's domain terminology (not pattern's)
   - Address user's specific concerns (not pattern's)
   - Match user's collaboration preference

5. **Validate Against Patterns**
   - Ensure generated team matches quality level of patterns
   - Confirm agents are distinct (not copies)
   - Verify workflows are equally actionable
   - Check domain expertise is authentic

### For Pattern Contributors

When adding new patterns:

**Criteria for New Patterns:**
- Represents significantly different domain or collaboration model
- Cannot be easily generated from existing patterns
- Teaches new composition principles
- Provides clear quality examples

**Pattern Development Process:**
1. Identify need (domain not well covered by existing patterns)
2. Design team structure (roles, size, collaboration)
3. Create 3-4 exemplar agents (show range of quality)
4. Design 2-3 exemplar workflows (show actionability)
5. Document collaboration model
6. Write clear generation guidance
7. Test: Can generation engine learn from this pattern?

**Quality Standards:**
- Agents must be memorable and distinct
- Workflows must be specific and actionable
- Domain expertise must be authentic
- Documentation must be clear
- Examples must teach principles, not serve as templates

## Pattern Quality Markers

### Agent Quality Markers

✅ **Specific background** - Not "experienced professional"
✅ **Distinctive communication** - Not generic "professional and clear"
✅ **Strong principles** - Not platitudes
✅ **Domain terminology** - Uses field-specific language
✅ **Memorable personality** - Has specific traits or patterns
✅ **Clear role** - No overlap with other agents

### Workflow Quality Markers

✅ **Specific steps** - Not "gather information" but "interview about X, Y, Z"
✅ **Clear agent assignments** - Who does what
✅ **Concrete outputs** - Named documents or artifacts
✅ **Logical flow** - Steps build on each other
✅ **Actionable** - Steps can actually be executed
✅ **Collaboration patterns** - How agents interact is clear

### Team Quality Markers

✅ **Clear structure** - Coordinator + experts + specialists + support
✅ **Complete coverage** - Analysis, execution, quality/review roles
✅ **Appropriate size** - Matches complexity and scope
✅ **Coherent collaboration** - Interaction patterns make sense
✅ **Domain appropriate** - Team design fits domain norms

## Anti-Patterns (What to Avoid)

### In Pattern Creation

❌ **Generic agents** - "Professional manager who coordinates tasks"
❌ **Vague workflows** - "Step 1: Do research, Step 2: Analyze, Step 3: Decide"
❌ **Template structure** - Agents with [FILL_IN_NAME] placeholders
❌ **Shallow domain expertise** - Surface-level terminology without understanding
❌ **All agents sound same** - Every agent "professional and collaborative"

### In Pattern Usage (Generation)

❌ **Pattern copying** - "User wants research team, I'll use pattern's Research Strategist with new name"
❌ **Domain swapping** - "Just replace ITIL with Healthcare in pattern agents"
❌ **Template filling** - "Fill in pattern template with user's domain"
❌ **Ignoring user context** - "Pattern has 12 agents, so generated team must have 12"
❌ **Missing user concerns** - "Pattern doesn't have risk agent, so generated team won't either"

## Pattern Maintenance

### When to Update Patterns

- Consistent validation failures in certain domains
- New best practices emerge
- User feedback reveals gaps
- Quality markers evolve

### When to Add New Patterns

- New domain type not covered (legal, medical, financial)
- New collaboration model (adversarial, rotational, hierarchical)
- New workflow style (audit-based, experimental, compliance-driven)
- Existing patterns inadequate for recurring domain

### When NOT to Add Patterns

- Minor variation of existing pattern
- Too specialized (single use case)
- Can be easily generated from existing patterns
- Not enough differentiation from current patterns

## Pattern Evolution

**Current Version:** 3.0 (6 patterns)

**Future Enhancements:**
- Additional domain patterns (legal, medical, financial)
- Advanced collaboration models (distributed, asynchronous)
- Specialized workflow patterns (compliance, audit)
- Pattern combinations (hybrid patterns)

**Feedback:**
If generated teams consistently struggle with certain domains or if new patterns would improve generation quality, create GitHub issue with:
- Domain or use case not well served
- Example of what's needed
- Why existing patterns insufficient

---

## Quick Reference

| Pattern | Team Size | Collaboration | Best For | Key Learning |
|---------|-----------|---------------|----------|--------------|
| ITIL/Domain Expert | 12 | Formal | Governance, compliance | Dual-mandate reps, formal processes |
| Software Development | 6-8 | Agile | Dev projects, code | Sprint workflows, scrum roles |
| Research/Intelligence | 6-8 | Iterative | Research, analysis, data/BI | Source evaluation, synthesis |
| Planning/Strategy | 6-8 | Consultative | Planning, decisions | Multi-perspective, risk analysis |
| Creative/Content | 6-7 | Creative Process | Content, creative work | Brand voice, creative stages |
| Operations/Process | 5-7 | Structured Improvement | Process improvement, Lean/Six Sigma | DMAIC, root cause, sustainability |

---

**Remember:** Patterns are learning tools, not copying tools. The goal is to generate teams as high quality as these patterns, not to replicate these patterns.

_Pattern Library v3.0 - 6 diverse patterns teaching composition principles_
