#!/usr/bin/env bash
# =============================================================================
# TeamBuilder v3 Project Installer for Linux/macOS (BMAD v6.2.2)
# =============================================================================
#
# Installs BMAD Method v6 core + bmm module + the TeamBuilder custom module
# into the CURRENT DIRECTORY, and configures Claude Code + Memory/Playwright MCP.
#
# This is the BMAD v6 installer. It uses BMAD's native --custom-content flow
# to register TeamBuilder as a first-class v6 custom module. No manual manifest
# editing, no .claude/commands/ stubs, no file-triad workflows — BMAD auto-generates
# everything from the TeamBuilder module's SKILL.md + bmad-skill-manifest.yaml files.
#
# Flags:
#   -y                    Accept all defaults, no prompts
#   --no-mcp              Skip .mcp.json creation
#   --no-playwright       Skip Playwright MCP server in .mcp.json
#   --branch NAME         Git branch to clone (default: main)
#   --local-source PATH   Use a local module directory instead of cloning
#                         (for maintainers testing changes pre-commit)
#
# Usage:
#   mkdir my-project && cd my-project
#   ./install-v6.sh
#
#   # Maintainer test flow:
#   ./install.sh -y --local-source /path/to/teambuilder
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
TEAMBUILDER_REPO="https://github.com/dexusno/teambuilder.git"
TEAMBUILDER_MODULE_PATH="teambuilder"     # Module directory within the cloned repo
BMAD_VERSION="6.2.2"                      # Pinned stable version (channel: stable)
BMAD_MODULES="bmm"
BMAD_TOOLS="claude-code"

# -----------------------------------------------------------------------------
# Flags
# -----------------------------------------------------------------------------
YES_FLAG=0
NO_MCP=0
NO_PLAYWRIGHT=0
BRANCH="main"
LOCAL_SOURCE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes) YES_FLAG=1; shift ;;
        --no-mcp) NO_MCP=1; shift ;;
        --no-playwright) NO_PLAYWRIGHT=1; shift ;;
        --branch) BRANCH="$2"; shift 2 ;;
        --local-source) LOCAL_SOURCE="$2"; shift 2 ;;
        -h|--help)
            grep '^#' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

# -----------------------------------------------------------------------------
# Console formatting
# -----------------------------------------------------------------------------
if [[ -t 1 ]]; then
    C_RESET=$'\033[0m'
    C_CYAN=$'\033[36m'
    C_GREEN=$'\033[32m'
    C_RED=$'\033[31m'
    C_YELLOW=$'\033[33m'
    C_MAGENTA=$'\033[35m'
    C_GRAY=$'\033[90m'
    C_WHITE=$'\033[97m'
else
    C_RESET=""; C_CYAN=""; C_GREEN=""; C_RED=""; C_YELLOW=""; C_MAGENTA=""; C_GRAY=""; C_WHITE=""
fi

header()  { printf "\n${C_CYAN}%s${C_RESET}\n  ${C_CYAN}%s${C_RESET}\n${C_CYAN}%s${C_RESET}\n\n" \
            "============================================================" "$1" \
            "============================================================"; }
step()    { printf "  ${C_YELLOW}-> %s${C_RESET}\n" "$1"; }
ok()      { printf "  ${C_GREEN}[OK] %s${C_RESET}\n" "$1"; }
fail()    { printf "  ${C_RED}[X]  %s${C_RESET}\n" "$1"; }
warn()    { printf "  ${C_YELLOW}[!]  %s${C_RESET}\n" "$1"; }
info()    { printf "  ${C_GRAY}%s${C_RESET}\n" "$1"; }

banner() {
    printf "\n"
    printf "  ${C_MAGENTA}+---------------------------------------------------+${C_RESET}\n"
    printf "  ${C_MAGENTA}|   TeamBuilder v3 Installer (BMAD v6.2.2)          |${C_RESET}\n"
    printf "  ${C_MAGENTA}|   github.com/dexusno/teambuilder                  |${C_RESET}\n"
    printf "  ${C_MAGENTA}+---------------------------------------------------+${C_RESET}\n\n"
}

confirm() {
    local prompt="$1"
    local default="${2:-y}"
    if [[ $YES_FLAG -eq 1 ]]; then
        [[ "$default" == "y" ]]
        return $?
    fi
    local suffix="[Y/n]"
    [[ "$default" == "n" ]] && suffix="[y/N]"
    read -r -p "  $prompt $suffix " reply
    reply="${reply:-$default}"
    [[ "$reply" =~ ^[Yy] ]]
}

has_cmd() { command -v "$1" >/dev/null 2>&1; }

# -----------------------------------------------------------------------------
# Prerequisite checks
# -----------------------------------------------------------------------------
check_prerequisites() {
    header "Checking Prerequisites"
    local missing=()

    if has_cmd node; then
        local nv
        nv="$(node --version | sed 's/^v//')"
        ok "Node.js $nv"
        local major="${nv%%.*}"
        if [[ "$major" -lt 18 ]]; then
            warn "Node.js >= 18 recommended (you have $nv)"
        fi
    else
        fail "Node.js not found"
        missing+=("Node.js (https://nodejs.org/)")
    fi

    if has_cmd npm; then
        ok "npm $(npm --version)"
    else
        fail "npm not found"
        missing+=("npm (ships with Node.js)")
    fi

    if has_cmd git; then
        ok "git $(git --version | sed 's/^git version //')"
    else
        fail "git not found"
        missing+=("git (https://git-scm.com/)")
    fi

    if has_cmd claude; then
        ok "Claude Code CLI detected (optional — desktop app works too)"
    else
        info "Claude Code CLI not in PATH (the desktop app works fine too)"
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        printf "\n"
        fail "Missing required tools:"
        for m in "${missing[@]}"; do printf "    ${C_RED}- %s${C_RESET}\n" "$m"; done
        printf "\n  ${C_RED}Install them and re-run this script.${C_RESET}\n"
        exit 1
    fi
    printf "\n"
}

# -----------------------------------------------------------------------------
# Refuse-if-exists guard
# -----------------------------------------------------------------------------
check_not_already_installed() {
    header "Checking Target Directory"
    info "Target: $(pwd)"

    if [[ -d "_bmad/teambuilder" ]]; then
        printf "\n"
        fail "TeamBuilder is already installed in this directory."
        printf "\n"
        printf "  ${C_RED}Found: _bmad/teambuilder/${C_RESET}\n\n"
        printf "  ${C_YELLOW}To update TeamBuilder, use scripts/update-v6.sh (coming in Phase 6).${C_RESET}\n"
        printf "  ${C_YELLOW}To diagnose issues,  use scripts/doctor-v6.sh (coming in Phase 6).${C_RESET}\n\n"
        printf "  ${C_YELLOW}If you want a fresh install, manually remove _bmad/ first (this will${C_RESET}\n"
        printf "  ${C_YELLOW}delete your current BMAD installation including any generated teams!).${C_RESET}\n\n"
        exit 1
    fi

    if [[ -d "_bmad" ]]; then
        warn "_bmad/ already exists (BMAD is installed, but TeamBuilder is not)"
        info "This installer will ADD TeamBuilder to your existing BMAD installation."
        info "Core and BMM modules will not be touched."
        if ! confirm "Proceed?" "y"; then
            info "Aborted."
            exit 0
        fi
    else
        ok "Clean directory — full BMAD + TeamBuilder install will proceed"
    fi
    printf "\n"
}

# -----------------------------------------------------------------------------
# Clone teambuilder repo to temp
# -----------------------------------------------------------------------------
TEMP_BASE=""
cleanup_temp() {
    if [[ -n "$TEMP_BASE" && -d "$TEMP_BASE" ]]; then
        if rm -rf "$TEMP_BASE" 2>/dev/null; then
            ok "Cleaned up temp clone"
        else
            warn "Could not remove temp clone at $TEMP_BASE (you may delete it manually)"
        fi
    fi
}
trap cleanup_temp EXIT

fetch_teambuilder_source() {
    header "Fetching TeamBuilder Module Source"

    # Maintainer flow: use a local directory instead of cloning
    if [[ -n "$LOCAL_SOURCE" ]]; then
        step "Using local source: $LOCAL_SOURCE"
        if [[ ! -d "$LOCAL_SOURCE" ]]; then
            fail "--local-source path does not exist: $LOCAL_SOURCE"
            exit 1
        fi
        if [[ ! -f "$LOCAL_SOURCE/module.yaml" ]]; then
            fail "--local-source does not contain module.yaml: $LOCAL_SOURCE"
            info "Must point at a valid BMAD custom module directory."
            exit 1
        fi
        MODULE_PATH="$(cd "$LOCAL_SOURCE" && pwd)"
        TEMP_BASE=""  # nothing to clean up
        ok "Using local TeamBuilder module source (no clone)"
        printf "\n"
        return
    fi

    # Normal flow: clone from remote
    TEMP_BASE="$(mktemp -d -t teambuilder-install-XXXXXXXX)"
    step "Cloning $TEAMBUILDER_REPO (branch: $BRANCH) to temp..."
    info "Temp: $TEMP_BASE"

    if ! git clone --depth 1 --branch "$BRANCH" "$TEAMBUILDER_REPO" "$TEMP_BASE" >/dev/null 2>&1; then
        fail "Failed to clone teambuilder repo"
        exit 1
    fi

    MODULE_PATH="$TEMP_BASE/$TEAMBUILDER_MODULE_PATH"
    if [[ ! -d "$MODULE_PATH" ]]; then
        fail "Cloned repo does not contain '$TEAMBUILDER_MODULE_PATH/'"
        info "The teambuilder repo layout may have changed."
        info "Check https://github.com/dexusno/teambuilder for updates."
        exit 1
    fi
    if [[ ! -f "$MODULE_PATH/module.yaml" ]]; then
        fail "Module source is missing module.yaml (not a valid BMAD custom module)"
        exit 1
    fi

    ok "TeamBuilder module source ready"
    printf "\n"
}

# -----------------------------------------------------------------------------
# Install BMAD + TeamBuilder via --custom-content
# -----------------------------------------------------------------------------
install_bmad() {
    header "Installing BMAD $BMAD_VERSION + TeamBuilder"
    local target_dir
    target_dir="$(pwd)"

    step "Running: npx bmad-method@$BMAD_VERSION install -y --modules $BMAD_MODULES --tools $BMAD_TOOLS --custom-content \"$MODULE_PATH\""
    info "This will take a minute or two. BMAD will:"
    info "  - Install core module"
    info "  - Install $BMAD_MODULES module"
    info "  - Copy teambuilder module from $MODULE_PATH"
    info "  - Auto-discover all SKILL.md files and generate manifests"
    info "  - Install all skills into .claude/skills/ for Claude Code"
    printf "\n"

    if ! npx --yes "bmad-method@$BMAD_VERSION" install \
            --directory "$target_dir" \
            -y \
            --modules "$BMAD_MODULES" \
            --tools "$BMAD_TOOLS" \
            --custom-content "$MODULE_PATH"; then
        fail "BMAD install failed"
        info "Leaving temp clone in place for debugging: $MODULE_PATH"
        exit 1
    fi

    printf "\n"

    # Sanity checks — verify teambuilder landed in the installed _bmad tree
    # (note: module.yaml is installer metadata and is NOT copied into the installed
    #  tree; we verify config.yaml + agents/ + skills/ which ARE copied)
    [[ -f "_bmad/teambuilder/config.yaml" ]] || { fail "Post-install check failed: _bmad/teambuilder/config.yaml not found"; info "BMAD reported success but the teambuilder module was not installed."; exit 1; }
    [[ -d "_bmad/teambuilder/agents" ]]      || { fail "Post-install check failed: _bmad/teambuilder/agents/ not found"; exit 1; }
    [[ -d "_bmad/teambuilder/skills" ]]      || { fail "Post-install check failed: _bmad/teambuilder/skills/ not found"; exit 1; }
    [[ -f "_bmad/_config/agent-manifest.csv" ]] || { fail "Post-install check failed: agent-manifest.csv not found"; exit 1; }

    local tb_agents tb_skills
    tb_agents="$(grep -c '"teambuilder"' "_bmad/_config/agent-manifest.csv" || true)"
    tb_skills="$(grep -c '"teambuilder"' "_bmad/_config/skill-manifest.csv" || true)"

    ok "Installed BMAD $BMAD_VERSION + TeamBuilder module"
    info "  Agents registered:  $tb_agents"
    info "  Skills registered:  $tb_skills"
    printf "\n"
}

# -----------------------------------------------------------------------------
# Write .mcp.json
# -----------------------------------------------------------------------------
write_mcp_config() {
    if [[ $NO_MCP -eq 1 ]]; then
        info "Skipping .mcp.json (--no-mcp specified)"
        return
    fi

    header "Configuring MCP Servers"

    if [[ -f ".mcp.json" ]]; then
        warn ".mcp.json already exists — leaving it untouched"
        info "If you want TeamBuilder's MCP defaults, back up .mcp.json and re-run."
        return
    fi

    local memory_path="$(pwd)/_bmad/teambuilder/memory/general-knowledge.jsonl"
    mkdir -p "$(dirname "$memory_path")"
    touch "$memory_path"

    local playwright_block=""
    if [[ $NO_PLAYWRIGHT -eq 0 ]]; then
        playwright_block=',
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    }'
    fi

    cat > .mcp.json <<EOF
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "env": {
        "MEMORY_FILE_PATH": "$memory_path"
      }
    }$playwright_block
  }
}
EOF

    ok "Wrote .mcp.json"
    info "  memory server   -> $memory_path"
    [[ $NO_PLAYWRIGHT -eq 0 ]] && info "  playwright      -> @playwright/mcp@latest"
    printf "\n"
}

# -----------------------------------------------------------------------------
# Docs folder and .gitignore
# -----------------------------------------------------------------------------
initialize_project_files() {
    header "Finalizing Project Structure"

    if [[ ! -d "docs" ]]; then
        mkdir -p "docs"
        ok "Created docs/ (team knowledge base)"
    else
        info "docs/ already exists — leaving alone"
    fi

    local tb_rules='
# --- TeamBuilder / BMAD v6 ---
# Team-specific memory files (per generated team, local-only)
_bmad-output/teams/*/memory.jsonl
_bmad-output/teams/*/session-context.md
# BMAD output folder can grow large; track it selectively
# _bmad-output/
'

    if [[ -f ".gitignore" ]]; then
        if grep -q '_bmad-output/teams/\*/memory\.jsonl' .gitignore 2>/dev/null; then
            info ".gitignore already has TeamBuilder rules"
        else
            printf '%s' "$tb_rules" >> .gitignore
            ok "Appended TeamBuilder rules to .gitignore"
        fi
    else
        printf '%s' "$tb_rules" > .gitignore
        ok "Created .gitignore with TeamBuilder rules"
    fi
    printf "\n"
}

# -----------------------------------------------------------------------------
# Success message
# -----------------------------------------------------------------------------
show_success() {
    printf "\n"
    printf "  ${C_GREEN}+---------------------------------------------------+${C_RESET}\n"
    printf "  ${C_GREEN}|            Installation Complete!                 |${C_RESET}\n"
    printf "  ${C_GREEN}+---------------------------------------------------+${C_RESET}\n\n"
    printf "  ${C_CYAN}Next steps:${C_RESET}\n\n"
    printf "  ${C_WHITE}1. Open this directory in Claude Code (CLI or desktop app)${C_RESET}\n"
    printf "  ${C_WHITE}2. Restart Claude Code so it discovers the new .claude/skills/${C_RESET}\n"
    printf "  ${C_WHITE}3. Invoke the TeamBuilder Guide:${C_RESET}\n\n"
    printf "       ${C_YELLOW}/bmad-agent-team-guide${C_RESET}\n\n"
    printf "  ${C_WHITE}4. Follow the guided discovery to build your first team.${C_RESET}\n\n"
    printf "  ${C_CYAN}Available agents:${C_RESET}\n"
    printf "    ${C_GRAY}/bmad-agent-team-guide        - Main entry point${C_RESET}\n"
    printf "    ${C_GRAY}/bmad-agent-team-architect    - Structural designer${C_RESET}\n"
    printf "    ${C_GRAY}/bmad-agent-persona-improver  - Persona quality specialist${C_RESET}\n"
    printf "    ${C_GRAY}/bmad-agent-quality-guardian  - Validation reviewer${C_RESET}\n"
    printf "    ${C_GRAY}/bmad-agent-tool-scout        - MCP/tool researcher${C_RESET}\n"
    printf "    ${C_GRAY}/bmad-agent-memory-manager    - Cross-team memory consolidation${C_RESET}\n\n"
    printf "  ${C_CYAN}Docs: https://github.com/dexusno/teambuilder${C_RESET}\n\n"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
banner
check_prerequisites
check_not_already_installed
fetch_teambuilder_source
install_bmad
write_mcp_config
initialize_project_files
show_success
