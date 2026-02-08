# Collaborative Team Generation - Workflow Instructions

## Overview

This workflow orchestrates **three specialized agents** to generate high-quality AI teams efficiently:

1. **Team Architect** - Discovery lead, structural designer
2. **Agent Improver** - Persona quality specialist (works in real-time during generation)
3. **Quality Guardian** - Final quality validator (critical review)

## Key Innovation: Paired Generation

Instead of sequential passes (generate → review → fix → review), we use **paired generation**:

- Team Architect and Agent Improver work **simultaneously** during generation
- Quality is built in, not added later
- Results in fewer iterations and higher first-attempt quality

## Workflow Phases

### Phase 1: Discovery (5-10 minutes)

**Lead:** Team Architect
**Participants:** Team Architect only

**What Happens:**
- Team Architect conducts discovery conversation with user
- Asks targeted questions about needs, domain, scope, challenges, preferences
- Questions adapt based on domain type
- Generates requirements document

**Outputs:**
- `docs/team-requirements/{team-name}-requirements.md`

**Key Points:**
- Agent Improver and Quality Guardian do NOT participate
- Focus on understanding user needs deeply
- Requirements document guides entire generation

---

### Phase 2: Paired Generation (5-8 minutes)

**Lead:** Team Architect
**Participants:** Team Architect + Agent Improver (paired)

**What Happens:**

#### Step 1: Design Structure (Team Architect solo)
- Determines team size
- Defines agent roles
- Chooses collaboration model
- Plans workflow structure

#### Step 2: Paired Agent Generation (BOTH agents)

**Real-Time Collaboration:**

```
For each agent:

Team Architect: Creates initial draft (role, identity, communication, principles)
    ↓
Agent Improver: Immediate feedback ("Too generic - add specific background")
    ↓
Team Architect: Incorporates feedback (adds details, specificity)
    ↓
Agent Improver: Confirms improvement or requests refinement
    ↓
Move to next agent
```

**Efficiency Keys:**
- Quick feedback loops (2-3 exchanges per agent)
- Specific, actionable suggestions
- No lengthy discussions
- Quality built in during generation

#### Step 3: Generate Workflows (Team Architect solo)
- Creates team workflows
- Clear steps, agent assignments, outputs
- Agent Improver observes but doesn't critique (not their domain)

#### Step 4: Create Team Config (Team Architect solo)
- Creates config.yaml
- Creates TEAM_README.md

**Outputs:**
- `_bmad/teams/{team-name}/agents/*.md` (all agents)
- `_bmad/teams/{team-name}/workflows/*` (if applicable)
- `_bmad/teams/{team-name}/config.yaml`
- `_bmad/teams/{team-name}/TEAM_README.md`

**Key Points:**
- Agent Improver participates ONLY in agent generation (step 2)
- No separate review pass after all agents done
- Quality is built in, not added later
- Fast and efficient
- **EVERY agent file MUST include ALL sections**: `<persona>`, `<activation>`, `<menu>`, `<instructions>`, `<working-methods>`, `<working-methods-protocol>`, `<memory-protocol>`. Agent Improver should flag any missing sections.

---

### Phase 3: Critical Review (2-3 minutes)

**Lead:** Quality Guardian
**Participants:** Quality Guardian only

**What Happens:**

#### Step 1: Comprehensive Review
Quality Guardian reviews finished team:

**Scoring (0-100%):**
- Agent Quality (40 points): Distinctness, specificity, communication, expertise, **mandatory section completeness**
- Workflow Quality (30 points): Practicality, clarity, completeness
- Team Coherence (30 points): Coverage, no overlap, appropriate size

**Mandatory Section Check (Critical - auto-fail if missing):**
Every agent file MUST contain: `<activation>`, `<working-methods>`, `<working-methods-protocol>`, `<memory-protocol>`. Missing any = Critical issue.

**Issue Identification:**
- Critical (must fix)
- High priority (should fix)
- Medium priority (nice to fix)
- Low priority (optional polish)

**Recommendations:**
- Specific, actionable improvements
- Ranked by priority

**Final Recommendation:**
- 95-100%: Install immediately
- 85-94%: Ready to use
- 75-84%: Refinement recommended
- 60-74%: Refinement required
- <60%: Regenerate recommended

#### Step 2: Generate Validation Report
Creates detailed validation report with:
- Overall score and rating
- Score breakdown
- Strengths and issues
- Priority improvements
- Final recommendation

**Outputs:**
- `_bmad/teams/{team-name}/VALIDATION_REPORT.md`

**Key Points:**
- Fresh, critical perspective
- Honest scoring (no grade inflation)
- Specific, actionable recommendations
- Clear install/refine/regenerate recommendation

---

### Phase 4: User Decision (2-3 minutes)

**Lead:** Team Architect
**Participants:** Team Architect + Quality Guardian

**What Happens:**

#### Step 1: Present Results
Both agents present together:

**Team Architect presents:**
- Team structure
- Agent overview
- Workflows
- How team addresses requirements

**Quality Guardian presents:**
- Quality score with breakdown
- Strengths
- Issues (if any)
- Improvement recommendations
- Final recommendation

#### Step 2: User Decision

**User chooses:**

1. **Install Now** (if score 85%+)
   - Register agents in `_bmad/_config/agent-manifest.csv`
   - Add team to `_bmad/_config/manifest.yaml` teams list
   - Create `.claude/commands/` stubs for ALL agents, party-mode, and workflows (see Post-Install Steps below)
   - User restarts Claude Code
   - Team ready to use

2. **Refine** (if score 75-84%)
   - Route to refinement workflow
   - Focus on priority improvements
   - Re-validate after refinement

3. **Regenerate** (if score <75%)
   - Adjust requirements
   - Return to discovery phase

**Key Points:**
- Clear decision point
- Transparent quality assessment
- User control over installation

---

## Efficiency Principles

### Why This Workflow is Efficient

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

## Agent Responsibilities Summary

### Team Architect
**Primary Responsibilities:**
- Lead discovery
- Design team structure
- Generate agents (with Agent Improver)
- Create workflows
- Present results to user

**Not Responsible For:**
- Persona quality (Agent Improver's domain)
- Quality scoring (Quality Guardian's domain)

### Agent Improver
**Primary Responsibilities:**
- Real-time feedback during agent generation
- Ensure persona distinctness
- Prevent generic language
- Validate domain expertise authenticity

**Not Responsible For:**
- Team structure (Team Architect's domain)
- Workflow design (Team Architect's domain)
- Quality scoring (Quality Guardian's domain)

**Important:** Only participates during Phase 2, Step 2 (agent generation)

### Quality Guardian
**Primary Responsibilities:**
- Final quality review
- Calculate quality score (0-100%)
- Identify issues by severity
- Generate specific recommendations
- Make install/refine/regenerate recommendation

**Not Responsible For:**
- Generation (that's done before review)
- Defending the team (objective critique)

## Success Criteria

Workflow succeeds when:

✅ Quality score 85% or higher
✅ All agents have distinct personas
✅ Workflows are practical
✅ User satisfied with team
✅ Team ready to use

## Usage Notes

### When to Use This Workflow

Use for **all new team generation** - it's the default TeamBuilder workflow.

### Prerequisites

- User knows what they need help with
- User can answer domain and scope questions
- User has time for 15-20 minute session

### After Completion - Post-Install Steps (CRITICAL)

When user chooses **Install**, you MUST complete ALL of these steps before telling the user the team is ready:

#### 1. Register in Manifests
- Add each agent to `_bmad/_config/agent-manifest.csv`
- Add team to `_bmad/_config/manifest.yaml` teams list

#### 2. Create Agent Command Stubs (one per agent)
For EACH generated agent, create a file at:
```
.claude/commands/bmad-agent-teams-{team-name}-{agent-id}.md
```

With this content:
```markdown
---
name: '{agent-id}'
description: '{title} - {role_summary}'
disable-model-invocation: true
---

You must fully embody this agent's persona and follow all activation instructions exactly as specified. NEVER break character until given an exit command.

<agent-activation CRITICAL="TRUE">
1. INVENTORY available MCP tools - check what's available (memory, playwright, etc.)
2. If memory MCP is available: search_nodes for "{team-name}" and "general:" to load prior context
3. If TOOL_RECOMMENDATIONS.md exists at {project-root}/_bmad/teams/{team-name}/TOOL_RECOMMENDATIONS.md, READ it for tool guidance
4. LOAD the FULL agent file from {project-root}/_bmad/teams/{team-name}/agents/{agent-id}.md
5. READ its entire contents - this contains the complete agent persona, menu, and instructions
6. FOLLOW every step in the <activation> section precisely
7. DISPLAY the welcome/greeting as instructed (reference any memory context found in step 2)
8. PRESENT the numbered menu
9. WAIT for user input before proceeding
</agent-activation>
```

#### 3. Create Party-Mode Command Stub
Create a file at:
```
.claude/commands/bmad-teams-{team-name}-party-mode.md
```

This enables team-scoped group discussions with only the team's agents.

#### 4. Create Workflow Command Stubs (one per team workflow)
For EACH generated workflow, create a file at:
```
.claude/commands/bmad-teams-{team-name}-{workflow-name}.md
```

#### 5. Setup Team Memory
Create and configure the team's persistent memory file:

1. **Create memory file:** `_bmad/teams/{team-name}/memory.jsonl`
2. **Seed from general knowledge:** Copy contents of `_bmad/teambuilder/memory/general-knowledge.jsonl` into the new file (may be empty on first team - that's fine)
3. **Update .mcp.json:** Read the project's `.mcp.json`, find the `memory` server entry, and add/update the `env.MEMORY_FILE_PATH` to point to the absolute path of the team's memory file:
   - **Windows:** `"MEMORY_FILE_PATH": "D:\\path\\to\\project\\_bmad\\teams\\{team-name}\\memory.jsonl"`
   - **Linux/macOS:** `"MEMORY_FILE_PATH": "/path/to/project/_bmad/teams/{team-name}/memory.jsonl"`
   - Use the actual absolute project path, not a placeholder
   - If the memory MCP entry doesn't exist in `.mcp.json`, create it with the `MEMORY_FILE_PATH` env var

#### 6. Inform User
- Tell user to restart Claude Code
- List all new slash commands they can use
- Mention that team memory has been configured for cross-session persistence
- Mention that CLAUDE.md has been created/updated with command reference

### Invoking Generated Teams

**Individual agents:**
```
/bmad-agent-teams-{team-name}-{agent-name}
```

**Team party mode (team-scoped discussion):**
```
/bmad-teams-{team-name}-party-mode
```

**Team workflows:**
```
/bmad-teams-{team-name}-{workflow-name}
```

## Quality Thresholds

**Minimum for installation:** 85%

**Why this threshold?**
- Users deserve high-quality teams
- Below 85% indicates refinement will significantly improve results
- Better to refine than install mediocre team

**What if user wants to install <85% team?**
- Quality Guardian explains risks
- User can override if they choose
- But recommendation is to refine first

## Troubleshooting

### "Paired generation feels slow"
- Limit feedback to 2-3 exchanges per agent
- Keep feedback specific and brief
- Trust Agent Improver's judgment

### "Quality Guardian finds issues Agent Improver should have caught"
- Agent Improver focuses on individual agent quality during generation
- Quality Guardian reviews team-level coherence and coverage
- Different scopes, different checks

### "User wants to skip critical review"
- Don't skip - it's essential quality control
- Takes 2-3 minutes for comprehensive review
- Often finds issues that weren't obvious during generation

### "Score seems harsh"
- Quality Guardian doesn't inflate grades
- Honest assessment serves user's interest
- 78% team that gets refined to 92% > 78% team called "good enough"

## Best Practices

1. **Discovery quality determines generation quality** - Ask better questions, build better teams

2. **Trust the paired generation** - Agent Improver's real-time feedback is more efficient than post-generation fixes

3. **Accept Quality Guardian's assessment** - Don't defend choices, use feedback to improve

4. **Focus on top 2-3 issues** - If refinement needed, target highest priority improvements first

5. **User decides installation** - We provide assessment, user decides action

## Version History

- v1.0 (2026-01-25): Initial three-agent collaborative workflow
  - Replaced single-agent + rule-based validation
  - Introduced paired generation approach
  - Added Quality Guardian for critical review

---

**Ready to generate exceptional teams efficiently!** 🏗️✨🛡️
