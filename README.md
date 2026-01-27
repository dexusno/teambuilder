# TeamBuilder

**One-command installer for BMAD + TeamBuilder projects.**

Create custom AI agent teams tailored to your exact needs using the BMAD Method.

## Prerequisites

- **Claude Code** with a paid subscription ([Claude Pro, Max, or API](https://claude.ai))
- **Node.js** (installed automatically if missing)
- **Git** (installed automatically if missing)

---

## Quick Start - Windows

Choose one of the two options below:

### Option A: Download Script First

Use this if you want to save the script locally or review it before running.

**Step 1:** Open PowerShell (search "PowerShell" in Start menu)

**Step 2:** Navigate to where you want your project, for example:
```powershell
cd C:\Projects
```

**Step 3:** Download the installer script:
```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.ps1 -OutFile install.ps1
```

**Step 4:** Run the script with your project name:
```powershell
.\install.ps1 my-project
```

### Option B: Run Directly from GitHub

Use this for a quick one-command install. Copy and paste this into PowerShell:

```powershell
irm https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.ps1 | iex
```

The script will prompt you for a project name.

---

## Quick Start - Linux / macOS

Choose one of the two options below:

### Option A: Download Script First

Use this if you want to save the script locally or review it before running.

**Step 1:** Open Terminal

**Step 2:** Navigate to where you want your project, for example:
```bash
cd ~/Projects
```

**Step 3:** Download the installer script:
```bash
curl -O https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.sh
```

**Step 4:** Make it executable:
```bash
chmod +x install.sh
```

**Step 5:** Run the script with your project name:
```bash
./install.sh my-project
```

### Option B: Run Directly from GitHub

Use this for a quick one-command install. Copy and paste this into Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.sh | bash
```

The script will prompt you for a project name.

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
- **Smart folder handling** - Creates folder, uses current directory, or prompts if not empty

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
│       ├── patterns/      # Team patterns (5 types)
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

TeamBuilder learns from 5 diverse patterns:

1. **ITIL/Domain Expert** - Large, formal, governance-focused teams
2. **Software Development** - Agile, sprint-based technical teams
3. **Research/Intelligence** - Iterative, synthesis-focused teams
4. **Planning/Strategy** - Consultative, multi-perspective teams
5. **Creative/Content** - Creative process, brand-aware teams

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
