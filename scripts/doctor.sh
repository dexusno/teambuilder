#!/usr/bin/env bash
# =============================================================================
# TeamBuilder Doctor — read-only diagnostics for an installed TeamBuilder project
# =============================================================================
#
# Runs the TeamBuilder compatibility check (scripts/lib/compat-check.js) plus
# BMAD's own `bmad status` command and reports combined health.
# READ-ONLY — never modifies anything.
#
# Flags:
#   --project-path PATH   Project root containing _bmad/ (default: cwd)
#   --json                Machine-readable JSON output
#   --strict              Exit 1 on warnings as well as failures
#   -h, --help            Show this help
#
# Use this when:
#   - Something feels broken and you want a quick triage
#   - You just upgraded BMAD and want to know if TeamBuilder is still compatible
#   - You're about to run scripts/update.sh and want the starting state
#   - You're filing a bug report and need a structured health snapshot
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Flags
# -----------------------------------------------------------------------------
PROJECT_PATH="$(pwd)"
JSON_FLAG=0
STRICT_FLAG=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --project-path) PROJECT_PATH="$2"; shift 2 ;;
        --json) JSON_FLAG=1; shift ;;
        --strict) STRICT_FLAG=1; shift ;;
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
else
    C_RESET=""; C_CYAN=""; C_GREEN=""; C_RED=""; C_YELLOW=""; C_MAGENTA=""; C_GRAY=""
fi

header() { printf "\n${C_CYAN}%s${C_RESET}\n  ${C_CYAN}%s${C_RESET}\n${C_CYAN}%s${C_RESET}\n\n" \
           "============================================================" "$1" \
           "============================================================"; }
ok()    { printf "  ${C_GREEN}[OK] %s${C_RESET}\n" "$1"; }
fail()  { printf "  ${C_RED}[X]  %s${C_RESET}\n" "$1"; }
warn()  { printf "  ${C_YELLOW}[!]  %s${C_RESET}\n" "$1"; }
info()  { printf "  ${C_GRAY}%s${C_RESET}\n" "$1"; }

banner() {
    printf "\n"
    printf "  ${C_MAGENTA}+---------------------------------------------------+${C_RESET}\n"
    printf "  ${C_MAGENTA}|   TeamBuilder Doctor (read-only diagnostics)      |${C_RESET}\n"
    printf "  ${C_MAGENTA}+---------------------------------------------------+${C_RESET}\n\n"
}

# -----------------------------------------------------------------------------
# Locate compat-check.js
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPAT_CHECK="$SCRIPT_DIR/lib/compat-check.js"

if [[ ! -f "$COMPAT_CHECK" ]]; then
    printf "\n  ${C_RED}[X] compat-check.js not found at %s${C_RESET}\n" "$COMPAT_CHECK"
    printf "  ${C_RED}    This script must live next to lib/compat-check.js${C_RESET}\n"
    exit 2
fi

# -----------------------------------------------------------------------------
# Sanity: project root must contain _bmad/
# -----------------------------------------------------------------------------
PROJECT_ABS="$(cd "$PROJECT_PATH" 2>/dev/null && pwd || echo "$PROJECT_PATH")"

if [[ ! -d "$PROJECT_ABS/_bmad" ]]; then
    if [[ $JSON_FLAG -eq 1 ]]; then
        printf '{"error": "_bmad/ not found at %s", "exitCode": 2}\n' "$PROJECT_ABS"
    else
        banner
        fail "_bmad/ not found at $PROJECT_ABS"
        info "TeamBuilder is not installed in this directory."
        info "Run scripts/install.sh to install."
    fi
    exit 2
fi

# -----------------------------------------------------------------------------
# JSON mode: just delegate to compat-check.js --json
# -----------------------------------------------------------------------------
if [[ $JSON_FLAG -eq 1 ]]; then
    set +e
    node "$COMPAT_CHECK" --bmad-path "$PROJECT_ABS" --json
    COMPAT_EXIT=$?
    set -e
    if [[ $STRICT_FLAG -eq 1 && $COMPAT_EXIT -ne 0 ]]; then exit 1; fi
    exit $COMPAT_EXIT
fi

# -----------------------------------------------------------------------------
# Human mode
# -----------------------------------------------------------------------------
banner
info "Project root: $PROJECT_ABS"
printf "\n"

# 1. Compatibility check
printf "  ${C_YELLOW}-> Running compatibility check...${C_RESET}\n\n"
set +e
if [[ $STRICT_FLAG -eq 1 ]]; then
    node "$COMPAT_CHECK" --bmad-path "$PROJECT_ABS" --strict
else
    node "$COMPAT_CHECK" --bmad-path "$PROJECT_ABS"
fi
COMPAT_EXIT=$?
set -e

# 2. BMAD status
header "BMAD Status (from bmad-method)"
pushd "$PROJECT_ABS" >/dev/null
set +e
npx --yes bmad-method@6.2.2 status 2>&1
BMAD_EXIT=$?
set -e
popd >/dev/null

# 3. Summary
header "Doctor Summary"
if [[ $COMPAT_EXIT -eq 0 ]]; then
    ok "compat-check: HEALTHY"
elif [[ $COMPAT_EXIT -eq 1 ]]; then
    fail "compat-check: FAILURES detected (see section above)"
elif [[ $COMPAT_EXIT -eq 2 ]]; then
    fail "compat-check: COULD NOT RUN (compatibility.json missing)"
fi

if [[ $BMAD_EXIT -eq 0 ]]; then
    ok "bmad status: returned cleanly"
else
    warn "bmad status: exit code $BMAD_EXIT (may be informational, check output above)"
fi

printf "\n"
if [[ $COMPAT_EXIT -eq 0 ]]; then
    printf "  ${C_GREEN}Doctor reports: HEALTHY${C_RESET}\n\n"
    exit 0
elif [[ $COMPAT_EXIT -eq 2 ]]; then
    printf "  ${C_RED}Doctor reports: CANNOT DIAGNOSE${C_RESET}\n"
    printf "  ${C_GRAY}(TeamBuilder may be installed in an old format without compatibility.json)${C_RESET}\n\n"
    exit 2
else
    printf "  ${C_RED}Doctor reports: ISSUES FOUND${C_RESET}\n"
    printf "  ${C_GRAY}Review the FAIL/WARN entries above and consult the README troubleshooting section.${C_RESET}\n"
    printf "  ${C_GRAY}https://github.com/dexusno/teambuilder#troubleshooting${C_RESET}\n\n"
    exit 1
fi
