#!/usr/bin/env bash
# ==============================================================================
# Git Hooks Installation Script
# ==============================================================================
# Installs and configures the Git Flow enforcement hook suite.
#
# Features:
# - Sets core.hooksPath to .githooks
# - Configures Git for optimal workflow
# - Makes hooks executable
# - Initializes logging infrastructure
# - Creates .git/info/exclude entries
# - Displays configuration summary
#
# Usage:
#   ./install-hooks.sh
#
# Author: Enterprise Development Team
# ==============================================================================

set -euo pipefail

# ==============================================================================
# CONSTANTS
# ==============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly HOOKS_DIR="${SCRIPT_DIR}"
readonly GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
readonly LOG_DIR="${GIT_ROOT}/.git/hooks-logs"
readonly INSTALL_LOG_FILE="${LOG_DIR}/install-$(date +%Y%m%d-%H%M%S).log"

# Color codes
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_WHITE='\033[1;37m'
readonly COLOR_GRAY='\033[0;90m'
readonly COLOR_RESET='\033[0m'

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

print_color() {
    local color="$1"
    local message="$2"
    printf "${color}%s${COLOR_RESET}\n" "$message"
}

print_header() {
    local title="$1"
    echo ""
    print_color "$COLOR_CYAN" "========================================"
    print_color "$COLOR_CYAN" "  $title"
    print_color "$COLOR_CYAN" "========================================"
    echo ""
}

print_success() {
    print_color "$COLOR_GREEN" "✓ $1"
}

print_error() {
    print_color "$COLOR_RED" "✗ $1"
}

print_info() {
    print_color "$COLOR_BLUE" "ℹ $1"
}

print_warning() {
    print_color "$COLOR_YELLOW" "⚠ $1"
}

# ==============================================================================
# LOGGING FUNCTIONS
# ==============================================================================

# Initialize logging for install script
init_install_logging() {
    # Create log directory if it doesn't exist
    if [[ ! -d "$LOG_DIR" ]]; then
        mkdir -p "$LOG_DIR" 2>/dev/null || {
            print_warning "Failed to create log directory: $LOG_DIR"
            return 1
        }
    fi
    
    # Create log file with header
    {
        echo "========================================"
        echo "Git Hooks Installation Log"
        echo "========================================"
        echo "Timestamp: $(date +'%Y-%m-%d %H:%M:%S')"
        echo "User: ${USER:-${USERNAME:-unknown}}"
        echo "Hostname: $(hostname 2>/dev/null || echo 'unknown')"
        echo "Git Root: $GIT_ROOT"
        echo "Hooks Dir: $HOOKS_DIR"
        echo "OS: $(uname -s 2>/dev/null || echo 'Windows')"
        echo "Shell: $BASH_VERSION"
        echo "========================================"
        echo ""
    } > "$INSTALL_LOG_FILE" 2>/dev/null || {
        print_warning "Failed to initialize log file: $INSTALL_LOG_FILE"
        return 1
    }
    
    return 0
}

# Log to installation log file
log_install() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    
    # Write to log file
    echo "[${timestamp}] [${level}] ${message}" >> "$INSTALL_LOG_FILE" 2>/dev/null || true
    
    # Also write errors to stderr in log
    if [[ "$level" == "ERROR" ]]; then
        echo "[${timestamp}] [${level}] ${message}" >> "$INSTALL_LOG_FILE" 2>&1 || true
    fi
}

# Log command execution with output capture
log_command() {
    local description="$1"
    shift
    local cmd="$*"
    
    log_install "INFO" "Executing: $description"
    log_install "DEBUG" "Command: $cmd"
    
    # Capture both stdout and stderr
    local output
    local exit_code=0
    
    output=$("$@" 2>&1) || exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        log_install "INFO" "Success: $description"
        if [[ -n "$output" ]]; then
            log_install "DEBUG" "Output: $output"
        fi
    else
        log_install "ERROR" "Failed: $description (exit code: $exit_code)"
        if [[ -n "$output" ]]; then
            log_install "ERROR" "Error output: $output"
        fi
    fi
    
    return $exit_code
}

# ==============================================================================
# VALIDATION
# ==============================================================================

validate_git_repository() {
    log_install "INFO" "Validating git repository"
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        log_install "ERROR" "Not a git repository"
        print_error "Not a git repository!"
        echo ""
        echo "Please run this script from within a git repository."
        exit 1
    fi
    log_install "INFO" "Git repository validated successfully"
}

validate_hooks_directory() {
    log_install "INFO" "Validating hooks directory: $HOOKS_DIR"
    if [[ ! -d "$HOOKS_DIR" ]]; then
        log_install "ERROR" "Hooks directory not found: $HOOKS_DIR"
        print_error "Hooks directory not found: $HOOKS_DIR"
        exit 1
    fi
    
    if [[ ! -f "$HOOKS_DIR/lib/common.sh" ]]; then
        log_install "ERROR" "Hook library not found: $HOOKS_DIR/lib/common.sh"
        print_error "Hook library not found: $HOOKS_DIR/lib/common.sh"
        exit 1
    fi
    log_install "INFO" "Hooks directory validated successfully"
}

# ==============================================================================
# INSTALLATION STEPS
# ==============================================================================

# Step 1: Configure Git hooks path
configure_hooks_path() {
    print_info "Configuring Git hooks path..."
    log_install "INFO" "Configuring Git hooks path"
    
    # Calculate relative path from git root to hooks dir
    local rel_path
    rel_path=$(realpath --relative-to="$GIT_ROOT" "$HOOKS_DIR" 2>/dev/null || \
               python -c "import os.path; print(os.path.relpath('$HOOKS_DIR', '$GIT_ROOT'))" 2>/dev/null || \
               echo ".githooks")
    
    log_install "DEBUG" "Calculated relative path: $rel_path"
    
    if git config core.hooksPath "$rel_path"; then
        log_install "INFO" "Successfully set core.hooksPath to: $rel_path"
        print_success "Hooks path set to: $rel_path"
    else
        log_install "ERROR" "Failed to set core.hooksPath"
        print_error "Failed to set hooks path"
        return 1
    fi
}

# Step 2: Configure Git for optimal workflow
configure_git_settings() {
    print_info "Configuring Git settings..."
    log_install "INFO" "Configuring Git settings"
    
    # Enable auto-squash for interactive rebases
    if git config rebase.autosquash true; then
        log_install "INFO" "Enabled rebase.autosquash"
        print_success "Enabled rebase.autosquash"
    else
        log_install "WARNING" "Failed to enable rebase.autosquash"
    fi
    
    # Prune deleted remote branches on fetch
    if git config fetch.prune true; then
        log_install "INFO" "Enabled fetch.prune"
        print_success "Enabled fetch.prune"
    else
        log_install "WARNING" "Failed to enable fetch.prune"
    fi
    
    # Set default branch for new repositories (optional)
    git config init.defaultBranch main 2>/dev/null || true
    log_install "DEBUG" "Attempted to set init.defaultBranch to main"
    
    # Initialize hooks configuration if not set
    if ! git config hooks.maxCommits >/dev/null 2>&1; then
        git config hooks.maxCommits 5
        log_install "INFO" "Set hooks.maxCommits to 5"
        print_success "Set hooks.maxCommits to 5"
    else
        local current_max
        current_max=$(git config hooks.maxCommits)
        log_install "DEBUG" "hooks.maxCommits already set to: $current_max"
    fi
    
    # Initialize bypass warning style if not set (default: compact for minimal clutter)
    if ! git config hooks.bypassWarningStyle >/dev/null 2>&1; then
        git config hooks.bypassWarningStyle compact
        log_install "INFO" "Set hooks.bypassWarningStyle to compact"
        print_success "Set hooks.bypassWarningStyle to compact"
    else
        local current_style
        current_style=$(git config hooks.bypassWarningStyle)
        log_install "DEBUG" "hooks.bypassWarningStyle already set to: $current_style"
    fi
    
    # Set base branches for tracking
    local current_branch
    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")
    log_install "DEBUG" "Current branch: ${current_branch:-<none>}"
    
    if [[ -n "$current_branch" ]] && [[ "$current_branch" != "main" ]] && [[ "$current_branch" != "develop" ]]; then
        # Try to set base branch if not configured
        if ! git config "branch.${current_branch}.base" >/dev/null 2>&1; then
            # Determine correct base branch based on Git Flow branch type
            local base_branch=""
            
            case "$current_branch" in
                release-*)
                    # Release branches come from develop
                    base_branch="develop"
                    log_install "DEBUG" "Detected release branch, base should be: develop"
                    ;;
                hotfix-*)
                    # Hotfix branches come from main
                    base_branch="main"
                    log_install "DEBUG" "Detected hotfix branch, base should be: main"
                    ;;
                *)
                    # Feature, bugfix, and other branches come from develop
                    base_branch="develop"
                    log_install "DEBUG" "Detected feature/bugfix branch, base should be: develop"
                    ;;
            esac
            
            if [[ -n "$base_branch" ]] && git rev-parse --verify "$base_branch" >/dev/null 2>&1; then
                git config "branch.${current_branch}.base" "$base_branch"
                log_install "INFO" "Set base branch for ${current_branch}: $base_branch"
                print_success "Set base branch for ${current_branch}: $base_branch"
            else
                log_install "WARNING" "Base branch '$base_branch' not found, skipping base config for ${current_branch}"
            fi
        else
            local existing_base
            existing_base=$(git config "branch.${current_branch}.base")
            log_install "DEBUG" "Branch ${current_branch} already has base configured: $existing_base"
        fi
    fi
}

# Fix existing misconfigured base branches
fix_existing_base_configs() {
    print_info "Checking for misconfigured base branches..."
    log_install "INFO" "Checking for misconfigured base branches"
    
    local fixed_count=0
    local checked_count=0
    
    # Get all branches with .base config
    while IFS= read -r config_line; do
        if [[ -z "$config_line" ]]; then
            continue
        fi
        
        checked_count=$((checked_count + 1))
        
        # Extract branch name and current base value
        local branch_config="${config_line%% *}"
        local current_base="${config_line##* }"
        local branch_name="${branch_config#branch.}"
        branch_name="${branch_name%.base}"
        
        log_install "DEBUG" "Checking branch: $branch_name (current base: $current_base)"
        
        # Determine what the correct base should be
        local correct_base=""
        case "$branch_name" in
            release-*)
                correct_base="develop"
                ;;
            hotfix-*)
                correct_base="main"
                ;;
            *)
                correct_base="develop"
                ;;
        esac
        
        # Fix if incorrect
        if [[ "$current_base" != "$correct_base" ]]; then
            log_install "WARNING" "Fixing misconfigured branch: $branch_name (was: $current_base → now: $correct_base)"
            print_warning "Fixing: $branch_name (was: $current_base → now: $correct_base)"
            git config "branch.${branch_name}.base" "$correct_base"
            fixed_count=$((fixed_count + 1))
        fi
    done < <(git config --get-regexp '^branch\..*\.base$' 2>/dev/null || true)
    
    if [[ $fixed_count -gt 0 ]]; then
        log_install "INFO" "Fixed $fixed_count misconfigured branch(es)"
        print_success "Fixed $fixed_count misconfigured branch(es)"
    elif [[ $checked_count -gt 0 ]]; then
        log_install "INFO" "All $checked_count branch configs are correct"
        print_success "All $checked_count branch configs are correct"
    else
        log_install "DEBUG" "No branch.*.base configurations found"
    fi
}

# Step 3: Make hooks executable
make_hooks_executable() {
    print_info "Making hooks executable..."
    log_install "INFO" "Making hooks executable"
    
    local hooks=(
        "pre-commit"
        "prepare-commit-msg"
        "commit-msg"
        "post-commit"
        "pre-push"
        "post-checkout"
        "post-rewrite"
        "applypatch-msg"
    )
    
    local success_count=0
    local fail_count=0
    
    for hook in "${hooks[@]}"; do
        local hook_file="${HOOKS_DIR}/${hook}"
        if [[ -f "$hook_file" ]]; then
            if chmod +x "$hook_file" 2>/dev/null; then
                log_install "INFO" "Made executable: $hook"
                print_success "Made executable: $hook"
                ((success_count++))
            else
                log_install "ERROR" "Failed to make executable: $hook"
                print_error "Failed to make executable: $hook"
                ((fail_count++))
            fi
        else
            log_install "WARNING" "Hook file not found: $hook"
        fi
    done
    
    # Make library files executable
    if [[ -f "${HOOKS_DIR}/lib/common.sh" ]]; then
        if chmod +x "${HOOKS_DIR}/lib/common.sh" 2>/dev/null; then
            log_install "INFO" "Made executable: lib/common.sh"
            print_success "Made executable: lib/common.sh"
            ((success_count++))
        else
            log_install "ERROR" "Failed to make executable: lib/common.sh"
            ((fail_count++))
        fi
    else
        log_install "WARNING" "Library file not found: lib/common.sh"
    fi
    
    if [[ -f "${HOOKS_DIR}/lib/command-runner.sh" ]]; then
        if chmod +x "${HOOKS_DIR}/lib/command-runner.sh" 2>/dev/null; then
            log_install "INFO" "Made executable: lib/command-runner.sh"
            print_success "Made executable: lib/command-runner.sh"
            ((success_count++))
        else
            log_install "ERROR" "Failed to make executable: lib/command-runner.sh"
            ((fail_count++))
        fi
    else
        log_install "WARNING" "Library file not found: lib/command-runner.sh"
    fi
    
    log_install "INFO" "Made executable: $success_count files, $fail_count failures"
    
    if [[ $fail_count -gt 0 ]]; then
        log_install "WARNING" "Some files could not be made executable - check permissions"
        return 1
    fi
    
    return 0
}

# Step 4: Initialize logging infrastructure
setup_logging() {
    print_info "Setting up logging infrastructure..."
    log_install "INFO" "Setting up logging infrastructure"
    
    if [[ ! -d "$LOG_DIR" ]]; then
        if mkdir -p "$LOG_DIR" 2>/dev/null; then
            log_install "INFO" "Created log directory: $LOG_DIR"
            print_success "Created log directory: $LOG_DIR"
        else
            log_install "ERROR" "Failed to create log directory: $LOG_DIR"
            print_error "Failed to create log directory: $LOG_DIR"
            return 1
        fi
    else
        log_install "DEBUG" "Log directory already exists: $LOG_DIR"
    fi
    
    if chmod 755 "$LOG_DIR" 2>/dev/null; then
        log_install "DEBUG" "Set permissions 755 on log directory"
    else
        log_install "WARNING" "Failed to set permissions on log directory"
    fi
    
    # Add logs to .git/info/exclude
    local exclude_file="${GIT_ROOT}/.git/info/exclude"
    if [[ -f "$exclude_file" ]]; then
        if ! grep -q "hooks-logs" "$exclude_file" 2>/dev/null; then
            if echo -e "\n# Git hooks logs\nhooks-logs/" >> "$exclude_file" 2>/dev/null; then
                log_install "INFO" "Added hooks-logs to .git/info/exclude"
                print_success "Added hooks-logs to .git/info/exclude"
            else
                log_install "WARNING" "Failed to add hooks-logs to .git/info/exclude"
            fi
        else
            log_install "DEBUG" "hooks-logs already in .git/info/exclude"
        fi
    else
        log_install "WARNING" ".git/info/exclude file not found"
    fi
    
    # Create initial log entry in hook log (separate from install log)
    local log_file="${LOG_DIR}/hook-$(date +%Y-%m-%d).log"
    if echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] [INSTALL] Hooks installed successfully" >> "$log_file" 2>/dev/null; then
        log_install "INFO" "Created initial hook log entry: $log_file"
    else
        log_install "WARNING" "Failed to create initial hook log entry"
    fi
    
    return 0
}

# Step 5: Create sample commands.conf if it doesn't exist
create_sample_config() {
    local config_file="${HOOKS_DIR}/commands.conf"
    
    log_install "INFO" "Checking for commands.conf"
    
    if [[ -f "$config_file" ]]; then
        log_install "INFO" "commands.conf already exists at: $config_file - skipping sample creation"
        print_info "commands.conf already exists - skipping sample creation"
        return 0
    fi
    
    log_install "INFO" "Creating sample commands.conf at: $config_file"
    print_info "Creating sample commands.conf..."
    
    cat > "$config_file" <<'EOF'
# ==============================================================================
# Git Hooks Custom Commands Configuration
# ==============================================================================
# Format: HOOK:PRIORITY:MANDATORY:TIMEOUT:COMMAND:DESCRIPTION
#
# Fields:
#   HOOK        - Hook name (pre-commit, pre-push, commit-msg, etc.)
#   PRIORITY    - Execution order (lower runs first)
#   MANDATORY   - true/false (whether failure blocks the hook)
#   TIMEOUT     - Maximum execution time in seconds
#   COMMAND     - Shell command to execute
#   DESCRIPTION - Human-readable description
#
# Variables:
#   {staged}    - Expands to list of staged files (pre-commit only)
#
# Examples:
# pre-commit:1:true:30:npx prettier --check {staged}:Format Check
# pre-commit:2:true:60:npx eslint {staged}:Lint Check
# pre-commit:3:false:120:npx tsc --noEmit:TypeScript Check
# pre-push:1:true:300:npm test:Run Tests
# pre-push:2:false:600:npm run build:Build Project
#
# ==============================================================================

# Uncomment and customize the commands below for your project

# JavaScript/TypeScript Projects
# pre-commit:1:true:30:npx prettier --check {staged}:Prettier Format Check
# pre-commit:2:true:60:npx eslint {staged}:ESLint
# pre-commit:3:false:120:npx tsc --noEmit --skipLibCheck:TypeScript Check
# pre-push:1:true:300:npm test:Run Test Suite
# pre-push:2:false:600:npm run build:Build Project

# Python Projects
# pre-commit:1:true:30:black --check {staged}:Black Format Check
# pre-commit:2:true:60:flake8 {staged}:Flake8 Linting
# pre-commit:3:false:60:mypy {staged}:MyPy Type Check
# pre-push:1:true:300:pytest:Run Tests

# Go Projects
# pre-commit:1:true:30:gofmt -l {staged}:Go Format Check
# pre-commit:2:true:60:go vet ./...:Go Vet
# pre-push:1:true:300:go test ./...:Run Tests

# General
# pre-commit:1:true:10:echo "Running pre-commit checks...":Info Message
EOF

    if [[ -f "$config_file" ]]; then
        log_install "INFO" "Successfully created sample commands.conf"
        print_success "Created sample commands.conf"
        print_warning "Edit .githooks/commands.conf to customize for your project"
    else
        log_install "ERROR" "Failed to create sample commands.conf"
        print_error "Failed to create sample commands.conf"
        return 1
    fi
    
    return 0
}

# ==============================================================================
# SUMMARY & TEST COMMANDS
# ==============================================================================

display_summary() {
    print_header "Installation Complete!"
    
    print_success "Git hooks successfully installed and configured"
    echo ""
    
    print_color "$COLOR_CYAN" "Configuration Summary:"
    print_color "$COLOR_WHITE" "  Hooks Directory: $(git config core.hooksPath)"
    print_color "$COLOR_WHITE" "  Max Commits: $(git config hooks.maxCommits)"
    print_color "$COLOR_WHITE" "  Auto-squash: $(git config rebase.autosquash)"
    print_color "$COLOR_WHITE" "  Fetch Prune: $(git config fetch.prune)"
    print_color "$COLOR_WHITE" "  Log Directory: $LOG_DIR"
    echo ""
    
    print_color "$COLOR_CYAN" "Active Hooks:"
    local hooks=(pre-commit prepare-commit-msg commit-msg post-commit pre-push post-checkout post-rewrite applypatch-msg)
    for hook in "${hooks[@]}"; do
        if [[ -f "${HOOKS_DIR}/${hook}" ]]; then
            print_color "$COLOR_GREEN" "  ✓ $hook"
        fi
    done
    echo ""
    
    print_color "$COLOR_CYAN" "Configuration Options:"
    print_color "$COLOR_GRAY" "  • hooks.maxCommits          - Maximum commits per branch (default: 5)"
    print_color "$COLOR_GRAY" "  • hooks.autoAddAfterFix     - Auto-stage files after fix (default: false)"
    print_color "$COLOR_GRAY" "  • hooks.parallelExecution   - Run commands in parallel (default: false)"
    print_color "$COLOR_GRAY" "  • branch.<name>.base        - Set base branch for tracking"
    echo ""
    print_color "$COLOR_WHITE" "Example: git config hooks.maxCommits 10"
    echo ""
    
    print_color "$COLOR_CYAN" "Bypass Mechanisms:"
    print_color "$COLOR_GRAY" "  • BYPASS_HOOKS=1 git commit              - Skip all hooks"
    print_color "$COLOR_GRAY" "  • ALLOW_DIRECT_PROTECTED=1 git commit    - Allow protected branch commits"
    echo ""
    
    print_color "$COLOR_CYAN" "Test Commands:"
    echo ""
    print_color "$COLOR_GRAY" "  Test commit message validation:"
    print_color "$COLOR_WHITE" "    echo \"Invalid message\" | git commit --allow-empty -F -"
    echo ""
    print_color "$COLOR_GRAY" "  Test branch naming (will fail on invalid names):"
    print_color "$COLOR_WHITE" "    git checkout -b invalid-branch-name"
    echo ""
    print_color "$COLOR_GRAY" "  Test protected branch commit:"
    print_color "$COLOR_WHITE" "    git checkout main"
    print_color "$COLOR_WHITE" "    git commit --allow-empty -m \"feat: TEST-123 Test commit\""
    echo ""
    print_color "$COLOR_GRAY" "  Create a valid feature branch:"
    print_color "$COLOR_WHITE" "    git checkout develop"
    print_color "$COLOR_WHITE" "    git checkout -b feat-PROJ-123-test-feature develop"
    print_color "$COLOR_WHITE" "    git config branch.feat-PROJ-123-test-feature.base develop"
    echo ""
    print_color "$COLOR_GRAY" "  View logs:"
    print_color "$COLOR_WHITE" "    cat ${LOG_DIR}/hook-\$(date +%Y-%m-%d).log"
    echo ""
    
    print_color "$COLOR_CYAN" "Next Steps:"
    print_color "$COLOR_GRAY" "  1. Review and customize .githooks/commands.conf"
    print_color "$COLOR_GRAY" "  2. Set base branches for your feature branches"
    print_color "$COLOR_GRAY" "  3. Test hooks with the commands above"
    print_color "$COLOR_GRAY" "  4. Share this setup with your team"
    echo ""
    
    print_color "$COLOR_CYAN" "Documentation:"
    print_color "$COLOR_GRAY" "  • Git Flow Model: https://nvie.com/posts/a-successful-git-branching-model/"
    print_color "$COLOR_GRAY" "  • Hooks Documentation: See .githooks/README.md"
    echo ""
    
    print_color "$COLOR_YELLOW" "========================================="
    print_color "$COLOR_YELLOW" " Installation successful! 🎉"
    print_color "$COLOR_YELLOW" "========================================="
    echo ""
}

# ==============================================================================
# MAIN INSTALLATION FLOW
# ==============================================================================

main() {
    # Initialize logging FIRST (before any other operations)
    if ! init_install_logging; then
        print_warning "Proceeding without logging capability"
    fi
    
    log_install "INFO" "============================================"
    log_install "INFO" "Starting Git Hooks Installation"
    log_install "INFO" "============================================"
    
    print_header "Git Hooks Installation"
    
    # Validation
    validate_git_repository
    validate_hooks_directory
    
    echo ""
    print_info "Installing Git Flow enforcement hooks..."
    echo ""
    
    # Installation steps
    configure_hooks_path
    configure_git_settings
    fix_existing_base_configs
    make_hooks_executable
    setup_logging
    create_sample_config
    
    # Summary
    display_summary
    
    # Finalize logging
    log_install "INFO" "============================================"
    log_install "INFO" "Installation completed successfully"
    log_install "INFO" "Log file: $INSTALL_LOG_FILE"
    log_install "INFO" "============================================"
    
    echo ""
    print_success "Installation log saved to: $INSTALL_LOG_FILE"
}

# Execute main
main "$@"
