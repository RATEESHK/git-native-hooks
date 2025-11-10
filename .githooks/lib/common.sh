#!/usr/bin/env bash
# ==============================================================================
# Git Hooks Common Library
# ==============================================================================
# Provides reusable functions for logging, error handling, branch detection,
# and cross-platform compatibility across all Git hooks.
#
# Author: Enterprise Development Team
# Version: 1.0.0
# License: MIT
# ==============================================================================

set -euo pipefail

# ==============================================================================
# CONSTANTS & CONFIGURATION
# ==============================================================================

readonly HOOK_VERSION="1.0.0"
readonly HOOK_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly HOOK_ROOT_DIR="$(dirname "$HOOK_LIB_DIR")"

# Cache GIT_ROOT to avoid repeated git calls
if [[ -z "${GIT_HOOKS_ROOT:-}" ]]; then
    export GIT_HOOKS_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
fi
readonly GIT_ROOT="${GIT_HOOKS_ROOT}"

readonly LOG_DIR="${GIT_ROOT}/.git/hooks-logs"
readonly HOOK_DATE="$(date +%Y-%m-%d)"
readonly LOG_FILE="${LOG_DIR}/hook-${HOOK_DATE}.log"
readonly TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S"

# Color codes for terminal output
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_MAGENTA='\033[0;35m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_WHITE='\033[1;37m'
readonly COLOR_GRAY='\033[0;90m'
readonly COLOR_BOLD='\033[1m'
readonly COLOR_RESET='\033[0m'

# Branch patterns based on Git Flow (https://nvie.com/posts/a-successful-git-branching-model/)
readonly PATTERN_MAIN='^main$'
readonly PATTERN_DEVELOP='^develop$'
# Release branches: release-1.2.0, release-1.2, release-2.0.0-rc1 (NO JIRA ID required per Git Flow)
readonly PATTERN_RELEASE='^release-[0-9]+(\.[0-9]+)*(-[a-zA-Z0-9._-]+)?$'
readonly PATTERN_FEATURE='^(feat|feature)-[A-Z]{2,10}-[0-9]+-[a-z0-9-]+$'
readonly PATTERN_BUGFIX='^(bugfix|fix)-[A-Z]{2,10}-[0-9]+-[a-z0-9-]+$'
readonly PATTERN_HOTFIX='^hotfix-[A-Z]{2,10}-[0-9]+-[a-z0-9-]+$'
readonly PATTERN_SUPPORT='^(build|chore|ci|docs|techdebt|perf|refactor|revert|style|test)-[A-Z]{2,10}-[0-9]+-[a-z0-9-]+$'

# Commit message pattern
readonly COMMIT_MSG_PATTERN='^(feat|fix|chore|break|tests|docs|style|refactor|test|hotfix): [A-Z]{2,10}-[0-9]+ [^[:space:]].*$'

# Protected branches
readonly PROTECTED_BRANCHES=("main" "develop")

# ==============================================================================
# LOGGING FUNCTIONS
# ==============================================================================

# Initialize logging infrastructure
init_logging() {
    if [[ ! -d "$LOG_DIR" ]]; then
        mkdir -p "$LOG_DIR" 2>/dev/null || true
    fi
}

# Get formatted timestamp
get_timestamp() {
    date +"$TIMESTAMP_FORMAT"
}

# Write to log file with timestamp and context (with file locking for concurrency)
log_to_file() {
    local level="$1"
    local hook_name="${2:-UNKNOWN}"
    local message="$3"
    local timestamp
    timestamp="$(get_timestamp)"
    
    init_logging
    
    # Check if flock is available (not available on Windows Git Bash by default)
    if command -v flock &>/dev/null; then
        # Use flock for atomic writes to prevent log corruption in concurrent scenarios
        (
            flock -x 200 || return 0
            echo "[${timestamp}] [${level}] [${hook_name}] ${message}" >> "$LOG_FILE"
        ) 200>>"${LOG_FILE}.lock" 2>/dev/null || true
    else
        # Fallback for systems without flock (e.g., Windows Git Bash)
        # Direct write - acceptable for most use cases as hook execution is typically sequential
        echo "[${timestamp}] [${level}] [${hook_name}] ${message}" >> "$LOG_FILE" 2>/dev/null || true
    fi
}

# Log with stack trace
log_with_trace() {
    local level="$1"
    local hook_name="$2"
    local message="$3"
    
    log_to_file "$level" "$hook_name" "$message"
    
    # Add stack trace for errors
    if [[ "$level" == "ERROR" ]]; then
        local frame=0
        log_to_file "TRACE" "$hook_name" "Stack trace:"
        # Disable errexit temporarily for stack trace generation
        set +e
        while caller $frame 2>/dev/null; do
            ((frame++))
        done | while read -r line; do
            log_to_file "TRACE" "$hook_name" "  $line"
        done
        set -e
    fi
}

# ==============================================================================
# CONSOLE OUTPUT FUNCTIONS
# ==============================================================================

# Print colored output
print_color() {
    local color="$1"
    local message="$2"
    local no_newline="${3:-false}"
    
    if [[ "$no_newline" == "true" ]]; then
        printf "${color}%s${COLOR_RESET}" "$message"
    else
        printf "${color}%s${COLOR_RESET}\n" "$message"
    fi
}

# Print section header
print_header() {
    local title="$1"
    local width=80
    
    echo ""
    print_color "$COLOR_CYAN" "$(printf '=%.0s' {1..80})"
    print_color "$COLOR_BOLD$COLOR_CYAN" "  $title"
    print_color "$COLOR_CYAN" "$(printf '=%.0s' {1..80})"
    echo ""
}

# Print error with icon
print_error() {
    local message="$1"
    printf "${COLOR_RED}✗ ERROR: %s${COLOR_RESET}\n" "$message" >&2
}

# Print warning with icon
print_warning() {
    local message="$1"
    printf "${COLOR_YELLOW}⚠ WARNING: %s${COLOR_RESET}\n" "$message" >&2
}

# Print success with icon
print_success() {
    local message="$1"
    print_color "$COLOR_GREEN" "✓ SUCCESS: $message"
}

# Print info with icon
print_info() {
    local message="$1"
    print_color "$COLOR_BLUE" "ℹ INFO: $message"
}

# Print hint with icon
print_hint() {
    local message="$1"
    print_color "$COLOR_MAGENTA" "💡 HINT: $message"
}

# Print separator
print_separator() {
    print_color "$COLOR_GRAY" "$(printf '─%.0s' {1..80})"
}

# ==============================================================================
# ERROR HANDLING & REPORTING
# ==============================================================================

# Comprehensive error reporter with context-aware suggestions
report_error() {
    local hook_name="$1"
    local error_type="$2"
    local error_message="$3"
    shift 3
    local suggestions=("$@")
    
    log_with_trace "ERROR" "$hook_name" "$error_type: $error_message"
    
    # Direct stderr output for Git hook visibility
    echo "" >&2
    printf "${COLOR_RED}✗ ERROR: %s${COLOR_RESET}\n" "$error_type" >&2
    printf "${COLOR_GRAY}%s${COLOR_RESET}\n" "$error_message" >&2
    echo "" >&2
    
    if [[ ${#suggestions[@]} -gt 0 ]]; then
        for suggestion in "${suggestions[@]}"; do
            echo "$suggestion" >&2
        done
        echo "" >&2
    fi
    
    printf "${COLOR_GRAY}💡 Bypass: BYPASS_HOOKS=1 git <command>${COLOR_RESET}\n" >&2
    printf "${COLOR_GRAY}📋 Log: %s${COLOR_RESET}\n" "$LOG_FILE" >&2
    printf "${COLOR_GRAY}🔍 Debug: bash -x %s/%s${COLOR_RESET}\n" "$HOOK_ROOT_DIR" "$hook_name" >&2
    echo "" >&2
}

# Report success with summary
report_success() {
    local hook_name="$1"
    local message="$2"
    
    log_to_file "INFO" "$hook_name" "SUCCESS: $message"
    print_success "$message"
}

# ==============================================================================
# BYPASS MECHANISMS
# ==============================================================================

# Check if hooks should be bypassed
should_bypass_hooks() {
    [[ "${BYPASS_HOOKS:-0}" == "1" ]]
}

# Check if protected branch restrictions should be bypassed
should_allow_protected() {
    [[ "${ALLOW_DIRECT_PROTECTED:-0}" == "1" ]]
}

# Log bypass usage
log_bypass() {
    local hook_name="$1"
    local bypass_type="$2"
    
    log_to_file "WARNING" "$hook_name" "BYPASS USED: $bypass_type by user: $(whoami)"
    print_warning "Hook bypassed: $bypass_type"
}

# ==============================================================================
# BRANCH DETECTION & VALIDATION
# ==============================================================================

# Get current branch name
get_current_branch() {
    git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "DETACHED"
}

# Get base branch for current branch
get_base_branch() {
    local current_branch="$1"
    
    # Try to detect from branch config first
    local configured_base
    configured_base=$(git config "branch.${current_branch}.base" 2>/dev/null || echo "")
    if [[ -n "$configured_base" ]]; then
        echo "$configured_base"
        return 0
    fi
    
    # Determine base from branch type
    case "$current_branch" in
        main|master)
            echo ""
            return 1
            ;;
        develop)
            # develop is a long-lived branch, not created from main
            echo ""
            return 1
            ;;
        release-*)
            # Release branches must come from develop (Git Flow)
            echo "develop"
            ;;
        hotfix-*)
            # Hotfix branches must come from main (Git Flow)
            echo "main"
            ;;
        *)
            # Feature, bugfix, and other branches come from develop
            echo "develop"
            ;;
    esac
}

# Check if branch is protected
is_protected_branch() {
    local branch="$1"
    
    for protected in "${PROTECTED_BRANCHES[@]}"; do
        if [[ "$branch" == "$protected" ]]; then
            return 0
        fi
    done
    
    return 1
}

# Validate branch name against patterns
validate_branch_name() {
    local branch="$1"
    
    # Long-lived branches
    if [[ "$branch" =~ $PATTERN_MAIN ]] || \
       [[ "$branch" =~ $PATTERN_DEVELOP ]] || \
       [[ "$branch" =~ $PATTERN_RELEASE ]]; then
        return 0
    fi
    
    # Short-lived branches
    if [[ "$branch" =~ $PATTERN_FEATURE ]] || \
       [[ "$branch" =~ $PATTERN_BUGFIX ]] || \
       [[ "$branch" =~ $PATTERN_HOTFIX ]] || \
       [[ "$branch" =~ $PATTERN_SUPPORT ]]; then
        return 0
    fi
    
    return 1
}

# Get branch type from name
get_branch_type() {
    local branch="$1"
    
    if [[ "$branch" =~ $PATTERN_MAIN ]]; then
        echo "main"
    elif [[ "$branch" =~ $PATTERN_DEVELOP ]]; then
        echo "develop"
    elif [[ "$branch" =~ $PATTERN_RELEASE ]]; then
        echo "release"
    elif [[ "$branch" =~ $PATTERN_HOTFIX ]]; then
        echo "hotfix"
    elif [[ "$branch" =~ $PATTERN_FEATURE ]]; then
        echo "feature"
    elif [[ "$branch" =~ $PATTERN_BUGFIX ]]; then
        echo "bugfix"
    elif [[ "$branch" =~ $PATTERN_SUPPORT ]]; then
        echo "support"
    else
        echo "unknown"
    fi
}

# Extract JIRA ID from branch name
extract_jira_id() {
    local branch="$1"
    
    if [[ "$branch" =~ ([A-Z]{2,10}-[0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}"
        return 0
    fi
    
    return 1
}

# Get valid branch examples based on current context
get_branch_examples() {
    local current_branch="$1"
    local jira_id="${2:-PROJ-123}"
    
    local examples=()
    
    case "$(get_branch_type "$current_branch")" in
        main|develop)
            examples+=(
                "feat-${jira_id}-add-user-authentication"
                "bugfix-${jira_id}-fix-memory-leak"
                "hotfix-${jira_id}-patch-security-vulnerability"
            )
            ;;
        release)
            examples+=(
                "hotfix-${jira_id}-critical-production-fix"
                "bugfix-${jira_id}-release-blocker"
            )
            ;;
        *)
            examples+=(
                "feat-${jira_id}-implement-new-feature"
                "fix-${jira_id}-resolve-critical-bug"
                "docs-${jira_id}-update-documentation"
            )
            ;;
    esac
    
    printf '%s\n' "${examples[@]}"
}

# ==============================================================================
# GIT FLOW VALIDATION
# ==============================================================================

# Validate branch creation point according to Git Flow
validate_branch_origin() {
    local branch="$1"
    local base_branch="$2"
    local branch_type
    branch_type="$(get_branch_type "$branch")"
    
    case "$branch_type" in
        feature|bugfix|support)
            if [[ "$base_branch" != "develop" ]]; then
                return 1
            fi
            ;;
        release)
            if [[ "$base_branch" != "develop" ]]; then
                return 1
            fi
            ;;
        hotfix)
            if [[ "$base_branch" != "main" ]]; then
                return 1
            fi
            ;;
    esac
    
    return 0
}

# Get allowed base branches for a branch type
get_allowed_bases() {
    local branch="$1"
    local branch_type
    branch_type="$(get_branch_type "$branch")"
    
    case "$branch_type" in
        feature|bugfix|support)
            echo "develop"
            ;;
        release)
            echo "develop"
            ;;
        hotfix)
            echo "main"
            ;;
        *)
            echo "develop or main"
            ;;
    esac
}

# Check if a branch type allows creating new branches FROM it
# Returns: 0 = allowed, 1 = blocked (release/hotfix), 2 = unusual (feature/bugfix)
can_branch_from() {
    local branch_type="$1"
    
    case "$branch_type" in
        main|develop)
            return 0  # Can create branches from long-lived branches
            ;;
        release|hotfix)
            return 1  # Cannot create branches from release or hotfix
            ;;
        feature|bugfix|support)
            return 2  # Unusual pattern, may indicate dependent features
            ;;
        *)
            return 0  # Unknown types allow (permissive for custom workflows)
            ;;
    esac
}

# Detect if any active release branches exist
has_active_release() {
    git branch --list 'release-*' 2>/dev/null | grep -q 'release-'
}

# Get list of active release branches
list_active_releases() {
    git branch --list 'release-*' 2>/dev/null | sed 's/^[* ]*//' || echo ""
}

# ==============================================================================
# COMMIT VALIDATION
# ==============================================================================

# Validate commit message format (strict - requires JIRA ID)
validate_commit_message() {
    local message="$1"
    
    # Allow merge commits
    if [[ "$message" =~ ^Merge ]]; then
        return 0
    fi
    
    # Allow revert commits
    if [[ "$message" =~ ^Revert ]]; then
        return 0
    fi
    
    # Check pattern
    if [[ "$message" =~ $COMMIT_MSG_PATTERN ]]; then
        return 0
    fi
    
    return 1
}

# Validate commit message with branch-aware rules
# Release branches: JIRA ID is OPTIONAL (soft validation per Git Flow)
# Other branches: JIRA ID is REQUIRED (strict validation)
validate_commit_message_for_branch() {
    local message="$1"
    local branch="$2"
    
    # Allow merge commits (all branches)
    if [[ "$message" =~ ^Merge ]]; then
        return 0
    fi
    
    # Allow revert commits (all branches)
    if [[ "$message" =~ ^Revert ]]; then
        return 0
    fi
    
    # Get branch type
    local branch_type
    branch_type="$(get_branch_type "$branch")"
    
    # RELEASE BRANCHES: Flexible validation (JIRA optional)
    # Per Git Flow: Release branches use version numbers, not JIRA IDs
    # Allow commits with OR without JIRA IDs
    if [[ "$branch_type" == "release" ]]; then
        # Pattern 1: Standard format WITH JIRA ID (feat: JIRA-123 description)
        if [[ "$message" =~ $COMMIT_MSG_PATTERN ]]; then
            return 0
        fi
        
        # Pattern 2: Standard format WITHOUT JIRA ID (feat: description)
        # Allows: feat: description, fix: description, chore: description, etc.
        if [[ "$message" =~ ^(feat|fix|chore|break|tests|docs|style|refactor|perf|build|ci|release|version):[[:space:]][^[:space:]].*$ ]]; then
            return 0
        fi
        
        # Pattern 3: Simple descriptive messages for release tasks
        # Allows: "Bump version to X.Y.Z", "Update changelog", "Prepare release"
        if [[ "$message" =~ ^(Bump|Update|Prepare|Release|Version|Finalize) ]]; then
            return 0
        fi
        
        # If none match, it's still invalid (must have SOME structure)
        return 1
    fi
    
    # ALL OTHER BRANCHES: Strict validation (JIRA required)
    # Feature, bugfix, hotfix, support branches MUST have JIRA IDs
    if [[ "$message" =~ $COMMIT_MSG_PATTERN ]]; then
        return 0
    fi
    
    return 1
}

# Get commit message example
get_commit_message_example() {
    local jira_id="${1:-PROJ-123}"
    
    cat <<EOF
feat: ${jira_id} Add user authentication system
fix: ${jira_id} Resolve memory leak in data processor
chore: ${jira_id} Update dependencies to latest versions
break: ${jira_id} Remove deprecated API endpoints
tests: ${jira_id} Add integration tests for payment module
EOF
}

# ==============================================================================
# HISTORY VALIDATION
# ==============================================================================

# Count commits between base and current branch
count_commits_ahead() {
    local base="$1"
    local head="${2:-HEAD}"
    
    # Ensure base exists
    if ! git rev-parse --verify "$base" >/dev/null 2>&1; then
        echo "0"
        return 1
    fi
    
    git rev-list --count "${base}..${head}" 2>/dev/null || echo "0"
}

# Check if history is linear (no merge commits)
has_linear_history() {
    local base="$1"
    local head="${2:-HEAD}"
    
    # Count merge commits
    local merge_count
    merge_count=$(git rev-list --merges --count "${base}..${head}" 2>/dev/null || echo "0")
    
    [[ "$merge_count" -eq 0 ]]
}

# Detect foxtrot merge pattern
has_foxtrot_merge() {
    local base="$1"
    local head="${2:-HEAD}"
    
    # A foxtrot merge is a merge commit where the first parent is not the target branch
    local merge_commits
    merge_commits=$(git rev-list --merges "${base}..${head}" 2>/dev/null || echo "")
    
    if [[ -z "$merge_commits" ]]; then
        return 1
    fi
    
    while IFS= read -r commit; do
        local first_parent
        first_parent=$(git rev-parse "${commit}^1" 2>/dev/null || echo "")
        
        if [[ -n "$first_parent" ]]; then
            # Check if first parent is reachable from base
            if ! git merge-base --is-ancestor "$first_parent" "$base" 2>/dev/null; then
                return 0
            fi
        fi
    done <<< "$merge_commits"
    
    return 1
}

# ==============================================================================
# FILE DETECTION
# ==============================================================================

# Detect package manager lockfiles
detect_lockfile_changes() {
    local commit_range="${1:-HEAD}"
    
    local lockfiles=(
        "package-lock.json"
        "yarn.lock"
        "pnpm-lock.yaml"
        "Gemfile.lock"
        "Pipfile.lock"
        "poetry.lock"
        "requirements.txt"
        "Cargo.lock"
        "go.sum"
        "composer.lock"
    )
    
    for lockfile in "${lockfiles[@]}"; do
        if git diff --name-only "$commit_range" | grep -q "^${lockfile}$"; then
            echo "$lockfile"
        fi
    done
}

# Detect infrastructure as code changes
detect_iac_changes() {
    local commit_range="${1:-HEAD}"
    
    local patterns=(
        "\.tf$"
        "\.tfvars$"
        "terraform\.tfstate"
        "\.yaml$"
        "\.yml$"
        "Dockerfile"
        "docker-compose"
        "\.tf\.json$"
    )
    
    for pattern in "${patterns[@]}"; do
        if git diff --name-only "$commit_range" | grep -E "$pattern" >/dev/null; then
            return 0
        fi
    done
    
    return 1
}

# Detect CI/CD configuration changes
detect_cicd_changes() {
    local commit_range="${1:-HEAD}"
    
    local patterns=(
        "\.github/workflows/"
        "\.gitlab-ci\.yml"
        "\.travis\.yml"
        "\.circleci/"
        "Jenkinsfile"
        "azure-pipelines"
        "buildspec\.yml"
    )
    
    for pattern in "${patterns[@]}"; do
        if git diff --name-only "$commit_range" | grep -E "$pattern" >/dev/null; then
            return 0
        fi
    done
    
    return 1
}

# ==============================================================================
# CONFIGURATION HELPERS
# ==============================================================================

# Get configuration value with default
get_config() {
    local key="$1"
    local default="$2"
    
    git config "$key" 2>/dev/null || echo "$default"
}

# Get max commits allowed (configurable)
get_max_commits() {
    get_config "hooks.maxCommits" "5"
}

# Check if auto-add after fix is enabled
is_auto_add_enabled() {
    local enabled
    enabled=$(get_config "hooks.autoAddAfterFix" "false")
    [[ "$enabled" == "true" ]]
}

# Check if parallel execution is enabled
is_parallel_enabled() {
    local enabled
    enabled=$(get_config "hooks.parallelExecution" "false")
    [[ "$enabled" == "true" ]]
}

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

# Check if we're in a git repository
is_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}

# Check if a remote exists
remote_exists() {
    local remote="${1:-origin}"
    git remote | grep -q "^${remote}$"
}

# Check if a branch exists locally
branch_exists_local() {
    local branch="$1"
    git show-ref --verify --quiet "refs/heads/${branch}"
}

# Check if a branch exists remotely
branch_exists_remote() {
    local branch="$1"
    local remote="${2:-origin}"
    git ls-remote --heads "$remote" "$branch" | grep -q "$branch"
}

# Get remote tracking branch
get_tracking_branch() {
    local branch="${1:-$(get_current_branch)}"
    git rev-parse --abbrev-ref "${branch}@{upstream}" 2>/dev/null || echo ""
}

# Print version information
print_version() {
    print_color "$COLOR_CYAN" "Git Hooks Suite v${HOOK_VERSION}"
    print_color "$COLOR_GRAY" "Enterprise-grade Git Flow enforcement"
}

# ==============================================================================
# INITIALIZATION
# ==============================================================================

# Initialize common library
init_common() {
    init_logging
    
    # Verify we're in a git repository
    if ! is_git_repo; then
        print_error "Not in a git repository"
        exit 1
    fi
}

# Run initialization if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    init_common
    print_version
fi
