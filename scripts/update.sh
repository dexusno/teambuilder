#!/usr/bin/env bash
# =============================================================================
# TeamBuilder Update — safely update an installed TeamBuilder module in place
# =============================================================================
#
# Updates the teambuilder module while preserving:
#   - Generated teams under _bmad/teams-*/
#   - The user's .mcp.json
#   - The user's docs/ contents
#   - The user's .gitignore
#   - Memory files (general-knowledge.jsonl is preserved)
#
# Steps:
#   1. Verify _bmad/teambuilder/ exists (else: not installed)
#   2. Run compat-check on the existing install (must pass or use --force)
#   3. Snapshot _bmad/teambuilder/ to _bmad/.tb-backup-{timestamp}/
#   4. Clone the teambuilder repo to a temp directory (or use --local-source)
#   5. Show current vs new version, ask for confirmation (unless -y)
#   6. Re-run BMAD's installer with --custom-content (quick-update)
#   7. Run compat-check on the result
#   8. If post-update compat-check fails: offer rollback
#   9. Clean up temp clone
#
# Critical safety properties:
#   - Never touches _bmad/teams-*/ (generated teams preserved)
#   - Never touches BMAD core/ or bmm/
#   - Never deletes the snapshot until the user confirms success
#
# Flags:
#   -y, --yes              Skip all confirmation prompts
#   --force                Proceed even on pre-check failures or blocked BMAD
#   --branch NAME          Git branch to clone (default: main)
#   --local-source PATH    Use a local TeamBuilder checkout (maintainer flow)
#   --project-path PATH    Project root containing _bmad/ (default: cwd)
#   --keep-backup          Don't prompt to delete the snapshot at the end
#   --channel NAME         BMAD release channel: stable (default), beta, nightly
#                          beta and nightly are UNSUPPORTED
#   -h, --help             Show this help
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
TEAMBUILDER_REPO="https://github.com/dexusno/teambuilder.git"
TEAMBUILDER_MODULE_PATH="teambuilder"
BMAD_STABLE_VERSION="6.2.2"
BMAD_MODULES="bmm"
BMAD_TOOLS="claude-code"

# -----------------------------------------------------------------------------
# Flags
# -----------------------------------------------------------------------------
YES_FLAG=0
FORCE_FLAG=0
BRANCH="main"
LOCAL_SOURCE=""
PROJECT_PATH="$(pwd)"
KEEP_BACKUP=0
CHANNEL="stable"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes) YES_FLAG=1; shift ;;
        --force) FORCE_FLAG=1; shift ;;
        --branch) BRANCH="$2"; shift 2 ;;
        --local-source) LOCAL_SOURCE="$2"; shift 2 ;;
        --project-path) PROJECT_PATH="$2"; shift 2 ;;
        --keep-backup) KEEP_BACKUP=1; shift ;;
        --channel) CHANNEL="$2"; shift 2 ;;
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

header() { printf "\n${C_CYAN}%s${C_RESET}\n  ${C_CYAN}%s${C_RESET}\n${C_CYAN}%s${C_RESET}\n\n" \
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
    printf "  ${C_MAGENTA}|   TeamBuilder Update (in-place, with rollback)    |${C_RESET}\n"
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

# -----------------------------------------------------------------------------
# Locate compat-check.js
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPAT_CHECK="$SCRIPT_DIR/lib/compat-check.js"

if [[ ! -f "$COMPAT_CHECK" ]]; then
    fail "compat-check.js not found at $COMPAT_CHECK"
    exit 2
fi

# Cleanup helper for temp clone
TEMP_BASE=""
cleanup_temp() {
    if [[ -n "$TEMP_BASE" && -d "$TEMP_BASE" ]]; then
        rm -rf "$TEMP_BASE" 2>/dev/null || true
    fi
}
trap cleanup_temp EXIT

# Resolve BMAD version based on channel
resolve_bmad_version() {
    case "$CHANNEL" in
        stable) BMAD_VERSION="$BMAD_STABLE_VERSION" ;;
        beta|nightly)
            local next
            if next="$(npx --yes -- npm view bmad-method dist-tags.next 2>/dev/null | tr -d '[:space:]')" && [[ -n "$next" ]]; then
                BMAD_VERSION="$next"
            else
                printf "  ${C_YELLOW}[!] Could not resolve %s version from npm; falling back to stable %s${C_RESET}\n" "$CHANNEL" "$BMAD_STABLE_VERSION"
                BMAD_VERSION="$BMAD_STABLE_VERSION"
            fi
            ;;
        *)
            echo "Unknown channel: $CHANNEL (must be stable, beta, or nightly)" >&2
            exit 1
            ;;
    esac
}

# =============================================================================
# Step 1 — Verify TeamBuilder is installed
# =============================================================================
banner
resolve_bmad_version

if [[ "$CHANNEL" != "stable" ]]; then
    printf "\n"
    printf "  ${C_YELLOW}+---------------------------------------------------+${C_RESET}\n"
    printf "  ${C_YELLOW}|  Non-stable channel selected: %-20s|${C_RESET}\n" "$CHANNEL"
    printf "  ${C_YELLOW}|  Resolved BMAD version:       %-20s|${C_RESET}\n" "$BMAD_VERSION"
    printf "  ${C_YELLOW}|  This is UNSUPPORTED. Stability not guaranteed.   |${C_RESET}\n"
    printf "  ${C_YELLOW}+---------------------------------------------------+${C_RESET}\n\n"
    if [[ $YES_FLAG -eq 0 ]]; then
        read -r -p "  Continue with $CHANNEL channel? [y/N] " reply
        if [[ ! "$reply" =~ ^[Yy] ]]; then
            info "Aborted by user."
            exit 0
        fi
    fi
fi

PROJECT_ABS="$(cd "$PROJECT_PATH" 2>/dev/null && pwd || echo "$PROJECT_PATH")"
info "Project root: $PROJECT_ABS"

header "Step 1 — Verify Existing Install"

TB_DIR="$PROJECT_ABS/_bmad/teambuilder"
if [[ ! -d "$TB_DIR" ]]; then
    fail "TeamBuilder is not installed in this directory."
    info "Found: $PROJECT_ABS"
    info "Expected: $TB_DIR"
    printf "\n"
    info "To install TeamBuilder for the first time, use scripts/install.sh instead."
    exit 1
fi

CURRENT_COMPAT="$TB_DIR/compatibility.json"
CURRENT_VERSION="unknown (pre-3.1, no compatibility.json)"
if [[ -f "$CURRENT_COMPAT" ]]; then
    CURRENT_VERSION="$(grep -oE '"teambuilder_version"\s*:\s*"[^"]+"' "$CURRENT_COMPAT" | sed -E 's/.*"([^"]+)"$/\1/' || echo unknown)"
fi
ok "Found existing TeamBuilder install (version: $CURRENT_VERSION)"

# =============================================================================
# Step 2 — Pre-update compat-check
# =============================================================================
header "Step 2 — Pre-Update Compatibility Check"

if [[ -f "$CURRENT_COMPAT" ]]; then
    set +e
    node "$COMPAT_CHECK" --bmad-path "$PROJECT_ABS" --quiet
    PRE_EXIT=$?
    set -e
    if [[ $PRE_EXIT -eq 0 ]]; then
        ok "Pre-update compat-check: HEALTHY"
    elif [[ $PRE_EXIT -eq 1 && $FORCE_FLAG -eq 0 ]]; then
        fail "Pre-update compat-check: FAILURES detected"
        info "Run scripts/doctor.sh for details."
        info "If you understand the issues and want to update anyway, re-run with --force."
        exit 1
    elif [[ $PRE_EXIT -eq 1 ]]; then
        warn "Pre-update compat-check: failures detected, but --force was specified, continuing"
    fi
else
    warn "No compatibility.json in current install (pre-3.1) - skipping pre-check"
    info "This update will install the new compatibility.json so future updates are checked."
fi

# =============================================================================
# Step 3 — Snapshot existing teambuilder/
# =============================================================================
header "Step 3 — Backup Snapshot"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
SNAPSHOT_DIR="$PROJECT_ABS/_bmad/.tb-backup-$TIMESTAMP"

step "Creating backup at $SNAPSHOT_DIR ..."
cp -r "$TB_DIR" "$SNAPSHOT_DIR"
SNAPSHOT_FILE_COUNT="$(find "$SNAPSHOT_DIR" -type f | wc -l | tr -d ' ')"
ok "Snapshot created ($SNAPSHOT_FILE_COUNT files)"

# =============================================================================
# Step 4 — Fetch new TeamBuilder source
# =============================================================================
header "Step 4 — Fetch New TeamBuilder Source"

MODULE_PATH=""
if [[ -n "$LOCAL_SOURCE" ]]; then
    step "Using local source: $LOCAL_SOURCE"
    if [[ ! -f "$LOCAL_SOURCE/module.yaml" ]]; then
        fail "--local-source does not contain module.yaml: $LOCAL_SOURCE"
        exit 1
    fi
    MODULE_PATH="$(cd "$LOCAL_SOURCE" && pwd)"
else
    TEMP_BASE="$(mktemp -d -t teambuilder-update-XXXXXXXX)"
    step "Cloning $TEAMBUILDER_REPO (branch: $BRANCH) to temp..."
    info "Temp: $TEMP_BASE"
    if ! git clone --depth 1 --branch "$BRANCH" "$TEAMBUILDER_REPO" "$TEMP_BASE" >/dev/null 2>&1; then
        fail "Failed to clone teambuilder repo"
        exit 1
    fi
    MODULE_PATH="$TEMP_BASE/$TEAMBUILDER_MODULE_PATH"
    if [[ ! -f "$MODULE_PATH/module.yaml" ]]; then
        fail "Cloned repo does not contain $TEAMBUILDER_MODULE_PATH/module.yaml"
        exit 1
    fi
fi

NEW_COMPAT="$MODULE_PATH/compatibility.json"
NEW_VERSION="unknown"
if [[ -f "$NEW_COMPAT" ]]; then
    NEW_VERSION="$(grep -oE '"teambuilder_version"\s*:\s*"[^"]+"' "$NEW_COMPAT" | sed -E 's/.*"([^"]+)"$/\1/' || echo unknown)"
fi
ok "New source ready (version: $NEW_VERSION)"

# =============================================================================
# Step 5 — Confirm
# =============================================================================
header "Step 5 — Confirm Update"

info "Current TeamBuilder version: $CURRENT_VERSION"
info "New TeamBuilder version:     $NEW_VERSION"
info "BMAD version (pinned):       $BMAD_VERSION"
printf "\n"
info "What this update will do:"
info "  - Re-run BMAD's installer with --custom-content"
info "  - BMAD will quick-update teambuilder, leaving core/bmm/teams-* alone"
info "  - Re-run compat-check after the update"
info "  - On any failure, you'll be offered the rollback from $SNAPSHOT_DIR"
printf "\n"

if ! confirm "Proceed with update?" "y"; then
    info "Aborted by user. Snapshot preserved at $SNAPSHOT_DIR"
    exit 0
fi

# =============================================================================
# Step 6 — Re-run BMAD installer (quick-update)
# =============================================================================
header "Step 6 — Run BMAD Quick-Update"

pushd "$PROJECT_ABS" >/dev/null
set +e
npx --yes "bmad-method@$BMAD_VERSION" install \
    --directory "$PROJECT_ABS" \
    -y \
    --modules "$BMAD_MODULES" \
    --tools "$BMAD_TOOLS" \
    --custom-content "$MODULE_PATH"
BMAD_EXIT=$?
set -e
popd >/dev/null

if [[ $BMAD_EXIT -ne 0 ]]; then
    fail "BMAD quick-update failed (exit $BMAD_EXIT)"
    printf "\n"
    warn "ROLLBACK AVAILABLE: snapshot at $SNAPSHOT_DIR"
    info "To restore: remove _bmad/teambuilder/ and rename the snapshot back."
    exit 1
fi

# =============================================================================
# Step 7 — Post-update compat-check
# =============================================================================
header "Step 7 — Post-Update Compatibility Check"

set +e
node "$COMPAT_CHECK" --bmad-path "$PROJECT_ABS"
POST_EXIT=$?
set -e

if [[ $POST_EXIT -ne 0 ]]; then
    printf "\n"
    fail "Post-update compat-check FAILED (exit $POST_EXIT)"
    printf "\n"
    warn "Update completed but the result is not healthy."
    warn "Snapshot is available at: $SNAPSHOT_DIR"
    printf "\n"
    if confirm "Roll back to the snapshot?" "y"; then
        step "Rolling back ..."
        rm -rf "$TB_DIR"
        cp -r "$SNAPSHOT_DIR" "$TB_DIR"
        step "Re-running BMAD installer to regenerate manifests after rollback ..."
        pushd "$PROJECT_ABS" >/dev/null
        set +e
        npx --yes "bmad-method@$BMAD_VERSION" install \
            --directory "$PROJECT_ABS" \
            -y \
            --modules "$BMAD_MODULES" \
            --tools "$BMAD_TOOLS" \
            --custom-content "$TB_DIR"
        set -e
        popd >/dev/null
        ok "Rolled back to previous TeamBuilder version"
        info "Snapshot preserved at $SNAPSHOT_DIR for inspection"
        exit 1
    else
        warn "Snapshot preserved at $SNAPSHOT_DIR for manual recovery"
        exit 1
    fi
fi

# =============================================================================
# Step 8 — Cleanup
# =============================================================================
header "Step 8 — Cleanup"

if [[ $KEEP_BACKUP -eq 0 ]]; then
    if confirm "Delete the backup snapshot at $SNAPSHOT_DIR?" "y"; then
        rm -rf "$SNAPSHOT_DIR"
        ok "Snapshot deleted"
    else
        info "Snapshot preserved at $SNAPSHOT_DIR"
    fi
else
    info "Snapshot preserved at $SNAPSHOT_DIR (--keep-backup specified)"
fi

printf "\n"
printf "  ${C_GREEN}+---------------------------------------------------+${C_RESET}\n"
printf "  ${C_GREEN}|              Update Complete!                     |${C_RESET}\n"
printf "  ${C_GREEN}+---------------------------------------------------+${C_RESET}\n\n"
printf "  ${C_WHITE}TeamBuilder is now at version: %s${C_RESET}\n\n" "$NEW_VERSION"
printf "  ${C_YELLOW}Restart Claude Code to pick up the updated skills.${C_RESET}\n\n"
exit 0
