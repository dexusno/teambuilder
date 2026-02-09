# Memory Guide - {team-name}

This file is a reference for entity classification when saving to memory MCP.
It is loaded by workflow steps that save tool learnings.

## Entity Classification: GeneralKnowledge vs ProjectKnowledge

Every entity stored in memory MCP MUST have its `entityType` set to either `GeneralKnowledge` or `ProjectKnowledge`.

### GeneralKnowledge

Use when ALL of these are true:
1. About a tool, CLI command, MCP method, API behavior, or shell technique
2. Would help ANY project (not just this one)
3. About how software/APIs/services work in general
4. Contains NO project names, team names, or project-specific references

### ProjectKnowledge

Use when ANY of these are true:
1. References specific team members, agents, or project entities
2. About project-specific configuration or setup
3. Contains decisions made for THIS project
4. Relates to domain-specific integrations unique to this project

## Entity Naming Convention

**GeneralKnowledge entities:**
```
general:{category}:{topic}
```
Categories: tool, mcp, cli, api, pattern, technique

**ProjectKnowledge entities:**
```
{team-name}:{category}:{topic}
```
Categories: tool, mcp, cli, api, config, preference, decision

## Examples

**GeneralKnowledge:**
- `general:mcp:memory-file-path` → "Memory MCP uses MEMORY_FILE_PATH env var, not CLI arg"
- `general:cli:npm-omit-dev` → "Use --omit=dev instead of deprecated --production flag"
- `general:tool:playwright-wait-pattern` → "Use browser_wait_for before browser_click on dynamic elements"

**ProjectKnowledge:**
- `{team-name}:tool:target-site-search` → "Target site search requires specific URL parameter encoding"
- `{team-name}:mcp:playwright-auth` → "This project's target sites need cookie-based auth before scraping"
- `{team-name}:config:api-rate-limit` → "API allows max 10 requests per minute, add 6-second delays"

## Memory Tools Quick Reference

| Tool | When to Use |
|------|-------------|
| `search_nodes` | Find known working methods at session start |
| `open_nodes` | Get specific method entities you know exist |
| `create_entities` | Store new working methods (name, entityType, observations) |
| `add_observations` | Add details to existing method entities |
| `create_relations` | Link related tool methods |
