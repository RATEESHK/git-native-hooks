#!/usr/bin/env bash
# ==============================================================================
# Command Runner Library
# ==============================================================================
# Executes custom commands defined in .githooks/commands.conf with support for:
# - Priority-based execution
# - Mandatory vs optional commands
# - Timeout handling
# - Parallel execution
# - Lint-staged integration
# - Auto-fix and re-staging
# - Comprehensive error reporting
#
# Configuration File Format (.githooks/commands.conf):
# HOOK:PRIORITY:MANDATORY:TIMEOUT:COMMAND:DESCRIPTION
#
# Example:
# pre-commit:1:true:30:npx lint-staged:Lint staged files
# pre-commit:2:false:60:npm run type-check:TypeScript validation
# pre-push:1:true:300:npm test:Run test suite
#
# Author: Enterprise Development Team
# ==============================================================================

set -euo pipefail

# Check bash version (requires 4.3+ for nameref support)
if ((BASH_VERSINFO[0] < 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 3))); then
    echo "Error: This script requires bash 4.3 or higher (current: ${BASH_VERSION})" >&2
    echo "On macOS, install newer bash: brew install bash" >&2
    exit 1
fi

# ==============================================================================
# CONSTANTS
# ==============================================================================

readonly COMMANDS_CONF="${HOOK_ROOT_DIR}/commands.conf"
readonly COMMAND_TIMEOUT_DEFAULT=60
readonly MAX_PARALLEL_JOBS=4

# ==============================================================================
# COMMAND PARSING
# ==============================================================================

# Parse commands configuration file for specific hook
parse_commands() {
    local hook_name="$1"
    
    if [[ ! -f "$COMMANDS_CONF" ]]; then
        log_to_file "DEBUG" "$hook_name" "No commands.conf file found"
        return 0
    fi
    
    # Parse and filter commands for this hook
    local commands=()
    while IFS=: read -r cmd_hook cmd_priority cmd_mandatory cmd_timeout cmd_command cmd_description; do
        # Skip comments and empty lines
        [[ "$cmd_hook" =~ ^#.*$ ]] || [[ -z "$cmd_hook" ]] && continue
        
        # Filter by hook name
        if [[ "$cmd_hook" == "$hook_name" ]]; then
            commands+=("${cmd_priority}:${cmd_mandatory}:${cmd_timeout}:${cmd_command}:${cmd_description}")
        fi
    done < "$COMMANDS_CONF"
    
    # Sort by priority
    printf '%s\n' "${commands[@]}" | sort -t: -k1 -n
}

# ==============================================================================
# COMMAND EXECUTION
# ==============================================================================

# Execute a single command with timeout
execute_command_with_timeout() {
    local command="$1"
    local timeout="$2"
    local output_file="$3"
    
    # Create a subshell for the command
    (
        eval "$command" > "$output_file" 2>&1
    ) &
    
    local cmd_pid=$!
    local elapsed=0
    local interval=1
    
    # Wait for command with timeout
    while kill -0 "$cmd_pid" 2>/dev/null; do
        if [[ $elapsed -ge $timeout ]]; then
            # Timeout reached - kill process
            kill -TERM "$cmd_pid" 2>/dev/null || true
            sleep 1
            kill -KILL "$cmd_pid" 2>/dev/null || true
            return 124  # Timeout exit code
        fi
        
        sleep $interval
        elapsed=$((elapsed + interval))
    done
    
    # Get exit code
    wait "$cmd_pid" 2>/dev/null
    return $?
}

# Execute a single command and capture result
execute_single_command() {
    local priority="$1"
    local mandatory="$2"
    local timeout="$3"
    local command="$4"
    local description="$5"
    local hook_name="$6"
    
    local output_file
    output_file=$(mktemp)
    
    # Ensure cleanup on exit
    trap "rm -f '$output_file' '${output_file}.error' 2>/dev/null" RETURN
    
    local start_time
    start_time=$(date +%s)
    
    log_to_file "INFO" "$hook_name" "Executing: $description"
    print_color "$COLOR_BLUE" "  ⋯ $description" true
    
    # Expand command variables safely
    local expanded_command="$command"
    
    # Replace {staged} with list of staged files (safely quoted)
    if [[ "$command" =~ \{staged\} ]]; then
        local -a staged_array=()
        while IFS= read -r file; do
            [[ -n "$file" ]] && staged_array+=("$file")
        done < <(git diff --cached --name-only --diff-filter=ACMR)
        
        # Safely quote each filename to prevent command injection
        local safe_files=""
        if [[ ${#staged_array[@]} -gt 0 ]]; then
            safe_files=$(printf '%q ' "${staged_array[@]}")
        fi
        expanded_command="${command//\{staged\}/$safe_files}"
    fi
    
    # Execute with timeout (using bash -c for safer execution)
    local exit_code=0
    if ! execute_command_with_timeout "$expanded_command" "$timeout" "$output_file"; then
        exit_code=$?
    fi
    
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Clear the "running" line and print result
    printf "\r"
    
    if [[ $exit_code -eq 0 ]]; then
        print_color "$COLOR_GREEN" "  ✓ $description (${duration}s)"
        log_to_file "INFO" "$hook_name" "Success: $description (${duration}s)"
        rm -f "$output_file"
        return 0
    elif [[ $exit_code -eq 124 ]]; then
        print_color "$COLOR_RED" "  ✗ $description (TIMEOUT after ${timeout}s)"
        log_to_file "ERROR" "$hook_name" "Timeout: $description after ${timeout}s"
        
        if [[ -f "$output_file" ]]; then
            log_to_file "ERROR" "$hook_name" "Output: $(cat "$output_file")"
        fi
        rm -f "$output_file"
        
        if [[ "$mandatory" == "true" ]]; then
            return 1
        fi
        return 0
    else
        print_color "$COLOR_RED" "  ✗ $description (exit code: $exit_code)"
        log_to_file "ERROR" "$hook_name" "Failed: $description (exit code: $exit_code)"
        
        # Capture and log output
        if [[ -f "$output_file" ]] && [[ -s "$output_file" ]]; then
            local output
            output=$(cat "$output_file")
            log_to_file "ERROR" "$hook_name" "Output: $output"
            
            # Store for error report
            echo "$output" > "${output_file}.error"
        fi
        
        rm -f "$output_file"
        
        if [[ "$mandatory" == "true" ]]; then
            return 1
        fi
        return 0
    fi
}

# ==============================================================================
# AUTO-FIX AND RE-STAGING
# ==============================================================================

# Check if files were modified by commands
check_modified_files() {
    local hook_name="$1"
    
    # Get list of modified files
    local modified_files
    modified_files=$(git diff --name-only)
    
    if [[ -z "$modified_files" ]]; then
        return 0
    fi
    
    log_to_file "INFO" "$hook_name" "Files modified by commands"
    
    # Check if auto-add is enabled
    if is_auto_add_enabled; then
        print_info "Auto-fixing detected, re-staging modified files..."
        
        while IFS= read -r file; do
            if git add "$file" 2>/dev/null; then
                print_color "$COLOR_GRAY" "    Re-staged: $file"
                log_to_file "INFO" "$hook_name" "Re-staged: $file"
            fi
        done <<< "$modified_files"
        
        return 0
    else
        print_warning "Files were modified by commands but auto-staging is disabled"
        print_color "$COLOR_GRAY" "  Modified files:"
        while IFS= read -r file; do
            print_color "$COLOR_GRAY" "    - $file"
        done <<< "$modified_files"
        print_color "$COLOR_CYAN" "  To auto-stage modified files:"
        print_color "$COLOR_WHITE" "    git config hooks.autoAddAfterFix true"
        return 0
    fi
}

# ==============================================================================
# PARALLEL EXECUTION
# ==============================================================================

# Execute commands in parallel for same priority
execute_parallel_commands() {
    local -n cmd_array_ref=$1
    local hook_name="$2"
    
    local pids=()
    local results=()
    local failed=0
    
    for cmd_spec in "${cmd_array_ref[@]}"; do
        IFS=: read -r priority mandatory timeout command description <<< "$cmd_spec"
        
        # Execute in background
        (
            execute_single_command "$priority" "$mandatory" "$timeout" "$command" "$description" "$hook_name"
            exit $?
        ) &
        
        pids+=($!)
        results+=("${description}:${mandatory}")
        
        # Limit parallel jobs
        if [[ ${#pids[@]} -ge $MAX_PARALLEL_JOBS ]]; then
            # Wait for one to finish
            wait -n "${pids[@]}" || true
        fi
    done
    
    # Wait for all to complete and collect results
    local idx=0
    for pid in "${pids[@]}"; do
        if ! wait "$pid"; then
            local result="${results[$idx]}"
            IFS=: read -r desc mand <<< "$result"
            if [[ "$mand" == "true" ]]; then
                failed=1
            fi
        fi
        ((idx++))
    done
    
    return $failed
}

# ==============================================================================
# SEQUENTIAL EXECUTION
# ==============================================================================

# Execute commands sequentially
execute_sequential_commands() {
    local -n cmd_array_ref=$1
    local hook_name="$2"
    
    local failed=0
    local failed_commands=()
    local passed_commands=()
    
    # Temp files for reporting
    local failed_file="/tmp/.git-hook-failed-$$"
    local passed_file="/tmp/.git-hook-passed-$$"
    
    # Ensure cleanup on exit
    trap "rm -f '$failed_file' '$passed_file' 2>/dev/null" RETURN
    
    for cmd_spec in "${cmd_array_ref[@]}"; do
        IFS=: read -r priority mandatory timeout command description <<< "$cmd_spec"
        
        if execute_single_command "$priority" "$mandatory" "$timeout" "$command" "$description" "$hook_name"; then
            passed_commands+=("$description")
        else
            failed_commands+=("$description")
            if [[ "$mandatory" == "true" ]]; then
                failed=1
            fi
        fi
        
        # Stop on first mandatory failure
        if [[ $failed -eq 1 ]]; then
            break
        fi
    done
    
    # Store results for reporting
    if [[ $failed -eq 1 ]]; then
        echo "${failed_commands[@]}" > "/tmp/.git-hook-failed-$$"
        echo "${passed_commands[@]}" > "/tmp/.git-hook-passed-$$"
    fi
    
    return $failed
}

# ==============================================================================
# MAIN COMMAND RUNNER
# ==============================================================================

# Run all commands for a hook
run_hook_commands() {
    local hook_name="$1"
    
    log_to_file "INFO" "$hook_name" "Running custom commands"
    
    # Parse commands for this hook
    local commands
    commands=$(parse_commands "$hook_name")
    
    if [[ -z "$commands" ]]; then
        log_to_file "DEBUG" "$hook_name" "No custom commands configured"
        return 0
    fi
    
    print_separator
    print_color "$COLOR_CYAN" "Running Custom Commands"
    echo ""
    
    # Convert to array
    local commands_array=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && commands_array+=("$line")
    done <<< "$commands"
    
    # Execute commands
    local exit_code=0
    if is_parallel_enabled; then
        log_to_file "INFO" "$hook_name" "Executing commands in parallel"
        if ! execute_parallel_commands commands_array "$hook_name"; then
            exit_code=1
        fi
    else
        log_to_file "INFO" "$hook_name" "Executing commands sequentially"
        if ! execute_sequential_commands commands_array "$hook_name"; then
            exit_code=1
        fi
    fi
    
    # Check for modified files and re-stage if needed
    if [[ "$hook_name" == "pre-commit" ]] && [[ $exit_code -eq 0 ]]; then
        check_modified_files "$hook_name"
    fi
    
    echo ""
    
    # Report failures
    if [[ $exit_code -eq 1 ]]; then
        print_header "Command Execution Failed"
        
        # Read failed and passed commands
        local failed_file="/tmp/.git-hook-failed-$$"
        local passed_file="/tmp/.git-hook-passed-$$"
        
        if [[ -f "$failed_file" ]]; then
            local failed_cmds
            failed_cmds=$(cat "$failed_file")
            if [[ -n "$failed_cmds" ]]; then
                print_color "$COLOR_RED" "Failed Checks:"
                for cmd in $failed_cmds; do
                    print_color "$COLOR_RED" "  ✗ $cmd"
                done
                echo ""
            fi
            rm -f "$failed_file"
        fi
        
        if [[ -f "$passed_file" ]]; then
            local passed_cmds
            passed_cmds=$(cat "$passed_file")
            if [[ -n "$passed_cmds" ]]; then
                print_color "$COLOR_GREEN" "Passed Checks:"
                for cmd in $passed_cmds; do
                    print_color "$COLOR_GREEN" "  ✓ $cmd"
                done
                echo ""
            fi
            rm -f "$passed_file"
        fi
        
        print_separator
        print_color "$COLOR_GRAY" "To bypass (emergency only): ${COLOR_WHITE}BYPASS_HOOKS=1 git ${hook_name#pre-}"
        print_color "$COLOR_GRAY" "Check logs for details: ${COLOR_WHITE}${LOG_FILE}"
        print_separator
        echo ""
        
        return 1
    fi
    
    return 0
}

# ==============================================================================
# LINT-STAGED INTEGRATION
# ==============================================================================

# Check if lint-staged is configured
is_lint_staged_configured() {
    [[ -f "${GIT_ROOT}/.lintstagedrc.json" ]] || \
    [[ -f "${GIT_ROOT}/.lintstagedrc.js" ]] || \
    [[ -f "${GIT_ROOT}/.lintstagedrc.yml" ]] || \
    [[ -f "${GIT_ROOT}/.lintstagedrc.yaml" ]] || \
    grep -q "lint-staged" "${GIT_ROOT}/package.json" 2>/dev/null
}

# Run lint-staged if configured
run_lint_staged() {
    local hook_name="$1"
    
    if ! is_lint_staged_configured; then
        return 0
    fi
    
    log_to_file "INFO" "$hook_name" "Running lint-staged"
    
    if command -v npx >/dev/null 2>&1; then
        if npx lint-staged 2>&1 | tee -a "$LOG_FILE"; then
            log_to_file "INFO" "$hook_name" "lint-staged succeeded"
            return 0
        else
            log_to_file "ERROR" "$hook_name" "lint-staged failed"
            return 1
        fi
    else
        log_to_file "WARNING" "$hook_name" "npx not found, skipping lint-staged"
        return 0
    fi
}
