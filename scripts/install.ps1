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
    Write-Host "  +-------------------------------------------------+" -ForegroundColor Magenta
    Write-Host "  |        TeamBuilder Project Installer            |" -ForegroundColor Magenta
    Write-Host "  |        github.com/dexusno/teambuilder           |" -ForegroundColor Magenta
    Write-Host "  +-------------------------------------------------+" -ForegroundColor Magenta
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
        Write-Fail "Error installing ${DisplayName}: $_"
        return $false
    }
}

# Main installation flow
function Main {
    # Initialize variables
    $installClaudeCode = $false

    Show-Banner

    # ===== STEP 1: Check Claude Code =====
    Write-Header "Step 1: Checking Claude Code"

    if (Test-Command "claude") {
        Write-Success "Claude Code found"
    } else {
        Write-Fail "Claude Code not found"
        Write-Host ""
        Write-Host "  Claude Code is required for this project." -ForegroundColor Yellow
        Write-Host "  More info: https://claude.ai" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  1. I have Claude Code - install it now" -ForegroundColor White
        Write-Host "  2. Exit" -ForegroundColor White
        Write-Host ""

        $choice = Read-Host "  Select option (1-2)"

        if ($choice -ne "1") {
            Write-Host ""
            Write-Info "Visit https://claude.ai to learn more."
            Write-Info "Run this installer again when ready."
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
        Write-Success "Node.js v${nodeVersion}"
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
        Write-Success "Git v${gitVersion}"
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
        Write-Success "Using current directory: ${targetDir}"
    } else {
        Write-Info "Current directory is not empty."
        $continue = Read-Host "  Continue installation here? (y/N)"
        if ($continue -notmatch "^[Yy]") {
            Write-Info "Installation cancelled. Create a new folder for your project and run again."
            exit 0
        }
        Write-Success "Using current directory: ${targetDir}"
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
            Write-Host "    2. Create team: /bmad-agent-teambuilder-teambuilder-guide" -ForegroundColor Gray
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
    Write-Step "Installing BMAD Method..."
    npx bmad-method@latest install
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "Failed to install BMAD Method"
        exit 1
    }

    # Verify BMAD installed
    if (-not (Test-Path "_bmad")) {
        Write-Fail "BMAD Method installation failed - _bmad folder not created"
        exit 1
    }
    Write-Success "BMAD Method installed"

    # Clone TeamBuilder module
    Write-Step "Installing TeamBuilder module..."
    $teambuilderDir = "_bmad\teambuilder"

    if (Test-Path $teambuilderDir) {
        Remove-Item -Recurse -Force $teambuilderDir
    }

    # Clone and check for errors
    $cloneOutput = git clone --depth 1 https://github.com/dexusno/teambuilder.git temp-teambuilder 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "Failed to clone TeamBuilder repository"
        Write-Info "Error: ${cloneOutput}"
        exit 1
    }

    # Verify and move
    if (Test-Path "temp-teambuilder\teambuilder") {
        Move-Item "temp-teambuilder\teambuilder" $teambuilderDir
    } else {
        Write-Fail "TeamBuilder module not found in cloned repository"
        Remove-Item -Recurse -Force "temp-teambuilder" -ErrorAction SilentlyContinue
        exit 1
    }
    Remove-Item -Recurse -Force "temp-teambuilder" -ErrorAction SilentlyContinue

    # Verify TeamBuilder installed
    if (-not (Test-Path $teambuilderDir)) {
        Write-Fail "TeamBuilder installation failed"
        exit 1
    }
    Write-Success "TeamBuilder module installed"

    # Register TeamBuilder in manifests
    Write-Step "Registering TeamBuilder in BMAD manifests..."

    $agentManifest = "_bmad\_config\agent-manifest.csv"
    $manifestEntries = "_bmad\teambuilder\agent-manifest-entries.csv"

    if (-not (Test-Path $agentManifest)) {
        Write-Fail "Agent manifest not found at ${agentManifest}"
        Write-Info "BMAD may not have installed correctly"
        exit 1
    }

    if (-not (Test-Path $manifestEntries)) {
        Write-Fail "TeamBuilder manifest entries not found"
        Write-Info "TeamBuilder module may be incomplete"
        exit 1
    }

    $entries = Get-Content $manifestEntries
    Add-Content -Path $agentManifest -Value $entries

    # 2. Add teambuilder module entry to manifest.yaml (beta format)
    $mainManifest = "_bmad\_config\manifest.yaml"
    if (Test-Path $mainManifest) {
        $mContent = Get-Content $mainManifest -Raw
        if ($mContent -notmatch "teambuilder") {
            $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
            $mLines = Get-Content $mainManifest
            $newLines = [System.Collections.ArrayList]::new()
            foreach ($mLine in $mLines) {
                if ($mLine -match "^ides:") {
                    [void]$newLines.Add("  - name: teambuilder")
                    [void]$newLines.Add("    version: `"2.0`"")
                    [void]$newLines.Add("    installDate: $timestamp")
                    [void]$newLines.Add("    lastUpdated: $timestamp")
                    [void]$newLines.Add("    source: external")
                    [void]$newLines.Add("    npmPackage: null")
                    [void]$newLines.Add("    repoUrl: https://github.com/dexusno/teambuilder")
                }
                [void]$newLines.Add($mLine)
            }
            Set-Content -Path $mainManifest -Value $newLines
        }
    }

    # 3. Register workflows in workflow-manifest.csv
    $workflowManifest = "_bmad\_config\workflow-manifest.csv"
    if (Test-Path $workflowManifest) {
        $wfContent = Get-Content $workflowManifest -Raw
        if ($wfContent -notmatch "teambuilder") {
            $workflowEntries = @(
                '"collaborative-generation","Three-agent collaboration workflow for high-quality team generation","teambuilder","_bmad/teambuilder/workflows/collaborative-generation/workflow.yaml"'
                '"discover-team-needs","Discover user requirements through guided questions","teambuilder","_bmad/teambuilder/workflows/1-discovery/discover-team-needs/workflow.yaml"'
                '"generate-team","Generate custom team with distinct personas and workflows","teambuilder","_bmad/teambuilder/workflows/2-generation/generate-team/workflow.yaml"'
                '"validate-team","Validate generated team quality through scoring and assessment","teambuilder","_bmad/teambuilder/workflows/2-generation/validate-team/workflow.yaml"'
                '"refine-team","Refine generated team through targeted improvements","teambuilder","_bmad/teambuilder/workflows/3-refinement/refine-team/workflow.yaml"'
            )
            Add-Content -Path $workflowManifest -Value ($workflowEntries -join "`r`n")
        }
    }

    # 4. Create Claude Code command file (flat format, teambuilder-guide only)
    $commandsDir = ".claude\commands"
    if (-not (Test-Path $commandsDir)) {
        New-Item -ItemType Directory -Path $commandsDir -Force | Out-Null
    }
    $commandContent = @"
---
name: 'teambuilder-guide'
description: 'Team Generation Guide'
disable-model-invocation: true
---

You must fully embody this agent's persona and follow all activation instructions exactly as specified. NEVER break character until given an exit command.

<agent-activation CRITICAL="TRUE">
1. LOAD the FULL agent file from {project-root}/_bmad/teambuilder/agents/teambuilder-guide.md
2. READ its entire contents - this contains the complete agent persona, menu, and instructions
3. FOLLOW every step in the <activation> section precisely
4. DISPLAY the welcome/greeting as instructed
5. PRESENT the numbered menu
6. WAIT for user input before proceeding
</agent-activation>
"@
    Set-Content -Path "$commandsDir\bmad-agent-teambuilder-teambuilder-guide.md" -Value $commandContent

    # 5. Inject core config values into TeamBuilder config.yaml
    $coreConfig = "_bmad\core\config.yaml"
    $tbConfig = "_bmad\teambuilder\config.yaml"
    if ((Test-Path $coreConfig) -and (Test-Path $tbConfig)) {
        $coreLines = Get-Content $coreConfig
        $coreVars = @{}
        foreach ($cl in $coreLines) {
            if ($cl -match "^(user_name|communication_language|document_output_language|output_folder):\s*(.+)$") {
                $coreVars[$Matches[1]] = $Matches[2].Trim()
            }
        }
        if ($coreVars.Count -gt 0) {
            $tbContent = Get-Content $tbConfig -Raw
            $headerLines = @(
                "# Core Configuration (from BMAD core)"
                "user_name: $($coreVars['user_name'])"
                "communication_language: $($coreVars['communication_language'])"
                "document_output_language: $($coreVars['document_output_language'])"
                "output_folder: $($coreVars['output_folder'])"
                ""
            )
            $header = ($headerLines -join "`r`n") + "`r`n"
            Set-Content -Path $tbConfig -Value ($header + $tbContent) -NoNewline
        }
    }

    Write-Success "TeamBuilder registered"

    # Create .mcp.json
    Write-Step "Creating MCP configuration..."

    $mcpConfig = @{
        mcpServers = @{}
    }

    if ($installMemoryMCP) {
        $mcpConfig.mcpServers["memory"] = @{
            command = "cmd"
            args = @("/c", "npx", "-y", "@modelcontextprotocol/server-memory")
        }
    }

    if ($installPlaywrightMCP) {
        $mcpConfig.mcpServers["playwright"] = @{
            command = "cmd"
            args = @("/c", "npx", "-y", "@playwright/mcp")
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

    $folderName = Split-Path $targetDir -Leaf
    Write-Host "  +-------------------------------------------------------------+" -ForegroundColor Green
    Write-Host "  |  Success! Your project is ready.                            |" -ForegroundColor Green
    Write-Host "  |                                                             |" -ForegroundColor Green
    Write-Host "  |  Next steps:                                                |" -ForegroundColor Green
    Write-Host "  |    1. Open terminal in this folder                          |" -ForegroundColor Green
    Write-Host "  |    2. Run: claude .                                         |" -ForegroundColor Green
    Write-Host "  |    3. Type: /bmad-agent-teambuilder-teambuilder-guide       |" -ForegroundColor Green
    Write-Host "  |                                                             |" -ForegroundColor Green
    Write-Host "  |  Happy team building!                                       |" -ForegroundColor Green
    Write-Host "  +-------------------------------------------------------------+" -ForegroundColor Green
    Write-Host ""
}

# Run main
Main
