# TeamBuilder Three-Agent Collaborative System

## Overview

The TeamBuilder module now uses a **three-agent collaborative architecture** to generate high-quality AI teams efficiently.

## The Three Agents

### 1. Team Architect 🏛️
**File:** `_bmad/teambuilder/agents/team-architect.md`

**Role:** Discovery lead and structural designer

**Responsibilities:**
- Conducts discovery conversation with user
- Designs team structure (roles, size, collaboration model)
- Generates agents (in collaboration with Agent Improver)
- Creates workflows
- Presents results to user

**Key Innovation:** Works in **real-time** with Agent Improver during generation

### 2. Agent Improver ✨
**File:** `_bmad/teambuilder/agents/agent-improver.md`

**Role:** Persona quality specialist

**Responsibilities:**
- Provides real-time feedback during agent generation
- Ensures persona distinctness and specificity
- Prevents generic language before it's written
- Validates domain expertise authenticity
- Focuses on communication style differentiation

**Key Innovation:** Works **during** generation, not after (quality built in, not added later)

### 3. Quality Guardian 🛡️
**File:** `_bmad/teambuilder/agents/quality-guardian.md`

**Role:** Final quality validator

**Responsibilities:**
- Reviews finished team with critical eye
- Scores quality (0-100%) across multiple dimensions
- Identifies issues by severity (critical, high, medium, low)
- Provides specific, actionable recommendations
- Makes install/refine/regenerate recommendation

**Key Innovation:** Fresh perspective, honest scoring (no grade inflation)

## Collaboration Workflow

### Phase 1: Discovery (5-10 min)
**Lead:** Team Architect

- User conversation to understand needs
- Domain classification and context gathering
- Requirements document generation

### Phase 2: Paired Generation (5-8 min)
**Lead:** Team Architect
**Collaborator:** Agent Improver

**Real-time collaboration:**
```
Team Architect: Creates agent draft
    ↓
Agent Improver: Immediate feedback ("Too generic - add specific background")
    ↓
Team Architect: Incorporates feedback instantly
    ↓
Agent Improver: Confirms or requests refinement
    ↓
Move to next agent
```

**Efficiency:** 2-3 feedback loops per agent, quality built in during generation

### Phase 3: Critical Review (2-3 min)
**Lead:** Quality Guardian

- Comprehensive quality assessment
- Scoring across 30+ criteria
- Issue identification by severity
- Specific improvement recommendations
- Final recommendation (install/refine/regenerate)

### Phase 4: User Decision (2-3 min)
**Lead:** Team Architect + Quality Guardian

- Present team and quality assessment
- User chooses: Install (85%+) / Refine (75-84%) / Regenerate (<75%)
- Execute appropriate action

## Quality Scoring System

**0-100% score based on:**

### Agent Quality (40 points)
- Persona distinctness (10 pts)
- Background specificity (10 pts)
- Communication differentiation (10 pts)
- Domain expertise authenticity (10 pts)

### Workflow Quality (30 points)
- Practicality (10 pts)
- Clarity (10 pts)
- Completeness (10 pts)

### Team Coherence (30 points)
- Coverage (10 pts)
- No role overlap (10 pts)
- Appropriate composition (10 pts)

## Quality Thresholds

- **95-100%:** Exceptional - install immediately
- **85-94%:** Good - ready to use
- **75-84%:** Acceptable - refinement recommended
- **60-74%:** Needs work - refinement required
- **<60%:** Regenerate recommended

## Efficiency Principles

### What Makes This Efficient

✅ **Paired generation prevents issues early**
- Better than generating then finding issues later
- Real-time quality improvement

✅ **Single critical review sufficient**
- When generation is high-quality, one review is enough
- No back-and-forth before user sees results

✅ **Clear phase separation**
- No confusion about who does what when
- Clean handoffs between phases

✅ **User sees results once**
- Not shown intermediate drafts
- Presented with finished, validated team

### What We Avoid

❌ Generate → Review → Fix → Review → Fix (multiple cycles)
❌ Three separate sequential reviews
❌ Back-and-forth before user sees anything
❌ Over-analysis paralysis

## Key Files

### Agent Files
- `_bmad/teambuilder/agents/team-architect.md`
- `_bmad/teambuilder/agents/agent-improver.md`
- `_bmad/teambuilder/agents/quality-guardian.md`
- `_bmad/teambuilder/agents/teambuilder-guide.md` (updated to use new workflow)

### Workflow Files
- `_bmad/teambuilder/workflows/collaborative-generation/workflow.yaml`
- `_bmad/teambuilder/workflows/collaborative-generation/instructions.md`

### Manifest Registration
- Added to `_bmad/_config/agent-manifest.csv`
- Module already registered in `_bmad/_config/manifest.yaml`

## Usage

### For Users

**Via TeamBuilder Guide:**
```
/bmad:teambuilder:agents:teambuilder-guide
```
Select option 1: "Create a new AI agent team"

**Direct Access to Agents:**
```
/bmad:teambuilder:agents:team-architect
/bmad:teambuilder:agents:agent-improver
/bmad:teambuilder:agents:quality-guardian
```

**Party Mode Workflow:**
```
Use workflow: _bmad/teambuilder/workflows/collaborative-generation/workflow.yaml
```

### IMPORTANT: Restart Required

After adding these agents to manifests, users must **restart Claude Code** for the agents to be discoverable.

## Agent Personas Summary

### Team Architect
- **Background:** Former McKinsey organizational design consultant
- **Expertise:** Team topology, capability mapping, workflow design
- **Style:** Collaborative, inquisitive, structural thinker
- **Philosophy:** Structure follows function, clear roles prevent chaos

### Agent Improver
- **Background:** Former creative writing professor + Amazon Alexa persona designer
- **Expertise:** Character development, distinctive voice, authentic expertise markers
- **Style:** Direct, constructive, celebrates good work
- **Philosophy:** Specific beats generic, show don't tell, communication styles must differ

### Quality Guardian
- **Background:** Former VP QA at Stripe, Stanford PhD in HCI
- **Expertise:** Quality frameworks, AI evaluation methodologies
- **Style:** Analytical, direct, honest (no sugarcoating)
- **Philosophy:** Honest assessment over false praise, quality is measurable

## Success Criteria

A successful team generation means:

✅ Quality score 85% or higher
✅ All agents have distinct personas
✅ Workflows are practical
✅ User satisfied with team
✅ Team ready to use

## Advantages Over Single-Agent Approach

### Previous Approach
- Single agent + rule-based validation
- Generate → Validate → Show issues
- Mechanical checks, not contextual

### New Three-Agent Approach
- Paired generation + critical review
- Quality built in during generation
- Contextual validation, not just rules
- Higher first-attempt quality
- Fewer refinement iterations needed
- Fresh perspective from Quality Guardian

## Design Rationale

### Why Three Agents?

**Team Architect focuses on:**
- Structure (team composition, workflows)
- Coverage (all needs addressed)
- Collaboration model design

**Agent Improver focuses on:**
- Individual agent persona quality
- Preventing generic language
- Ensuring distinctness and authenticity

**Quality Guardian focuses on:**
- Team-level coherence
- Objective quality assessment
- Honest scoring and recommendations

**Clear separation of concerns** = Each agent excels in their domain

### Why Paired Generation?

**Traditional approach:**
1. Generate all agents
2. Review all agents
3. Find issues
4. Fix issues
5. Review again

**Problem:** Wasteful, multiple cycles

**Paired approach:**
1. Generate agent with real-time feedback
2. Quality built in immediately
3. Move to next agent
4. Single final review for coherence

**Benefit:** Efficient, higher quality on first attempt

### Why Quality Guardian as Separate Agent?

- **Fresh perspective:** Not invested in generation decisions
- **Objective scoring:** Honest assessment, no defense of choices
- **Critical eye:** Finds issues others might miss
- **User service:** Provides transparency on quality before installation

## Future Enhancements

Possible future improvements:

1. **Adaptive feedback:** Agent Improver learns user preferences over time
2. **Pattern learning:** System learns from highly-rated teams
3. **Domain specialization:** Additional agent for deep domain expertise in certain fields
4. **Automated refinement:** Quality Guardian suggests fixes, Team Architect applies automatically
5. **Multi-team orchestration:** Generate related teams that work together

## Version History

- **v1.0 (2026-01-25):** Initial three-agent collaborative architecture
  - Replaced single-agent + rule-based validation
  - Introduced paired generation approach
  - Added Quality Guardian for critical review
  - Updated TeamBuilder Guide to use new workflow

---

**Architecture designed and implemented by:** BMAD Master 🧙
**Date:** 2026-01-25
**Status:** Ready for testing

**Next Steps:**
1. Restart Claude Code to discover new agents
2. Test team generation workflow
3. Evaluate quality improvements
4. Gather user feedback
