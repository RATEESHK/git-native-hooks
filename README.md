# Git Native Hooks - Enterprise Git Flow Enforcement Suite

A comprehensive, production-ready Git hooks system that enforces Git Flow branching model, commit message conventions, code quality standards, and maintains clean repository history. Built with Bash for maximum compatibility and zero runtime dependencies.

[![License](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/Bash-4.3%2B-green.svg)](https://www.gnu.org/software/bash/)
[![Git Flow](https://img.shields.io/badge/Git%20Flow-Compliant-success.svg)](https://nvie.com/posts/a-successful-git-branching-model/)

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Git Flow Rules Enforced](#git-flow-rules-enforced)
- [Hook Reference](#hook-reference)
  - [pre-commit](#pre-commit)
  - [prepare-commit-msg](#prepare-commit-msg)
  - [commit-msg](#commit-msg)
  - [post-commit](#post-commit)
  - [pre-push](#pre-push)
  - [post-checkout](#post-checkout)
  - [post-rewrite](#post-rewrite)
  - [applypatch-msg](#applypatch-msg)
- [Configuration](#configuration)
- [Custom Commands](#custom-commands)
- [Bypass Mechanisms](#bypass-mechanisms)
- [Branch Naming Convention](#branch-naming-convention)
- [Commit Message Format](#commit-message-format)
- [Lockfile Validation](#lockfile-validation)
- [Error Messages and Fixes](#error-messages-and-fixes)
- [Logging and Debugging](#logging-and-debugging)
- [Uninstallation](#uninstallation)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

**Git Native Hooks** provides a robust, enterprise-grade Git workflow enforcement system that ensures:

- ✅ **Git Flow Compliance**: Automatic validation of Git Flow branching model
- ✅ **Clean History**: Enforces linear history, curated commits, no foxtrot merges
- ✅ **Standardized Commits**: JIRA-integrated commit messages with auto-population
- ✅ **Protected Branches**: Prevents direct commits to `main` and `develop`
- ✅ **Code Quality**: Extensible framework for linting, testing, and validation
- ✅ **Lockfile Integrity**: Validates package manager lockfiles across all ecosystems
- ✅ **Context-Aware Errors**: Detailed error messages with actionable fix suggestions
- ✅ **Zero Dependencies**: Pure Bash implementation, works everywhere Git works

---

## Features

### Git Flow Enforcement
- Validates branch creation from correct base (e.g., features from `develop`, hotfixes from `main`)
- Enforces branch naming conventions with JIRA ticket integration
- Prevents merge commits in feature branches (linear history only)
- Detects and blocks foxtrot merge patterns
- Configurable commit count limits to encourage squashing

### Commit Quality
- Auto-populates commit messages with JIRA IDs from branch names
- Validates commit message format: `<type>: <JIRA-ID> <description>`
- Supports merge and revert commits
- Provides intelligent suggestions based on branch context

### Protected Branch Management
- Blocks direct commits to `main` and `develop`
- Blocks direct pushes to protected branches
- Emergency bypass mechanism with audit logging
- Clear guidance for proper workflows

### Custom Command Execution
- Priority-based command execution framework
- Supports mandatory and optional validations
- Timeout handling per command
- Parallel execution support
- Variable expansion (e.g., `{staged}` for staged files)
- Lint-staged integration

### Lockfile Validation (Multi-Language Support)
- **Node.js**: package-lock.json, yarn.lock, pnpm-lock.yaml
- **Python**: poetry.lock, Pipfile.lock, requirements.txt
- **Go**: go.sum
- **Rust**: Cargo.lock
- **Ruby**: Gemfile.lock
- **PHP**: composer.lock
- **Swift/iOS**: Package.resolved, Podfile.lock
- **Terraform**: .terraform.lock.hcl
- Detects merge conflict markers in lockfiles
- Validates lockfile integrity and sync with manifest files
- Comprehensive fix suggestions for common issues

### Developer Experience
- Color-coded terminal output
- Progress indicators during command execution
- Detailed logging with timestamp and context
- Contextual error messages with fix commands
- Undo instructions for common mistakes
- Git Flow education in error messages

---

## Prerequisites

- **Git**: Version 2.9+ (for `core.hooksPath` support)
- **Bash**: Version 4.3+ (3.2+ supported with limited features)
- **Operating System**: Linux, macOS, Windows (Git Bash), WSL

### Platform-Specific Notes

**macOS**: Default Bash is 3.2. For full functionality:
```bash
brew install bash
```

**Windows**: Use Git Bash (included with Git for Windows)

---

## Installation

### 1. Clone or Copy Hooks

```bash
# Option 1: Clone into your repository
git clone https://github.com/RATEESHK/git-native-hooks.git .githooks

# Option 2: Copy .githooks directory to your repository
cp -r /path/to/git-native-hooks/.githooks /path/to/your/repo/
```

### 2. Run Installation Script

```bash
cd /path/to/your/repo
./.githooks/install-hooks.sh
```

The installer will:
- ✅ Configure `core.hooksPath` to `.githooks`
- ✅ Set up Git workflow optimizations
- ✅ Make hook scripts executable
- ✅ Create logging infrastructure
- ✅ Generate sample `commands.conf`
- ✅ Display configuration summary and test commands

### 3. Verify Installation

```bash
# Test commit message validation
echo "Invalid message" | git commit --allow-empty -F -

# View active hooks
git config core.hooksPath

# Check logs
cat .git/hooks-logs/hook-$(date +%Y-%m-%d).log
```

---

## Quick Start

### Create a Proper Feature Branch

```bash
# Checkout develop (base for features)
git checkout develop

# Create feature branch with JIRA ID
git checkout -b feat-PROJ-123-add-user-auth develop

# Set base branch (automatic with post-checkout hook)
git config branch.feat-PROJ-123-add-user-auth.base develop
```

### Make Changes and Commit

```bash
# Stage your changes
git add src/auth.js

# Commit (message auto-populated with JIRA ID)
git commit -m "feat: PROJ-123 implement user authentication system"

# Or let prepare-commit-msg populate the template
git commit
# Opens editor with: "feat: PROJ-123 "
```

### Push Your Branch

```bash
# Push feature branch (pre-push hook validates)
git push origin feat-PROJ-123-add-user-auth
```

### Create Hotfix Branch (Production Fix)

```bash
# Checkout main (base for hotfixes)
git checkout main

# Create hotfix branch
git checkout -b hotfix-PROJ-456-security-patch main

# Make fix and commit
git commit -m "fix: PROJ-456 patch XSS vulnerability"

# Push
git push origin hotfix-PROJ-456-security-patch
```

---

## Git Flow Rules Enforced

### Long-Lived Branches

| Branch | Base | Merges Into | Purpose |
|--------|------|-------------|---------|
| `main` | - | - | Production-ready code |
| `develop` | - | - | Integration branch for next release |

### Short-Lived Branches

| Type | Pattern | Base | Merges Into | Purpose |
|------|---------|------|-------------|---------|
| **Feature** | `feat-JIRA-123-description` | `develop` | `develop` | New features |
| **Bugfix** | `fix-JIRA-123-description` | `develop` | `develop` | Bug fixes |
| **Hotfix** | `hotfix-JIRA-123-description` | `main` | `main` + `develop` | Production fixes |
| **Release** | `release-1.0.0` or `release/1.0.0` | `develop` | `main` + `develop` | Release preparation |
| **Support** | `chore-JIRA-123-description` | `develop` | `develop` | Maintenance tasks |

### Validation Points

1. **Post-Checkout**: Validates branch creation base
2. **Pre-Commit**: Validates protected branch commits
3. **Commit-Msg**: Validates commit message format
4. **Pre-Push**: Validates branch name, history, commit count, base branch

---

## Hook Reference

### pre-commit

**Triggers**: Before creating a commit

**Validates**:
- Protected branch commits (blocks direct commits to `main`/`develop`)
- Executes custom commands from `commands.conf`

**Custom Commands**: Supports linting, formatting, type-checking, security scans

**Example Output**:
```
================================================================================
  Pre-Commit Validation
================================================================================

✓ SUCCESS: Branch: feat-PROJ-123-add-auth

────────────────────────────────────────────────────────────────────────────────
Running Custom Commands

  ✓ Prettier Format Check (2s)
  ✓ ESLint (5s)
  ✓ TypeScript Check (8s)

✓ SUCCESS: All pre-commit validations passed
```

**Bypass**:
```bash
BYPASS_HOOKS=1 git commit -m "message"
# or
git commit --no-verify -m "message"
```

---

### prepare-commit-msg

**Triggers**: Before commit message editor opens

**Actions**:
- Extracts JIRA ID from branch name
- Auto-populates commit message template
- Preserves existing messages

**Example**:
```bash
# Branch: feat-PROJ-123-user-auth
git commit

# Opens editor with:
feat: PROJ-123 

# Please enter a descriptive commit message above
# Format: <type>: <JIRA-ID> <description>
#
# Types: feat, fix, chore, break, tests
# Example: feat: PROJ-123 Add user authentication
#
# Your branch: feat-PROJ-123-user-auth
```

**Skips**:
- Merge commits
- Amend commits with existing messages
- Messages already containing JIRA ID
- Detached HEAD state

---

### commit-msg

**Triggers**: Before commit is created (validates commit message)

**Validates**:
- Commit message format: `<type>: <JIRA-ID> <description>`
- Valid types: `feat`, `fix`, `chore`, `break`, `tests`, `docs`, `style`, `refactor`, `perf`
- JIRA ID pattern: `[A-Z]{2,10}-[0-9]+`
- Non-empty descriptions

**Allows**:
- Merge commits (starts with "Merge")
- Revert commits (starts with "Revert")

**Example Valid Messages**:
```
feat: PROJ-123 add user authentication
fix: TICKET-456 resolve memory leak
chore: ABC-789 update dependencies
break: PROJ-100 remove deprecated API
tests: JIRA-999 add integration tests
```

**Example Error**:
```
✗ ERROR: Invalid Commit Message
Commit message must follow: <type>: <JIRA-ID> <description>

Your message: "added new feature"

✓ JIRA ID from branch: PROJ-123

Required format: feat: PROJ-123 add your description
Types: feat, fix, chore, break, tests, docs, refactor, perf

Examples:
  feat: PROJ-123 add user authentication
  fix: PROJ-123 resolve memory leak
  chore: PROJ-123 update dependencies

Fix now:
  git commit --amend -m "feat: PROJ-123 your description"

🔄 Undo commit if needed:
  git reset --soft HEAD~1      # Undo commit, keep changes
  git reset --mixed HEAD~1     # Undo commit, unstage changes
  git reset --hard HEAD~1      # Undo commit, discard changes
  git reflog                   # View commit history to recover
```

---

### post-commit

**Triggers**: After successful commit creation

**Actions**:
- Detects lockfile changes (package-lock.json, yarn.lock, etc.)
- Detects Infrastructure as Code changes (Terraform, K8s, etc.)
- Detects CI/CD configuration changes
- Provides helpful reminders and suggestions

**Example Output**:
```
💡 HINT: Lockfile changed - Dependencies updated
  • package-lock.json

  npm ci && npm audit && npm test

🔄 If lockfile shouldn't have changed:
  git reset --soft HEAD~1   # Undo commit, keep changes
  git restore --staged package-lock.json  # Unstage lockfile
  git restore package-lock.json    # Revert lockfile
```

**Silent**: When no special files are detected

---

### pre-push

**Triggers**: Before pushing to remote

**Validates**:
1. **Branch Naming**: Git Flow compliant patterns
2. **Protected Branch Push**: Blocks direct pushes to `main`/`develop`
3. **Branch Base**: Validates Git Flow branch origin
4. **Commit Count**: Enforces curated history (default: max 5 commits)
5. **Linear History**: No merge commits allowed
6. **Foxtrot Merges**: Detects and blocks incorrect merge patterns

**Example Output**:
```
================================================================================
  Validating Push: feat-PROJ-123-add-auth → origin
================================================================================

✓ SUCCESS: Branch naming: Valid
✓ SUCCESS: Branch base: develop (correct)
✓ SUCCESS: Commit count: 3/5
✓ SUCCESS: History: Linear (no merge commits)

✓ SUCCESS: All validations passed - push allowed
```

**Example Error (Too Many Commits)**:
```
✗ ERROR: Too Many Commits
Branch has 8 commits (limit: 5). Squash commits before pushing.

Why limit commits? Easier review, cleaner history, simpler reverts.

Fix option 1 - Interactive rebase:
  git rebase -i develop
  # Mark commits as 'squash' or 'fixup', save and exit
  git push --force-with-lease origin feat-PROJ-123-add-auth

Fix option 2 - Soft reset (simpler):
  git reset --soft develop
  git commit -m "feat: PROJ-123 your complete description"
  git push --force-with-lease origin feat-PROJ-123-add-auth

Increase limit temporarily (if justified):
  git config hooks.maxCommits 8
```

**Configuration**:
```bash
# Increase commit limit
git config hooks.maxCommits 10

# View current limit
git config hooks.maxCommits
```

---

### post-checkout

**Triggers**: After checking out a branch

**Validates**:
- Git Flow base branch for new branches
- Branch naming conventions
- Protected branch warnings

**Critical Validation**: Ensures new branches are created from correct base

**Example (Correct Base)**:
```bash
# Create feature from develop (correct)
git checkout develop
git checkout -b feat-PROJ-123-new-feature

# Output:
✓ SUCCESS: Git Flow: Branch created from correct base 'develop'
```

**Example (Wrong Base - Error)**:
```bash
# Create feature from main (wrong!)
git checkout main
git checkout -b feat-PROJ-123-new-feature

# Output:
✗ ERROR: Git Flow Violation: Invalid Base Branch

❌ CRITICAL: Branch created from wrong base!

Branch:         feat-PROJ-123-new-feature
Branch type:    feature
Created from:   main (❌ WRONG)
Required base:  develop (✓ CORRECT)

═══════════════════════════════════════════════════════════════
                    GIT FLOW RULES
═══════════════════════════════════════════════════════════════

📋 Feature/Bugfix/Support branches:
   • MUST branch from: 'develop'
   • MUST merge into: 'develop'
   • Purpose: New features and bug fixes for next release

   Types: feat, feature, bugfix, fix, build, chore, ci,
          docs, techdebt, perf, refactor, revert, style, test

═══════════════════════════════════════════════════════════════

🔧 FIX OPTION 1 - Recreate from correct base (RECOMMENDED):

   Step 1: Go to correct base branch
     git checkout develop

   Step 2: Create new branch with proper name from correct base
     git checkout -b feat-PROJ-123-your-description

   Step 3: Delete the incorrectly created branch
     git branch -D feat-PROJ-123-new-feature

🔧 FIX OPTION 2 - Rebase onto correct base (ADVANCED):

   ⚠️  Use this ONLY if you have NO commits yet!

   Step 1: Ensure you're on the wrong branch
     git checkout feat-PROJ-123-new-feature

   Step 2: Rebase onto correct base
     git rebase --onto develop main feat-PROJ-123-new-feature

   Step 3: Verify the base
     git log --oneline develop..feat-PROJ-123-new-feature

⛔ This branch will be REJECTED on push!
⚠️  Fix this NOW to avoid losing work later.
```

**Protected Branch Warning**:
```bash
git checkout main

# Output:
⚠ WARNING: You are now on protected branch: main

⚠️  Direct commits are restricted on this branch

To make changes (hotfix for production):
  git checkout -b hotfix-JIRA-123-description main
```

---

### post-rewrite

**Triggers**: After rebase or amend operations

**Actions**:
- Provides force-push reminders
- Shows undo commands
- History rewriting guidance

**Example (After Rebase)**:
```
✓ SUCCESS: Rebase completed
⚠ WARNING: Force-push required

Next steps:
  1. Review: git log --oneline -10
  2. Check:  git log --oneline origin/feat-PROJ-123..feat-PROJ-123
  3. Push:   git push --force-with-lease origin feat-PROJ-123

⚠️  Use --force-with-lease (safer than --force)

🔄 Undo rebase if needed:
  git reflog                    # Find pre-rebase commit
  git reset --hard HEAD@{N}     # Go back to commit N
  git reset --hard ORIG_HEAD    # Quick undo (if available)
```

**Example (After Amend)**:
```
ℹ INFO: Commit amended - force-push if already pushed
  git push --force-with-lease origin feat-PROJ-123

🔄 Undo amend:
  git reset --soft HEAD@{1}     # Keep changes
  git reset --hard HEAD@{1}     # Discard changes
```

---

### applypatch-msg

**Triggers**: When applying patches via `git am`

**Validates**:
- Patch commit messages follow same format as regular commits
- JIRA ID presence and format

**Example Error**:
```
✗ ERROR: Invalid Patch Message
Patch message must follow: <type>: <JIRA-ID> <description>

Your message: "patch for bug"

Fix option 1 - Interactive mode:
  git am --abort
  git am --interactive <patch-file>.patch
  # Press 'e' to edit message

Fix option 2 - Apply and amend:
  git am --no-verify <patch-file>.patch
  git commit --amend -m "feat: PROJ-123 apply patch description"

🔄 Undo applied patch:
  git am --abort        # Before patch is applied
  git reset --hard HEAD~1  # After patch is applied
  git reflog            # Recover if needed
```

---

## Configuration

### Git Configuration Options

```bash
# Maximum commits allowed per branch (default: 5)
git config hooks.maxCommits 10

# Auto-stage files after commands fix them (default: false)
git config hooks.autoAddAfterFix true

# Enable parallel command execution (default: false)
git config hooks.parallelExecution true

# Set base branch for current branch
git config branch.$(git branch --show-current).base develop
```

### View Current Configuration

```bash
# View all hooks-related configs
git config --get-regexp '^hooks\.'

# View specific config
git config hooks.maxCommits

# View branch base
git config branch.feat-PROJ-123.base
```

### Global vs Local Configuration

```bash
# Repository-specific (recommended)
git config hooks.maxCommits 5

# Global (all repositories)
git config --global hooks.maxCommits 10

# Remove configuration
git config --unset hooks.maxCommits
```

---

## Custom Commands

### Configuration File

Custom commands are defined in `.githooks/commands.conf`

**Format**:
```
HOOK:PRIORITY:MANDATORY:TIMEOUT:COMMAND:DESCRIPTION
```

**Fields**:
- `HOOK`: Hook name (pre-commit, pre-push, commit-msg, etc.)
- `PRIORITY`: Execution order (lower number = runs first)
- `MANDATORY`: `true`/`false` - whether failure blocks the entire hook
- `TIMEOUT`: Maximum execution time in seconds
- `COMMAND`: Shell command to execute
- `DESCRIPTION`: Human-readable description shown during execution

**Variables**:
- `{staged}`: Expands to space-separated list of staged files (pre-commit only)

### Examples

#### JavaScript/TypeScript Project

```properties
# Stage 1: Fast formatting and basic checks (< 1 minute)
pre-commit:1:true:30:npx prettier --check {staged}:Prettier Format Check
pre-commit:2:true:60:npx eslint {staged}:ESLint

# Stage 2: Type checking (optional, can be slow)
pre-commit:3:false:120:npx tsc --noEmit --skipLibCheck:TypeScript Check

# Stage 3: Unit tests before push (< 5 minutes)
pre-push:1:true:300:npm test:Run Unit Tests

# Stage 4: Build verification (optional, slower)
pre-push:2:false:600:npm run build:Build Verification
```

#### Python Project

```properties
# Stage 1: Fast formatting and linting (< 1 minute)
pre-commit:1:true:30:black --check {staged}:Black Format Check
pre-commit:2:true:60:flake8 {staged}:Flake8 Linting
pre-commit:3:true:30:isort --check {staged}:Import Sort Check

# Stage 2: Type and security checks (optional)
pre-commit:4:false:60:mypy {staged}:MyPy Type Check
pre-commit:5:false:30:bandit -r {staged}:Security Scan

# Stage 3: Unit tests before push
pre-push:1:true:300:pytest tests/unit -v:Unit Tests

# Stage 4: Coverage and integration tests (optional)
pre-push:2:false:600:pytest tests/integration -v:Integration Tests
```

#### Go Project

```properties
# Format checking
pre-commit:1:true:30:test -z $(gofmt -l {staged}):Go Format Check

# Vetting
pre-commit:2:true:60:go vet ./...:Go Vet

# Linting with golangci-lint
pre-commit:3:true:90:golangci-lint run {staged}:GolangCI-Lint

# Unit tests
pre-push:1:true:300:go test ./...:Run Tests

# Build verification
pre-push:2:false:180:go build ./...:Build Project
```

#### Docker/Infrastructure

```properties
# Dockerfile linting
pre-commit:1:true:30:docker run --rm -i hadolint/hadolint < Dockerfile:Hadolint

# Terraform validation
pre-commit:1:true:30:terraform fmt -check -recursive:Terraform Format
pre-commit:2:true:60:terraform validate:Terraform Validate

# YAML linting
pre-commit:3:true:30:yamllint {staged}:YAML Lint
```

### Priority Guidelines

- **1-10**: Critical, fast checks (format, lint, lockfile sync)
- **11-20**: Important checks (type check, compilation)
- **21-30**: Optional quality checks
- **31+**: Slow, optional validations

### Timeout Guidelines

- **5-10s**: Fast checks (conflict detection, file presence)
- **10-30s**: Format checkers, linters, basic lockfile validation
- **30-90s**: Type checkers, compilation, deep lockfile validation
- **90-300s**: Unit tests
- **300-600s**: Integration tests, builds

### Testing Commands

```bash
# Test commands manually
npx prettier --check src/

# Dry-run with hooks
BYPASS_HOOKS=1 git commit -m "test"

# View logs
cat .git/hooks-logs/hook-$(date +%Y-%m-%d).log
```

---

## Bypass Mechanisms

### Global Bypass (All Hooks)

```bash
# Skip all hook validations
BYPASS_HOOKS=1 git commit -m "emergency fix"
BYPASS_HOOKS=1 git push

# Git's native bypass (only client-side)
git commit --no-verify -m "emergency fix"
git push --no-verify
```

### Protected Branch Bypass

```bash
# Allow commits to main/develop
ALLOW_DIRECT_PROTECTED=1 git commit -m "hotfix: emergency"

# Allow push to main/develop
ALLOW_DIRECT_PROTECTED=1 git push origin main
```

### When to Use Bypass

✅ **Appropriate Uses**:
- Emergency production hotfixes
- Fixing broken CI/CD pipelines
- Recovering from Git disasters
- Testing hook changes

❌ **Inappropriate Uses**:
- Avoiding code quality standards
- Rushing incomplete features
- Circumventing team processes
- Regular development workflow

### Audit Trail

All bypass operations are logged:
```bash
cat .git/hooks-logs/hook-$(date +%Y-%m-%d).log | grep BYPASS

# Example output:
[2024-11-08 14:23:45] [WARNING] [pre-commit] BYPASS USED: Hook bypassed via BYPASS_HOOKS by user: developer
```

---

## Branch Naming Convention

### Pattern Requirements

**Format**: `<type>-<JIRA-ID>-<description>`

**Components**:
- **Type**: One of the valid types (see below)
- **JIRA ID**: Pattern `[A-Z]{2,10}-[0-9]+` (2-10 uppercase letters, dash, numbers)
- **Description**: Lowercase, hyphen-separated words

### Valid Branch Types

| Type | Purpose | Base Branch |
|------|---------|-------------|
| `feat`, `feature` | New features | `develop` |
| `fix`, `bugfix` | Bug fixes | `develop` |
| `hotfix` | Production fixes | `main` |
| `release` | Release preparation | `develop` |
| `chore` | Maintenance | `develop` |
| `docs` | Documentation | `develop` |
| `style` | Code style | `develop` |
| `refactor` | Code restructuring | `develop` |
| `perf` | Performance | `develop` |
| `test` | Testing | `develop` |
| `build` | Build system | `develop` |
| `ci` | CI/CD | `develop` |
| `techdebt` | Technical debt | `develop` |
| `revert` | Revert changes | `develop` |

### Valid Examples

```bash
feat-PROJ-123-add-user-authentication
fix-TICKET-456-resolve-memory-leak
hotfix-ABC-789-patch-security-vulnerability
chore-JIRA-100-update-dependencies
docs-PROJECT-200-api-documentation
refactor-TASK-300-simplify-auth-logic
```

### Invalid Examples

❌ `feature-branch` - Missing JIRA ID
❌ `PROJ-123` - Missing type and description
❌ `feat-proj-123-description` - Lowercase JIRA ID
❌ `feat-PROJ-123` - Missing description
❌ `feat_PROJ_123_description` - Wrong separators (use hyphens)

### Creating Branches Correctly

```bash
# Feature branch (from develop)
git checkout develop
git checkout -b feat-PROJ-123-add-feature develop

# Hotfix branch (from main)
git checkout main
git checkout -b hotfix-PROJ-456-fix-bug main

# Avoid common mistakes
git checkout main
git checkout -b feat-PROJ-123-feature  # ❌ Wrong base!

git checkout develop
git checkout -b feature-branch  # ❌ Invalid name!
```

---

## Commit Message Format

### Required Pattern

```
<type>: <JIRA-ID> <description>
```

### Valid Types

- `feat`: New feature
- `fix`: Bug fix
- `chore`: Maintenance
- `break`: Breaking change
- `tests`: Test changes
- `docs`: Documentation
- `style`: Code style (formatting, whitespace)
- `refactor`: Code restructuring
- `perf`: Performance improvement
- `hotfix`: Production hotfix

### JIRA ID Format

- Pattern: `[A-Z]{2,10}-[0-9]+`
- Examples: `PROJ-123`, `TICKET-456`, `ABC-789`

### Description Rules

- Must not be empty
- Should be concise but descriptive
- No period at the end (convention)
- Present tense (e.g., "add" not "added")

### Valid Examples

```
feat: PROJ-123 add user authentication system
fix: TICKET-456 resolve memory leak in data processor
chore: JIRA-789 update dependencies to latest versions
break: PROJ-100 remove deprecated API endpoints
tests: ABC-200 add integration tests for payment module
docs: TASK-300 update API documentation
refactor: PROJ-400 simplify authentication logic
perf: TICKET-500 optimize database queries
```

### Invalid Examples

❌ `added new feature` - Missing type and JIRA ID
❌ `feat: add feature` - Missing JIRA ID
❌ `feat: proj-123 add feature` - Lowercase JIRA ID
❌ `feat: PROJ-123` - Missing description
❌ `PROJ-123 add feature` - Missing type

### Auto-Population

The `prepare-commit-msg` hook automatically extracts JIRA ID from branch names:

```bash
# Branch: feat-PROJ-123-user-auth
git commit

# Editor opens with pre-filled template:
feat: PROJ-123 

# Just add your description:
feat: PROJ-123 implement OAuth2 authentication
```

### Special Commit Types (Always Allowed)

**Merge Commits**:
```
Merge branch 'develop' into 'main'
Merge pull request #123 from user/feat-PROJ-456-feature
```

**Revert Commits**:
```
Revert "feat: PROJ-123 add user authentication"
```

---

## Lockfile Validation

### Supported Package Managers

The hooks provide comprehensive lockfile validation for:

#### Node.js / JavaScript / TypeScript
- `package-lock.json` (npm)
- `yarn.lock` (Yarn)
- `pnpm-lock.yaml` (pnpm)

#### Python
- `poetry.lock` (Poetry)
- `Pipfile.lock` (Pipenv)
- `requirements.txt`

#### Go
- `go.sum`

#### Rust
- `Cargo.lock`

#### Ruby
- `Gemfile.lock` (Bundler)

#### PHP
- `composer.lock` (Composer)

#### Swift / iOS
- `Package.resolved` (Swift Package Manager)
- `Podfile.lock` (CocoaPods)

#### Terraform / Infrastructure
- `.terraform.lock.hcl`

### Validation Types

#### 1. Manifest-Lockfile Sync Check

Ensures lockfile is updated when manifest changes.

**Example** (package.json):
```bash
# Edit package.json but forget to run npm install
git add package.json
git commit -m "feat: PROJ-123 add dependency"

# Error:
⚠️  package.json modified but package-lock.json not updated!

Fix: Run 'npm install' to regenerate package-lock.json
Then: git add package-lock.json
```

#### 2. Lockfile Integrity Validation

Validates lockfile format and content.

**Example**:
```bash
# Corrupted package-lock.json
git add package-lock.json
git commit -m "feat: PROJ-123 update deps"

# Error:
❌ package-lock.json validation failed!

Common causes:
  • package-lock.json is corrupted
  • Versions in package.json don't match lockfile
  • Manual edit to lockfile (don't do this!)

Fix: Delete and regenerate:
  rm package-lock.json
  npm install
  git add package-lock.json
```

#### 3. Merge Conflict Detection

Prevents committing lockfiles with unresolved conflicts.

**Example**:
```bash
# After merge conflict in package-lock.json
git add package-lock.json
git commit -m "feat: PROJ-123 merge develop"

# Error:
❌ MERGE CONFLICT markers detected in lockfile!

DO NOT manually resolve lockfile conflicts!

Fix for npm:
  git checkout --theirs package-lock.json  # or --ours
  npm install
  git add package-lock.json
```

#### 4. Orphan Lockfile Change Warning

Alerts when lockfile changes without manifest changes.

**Example**:
```bash
# package-lock.json changed but not package.json
git add package-lock.json
git commit -m "feat: PROJ-123 update lock"

# Warning (not blocking):
ℹ️  Lockfile changed without package.json change

This is unusual but can be valid:
  • Security update (npm audit fix)
  • Lockfile format upgrade
  • Version resolution change

Verify this is intentional. If not, run:
  git restore --staged package-*.json yarn.lock pnpm-lock.yaml
```

### Enabling Lockfile Validation

Lockfile validation commands are extensively documented in `commands.conf` but commented out by default.

**To enable**:

1. Open `.githooks/commands.conf`
2. Find your technology section (e.g., "Node.js / JavaScript / TypeScript Projects")
3. Uncomment the relevant validation commands

**Recommendation**: Start with `mandatory=false` for 1-2 weeks, then switch to `mandatory=true`.

**Example for Node.js**:
```properties
# Check package.json/lockfile sync
pre-commit:1:false:10:if git diff --cached --name-only | grep -q "^package\.json$"; then if [ -f package-lock.json ] && ! git diff --cached --name-only | grep -q "^package-lock\.json$"; then echo ""; echo "⚠️  package.json modified but package-lock.json not updated!"; echo ""; echo "Fix: Run 'npm install' to regenerate package-lock.json"; echo "Then: git add package-lock.json"; echo ""; exit 1; fi; fi:Check package.json sync

# Validate npm lockfile integrity
pre-commit:2:false:30:if [ -f package-lock.json ] && git diff --cached --name-only | grep -q "^package-lock\.json$"; then if ! npm ls --package-lock-only >/dev/null 2>&1; then echo ""; echo "❌ package-lock.json validation failed!"; echo ""; exit 1; fi; fi:Validate package-lock.json

# Detect merge conflicts
pre-commit:1:true:5:if git diff --cached --name-only | grep -qE "package-lock\.json|yarn\.lock|pnpm-lock\.yaml"; then if git diff --cached | grep -qE "^(<{7}|={7}|>{7})"; then echo ""; echo "❌ MERGE CONFLICT markers detected in lockfile!"; echo ""; exit 1; fi; fi:Check Node.js lockfile conflicts
```

### Post-Commit Hints

The `post-commit` hook provides helpful reminders when lockfiles change:

```bash
git commit -m "feat: PROJ-123 update dependencies"

# Output:
💡 HINT: Lockfile changed - Dependencies updated
  • package-lock.json

  npm ci && npm audit && npm test

🔄 If lockfile shouldn't have changed:
  git reset --soft HEAD~1   # Undo commit, keep changes
  git restore --staged package-lock.json  # Unstage lockfile
  git restore package-lock.json    # Revert lockfile
```

### Best Practices

1. **Never Manually Edit Lockfiles**: Always regenerate using package manager
2. **Resolve Conflicts Properly**: Use `git checkout` + regenerate, not manual editing
3. **Commit Together**: Always commit manifest and lockfile together
4. **Test After Update**: Run tests after dependency updates
5. **Audit Security**: Run `npm audit` or equivalent after updates

---

## Error Messages and Fixes

### Common Scenarios

#### 1. Wrong Branch Base

**Error**:
```
❌ CRITICAL: Branch created from wrong base!

Branch:         feat-PROJ-123-add-auth
Branch type:    feature
Created from:   main (❌ WRONG)
Required base:  develop (✓ CORRECT)
```

**Fix**:
```bash
# Recreate from correct base
git checkout develop
git checkout -b feat-PROJ-123-add-auth
git branch -D feat-PROJ-123-add-auth-old  # Delete wrong branch
```

#### 2. Invalid Commit Message

**Error**:
```
✗ ERROR: Invalid Commit Message

Your message: "added new feature"

Required format: feat: PROJ-123 add your description
```

**Fix**:
```bash
# Amend commit message
git commit --amend -m "feat: PROJ-123 add new feature"

# Or reset and recommit
git reset --soft HEAD~1
git commit -m "feat: PROJ-123 add new feature"
```

#### 3. Too Many Commits

**Error**:
```
✗ ERROR: Too Many Commits
Branch has 8 commits (limit: 5). Squash commits before pushing.
```

**Fix**:
```bash
# Interactive rebase
git rebase -i develop
# Mark commits as 'squash', save and exit

# Or soft reset (simpler)
git reset --soft develop
git commit -m "feat: PROJ-123 complete feature description"

# Force-push with safety
git push --force-with-lease origin feat-PROJ-123
```

#### 4. Non-Linear History (Merge Commits)

**Error**:
```
✗ ERROR: Non-Linear History
Branch contains 2 merge commit(s). Use rebase instead of merge.
```

**Fix**:
```bash
# Rebase onto develop
git fetch origin
git rebase origin/develop

# Resolve conflicts if any
git add <resolved-files>
git rebase --continue

# Force-push
git push --force-with-lease origin feat-PROJ-123
```

#### 5. Protected Branch Commit

**Error**:
```
✗ ERROR: Protected Branch
Cannot commit directly to protected branch 'main'. Use Pull Requests.
```

**Fix**:
```bash
# Move changes to proper branch
git stash push -m 'Changes from main'
git checkout -b hotfix-PROJ-123-fix main
git stash pop
git add .
git commit -m "fix: PROJ-123 emergency fix"
```

#### 6. Invalid Branch Name

**Error**:
```
✗ ERROR: Invalid Branch Name
Branch 'feature-branch' doesn't follow Git Flow naming: <type>-<JIRA>-<description>
```

**Fix**:
```bash
# Rename branch
git branch -m feature-branch feat-PROJ-123-add-feature

# Or create new correctly-named branch
git checkout develop
git checkout -b feat-PROJ-123-add-feature
git cherry-pick <commits>
git branch -D feature-branch
```

### Universal Undo Commands

```bash
# Undo last commit (keep changes staged)
git reset --soft HEAD~1

# Undo last commit (unstage changes)
git reset --mixed HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# View reflog to recover
git reflog
git reset --hard HEAD@{N}  # Go back to specific state

# Undo last N commits
git reset --soft HEAD~3

# Abort rebase
git rebase --abort

# Abort merge
git merge --abort

# Abort cherry-pick
git cherry-pick --abort

# Recover deleted branch
git reflog
git checkout -b recovered-branch HEAD@{N}
```

---

## Logging and Debugging

### Log Location

```bash
# Daily log file
.git/hooks-logs/hook-YYYY-MM-DD.log

# Today's log
.git/hooks-logs/hook-$(date +%Y-%m-%d).log
```

### Log Format

```
[YYYY-MM-DD HH:MM:SS] [LEVEL] [HOOK_NAME] Message
```

**Levels**: INFO, WARNING, ERROR, DEBUG, TRACE

### Viewing Logs

```bash
# View today's log
cat .git/hooks-logs/hook-$(date +%Y-%m-%d).log

# Tail logs (live)
tail -f .git/hooks-logs/hook-$(date +%Y-%m-%d).log

# Search for errors
grep ERROR .git/hooks-logs/hook-$(date +%Y-%m-%d).log

# Search for bypass usage
grep BYPASS .git/hooks-logs/*.log

# View last 50 lines
tail -50 .git/hooks-logs/hook-$(date +%Y-%m-%d).log
```

### Example Log Output

```
[2024-11-08 14:23:10] [INFO] [pre-commit] Hook execution started
[2024-11-08 14:23:10] [INFO] [pre-commit] Checking protected branch: feat-PROJ-123
[2024-11-08 14:23:11] [INFO] [pre-commit] Executing: Prettier Format Check
[2024-11-08 14:23:13] [INFO] [pre-commit] Success: Prettier Format Check (2s)
[2024-11-08 14:23:13] [INFO] [pre-commit] Pre-commit validation successful
```

### Debugging Hook Execution

```bash
# Enable bash debug mode
bash -x .githooks/pre-commit

# Debug specific hook with environment variables
BASH_XTRACEFD=1 bash -x .githooks/pre-push

# Test hook manually
./.githooks/pre-commit

# Check hook configuration
git config core.hooksPath
git config --get-regexp '^hooks\.'
```

### Common Debug Scenarios

#### Hook Not Running

```bash
# Check hooks path
git config core.hooksPath
# Should output: .githooks

# Check if hooks are executable
ls -la .githooks/
# Should show: -rwxr-xr-x

# Make hooks executable
chmod +x .githooks/*
```

#### Command Not Found

```bash
# Check if command exists
which npx
which npm

# Check PATH
echo $PATH

# Check Node.js installation
node --version
npm --version
```

#### Timeout Issues

```bash
# Increase timeout in commands.conf
# Change:
pre-commit:1:true:30:npm test:Run Tests
# To:
pre-commit:1:true:300:npm test:Run Tests

# Or disable mandatory
pre-commit:1:false:300:npm test:Run Tests
```

---

## Uninstallation

### Using Uninstall Script

```bash
# Run uninstaller
./.githooks/uninstall-hooks.sh

# Prompts for confirmation:
Are you sure you want to uninstall? (yes/no):
```

### What Gets Removed

- ✅ `core.hooksPath` configuration
- ✅ `hooks.*` configurations
- ✅ `branch.*.base` configurations
- ✅ Workflow settings (`rebase.autosquash`, `fetch.prune`)

### What Gets Preserved

- ✅ Hook files in `.githooks/` (not deleted)
- ✅ Logs archived to `.git/hooks-logs-archive/`

### Manual Uninstallation

```bash
# Remove hooks path
git config --unset core.hooksPath

# Remove hooks configurations
git config --unset hooks.maxCommits
git config --unset hooks.autoAddAfterFix
git config --unset hooks.parallelExecution

# Remove all branch base configs
for key in $(git config --get-regexp '^branch\..*\.base$' | awk '{print $1}'); do
    git config --unset "$key"
done

# Remove workflow settings
git config --unset rebase.autosquash
git config --unset fetch.prune

# Archive logs
mkdir -p .git/hooks-logs-archive
cp -r .git/hooks-logs .git/hooks-logs-archive/backup-$(date +%Y%m%d)
rm -rf .git/hooks-logs
```

### Reinstallation

```bash
# After uninstallation, reinstall with:
./.githooks/install-hooks.sh
```

---

## Best Practices

### For Developers

1. **Always Branch from Correct Base**
   - Features/bugfixes: `develop`
   - Hotfixes: `main`
   - Releases: `develop`

2. **Use Descriptive Branch Names**
   - Include JIRA ticket ID
   - Use hyphens, not underscores
   - Keep description concise but clear

3. **Write Good Commit Messages**
   - Follow format: `<type>: <JIRA-ID> <description>`
   - Use present tense
   - Be specific about what changed

4. **Squash Before Pushing**
   - Keep feature branches to ≤ 5 commits
   - Use interactive rebase to clean up history
   - Force-push with `--force-with-lease`

5. **Rebase, Don't Merge**
   - Keep linear history
   - `git pull --rebase` or `git config pull.rebase true`
   - Resolve conflicts carefully

6. **Test Before Pushing**
   - Run tests locally
   - Ensure linters pass
   - Verify builds complete

7. **Use Bypass Sparingly**
   - Document why bypass was used
   - Fix underlying issues after emergency
   - Don't make it a habit

### For Team Leads

1. **Educate Team on Git Flow**
   - Share this README
   - Conduct training sessions
   - Lead by example

2. **Configure Repository**
   - Set appropriate `hooks.maxCommits`
   - Enable `hooks.autoAddAfterFix` if using formatters
   - Configure `commands.conf` for your stack

3. **Monitor Hook Usage**
   - Review logs periodically
   - Identify bypass patterns
   - Address recurring issues

4. **Customize for Your Workflow**
   - Adjust branch naming if needed
   - Configure protected branches
   - Set up custom commands

5. **Maintain Documentation**
   - Keep team wiki updated
   - Document project-specific rules
   - Share common error fixes

### For Repository Maintainers

1. **Keep Hooks Updated**
   - Pull latest changes regularly
   - Test in staging before production
   - Communicate changes to team

2. **Review and Optimize Commands**
   - Remove slow/unused commands
   - Optimize command timeouts
   - Balance speed vs thoroughness

3. **Monitor Performance**
   - Track hook execution times
   - Identify bottlenecks
   - Consider parallel execution

4. **Handle Exceptions**
   - Document when bypass is acceptable
   - Provide guidance for edge cases
   - Update hooks for new scenarios

---

## Troubleshooting

### Common Issues

#### 1. Hooks Not Executing

**Symptoms**: Commits/pushes succeed without validation

**Diagnosis**:
```bash
# Check hooks path
git config core.hooksPath

# Check if hooks are executable
ls -la .githooks/
```

**Solution**:
```bash
# Reinstall hooks
./.githooks/install-hooks.sh

# Or manually configure
git config core.hooksPath .githooks
chmod +x .githooks/*
```

#### 2. Command Not Found Errors

**Symptoms**: `npx: command not found`, `python: command not found`

**Diagnosis**:
```bash
# Check if tools are installed
which npx
which python

# Check PATH
echo $PATH
```

**Solution**:
```bash
# Install missing tools
# Node.js: https://nodejs.org/
# Python: https://www.python.org/

# Or disable commands in commands.conf
# Comment out the failing commands
```

#### 3. Bash Version Issues

**Symptoms**: `This script requires bash 4.3 or higher`

**Diagnosis**:
```bash
bash --version
```

**Solution (macOS)**:
```bash
# Install newer bash
brew install bash

# Add to shells
sudo echo /usr/local/bin/bash >> /etc/shells

# Change default shell (optional)
chsh -s /usr/local/bin/bash
```

#### 4. Timeout Errors

**Symptoms**: Commands killed with "TIMEOUT after Xs"

**Diagnosis**: Check if commands are hanging

**Solution**:
```bash
# Increase timeout in commands.conf
# From:
pre-commit:1:true:30:npm test:Run Tests
# To:
pre-commit:1:true:300:npm test:Run Tests

# Or make optional
pre-commit:1:false:300:npm test:Run Tests
```

#### 5. Lockfile Validation False Positives

**Symptoms**: Valid lockfile changes flagged as errors

**Diagnosis**: Review specific error message

**Solution**:
```bash
# If validation is too strict, adjust mandatory flag
# From:
pre-commit:1:true:30:validation-command:Description
# To:
pre-commit:1:false:30:validation-command:Description

# Or regenerate lockfile
rm package-lock.json
npm install
git add package-lock.json
```

#### 6. Performance Issues

**Symptoms**: Hooks take too long to execute

**Diagnosis**:
```bash
# Check log for slow commands
cat .git/hooks-logs/hook-$(date +%Y-%m-%d).log | grep -E '\([0-9]+s\)'
```

**Solution**:
```bash
# Enable parallel execution
git config hooks.parallelExecution true

# Reduce command scope
# Instead of:
pre-commit:1:true:60:npm run lint:Lint All
# Use:
pre-commit:1:true:60:npx eslint {staged}:Lint Staged

# Make slow commands optional
pre-commit:3:false:120:npm run type-check:Type Check
```

### Getting Help

1. **Check Logs**:
   ```bash
   cat .git/hooks-logs/hook-$(date +%Y-%m-%d).log
   ```

2. **Enable Debug Mode**:
   ```bash
   bash -x .githooks/pre-commit
   ```

3. **Review Error Message**: Hooks provide detailed fix suggestions

4. **Search Issues**: Check repository issues for similar problems

5. **Ask Team**: Consult with team members or leads

---

## Contributing

We welcome contributions! To contribute:

1. **Fork the Repository**
2. **Create Feature Branch**: `git checkout -b feat-CONTRIB-123-your-feature develop`
3. **Make Changes**: Follow existing code style
4. **Test Thoroughly**: Ensure hooks work across scenarios
5. **Document Changes**: Update README if needed
6. **Submit Pull Request**: Target `develop` branch

### Development Guidelines

- Test on Linux, macOS, and Windows (Git Bash)
- Maintain backward compatibility
- Add logging for new features
- Include error handling
- Provide helpful error messages
- Update documentation

---

## License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.

**Key Points**:
- ✅ Free to use, modify, and distribute
- ✅ Must share source code of modifications
- ✅ Must use same license for derivatives
- ✅ Network use = distribution (AGPL requirement)

See [LICENSE](LICENSE) for full text.

---

## Credits

- **Author**: Enterprise Development Team
- **Git Flow Model**: [Vincent Driessen](https://nvie.com/posts/a-successful-git-branching-model/)
- **Inspiration**: Enterprise development best practices

---

## Support

- **Documentation**: This README
- **Issues**: GitHub Issues
- **Discussions**: GitHub Discussions

---

**Happy Git Flowing! 🚀**