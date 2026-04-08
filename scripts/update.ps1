<#
.SYNOPSIS
    Safely update an installed TeamBuilder module in place.
.DESCRIPTION
    Updates the teambuilder module while preserving:
      - Generated teams under _bmad/teams-*/
      - The user's .mcp.json
      - The user's docs/ contents
      - The user's .gitignore (only TeamBuilder rules are reapplied if missing)
      - Memory files (general-knowledge.jsonl is preserved)

    Steps:
      1. Verify _bmad/teambuilder/ exists (else: not installed, point at install.ps1)
      2. Run compat-check on the existing install (must pass or use -Force)
      3. Snapshot _bmad/teambuilder/ to _bmad/.tb-backup-{timestamp}/
      4. Clone the teambuilder repo to a temp directory (or use -LocalSource)
      5. Show current version vs new version, ask for confirmation (unless -Yes)
      6. Re-run BMAD's installer with --custom-content (BMAD does a quick-update)
      7. Run compat-check on the result
      8. If post-update compat-check fails: offer rollback from snapshot
      9. Clean up temp clone

    Critical safety properties:
      - Never touches _bmad/teams-*/ (generated teams are preserved)
      - Never touches BMAD core/ or bmm/
      - Never deletes the snapshot until the user confirms success
      - Refuses to run if BMAD is in the blocked list (use -Force to override)

.PARAMETER Yes
    Skip all confirmation prompts.
.PARAMETER Force
    Proceed even if compat-check reports failures or BMAD is in the blocked list.
.PARAMETER Branch
    Git branch to clone from the teambuilder repo (default: main).
.PARAMETER LocalSource
    Use a local TeamBuilder checkout instead of cloning (maintainer flow).
.PARAMETER ProjectPath
    Project root containing _bmad/. Default: current directory.
.PARAMETER KeepBackup
    Don't prompt to delete the .tb-backup-{ts}/ snapshot at the end.
.EXAMPLE
    cd C:\path\to\my-project
    .\update.ps1
.EXAMPLE
    .\update.ps1 -Yes -Branch develop
.LINK
    https://github.com/dexusno/teambuilder
#>

param(
    [switch]$Yes,
    [switch]$Force,
    [string]$Branch = "main",
    [string]$LocalSource = "",
    [string]$ProjectPath = (Get-Location).Path,
    [switch]$KeepBackup
)

$ErrorActionPreference = "Stop"

# -----------------------------------------------------------------------------
# Configuration (must match install.ps1)
# -----------------------------------------------------------------------------
$TEAMBUILDER_REPO = "https://github.com/dexusno/teambuilder.git"
$TEAMBUILDER_MODULE_PATH = "teambuilder"
$BMAD_VERSION = "6.2.2"
$BMAD_MODULES = "bmm"
$BMAD_TOOLS = "claude-code"

# -----------------------------------------------------------------------------
# Console formatting
# -----------------------------------------------------------------------------
function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host ("=" * 60) -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host ("=" * 60) -ForegroundColor Cyan
    Write-Host ""
}
function Write-Step    { param([string]$t) Write-Host "  -> $t" -ForegroundColor Yellow }
function Write-Success { param([string]$t) Write-Host "  [OK] $t" -ForegroundColor Green }
function Write-Fail    { param([string]$t) Write-Host "  [X]  $t" -ForegroundColor Red }
function Write-Warn    { param([string]$t) Write-Host "  [!]  $t" -ForegroundColor DarkYellow }
function Write-Info    { param([string]$t) Write-Host "  $t" -ForegroundColor Gray }

function Show-Banner {
    Write-Host ""
    Write-Host "  +---------------------------------------------------+" -ForegroundColor Magenta
    Write-Host "  |   TeamBuilder Update (in-place, with rollback)    |" -ForegroundColor Magenta
    Write-Host "  +---------------------------------------------------+" -ForegroundColor Magenta
    Write-Host ""
}

function Confirm-Or-Exit {
    param([string]$Prompt, [bool]$Default = $true)
    if ($Yes) { return $Default }
    $suffix = if ($Default) { "[Y/n]" } else { "[y/N]" }
    $reply = Read-Host "  $Prompt $suffix"
    if ([string]::IsNullOrWhiteSpace($reply)) { return $Default }
    return ($reply -match '^[Yy]')
}

# -----------------------------------------------------------------------------
# Locate compat-check.js
# -----------------------------------------------------------------------------
$compatCheck = Join-Path $PSScriptRoot "lib\compat-check.js"
if (-not (Test-Path $compatCheck)) {
    Write-Fail "compat-check.js not found at $compatCheck"
    exit 2
}

# =============================================================================
# Step 1 - Verify TeamBuilder is installed
# =============================================================================
Show-Banner

$projectAbs = (Resolve-Path $ProjectPath -ErrorAction SilentlyContinue).Path
if (-not $projectAbs) { $projectAbs = $ProjectPath }
Write-Info "Project root: $projectAbs"

Write-Header "Step 1 - Verify Existing Install"

$tbDir = Join-Path $projectAbs "_bmad\teambuilder"
if (-not (Test-Path $tbDir)) {
    Write-Fail "TeamBuilder is not installed in this directory."
    Write-Info "Found: $projectAbs"
    Write-Info "Expected: $tbDir"
    Write-Host ""
    Write-Info "To install TeamBuilder for the first time, use scripts\install.ps1 instead."
    exit 1
}

$currentCompatPath = Join-Path $tbDir "compatibility.json"
$currentVersion = "unknown (pre-3.1, no compatibility.json)"
if (Test-Path $currentCompatPath) {
    try {
        $currentCompat = Get-Content $currentCompatPath -Raw | ConvertFrom-Json
        $currentVersion = $currentCompat.teambuilder_version
    } catch {
        Write-Warn "Could not parse current compatibility.json"
    }
}
Write-Success "Found existing TeamBuilder install (version: $currentVersion)"

# =============================================================================
# Step 2 - Pre-update compat-check
# =============================================================================
Write-Header "Step 2 - Pre-Update Compatibility Check"

if (Test-Path $currentCompatPath) {
    & node $compatCheck --bmad-path $projectAbs --quiet
    $preExit = $LASTEXITCODE
    if ($preExit -eq 0) {
        Write-Success "Pre-update compat-check: HEALTHY"
    } elseif ($preExit -eq 1 -and -not $Force) {
        Write-Fail "Pre-update compat-check: FAILURES detected"
        Write-Info "Run scripts\doctor.ps1 for details."
        Write-Info "If you understand the issues and want to update anyway, re-run with -Force."
        exit 1
    } elseif ($preExit -eq 1) {
        Write-Warn "Pre-update compat-check: failures detected, but -Force was specified, continuing"
    }
} else {
    Write-Warn "No compatibility.json in current install (pre-3.1) - skipping pre-check"
    Write-Info "This update will install the new compatibility.json so future updates are checked."
}

# =============================================================================
# Step 3 - Snapshot existing teambuilder/
# =============================================================================
Write-Header "Step 3 - Backup Snapshot"

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$snapshotDir = Join-Path $projectAbs "_bmad\.tb-backup-$timestamp"

Write-Step "Creating backup at $snapshotDir ..."
Copy-Item -Path $tbDir -Destination $snapshotDir -Recurse -Force
$snapshotFileCount = (Get-ChildItem $snapshotDir -Recurse -File | Measure-Object).Count
Write-Success "Snapshot created ($snapshotFileCount files)"

# =============================================================================
# Step 4 - Fetch new TeamBuilder source
# =============================================================================
Write-Header "Step 4 - Fetch New TeamBuilder Source"

$tempBase = $null
$modulePath = $null

if (-not [string]::IsNullOrWhiteSpace($LocalSource)) {
    Write-Step "Using local source: $LocalSource"
    if (-not (Test-Path (Join-Path $LocalSource "module.yaml"))) {
        Write-Fail "LocalSource does not contain module.yaml: $LocalSource"
        exit 1
    }
    $modulePath = (Resolve-Path $LocalSource).Path
} else {
    $tempBase = Join-Path $env:TEMP ("teambuilder-update-" + [Guid]::NewGuid().ToString("N").Substring(0,8))
    Write-Step "Cloning $TEAMBUILDER_REPO (branch: $Branch) to temp..."
    Write-Info "Temp: $tempBase"
    & git clone --depth 1 --branch $Branch $TEAMBUILDER_REPO $tempBase 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "Failed to clone teambuilder repo"
        exit 1
    }
    $modulePath = Join-Path $tempBase $TEAMBUILDER_MODULE_PATH
    if (-not (Test-Path (Join-Path $modulePath "module.yaml"))) {
        Write-Fail "Cloned repo does not contain $TEAMBUILDER_MODULE_PATH/module.yaml"
        Remove-Item $tempBase -Recurse -Force -ErrorAction SilentlyContinue
        exit 1
    }
}

# Read the new version
$newCompatPath = Join-Path $modulePath "compatibility.json"
$newVersion = "unknown"
if (Test-Path $newCompatPath) {
    try {
        $newCompat = Get-Content $newCompatPath -Raw | ConvertFrom-Json
        $newVersion = $newCompat.teambuilder_version
    } catch { }
}
Write-Success "New source ready (version: $newVersion)"

# =============================================================================
# Step 5 - Confirm
# =============================================================================
Write-Header "Step 5 - Confirm Update"

Write-Info "Current TeamBuilder version: $currentVersion"
Write-Info "New TeamBuilder version:     $newVersion"
Write-Info "BMAD version (pinned):       $BMAD_VERSION"
Write-Host ""
Write-Info "What this update will do:"
Write-Info "  - Re-run BMAD's installer with --custom-content"
Write-Info "  - BMAD will quick-update teambuilder, leaving core/bmm/teams-* alone"
Write-Info "  - Re-run compat-check after the update"
Write-Info "  - On any failure, you'll be offered the rollback from $snapshotDir"
Write-Host ""

if (-not (Confirm-Or-Exit "Proceed with update?" $true)) {
    Write-Info "Aborted by user. Snapshot preserved at $snapshotDir"
    if ($tempBase -and (Test-Path $tempBase)) { Remove-Item $tempBase -Recurse -Force -ErrorAction SilentlyContinue }
    exit 0
}

# =============================================================================
# Step 6 - Re-run BMAD installer (quick-update mode)
# =============================================================================
Write-Header "Step 6 - Run BMAD Quick-Update"

Push-Location $projectAbs
try {
    & cmd /c "npx --yes bmad-method@$BMAD_VERSION install --directory `"$projectAbs`" -y --modules $BMAD_MODULES --tools $BMAD_TOOLS --custom-content `"$modulePath`""
    $bmadExit = $LASTEXITCODE
} finally { Pop-Location }

if ($bmadExit -ne 0) {
    Write-Fail "BMAD quick-update failed (exit $bmadExit)"
    Write-Host ""
    Write-Warn "ROLLBACK AVAILABLE: snapshot at $snapshotDir"
    Write-Info "To restore: remove _bmad\teambuilder\ and rename the snapshot back."
    if ($tempBase -and (Test-Path $tempBase)) { Remove-Item $tempBase -Recurse -Force -ErrorAction SilentlyContinue }
    exit 1
}

# =============================================================================
# Step 7 - Post-update compat-check
# =============================================================================
Write-Header "Step 7 - Post-Update Compatibility Check"

& node $compatCheck --bmad-path $projectAbs
$postExit = $LASTEXITCODE

if ($postExit -ne 0) {
    Write-Host ""
    Write-Fail "Post-update compat-check FAILED (exit $postExit)"
    Write-Host ""
    Write-Warn "Update completed but the result is not healthy."
    Write-Warn "Snapshot is available at: $snapshotDir"
    Write-Host ""
    if (Confirm-Or-Exit "Roll back to the snapshot?" $true) {
        Write-Step "Rolling back ..."
        Remove-Item $tbDir -Recurse -Force
        Copy-Item -Path $snapshotDir -Destination $tbDir -Recurse -Force
        # Re-run BMAD install one more time so manifests reflect the rolled-back module
        Write-Step "Re-running BMAD installer to regenerate manifests after rollback ..."
        Push-Location $projectAbs
        try {
            & cmd /c "npx --yes bmad-method@$BMAD_VERSION install --directory `"$projectAbs`" -y --modules $BMAD_MODULES --tools $BMAD_TOOLS --custom-content `"$tbDir`""
        } finally { Pop-Location }
        Write-Success "Rolled back to previous TeamBuilder version"
        Write-Info "Snapshot preserved at $snapshotDir for inspection"
        if ($tempBase -and (Test-Path $tempBase)) { Remove-Item $tempBase -Recurse -Force -ErrorAction SilentlyContinue }
        exit 1
    } else {
        Write-Warn "Snapshot preserved at $snapshotDir for manual recovery"
        if ($tempBase -and (Test-Path $tempBase)) { Remove-Item $tempBase -Recurse -Force -ErrorAction SilentlyContinue }
        exit 1
    }
}

# =============================================================================
# Step 8 - Clean up
# =============================================================================
Write-Header "Step 8 - Cleanup"

if ($tempBase -and (Test-Path $tempBase)) {
    Remove-Item $tempBase -Recurse -Force -ErrorAction SilentlyContinue
    Write-Success "Removed temp clone"
}

if (-not $KeepBackup) {
    if (Confirm-Or-Exit "Delete the backup snapshot at $snapshotDir?" $true) {
        Remove-Item $snapshotDir -Recurse -Force
        Write-Success "Snapshot deleted"
    } else {
        Write-Info "Snapshot preserved at $snapshotDir"
    }
} else {
    Write-Info "Snapshot preserved at $snapshotDir (-KeepBackup specified)"
}

Write-Host ""
Write-Host "  +---------------------------------------------------+" -ForegroundColor Green
Write-Host "  |              Update Complete!                     |" -ForegroundColor Green
Write-Host "  +---------------------------------------------------+" -ForegroundColor Green
Write-Host ""
Write-Host "  TeamBuilder is now at version: $newVersion" -ForegroundColor White
Write-Host ""
Write-Host "  Restart Claude Code to pick up the updated skills." -ForegroundColor Yellow
Write-Host ""
exit 0
