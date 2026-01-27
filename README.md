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

### Option B: Run Directly from GitHub

**Step 1:** Create and navigate to your project folder:
```powershell
mkdir my-project
cd my-project
```

**Step 2:** Run the installer:
```powershell
irm https://raw.githubusercontent.com/dexusno/teambuilder/main/scripts/install.ps1 | iex
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
