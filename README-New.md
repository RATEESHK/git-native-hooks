# Git Flow Enforcement Hooks

Enterprise-grade Git hooks suite that enforces the [Git Flow branching model](https://nvie.com/posts/a-successful-git-branching-model/) with comprehensive validation, custom command execution, and detailed error reporting.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Initial Repository Setup & First-Time Configuration](#initial-repository-setup--first-time-configuration)
  - [Scenario 1: Brand New Local Repository (git init)](#scenario-1-brand-new-local-repository-git-init)
  - [Scenario 2: Repository Created on Remote (Clone & Setup)](#scenario-2-repository-created-on-remote-clone--setup)
  - [Scenario 3: Existing Repository with Only Main (Migration)](#scenario-3-existing-repository-with-only-main-migration)
- [Using This Repository as a Template](#using-this-repository-as-a-template)
- [Common Setup Issues & Solutions](#common-setup-issues--solutions)
- [Git Flow Workflows](#git-flow-workflows)
  - [Complete Feature Development Workflow](#complete-feature-development-workflow)
  - [Complete Release Workflow](#complete-release-workflow)
  - [Complete Hotfix Workflow](#complete-hotfix-workflow)
- [Version Tagging Strategy](#version-tagging-strategy)
- [Git Flow Best Practices](#git-flow-best-practices)
- [Git Flow Rules Enforced](#git-flow-rules-enforced)
- [Hook Reference](#hook-reference)
- [Configuration](#configuration)
- [Custom Commands](#custom-commands)
- [Bypass Mechanisms](#bypass-mechanisms)
- [Branch Naming Convention](#branch-naming-convention)
- [Commit Message Format](#commit-message-format)
- [Error Messages and Fixes](#error-messages-and-fixes)
- [Logging and Debugging](#logging-and-debugging)
- [Uninstallation](#uninstallation)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## Overview

This repository provides a comprehensive Git hooks framework that enforces **Git Flow branching model** to maintain code quality, ensure consistent workflows, and prevent common Git mistakes. The hooks provide intelligent validation, context-aware error messages, and powerful custom command execution capabilities.

**Key Benefits:**
- ✅ **Enforces Git Flow branching model** automatically
- ✅ **Prevents direct commits to protected branches** (main/develop)
- ✅ **Validates branch naming conventions** and commit messages
- ✅ **Ensures linear history** (no accidental merge commits)
- ✅ **Limits commit count** to encourage focused PRs
- ✅ **Executes custom commands** (linting, testing, type checking)
- ✅ **Comprehensive error messages** with step-by-step fixes
- ✅ **Emergency bypass mechanisms** for critical situations
- ✅ **Detailed logging** for debugging and audit trails

---

## Features

### Git Flow Enforcement
- **Branch Naming Validation**: Enforces standardized naming patterns for all branch types
- **Base Branch Validation**: Ensures branches are created from correct sources (features from develop, hotfixes from main)
- **Protected Branch Protection**: Blocks direct commits and pushes to main/develop
- **Merge Destination Validation**: Validates Git Flow merge rules (features → develop, releases → main & develop)

### Commit Management
- **Commit Message Validation**: Enforces structured commit messages with JIRA IDs
- **Commit Count Limits**: Encourages focused, reviewable PRs (default: 5 commits max)
- **Linear History Enforcement**: Prevents merge commits in feature branches
- **Foxtrot Merge Detection**: Identifies and prevents confusing merge patterns

### Custom Command Execution
- **Priority-Based Execution**: Run commands in specific order
- **Mandatory vs Optional**: Configure which checks block commits
- **Timeout Handling**: Prevent hanging on slow commands
- **Parallel Execution**: Speed up validation with concurrent commands
- **Auto-Fix and Re-Staging**: Automatically stage files modified by formatters
- **Lint-Staged Integration**: Built-in support for lint-staged

### Developer Experience
- **Context-Aware Error Messages**: Detailed explanations with step-by-step fixes
- **Automatic JIRA ID Extraction**: Pre-fills commit messages from branch names
- **Helpful Post-Commit Hints**: Detects lockfile, IaC, and CI/CD changes
- **Configurable Bypass Warnings**: Control bypass notification visibility
- **Comprehensive Logging**: All hook executions logged for debugging

---

## Prerequisites

- **Git**: Version 2.9 or higher
- **Bash**: Version 4.3 or higher (for command execution features)
  - macOS users: `brew install bash` (macOS ships with Bash 3.x)
  - Windows users: Git Bash is sufficient
- **Project with Git Flow structure**: main and develop branches

---

## Installation

### Step 1: Copy Hooks to Your Repository

Clone or download this repository, then copy the `.githooks` directory to your project:

```bash
# From your project root
cp -r /path/to/git-flow-hooks/.githooks ./
```

### Step 2: Run Installation Script

```bash
bash .githooks/install-hooks.sh
```

**What the installer does:**
1. ✅ Sets `core.hooksPath` to `.githooks`
2. ✅ Makes all hook scripts executable
3. ✅ Configures optimal Git settings (rebase.autosquash, fetch.prune)
4. ✅ Sets default hook configurations (max commits, bypass warning style)
5. ✅ Creates logging infrastructure
6. ✅ Detects and fixes misconfigured base branches
7. ✅ Creates sample `commands.conf` if not present

### Step 3: Verify Installation

```bash
# Check hooks are configured
git config core.hooksPath
# Output: .githooks

# Check configuration
git config --get-regexp hooks
# Output:
# hooks.maxcommits 5
# hooks.bypasswarningstyle compact
```

---

## Quick Start

### 1. Create Your First Feature Branch

```bash
# Ensure you're on develop
git checkout develop

# Create a feature branch (JIRA ID required)
git checkout -b feat-PROJ-123-add-user-authentication

# The post-checkout hook validates:
# ✓ Branch follows naming convention
# ✓ Branch created from correct base (develop)
```

### 2. Make Your Changes and Commit

```bash
# Stage your changes
git add src/auth.js

# Commit with proper format
git commit -m "feat: PROJ-123 Add JWT authentication system"

# The hooks validate:
# ✓ Not committing to protected branch
# ✓ Commit message follows format
# ✓ Custom commands pass (if configured)
```

### 3. Push Your Branch

```bash
git push origin feat-PROJ-123-add-user-authentication

# The pre-push hook validates:
# ✓ Branch naming convention
# ✓ Commit count within limits
# ✓ Linear history (no merge commits)
# ✓ Branch created from correct base
```

### 4. Merge via Pull Request

**On GitHub/GitLab/Bitbucket:**
1. Create Pull Request: `feat-PROJ-123-add-user-authentication` → `develop`
2. Get code review approval
3. Merge using **Squash and Merge** or **Merge (no fast-forward)**

**Locally (if required):**
```bash
git checkout develop
git merge --no-ff feat-PROJ-123-add-user-authentication
git push origin develop
```

---

## Initial Repository Setup & First-Time Configuration

### Scenario 1: Brand New Local Repository (git init)

**When to use:** Creating a completely new repository from scratch.

```bash
# Step 1: Initialize repository
mkdir my-new-project
cd my-new-project
git init

# Step 2: Create main branch with initial commit
echo "# My New Project" > README.md
git add README.md
git commit -m "chore: INIT-000 Initial repository setup"
git branch -M main

# Step 3: Create develop branch from main
git checkout -b develop main

# Step 4: Install Git Flow hooks
# Copy .githooks directory to your project
cp -r /path/to/git-flow-hooks/.githooks ./

# Run installation
bash .githooks/install-hooks.sh

# Step 5: Push both branches to remote
git remote add origin https://github.com/username/my-new-project.git
git push -u origin main
git push -u origin develop

# Step 6: Set develop as default branch (optional, on GitHub/GitLab)
# Go to repository settings → Branches → Change default branch to 'develop'

# Step 7: Start working on features
git checkout develop
git checkout -b feat-PROJ-001-initial-feature
```

**What you should have:**
- ✅ `main` branch (production-ready code)
- ✅ `develop` branch (integration branch for features)
- ✅ Git Flow hooks installed and configured
- ✅ Both branches pushed to remote

---

### Scenario 2: Repository Created on Remote (Clone & Setup)

**When to use:** Repository exists on GitHub/GitLab with only `main` branch.

```bash
# Step 1: Clone the repository
git clone https://github.com/username/existing-repo.git
cd existing-repo

# Step 2: Create develop branch from main
git checkout -b develop main
git push -u origin develop

# Step 3: Set develop as default branch (on GitHub/GitLab)
# Settings → Branches → Change default branch to 'develop'

# Step 4: Install Git Flow hooks
# Copy .githooks to your project
cp -r /path/to/git-flow-hooks/.githooks ./

# Run installation
bash .githooks/install-hooks.sh

# Step 5: Commit hooks to repository (recommended for team sharing)
git add .githooks/
git commit -m "chore: SETUP-001 Add Git Flow enforcement hooks"
git push origin develop

# Step 6: Team members run installation
# Each team member runs after pulling:
# bash .githooks/install-hooks.sh

# Step 7: Start working on features
git checkout -b feat-PROJ-101-new-feature
```

**What you should have:**
- ✅ Both `main` and `develop` branches
- ✅ Git Flow hooks committed to repository
- ✅ `develop` set as default branch for PRs
- ✅ Hooks installed locally for your user

---

### Scenario 3: Existing Repository with Only Main (Migration)

**When to use:** Active repository with only `main` branch, needs Git Flow migration.

```bash
# Step 1: Ensure you're on latest main
git checkout main
git pull origin main

# Step 2: Create develop from current main
git checkout -b develop main

# Step 3: Push develop to remote
git push -u origin develop

# Step 4: Update default branch (on GitHub/GitLab)
# Settings → Branches → Change default branch to 'develop'
# ⚠️ IMPORTANT: Update PR base branch defaults

# Step 5: Install Git Flow hooks
cp -r /path/to/git-flow-hooks/.githooks ./
bash .githooks/install-hooks.sh

# Step 6: Commit hooks to repository
git add .githooks/
git commit -m "chore: MIGRATE-001 Add Git Flow hooks and workflow"
git push origin develop

# Step 7: Notify team about workflow change
# Send announcement with:
# - New branching model (Git Flow)
# - Hook installation instructions
# - Branch naming conventions
# - Commit message format

# Step 8: Migrate existing feature branches (if any)
git checkout existing-feature-branch
git config branch.existing-feature-branch.base develop

# Step 9: New work starts from develop
git checkout develop
git checkout -b feat-PROJ-200-new-feature
```

**Migration Checklist:**
- ✅ `develop` branch created from `main`
- ✅ Default branch changed to `develop` on remote
- ✅ Team notified about workflow change
- ✅ Existing feature branches reconfigured
- ✅ Git Flow hooks installed and committed
- ✅ Documentation updated (README, CONTRIBUTING.md)

**Communication Template for Team:**
```
📢 IMPORTANT: Git Flow Migration

We're adopting Git Flow branching model to improve our development workflow.

ACTION REQUIRED:
1. Pull latest changes: `git pull origin develop`
2. Install hooks: `bash .githooks/install-hooks.sh`
3. Create features from develop: `git checkout -b feat-JIRA-ID-description develop`

NEW RULES:
- Features: Create from 'develop', name as 'feat-JIRA-XXX-description'
- Hotfixes: Create from 'main', name as 'hotfix-JIRA-XXX-description'
- Releases: Create from 'develop', name as 'release-X.Y.Z'
- Commit format: 'type: JIRA-XXX description'

Questions? See README.md or ask in #dev-team
```

---

## Using This Repository as a Template

### Option 1: Copy Hooks to Existing Repository

```bash
# Navigate to your project
cd /path/to/your/project

# Copy .githooks directory
cp -r /path/to/git-flow-hooks/.githooks ./

# Install
bash .githooks/install-hooks.sh

# Commit to your repository
git add .githooks/
git commit -m "chore: Add Git Flow enforcement hooks"
git push
```

### Option 2: GitHub Template Repository

1. **On GitHub**: Click "Use this template" button
2. **Clone your new repository**:
   ```bash
   git clone https://github.com/your-username/your-new-repo.git
   cd your-new-repo
   ```
3. **Install hooks**:
   ```bash
   bash .githooks/install-hooks.sh
   ```
4. **Start developing**:
   ```bash
   git checkout -b feat-PROJ-001-initial-feature
   ```

### Option 3: Fork and Customize

```bash
# Fork this repository on GitHub
# Clone your fork
git clone https://github.com/your-username/git-flow-hooks.git
cd git-flow-hooks

# Customize hooks as needed
# Edit files in .githooks/

# Use in your projects
cp -r .githooks /path/to/your/project/
```

---

## Common Setup Issues & Solutions

### Issue 1: Hooks Not Executing

**Symptom:** Commits succeed without validation

**Solutions:**
```bash
# Check hooks path is set
git config core.hooksPath
# Should output: .githooks

# If empty, reinstall:
bash .githooks/install-hooks.sh

# Check hooks are executable
ls -la .githooks/
# Should show: -rwxr-xr-x (executable)

# If not executable:
chmod +x .githooks/*
chmod +x .githooks/lib/*
```

### Issue 2: "bash version too old" Error

**Symptom:** `Error: This script requires bash 4.3 or higher`

**Solutions:**

**macOS:**
```bash
# Install newer bash
brew install bash

# Verify version
bash --version

# Update shebang in hooks (if needed)
# Or run commands with: /usr/local/bin/bash
```

**Windows:**
```bash
# Git Bash usually sufficient
# If issues persist, use WSL:
wsl bash .githooks/install-hooks.sh
```

### Issue 3: Wrong Base Branch Detected

**Symptom:** Hook reports "created from wrong branch"

**Solution:**
```bash
# Check current base configuration
git config branch.your-branch.base

# Fix incorrect base
git config branch.your-branch.base develop

# Or reinstall hooks (auto-fixes misconfigurations)
bash .githooks/install-hooks.sh
```

### Issue 4: Custom Commands Failing

**Symptom:** Hook fails with "command not found"

**Solutions:**
```bash
# Check commands.conf syntax
cat .githooks/commands.conf

# Ensure commands are installed
which npx
which eslint

# Test command manually
npx eslint src/

# Disable command temporarily (set mandatory to false)
# pre-commit:1:false:30:npx eslint {staged}:ESLint
```

### Issue 5: Permission Denied Errors

**Symptom:** `Permission denied: .githooks/pre-commit`

**Solution:**
```bash
# Make all hooks executable
chmod +x .githooks/*
chmod +x .githooks/lib/*

# Verify
ls -la .githooks/ | grep -E "^-rwx"
```

---

## Git Flow Workflows

### Complete Feature Development Workflow

**Scenario:** Adding a new feature to the application

```bash
# 1. Start from develop branch
git checkout develop
git pull origin develop

# 2. Create feature branch with JIRA ID
git checkout -b feat-PROJ-123-user-authentication develop

# ✅ post-checkout hook validates:
#    - Branch name follows convention
#    - Created from correct base (develop)
#    - Branch type allows branching

# 3. Make changes
vim src/auth/login.js
vim tests/auth.test.js

# 4. Commit changes (multiple commits allowed, within limit)
git add src/auth/login.js
git commit -m "feat: PROJ-123 Add login endpoint"

# ✅ pre-commit hook validates:
#    - Not on protected branch
#    - Custom commands pass (lint, format)
# ✅ prepare-commit-msg pre-fills JIRA ID
# ✅ commit-msg validates message format

git add tests/auth.test.js
git commit -m "feat: PROJ-123 Add authentication tests"

# 5. Push feature branch
git push origin feat-PROJ-123-user-authentication

# ✅ pre-push hook validates:
#    - Branch naming convention
#    - Commit count ≤ 5 (configurable)
#    - Linear history (no merge commits)
#    - Branch base is correct

# 6. Create Pull Request
# On GitHub/GitLab: feat-PROJ-123-user-authentication → develop

# 7. After PR approval, merge to develop
# Option A: Merge on GitHub (Squash and Merge recommended)
# Option B: Local merge
git checkout develop
git merge --no-ff feat-PROJ-123-user-authentication
git push origin develop

# 8. Delete feature branch
git branch -d feat-PROJ-123-user-authentication
git push origin --delete feat-PROJ-123-user-authentication
```

**Key Points:**
- ✅ Features **MUST** branch from `develop`
- ✅ Features **MUST** merge back to `develop`
- ✅ Feature branches use naming: `feat-JIRA-ID-description`
- ✅ Keep commits focused (≤5 commits, squash if needed)
- ✅ Linear history (rebase instead of merge)

---

### Complete Release Workflow

**Scenario:** Preparing version 1.2.0 for production

```bash
# 1. Ensure develop is ready for release
git checkout develop
git pull origin develop

# Run final checks
npm test
npm run build

# 2. Create release branch from develop
git checkout -b release-1.2.0 develop

# ✅ post-checkout hook validates:
#    - Release branch follows naming (release-X.Y.Z)
#    - Created from develop (correct base)

# 3. Bump version and update changelog
npm version 1.2.0 --no-git-tag-version
vim CHANGELOG.md

# Commit version bump (JIRA ID optional for releases)
git add package.json CHANGELOG.md
git commit -m "chore: Bump version to 1.2.0"

# ✅ commit-msg allows commits WITHOUT JIRA IDs on release branches

# 4. Fix any last-minute bugs DIRECTLY on release branch
git commit -m "fix: Correct login redirect URL"
git commit -m "docs: Update API documentation"

# 5. Push release branch
git push origin release-1.2.0

# 6. Merge release to main (production)
git checkout main
git pull origin main
git merge --no-ff release-1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main --tags

# 7. Merge release back to develop (incorporate bug fixes)
git checkout develop
git merge --no-ff release-1.2.0
git push origin develop

# 8. Delete release branch
git branch -d release-1.2.0
git push origin --delete release-1.2.0
```

**Key Points:**
- ✅ Releases **MUST** branch from `develop`
- ✅ Releases **MUST** merge to **both** `main` AND `develop`
- ✅ Release branches use naming: `release-X.Y.Z` (NO JIRA ID)
- ✅ JIRA IDs are **OPTIONAL** in commit messages on release branches
- ✅ Only bug fixes and release tasks on release branch (NO new features)
- ✅ Tag main after merge with version number

---

### Complete Hotfix Workflow

**Scenario:** Critical bug in production (main branch) needs immediate fix

```bash
# 1. Start from main (production)
git checkout main
git pull origin main

# 2. Create hotfix branch from main
git checkout -b hotfix-PROJ-999-security-patch main

# ✅ post-checkout hook validates:
#    - Hotfix branch follows naming
#    - Created from main (correct base for hotfixes)

# 3. Apply the fix
vim src/auth/validator.js
git add src/auth/validator.js
git commit -m "fix: PROJ-999 Fix SQL injection vulnerability"

# 4. Add tests for the fix
vim tests/security.test.js
git add tests/security.test.js
git commit -m "test: PROJ-999 Add security validation tests"

# 5. Push hotfix branch
git push origin hotfix-PROJ-999-security-patch

# ✅ pre-push validates all Git Flow rules

# 6. Merge hotfix to main (production fix)
git checkout main
git merge --no-ff hotfix-PROJ-999-security-patch
git tag -a v1.2.1 -m "Hotfix: Security patch"
git push origin main --tags

# 7. Merge hotfix to develop (ensure fix in next release)
git checkout develop
git merge --no-ff hotfix-PROJ-999-security-patch
git push origin develop

# 8. Delete hotfix branch
git branch -d hotfix-PROJ-999-security-patch
git push origin --delete hotfix-PROJ-999-security-patch
```

**Key Points:**
- ✅ Hotfixes **MUST** branch from `main`
- ✅ Hotfixes **MUST** merge to **both** `main` AND `develop`
- ✅ Hotfix branches use naming: `hotfix-JIRA-ID-description`
- ✅ Tag main after merge with patch version (e.g., v1.2.1)
- ✅ Hotfixes are for **emergency production fixes only**

---

## Version Tagging Strategy

### Semantic Versioning

This project follows [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): New features (backward-compatible)
- **PATCH** (1.0.0 → 1.0.1): Bug fixes (backward-compatible)

### Creating Tags

**After Release Merge:**
```bash
# On main branch after merging release
git checkout main
git merge --no-ff release-1.3.0

# Create annotated tag
git tag -a v1.3.0 -m "Release version 1.3.0

Features:
- User authentication system
- Dashboard analytics
- Email notifications

Bug Fixes:
- Fixed login redirect
- Corrected timezone handling"

# Push tags to remote
git push origin main --tags
```

**After Hotfix Merge:**
```bash
# On main branch after merging hotfix
git checkout main
git merge --no-ff hotfix-PROJ-999-security-patch

# Create patch tag
git tag -a v1.2.1 -m "Hotfix: Security patch

- Fixed SQL injection vulnerability
- Added input validation"

git push origin main --tags
```

### Version Bump Strategies

**For Releases:**
```bash
# MINOR version (new features)
npm version minor  # 1.2.0 → 1.3.0

# MAJOR version (breaking changes)
npm version major  # 1.2.0 → 2.0.0
```

**For Hotfixes:**
```bash
# PATCH version (bug fixes)
npm version patch  # 1.2.0 → 1.2.1
```

---

## Git Flow Best Practices

### Branch Lifecycle

1. **main**: Production-ready code only
   - Direct commits: ❌ **BLOCKED**
   - Receives merges from: `release-*`, `hotfix-*`
   - Tagged with version numbers

2. **develop**: Integration branch for features
   - Direct commits: ❌ **BLOCKED** (use feature branches)
   - Receives merges from: `feat-*`, `bugfix-*`, `release-*`, `hotfix-*`
   - Always ahead of main

3. **Feature branches** (`feat-*`, `bugfix-*`):
   - Created from: `develop`
   - Merged into: `develop`
   - Short-lived (days to weeks)
   - Deleted after merge

4. **Release branches** (`release-*`):
   - Created from: `develop`
   - Merged into: `main` AND `develop`
   - Short-lived (hours to days)
   - Bug fixes only, no new features

5. **Hotfix branches** (`hotfix-*`):
   - Created from: `main`
   - Merged into: `main` AND `develop`
   - Very short-lived (hours)
   - Critical production fixes only

### Commit Hygiene

**Good Practices:**
- ✅ Keep commits small and focused
- ✅ Write descriptive commit messages
- ✅ Include JIRA ticket IDs
- ✅ Squash WIP/fixup commits before merging
- ✅ Use conventional commit types (feat, fix, chore)

**Bad Practices:**
- ❌ Large commits with multiple unrelated changes
- ❌ Generic messages like "fixes" or "updates"
- ❌ Missing JIRA IDs (except on release branches)
- ❌ Merge commits in feature branches
- ❌ More than 5 commits per PR (without justification)

### Pull Request Guidelines

**Before Creating PR:**
```bash
# 1. Rebase on latest develop
git checkout develop
git pull origin develop
git checkout feat-PROJ-123-feature
git rebase develop

# 2. Squash if too many commits
git rebase -i develop
# Mark commits as 'squash' or 'fixup'

# 3. Force push (safely)
git push --force-with-lease origin feat-PROJ-123-feature
```

**PR Description Template:**
```markdown
## Summary
Brief description of changes

## JIRA Ticket
PROJ-123

## Changes
- Added user authentication
- Updated database schema
- Added unit tests

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No merge conflicts
```

---

## Git Flow Rules Enforced

### Branch Naming Rules

| Branch Type | Pattern | Example | JIRA Required | Base Branch |
|------------|---------|---------|---------------|-------------|
| Main | `main` | `main` | N/A | - |
| Develop | `develop` | `develop` | N/A | - |
| Feature | `feat-JIRA-ID-description` | `feat-PROJ-123-add-auth` | ✅ Yes | `develop` |
| Feature (alt) | `feature-JIRA-ID-description` | `feature-PROJ-123-add-auth` | ✅ Yes | `develop` |
| Bugfix | `fix-JIRA-ID-description` | `fix-PROJ-124-memory-leak` | ✅ Yes | `develop` |
| Bugfix (alt) | `bugfix-JIRA-ID-description` | `bugfix-PROJ-124-memory-leak` | ✅ Yes | `develop` |
| Hotfix | `hotfix-JIRA-ID-description` | `hotfix-PROJ-125-security` | ✅ Yes | `main` |
| Release | `release-VERSION` | `release-1.2.0` | ❌ No | `develop` |
| Support | `TYPE-JIRA-ID-description` | `chore-PROJ-126-update-deps` | ✅ Yes | `develop` |

**Support Types:** `build`, `chore`, `ci`, `docs`, `techdebt`, `perf`, `refactor`, `revert`, `style`, `test`

### Merge Destination Rules

| Source Branch | Can Merge To | Blocked From |
|--------------|--------------|--------------|
| `feat-*` | ✅ `develop` | ❌ `main` |
| `bugfix-*` | ✅ `develop` | ❌ `main` |
| `hotfix-*` | ✅ `main`, ✅ `develop` | - |
| `release-*` | ✅ `main`, ✅ `develop` | - |
| `support-*` | ✅ `develop` | ❌ `main` |

### Protected Branch Rules

**main:**
- ❌ Direct commits blocked
- ❌ Direct pushes blocked
- ✅ Only receives merges from `release-*` or `hotfix-*`
- ✅ Every merge must be tagged

**develop:**
- ❌ Direct commits blocked (best practice)
- ✅ Receives merges from feature branches
- ✅ Source for releases

### Branching Source Rules

**CRITICAL: You CANNOT create branches FROM:**
- ❌ `release-*` branches (fixes go directly on release branch)
- ❌ `hotfix-*` branches (fixes go directly on hotfix branch)

**Official Git Flow Rule:**
> "During release preparation, bug fixes may be applied **in this branch** (rather than on the develop branch)"

**Correct Workflow:**
```bash
# ✅ CORRECT: Fix directly on release branch
git checkout release-1.2.0
git commit -m "fix: Correct version number"

# ❌ WRONG: Creating branch from release
git checkout -b fix-something release-1.2.0
# This will be BLOCKED by post-checkout hook
```

---

## Hook Reference

### pre-commit

**Executes before:** Commit creation

**Validations:**
- ✅ Prevents commits to protected branches (main/develop)
- ✅ Runs custom commands from commands.conf
- ✅ Lint-staged integration
- ✅ Auto-fix and re-staging support

**Example Output:**
```
✗ ERROR: Protected Branch
Cannot commit directly to protected branch 'main'. Use Pull Requests.

Move to hotfix branch (for production fixes):
  git stash push -m 'Changes from main'
  git checkout -b hotfix-PROJ-123-your-fix main
  git stash pop
  git add <files> && git commit
```

**Bypass:**
```bash
ALLOW_DIRECT_PROTECTED=1 git commit -m "Emergency fix"
```

---

### prepare-commit-msg

**Executes before:** Commit message editor opens

**Features:**
- ✅ Extracts JIRA ID from branch name
- ✅ Pre-fills commit message template
- ✅ Determines commit type from branch type
- ✅ Preserves existing commit messages

**Example:**

**Branch:** `feat-PROJ-123-add-login`

**Pre-filled message:**
```
feat: PROJ-123 

# Please enter a descriptive commit message above
# Format: <type>: <JIRA-ID> <description>
#
# Types: feat, fix, chore, break, tests
# Example: feat: PROJ-123 Add user authentication
#
# Your branch: feat-PROJ-123-add-login
```

---

### commit-msg

**Executes before:** Commit is finalized

**Validations:**
- ✅ Validates commit message format
- ✅ Branch-aware validation (JIRA optional for releases)
- ✅ Checks commit types and structure
- ✅ Allows merge and revert commits

**Valid Formats:**

**Standard (JIRA required):**
```
feat: PROJ-123 Add user authentication
fix: PROJ-124 Resolve memory leak
chore: PROJ-125 Update dependencies
```

**Release branches (JIRA optional):**
```
chore: Bump version to 1.2.0
docs: Update changelog
Bump version to 1.2.0
```

**Always allowed:**
```
Merge branch 'feature-xyz'
Revert "feat: PROJ-123 Add broken feature"
```

**Example Error:**
```
✗ ERROR: Invalid Commit Message
Commit message must follow: <type>: <JIRA-ID> <description>

Your message: "added authentication"

✓ JIRA ID from branch: PROJ-123

Required format: feat: PROJ-123 add your description
Types: feat, fix, chore, break, tests, docs, refactor, perf

Fix now:
  git commit --amend -m "feat: PROJ-123 add user authentication"
```

---

### post-commit

**Executes after:** Commit creation

**Features:**
- ✅ Detects lockfile changes (package-lock.json, yarn.lock, etc.)
- ✅ Detects Infrastructure as Code changes (Terraform, Kubernetes)
- ✅ Detects CI/CD configuration changes
- ✅ Provides helpful hints and next steps

**Example Output:**
```
💡 HINT: Lockfile changed - Dependencies updated
  • package-lock.json

  npm ci && npm audit && npm test

🔄 If lockfile shouldn't have changed:
  git reset --soft HEAD~1   # Undo commit, keep changes
  git restore --staged package-lock.json
  git restore package-lock.json
```

---

### pre-push

**Executes before:** Pushing to remote

**Validations:**
- ✅ Branch naming convention
- ✅ Protected branch push prevention
- ✅ Branch base validation (Git Flow compliance)
- ✅ Commit count limits (default: 5)
- ✅ Linear history enforcement
- ✅ Foxtrot merge detection
- ✅ Merge destination validation
- ✅ Git Flow merge detection

**Example Error:**
```
✗ ERROR: Invalid Branch Name
Branch 'my-feature' doesn't follow Git Flow naming: <type>-<JIRA>-<description>

⚠ No JIRA ID detected in branch name

Valid format: feat-PROJ-123-your-description
Examples: feat-PROJ-123-add-auth | fix-PROJ-123-memory-leak

Option 1 - Create new branch (recommended):
  git checkout develop
  git checkout -b feat-PROJ-123-your-description
  git cherry-pick <commit1> <commit2>
  git push origin -u feat-PROJ-123-your-description
  git branch -D my-feature
```

---

### post-checkout

**Executes after:** Checking out a branch

**Validations:**
- ✅ **CRITICAL:** Prevents creating branches FROM release/hotfix branches
- ✅ Validates base branch for Git Flow compliance
- ✅ Warns about protected branches
- ✅ Provides branch naming guidance
- ✅ Stores branch creation tracking

**Example (Blocked):**
```
✗ ERROR: Git Flow Violation: Cannot Create Branches FROM Release Branch

❌ CRITICAL: You attempted to create a branch FROM a release branch!

Current situation:
  Previous branch: release-1.2.0 (type: release)
  New branch: feat-PROJ-200-new-feature

═══════════════════════════════════════════════════
       GIT FLOW: RELEASE BRANCH WORKFLOW
═══════════════════════════════════════════════════

📋 Release Branch Purpose:
   • Prepare for a production release
   • Apply bug fixes DIRECTLY on the release branch
   • NO new features allowed
   • NO branching allowed

Official Git Flow Rule (nvie.com):
  "During that time, bug fixes may be applied IN THIS BRANCH"
  "(rather than on the develop branch)"

✓ CORRECT: Commit bug fixes DIRECTLY on release branch
  git checkout release-1.2.0
  # Make your fix
  git add <files>
  git commit -m "fix: PROJ-123 fix bug in release"

❌ WRONG: Create a new branch from release
  git checkout -b feat-PROJ-123-fix  # This is blocked!

🔧 TO FIX THIS ISSUE:

Option 1: Delete the incorrectly created branch and commit directly
  git checkout release-1.2.0           # Go back to release branch
  git branch -D feat-PROJ-200-new-feature      # Delete wrong branch
  # Now make your changes and commit directly to release-1.2.0
```

---

### post-rewrite

**Executes after:** Rebase or commit amend

**Features:**
- ✅ Reminds about force-push requirement
- ✅ Provides safe force-push commands
- ✅ Shows undo instructions

**Example Output:**
```
✓ SUCCESS: Rebase completed
⚠ WARNING: Force-push required

Next steps:
  1. Review: git log --oneline -10
  2. Check:  git log --oneline origin/develop..feat-PROJ-123
  3. Push:   git push --force-with-lease origin feat-PROJ-123

⚠️  Use --force-with-lease (safer than --force)

🔄 Undo rebase if needed:
  git reflog                    # Find pre-rebase commit
  git reset --hard HEAD@{N}     # Go back to commit N
  git reset --hard ORIG_HEAD    # Quick undo (if available)
```

---

### applypatch-msg

**Executes before:** Applying patches with `git am`

**Validations:**
- ✅ Validates commit message format in patches
- ✅ Same rules as commit-msg hook
- ✅ Branch-aware validation

**Usage:**
```bash
# Apply patch from email
git am < patch.mbox

# Hook validates patch commit message
```

---

## Configuration

### Git Hook Configuration

Set via `git config`:

```bash
# Maximum commits allowed per branch (default: 5)
git config hooks.maxCommits 10

# Auto-stage files after fix (default: false)
git config hooks.autoAddAfterFix true

# Bypass warning style: compact|full|once (default: compact)
git config hooks.bypassWarningStyle once

# Enable parallel command execution (default: false)
git config hooks.parallelExecution true

# Set base branch for current branch
git config branch.feat-PROJ-123.base develop
```

### Bypass Warning Styles

**Compact (default):**
```
⚠️  BYPASS ACTIVE: BYPASS_HOOKS=1 (Only for critical changes! Disable: unset BYPASS_HOOKS)
```

**Full:**
```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                      ⚠️  CRITICAL SECURITY WARNING ⚠️                         ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

🚨 GIT HOOKS BYPASS MECHANISM IS ACTIVE 🚨

[... detailed explanation ...]
```

**Once:**
- Shows full warning on first use per session
- Shows compact warning on subsequent uses

**Change style:**
```bash
git config hooks.bypassWarningStyle compact  # Minimal
git config hooks.bypassWarningStyle full     # Always detailed
git config hooks.bypassWarningStyle once     # Detailed once, then compact
```

---

## Custom Commands

Custom commands are defined in `.githooks/commands.conf` and executed during hook execution.

### Configuration Format

```
HOOK:PRIORITY:MANDATORY:TIMEOUT:COMMAND:DESCRIPTION
```

**Fields:**
- **HOOK**: Hook name (pre-commit, pre-push, etc.)
- **PRIORITY**: Execution order (lower = earlier, 1-100)
- **MANDATORY**: `true` (blocks on failure) | `false` (warning only)
- **TIMEOUT**: Max execution time in seconds
- **COMMAND**: Shell command to execute
- **DESCRIPTION**: Human-readable description

### Variables

- `{staged}`: Expands to space-separated list of staged files (pre-commit only)

### Examples

**JavaScript/TypeScript Project:**
```conf
# Format checking
pre-commit:1:true:30:npx prettier --check {staged}:Prettier Format Check

# Linting
pre-commit:2:true:60:npx eslint {staged}:ESLint

# Type checking (optional, can be slow)
pre-commit:3:false:120:npx tsc --noEmit --skipLibCheck:TypeScript Check

# Unit tests before push
pre-push:1:true:300:npm test:Run Unit Tests

# Build verification
pre-push:2:false:600:npm run build:Build Project
```

**Python Project:**
```conf
# Format checking
pre-commit:1:true:30:black --check {staged}:Black Format Check

# Linting
pre-commit:2:true:60:flake8 {staged}:Flake8 Linting

# Type checking
pre-commit:3:false:60:mypy {staged}:MyPy Type Check

# Unit tests
pre-push:1:true:300:pytest tests/unit:Run Unit Tests
```

**Go Project:**
```conf
# Format checking
pre-commit:1:true:30:gofmt -l {staged}:Go Format Check

# Vetting
pre-commit:2:true:60:go vet ./...:Go Vet

# Linting
pre-commit:3:true:90:golangci-lint run {staged}:GolangCI-Lint

# Unit tests
pre-push:1:true:300:go test ./...:Run Tests
```

### Priority Guidelines

- **1-10**: Critical, fast checks (format, lint, lockfile sync)
- **11-20**: Important checks (type check, compilation)
- **21-30**: Optional quality checks
- **31+**: Slow, optional validations

### Timeout Guidelines

- **5-10s**: Fast checks (conflict detection, file presence)
- **10-30s**: Format checkers, linters
- **30-90s**: Type checkers, compilation
- **90-300s**: Unit tests
- **300-600s**: Integration tests, builds

### Auto-Fix and Re-Staging

When commands modify files (e.g., auto-formatters):

```bash
# Enable auto-staging
git config hooks.autoAddAfterFix true

# Now commands that modify files will auto-stage changes
# Example: prettier --write, eslint --fix
```

**Example with auto-fix:**
```conf
# Auto-fix linting issues
pre-commit:1:true:60:npx eslint --fix {staged}:ESLint Auto-fix

# Auto-format code
pre-commit:2:true:30:npx prettier --write {staged}:Prettier Format
```

### Parallel Execution

Speed up validation by running commands in parallel:

```bash
# Enable parallel execution
git config hooks.parallelExecution true
```

**Rules:**
- Commands with **same priority** run in parallel
- Commands with **different priorities** run sequentially
- Max 4 parallel jobs by default

---

## Bypass Mechanisms

### Emergency Bypass

**BYPASS_HOOKS=1** - Skips ALL validations

```bash
# Bypass all hooks for emergency commit
BYPASS_HOOKS=1 git commit -m "Emergency production fix"

# Bypass for push
BYPASS_HOOKS=1 git push origin hotfix-emergency
```

**What gets bypassed:**
- ❌ Branch naming validation
- ❌ Git Flow rules
- ❌ Commit message validation
- ❌ Commit count limits
- ❌ Linear history enforcement
- ❌ Custom commands

⚠️ **WARNING:** Use ONLY for emergencies. All bypasses are logged.

### Protected Branch Bypass

**ALLOW_DIRECT_PROTECTED=1** - Allows commits/pushes to protected branches

```bash
# Allow commit to main/develop
ALLOW_DIRECT_PROTECTED=1 git commit -m "feat: ADMIN-001 Initial setup"

# Allow push to protected branch
ALLOW_DIRECT_PROTECTED=1 git push origin main
```

**What gets bypassed:**
- ❌ Protected branch commit prevention
- ❌ Protected branch push prevention
- ✅ All other validations still run

### Bypass Best Practices

**When to use:**
- ✅ Emergency production fixes requiring immediate action
- ✅ Critical incidents
- ✅ One-time administrative tasks (initial setup, repository migration)
- ✅ Automated systems (CI/CD) with proper authorization

**When NOT to use:**
- ❌ Regular development work
- ❌ "I don't feel like following the rules"
- ❌ To avoid fixing validation errors
- ❌ Because you're in a hurry

**After using bypass:**
```bash
# DISABLE IMMEDIATELY
unset BYPASS_HOOKS
unset ALLOW_DIRECT_PROTECTED

# Verify disabled
echo $BYPASS_HOOKS
# Should output nothing
```

### Per-Hook Bypass

Skip specific hooks using `--no-verify`:

```bash
# Skip pre-commit hook only
git commit --no-verify -m "WIP: Work in progress"

# Skip pre-push hook only
git push --no-verify origin feature-branch
```

⚠️ **Note:** `--no-verify` skips ALL hooks for that operation, not just specific validations.

---

## Branch Naming Convention

### Pattern Reference

**Feature branches:**
```
feat-<JIRA>-<description>
feature-<JIRA>-<description>

Examples:
feat-PROJ-123-add-user-login
feature-AUTH-456-oauth-integration
```

**Bugfix branches:**
```
fix-<JIRA>-<description>
bugfix-<JIRA>-<description>

Examples:
fix-PROJ-124-memory-leak
bugfix-API-789-null-pointer
```

**Hotfix branches:**
```
hotfix-<JIRA>-<description>

Examples:
hotfix-PROD-001-security-patch
hotfix-URGENT-999-database-crash
```

**Release branches:**
```
release-<VERSION>

Examples:
release-1.2.0
release-2.0.0-rc1
release-1.3.0-beta
```

**Support branches:**
```
<type>-<JIRA>-<description>

Types: build, chore, ci, docs, techdebt, perf, refactor, revert, style, test

Examples:
chore-PROJ-125-update-dependencies
docs-PROJ-126-api-documentation
ci-PROJ-127-github-actions
refactor-PROJ-128-cleanup-code
```

### JIRA ID Format

- **2-10 uppercase letters**, followed by dash, then numbers
- Examples: `PROJ-123`, `AUTH-456`, `FRONTEND-789`

### Description Format

- **Lowercase with hyphens** (kebab-case)
- **Short and descriptive** (2-5 words)
- Examples: `add-login`, `fix-memory-leak`, `update-dependencies`

### Validation Regex

```regex
# Feature/Bugfix/Support
^(feat|feature|fix|bugfix|build|chore|ci|docs|techdebt|perf|refactor|revert|style|test)-[A-Z]{2,10}-[0-9]+-[a-z0-9-]+$

# Hotfix
^hotfix-[A-Z]{2,10}-[0-9]+-[a-z0-9-]+$

# Release (NO JIRA ID)
^release-[0-9]+(\.[0-9]+)*(-[a-zA-Z0-9._-]+)?$
```

---

## Commit Message Format

### Standard Format (JIRA Required)

```
<type>: <JIRA-ID> <description>

Types: feat, fix, chore, break, tests, docs, style, refactor, perf, hotfix
```

**Examples:**
```
feat: PROJ-123 Add user authentication system
fix: PROJ-124 Resolve memory leak in data processor
chore: PROJ-125 Update dependencies to latest versions
break: PROJ-126 Remove deprecated API endpoints
tests: PROJ-127 Add integration tests for payment module
docs: PROJ-128 Update API documentation
refactor: PROJ-129 Simplify authentication logic
perf: PROJ-130 Optimize database queries
```

### Release Branch Format (JIRA Optional)

**With JIRA:**
```
feat: PROJ-123 Add feature to release
fix: PROJ-124 Fix bug in release
```

**Without JIRA (allowed on release branches):**
```
chore: Bump version to 1.2.0
docs: Update CHANGELOG
Bump version to 1.2.0
Update changelog
Prepare release 1.2.0
Finalize release
```

### Always Allowed

**Merge commits:**
```
Merge branch 'feat-PROJ-123-feature'
Merge pull request #123 from feat-PROJ-123-feature
```

**Revert commits:**
```
Revert "feat: PROJ-123 Add broken feature"
```

### Commit Message Best Practices

**Good:**
```
feat: PROJ-123 Add JWT authentication with refresh tokens
fix: PROJ-124 Resolve race condition in user session management
chore: PROJ-125 Upgrade React from 17 to 18
```

**Bad:**
```
Added stuff
fixed bug
updates
WIP
asdf
```

### Validation Regex

```regex
# Standard (JIRA required)
^(feat|fix|chore|break|tests|docs|style|refactor|test|hotfix): [A-Z]{2,10}-[0-9]+ [^[:space:]].*$

# Release branch (JIRA optional)
^(feat|fix|chore|break|tests|docs|style|refactor|perf|build|ci|release|version):[[:space:]][^[:space:]].*$

# Simple release messages
^(Bump|Update|Prepare|Release|Version|Finalize)
```

---

## Error Messages and Fixes

### Common Errors

#### Error: Protected Branch Commit

```
✗ ERROR: Protected Branch
Cannot commit directly to protected branch 'main'. Use Pull Requests.
```

**Fix:**
```bash
# Move changes to feature branch
git stash push -m 'Changes from main'
git checkout -b hotfix-PROJ-999-your-fix main
git stash pop
git add <files>
git commit -m "fix: PROJ-999 your fix"
```

#### Error: Invalid Branch Name

```
✗ ERROR: Invalid Branch Name
Branch 'my-feature' doesn't follow Git Flow naming: <type>-<JIRA>-<description>
```

**Fix:**
```bash
# Rename branch
git branch -m my-feature feat-PROJ-123-my-feature
git push origin -u feat-PROJ-123-my-feature
```

#### Error: Invalid Commit Message

```
✗ ERROR: Invalid Commit Message
Commit message must follow: <type>: <JIRA-ID> <description>

Your message: "added feature"
```

**Fix:**
```bash
# Amend commit message
git commit --amend -m "feat: PROJ-123 add user authentication feature"
```

#### Error: Too Many Commits

```
✗ ERROR: Too Many Commits
Branch has 8 commits (limit: 5). Squash commits before pushing.
```

**Fix:**
```bash
# Interactive rebase to squash
git rebase -i develop
# Mark commits as 'squash' or 'fixup'

# Or soft reset and recommit
git reset --soft develop
git commit -m "feat: PROJ-123 complete feature implementation"
git push --force-with-lease origin feat-PROJ-123
```

#### Error: Non-Linear History

```
✗ ERROR: Non-Linear History
Branch contains 2 merge commit(s). Use rebase instead of merge.
```

**Fix:**
```bash
# Rebase to clean history
git fetch origin
git rebase origin/develop
git push --force-with-lease origin feat-PROJ-123
```

#### Error: Wrong Branch Origin

```
✗ ERROR: Git Flow Violation: Wrong Branch Origin
Branch 'feat-PROJ-123' created from 'main' instead of 'develop'.
```

**Fix:**
```bash
# Recreate from correct base
git checkout develop
git checkout -b feat-PROJ-123-fixed
git cherry-pick <commits-from-wrong-branch>
git branch -D feat-PROJ-123
git branch -m feat-PROJ-123-fixed feat-PROJ-123
```

---

## Logging and Debugging

### Log Files

**Location:** `.git/hooks-logs/`

**Files:**
- `hook-YYYY-MM-DD.log`: Daily hook execution log
- `install-YYYYMMDD-HHMMSS.log`: Installation log
- `uninstall-YYYYMMDD-HHMMSS.log`: Uninstallation log

**View logs:**
```bash
# Today's hook log
cat .git/hooks-logs/hook-$(date +%Y-%m-%d).log

# Latest 50 lines
tail -50 .git/hooks-logs/hook-$(date +%Y-%m-%d).log

# Search for errors
grep ERROR .git/hooks-logs/hook-$(date +%Y-%m-%d).log

# Installation log
ls -lt .git/hooks-logs/install-*.log | head -1 | xargs cat
```

### Debug Mode

Run hooks manually with debug output:

```bash
# Debug pre-commit
bash -x .githooks/pre-commit

# Debug pre-push (requires stdin)
echo "refs/heads/feat-PROJ-123 sha1 refs/heads/feat-PROJ-123 sha1" | bash -x .githooks/pre-push origin https://github.com/user/repo.git

# Debug post-checkout
bash -x .githooks/post-checkout prev_sha new_sha 1
```

### Log Levels

- **INFO**: Normal operations
- **WARNING**: Non-critical issues, bypasses used
- **ERROR**: Validation failures, blocking errors
- **DEBUG**: Detailed execution information
- **TRACE**: Stack traces (errors only)

### Example Log Entry

```
[2025-01-15 10:23:45] [INFO] [pre-commit] Hook execution started
[2025-01-15 10:23:45] [INFO] [pre-commit] Checking protected branch: feat-PROJ-123
[2025-01-15 10:23:45] [INFO] [pre-commit] Running custom commands
[2025-01-15 10:23:46] [INFO] [pre-commit] Success: ESLint (2s)
[2025-01-15 10:23:47] [INFO] [pre-commit] Pre-commit validation successful
```

---

## Uninstallation

### Run Uninstall Script

```bash
bash .githooks/uninstall-hooks.sh
```

**Confirmation prompt:**
```
Are you sure you want to uninstall? (yes/no): yes
```

**What gets removed:**
- ✅ `core.hooksPath` configuration
- ✅ `rebase.autosquash` configuration
- ✅ `fetch.prune` configuration
- ✅ All `hooks.*` configurations
- ✅ All `branch.*.base` configurations
- ✅ All `branch.*.createdfrom` tracking
- ✅ Bypass warning session markers

**What remains:**
- ✅ Hook files in `.githooks/` (not deleted)
- ✅ Archived logs in `.git/hooks-logs-archive/`

### Manual Uninstallation

```bash
# Remove hooks path
git config --unset core.hooksPath

# Remove configurations
git config --unset rebase.autosquash
git config --unset fetch.prune
git config --unset hooks.maxCommits
git config --unset hooks.autoAddAfterFix
git config --unset hooks.parallelExecution
git config --unset hooks.bypassWarningStyle

# Remove branch configs (for each branch)
git config --unset branch.feat-PROJ-123.base
git config --unset branch.feat-PROJ-123.createdfrom
```

### Reinstallation

```bash
# After uninstallation, to reinstall:
bash .githooks/install-hooks.sh
```

---

## Best Practices

### For Developers

1. **Always create branches from correct base:**
   - Features → from `develop`
   - Hotfixes → from `main`
   - Releases → from `develop`

2. **Keep commits focused and small:**
   - One logical change per commit
   - Squash WIP commits before PR
   - Stay within commit limits

3. **Write clear commit messages:**
   - Include JIRA ID
   - Describe what and why
   - Use conventional commit types

4. **Rebase instead of merge:**
   - Keep linear history
   - `git pull --rebase`
   - `git config pull.rebase true`

5. **Test before committing:**
   - Run tests locally
   - Ensure linting passes
   - Verify build succeeds

### For Teams

1. **Standardize JIRA project codes:**
   - Document valid project codes
   - Use consistent naming

2. **Configure commit limits appropriately:**
   - Small teams: 5-10 commits
   - Large teams: 3-5 commits
   - Adjust per project needs

3. **Use custom commands:**
   - Add project-specific checks
   - Enforce code style
   - Run critical tests

4. **Document bypass scenarios:**
   - Define when bypass is allowed
   - Require approval for bypasses
   - Audit bypass usage

5. **Share hook configuration:**
   - Commit `.githooks/` to repository
   - Document installation in README
   - Include in onboarding

### For Repository Administrators

1. **Set up branch protection rules:**
   - Require PR for main/develop
   - Require status checks
   - Require reviews

2. **Configure default branches:**
   - Set `develop` as default
   - Protect `main` and `develop`

3. **Monitor hook compliance:**
   - Review logs periodically
   - Track bypass usage
   - Address violations

4. **Update hooks regularly:**
   - Stay current with updates
   - Test changes in staging
   - Communicate updates to team

5. **Provide training:**
   - Git Flow overview
   - Hook functionality
   - Common error fixes
   - Bypass procedures

---

## Troubleshooting

### Hooks Not Running

**Symptom:** Commits succeed without validation

**Diagnosis:**
```bash
# Check hooks path
git config core.hooksPath
# Should output: .githooks

# Check hook permissions
ls -la .githooks/pre-commit
# Should show: -rwxr-xr-x (executable)
```

**Fix:**
```bash
# Reinstall hooks
bash .githooks/install-hooks.sh

# Manually set hooks path
git config core.hooksPath .githooks

# Make executable
chmod +x .githooks/*
```

### Custom Commands Failing

**Symptom:** `command not found` errors

**Diagnosis:**
```bash
# Check if command exists
which npx
which eslint

# Test command manually
npx eslint src/
```

**Fix:**
```bash
# Install missing dependencies
npm install

# Update commands.conf paths
# Change: npx eslint {staged}
# To: ./node_modules/.bin/eslint {staged}

# Or disable temporarily
# Set mandatory to false in commands.conf
```

### Permission Errors

**Symptom:** `Permission denied` when running hooks

**Diagnosis:**
```bash
# Check file permissions
ls -la .githooks/
```

**Fix:**
```bash
# Make all hooks executable
chmod +x .githooks/*
chmod +x .githooks/lib/*

# Verify
ls -la .githooks/ | grep -E "^-rwx"
```

### Slow Hook Execution

**Symptom:** Hooks take too long to execute

**Diagnosis:**
```bash
# Check logs for slow commands
grep "Success:" .git/hooks-logs/hook-$(date +%Y-%m-%d).log

# Look for high execution times
# Example: Success: TypeScript Check (145s)
```

**Fix:**
```bash
# Enable parallel execution
git config hooks.parallelExecution true

# Make slow checks optional (non-blocking)
# In commands.conf:
# pre-commit:3:false:120:npx tsc:TypeScript Check

# Move slow checks to pre-push
# Change: pre-commit → pre-push

# Increase timeouts if needed
# pre-commit:3:false:300:npm test:Tests
```

### Branch Base Configuration Issues

**Symptom:** "Wrong base branch" errors for correct branches

**Diagnosis:**
```bash
# Check configured base
git config branch.your-branch.base

# Check branch creation source
git config branch.your-branch.createdfrom
```

**Fix:**
```bash
# Set correct base
git config branch.feat-PROJ-123.base develop

# Run auto-fix
bash .githooks/install-hooks.sh
# (Installation script fixes misconfigured bases)

# Manual fix for all branches
for branch in $(git branch | sed 's/^[* ]*//'); do
  case "$branch" in
    feat-*|bugfix-*|fix-*) git config "branch.$branch.base" develop ;;
    hotfix-*) git config "branch.$branch.base" main ;;
    release-*) git config "branch.$branch.base" develop ;;
  esac
done
```

### Bypass Not Working

**Symptom:** Bypass variables ignored

**Diagnosis:**
```bash
# Check if variable is set
echo $BYPASS_HOOKS
echo $ALLOW_DIRECT_PROTECTED
```

**Fix:**
```bash
# Ensure variable is exported (for scripts)
export BYPASS_HOOKS=1

# Or use inline (recommended)
BYPASS_HOOKS=1 git commit -m "message"

# Verify it's working (should see warning)
BYPASS_HOOKS=1 git status
# Should show bypass warning
```

### Merge Conflicts in Hooks

**Symptom:** After pulling, hooks are broken

**Diagnosis:**
```bash
# Check for conflict markers
grep -r "<<<<<<< HEAD" .githooks/
```

**Fix:**
```bash
# Resolve conflicts
vim .githooks/pre-commit
# (Remove conflict markers)

# Or restore from remote
git checkout origin/develop -- .githooks/

# Reinstall
bash .githooks/install-hooks.sh
```

### Lockfile Validation False Positives

**Symptom:** Lockfile checks fail incorrectly

**Diagnosis:**
```bash
# Check lockfile integrity manually
npm ci --dry-run
yarn check --integrity
```

**Fix:**
```bash
# Regenerate lockfile
rm package-lock.json
npm install

# Or disable check temporarily
# Comment out in commands.conf:
# #pre-commit:2:false:30:...lockfile validation...:Validate Lockfile
```

### Git Version Issues

**Symptom:** Hooks fail on older Git versions

**Diagnosis:**
```bash
# Check Git version
git --version
# Should be 2.9 or higher
```

**Fix:**
```bash
# Update Git
# macOS:
brew upgrade git

# Ubuntu/Debian:
sudo apt update && sudo apt upgrade git

# Windows:
# Download from https://git-scm.com/
```

---

## License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.

See [LICENSE](LICENSE) file for full license text.

**Key Points:**
- ✅ Free to use, modify, and distribute
- ✅ Must disclose source code for modifications
- ✅ Must use same license for derivatives
- ✅ Network use triggers source disclosure requirements

---

## Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
2. **Create feature branch:** `git checkout -b feat-CONTRIB-001-your-feature`
3. **Make changes** and test thoroughly
4. **Commit:** `git commit -m "feat: CONTRIB-001 Add your feature"`
5. **Push:** `git push origin feat-CONTRIB-001-your-feature`
6. **Create Pull Request** to `develop` branch

### Development Setup

```bash
# Clone repository
git clone https://github.com/yourusername/git-flow-hooks.git
cd git-flow-hooks

# Create develop branch if not exists
git checkout -b develop main

# Install hooks for testing
bash .githooks/install-hooks.sh

# Test changes
bash -x .githooks/pre-commit
bash -x .githooks/pre-push
```

---

## Support

### Documentation

- **Git Flow Model:** https://nvie.com/posts/a-successful-git-branching-model/
- **Semantic Versioning:** https://semver.org/
- **Conventional Commits:** https://www.conventionalcommits.org/

### Issues

Report issues at: `https://github.com/yourusername/git-flow-hooks/issues`

### Questions

For questions and discussions: `https://github.com/yourusername/git-flow-hooks/discussions`

---

## Acknowledgments

- **Git Flow Model** by [Vincent Driessen](https://nvie.com/)
- **Enterprise Development Team** for hook implementation
- All contributors to this project

---

**Made with ❤️ for teams who care about code quality and workflow consistency.**
