#!/usr/bin/env bash
# ==============================================================================
# Git Hooks Uninstallation Script
# ==============================================================================
# Safely removes the Git Flow enforcement hook suite and restores defaults.
#
# Features:
# - Removes hooks configuration
# - Archives logs before deletion
# - Restores default Git settings
# - Confirmation prompt for safety
#
# Usage:
#   ./uninstall-hooks.sh
#
# Author: Enterprise Development Team
# ==============================================================================

set -euo pipefail

# ==============================================================================
# CONSTANTS
# ==============================================================================

readonly GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
readonly LOG_DIR="${GIT_ROOT}/.git/hooks-logs"
readonly ARCHIVE_DIR="${GIT_ROOT}/.git/hooks-logs-archive"

# Color codes
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_WHITE='\033[1;37m'
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

print_warning() {
    print_color "$COLOR_YELLOW" "⚠ $1"
}

print_error() {
    print_color "$COLOR_RED" "✗ $1"
}

# ==============================================================================
# CONFIRMATION
# ==============================================================================

confirm_uninstall() {
    print_header "Git Hooks Uninstallation"
    
    print_warning "This will remove all Git hook configurations."
    echo ""
    print_color "$COLOR_WHITE" "The following will be removed:"
    print_color "$COLOR_WHITE" "  • core.hooksPath configuration"
    print_color "$COLOR_WHITE" "  • rebase.autosquash configuration"
    print_color "$COLOR_WHITE" "  • fetch.prune configuration"
    print_color "$COLOR_WHITE" "  • hooks.* configurations"
    print_color "$COLOR_WHITE" "  • branch.*.base configurations"
    echo ""
    print_color "$COLOR_WHITE" "Logs will be archived to:"
    print_color "$COLOR_WHITE" "  $ARCHIVE_DIR"
    echo ""
    
    read -p "Are you sure you want to uninstall? (yes/no): " -r response
    echo ""
    
    if [[ "$response" != "yes" ]]; then
        print_color "$COLOR_CYAN" "Uninstallation cancelled."
        exit 0
    fi
}

# ==============================================================================
# UNINSTALLATION STEPS
# ==============================================================================

# Step 1: Archive logs
archive_logs() {
    if [[ -d "$LOG_DIR" ]]; then
        print_color "$COLOR_CYAN" "Archiving logs..."
        
        local timestamp
        timestamp=$(date +%Y%m%d-%H%M%S)
        local archive_path="${ARCHIVE_DIR}/hooks-logs-${timestamp}"
        
        mkdir -p "$archive_path"
        cp -r "$LOG_DIR"/* "$archive_path/" 2>/dev/null || true
        
        print_success "Logs archived to: $archive_path"
        
        # Remove original logs
        rm -rf "$LOG_DIR"
        print_success "Removed log directory"
    else
        print_color "$COLOR_CYAN" "No logs found to archive"
    fi
}

# Step 2: Remove Git configurations
remove_configurations() {
    print_color "$COLOR_CYAN" "Removing Git configurations..."
    
    # Remove hooks path
    if git config core.hooksPath >/dev/null 2>&1; then
        git config --unset core.hooksPath
        print_success "Removed core.hooksPath"
    fi
    
    # Remove workflow configurations
    if git config rebase.autosquash >/dev/null 2>&1; then
        git config --unset rebase.autosquash
        print_success "Removed rebase.autosquash"
    fi
    
    if git config fetch.prune >/dev/null 2>&1; then
        git config --unset fetch.prune
        print_success "Removed fetch.prune"
    fi
    
    # Remove hooks configurations
    for key in $(git config --get-regexp '^hooks\.' | awk '{print $1}'); do
        git config --unset "$key"
        print_success "Removed $key"
    done
    
    # Remove branch base configurations
    for key in $(git config --get-regexp '^branch\..*\.base$' | awk '{print $1}'); do
        git config --unset "$key"
        print_success "Removed $key"
    done
}

# Step 3: Display summary
display_summary() {
    print_header "Uninstallation Complete"
    
    print_success "Git hooks have been uninstalled"
    echo ""
    
    print_color "$COLOR_CYAN" "What was removed:"
    print_color "$COLOR_WHITE" "  • All hook configurations"
    print_color "$COLOR_WHITE" "  • Workflow settings"
    print_color "$COLOR_WHITE" "  • Branch tracking"
    echo ""
    
    print_color "$COLOR_CYAN" "What remains:"
    print_color "$COLOR_WHITE" "  • Hook files in .githooks/ (not deleted)"
    print_color "$COLOR_WHITE" "  • Archived logs in $ARCHIVE_DIR"
    echo ""
    
    print_color "$COLOR_CYAN" "To reinstall:"
    print_color "$COLOR_WHITE" "  ./.githooks/install-hooks.sh"
    echo ""
    
    print_color "$COLOR_GREEN" "========================================="
    print_color "$COLOR_GREEN" " Uninstallation complete!"
    print_color "$COLOR_GREEN" "========================================="
    echo ""
}

# ==============================================================================
# MAIN UNINSTALLATION FLOW
# ==============================================================================

main() {
    # Confirmation
    confirm_uninstall
    
    # Uninstallation steps
    archive_logs
    remove_configurations
    
    # Summary
    display_summary
}

# Execute main
main "$@"
