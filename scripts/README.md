# TeamBuilder Scripts

Operational scripts for installing, diagnosing, and updating a TeamBuilder + BMAD project.

| Script | Purpose | Modifies disk? |
|---|---|---|
| `install.ps1` / `install.sh` | First-time install of BMAD + TeamBuilder | Yes (writes `_bmad/`, `.mcp.json`, `docs/`, `.gitignore`) |
| `doctor.ps1` / `doctor.sh` | Read-only health check (compat-check + bmad status) | **No** — read-only, safe to run anytime |
| `update.ps1` / `update.sh` | Safe in-place update with snapshot + rollback | Yes (replaces `_bmad/teambuilder/`, never touches `_bmad/teams-*/`) |
| `lib/compat-check.js` | Vanilla-Node compatibility engine called by doctor and update | **No** — read-only |

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

## `doctor.ps1` / `doctor.sh` — Read-Only Diagnostics

**Read-only** health check. Runs the full compatibility test suite (42+ structural and version checks) plus `bmad status` and reports a structured pass/fail summary. Use this when something feels broken, after upgrading BMAD, before running `update.*`, or when filing a bug report.

**PowerShell:**

```powershell
.\doctor.ps1                              # Standard check, current directory
.\doctor.ps1 -ProjectPath C:\path\to\proj # Check a specific project
.\doctor.ps1 -Json                        # JSON output for scripts
.\doctor.ps1 -Strict                      # Exit 1 on warnings as well as failures
```

**Bash:**

```bash
./doctor.sh                                  # Standard check, current directory
./doctor.sh --project-path /path/to/proj     # Check a specific project
./doctor.sh --json                           # JSON output for scripts
./doctor.sh --strict                         # Exit 1 on warnings as well as failures
```

**Exit codes:**

| Code | Meaning |
|---|---|
| 0 | Healthy (or warnings only in non-strict mode) |
| 1 | Failures detected (or warnings if --strict) |
| 2 | Cannot run (TeamBuilder not installed, or compatibility.json missing) |

**What gets checked (44 total checks in a healthy v3.1 install):**

- **Section A — BMAD version status**: detected version, blocked-list check, tested-list check, supported-range check
- **Section B — BMAD structural invariants**: required files (`agent-manifest.csv`, `skill-manifest.csv`, etc.), required directories, CSV column headers match expected schema, `manifest.yaml` top-level keys
- **Section C — TeamBuilder install integrity**: required files, all 6 expected agents present (with both `SKILL.md` and `bmad-skill-manifest.yaml`), all 5 expected skills present, all 6 patterns with their 6 standard files each
- **Section D — Manifest registration counts**: 6 teambuilder agents in `agent-manifest.csv`, 11 teambuilder skills in `skill-manifest.csv` (6 agents + 5 skills), `teambuilder` listed in `manifest.yaml`

---

## `update.ps1` / `update.sh` — Safe In-Place Update

Updates TeamBuilder in place with **snapshot + rollback** safety. Never touches `_bmad/teams-*/` (your generated teams are preserved).

**The flow:**

1. Verify `_bmad/teambuilder/` exists (else: refuse, point at install)
2. Run pre-update `compat-check` (must pass, or use `-Force` / `--force`)
3. Snapshot the current `_bmad/teambuilder/` to `_bmad/.tb-backup-{timestamp}/`
4. Clone the teambuilder repo to a temp directory (or use `-LocalSource` / `--local-source`)
5. Show current vs new version, ask for confirmation (unless `-Yes` / `-y`)
6. Re-run BMAD's installer with `--custom-content` (BMAD does a quick-update)
7. Run post-update `compat-check`
8. **On any failure**: offer rollback from the snapshot
9. **On success**: ask whether to delete the snapshot (or `-KeepBackup` / `--keep-backup` to retain)

**Critical safety properties:**

- ✅ Never touches `_bmad/teams-*/` (generated teams are preserved)
- ✅ Never touches BMAD `core/` or `bmm/` modules
- ✅ Never deletes the snapshot until the user confirms success
- ✅ Refuses to run if `_bmad/teambuilder/` doesn't exist
- ✅ Refuses to run if BMAD is in the blocked list (override with `-Force`)
- ✅ Always re-runs compat-check after the update

**PowerShell:**

```powershell
.\update.ps1                       # Interactive: prompts before each step
.\update.ps1 -Yes                  # Non-interactive
.\update.ps1 -Yes -KeepBackup      # Non-interactive, keep the snapshot
.\update.ps1 -Yes -Force           # Override pre-check failures
.\update.ps1 -Yes -Branch develop  # Update to a specific branch
.\update.ps1 -Yes -LocalSource D:\dev\teambuilder\teambuilder  # Maintainer flow
```

**Bash:**

```bash
./update.sh                         # Interactive
./update.sh -y                      # Non-interactive
./update.sh -y --keep-backup        # Keep the snapshot
./update.sh -y --force              # Override pre-check failures
./update.sh -y --branch develop     # Specific branch
./update.sh -y --local-source /home/dev/teambuilder/teambuilder  # Maintainer
```

**Exit codes:**

| Code | Meaning |
|---|---|
| 0 | Update successful and verified |
| 1 | Update failed (snapshot preserved at `_bmad/.tb-backup-{timestamp}/`) |
| 2 | Cannot run (compat-check.js missing or other infrastructure failure) |

---

## `lib/compat-check.js` — Compatibility Engine

Vanilla-Node script (zero dependencies). Reads `_bmad/teambuilder/compatibility.json` and probes the live BMAD install for required structure, schema invariants, and version compatibility. Called by `doctor.*` and `update.*`. Can also be invoked directly for advanced diagnostics or CI.

```bash
node scripts/lib/compat-check.js                          # default human output
node scripts/lib/compat-check.js --bmad-path /path/to/proj
node scripts/lib/compat-check.js --json                   # machine-readable
node scripts/lib/compat-check.js --strict                 # warnings = failures
node scripts/lib/compat-check.js --quiet                  # only summary line
node scripts/lib/compat-check.js --help
```

**Exit codes** (same as `doctor.*`): 0 healthy, 1 failures, 2 cannot run.

---

## Troubleshooting

See the [top-level README Troubleshooting section](../README.md#troubleshooting) for runtime issues. **First step for any problem: run `doctor.ps1` or `doctor.sh`.**

For installer-specific issues:

- **"Script cannot be loaded because running scripts is disabled on this system"** (Windows): run with `powershell -ExecutionPolicy Bypass -File .\install.ps1` or set `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.
- **"git clone failed"**: check network, check SSL certificates, try `--branch` if `main` doesn't exist for some reason.
- **"npx bmad-method@6.2.2 not found"**: verify `npx` works: `npx --version`. If missing, reinstall Node.js.
- **BMAD install fails partway through**: the installer leaves `_bmad/` in whatever state BMAD left it. Delete `_bmad/` and try again. If it fails again with the same error, file an issue with the full output.
- **`update.ps1` says "compat-check.js not found"**: the script must live next to `lib/compat-check.js`. Check that the `lib/` subdirectory was cloned along with the scripts.
- **`update.ps1` post-check FAILED, what now?**: the script will offer to roll back from the snapshot. Say yes — it restores `_bmad/teambuilder/` from `_bmad/.tb-backup-{timestamp}/` and re-runs BMAD's installer to regenerate manifests. Generated teams are unaffected throughout.
