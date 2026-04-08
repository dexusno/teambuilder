<#
.SYNOPSIS
    TeamBuilder Doctor - read-only diagnostics for an installed TeamBuilder + BMAD project.
.DESCRIPTION
    Runs the TeamBuilder compatibility check (scripts/lib/compat-check.js) plus
    BMAD's own `bmad status` command and reports the combined health of the
    install. READ-ONLY - never modifies anything.

    Use this when:
      - Something feels broken and you want a quick triage
      - You just upgraded BMAD and want to know if TeamBuilder is still compatible
      - You're about to run scripts/update.ps1 and want to know the starting state
      - You're filing a bug report and need a structured health snapshot

.PARAMETER ProjectPath
    The project root containing _bmad/. Default: current directory.
.PARAMETER Json
    Emit machine-readable JSON output (combines compat-check JSON + bmad status).
.PARAMETER Strict
    Exit code 1 if there are warnings as well as failures.
.EXAMPLE
    cd C:\path\to\my-project
    .\doctor.ps1
.EXAMPLE
    .\doctor.ps1 -ProjectPath C:\path\to\project -Json
.LINK
    https://github.com/dexusno/teambuilder
#>

param(
    [string]$ProjectPath = (Get-Location).Path,
    [switch]$Json,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

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
    Write-Host "  |   TeamBuilder Doctor (read-only diagnostics)      |" -ForegroundColor Magenta
    Write-Host "  +---------------------------------------------------+" -ForegroundColor Magenta
    Write-Host ""
}

# -----------------------------------------------------------------------------
# Locate compat-check.js
# -----------------------------------------------------------------------------
$compatCheck = Join-Path $PSScriptRoot "lib\compat-check.js"
if (-not (Test-Path $compatCheck)) {
    Write-Host ""
    Write-Host "  [X] compat-check.js not found at $compatCheck" -ForegroundColor Red
    Write-Host "      This script must live next to lib\compat-check.js" -ForegroundColor Red
    exit 2
}

# -----------------------------------------------------------------------------
# Sanity: project root must contain _bmad/
# -----------------------------------------------------------------------------
$projectAbs = (Resolve-Path $ProjectPath -ErrorAction SilentlyContinue).Path
if (-not $projectAbs) { $projectAbs = $ProjectPath }

$bmadDir = Join-Path $projectAbs "_bmad"
if (-not (Test-Path $bmadDir)) {
    if ($Json) {
        $err = @{ error = "_bmad/ not found at $projectAbs"; exitCode = 2 } | ConvertTo-Json
        Write-Output $err
    } else {
        Show-Banner
        Write-Fail "_bmad/ not found at $projectAbs"
        Write-Info "TeamBuilder is not installed in this directory."
        Write-Info "Run scripts/install.ps1 to install."
    }
    exit 2
}

# -----------------------------------------------------------------------------
# JSON mode: just delegate to compat-check.js --json and output
# -----------------------------------------------------------------------------
if ($Json) {
    $jsonOut = & node $compatCheck --bmad-path $projectAbs --json
    Write-Output ($jsonOut -join "`n")
    $compatExit = $LASTEXITCODE
    if ($Strict -and $compatExit -ne 0) { exit 1 }
    exit $compatExit
}

# -----------------------------------------------------------------------------
# Human mode: banner + compat-check + bmad status
# -----------------------------------------------------------------------------
Show-Banner
Write-Info "Project root: $projectAbs"
Write-Host ""

# 1. Compatibility check
Write-Step "Running compatibility check..."
Write-Host ""
$compatArgs = @("--bmad-path", $projectAbs)
if ($Strict) { $compatArgs += "--strict" }
& node $compatCheck @compatArgs
$compatExit = $LASTEXITCODE

# 2. BMAD status
Write-Header "BMAD Status (from bmad-method)"
Push-Location $projectAbs
try {
    & cmd /c 'npx --yes bmad-method@6.2.2 status 2>&1' | ForEach-Object { Write-Output $_ }
    $bmadExit = $LASTEXITCODE
} finally { Pop-Location }

# 3. Summary
Write-Header "Doctor Summary"
if ($compatExit -eq 0) {
    Write-Success "compat-check: HEALTHY"
} elseif ($compatExit -eq 1) {
    Write-Fail "compat-check: FAILURES detected (see section above)"
} elseif ($compatExit -eq 2) {
    Write-Fail "compat-check: COULD NOT RUN (compatibility.json missing)"
}

if ($bmadExit -eq 0) {
    Write-Success "bmad status: returned cleanly"
} else {
    Write-Warn "bmad status: exit code $bmadExit (may be informational, check output above)"
}

Write-Host ""
if ($compatExit -eq 0) {
    Write-Host "  Doctor reports: HEALTHY" -ForegroundColor Green
    Write-Host ""
    exit 0
} elseif ($compatExit -eq 2) {
    Write-Host "  Doctor reports: CANNOT DIAGNOSE" -ForegroundColor Red
    Write-Host "  (TeamBuilder may be installed in an old format without compatibility.json)" -ForegroundColor Gray
    Write-Host ""
    exit 2
} else {
    Write-Host "  Doctor reports: ISSUES FOUND" -ForegroundColor Red
    Write-Host "  Review the FAIL/WARN entries above and consult the README troubleshooting section." -ForegroundColor Gray
    Write-Host "  https://github.com/dexusno/teambuilder#troubleshooting" -ForegroundColor Gray
    Write-Host ""
    exit 1
}
