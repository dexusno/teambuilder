<#
.SYNOPSIS
    TeamBuilder Project Installer for Windows
.DESCRIPTION
    Installs BMAD Method + TeamBuilder module with all prerequisites.
    Creates a ready-to-use project for building AI agent teams.
    Run this script from inside your project folder.
.EXAMPLE
    mkdir my-project
    cd my-project
    .\install.ps1
.LINK
    https://github.com/dexusno/teambuilder
#>

$ErrorActionPreference = "Stop"

# Colors and formatting
function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host ("=" * 55) -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host ("=" * 55) -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Text)
    Write-Host "  -> $Text" -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Text)
    Write-Host "  [OK] $Text" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Text)
    Write-Host "  [X] $Text" -ForegroundColor Red
}

function Write-Info {
    param([string]$Text)
    Write-Host "  $Text" -ForegroundColor Gray
}

# Banner
function Show-Banner {
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "  ║        TeamBuilder Project Installer              ║" -ForegroundColor Magenta
    Write-Host "  ║        github.com/dexusno/teambuilder             ║" -ForegroundColor Magenta
    Write-Host "  ╚═══════════════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""
}

# Check if command exists
function Test-Command {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Get command version
function Get-CommandVersion {
    param([string]$Command)
    try {
        switch ($Command) {
            "node" { (node --version) -replace 'v', '' }
            "npm" { npm --version }
            "git" { (git --version) -replace 'git version ', '' }
            "claude" { "installed" }
            default { "unknown" }
        }
    } catch {
        "unknown"
    }
}

# Install via winget
function Install-WithWinget {
    param(
        [string]$PackageId,
        [string]$DisplayName
    )

    Write-Step "Installing $DisplayName via winget..."

    try {
        winget install $PackageId --accept-package-agreements --accept-source-agreements --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$DisplayName installed"
            # Refresh PATH
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            return $true
        } else {
            Write-Fail "Failed to install $DisplayName"
            return $false
        }
    } catch {
        Write-Fail "Error installing $DisplayName: $_"
        return $false
    }
}

# Main installation flow
function Main {
    Show-Banner

    # ===== STEP 1: Check Claude Code =====
    Write-Header "Step 1: Checking Claude Code"

    if (Test-Command "claude") {
        Write-Success "Claude Code found"
    } else {
        Write-Fail "Claude Code not found"
        Write-Host ""
        Write-Host "  ╔═══════════════════════════════════════════════════╗" -ForegroundColor Yellow
        Write-Host "  ║  Claude Code is REQUIRED for this project.        ║" -ForegroundColor Yellow
        Write-Host "  ║                                                   ║" -ForegroundColor Yellow
        Write-Host "  ║  It requires a paid Claude subscription:          ║" -ForegroundColor Yellow
        Write-Host "  ║    - Pro: `$20/month                               ║" -ForegroundColor Yellow
        Write-Host "  ║    - Max: `$100-200/month                          ║" -ForegroundColor Yellow
        Write-Host "  ║    - Or API credits                               ║" -ForegroundColor Yellow
        Write-Host "  ║                                                   ║" -ForegroundColor Yellow
        Write-Host "  ║  More info: https://claude.ai/pricing             ║" -ForegroundColor Yellow
        Write-Host "  ╚═══════════════════════════════════════════════════╝" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  1. I have a Claude account - proceed with setup" -ForegroundColor White
        Write-Host "  2. I don't have a Claude account - exit" -ForegroundColor White
        Write-Host ""

        $choice = Read-Host "  Select option (1-2)"

        if ($choice -ne "1") {
            Write-Host ""
            Write-Info "Visit https://claude.ai/pricing to sign up."
            Write-Info "Run this installer again after subscribing."
            Write-Host ""
            exit 0
        }

        # User has account, will install Claude Code after Node.js
        $installClaudeCode = $true
    }

    # ===== STEP 2: Check/Install Prerequisites =====
    Write-Header "Step 2: Checking Prerequisites"

    # Check winget
    if (-not (Test-Command "winget")) {
        Write-Fail "winget not found. Please install App Installer from Microsoft Store."
        Write-Info "https://aka.ms/getwinget"
        exit 1
    }
    Write-Success "winget available"

    # Check/Install Node.js
    if (Test-Command "node") {
        $nodeVersion = Get-CommandVersion "node"
        Write-Success "Node.js v$nodeVersion"
    } else {
        Write-Fail "Node.js not found"
        Write-Host ""
        $install = Read-Host "  Install Node.js? (Y/n)"
        if ($install -eq "" -or $install -match "^[Yy]") {
            if (-not (Install-WithWinget "OpenJS.NodeJS.LTS" "Node.js")) {
                exit 1
            }
        } else {
            Write-Info "Node.js is required. Exiting."
            exit 1
        }
    }

    # Check/Install Git
    if (Test-Command "git") {
        $gitVersion = Get-CommandVersion "git"
        Write-Success "Git v$gitVersion"
    } else {
        Write-Fail "Git not found"
        Write-Host ""
        $install = Read-Host "  Install Git? (Y/n)"
        if ($install -eq "" -or $install -match "^[Yy]") {
            if (-not (Install-WithWinget "Git.Git" "Git")) {
                exit 1
            }
        } else {
            Write-Info "Git is required. Exiting."
            exit 1
        }
    }

    # Install Claude Code if needed
    if ($installClaudeCode) {
        Write-Step "Installing Claude Code via npm..."
        npm install -g @anthropic-ai/claude-code
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Claude Code installed"
        } else {
            Write-Fail "Failed to install Claude Code"
            Write-Info "Try manually: npm install -g @anthropic-ai/claude-code"
            exit 1
        }
    }

    Write-Success "All prerequisites satisfied"

    # ===== STEP 3: Project Folder =====
    Write-Header "Step 3: Project Folder"

    $targetDir = Get-Location
    $items = Get-ChildItem -Force | Where-Object { $_.Name -notmatch "^install\.(ps1|sh)$" }

    if ($items.Count -eq 0) {
        Write-Success "Using current directory: $targetDir"
    } else {
        Write-Info "Current directory is not empty."
        $continue = Read-Host "  Continue installation here? (y/N)"
        if ($continue -notmatch "^[Yy]") {
            Write-Info "Installation cancelled. Create a new folder for your project and run again."
            exit 0
        }
        Write-Success "Using current directory: $targetDir"
    }

    # ===== STEP 4: Main Menu =====
    Write-Header "Step 4: Installation Options"

    Write-Host "  1. Full Install (recommended)" -ForegroundColor White
    Write-Host "  2. Custom Install" -ForegroundColor White
    Write-Host "  3. Help / Documentation" -ForegroundColor White
    Write-Host "  4. Exit" -ForegroundColor White
    Write-Host ""

    $menuChoice = Read-Host "  Select option (1-4)"

    # Default options
    $installMemoryMCP = $true
    $installPlaywrightMCP = $true
    $initGit = $false

    switch ($menuChoice) {
        "1" {
            # Full install - use defaults
        }
        "2" {
            # Custom install
            Write-Host ""
            Write-Host "  Select components (Y/n for each):" -ForegroundColor Cyan
            Write-Host ""

            $memoryChoice = Read-Host "  Install Memory MCP? (Y/n)"
            $installMemoryMCP = ($memoryChoice -eq "" -or $memoryChoice -match "^[Yy]")

            $playwrightChoice = Read-Host "  Install Playwright MCP? (Y/n)"
            $installPlaywrightMCP = ($playwrightChoice -eq "" -or $playwrightChoice -match "^[Yy]")

            $gitChoice = Read-Host "  Initialize Git repository? (y/N)"
            $initGit = ($gitChoice -match "^[Yy]")
        }
        "3" {
            Write-Host ""
            Write-Host "  TeamBuilder creates AI agent teams using the BMAD Method." -ForegroundColor Cyan
            Write-Host ""
            Write-Host "  After installation:" -ForegroundColor White
            Write-Host "    1. Open project: claude ." -ForegroundColor Gray
            Write-Host "    2. Create team: /bmad:teambuilder:agents:teambuilder-guide" -ForegroundColor Gray
            Write-Host ""
            Write-Host "  Documentation: https://github.com/dexusno/teambuilder" -ForegroundColor Gray
            Write-Host ""
            exit 0
        }
        default {
            Write-Info "Installation cancelled."
            exit 0
        }
    }

    # ===== STEP 5: Installation =====
    Write-Header "Step 5: Installing"

    # Install BMAD Method
    Write-Step "Installing BMAD Method (latest alpha)..."
    npx bmad-method@alpha install
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "Failed to install BMAD Method"
        exit 1
    }
    Write-Success "BMAD Method installed"

    # Clone TeamBuilder module
    Write-Step "Installing TeamBuilder module..."
    $teambuilderDir = "_bmad\teambuilder"

    if (Test-Path $teambuilderDir) {
        Remove-Item -Recurse -Force $teambuilderDir
    }

    git clone --depth 1 https://github.com/dexusno/teambuilder.git temp-teambuilder 2>$null
    if (Test-Path "temp-teambuilder\teambuilder") {
        Move-Item "temp-teambuilder\teambuilder" $teambuilderDir
    }
    Remove-Item -Recurse -Force "temp-teambuilder" -ErrorAction SilentlyContinue
    Write-Success "TeamBuilder module installed"

    # Register TeamBuilder in manifests
    Write-Step "Registering TeamBuilder in BMAD manifests..."

    $agentManifest = "_bmad\_config\agent-manifest.csv"
    $manifestEntries = "_bmad\teambuilder\agent-manifest-entries.csv"
    if ((Test-Path $agentManifest) -and (Test-Path $manifestEntries)) {
        $entries = Get-Content $manifestEntries
        Add-Content -Path $agentManifest -Value $entries
    }
    Write-Success "TeamBuilder registered"

    # Create .mcp.json
    Write-Step "Creating MCP configuration..."

    $mcpConfig = @{
        mcpServers = @{}
    }

    if ($installMemoryMCP) {
        $mcpConfig.mcpServers["memory"] = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-memory")
        }
    }

    if ($installPlaywrightMCP) {
        $mcpConfig.mcpServers["playwright"] = @{
            command = "npx"
            args = @("-y", "@anthropic/mcp-playwright")
        }
    }

    $mcpConfig | ConvertTo-Json -Depth 4 | Set-Content ".mcp.json"
    Write-Success "MCP configuration created"

    # Create .gitignore
    Write-Step "Creating .gitignore..."
    @"
# Dependencies
node_modules/

# Local settings
.claude/settings.local.json

# Environment files
.env
.env.local

# OS files
.DS_Store
Thumbs.db

# Playwright artifacts
.playwright-mcp/
"@ | Set-Content ".gitignore"
    Write-Success ".gitignore created"

    # Initialize Git if requested
    if ($initGit) {
        Write-Step "Initializing Git repository..."
        git init
        git add .
        git commit -m "Initial commit: BMAD + TeamBuilder project"
        Write-Success "Git repository initialized"
    }

    # ===== STEP 6: Complete =====
    Write-Header "Installation Complete!"

    Write-Host "  ╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "  ║  Success! Your project is ready.                  ║" -ForegroundColor Green
    Write-Host "  ║                                                   ║" -ForegroundColor Green
    Write-Host "  ║  Next steps:                                      ║" -ForegroundColor Green
    Write-Host "  ║    1. cd $(Split-Path $targetDir -Leaf)" -ForegroundColor Green
    Write-Host "  ║    2. claude .                                    ║" -ForegroundColor Green
    Write-Host "  ║    3. /bmad:teambuilder:agents:teambuilder-guide  ║" -ForegroundColor Green
    Write-Host "  ║                                                   ║" -ForegroundColor Green
    Write-Host "  ║  Happy team building!                             ║" -ForegroundColor Green
    Write-Host "  ╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
}

# Run main
Main
