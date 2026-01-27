# TeamBuilder

**One-command installer for BMAD + TeamBuilder projects.**

---

## What is This?

### The BMAD Method

[BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD) is an open-source framework that lets you create **AI agent teams** using Claude Code. Instead of talking to one generic AI, you can build specialized agents - each with their own expertise, personality, and role - that work together on complex tasks.

Think of it like assembling a team of experts: a project manager, a developer, a researcher, a quality reviewer - each with distinct skills and perspectives. BMAD provides the structure to define these agents and orchestrate how they collaborate.

*Note: BMAD Method is created and maintained by [bmad-code-org](https://github.com/bmad-code-org). TeamBuilder is a community project that builds on top of it.*

### What TeamBuilder Adds

Creating agent teams from scratch requires writing detailed agent definitions, designing workflows, and understanding BMAD's structure. **TeamBuilder simplifies this.**

With TeamBuilder, you get:

- **Guided Team Creation** - Answer questions about what you need, and TeamBuilder generates a custom team for you
- **Quality Assurance** - Built-in validation ensures your agents are distinct, well-defined, and work together effectively
- **Pattern Library** - Learn from 6 proven team patterns (research teams, development teams, operations teams, and more)
- **Tool Recommendations** - Get suggestions for MCP integrations that enhance your team's capabilities
- **One-Command Setup** - This installer sets up everything: BMAD, TeamBuilder, and useful tools

### Who Is This For?

- **Beginners** who want to explore AI agent teams without learning BMAD internals
- **Teams** who need specialized AI collaborators for specific domains (home automation, research, content creation, etc.)
- **Developers** who want a fast way to bootstrap BMAD projects with best practices built in

---

## Prerequisites

- **[Claude Code](https://claude.ai)** - Anthropic's CLI for Claude
- **Node.js** (installed automatically if missing)
- **Git** (installed automatically if missing)

---

## Quick Start - Windows

Choose one of the two options below:

### Option A: Download Script First

**Step 1:** Download the script: **[install.ps1](https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.ps1)** (right-click → Save link as)

**Step 2:** Create a folder for your project and move the script there

**Step 3:** Open PowerShell and navigate to your project folder:
```powershell
cd C:\Projects\my-project
```

**Step 4:** Run the script:
```powershell
.\install.ps1
```

### Option B: One-Liner from GitHub

**Step 1:** Create and navigate to your project folder:
```powershell
mkdir my-project
cd my-project
```

**Step 2:** Download and run the installer:
```powershell
iwr https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.ps1 -OutFile install.ps1; .\install.ps1
```

---

## Quick Start - Linux / macOS

Choose one of the two options below:

### Option A: Download Script First

**Step 1:** Download the script: **[install.sh](https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.sh)** (right-click → Save link as)

**Step 2:** Create a folder for your project and move the script there

**Step 3:** Open Terminal and navigate to your project folder:
```bash
cd ~/Projects/my-project
chmod +x install.sh
```

**Step 4:** Run the script:
```bash
./install.sh
```

### Option B: Run Directly from GitHub

**Step 1:** Create and navigate to your project folder:
```bash
mkdir my-project
cd my-project
```

**Step 2:** Run the installer:
```bash
curl -fsSL https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.sh | bash
```

---

## What Gets Installed

| Component | Description |
|-----------|-------------|
| **BMAD Method** | Latest alpha version via `npx bmad-method@alpha install` |
| **TeamBuilder Module** | AI agent team generator with patterns and workflows |
| **Memory MCP** | Persistent knowledge across sessions |
| **Playwright MCP** | Headless browser automation |

## Usage

After installation:

```bash
# 1. Navigate to your project
cd my-project

# 2. Open in Claude Code
claude .

# 3. Create your first team
/bmad:teambuilder:agents:teambuilder-guide
```

## Installer Features

- **Prerequisite checking** - Verifies Claude Code, Node.js, Git
- **Auto-installation** - Installs missing prerequisites via winget (Windows) or apt/brew/dnf/pacman (Linux/Mac)
- **Menu-driven** - Full install or custom component selection
- **Current folder install** - Installs in the folder you run the script from

## Project Structure

After installation, your project will have:

```
my-project/
├── _bmad/
│   ├── _config/           # BMAD configuration
│   ├── core/              # BMAD core modules
│   └── teambuilder/       # TeamBuilder module
│       ├── agents/        # TeamBuilder agents
│       ├── workflows/     # Generation workflows
│       ├── patterns/      # Team patterns (6 types)
│       └── templates/     # Agent/workflow templates
├── .mcp.json              # MCP server configuration
└── .gitignore
```

## TeamBuilder Agents

| Agent | Role |
|-------|------|
| **TeamBuilder Guide** | Main interface - guides team creation |
| **Team Architect** | Designs team structure and composition |
| **Agent Improver** | Ensures persona quality and distinctness |
| **Quality Guardian** | Validates and scores generated teams |
| **Tool Scout** | Researches MCPs and tools that benefit teams |

## Team Patterns

TeamBuilder learns from 6 diverse patterns:

1. **ITIL/Domain Expert** - Large, formal, governance-focused teams
2. **Software Development** - Agile, sprint-based technical teams
3. **Research/Intelligence** - Iterative, synthesis-focused teams (also covers data analysis/BI)
4. **Planning/Strategy** - Consultative, multi-perspective teams
5. **Creative/Content** - Creative process, brand-aware teams
6. **Operations/Process** - Lean/Six Sigma, continuous improvement teams

## Generated Team Structure

When TeamBuilder creates a team, you get:

```
_bmad/teams/your-team/
├── agents/              # Team specialists with distinct personas
├── workflows/
│   └── party-mode/      # Team-scoped group discussion
├── docs/                # Team documentation (optional)
└── config.yaml          # Team configuration
```

### Team Party-Mode

Each generated team includes its own **party-mode** workflow:

| Command | Scope |
|---------|-------|
| `/bmad:core:workflows:party-mode` | All installed BMAD agents |
| `/bmad:teams:your-team:workflows:party-mode` | Only your team's agents |

The team-scoped party-mode enables focused group discussions with just that team's specialists - no interference from other teams or BMAD core agents.

## MCP Servers

Default configuration includes:

| MCP | Purpose |
|-----|---------|
| **Memory** | Persistent knowledge graph across sessions |
| **Playwright** | Headless browser automation for web tasks |

## License

MIT License - See [LICENSE](LICENSE) for details.

## Links

- [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD)
- [Claude Code](https://claude.ai/product/claude-code)
- [MCP Servers](https://github.com/modelcontextprotocol/servers)
