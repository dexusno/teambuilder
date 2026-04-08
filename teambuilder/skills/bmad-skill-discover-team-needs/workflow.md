# Discover Team Needs — Workflow

Guided 10-step interview to capture user requirements for team generation. Branches at step 6 based on the domain identified in step 2.

## Variables to Capture

Throughout the workflow, populate these variables:

```yaml
primary_task: ""
primary_task_elaboration: ""
domain: ""              # research-intelligence | planning-strategy | creative-content | technical-development | operations-support | domain-specific-expert
domain_context: ""
scope: ""               # one-time | ongoing | continuous
complexity: ""          # simple | moderate | complex
scale: ""               # small | medium | large
team_size_preference: ""    # 4-6 | 6-8 | 8-12
collaboration_style: ""     # formal | agile | consultative | casual | flexible
key_concerns: []            # 3-5 items
domain_specific_1: ""
domain_specific_2: ""
domain_specific_3: ""
required_expertise: ""
missing_expertise: ""
workflow_preference: ""     # guided | flexible | structured
output_preference: ""       # documents | decisions | analysis | creative-work
discovery_summary: ""
generation_guidance: ""
```

## Step 1 — Initial Need Capture

**Action:** Ask an open-ended question to understand what the user needs help with.

**Question:** "What do you need help with? Tell me about the task, project, or challenge you're facing."

**Listen for:** keywords indicating domain (research, plan, create, build, analyze, manage), scale indicators (one-time, ongoing, large project), complexity signals, pain points.

**Capture:** `primary_task` (direct quote or paraphrase), note key phrases and terminology.

**Follow-up if too brief:** "Can you elaborate a bit more? What's the context or bigger picture?"

## Step 2 — Domain Classification

**Action:** Based on the description, classify into a primary domain.

**Domains and signal keywords:**
- **research-intelligence** — research, find, investigate, analyze data, synthesize
- **planning-strategy** — plan, strategy, roadmap, prioritize, stakeholders, decisions
- **creative-content** — create, write, design, campaign, brand, content, marketing
- **technical-development** — build, code, develop, software, system, technical, engineer
- **operations-support** — manage, coordinate, track, support, maintain, operations, service
- **domain-specific-expert** — specialized field markers (healthcare, legal, finance, ITIL, …)

**Question:** "Based on what you've shared, this sounds like primarily a {DOMAIN} initiative. Does that sound right?" — if unclear, offer the six categories and let the user pick.

**Capture:** `domain`, `domain_context`.

**Validate:** confirm classification with user; adjust if incorrect.

## Step 3 — Scope & Scale Assessment

**Questions:**
1. "Is this a one-time project, an ongoing initiative, or continuous work?" → `scope`
2. "How complex is this? Simple, moderately complex, or highly complex with many moving parts?" → `complexity`
3. "What's the scale? Small (just you), medium (small team), or large (organization-wide)?" → `scale`

**Why these matter:** scope informs workflow design (one-time vs iterative); complexity guides team size; scale affects collaboration model (small=casual, large=formal).

## Step 4 — Team Size Preference

**Question:** "How many AI agents would feel right for this work?
- **Small team (4–6 agents)** — focused, easier to manage, good for straightforward tasks
- **Medium team (6–8 agents)** — balanced, covers most needs, most common choice
- **Large team (8–12 agents)** — comprehensive expertise, best for complex/multifaceted work

What feels right for your situation?"

**Capture:** `team_size_preference`.

**Guidance if uncertain:** simple+low → 4–6; moderate+moderate → 6–8; complex+high → 8–12.

## Step 5 — Key Concerns Identification

**Action:** Identify 3–5 key concerns that should be addressed by team specialists.

**Question:** "What are your main concerns or challenges with this work? What keeps you up at night about it? For example: quality assurance, meeting deadlines, staying within budget, stakeholder alignment, technical complexity, risk management, regulatory compliance. Tell me your top 3–5 concerns."

**Capture:** populate `key_concerns` array (and individually `key_concern_1` through `key_concern_5` if needed).

**Why this matters:** key concerns directly drive specialist agent creation. "Risk management" → team gets a risk specialist.

**Follow-up if user struggles:** "Think about: what could go wrong? What's hardest about this? What expertise do you wish you had?"

## Step 6 — Domain-Specific Questions (BRANCH on `domain`)

This step is critical for generation quality. Ask 3 domain-specific questions based on `domain`.

### Branch: research-intelligence
1. "What sources or types of information will you be searching? (academic papers, market data, web sources, internal documents)" → `domain_specific_1`
2. "How will you verify information credibility? Do you need fact-checking or source evaluation?" → `domain_specific_2`
3. "What's the end deliverable? (comprehensive report, executive summary, dataset, comparative analysis)" → `domain_specific_3`

### Branch: planning-strategy
1. "Who are the key stakeholders? (internal team, executives, customers, partners)" → `domain_specific_1`
2. "What's your planning horizon? (short-term tactical, medium-term initiative, long-term strategic)" → `domain_specific_2`
3. "What types of risks concern you most? (technical, financial, organizational, market, regulatory)" → `domain_specific_3`

### Branch: creative-content
1. "What type of content? (blog, marketing copy, technical docs, social media, video scripts, creative writing)" → `domain_specific_1`
2. "Is there a brand voice or style guide? Tone requirements?" → `domain_specific_2`
3. "Do you need SEO optimization, audience targeting, or performance tracking?" → `domain_specific_3`

### Branch: technical-development
1. "What tech stack or platforms? (languages, frameworks, tools, infrastructure)" → `domain_specific_1`
2. "What development methodology? (Agile/Scrum, Kanban, Waterfall, ad-hoc)" → `domain_specific_2`
3. "What are your quality/testing requirements? (unit tests, integration tests, code review, CI/CD)" → `domain_specific_3`

### Branch: operations-support
1. "What processes or services are you managing? (IT operations, customer support, facilities, …)" → `domain_specific_1`
2. "What are your SLA or performance requirements?" → `domain_specific_2`
3. "What tools or systems do you use? (ticketing, monitoring, automation, ITSM)" → `domain_specific_3`

### Branch: domain-specific-expert
1. "What specific domain or field? (healthcare, legal, finance, ITIL, compliance, …)" → `domain_specific_1`
2. "What regulations, standards, or frameworks apply? (GDPR, HIPAA, SOX, ITIL, ISO, …)" → `domain_specific_2`
3. "What domain-specific challenges or requirements should the team understand?" → `domain_specific_3`

**Why this matters:** domain-specific questions provide context that enables authentic domain expertise in generated agents. This is the difference between generic and excellent teams.

## Step 7 — Collaboration Style Preference

**Question:** "How should this team work together?
- **Formal** — structured roles, clear hierarchies, formal handoffs (governance, compliance)
- **Agile** — sprint-based, ceremonies, iterative (development, dynamic work)
- **Consultative** — multi-perspective discussion, advisory (strategy, decisions)
- **Casual** — flexible, collaborative, less structure (creative, exploratory)
- **Flexible** — balanced approach, adapts as needed

What collaboration style feels right?"

**Capture:** `collaboration_style`.

**Guidance if unsure (suggest based on domain):** domain-specific-expert → Formal; technical-development → Agile; planning-strategy → Consultative; creative-content → Casual; research-intelligence → Flexible.

## Step 8 — Workflow Preference

**Question:** "How do you prefer to work with workflows?
- **Guided** — step-by-step that walks you through
- **Flexible** — loose, adapts to your needs
- **Structured** — detailed, comprehensive, with clear checkpoints

What's your preference?"

**Capture:** `workflow_preference`, and infer `output_preference` (documents, decisions, analysis, creative-work) from context.

## Step 9 — Expertise Gap Check

**Question:** "Is there any specific expertise or specialized knowledge this team absolutely must have? For example: machine learning, legal compliance, healthcare regulations, specific technologies, industry knowledge."

**Capture:** `required_expertise`, `missing_expertise`.

## Step 10 — Summary & Confirmation

**Action:** Summarize all captured requirements and confirm.

**Present to user:**
```
Let me summarize what I understand:

Your need: {primary_task}
Domain: {domain} ({domain_context})
Scope: {scope}, {complexity} complexity, {scale} scale
Team size: {team_size_preference} agents

Key concerns:
- {key_concern_1}
- {key_concern_2}
- {key_concern_3}
- [additional]

Domain context:
- {domain_specific_1}
- {domain_specific_2}
- {domain_specific_3}

Collaboration style: {collaboration_style}
Workflow preference: {workflow_preference}
Required expertise: {required_expertise}

Does this accurately capture what you need?
```

**On confirmation (Yes):** proceed to finalization.
**On correction:** update affected variables and re-confirm.

## Finalization

After step 10 confirmation:

1. **Generate `discovery_summary`** — synthesize all captured information, highlight critical requirements, note domain-specific context.
2. **Create `generation_guidance`** — translate user needs into generation instructions for the next phase: emphasize key concerns for specialist agents, note required expertise, specify collaboration model.
3. **Produce requirements document** — fill in `./template.md` with all captured variables and save to `{output_folder}/teams/team-requirements-{timestamp}.md` (timestamp format `YYYYMMDD-HHmmss`).
4. **Hand off to generation** — return the path to the requirements document to the calling skill (typically `bmad-skill-collaborative-generation`). Tell the user: "Perfect! I've captured your requirements. Now I'll generate a custom team tailored to your needs. This will take about 2–3 minutes…"

## Edge Cases

- **User is vague:** ask follow-ups, provide examples, offer scenarios.
- **Domain unclear:** default to `domain-specific-expert`, ask "What would you call this field?", store the user's term in `domain_context`.
- **Mismatch (small team for complex work):** gently suggest larger team but respect user's choice; note constraint in `generation_guidance`.
- **More than 5 concerns:** acknowledge all, ask user to prioritize the top 3–5, note the rest in `generation_guidance`.
- **Multiple domains:** ask which is primary, note secondary domains in `domain_context`, generation will blend patterns.

## Quality Markers

✅ **Good discovery:** captures specific domain context (not generic), identifies concrete concerns that drive specialist agents, gathers domain terminology, user confirms accuracy.

❌ **Poor discovery:** generic information, no domain-specific questions asked, key concerns not identified, user terminology not captured, rushed steps.
