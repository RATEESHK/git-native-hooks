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
readonly SESSION_MARKERS_PATTERN="${GIT_ROOT}/.git/.bypass-warned-*"
readonly UNINSTALL_LOG_FILE="${ARCHIVE_DIR}/uninstall-$(date +%Y%m%d-%H%M%S).log"

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
# LOGGING FUNCTIONS
# ==============================================================================

# Initialize logging for uninstall script
init_uninstall_logging() {
    # Create archive directory if it doesn't exist
    if [[ ! -d "$ARCHIVE_DIR" ]]; then
        if ! mkdir -p "$ARCHIVE_DIR" 2>/dev/null; then
            # Archive dir creation failed - try to create log in .git directory as fallback
            print_warning "Failed to create archive directory: $ARCHIVE_DIR"
            print_warning "Attempting to create log in .git directory as fallback"
            
            # Fallback: create log in .git directory directly
            local fallback_log="${GIT_ROOT}/.git/uninstall-$(date +%Y%m%d-%H%M%S).log"
            
            {
                echo "========================================"
                echo "Git Hooks Uninstallation Log (FALLBACK)"
                echo "========================================"
                echo "WARNING: Archive directory creation failed"
                echo "Archive dir attempted: $ARCHIVE_DIR"
                echo "Timestamp: $(date +'%Y-%m-%d %H:%M:%S')"
                echo "User: ${USER:-${USERNAME:-unknown}}"
                echo "Hostname: $(hostname 2>/dev/null || echo 'unknown')"
                echo "Git Root: $GIT_ROOT"
                echo "OS: $(uname -s 2>/dev/null || echo 'Windows')"
                echo "Shell: $BASH_VERSION"
                echo "========================================"
                echo ""
                echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] Failed to create archive directory: $ARCHIVE_DIR"
                echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] Using fallback log location: $fallback_log"
            } > "$fallback_log" 2>/dev/null || {
                # Even fallback failed - proceed without logging but warn user
                print_error "Failed to create log file even in fallback location"
                print_warning "Proceeding without logging capability"
                return 1
            }
            
            # Update log file path to fallback location
            UNINSTALL_LOG_FILE="$fallback_log"
            print_success "Created fallback log file: $fallback_log"
            return 0
        fi
    fi
    
    # Create log file with header
    {
        echo "========================================"
        echo "Git Hooks Uninstallation Log"
        echo "========================================"
        echo "Timestamp: $(date +'%Y-%m-%d %H:%M:%S')"
        echo "User: ${USER:-${USERNAME:-unknown}}"
        echo "Hostname: $(hostname 2>/dev/null || echo 'unknown')"
        echo "Git Root: $GIT_ROOT"
        echo "OS: $(uname -s 2>/dev/null || echo 'Windows')"
        echo "Shell: $BASH_VERSION"
        echo "========================================"
        echo ""
    } > "$UNINSTALL_LOG_FILE" 2>/dev/null || {
        print_warning "Failed to initialize log file: $UNINSTALL_LOG_FILE"
        return 1
    }
    
    return 0
}

# Log to uninstallation log file
log_uninstall() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    
    # Write to log file
    echo "[${timestamp}] [${level}] ${message}" >> "$UNINSTALL_LOG_FILE" 2>/dev/null || true
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
    print_color "$COLOR_WHITE" "  • hooks.* configurations (including bypassWarningStyle)"
    print_color "$COLOR_WHITE" "  • branch.*.base configurations"
    print_color "$COLOR_WHITE" "  • branch.*.createdfrom tracking"
    print_color "$COLOR_WHITE" "  • Bypass warning session markers"
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
    log_uninstall "INFO" "Archiving hook logs"
    if [[ -d "$LOG_DIR" ]]; then
        print_color "$COLOR_CYAN" "Archiving logs..."
        
        local timestamp
        timestamp=$(date +%Y%m%d-%H%M%S)
        local archive_path="${ARCHIVE_DIR}/hooks-logs-${timestamp}"
        
        log_uninstall "DEBUG" "Archive path: $archive_path"
        mkdir -p "$archive_path"
        cp -r "$LOG_DIR"/* "$archive_path/" 2>/dev/null || true
        
        log_uninstall "INFO" "Logs archived to: $archive_path"
        print_success "Logs archived to: $archive_path"
        
        # Remove original logs
        rm -rf "$LOG_DIR"
        log_uninstall "INFO" "Removed original log directory: $LOG_DIR"
        print_success "Removed log directory"
    else
        log_uninstall "INFO" "No logs found to archive"
        print_color "$COLOR_CYAN" "No logs found to archive"
    fi
}

# Step 2: Clean bypass warning session markers
clean_session_markers() {
    log_uninstall "INFO" "Cleaning bypass warning session markers"
    print_color "$COLOR_CYAN" "Cleaning bypass warning session markers..."
    
    local marker_count=0
    # Use bash glob to find session marker files
    shopt -s nullglob
    local markers=("${GIT_ROOT}/.git/.bypass-warned-"*)
    shopt -u nullglob
    
    if [[ ${#markers[@]} -gt 0 ]]; then
        log_uninstall "DEBUG" "Found ${#markers[@]} session marker(s)"
        for marker in "${markers[@]}"; do
            if [[ -f "$marker" ]]; then
                log_uninstall "DEBUG" "Removing marker: $marker"
                rm -f "$marker" 2>/dev/null || true
                ((marker_count++))
            fi
        done
        
        if [[ $marker_count -gt 0 ]]; then
            log_uninstall "INFO" "Removed $marker_count bypass warning session marker(s)"
            print_success "Removed $marker_count bypass warning session marker(s)"
        fi
    else
        log_uninstall "INFO" "No bypass warning session markers found"
        print_color "$COLOR_CYAN" "No bypass warning session markers found"
    fi
}

# Step 3: Remove Git configurations
remove_configurations() {
    log_uninstall "INFO" "Removing Git configurations"
    print_color "$COLOR_CYAN" "Removing Git configurations..."
    
    # Remove hooks path
    if git config core.hooksPath >/dev/null 2>&1; then
        local hooks_path
        hooks_path=$(git config core.hooksPath)
        git config --unset core.hooksPath
        log_uninstall "INFO" "Removed core.hooksPath: $hooks_path"
        print_success "Removed core.hooksPath"
    else
        log_uninstall "DEBUG" "core.hooksPath not set"
    fi
    
    # Remove workflow configurations
    if git config rebase.autosquash >/dev/null 2>&1; then
        git config --unset rebase.autosquash
        log_uninstall "INFO" "Removed rebase.autosquash"
        print_success "Removed rebase.autosquash"
    else
        log_uninstall "DEBUG" "rebase.autosquash not set"
    fi
    
    if git config fetch.prune >/dev/null 2>&1; then
        git config --unset fetch.prune
        log_uninstall "INFO" "Removed fetch.prune"
        print_success "Removed fetch.prune"
    else
        log_uninstall "DEBUG" "fetch.prune not set"
    fi
    
    # Remove hooks configurations (including hooks.bypassWarningStyle)
    local hooks_config_count=0
    for key in $(git config --get-regexp '^hooks\.' 2>/dev/null | awk '{print $1}'); do
        git config --unset "$key" 2>/dev/null || true
        log_uninstall "INFO" "Removed config: $key"
        print_success "Removed $key"
        ((hooks_config_count++))
    done
    
    if [[ $hooks_config_count -eq 0 ]]; then
        log_uninstall "INFO" "No hooks.* configurations found"
        print_color "$COLOR_CYAN" "No hooks.* configurations found"
    else
        log_uninstall "INFO" "Removed $hooks_config_count hooks.* configuration(s)"
    fi
    
    # Remove branch base configurations
    local branch_base_count=0
    for key in $(git config --get-regexp '^branch\..*\.base$' 2>/dev/null | awk '{print $1}'); do
        git config --unset "$key" 2>/dev/null || true
        log_uninstall "INFO" "Removed branch config: $key"
        print_success "Removed $key"
        ((branch_base_count++))
    done
    
    if [[ $branch_base_count -eq 0 ]]; then
        log_uninstall "INFO" "No branch.*.base configurations found"
        print_color "$COLOR_CYAN" "No branch.*.base configurations found"
    else
        log_uninstall "INFO" "Removed $branch_base_count branch.*.base configuration(s)"
    fi
    
    # Remove branch createdfrom tracking configurations
    local branch_createdfrom_count=0
    for key in $(git config --get-regexp '^branch\..*\.createdfrom$' 2>/dev/null | awk '{print $1}'); do
        git config --unset "$key" 2>/dev/null || true
        log_uninstall "INFO" "Removed branch tracking: $key"
        print_success "Removed $key"
        ((branch_createdfrom_count++))
    done
    
    if [[ $branch_createdfrom_count -eq 0 ]]; then
        log_uninstall "INFO" "No branch.*.createdfrom configurations found"
        print_color "$COLOR_CYAN" "No branch.*.createdfrom configurations found"
    else
        log_uninstall "INFO" "Removed $branch_createdfrom_count branch.*.createdfrom configuration(s)"
    fi
}

# Step 4: Display summary
display_summary() {
    print_header "Uninstallation Complete"
    
    print_success "Git hooks have been uninstalled"
    echo ""
    
    print_color "$COLOR_CYAN" "What was removed:"
    print_color "$COLOR_WHITE" "  • All hook configurations (hooks.maxCommits, hooks.bypassWarningStyle, etc.)"
    print_color "$COLOR_WHITE" "  • Workflow settings (rebase.autosquash, fetch.prune)"
    print_color "$COLOR_WHITE" "  • Branch tracking (branch.*.base, branch.*.createdfrom)"
    print_color "$COLOR_WHITE" "  • Bypass warning session markers"
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
    # Initialize logging FIRST (before any operations)
    if ! init_uninstall_logging; then
        print_warning "Proceeding without logging capability"
    else
        log_uninstall "INFO" "============================================"
        log_uninstall "INFO" "Starting Git Hooks Uninstallation"
        log_uninstall "INFO" "============================================"
    fi
    
    # Confirmation
    confirm_uninstall
    log_uninstall "INFO" "User confirmed uninstallation"
    
    # Uninstallation steps
    archive_logs
    clean_session_markers
    remove_configurations
    
    # Summary
    display_summary
    
    # Finalize logging
    log_uninstall "INFO" "============================================"
    log_uninstall "INFO" "Uninstallation completed successfully"
    log_uninstall "INFO" "Log file: $UNINSTALL_LOG_FILE"
    log_uninstall "INFO" "============================================"
    
    echo ""
    print_success "Uninstallation log saved to: $UNINSTALL_LOG_FILE"
}

# Execute main
main "$@"
