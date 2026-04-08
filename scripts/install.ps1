<#
.SYNOPSIS
    TeamBuilder v3 Project Installer for Windows (BMAD v6.2.2)
.DESCRIPTION
    Installs BMAD Method v6 core + bmm module + the TeamBuilder custom module
    into the CURRENT DIRECTORY, and configures Claude Code + Memory/Playwright MCP.

    This is the BMAD v6 installer. It uses BMAD's native --custom-content flow
    to register TeamBuilder as a first-class v6 custom module. No manual manifest
    editing, no .claude/commands/ stubs, no file-triad workflows - BMAD auto-generates
    everything from the TeamBuilder module's SKILL.md + bmad-skill-manifest.yaml files.

    The installer:
      1. Checks prerequisites (Node.js, npm, git)
      2. Refuses to run if TeamBuilder is already installed (use update/doctor scripts)
      3. Clones the teambuilder repo to a temp directory
      4. Runs `npx bmad-method install --custom-content ...` to register TeamBuilder
      5. Writes .mcp.json (Memory + optional Playwright MCP servers)
      6. Creates docs/ and updates .gitignore
      7. Reports success with next steps

.PARAMETER Yes
    Accept all defaults and skip interactive prompts.
.PARAMETER NoMcp
    Skip .mcp.json creation (user will configure MCP servers manually).
.PARAMETER NoPlaywright
    Skip Playwright MCP server in .mcp.json (keep Memory only).
.PARAMETER Branch
    Git branch to clone from the teambuilder repo. Default: main.
.PARAMETER LocalSource
    Path to a local teambuilder module directory (skips the git clone).
    Used by maintainers testing changes before committing. Must point at a
    directory that contains module.yaml.
.PARAMETER Channel
    BMAD release channel to install: stable (default, pinned 6.2.2),
    beta (next pre-release), or nightly (npm 'next' dist-tag, untested).
    Use beta/nightly only if you accept the risk of breakage.
.EXAMPLE
    mkdir my-project
    cd my-project
    .\install.ps1
.EXAMPLE
    .\install.ps1 -Yes -NoPlaywright
.EXAMPLE
    # Maintainer flow: test a local checkout without pushing
    .\install.ps1 -LocalSource D:\teambuilder-repo\teambuilder -Yes
.EXAMPLE
    # Try the latest BMAD nightly (UNSUPPORTED)
    .\install.ps1 -Channel nightly
.LINK
    https://github.com/dexusno/teambuilder
#>

param(
    [switch]$Yes,
    [switch]$NoMcp,
    [switch]$NoPlaywright,
    [string]$Branch = "main",
    [string]$LocalSource = "",
    [ValidateSet("stable", "beta", "nightly")]
    [string]$Channel = "stable"
)

$ErrorActionPreference = "Stop"

# =============================================================================
# Configuration
# =============================================================================

$TEAMBUILDER_REPO = "https://github.com/dexusno/teambuilder.git"
$TEAMBUILDER_MODULE_PATH = "teambuilder"     # Module directory within the cloned repo
$BMAD_STABLE_VERSION = "6.2.2"               # Pinned stable version (channel: stable)
$BMAD_MODULES = "bmm"                        # Default modules to install alongside teambuilder
$BMAD_TOOLS = "claude-code"                  # Default IDE integration

# Resolve BMAD version based on selected channel.
# stable  -> the pinned $BMAD_STABLE_VERSION
# beta    -> npm dist-tag 'next' (returns prerelease versions, e.g. 6.2.3-next.30)
# nightly -> alias for beta (BMAD has only 'latest' and 'next' dist-tags)
function Resolve-BmadVersion {
    param([string]$Ch)
    if ($Ch -eq "stable") { return $BMAD_STABLE_VERSION }
    if ($Ch -eq "beta" -or $Ch -eq "nightly") {
        try {
            $next = (& cmd /c "npx --yes -- npm view bmad-method dist-tags.next 2>nul") -join "" -replace '\s',''
            if ($next) { return $next }
        } catch { }
        Write-Host ("[!] Could not resolve " + $Ch + " version from npm; falling back to stable " + $BMAD_STABLE_VERSION) -ForegroundColor DarkYellow
        return $BMAD_STABLE_VERSION
    }
    return $BMAD_STABLE_VERSION
}

$BMAD_VERSION = Resolve-BmadVersion $Channel

# =============================================================================
# Console formatting
# =============================================================================

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
    Write-Host "  |   TeamBuilder v3 Installer (BMAD v6.2.2)          |" -ForegroundColor Magenta
    Write-Host "  |   github.com/dexusno/teambuilder                  |" -ForegroundColor Magenta
    Write-Host "  +---------------------------------------------------+" -ForegroundColor Magenta
    Write-Host ""
}

function Test-Command {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Confirm-Or-Exit {
    param([string]$Prompt, [bool]$Default = $true)
    if ($Yes) { return $Default }
    $suffix = if ($Default) { "[Y/n]" } else { "[y/N]" }
    $reply = Read-Host "  $Prompt $suffix"
    if ([string]::IsNullOrWhiteSpace($reply)) { return $Default }
    return ($reply -match '^[Yy]')
}

# =============================================================================
# Prerequisite checks
# =============================================================================

function Test-Prerequisites {
    Write-Header "Checking Prerequisites"
    $missing = @()

    if (Test-Command "node") {
        $nodeVersion = (node --version) -replace '^v',''
        Write-Success "Node.js $nodeVersion"
        $major = [int]($nodeVersion -split '\.')[0]
        if ($major -lt 18) {
            Write-Warn "Node.js >= 18 recommended (you have $nodeVersion)"
        }
    } else {
        Write-Fail "Node.js not found"
        $missing += "Node.js (https://nodejs.org/)"
    }

    if (Test-Command "npm") {
        Write-Success "npm $(npm --version)"
    } else {
        Write-Fail "npm not found"
        $missing += "npm (ships with Node.js)"
    }

    if (Test-Command "git") {
        $gitVersion = (git --version) -replace '^git version ',''
        Write-Success "git $gitVersion"
    } else {
        Write-Fail "git not found"
        $missing += "git (https://git-scm.com/)"
    }

    if (Test-Command "claude") {
        Write-Success "Claude Code CLI detected (optional - desktop app works too)"
    } else {
        Write-Info "Claude Code CLI not in PATH (the desktop app works fine too)"
    }

    if ($missing.Count -gt 0) {
        Write-Host ""
        Write-Fail "Missing required tools:"
        foreach ($m in $missing) { Write-Host "    - $m" -ForegroundColor Red }
        Write-Host ""
        Write-Host "  Install them and re-run this script." -ForegroundColor Red
        exit 1
    }

    Write-Host ""
}

# =============================================================================
# Refuse-if-exists guard
# =============================================================================

function Test-NotAlreadyInstalled {
    Write-Header "Checking Target Directory"

    $target = (Get-Location).Path
    Write-Info "Target: $target"

    if (Test-Path "_bmad\teambuilder") {
        Write-Host ""
        Write-Fail "TeamBuilder is already installed in this directory."
        Write-Host ""
        Write-Host "  Found: _bmad\teambuilder\" -ForegroundColor Red
        Write-Host ""
        Write-Host "  To update TeamBuilder, use scripts\update-v6.ps1 (coming in Phase 6)." -ForegroundColor Yellow
        Write-Host "  To diagnose issues,  use scripts\doctor-v6.ps1 (coming in Phase 6)." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  If you want a fresh install, manually remove _bmad/ first (this will" -ForegroundColor Yellow
        Write-Host "  delete your current BMAD installation including any generated teams!)." -ForegroundColor Yellow
        Write-Host ""
        exit 1
    }

    if (Test-Path "_bmad") {
        Write-Warn "_bmad/ already exists (BMAD is installed, but TeamBuilder is not)"
        Write-Info "This installer will ADD TeamBuilder to your existing BMAD installation."
        Write-Info "Core and BMM modules will not be touched."
        if (-not (Confirm-Or-Exit "Proceed?" $true)) {
            Write-Info "Aborted."
            exit 0
        }
    } else {
        Write-Success "Clean directory - full BMAD + TeamBuilder install will proceed"
    }

    Write-Host ""
}

# =============================================================================
# Clone teambuilder repo to temp
# =============================================================================

function Get-TeambuilderSource {
    Write-Header "Fetching TeamBuilder Module Source"

    # Maintainer flow: use a local directory instead of cloning
    if (-not [string]::IsNullOrWhiteSpace($LocalSource)) {
        Write-Step "Using local source: $LocalSource"
        if (-not (Test-Path $LocalSource)) {
            Write-Fail "LocalSource path does not exist: $LocalSource"
            exit 1
        }
        $modulesYaml = Join-Path $LocalSource "module.yaml"
        if (-not (Test-Path $modulesYaml)) {
            Write-Fail "LocalSource does not contain module.yaml: $LocalSource"
            Write-Info "LocalSource must point at a valid BMAD custom module directory."
            exit 1
        }
        Write-Success "Using local TeamBuilder module source (no clone)"
        Write-Host ""
        return @{ TempBase = ""; ModulePath = (Resolve-Path $LocalSource).Path }
    }

    # Normal flow: clone from remote
    $tempBase = Join-Path $env:TEMP ("teambuilder-install-" + [Guid]::NewGuid().ToString("N").Substring(0,8))
    Write-Step "Cloning $TEAMBUILDER_REPO (branch: $Branch) to temp..."
    Write-Info "Temp: $tempBase"

    try {
        & git clone --depth 1 --branch $Branch $TEAMBUILDER_REPO $tempBase 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "git clone failed (exit $LASTEXITCODE)" }
    } catch {
        Write-Fail "Failed to clone teambuilder repo: $_"
        if (Test-Path $tempBase) { Remove-Item $tempBase -Recurse -Force -ErrorAction SilentlyContinue }
        exit 1
    }

    $modulePath = Join-Path $tempBase $TEAMBUILDER_MODULE_PATH
    if (-not (Test-Path $modulePath)) {
        Write-Fail "Cloned repo does not contain '$TEAMBUILDER_MODULE_PATH/'"
        Write-Info "The teambuilder repo layout may have changed."
        Write-Info "Check https://github.com/dexusno/teambuilder for updates."
        Remove-Item $tempBase -Recurse -Force -ErrorAction SilentlyContinue
        exit 1
    }

    $modulesYaml = Join-Path $modulePath "module.yaml"
    if (-not (Test-Path $modulesYaml)) {
        Write-Fail "Module source is missing module.yaml (not a valid BMAD custom module)"
        Remove-Item $tempBase -Recurse -Force -ErrorAction SilentlyContinue
        exit 1
    }

    Write-Success "TeamBuilder module source ready"
    Write-Host ""
    return @{ TempBase = $tempBase; ModulePath = $modulePath }
}

# =============================================================================
# Install BMAD + TeamBuilder via --custom-content
# =============================================================================

function Install-Bmad {
    param([string]$ModulePath)

    Write-Header "Installing BMAD $BMAD_VERSION + TeamBuilder"

    Write-Step "Running: npx bmad-method@$BMAD_VERSION install -y --modules $BMAD_MODULES --tools $BMAD_TOOLS --custom-content `"$ModulePath`""
    Write-Info "This will take a minute or two. BMAD will:"
    Write-Info "  - Install core module"
    Write-Info "  - Install $BMAD_MODULES module"
    Write-Info "  - Copy teambuilder module from $ModulePath"
    Write-Info "  - Auto-discover all SKILL.md files and generate manifests"
    Write-Info "  - Install all skills into .claude/skills/ for Claude Code"
    Write-Host ""

    $targetDir = (Get-Location).Path
    & cmd /c "npx --yes bmad-method@$BMAD_VERSION install --directory `"$targetDir`" -y --modules $BMAD_MODULES --tools $BMAD_TOOLS --custom-content `"$ModulePath`""
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "BMAD install failed (exit $LASTEXITCODE)"
        Write-Info "Leaving temp clone in place for debugging: $ModulePath"
        exit 1
    }

    Write-Host ""

    # Sanity checks - verify teambuilder landed in the installed _bmad tree
    # (note: module.yaml is installer metadata and is NOT copied into the installed
    #  tree; we verify config.yaml + agents/ + skills/ which ARE copied)
    if (-not (Test-Path "_bmad\teambuilder\config.yaml")) {
        Write-Fail "Post-install check failed: _bmad\teambuilder\config.yaml not found"
        Write-Info "BMAD reported success but the teambuilder module was not installed."
        exit 1
    }
    if (-not (Test-Path "_bmad\teambuilder\agents")) {
        Write-Fail "Post-install check failed: _bmad\teambuilder\agents\ not found"
        exit 1
    }
    if (-not (Test-Path "_bmad\teambuilder\skills")) {
        Write-Fail "Post-install check failed: _bmad\teambuilder\skills\ not found"
        exit 1
    }
    if (-not (Test-Path "_bmad\_config\agent-manifest.csv")) {
        Write-Fail "Post-install check failed: agent-manifest.csv not found"
        exit 1
    }

    # Count teambuilder entries in the manifest
    $agentCsv = Get-Content "_bmad\_config\agent-manifest.csv"
    $tbAgents = ($agentCsv | Select-String -Pattern '"teambuilder"').Count
    $skillCsv = Get-Content "_bmad\_config\skill-manifest.csv"
    $tbSkills = ($skillCsv | Select-String -Pattern '"teambuilder"').Count

    Write-Success "Installed BMAD $BMAD_VERSION + TeamBuilder module"
    Write-Info "  Agents registered:  $tbAgents"
    Write-Info "  Skills registered:  $tbSkills"
    Write-Host ""
}

# =============================================================================
# Write .mcp.json
# =============================================================================

function Write-McpConfig {
    if ($NoMcp) {
        Write-Info "Skipping .mcp.json (-NoMcp specified)"
        return
    }

    Write-Header "Configuring MCP Servers"

    if (Test-Path ".mcp.json") {
        Write-Warn ".mcp.json already exists - leaving it untouched"
        Write-Info "If you want TeamBuilder's MCP defaults, back up .mcp.json and re-run."
        return
    }

    $memoryPath = Join-Path (Get-Location).Path "_bmad\teambuilder\memory\general-knowledge.jsonl"
    # Ensure the memory file exists (BMAD copied the empty seed already, but just in case)
    $memoryDir = Split-Path $memoryPath -Parent
    if (-not (Test-Path $memoryDir)) { New-Item -ItemType Directory -Path $memoryDir -Force | Out-Null }
    if (-not (Test-Path $memoryPath)) { New-Item -ItemType File -Path $memoryPath -Force | Out-Null }

    # Double backslashes for JSON escaping
    $memoryPathJson = $memoryPath -replace '\\','\\'

    $mcpServers = @{}
    $mcpServers["memory"] = @{
        command = "npx"
        args = @("-y", "@modelcontextprotocol/server-memory")
        env = @{ MEMORY_FILE_PATH = $memoryPath }
    }

    if (-not $NoPlaywright) {
        $mcpServers["playwright"] = @{
            command = "npx"
            args = @("-y", "@playwright/mcp@latest")
        }
    }

    $mcpJson = @{ mcpServers = $mcpServers } | ConvertTo-Json -Depth 10
    Set-Content -Path ".mcp.json" -Value $mcpJson -Encoding UTF8

    Write-Success "Wrote .mcp.json"
    Write-Info "  memory server   -> $memoryPath"
    if (-not $NoPlaywright) { Write-Info "  playwright      -> @playwright/mcp@latest" }
    Write-Host ""
}

# =============================================================================
# Docs folder and .gitignore
# =============================================================================

function Initialize-ProjectFiles {
    Write-Header "Finalizing Project Structure"

    if (-not (Test-Path "docs")) {
        New-Item -ItemType Directory -Path "docs" | Out-Null
        Write-Success "Created docs/ (team knowledge base)"
    } else {
        Write-Info "docs/ already exists - leaving alone"
    }

    $gitignorePath = ".gitignore"
    $tbLines = @(
        ""
        "# --- TeamBuilder / BMAD v6 ---"
        "# Team-specific memory files (per generated team, local-only)"
        "_bmad-output/teams/*/memory.jsonl"
        "_bmad-output/teams/*/session-context.md"
        "# BMAD output folder can grow large; track it selectively"
        "# _bmad-output/"
        ""
    )

    if (Test-Path $gitignorePath) {
        $existing = Get-Content $gitignorePath -Raw
        if ($existing -notmatch '_bmad-output/teams/\*/memory\.jsonl') {
            Add-Content -Path $gitignorePath -Value ($tbLines -join "`r`n")
            Write-Success "Appended TeamBuilder rules to .gitignore"
        } else {
            Write-Info ".gitignore already has TeamBuilder rules"
        }
    } else {
        Set-Content -Path $gitignorePath -Value ($tbLines -join "`r`n") -Encoding UTF8
        Write-Success "Created .gitignore with TeamBuilder rules"
    }
    Write-Host ""
}

# =============================================================================
# Cleanup + success
# =============================================================================

function Remove-TempClone {
    param([string]$TempBase)
    if ([string]::IsNullOrWhiteSpace($TempBase)) { return }  # LocalSource flow, nothing to clean
    if (Test-Path $TempBase) {
        try {
            Remove-Item $TempBase -Recurse -Force -ErrorAction Stop
            Write-Success "Cleaned up temp clone"
        } catch {
            Write-Warn "Could not remove temp clone at $TempBase (you may delete it manually)"
        }
    }
}

function Show-Success {
    Write-Host ""
    Write-Host "  +---------------------------------------------------+" -ForegroundColor Green
    Write-Host "  |            Installation Complete!                 |" -ForegroundColor Green
    Write-Host "  +---------------------------------------------------+" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Next steps:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. Open this directory in Claude Code (CLI or desktop app)" -ForegroundColor White
    Write-Host "  2. Restart Claude Code so it discovers the new .claude/skills/" -ForegroundColor White
    Write-Host "  3. Invoke the TeamBuilder Guide:" -ForegroundColor White
    Write-Host ""
    Write-Host "       /bmad-agent-team-guide" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  4. Follow the guided discovery to build your first team." -ForegroundColor White
    Write-Host ""
    Write-Host "  Available agents:" -ForegroundColor Cyan
    Write-Host "    /bmad-agent-team-guide        - Main entry point" -ForegroundColor Gray
    Write-Host "    /bmad-agent-team-architect    - Structural designer" -ForegroundColor Gray
    Write-Host "    /bmad-agent-persona-improver  - Persona quality specialist" -ForegroundColor Gray
    Write-Host "    /bmad-agent-quality-guardian  - Validation reviewer" -ForegroundColor Gray
    Write-Host "    /bmad-agent-tool-scout        - MCP/tool researcher" -ForegroundColor Gray
    Write-Host "    /bmad-agent-memory-manager    - Cross-team memory consolidation" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Docs: https://github.com/dexusno/teambuilder" -ForegroundColor Cyan
    Write-Host ""
}

# =============================================================================
# Main
# =============================================================================

Show-Banner

if ($Channel -ne "stable") {
    Write-Host ""
    Write-Host "  +---------------------------------------------------+" -ForegroundColor DarkYellow
    Write-Host ("  |  Non-stable channel selected: " + $Channel.PadRight(20) + "|") -ForegroundColor DarkYellow
    Write-Host ("  |  Resolved BMAD version:       " + $BMAD_VERSION.PadRight(20) + "|") -ForegroundColor DarkYellow
    Write-Host "  |  This is UNSUPPORTED. Stability not guaranteed.   |" -ForegroundColor DarkYellow
    Write-Host "  +---------------------------------------------------+" -ForegroundColor DarkYellow
    Write-Host ""
    if (-not $Yes) {
        $reply = Read-Host "  Continue with $Channel channel? [y/N]"
        if ($reply -notmatch '^[Yy]') {
            Write-Info "Aborted by user."
            exit 0
        }
    }
}

Test-Prerequisites
Test-NotAlreadyInstalled

$source = Get-TeambuilderSource
try {
    Install-Bmad -ModulePath $source.ModulePath
    Write-McpConfig
    Initialize-ProjectFiles
} finally {
    Remove-TempClone -TempBase $source.TempBase
}

Show-Success
