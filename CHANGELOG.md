# Changelog

All notable changes to TeamBuilder are documented here.

This project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.

The full per-commit history is on GitHub: https://github.com/dexusno/teambuilder/commits/main

---

## [3.2.1] — 2026-04-09

**Hotfix: non-interactive install command.**

### Fixed
- **Install command missing critical flags.** `bmad-skill-generate-team/workflow.md` Step 10, `bmad-skill-collaborative-generation/workflow.md` Phase 2 Step 4 and Phase 4 Step 2 "If INSTALL", and three places in `README.md` all showed the install command as:
  ```
  npx bmad-method install --custom-content "<team-path>" -y
  ```
  This is **incomplete**. Without `--directory`, `--modules`, and `--tools`, BMAD's installer drops into an interactive clack TUI asking for the installation directory, module selection, and tool selection. An LLM-driven team-guide agent running the install via a Bash tool call cannot answer these prompts — it hangs until timeout.

  All five install-command templates now show the fully non-interactive form:
  ```
  npx bmad-method@6.2.2 install \
    --directory "<absolute-path-to-project-root>" \
    -y \
    --modules bmm \
    --tools claude-code \
    --custom-content "<absolute-path-to-team>"
  ```
  With an explicit flag-by-flag table explaining what each flag does and what happens if it's omitted. Emphasis on **absolute paths only** for both `--directory` and `--custom-content`.

### Impact
- Users who generated a team with v3.2.0 and tried to have the team-guide agent install it via Bash were blocked on the interactive TUI. This is a regression from Phase 1 testing where I verified the flag set worked — the v3.0 port correctly used all flags in the `install.ps1` / `install.sh` scripts, but the install-command template in the generated `TEAM_README.md` (produced by `bmad-skill-generate-team`) was a shortened form that didn't match.

### Discovered by
- Real user running their first end-to-end team generation. Reported with exact error (BMAD prompting for installation directory), enabling this fix.

### Not affected
- `scripts/install.ps1` and `scripts/install.sh` (the TeamBuilder installers themselves) — those already use the full flag set and work correctly.
- The Phase 4 smoke test (hand-crafted fake team) — it used the correct flags and passed 28/28.
- Users who copy-pasted the install command from the TEAM_README manually to a terminal — the interactive TUI would prompt them for the missing values and they'd just press Enter. Only agent-driven automated installs hit the block.

---

## [3.2.0] — 2026-04-08

**Phase 6b — Channels, runtime drift warning, CI smoke test.**

### Added
- **BMAD release channels** in `install.{ps1,sh}` and `update.{ps1,sh}` via the new `-Channel` / `--channel` flag. Three values supported:
  - `stable` (default) — pinned BMAD `6.2.2`, the only fully tested combination.
  - `beta` — latest npm `next` dist-tag (UNSUPPORTED).
  - `nightly` — alias for `beta` (BMAD has only `latest` and `next` dist-tags).
  When a non-stable channel is selected, the installer prints a yellow warning box with the resolved version and requires interactive confirmation (skip with `-Yes` / `-y`). Verified live: `-Channel beta` resolves to `6.2.3-next.30` from npm.
- **Runtime drift warning** in `bmad-agent-team-guide` activation. On every invocation the agent loads `compatibility.json`, reads the installed BMAD version from `manifest.yaml`, and compares against the matrix:
  - Blocked → red blocking warning with reason from the matrix.
  - Tested with `status: pass` → silent.
  - In `supported_range` but untested → yellow info note.
  - Out of range → yellow warning to use `scripts/doctor.*`.
  The check is informational only — it never blocks the user from proceeding.
- **GitHub Actions CI smoke test** at `.github/workflows/smoke-test.yml`. Runs on every push, pull_request, and a daily cron at 04:17 UTC, plus manual dispatch. Matrix: `{ubuntu-latest, windows-latest} × {Node 18, 20, 22}`. For each combination, runs the full install + manifest verification + `compat-check` + `doctor` + `bmad status` pipeline. An aggregate summary job reports a single pass/fail at the end.

### Changed
- `install.{ps1,sh}` and `update.{ps1,sh}` now derive `BMAD_VERSION` at runtime from the resolved channel rather than using a hardcoded constant.
- README.md version history now lists v3.2.0 with channel + runtime warning + CI details.

### Fixed
- The `Resolve-BmadVersion` function (PowerShell) and `resolve_bmad_version` function (bash) gracefully fall back to the pinned stable version on npm-network failure.

### Known limitations
- Channel auto-detection of the originally-installed channel is not implemented. Users on a non-stable channel must re-pass `--channel beta` on every `update.*` invocation or they will be downgraded to stable.
- The runtime drift warning is implemented as activation instructions for the LLM to interpret. A future iteration could move this to a Python helper in `bmad-init` for deterministic enforcement.

---

## [3.1.0] — 2026-04-08

**Phase 6a — Compatibility guardrails.**

### Added
- **`teambuilder/compatibility.json`** — structured BMAD compatibility matrix with:
  - `teambuilder_version`, `bmad.supported_range`, `bmad.tested[]`, `bmad.blocked[]`
  - `required_structure` — files, directories, CSV column headers, manifest.yaml top-level keys
  - `teambuilder_invariants` — expected agents/skills/patterns, required files, agent manifest fields
  - `remediation` — short text snippets for each known failure mode
  Update this file when testing TeamBuilder against a new BMAD version. JSON (not YAML) for zero-dependency parsing.
- **`scripts/lib/compat-check.js`** — vanilla Node compatibility engine. Zero dependencies (uses only `fs`, `path`, `process` from stdlib). Includes a tiny semver subset and a naive YAML reader for top-level keys. Output modes: human-readable text, `--json` (machine-readable), `--quiet` (summary only), `--strict` (warnings count as failures). Exit codes: 0 healthy, 1 failures (or warnings if `--strict`), 2 cannot run.
- **`scripts/doctor.{ps1,sh}`** — read-only diagnostics. Wraps `compat-check.js` + `bmad-method status`. Reports a combined health summary across four sections: A. BMAD version status, B. BMAD structural invariants, C. TeamBuilder install integrity, D. Manifest registration counts. Never modifies anything. Supports `-Json` / `--json` for scripts.
- **`scripts/update.{ps1,sh}`** — safe in-place update with snapshot + rollback. Critical safety properties:
  - Never touches `_bmad/teams-*/` (generated teams are preserved).
  - Never touches BMAD `core/` or `bmm/` modules.
  - Snapshots `_bmad/teambuilder/` to `_bmad/.tb-backup-{timestamp}/` before any change.
  - Refuses to run if `_bmad/teambuilder/` doesn't exist (points at `install.*`).
  - Refuses to run if BMAD is in the blocked list (override with `-Force` / `--force`).
  - Runs `compat-check` before AND after the update.
  - Offers rollback from the snapshot if the post-update check fails.
  - Re-runs BMAD installer after rollback to regenerate manifests.

### Documentation
- README.md "Reinstalling, updating, uninstalling" section rewritten to point at the new scripts (replacing the v3.0 "not yet supported" placeholder).
- Troubleshooting section now leads with "First step: run doctor".
- `scripts/README.md` restructured around the four operational scripts (install, doctor, update, compat-check) with full flag documentation, exit code tables, and the Section A/B/C/D check inventory.

### Validation
Phase 6a 7-test suite all pass:
1. doctor on healthy v3.1 sandbox → 44 PASS / 0 WARN / 0 FAIL, exit 0
2. doctor `--json` → JSON parses cleanly, status `HEALTHY`
3. doctor on corrupted sandbox (deleted `bmad-agent-team-guide`) → Section C reports FAIL, exit 1
4. update with `-KeepBackup` → snapshot created (69 files), BMAD quick-update succeeds, post-check 44 PASS, exit 0
5. backup snapshot preserved with `-KeepBackup` → `.tb-backup-{timestamp}/` present
6. update against directory without `_bmad/teambuilder/` → refused with "not installed", exit 1
7. cleanup → snapshots removed

---

## [3.0.0] — 2026-04-08

**Full port to BMAD v6.2.2 architecture.** Ground-up rewrite. Not backward compatible with v2.x.

### Why this release exists
The previous v5-era architecture (XML-style agent files, workflow file triads, manual manifest CSV editing, `.claude/commands/` stubs) was incompatible with BMAD v6.2.2's new module system. v3.0 is the result of porting TeamBuilder to be a first-class BMAD v6 custom module installed via BMAD's native `--custom-content` flow. Every generated team is itself a BMAD v6 custom module, installable the same way.

### Added — architecture
- **SKILL.md + bmad-skill-manifest.yaml** for agents (replaces v5 XML `<agent><persona><menu>` files).
- **SKILL.md + workflow.md** (+ optional `template.md`) for skills (replaces v5 `workflow.yaml + instructions.md + template.md` triads).
- **`teams-{team-name}` module code convention** for generated teams. BMAD's `bmad-init` skill discovers modules by literal directory match; the prefix prevents collisions with `core`, `bmm`, `teambuilder` and ensures `bmad-init --module=teams-{name}` works at runtime.
- **`templates/_team-skills/`** with `bmad-skill-save-session` and `bmad-skill-memory-guide`. The leading underscore tells BMAD's recursive discovery to skip these — they are templates copied into generated teams at generation time, not skills of TeamBuilder itself.
- **`module.yaml`** at the module root so BMAD recognizes TeamBuilder as a custom module.

### Added — agents (6)
- `bmad-agent-team-guide` (was `teambuilder-guide`)
- `bmad-agent-team-architect` (was `team-architect`)
- `bmad-agent-persona-improver` (was `agent-improver`; renamed to make scope explicit — persona is the full domain, identity is just one field)
- `bmad-agent-quality-guardian` (was `quality-guardian`)
- `bmad-agent-tool-scout` (was `tool-scout`)
- `bmad-agent-memory-manager` (was `memory-manager`; kept as an agent because the auto-memory capture approach failed in practice)

### Added — skills (5)
- `bmad-skill-discover-team-needs`
- `bmad-skill-collaborative-generation`
- `bmad-skill-generate-team`
- `bmad-skill-validate-team`
- `bmad-skill-refine-team`

### Added — pattern library
Six patterns rewritten in parallel by 6 worker agents. ~55,000 words of new content total. Every example shows complete v6 SKILL.md + bmad-skill-manifest.yaml shape. v5 XML markup and workflow-triad references are fully stripped.

| Pattern | Agents | Workflows | Words |
|---|---|---|---|
| creative-content | 5 | 4 | ~8,200 |
| itil-domain-expert | 6 | 4 | ~13,800 |
| operations-process | 5 | 3 | ~7,200 |
| planning-strategy | 6 | 3 | ~9,550 |
| research-intelligence | 5 | 3 | ~7,300 |
| software-development | 5 specialty | 4 | ~8,500 |

The software-development pattern includes a prominent **BMM disambiguation**: "use `bmm` for generic agile software development; use this pattern only for specialty roles BMM doesn't provide" (Security Engineer, SRE, ML Engineer, Accessibility Specialist, etc.).

### Added — validation rules
`templates/validation-rules.yaml` rewritten to v3.0 (~29 KB, up from ~16 KB):
- Removed 6 v5-specific rules (XML structure, workflow triad existence, Entry-Point thin-shell line limits, manual manifest format, etc.).
- Rewrote 5 rules to v6 equivalents.
- Added 18 new v6-critical rules including the critical `code: teams-{name}` enforcement on generated module.yaml files.
- Scoring weights (agent 40% / workflow 30% / team 30%) and bands (95/85/75/60) preserved exactly.
- Now scores well-formed v6 teams 90+ instead of failing them for missing v5 artifacts.

### Added — installer
`scripts/install.{ps1,sh}` rewritten from scratch:
- Refuse-if-exists guard (refuses to run if `_bmad/teambuilder/` exists; offers to add to existing BMAD-only install if `_bmad/` exists without teambuilder)
- `-LocalSource` / `--local-source` flag for maintainer testing without git push
- `-NoMcp` / `--no-mcp` and `-NoPlaywright` / `--no-playwright` flags
- `-Branch` / `--branch` flag for feature-branch installs
- Post-install sanity checks (verifies config.yaml, agents/, skills/, manifests)
- Temp-clone cleanup via try/finally and trap EXIT
- BMAD version pinning to `6.2.2` (replaces the previous `@latest` which was risky for version drift)

### Removed
- v5 XML agent files (`<agent><persona><menu><activation>` blocks)
- v5 workflow triads (`workflow.yaml + instructions.md + template.md`)
- `.claude/commands/` stub creation logic (BMAD v6 installs to `.claude/skills/` directly)
- Manual `agent-manifest.csv` row appending (BMAD generates the CSV from filesystem discovery)
- Manual `manifest.yaml` block insertion (BMAD generates the file)
- Manual `workflow-manifest.csv` handling (the file no longer exists in BMAD v6)
- Config value copying between module files (BMAD handles config cascading natively)
- winget/brew/apt auto-install of prerequisites (users handle prereqs themselves)

### Documentation
README.md completely rewritten with comprehensive sections: TOC, what TeamBuilder IS and is NOT, architecture pipeline diagram, install instructions for Windows/Linux/macOS, first-team quick start, all 6 agents and 5 skills documented, pattern library catalog, generated team structure with the `teams-` prefix explanation, memory system (GeneralKnowledge vs ProjectKnowledge), configuration reference, project layout, troubleshooting, development notes, version history, 10-point disclaimer.

### Validation
All gates passed:
- Phase 1 gate — single agent + single skill sandbox install
- Phase 1b gate — 2 agents + 2 skills
- Phase 2 bulk gate — all 6 agents + 5 skills + patterns + templates
- Phase 2.5 polish gate — after `_team-skills` rename + `principles_note` cleanup
- Phase 3 installer test — install succeeds, refuses on re-run, `.mcp.json` + `.gitignore` + `docs/` all created correctly
- **Phase 4 smoke test — 28/28 PASS** on the end-to-end round trip: a hand-crafted fake "generated team" was installed as a real BMAD custom module, both `teambuilder` and `teams-smoke-test-team` coexisted, `bmad status` reported both healthy, all agents and skills landed in `.claude/skills/`
- Phase 5 final gate — install from renamed `teambuilder/` directory works, 6 agents + 11 skills registered

### Breaking changes
v3.0 is **not backward compatible** with v2.x. The v5 architecture and the v6 architecture are fundamentally different. If you have v2-generated teams, you'll need to regenerate them with v3 for use on BMAD v6.

---

## [2.0.0] — 2025-12-02

**Dynamic generation architecture with pattern library** (BMAD v5 era). Pre-port. Documented here for historical completeness — no longer maintained.

---

## [1.0.0] — 2025-11-29

**Initial release: pre-built ITIL Configuration Management team** (BMAD v5 era). Pre-port. Documented here for historical completeness.

---

[3.2.1]: https://github.com/dexusno/teambuilder/releases/tag/v3.2.1
[3.2.0]: https://github.com/dexusno/teambuilder/releases/tag/v3.2.0
[3.1.0]: https://github.com/dexusno/teambuilder/releases/tag/v3.1.0
[3.0.0]: https://github.com/dexusno/teambuilder/releases/tag/v3.0.0
[2.0.0]: https://github.com/dexusno/teambuilder/releases/tag/v2.0
[1.0.0]: https://github.com/dexusno/teambuilder/commits/main
