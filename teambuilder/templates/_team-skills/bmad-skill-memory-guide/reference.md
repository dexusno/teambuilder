# Memory Guide — {team_name}

Reference content for classifying entities stored in Memory MCP. Loaded by `bmad-skill-save-session` and any other skill in the `{team_name}` team that persists or searches memory.

## Entity Classification: GeneralKnowledge vs ProjectKnowledge

Every entity stored in Memory MCP MUST have its `entityType` set to either `GeneralKnowledge` or `ProjectKnowledge`.

### GeneralKnowledge

Use when **ALL** of these are true:

1. About a tool, CLI command, MCP method, API behavior, or shell technique
2. Would help ANY project — not just `{team_name}`
3. About how software, APIs, or services work in general
4. Contains NO project names, team names, or project-specific references

`GeneralKnowledge` entries are eligible for cross-team consolidation into `{project-root}/_bmad/teambuilder/memory/general-knowledge.jsonl` so that future generated teams start with accumulated wisdom.

### ProjectKnowledge

Use when **ANY** of these are true:

1. References specific team members, agents, or entities unique to `{team_name}`
2. About project-specific configuration or setup
3. Contains decisions made for this project
4. Relates to domain-specific integrations unique to `{team_name}`

`ProjectKnowledge` entries stay local to this team and are never consolidated.

## Entity Naming Convention

**GeneralKnowledge entities:**

```
general:{category}:{topic}
```

Categories: `tool`, `mcp`, `cli`, `api`, `pattern`, `technique`

**ProjectKnowledge entities:**

```
{team_name}:{category}:{topic}
```

Categories: `tool`, `mcp`, `cli`, `api`, `config`, `preference`, `decision`

## Examples

**GeneralKnowledge:**

- `general:mcp:memory-file-path` → "Memory MCP uses MEMORY_FILE_PATH env var, not a CLI arg"
- `general:cli:npm-omit-dev` → "Use `--omit=dev` instead of the deprecated `--production` flag"
- `general:tool:playwright-wait-pattern` → "Use browser_wait_for before browser_click on dynamic elements"

**ProjectKnowledge:**

- `{team_name}:tool:target-site-search` → "Target site search requires specific URL parameter encoding"
- `{team_name}:mcp:playwright-auth` → "This project's target sites need cookie-based auth before scraping"
- `{team_name}:config:api-rate-limit` → "API allows max 10 requests per minute; add 6-second delays"

## Memory Tools Quick Reference

| Tool | When to Use |
|------|-------------|
| `search_nodes` | Find known working methods at session start |
| `open_nodes` | Get specific method entities you know exist |
| `create_entities` | Store new working methods (`name`, `entityType`, `observations`) |
| `add_observations` | Add details to an existing method entity |
| `create_relations` | Link related tool methods |

## Classification Decision Guide

When in doubt:

1. Strip mentions of `{team_name}` and the project domain from the observation.
2. Does the remaining statement still make sense and still teach something useful?
   - **Yes** → `GeneralKnowledge`
   - **No** → `ProjectKnowledge`
3. If it mentions configuration values, credentials, or site-specific behavior that other projects would NOT share → `ProjectKnowledge`.
4. If it describes how a public tool, MCP, CLI, or API behaves at the product level → `GeneralKnowledge`.

## Storage Locations

- **Team memory file:** configured via `.mcp.json` to point Memory MCP at `{output_folder}/teams/{team_name}/memory.jsonl`
- **Cross-team consolidation target:** `{project-root}/_bmad/teambuilder/memory/general-knowledge.jsonl` (consolidated by TeamBuilder's `memory-manager` agent)
