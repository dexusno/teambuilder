# Installation Scripts

TeamBuilder's install scripts for Windows and Unix-like systems. Both install BMAD Method 6.2.2 + TeamBuilder into the current directory using BMAD's native `--custom-content` flow.

For the full user-facing installation guide see the [top-level README](../README.md#installation).

---

## `install.ps1` — Windows PowerShell

**Typical usage:**

```powershell
cd C:\path\to\your\project
.\install.ps1
```

**Flags:**

| Flag | Effect |
|---|---|
| `-Yes` | Accept all defaults, no prompts |
| `-NoMcp` | Skip `.mcp.json` creation |
| `-NoPlaywright` | Keep Memory MCP, skip Playwright |
| `-Branch <name>` | Install from a specific git branch (default `main`) |
| `-LocalSource <path>` | Use a local TeamBuilder checkout (maintainer flow) |

**Examples:**

```powershell
# Standard install
.\install.ps1

# Non-interactive, no Playwright
.\install.ps1 -Yes -NoPlaywright

# Install from a feature branch
.\install.ps1 -Branch my-feature

# Maintainer: test a local checkout without pushing
.\install.ps1 -Yes -LocalSource D:\dev\teambuilder\teambuilder
```

---

## `install.sh` — Linux / macOS

**Typical usage:**

```bash
cd ~/path/to/your/project
bash install.sh
```

**Flags:**

| Flag | Effect |
|---|---|
| `-y` / `--yes` | Accept all defaults, no prompts |
| `--no-mcp` | Skip `.mcp.json` creation |
| `--no-playwright` | Keep Memory MCP, skip Playwright |
| `--branch NAME` | Install from a specific git branch (default `main`) |
| `--local-source PATH` | Use a local TeamBuilder checkout (maintainer flow) |

**Examples:**

```bash
# Standard install
./install.sh

# Non-interactive, no Playwright
./install.sh -y --no-playwright

# Maintainer: test a local checkout without pushing
./install.sh -y --local-source /home/you/dev/teambuilder/teambuilder
```

---

## What the installers do

Both scripts perform the same sequence of steps in the same order:

1. **Check prerequisites** — Node.js ≥ 18, npm, git. Reports Claude Code CLI if present (optional — the desktop app works fine too).
2. **Refuse-if-exists guard** — refuses to run if `_bmad/teambuilder/` already exists (points at update/doctor scripts). If `_bmad/` exists but `teambuilder/` doesn't, offers to add TeamBuilder to the existing BMAD install.
3. **Fetch TeamBuilder module source** — git-clones the `dexusno/teambuilder` repo to a temp directory (or uses `--local-source` if specified).
4. **Run BMAD's installer** —
   ```
   npx bmad-method@6.2.2 install \
     --directory <target> \
     -y \
     --modules bmm \
     --tools claude-code \
     --custom-content <temp>/teambuilder
   ```
   BMAD handles everything else: copies the module, generates manifest CSVs (`agent-manifest.csv`, `skill-manifest.csv`, `files-manifest.csv`), registers entries in `manifest.yaml`, installs skills into `.claude/skills/`.
5. **Post-install sanity checks** — verifies `_bmad/teambuilder/config.yaml`, `_bmad/teambuilder/agents/`, `_bmad/teambuilder/skills/`, and the manifest CSVs. Counts teambuilder rows and reports them.
6. **Write `.mcp.json`** — configures the Memory MCP server with `MEMORY_FILE_PATH` pointing at `_bmad/teambuilder/memory/general-knowledge.jsonl`, plus Playwright MCP (unless skipped). Leaves an existing `.mcp.json` alone.
7. **Create `docs/`** — team knowledge base directory.
8. **Create or append to `.gitignore`** — rules for team memory and session context files.
9. **Clean up the temp clone.**
10. **Print success** with next steps, full agent list, and the exact slash command to invoke first (`/bmad-agent-team-guide`).

## What the installers do NOT do

Compared to v5 installers (now gone), these scripts **do not**:

- Manually append rows to `agent-manifest.csv` or `skill-manifest.csv` — BMAD generates these.
- Insert blocks into `manifest.yaml` — BMAD manages it.
- Create `.claude/commands/` stub files — BMAD installs to `.claude/skills/` directly.
- Copy config values between module files — BMAD handles config cascading.
- Auto-install Node.js / git / Claude Code via winget/brew/apt — the user is expected to install prerequisites themselves. (This was a v5 feature that added complexity for little benefit.)

## Prerequisites

The installer scripts require these tools on your PATH:

| Tool | Minimum | How to install |
|---|---|---|
| Node.js | 18.x | https://nodejs.org/ |
| npm | ships with Node.js | — |
| git | any recent | https://git-scm.com/ |

Claude Code CLI is optional — the Claude Code desktop app works equally well. BMAD Method itself is installed automatically by the script (via `npx bmad-method@6.2.2`), so do NOT pre-install it.

## BMAD version pinning

Both scripts pin BMAD to **`6.2.2`** (the current stable at time of TeamBuilder v3.0 release). This is intentional:

- BMAD's API surface between `6.2.x` and future releases may change in ways that break TeamBuilder's manifest expectations.
- Using `@latest` would let a breaking BMAD release silently break TeamBuilder installs for new users.
- The Phase 6 guardrail system (planned) will add a compatibility matrix and `update.ps1` / `doctor.ps1` scripts to manage version drift explicitly.

If you need to override the version, edit `BMAD_VERSION` at the top of the script and know what you're doing.

## Troubleshooting

See the [top-level README Troubleshooting section](../README.md#troubleshooting) for runtime issues. For installer-specific issues:

- **"Script cannot be loaded because running scripts is disabled on this system"** (Windows): run with `powershell -ExecutionPolicy Bypass -File .\install.ps1` or set `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.
- **"git clone failed"**: check network, check SSL certificates, try `--branch` if `main` doesn't exist for some reason.
- **"npx bmad-method@6.2.2 not found"**: verify `npx` works: `npx --version`. If missing, reinstall Node.js.
- **BMAD install fails partway through**: the installer leaves `_bmad/` in whatever state BMAD left it. Delete `_bmad/` and try again. If it fails again with the same error, file an issue with the full output.
