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
# VALIDATION
# ==============================================================================

validate_git_repository() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        print_error "Not a git repository!"
        echo ""
        echo "Please run this script from within a git repository."
        exit 1
    fi
}

validate_hooks_directory() {
    if [[ ! -d "$HOOKS_DIR" ]]; then
        print_error "Hooks directory not found: $HOOKS_DIR"
        exit 1
    fi
    
    if [[ ! -f "$HOOKS_DIR/lib/common.sh" ]]; then
        print_error "Hook library not found: $HOOKS_DIR/lib/common.sh"
        exit 1
    fi
}

# ==============================================================================
# INSTALLATION STEPS
# ==============================================================================

# Step 1: Configure Git hooks path
configure_hooks_path() {
    print_info "Configuring Git hooks path..."
    
    # Calculate relative path from git root to hooks dir
    local rel_path
    rel_path=$(realpath --relative-to="$GIT_ROOT" "$HOOKS_DIR" 2>/dev/null || \
               python -c "import os.path; print(os.path.relpath('$HOOKS_DIR', '$GIT_ROOT'))" 2>/dev/null || \
               echo ".githooks")
    
    git config core.hooksPath "$rel_path"
    print_success "Hooks path set to: $rel_path"
}

# Step 2: Configure Git for optimal workflow
configure_git_settings() {
    print_info "Configuring Git settings..."
    
    # Enable auto-squash for interactive rebases
    git config rebase.autosquash true
    print_success "Enabled rebase.autosquash"
    
    # Prune deleted remote branches on fetch
    git config fetch.prune true
    print_success "Enabled fetch.prune"
    
    # Set default branch for new repositories (optional)
    git config init.defaultBranch main 2>/dev/null || true
    
    # Initialize hooks configuration if not set
    if ! git config hooks.maxCommits >/dev/null 2>&1; then
        git config hooks.maxCommits 5
        print_success "Set hooks.maxCommits to 5"
    fi
    
    # Initialize bypass warning style if not set (default: compact for minimal clutter)
    if ! git config hooks.bypassWarningStyle >/dev/null 2>&1; then
        git config hooks.bypassWarningStyle compact
        print_success "Set hooks.bypassWarningStyle to compact"
    fi
    
    # Set base branches for tracking
    local current_branch
    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")
    
    if [[ -n "$current_branch" ]] && [[ "$current_branch" != "main" ]] && [[ "$current_branch" != "develop" ]]; then
        # Try to set base branch if not configured
        if ! git config "branch.${current_branch}.base" >/dev/null 2>&1; then
            # Default to develop for feature branches
            if git rev-parse --verify develop >/dev/null 2>&1; then
                git config "branch.${current_branch}.base" develop
                print_success "Set base branch for ${current_branch}: develop"
            fi
        fi
    fi
}

# Step 3: Make hooks executable
make_hooks_executable() {
    print_info "Making hooks executable..."
    
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
    
    for hook in "${hooks[@]}"; do
        local hook_file="${HOOKS_DIR}/${hook}"
        if [[ -f "$hook_file" ]]; then
            chmod +x "$hook_file"
            print_success "Made executable: $hook"
        fi
    done
    
    # Make library files executable
    if [[ -f "${HOOKS_DIR}/lib/common.sh" ]]; then
        chmod +x "${HOOKS_DIR}/lib/common.sh"
        print_success "Made executable: lib/common.sh"
    fi
    
    if [[ -f "${HOOKS_DIR}/lib/command-runner.sh" ]]; then
        chmod +x "${HOOKS_DIR}/lib/command-runner.sh"
        print_success "Made executable: lib/command-runner.sh"
    fi
}

# Step 4: Initialize logging infrastructure
setup_logging() {
    print_info "Setting up logging infrastructure..."
    
    if [[ ! -d "$LOG_DIR" ]]; then
        mkdir -p "$LOG_DIR"
        print_success "Created log directory: $LOG_DIR"
    fi
    
    chmod 755 "$LOG_DIR" 2>/dev/null || true
    
    # Add logs to .git/info/exclude
    local exclude_file="${GIT_ROOT}/.git/info/exclude"
    if [[ -f "$exclude_file" ]]; then
        if ! grep -q "hooks-logs" "$exclude_file" 2>/dev/null; then
            echo "" >> "$exclude_file"
            echo "# Git hooks logs" >> "$exclude_file"
            echo "hooks-logs/" >> "$exclude_file"
            print_success "Added hooks-logs to .git/info/exclude"
        fi
    fi
    
    # Create initial log entry
    local log_file="${LOG_DIR}/hook-$(date +%Y-%m-%d).log"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] [INSTALL] Hooks installed successfully" >> "$log_file"
}

# Step 5: Create sample commands.conf if it doesn't exist
create_sample_config() {
    local config_file="${HOOKS_DIR}/commands.conf"
    
    if [[ -f "$config_file" ]]; then
        print_info "commands.conf already exists - skipping sample creation"
        return 0
    fi
    
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

    print_success "Created sample commands.conf"
    print_warning "Edit .githooks/commands.conf to customize for your project"
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
    make_hooks_executable
    setup_logging
    create_sample_config
    
    # Summary
    display_summary
}

# Execute main
main "$@"
