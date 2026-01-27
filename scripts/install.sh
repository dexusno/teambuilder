#!/bin/bash
#
# TeamBuilder Project Installer for Linux/macOS
# Installs BMAD Method + TeamBuilder module with all prerequisites.
# Creates a ready-to-use project for building AI agent teams.
# Run this script from inside your project folder.
#
# Usage:
#   mkdir my-project && cd my-project
#   ./install.sh
#
# https://github.com/dexusno/teambuilder

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Formatting functions
print_header() {
    echo ""
    echo -e "${CYAN}=======================================================${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}=======================================================${NC}"
    echo ""
}

print_step() {
    echo -e "  ${YELLOW}-> $1${NC}"
}

print_success() {
    echo -e "  ${GREEN}[OK] $1${NC}"
}

print_fail() {
    echo -e "  ${RED}[X] $1${NC}"
}

print_info() {
    echo -e "  ${GRAY}$1${NC}"
}

# Banner
show_banner() {
    echo ""
    echo -e "${MAGENTA}  +-------------------------------------------------+${NC}"
    echo -e "${MAGENTA}  |        TeamBuilder Project Installer            |${NC}"
    echo -e "${MAGENTA}  |        github.com/dexusno/teambuilder           |${NC}"
    echo -e "${MAGENTA}  +-------------------------------------------------+${NC}"
    echo ""
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Get command version
get_version() {
    case "$1" in
        node) node --version 2>/dev/null | sed 's/v//' ;;
        npm) npm --version 2>/dev/null ;;
        git) git --version 2>/dev/null | sed 's/git version //' ;;
        claude) echo "installed" ;;
        *) echo "unknown" ;;
    esac
}

# Detect OS and package manager
detect_package_manager() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command_exists brew; then
            echo "brew"
        else
            echo "none"
        fi
    elif command_exists apt-get; then
        echo "apt"
    elif command_exists dnf; then
        echo "dnf"
    elif command_exists pacman; then
        echo "pacman"
    elif command_exists brew; then
        echo "brew"
    else
        echo "none"
    fi
}

# Install package
install_package() {
    local package=$1
    local display_name=$2
    local pm=$(detect_package_manager)

    print_step "Installing $display_name..."

    case "$pm" in
        brew)
            brew install "$package"
            ;;
        apt)
            sudo apt-get update && sudo apt-get install -y "$package"
            ;;
        dnf)
            sudo dnf install -y "$package"
            ;;
        pacman)
            sudo pacman -S --noconfirm "$package"
            ;;
        *)
            print_fail "No supported package manager found"
            print_info "Please install $display_name manually"
            return 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        print_success "$display_name installed"
        return 0
    else
        print_fail "Failed to install $display_name"
        return 1
    fi
}

# Main installation
main() {
    local install_claude_code=false
    local install_memory_mcp=true
    local install_playwright_mcp=true
    local init_git=false

    show_banner

    # ===== STEP 1: Check Claude Code =====
    print_header "Step 1: Checking Claude Code"

    if command_exists claude; then
        print_success "Claude Code found"
    else
        print_fail "Claude Code not found"
        echo ""
        echo -e "  ${YELLOW}Claude Code is required for this project.${NC}"
        echo -e "  ${YELLOW}More info: https://claude.ai${NC}"
        echo ""
        echo "  1. I have Claude Code - install it now"
        echo "  2. Exit"
        echo ""
        read -p "  Select option (1-2): " choice

        if [ "$choice" != "1" ]; then
            echo ""
            print_info "Visit https://claude.ai to learn more."
            print_info "Run this installer again when ready."
            echo ""
            exit 0
        fi

        install_claude_code=true
    fi

    # ===== STEP 2: Check/Install Prerequisites =====
    print_header "Step 2: Checking Prerequisites"

    local pm=$(detect_package_manager)
    if [ "$pm" == "none" ]; then
        print_fail "No supported package manager found"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            print_info "Please install Homebrew: https://brew.sh"
        else
            print_info "Please install packages manually"
        fi
        exit 1
    fi
    print_success "Package manager: $pm"

    # Check/Install Node.js
    if command_exists node; then
        local node_version=$(get_version node)
        print_success "Node.js v$node_version"
    else
        print_fail "Node.js not found"
        echo ""
        read -p "  Install Node.js? (Y/n): " install_node
        if [[ "$install_node" == "" || "$install_node" =~ ^[Yy] ]]; then
            local node_pkg="node"
            [ "$pm" == "apt" ] && node_pkg="nodejs"
            if ! install_package "$node_pkg" "Node.js"; then
                exit 1
            fi
        else
            print_info "Node.js is required. Exiting."
            exit 1
        fi
    fi

    # Check/Install Git
    if command_exists git; then
        local git_version=$(get_version git)
        print_success "Git v$git_version"
    else
        print_fail "Git not found"
        echo ""
        read -p "  Install Git? (Y/n): " install_git
        if [[ "$install_git" == "" || "$install_git" =~ ^[Yy] ]]; then
            if ! install_package "git" "Git"; then
                exit 1
            fi
        else
            print_info "Git is required. Exiting."
            exit 1
        fi
    fi

    # Install Claude Code if needed
    if [ "$install_claude_code" = true ]; then
        print_step "Installing Claude Code via npm..."
        npm install -g @anthropic-ai/claude-code
        if [ $? -eq 0 ]; then
            print_success "Claude Code installed"
        else
            print_fail "Failed to install Claude Code"
            print_info "Try manually: npm install -g @anthropic-ai/claude-code"
            exit 1
        fi
    fi

    print_success "All prerequisites satisfied"

    # ===== STEP 3: Project Folder =====
    print_header "Step 3: Project Folder"

    local target_dir="$(pwd)"
    local item_count=$(ls -A 2>/dev/null | grep -v "^install\.\(ps1\|sh\)$" | wc -l)

    if [ "$item_count" -eq 0 ]; then
        print_success "Using current directory: $target_dir"
    else
        print_info "Current directory is not empty."
        read -p "  Continue installation here? (y/N): " continue_install
        if [[ ! "$continue_install" =~ ^[Yy] ]]; then
            print_info "Installation cancelled. Create a new folder for your project and run again."
            exit 0
        fi
        print_success "Using current directory: $target_dir"
    fi

    # ===== STEP 4: Main Menu =====
    print_header "Step 4: Installation Options"

    echo "  1. Full Install (recommended)"
    echo "  2. Custom Install"
    echo "  3. Help / Documentation"
    echo "  4. Exit"
    echo ""
    read -p "  Select option (1-4): " menu_choice

    case "$menu_choice" in
        1)
            # Full install - use defaults
            ;;
        2)
            echo ""
            echo -e "  ${CYAN}Select components (Y/n for each):${NC}"
            echo ""

            read -p "  Install Memory MCP? (Y/n): " memory_choice
            [[ "$memory_choice" =~ ^[Nn] ]] && install_memory_mcp=false

            read -p "  Install Playwright MCP? (Y/n): " playwright_choice
            [[ "$playwright_choice" =~ ^[Nn] ]] && install_playwright_mcp=false

            read -p "  Initialize Git repository? (y/N): " git_choice
            [[ "$git_choice" =~ ^[Yy] ]] && init_git=true
            ;;
        3)
            echo ""
            echo -e "  ${CYAN}TeamBuilder creates AI agent teams using the BMAD Method.${NC}"
            echo ""
            echo "  After installation:"
            echo "    1. Open project: claude ."
            echo "    2. Create team: /bmad:teambuilder:agents:teambuilder-guide"
            echo ""
            echo "  Documentation: https://github.com/dexusno/teambuilder"
            echo ""
            exit 0
            ;;
        *)
            print_info "Installation cancelled."
            exit 0
            ;;
    esac

    # ===== STEP 5: Installation =====
    print_header "Step 5: Installing"

    # Install BMAD Method
    print_step "Installing BMAD Method (latest alpha)..."
    npx bmad-method@alpha install
    if [ $? -ne 0 ]; then
        print_fail "Failed to install BMAD Method"
        exit 1
    fi

    # Verify BMAD installed
    if [ ! -d "_bmad" ]; then
        print_fail "BMAD Method installation failed - _bmad folder not created"
        exit 1
    fi
    print_success "BMAD Method installed"

    # Clone TeamBuilder module
    print_step "Installing TeamBuilder module..."
    local teambuilder_dir="_bmad/teambuilder"

    [ -d "$teambuilder_dir" ] && rm -rf "$teambuilder_dir"

    # Clone and check for errors
    if ! git clone --depth 1 https://github.com/dexusno/teambuilder.git temp-teambuilder 2>&1; then
        print_fail "Failed to clone TeamBuilder repository"
        exit 1
    fi

    # Verify and move
    if [ -d "temp-teambuilder/teambuilder" ]; then
        mv temp-teambuilder/teambuilder "$teambuilder_dir"
    else
        print_fail "TeamBuilder module not found in cloned repository"
        rm -rf temp-teambuilder 2>/dev/null
        exit 1
    fi
    rm -rf temp-teambuilder 2>/dev/null

    # Verify TeamBuilder installed
    if [ ! -d "$teambuilder_dir" ]; then
        print_fail "TeamBuilder installation failed"
        exit 1
    fi
    print_success "TeamBuilder module installed"

    # Register TeamBuilder in manifests
    print_step "Registering TeamBuilder in BMAD manifests..."
    local agent_manifest="_bmad/_config/agent-manifest.csv"
    local manifest_entries="_bmad/teambuilder/agent-manifest-entries.csv"

    if [ ! -f "$agent_manifest" ]; then
        print_fail "Agent manifest not found at $agent_manifest"
        print_info "BMAD may not have installed correctly"
        exit 1
    fi

    if [ ! -f "$manifest_entries" ]; then
        print_fail "TeamBuilder manifest entries not found"
        print_info "TeamBuilder module may be incomplete"
        exit 1
    fi

    cat "$manifest_entries" >> "$agent_manifest"

    # Add teambuilder to modules list in manifest.yaml
    local main_manifest="_bmad/_config/manifest.yaml"
    if [ -f "$main_manifest" ]; then
        if ! grep -q "teambuilder" "$main_manifest"; then
            # Portable: append after the last module entry
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' 's/^  - cis$/  - cis\n  - teambuilder/' "$main_manifest"
            else
                sed -i 's/^  - cis$/  - cis\n  - teambuilder/' "$main_manifest"
            fi
        fi
    fi

    # Create Claude Code command files for TeamBuilder agents
    local commands_dir=".claude/commands/bmad/teambuilder/agents"
    mkdir -p "$commands_dir"

    # Create command file for each agent
    for agent_file in _bmad/teambuilder/agents/*.md; do
        if [ -f "$agent_file" ]; then
            local agent_name=$(basename "$agent_file" .md)
            local command_file="$commands_dir/$agent_name.md"
            cat > "$command_file" << CMDEOF
---
name: '$agent_name'
description: '$agent_name agent'
---

You must fully embody this agent's persona and follow all activation instructions exactly as specified. NEVER break character until given an exit command.

<agent-activation CRITICAL="TRUE">
1. LOAD the FULL agent file from @_bmad/teambuilder/agents/$agent_name.md
2. READ its entire contents - this contains the complete agent persona, menu, and instructions
3. Execute ALL activation steps exactly as written in the agent file
4. Follow the agent's persona and menu system precisely
5. Stay in character throughout the session
</agent-activation>
CMDEOF
        fi
    done
    print_success "TeamBuilder registered"

    # Create .mcp.json
    print_step "Creating MCP configuration..."

    local mcp_content='{\n  "mcpServers": {'
    local has_mcp=false

    if [ "$install_memory_mcp" = true ]; then
        mcp_content="$mcp_content"'\n    "memory": {\n      "command": "npx",\n      "args": ["-y", "@modelcontextprotocol/server-memory"]\n    }'
        has_mcp=true
    fi

    if [ "$install_playwright_mcp" = true ]; then
        [ "$has_mcp" = true ] && mcp_content="$mcp_content,"
        mcp_content="$mcp_content"'\n    "playwright": {\n      "command": "npx",\n      "args": ["-y", "@anthropic/mcp-playwright"]\n    }'
    fi

    mcp_content="$mcp_content"'\n  }\n}'

    echo -e "$mcp_content" > .mcp.json
    print_success "MCP configuration created"

    # Create .gitignore
    print_step "Creating .gitignore..."
    cat > .gitignore << 'EOF'
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
EOF
    print_success ".gitignore created"

    # Initialize Git if requested
    if [ "$init_git" = true ]; then
        print_step "Initializing Git repository..."
        git init
        git add .
        git commit -m "Initial commit: BMAD + TeamBuilder project"
        print_success "Git repository initialized"
    fi

    # ===== STEP 6: Complete =====
    print_header "Installation Complete!"

    local folder_name=$(basename "$target_dir")
    echo -e "  ${GREEN}+-------------------------------------------------+${NC}"
    echo -e "  ${GREEN}|  Success! Your project is ready.                |${NC}"
    echo -e "  ${GREEN}|                                                 |${NC}"
    echo -e "  ${GREEN}|  Next steps:                                    |${NC}"
    echo -e "  ${GREEN}|    1. Open terminal in this folder              |${NC}"
    echo -e "  ${GREEN}|    2. Run: claude .                             |${NC}"
    echo -e "  ${GREEN}|    3. Type: /bmad:teambuilder:agents:teambuilder-guide${NC}"
    echo -e "  ${GREEN}|                                                 |${NC}"
    echo -e "  ${GREEN}|  Happy team building!                           |${NC}"
    echo -e "  ${GREEN}+-------------------------------------------------+${NC}"
    echo ""
}

# Run main
main
