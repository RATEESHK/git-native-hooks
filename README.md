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
- [Initial Repository Setup & First-Time Configuration](#initial-repository-setup--first-time-configuration)
  - [Scenario 1: Brand New Local Repository (git init)](#scenario-1-brand-new-local-repository-git-init)
  - [Scenario 2: Repository Created on Remote (Clone & Setup)](#scenario-2-repository-created-on-remote-clone--setup)
  - [Scenario 3: Existing Repository with Only Main (Migration)](#scenario-3-existing-repository-with-only-main-migration)
  - [Using This Repository as a Template](#using-this-repository-as-a-template)
  - [Common Setup Issues & Solutions](#common-setup-issues--solutions)
- [Detailed Usage Guide](#detailed-usage-guide)
  - [Daily Developer Workflow](#daily-developer-workflow)
  - [Real-World Scenarios](#real-world-scenarios)
  - [Command Reference](#command-reference)
  - [Troubleshooting Guide](#troubleshooting-guide)
- [Understanding Git Flow](#understanding-git-flow)
  - [What is Git Flow?](#what-is-git-flow)
  - [The Branching Model](#the-branching-model)
  - [Main Branches](#main-branches)
  - [Supporting Branches](#supporting-branches)
- [Git Flow Workflows](#git-flow-workflows)
  - [Complete Feature Development Workflow](#complete-feature-development-workflow)
  - [Complete Release Workflow](#complete-release-workflow)
  - [Complete Hotfix Workflow](#complete-hotfix-workflow)
- [Version Tagging Strategy](#version-tagging-strategy)
  - [Semantic Versioning](#semantic-versioning)
  - [Creating Tags](#creating-tags)
  - [Version Bump Strategies](#version-bump-strategies)
- [Git Flow Automation](#git-flow-automation)
  - [Using git-flow CLI Tool](#using-git-flow-cli-tool)
  - [Integration with This Hook System](#integration-with-this-hook-system)
  - [GitHub Actions Automation](#github-actions-automation)
    - [Complete Automation Setup](#complete-automation-setup)
    - [Setup Instructions](#setup-instructions)
    - [What Gets Automated](#what-gets-automated)
    - [Customization Options](#customization-options)
  - [GitLab CI Automation](#gitlab-ci-automation)
- [Server-Side Git Flow Enforcement with Harness CI/CD](#server-side-git-flow-enforcement-with-harness-cicd)
  - [Why Server-Side Enforcement with Harness?](#why-server-side-enforcement-with-harness)
  - [Harness Git Flow Architecture](#harness-git-flow-architecture)
  - [Harness Setup - Complete Guide](#harness-setup---complete-guide)
  - [Harness Pipeline Templates for Git Flow](#harness-pipeline-templates-for-git-flow)
  - [Harness Git Flow Automation Pipelines](#harness-git-flow-automation-pipelines)
  - [Harness Trigger Configurations](#harness-trigger-configurations)
  - [Input Sets for Environments](#input-sets-for-environments)
  - [Server-Side Git Flow Enforcement Strategies](#server-side-git-flow-enforcement-strategies)
  - [Complete Integration: Client + Server Hooks](#complete-integration-client--server-hooks)
  - [Webhook Configuration](#webhook-configuration)
  - [Harness Best Practices for Git Flow](#harness-best-practices-for-git-flow)
  - [Troubleshooting Guide](#troubleshooting-guide)
- [Git Flow Best Practices](#git-flow-best-practices)
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

## Initial Repository Setup & First-Time Configuration

This section covers how to set up Git Flow in different scenarios: brand new repositories, remote repositories, and existing repositories. If you're starting fresh or migrating an existing project, follow the appropriate scenario below.

### Why This Section Matters

The hooks in this repository **require Git Flow structure** to function properly:
- A `main` branch (production-ready code)
- A `develop` branch (integration branch for features)
- Proper branch creation from correct bases
- Initial version tags

Without this setup, hooks will block operations and show errors. This section ensures you start correctly.

---

### Scenario 1: Brand New Local Repository (git init)

**Use this when**: You're creating a completely new project from scratch on your local machine.

#### Step 1: Initialize Git Repository

```bash
# Create project directory
mkdir my-awesome-project
cd my-awesome-project

# Initialize Git
git init

# Verify Git initialization
git status
# Output: On branch main (or master)
```

**Note**: If your default branch is `master`, rename it to `main`:
```bash
git branch -m master main
git config init.defaultBranch main  # For future repos
```

#### Step 2: Create Initial Commit

```bash
# Create README or initial files
echo "# My Awesome Project" > README.md
echo "node_modules/" > .gitignore

# Stage files
git add .

# Make initial commit
git commit -m "chore: INIT-001 initial commit"
```

**Why this commit message format?**
- Even initial commits follow conventions
- `INIT-001` is a placeholder JIRA ID (replace with your actual ticket if you have one)
- Hooks aren't installed yet, so this won't fail validation

#### Step 3: Create and Tag Main Branch

```bash
# Ensure you're on main
git branch
# Output: * main

# Create initial version tag
git tag -a v0.1.0 -m "Initial release v0.1.0

This is the first version of the project.
Contains:
- Initial project structure
- README documentation
- Basic .gitignore
"

# Verify tag
git tag
# Output: v0.1.0

git show v0.1.0
# Shows tag details and initial commit
```

**Version Strategy**:
- `v0.1.0` = Pre-release, initial development
- `v1.0.0` = First production-ready release
- Choose based on your project's maturity

#### Step 4: Create Develop Branch

```bash
# Create develop branch from main
git checkout -b develop main

# Verify you're on develop
git branch
# Output:
#   main
# * develop

# Push both branches to establish remote tracking (do this after adding remote in Step 5)
```

#### Step 5: Add Remote and Push

```bash
# Create repository on GitHub/GitLab/Bitbucket first
# Then add remote (replace with your actual URL)
git remote add origin https://github.com/your-username/my-awesome-project.git

# Verify remote
git remote -v
# Output:
# origin  https://github.com/your-username/my-awesome-project.git (fetch)
# origin  https://github.com/your-username/my-awesome-project.git (push)

# Push main branch with tags
git checkout main
git push -u origin main
git push origin --tags

# Push develop branch
git checkout develop
git push -u origin develop
```

#### Step 6: Install Git Hooks

```bash
# Clone git-native-hooks into your repository
git clone https://github.com/RATEESHK/git-native-hooks.git .githooks

# Remove the .git directory from .githooks (it's not needed)
rm -rf .githooks/.git

# Run installation script
./.githooks/install-hooks.sh

# Output will show:
# ✓ Hooks path set to: .githooks
# ✓ Made executable: pre-commit
# ✓ Made executable: commit-msg
# ... etc
```

#### Step 7: Commit Hook Installation

```bash
# You're on develop branch
git add .githooks
git commit -m "chore: INIT-002 add Git Flow enforcement hooks"
git push origin develop
```

#### Step 8: Create Your First Feature Branch

```bash
# Ensure develop is up to date
git checkout develop
git pull origin develop

# Create feature branch (replace PROJ-123 with your JIRA ticket)
git checkout -b feat-PROJ-123-setup-project-structure develop

# Verify base branch is set (done automatically by post-checkout hook)
git config branch.feat-PROJ-123-setup-project-structure.base
# Output: develop

# Make changes
mkdir -p src tests docs
echo "// Main application entry point" > src/index.js
echo "// Test file" > tests/index.test.js

# Stage and commit (hooks now active!)
git add .
git commit -m "feat: PROJ-123 add basic project structure"

# Commit message was auto-populated with "feat: PROJ-123 "
# Hooks validated branch name and commit message

# Push to remote
git push -u origin feat-PROJ-123-setup-project-structure
```

#### Step 9: Verify Everything Works

```bash
# Test branch naming validation (should fail)
git checkout develop
git checkout -b invalid-branch-name develop
# Output: Error from post-checkout hook about invalid branch name

# Delete bad branch
git checkout develop
git branch -D invalid-branch-name

# Test commit message validation (should fail)
echo "test" > test.txt
git add test.txt
git commit -m "bad commit message"
# Output: Error from commit-msg hook about invalid format

# Undo bad commit
git reset --soft HEAD~1
git restore --staged test.txt
rm test.txt
```

#### Step 10: Create Your First Release (Experience Git Flow)

Now that hooks are installed and working, let's walk through creating your first proper release to experience the complete Git Flow cycle.

**Why this step matters**: This gives you hands-on experience with the full Git Flow release process before your first real feature.

```bash
# 1. Add a few features to develop
git checkout develop
git pull origin develop

# Create a simple feature
git checkout -b feat-PROJ-200-add-version-file develop
echo "VERSION=0.1.0" > VERSION
git add VERSION
git commit -m "feat: PROJ-200 add version tracking file"
git push -u origin feat-PROJ-200-add-version-file

# Simulate PR merge (in real workflow, merge via PR)
git checkout develop
git merge --no-ff feat-PROJ-200-add-version-file -m "Merge feat-PROJ-200-add-version-file into develop"
git push origin develop
git branch -d feat-PROJ-200-add-version-file
git push origin --delete feat-PROJ-200-add-version-file

# 2. Start release process from develop
git checkout develop
git pull origin develop
git checkout -b release-0.2.0 develop

# post-checkout hook validates release branch naming ✓
# Base branch set to develop ✓

# 3. Bump version in release branch
echo "VERSION=0.2.0" > VERSION
git add VERSION
git commit -m "chore: REL-020 bump version to 0.2.0"

# Create CHANGELOG for this release
cat > CHANGELOG.md <<EOF
# Changelog

## [0.2.0] - $(date +%Y-%m-%d)

### Added
- PROJ-200: Version tracking file
- PROJ-123: Basic project structure
- PROJ-002: Git Flow enforcement hooks

### Changed
- Initial setup completed
- Git Flow workflow established

EOF

git add CHANGELOG.md
git commit -m "docs: REL-020 add changelog for v0.2.0"

# 4. Push release branch for team review/QA
git push -u origin release-0.2.0

# In real workflow: QA tests this branch
# If bugs found: fix them on release branch with commits
# For now, we'll proceed assuming QA passed

# 5. Merge release to main (production)
git checkout main
git pull origin main
git merge --no-ff release-0.2.0 -m "Merge release-0.2.0 to main

First proper release using Git Flow:
- Added version tracking
- Established project structure
- Implemented Git Flow hooks
"

# 6. Tag the release on main
git tag -a v0.2.0 -m "Release version 0.2.0

First Git Flow release after initial setup.

Features:
- Version tracking system
- Project structure (src, tests, docs)
- Git Flow enforcement hooks installed

This release demonstrates the complete Git Flow process.
"

# 7. Push main and tags
git push origin main
git push origin v0.2.0

# 8. Merge release back to develop (critical step!)
git checkout develop
git pull origin develop
git merge --no-ff release-0.2.0 -m "Merge release-0.2.0 back into develop

Integrating release changes:
- Version bump to 0.2.0
- CHANGELOG updates
"

# 9. Push updated develop
git push origin develop

# 10. Delete release branch (no longer needed)
git branch -d release-0.2.0
git push origin --delete release-0.2.0

# 11. Verify release
git log --oneline --graph --all --decorate | head -20
# Shows merge commits and v0.2.0 tag

git tag
# Output:
# v0.1.0
# v0.2.0

# 12. Check branch status
git checkout develop
git log --oneline -3
# Shows release merge commit

git checkout main
git log --oneline -3
# Shows release merge commit and tag
```

**What You Just Learned**:
- ✅ Creating release branch from develop
- ✅ Version bumping and changelog generation
- ✅ Merging release to main (production)
- ✅ Tagging releases with semantic versions
- ✅ Merging release back to develop (no history loss!)
- ✅ Cleaning up release branches
- ✅ Complete Git Flow release cycle

**Next releases** will follow the same pattern:
1. Develop features on `feat-*` branches
2. Merge features to `develop`
3. Create `release-X.Y.Z` from `develop`
4. Test, fix bugs, bump version
5. Merge to `main`, tag, merge back to `develop`
6. Delete release branch

#### Summary: You Now Have

✅ `main` branch with initial commit and tag (`v0.1.0`)
✅ `develop` branch for integration
✅ Both branches pushed to remote with tracking
✅ Git hooks installed and working
✅ First feature branch created successfully
✅ Validated that hooks catch violations
✅ **Completed first Git Flow release (v0.2.0)**
✅ **Experienced complete release cycle hands-on**
✅ **Both main and develop in sync with no history loss**

---

### Scenario 2: Repository Created on Remote (Clone & Setup)

**Use this when**: Your team created a repository on GitHub/GitLab/Bitbucket, and you're setting up locally.

#### Step 1: Clone Repository

```bash
# Clone from remote (replace with your actual URL)
git clone https://github.com/your-org/existing-project.git
cd existing-project

# Check existing branches
git branch -a
# Output:
# * main
#   remotes/origin/HEAD -> origin/main
#   remotes/origin/main
```

**Common State**: Repository only has `main` branch, possibly with some commits but no tags.

#### Step 2: Check for Existing Tags

```bash
# List all tags
git tag

# If empty output, proceed to create initial tag
# If tags exist, check latest version:
git describe --tags --abbrev=0
# Output: v1.2.3 (or empty if no tags)
```

#### Step 3A: If No Tags Exist - Create Initial Tag

```bash
# Ensure you're on main
git checkout main

# Check git log to see what's already committed
git log --oneline
# Output shows existing commits

# Tag the latest commit on main as your starting version
# Choose version based on project state:
# - v0.1.0 = Early development
# - v1.0.0 = If already in production

git tag -a v0.1.0 -m "Initial baseline version v0.1.0

Tagging current state of main branch as baseline
for Git Flow implementation.

Existing features:
- (list what's already in the codebase)
"

# Push tag to remote
git push origin v0.1.0
```

#### Step 3B: If Tags Exist - Note Latest Version

```bash
# If repository already has tags, note the latest
LATEST_TAG=$(git describe --tags --abbrev=0)
echo "Latest version: $LATEST_TAG"

# You're ready to proceed - no new tag needed yet
# Next release will increment from here
```

#### Step 4: Create Develop Branch

```bash
# Check if develop already exists remotely
git branch -a | grep develop

# If develop doesn't exist:
git checkout main
git checkout -b develop main

# Push develop to remote
git push -u origin develop

# Set develop as the default branch on remote (optional but recommended):
# GitHub: Settings → Branches → Default branch → Change to 'develop'
# GitLab: Settings → Repository → Default branch → Select 'develop'
# Bitbucket: Repository settings → Branch management → Main branch → Select 'develop'
```

**Why create develop from main?**
- Develop starts from the same point as main
- All future features branch from develop
- Main only receives merges from release and hotfix branches

#### Step 5: Install Git Hooks

```bash
# Ensure you're on develop
git checkout develop

# Clone hooks into repository
git clone https://github.com/RATEESHK/git-native-hooks.git .githooks

# Remove unnecessary .git folder
rm -rf .githooks/.git

# Install hooks
./.githooks/install-hooks.sh

# Commit hooks to develop
git add .githooks
git commit -m "chore: SETUP-001 add Git Flow enforcement hooks"
git push origin develop
```

#### Step 6: Configure Branch Protection (Recommended)

Set up branch protection on your Git hosting platform:

**GitHub:**
```
Repository → Settings → Branches → Add rule

Branch name pattern: main
☑ Require pull request reviews before merging
☑ Require status checks to pass before merging
☑ Include administrators
☐ Allow force pushes

Branch name pattern: develop
☑ Require pull request reviews before merging
☑ Require status checks to pass before merging
```

**GitLab:**
```
Project → Settings → Repository → Protected Branches

Branch: main
Allowed to merge: Maintainers
Allowed to push: No one
Allowed to force push: ☐

Branch: develop
Allowed to merge: Developers + Maintainers
Allowed to push: No one
```

**Bitbucket:**
```
Repository settings → Branch permissions

Branch: main
Type: No direct writes
Approvers: 2 required

Branch: develop
Type: No direct writes
Approvers: 1 required
```

#### Step 7: Create First Feature Branch

```bash
# Checkout develop
git checkout develop
git pull origin develop

# Create feature branch (use your actual JIRA ID)
git checkout -b feat-PROJ-123-add-authentication develop

# Post-checkout hook automatically sets base branch
git config branch.feat-PROJ-123-add-authentication.base
# Output: develop

# Make changes
touch src/auth.js
git add src/auth.js
git commit -m "feat: PROJ-123 add authentication module"

# Push to remote
git push -u origin feat-PROJ-123-add-authentication

# Create Pull Request to develop
# GitHub: Click "Compare & pull request"
# Target branch: develop
# Request reviewers
```

#### Step 8: Verify Hooks Are Working

```bash
# Test 1: Try to commit to main (should fail)
git checkout main
echo "test" > test.txt
git add test.txt
git commit -m "test: TEST-001 this should fail"
# Output: ✗ ERROR: Cannot commit directly to protected branch 'main'

# Cleanup
git restore --staged test.txt
rm test.txt

# Test 2: Try invalid branch name (should fail)
git checkout develop
git checkout -b badbranchname develop
# Output: Error about invalid branch naming

# Cleanup
git checkout develop
git branch -D badbranchname

# Test 3: Valid branch and commit (should succeed)
git checkout -b feat-PROJ-124-test-feature develop
echo "# Test" > feature.md
git add feature.md
git commit -m "feat: PROJ-124 add test feature"
# Output: ✓ SUCCESS: All pre-commit validations passed

# Test 4: Release branch with flexible commit messages (should succeed)
git checkout develop
git checkout -b release-1.0.0 develop
echo "1.0.0" > VERSION
git add VERSION

# Test 4a: Commit WITHOUT JIRA ID (should succeed on release branches)
git commit -m "Bump version to 1.0.0"
# Output: ✓ SUCCESS: Commit message valid (release branch - JIRA optional)

# Test 4b: Commit with type but no JIRA (should succeed)
echo "## Release 1.0.0" > CHANGELOG.md
git add CHANGELOG.md
git commit -m "chore: update changelog for 1.0.0"
# Output: ✓ SUCCESS: Commit message valid (release branch - JIRA optional)

# Test 4c: Commit with JIRA (also valid on release branches)
echo "Final changes" >> CHANGELOG.md
git add CHANGELOG.md
git commit -m "docs: PROJ-125 finalize release notes"
# Output: ✓ SUCCESS: Commit message valid (release branch - JIRA optional)

# Test 4d: Simple message format (should succeed)
echo "Ready" > RELEASE
git add RELEASE
git commit -m "Prepare release 1.0.0"
# Output: ✓ SUCCESS: Commit message valid (release branch - JIRA optional)

# Cleanup
git checkout develop
git branch -D feat-PROJ-124-test-feature
```

#### Step 9: Create First Release (Complete Git Flow Experience)

Now let's create your first release to complete the Git Flow learning experience:

```bash
# 1. Merge the test feature to develop (simulate completed feature)
git checkout develop
git merge --no-ff feat-PROJ-123-add-authentication -m "Merge feat-PROJ-123-add-authentication into develop"
git push origin develop

# Delete feature branch
git branch -d feat-PROJ-123-add-authentication
git push origin --delete feat-PROJ-123-add-authentication

# 2. Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release-1.0.0 develop

# 3. Update version (assuming you have package.json or similar)
# If starting fresh, create a version file
echo '{"version": "1.0.0"}' > package.json
git add package.json
git commit -m "chore: REL-100 bump version to 1.0.0"

# 4. Create or update CHANGELOG
cat > CHANGELOG.md <<EOF
# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - $(date +%Y-%m-%d)

### Added
- PROJ-123: Authentication module
- Git Flow enforcement hooks
- Initial project setup

### Infrastructure
- CI/CD pipeline configuration
- Branch protection rules
- Development workflow established

EOF

git add CHANGELOG.md
git commit -m "docs: REL-100 add changelog for v1.0.0"

# 5. Push release branch
git push -u origin release-1.0.0

# 6. After QA approval, merge to main
git checkout main
git pull origin main
git merge --no-ff release-1.0.0 -m "Merge release-1.0.0 to main

First production release with Git Flow process:
- Authentication system
- Git Flow hooks enforcement
- Complete project structure
"

# 7. Tag the release
git tag -a v1.0.0 -m "Release version 1.0.0

First production-ready release.

Features:
- Authentication module
- Git Flow workflow enforcement
- Development infrastructure

Marks the completion of initial setup and first feature cycle.
"

# 8. Push main and tags
git push origin main
git push origin v1.0.0

# 9. Merge back to develop (keep develop in sync!)
git checkout develop
git pull origin develop
git merge --no-ff release-1.0.0 -m "Merge release-1.0.0 back into develop"
git push origin develop

# 10. Clean up release branch
git branch -d release-1.0.0
git push origin --delete release-1.0.0

# 11. Verify your work
echo "✅ Release v1.0.0 complete!"
git log --oneline --graph --all --decorate -10
```

**Congratulations!** You've completed your first full Git Flow release cycle.

#### Summary: You Now Have

✅ Repository cloned from remote
✅ `main` branch tagged with initial/current version
✅ `develop` branch created and pushed
✅ Branch protection configured (recommended)
✅ Git hooks installed and enforcing rules
✅ Ready to create feature branches
✅ **Completed first Git Flow release (v1.0.0)**
✅ **Full understanding of release process**

---

### Scenario 3: Existing Repository with Only Main (Migration)

**Use this when**: You have an existing project with only a `main`/`master` branch and want to adopt Git Flow.

#### Step 1: Assess Current State

```bash
# Check current branch
git branch
# Output: * main (or * master)

# Check for remote
git remote -v
# Output shows remote URL if configured

# Check existing commits
git log --oneline | head -10
# Shows recent commit history

# Check for existing tags
git tag
# May show existing version tags or be empty
```

#### Step 2: Create Baseline Tag (If None Exists)

```bash
# If no tags exist, create one for current state
git checkout main

# Determine appropriate version:
# - If already in production: v1.0.0 or current version
# - If pre-production: v0.5.0 or v0.9.0
# - If early stage: v0.1.0

git tag -a v1.0.0 -m "Baseline version v1.0.0

Tagged current main branch as baseline before
implementing Git Flow workflow.

Current state:
- Production-ready codebase
- (list major features present)
"

# If remote exists, push tag
git push origin v1.0.0
```

#### Step 3: Create Develop Branch from Main

```bash
# Create develop from current main
git checkout -b develop main

# Verify develop is at same commit as main
git log --oneline main..develop
# Output should be empty (no commits difference)

git log --oneline develop..main
# Output should be empty (both at same point)

# Push develop to remote
git push -u origin develop
```

#### Step 4: Update Default Branch (Recommended)

**Why?** Developers should work from `develop`, not `main`.

**GitHub**:
```
Settings → Branches → Default branch → Change to 'develop' → Update

This changes what branch is shown by default and what new clones check out.
```

**GitLab**:
```
Settings → Repository → Default branch → Select 'develop' → Save changes
```

**Bitbucket**:
```
Repository settings → Branch management → Main branch → Select 'develop'
```

#### Step 5: Protect Main and Develop

See Step 6 in Scenario 2 for branch protection configuration.

#### Step 6: Install Git Hooks

```bash
# Switch to develop
git checkout develop

# Clone hooks
git clone https://github.com/RATEESHK/git-native-hooks.git .githooks
rm -rf .githooks/.git

# Install
./.githooks/install-hooks.sh

# Commit hooks
git add .githooks
git commit -m "chore: MIGRATE-001 add Git Flow enforcement hooks

Implementing Git Flow workflow with automated enforcement.
All future feature development will branch from develop.
"

# Push to develop
git push origin develop
```

#### Step 7: Communicate to Team

**Send team notification** (example):

```
📢 Important: We're adopting Git Flow! 🎉

Changes effective immediately:
1. ✅ Default branch is now 'develop' (not main)
2. ✅ All feature branches must be created from 'develop'
3. ✅ Branch naming required: feat-JIRA-123-description
4. ✅ Commit format required: feat: JIRA-123 description
5. ✅ Direct commits to main/develop are blocked

How to update your local repo:
$ git fetch origin
$ git checkout develop
$ git pull origin develop
$ ./.githooks/install-hooks.sh  # Install hooks locally

Creating features:
$ git checkout develop
$ git checkout -b feat-PROJ-123-your-feature develop
$ git commit -m "feat: PROJ-123 your description"
$ git push -u origin feat-PROJ-123-your-feature
# Then create PR to develop (not main!)

Questions? See README.md or ask in #engineering-help

Happy Git Flowing! 🚀
```

#### Step 8: Migrate In-Progress Work

**If teammates have open branches from main:**

```bash
# Developer with feature branch from old main:
git fetch origin

# Check branch base
git merge-base feature-branch origin/main
# Shows commit hash where branch was created

# Check if that commit is in develop
git branch --contains <commit-hash>
# If develop is listed, branch is safe to use

# If branch was created before develop existed:
# Option 1: Rebase onto develop
git checkout feature-branch
git rebase origin/develop

# Option 2: Merge develop into feature (not ideal but works)
git checkout feature-branch
git merge origin/develop

# Option 3: Cherry-pick commits onto new branch (cleanest)
git checkout -b feat-PROJ-123-description develop
git cherry-pick <commit1> <commit2> <commit3>
git push -u origin feat-PROJ-123-description
# Delete old branch after verification
```

#### Step 9: First Release After Migration

When ready for next production release:

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release-1.1.0 develop

# Update version numbers in code
# Edit package.json, version.py, etc.
# Bump from v1.0.0 to v1.1.0

git add package.json
git commit -m "chore: REL-110 bump version to 1.1.0"

# Push release branch
git push -u origin release-1.1.0

# After testing and approval, merge to main
git checkout main
git pull origin main
git merge --no-ff release-1.1.0 -m "Merge release-1.1.0"
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin main
git push origin v1.1.0

# Merge back to develop
git checkout develop
git pull origin develop
git merge --no-ff release-1.1.0 -m "Merge release-1.1.0 into develop"
git push origin develop

# Delete release branch
git branch -d release-1.1.0
git push origin --delete release-1.1.0
```

#### Summary: You Successfully Migrated

✅ Baseline tag created for existing code
✅ `develop` branch created from `main`
✅ Default branch changed to `develop`
✅ Branch protection enabled
✅ Git hooks installed and enforcing
✅ Team notified and guided
✅ In-progress work migrated
✅ Ready for first Git Flow release

---

### Using This Repository as a Template

Want to use git-native-hooks as a starting point for multiple projects? Here's how to set it up as a template and use it.

#### Option 1: GitHub Template Repository

**Setup (One-Time)**:

1. **Fork or Import** this repository to your organization:
   ```
   GitHub → Import repository
   URL: https://github.com/RATEESHK/git-native-hooks
   Owner: your-org
   Name: git-flow-template
   ```

2. **Enable as Template**:
   ```
   Repository → Settings → Scroll down to "Template repository"
   ☑ Template repository
   ```

3. **Customize Template** (optional):
   ```bash
   # Clone your template
   git clone https://github.com/your-org/git-flow-template.git
   cd git-flow-template
   
   # Remove this README or replace with your own
   rm README.md
   echo "# Project Template with Git Flow" > README.md
   
   # Add organization-specific configs
   mkdir -p .github/PULL_REQUEST_TEMPLATE
   echo "## Changes\n\n## Testing\n\n## Checklist\n- [ ] Tests pass" > .github/PULL_REQUEST_TEMPLATE/pull_request_template.md
   
   # Add organization CI/CD configs
   mkdir -p .github/workflows
   # Add your CI/CD pipeline files
   
   # Customize commands.conf for your tech stack
   # Edit .githooks/commands.conf
   
   # Commit and push
   git add .
   git commit -m "chore: customize template for organization"
   git push origin main
   ```

**Using the Template**:

When creating a new project:

```
GitHub → New repository
Select: "Repository template" → your-org/git-flow-template
Owner: your-org
Repository name: new-awesome-project
Description: My new project
☑ Private (or Public)
Click: "Create repository"
```

**Then clone and set up**:

```bash
# Clone new repository
git clone https://github.com/your-org/new-awesome-project.git
cd new-awesome-project

# Repository already has:
# ✅ .githooks/ directory
# ✅ Git Flow structure

# Install hooks
./.githooks/install-hooks.sh

# Create develop branch (template only has main)
git checkout -b develop main
git push -u origin develop

# Tag initial version
git checkout main
git tag -a v0.1.0 -m "Initial version"
git push origin v0.1.0

# Start working
git checkout develop
git checkout -b feat-PROJ-001-initialize-project develop
```

#### Option 2: Script-Based Template

**Create a setup script** in your template repo:

```bash
# File: setup-new-project.sh
#!/bin/bash

set -euo pipefail

PROJECT_NAME="${1:-}"
JIRA_PREFIX="${2:-PROJ}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: ./setup-new-project.sh <project-name> [JIRA-PREFIX]"
    echo "Example: ./setup-new-project.sh my-api MYAPI"
    exit 1
fi

echo "Setting up new project: $PROJECT_NAME"
echo "JIRA prefix: $JIRA_PREFIX"

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize Git
git init
git branch -m main

# Copy hooks
cp -r ../git-flow-template/.githooks .
rm -rf .githooks/.git

# Create initial files
cat > README.md <<EOF
# $PROJECT_NAME

## Description
[Add project description]

## Setup
\`\`\`bash
npm install  # or your package manager
\`\`\`

## Development
\`\`\`bash
git checkout develop
git checkout -b feat-${JIRA_PREFIX}-XXX-description develop
\`\`\`
EOF

cat > .gitignore <<EOF
node_modules/
.env
.DS_Store
*.log
.vscode/
EOF

# Initial commit
git add .
git commit -m "chore: INIT-001 initial project setup"

# Create tag
git tag -a v0.1.0 -m "Initial version v0.1.0"

# Create develop
git checkout -b develop main

# Install hooks
./.githooks/install-hooks.sh

echo ""
echo "✅ Project $PROJECT_NAME initialized!"
echo ""
echo "Next steps:"
echo "  1. Create remote repository on GitHub/GitLab"
echo "  2. git remote add origin <URL>"
echo "  3. git push -u origin main"
echo "  4. git push origin --tags"
echo "  5. git push -u origin develop"
echo ""
```

**Usage**:

```bash
# Create git-flow-template repository
mkdir git-flow-template
cd git-flow-template
git init
# Copy .githooks from this repo
# Add setup-new-project.sh
git add .
git commit -m "Template ready"

# Use it to create new projects
cd ..
./git-flow-template/setup-new-project.sh my-new-api MYAPI
cd my-new-api
# Follow printed instructions
```

#### Option 3: Manual Copy (Simplest)

For one-off project setup:

```bash
# In your new project
cd my-new-project
git init

# Copy hooks from this repository
cp -r /path/to/git-native-hooks/.githooks .
rm -rf .githooks/.git

# Install
./.githooks/install-hooks.sh

# Set up Git Flow structure (follow Scenario 1)
```

#### Customization Checklist

After using template, customize for your project:

- [ ] **Update README.md**
  - Replace generic content with project-specific info
  - Add setup instructions
  - Add contribution guidelines

- [ ] **Configure commands.conf**
  - Uncomment language-specific linters
  - Add project-specific commands
  - Set appropriate timeouts
  - Enable/disable optional checks

- [ ] **Update JIRA Prefix**
  - Default patterns use `PROJ-123`
  - Update if your JIRA uses different format
  - Modify patterns in `.githooks/lib/common.sh` if needed

- [ ] **Set Up CI/CD**
  - Add GitHub Actions / GitLab CI / Jenkins configs
  - Configure branch protection
  - Set up required status checks

- [ ] **Configure Git Remote**
  - Add origin: `git remote add origin <URL>`
  - Push main: `git push -u origin main`
  - Push develop: `git push -u origin develop`
  - Push tags: `git push origin --tags`

- [ ] **Team Onboarding**
  - Share repository with team
  - Add contributors
  - Provide setup instructions
  - Schedule Git Flow training session

---

### Common Setup Issues & Solutions

#### Issue 1: "Not in a git repository"

**Symptom**:
```bash
./.githooks/install-hooks.sh
Error: Not in a git repository
```

**Solution**:
```bash
# Initialize Git first
git init

# Or verify you're in the right directory
pwd
ls -la .git
```

#### Issue 2: "Hook not executable"

**Symptom**:
```bash
git commit
error: cannot run .git/hooks/pre-commit: Permission denied
```

**Solution**:
```bash
# Make hooks executable
chmod +x .githooks/*
chmod +x .githooks/lib/*

# Or run install script again
./.githooks/install-hooks.sh
```

#### Issue 3: "develop branch doesn't exist"

**Symptom**:
```bash
git checkout develop
error: pathspec 'develop' did not match any file(s) known to git
```

**Solution**:
```bash
# Create develop from main
git checkout main
git checkout -b develop main

# Push to remote
git push -u origin develop
```

#### Issue 4: "Base branch not configured"

**Symptom**:
```bash
git push
Error: Branch does not have a configured base branch
```

**Solution**:
```bash
# Set base branch manually
git config branch.feat-PROJ-123-feature.base develop

# Or recreate branch properly
git checkout develop
git checkout -b feat-PROJ-123-feature develop
# Base is set automatically by post-checkout hook
```

#### Issue 5: "Permission denied (publickey)" when pushing

**Symptom**:
```bash
git push origin main
Permission denied (publickey).
```

**Solution**:
```bash
# Check SSH keys
ssh -T git@github.com

# Or switch to HTTPS
git remote set-url origin https://github.com/user/repo.git

# Or generate and add SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
# Add to GitHub/GitLab: Settings → SSH Keys
```

#### Issue 6: "hooks.maxCommits exceeded"

**Symptom**:
```bash
git push
Error: Branch has 8 commits (limit: 5). Squash commits before pushing.
```

**Quick Solution**:
```bash
# Option 1: Soft reset (simplest - recommended)
git reset --soft develop
git commit -m "feat: PROJ-123 complete feature description"
git push --force-with-lease origin feat-PROJ-123

# Option 2: Interactive rebase (more control)
git rebase -i develop
# Mark commits as 'squash' or 'fixup', save
git push --force-with-lease origin feat-PROJ-123

# Option 3: Increase limit temporarily (last resort)
git config hooks.maxCommits 10
```

**For Complete Guide** including:
- Detailed step-by-step instructions
- Visual examples of before/after
- How history is preserved
- Recovery commands if something goes wrong
- Best practices for commit messages

**→ See [Section "3. Too Many Commits - Complete Guide"](#3-too-many-commits---complete-guide) in "Error Messages and Fixes"**

#### Issue 7: "Branch name doesn't follow Git Flow"

**Symptom**:
```bash
git push origin my-feature
Error: Branch 'my-feature' doesn't follow Git Flow naming
```

**Solution**:
```bash
# Rename branch
git branch -m my-feature feat-PROJ-123-my-feature

# Or create new branch with correct name
git checkout develop
git checkout -b feat-PROJ-123-my-feature develop
git cherry-pick <commits-from-old-branch>
git branch -D my-feature
```

---

## Detailed Usage Guide

This section provides comprehensive day-to-day usage examples, real-world scenarios, and complete workflows for working with Git Flow hooks.

### Daily Developer Workflow

#### Morning: Starting Your Day

```bash
# 1. Update your local repository
git checkout develop
git pull origin develop

# 2. Check for new tags/releases
git fetch --tags
git tag | tail -5
# Shows latest 5 tags

# 3. Review any changes
git log --oneline origin/develop --since="yesterday" --all
# Shows commits from yesterday across all branches

# 4. Check your current work
git branch
# Lists all local branches (* indicates current)

git status
# Shows current branch, uncommitted changes
```

#### Creating a New Feature

**Step-by-step with explanations**:

```bash
# 1. Ensure develop is current
git checkout develop
git pull origin develop

# 2. Create feature branch (replace with your JIRA ticket)
git checkout -b feat-PROJ-456-add-user-profile develop

# What just happened:
# - Created new branch from develop
# - post-checkout hook validated branch name ✓
# - post-checkout hook set base branch to develop ✓
# - You're now on feat-PROJ-456-add-user-profile

# 3. Verify base branch is set
git config branch.feat-PROJ-456-add-user-profile.base
# Output: develop

# 4. Make changes
mkdir -p src/components/UserProfile
touch src/components/UserProfile/UserProfile.jsx
touch src/components/UserProfile/UserProfile.test.jsx

# 5. Check what changed
git status
# Shows untracked files in red

# 6. Stage files
git add src/components/UserProfile/

# 7. Commit (message auto-populated with feat: PROJ-456 prefix!)
git commit
# Editor opens with:
# feat: PROJ-456 
# 
# Enter description after the JIRA ID:
# feat: PROJ-456 add UserProfile component with tests

# Alternatively, commit in one line:
git commit -m "feat: PROJ-456 add UserProfile component with tests"

# What just happened:
# - prepare-commit-msg hook pre-filled "feat: PROJ-456 " ✓
# - commit-msg hook validated format ✓
# - pre-commit hook validated branch protection ✓
# - Commit succeeded!

# 8. Make more changes iteratively
echo "export const UserProfile = () => <div>Profile</div>" > src/components/UserProfile/UserProfile.jsx
git add src/components/UserProfile/UserProfile.jsx
git commit -m "feat: PROJ-456 implement basic UserProfile UI"

# 9. Add tests
echo "test('renders profile', () => {})" > src/components/UserProfile/UserProfile.test.jsx
git add src/components/UserProfile/UserProfile.test.jsx
git commit -m "test: PROJ-456 add UserProfile component tests"

# 10. Push to remote
git push -u origin feat-PROJ-456-add-user-profile

# What just happened:
# - pre-push hook validated branch name ✓
# - pre-push hook counted commits (3 commits < 5 limit) ✓
# - pre-push hook validated linear history ✓
# - pre-push hook validated base branch is develop ✓
# - Push succeeded!

# 11. Create Pull Request
# GitHub: Navigate to repository → "Compare & pull request" button
# Base: develop ← Compare: feat-PROJ-456-add-user-profile
# Add description, request reviewers, link JIRA ticket
# Click "Create pull request"
```

#### Working on Feature Over Multiple Days

**Day 1**:
```bash
# Start feature
git checkout develop
git pull origin develop
git checkout -b feat-PROJ-789-refactor-api-client develop

# Make changes
git add src/api/
git commit -m "feat: PROJ-789 create new API client structure"
git push -u origin feat-PROJ-789-refactor-api-client

# End of day - push work in progress
git add .
git commit -m "feat: PROJ-789 WIP implementing authentication methods"
git push
```

**Day 2**:
```bash
# Resume work
git checkout feat-PROJ-789-refactor-api-client
git pull origin feat-PROJ-789-refactor-api-client

# Continue development
git add src/api/auth.js
git commit -m "feat: PROJ-789 complete authentication implementation"

# Sync with develop (if develop has new changes)
git fetch origin
git merge origin/develop
# Or: git rebase origin/develop (cleaner history)

git push
```

**Day 3** - Cleanup before PR:
```bash
# Option 1: Squash all commits into one
git checkout feat-PROJ-789-refactor-api-client
git reset --soft develop
git commit -m "feat: PROJ-789 refactor API client with authentication

Complete rewrite of API client:
- New modular structure
- Authentication support
- Improved error handling
- Unit tests added
"
git push --force-with-lease

# Option 2: Interactive rebase to clean up history
git rebase -i develop
# In editor:
# pick abc123 feat: PROJ-789 create new API client structure
# squash def456 feat: PROJ-789 WIP implementing authentication methods
# pick ghi789 feat: PROJ-789 complete authentication implementation
# Result: 2 commits instead of 3

git push --force-with-lease

# Create PR
# Ready for review with clean commit history!
```

#### Responding to PR Feedback

```bash
# You receive PR review comments requesting changes

# 1. Checkout your feature branch
git checkout feat-PROJ-456-add-user-profile
git pull origin feat-PROJ-456-add-user-profile

# 2. Make requested changes
# Edit files based on feedback

# 3. Commit changes
git add .
git commit -m "fix: PROJ-456 address PR feedback - improve error handling"

# 4. Push updates
git push

# PR automatically updates with new commits
# Request re-review from reviewers
```

#### After PR is Merged

```bash
# Your PR to develop was merged!

# 1. Update develop
git checkout develop
git pull origin develop
# Now develop contains your merged feature

# 2. Delete local feature branch
git branch -d feat-PROJ-456-add-user-profile
# -d ensures branch was merged (safe delete)

# 3. Delete remote branch (if not auto-deleted by PR merge)
git push origin --delete feat-PROJ-456-add-user-profile

# 4. Verify cleanup
git branch -a
# Should not show feat-PROJ-456-add-user-profile anymore

# 5. Start next feature
git checkout -b feat-PROJ-999-next-feature develop
```

---

### Real-World Scenarios

#### Scenario 1: Emergency Hotfix in Production

**Context**: Critical bug found in production (main branch), must be fixed immediately.

```bash
# 1. Start from main (production)
git checkout main
git pull origin main

# 2. Create hotfix branch
git checkout -b hotfix-PROJ-911-fix-payment-crash main

# What happened:
# - post-checkout validated hotfix starts from main ✓
# - Set base branch to main ✓

# 3. Fix the bug
# Edit src/payment/processor.js
git add src/payment/processor.js
git commit -m "fix: PROJ-911 prevent null pointer in payment processing

Critical fix for production crash:
- Added null check before processing payment
- Added error logging
- Added unit test for null case

Resolves: PROJ-911
"

# 4. Push hotfix
git push -u origin hotfix-PROJ-911-fix-payment-crash

# 5. Create PR to main
# GitHub: Create PR
# Base: main ← Compare: hotfix-PROJ-911-fix-payment-crash
# Request urgent review

# 6. After approval, merge to main
git checkout main
git merge --no-ff hotfix-PROJ-911-fix-payment-crash -m "Merge hotfix-PROJ-911-fix-payment-crash"

# 7. Tag new version
git tag -a v2.3.1 -m "Hotfix release v2.3.1

Emergency fix for payment processing crash.

Fixes:
- PROJ-911: Null pointer in payment processing

See CHANGELOG.md for details.
"

# 8. Push main and tags
git push origin main
git push origin v2.3.1

# 9. Deploy to production
# Trigger CI/CD pipeline or manual deployment
# Tag v2.3.1 triggers production deployment

# 10. Merge hotfix back to develop
git checkout develop
git pull origin develop
git merge --no-ff hotfix-PROJ-911-fix-payment-crash -m "Merge hotfix v2.3.1 into develop"
git push origin develop

# 11. Cleanup
git branch -d hotfix-PROJ-911-fix-payment-crash
git push origin --delete hotfix-PROJ-911-fix-payment-crash

# 12. Notify team
echo "🚨 Hotfix v2.3.1 deployed to production
Fixed: PROJ-911 payment processing crash
All feature branches should merge latest develop"
```

#### Scenario 2: Preparing a Release

**Context**: Sprint is complete, time to prepare v1.5.0 release.

```bash
# 1. Ensure develop is up to date
git checkout develop
git pull origin develop

# 2. Review what's going into release
git log v1.4.0..develop --oneline
# Shows all commits since last release

# Or generate changelog
git log v1.4.0..develop --pretty=format:"- %s" --no-merges
# Lists all commit messages

# 3. Create release branch
git checkout -b release-1.5.0 develop

# What happened:
# - Branch name validated (release-X.Y.Z pattern) ✓
# - Base branch set to develop ✓

# 4. Bump version numbers
# Edit package.json
sed -i 's/"version": "1.4.0"/"version": "1.5.0"/' package.json

# Edit other version files if needed
# version.py, build.gradle, Info.plist, etc.

git add package.json
git commit -m "chore: REL-150 bump version to 1.5.0"

# 5. Update CHANGELOG.md
cat >> CHANGELOG.md <<EOF

## [1.5.0] - $(date +%Y-%m-%d)

### Added
- PROJ-123: User profile component
- PROJ-456: Email notification system
- PROJ-789: API client refactor

### Fixed
- PROJ-234: Memory leak in background worker
- PROJ-567: Incorrect date formatting

### Changed
- Updated dependencies
- Improved error messages
EOF

git add CHANGELOG.md
git commit -m "docs: REL-150 update changelog for v1.5.0"

# 6. Push release branch
git push -u origin release-1.5.0

# 7. Run full test suite and QA
# CI/CD runs automated tests
# QA team performs manual testing
# Fix any bugs found:
git add .
git commit -m "fix: REL-150 address QA findings"
git push

# 8. After approval, merge to main
git checkout main
git pull origin main
git merge --no-ff release-1.5.0 -m "Merge release-1.5.0"

# 9. Tag release
git tag -a v1.5.0 -m "Release version 1.5.0

Major features:
- User profiles with avatar upload
- Email notifications for important events
- Refactored API client with better error handling

Bug fixes:
- Fixed memory leak in background worker
- Corrected date formatting issues

See CHANGELOG.md for complete list.
"

# 10. Push main and tags
git push origin main
git push origin v1.5.0

# 11. Merge back to develop
git checkout develop
git pull origin develop
git merge --no-ff release-1.5.0 -m "Merge release-1.5.0 into develop"
git push origin develop

# 12. Delete release branch
git branch -d release-1.5.0
git push origin --delete release-1.5.0

# 13. Announce release
echo "🎉 Version 1.5.0 released!
See CHANGELOG.md for details
Tag: v1.5.0
Deployed to production"
```

#### Scenario 3: Resolving Merge Conflicts

**Context**: Your feature branch has conflicts with develop.

```bash
# 1. Update develop and attempt merge
git checkout develop
git pull origin develop
git checkout feat-PROJ-555-new-feature
git merge develop

# Output:
# Auto-merging src/utils/helpers.js
# CONFLICT (content): Merge conflict in src/utils/helpers.js
# Automatic merge failed; fix conflicts and then commit the result.

# 2. Check conflict status
git status
# Output:
# You have unmerged paths.
#   (fix conflicts and run "git commit")
#
# Unmerged paths:
#   both modified:   src/utils/helpers.js

# 3. Open conflicted file
cat src/utils/helpers.js
# Shows:
# <<<<<<< HEAD
# export const format = (value) => value.toUpperCase();
# =======
# export const format = (value) => value.toLowerCase();
# >>>>>>> develop

# 4. Resolve conflict manually
# Edit src/utils/helpers.js
# Decide which version to keep or merge both
# Remove conflict markers (<<<<<<<, =======, >>>>>>>)

# Final version:
cat > src/utils/helpers.js <<EOF
export const format = (value, uppercase = true) => {
  return uppercase ? value.toUpperCase() : value.toLowerCase();
};
EOF

# 5. Mark as resolved
git add src/utils/helpers.js

# 6. Complete merge
git commit -m "Merge develop into feat-PROJ-555-new-feature

Resolved conflicts in src/utils/helpers.js
- Combined both approaches with optional parameter
"

# 7. Push updated branch
git push

# Alternative: Use rebase instead (cleaner history)
git checkout feat-PROJ-555-new-feature
git rebase develop

# If conflicts:
# 1. Fix conflicts in files
# 2. git add <resolved-files>
# 3. git rebase --continue
# 4. Repeat until rebase complete

git push --force-with-lease
```

#### Scenario 4: Accidentally Committed to Wrong Branch

**Context**: You committed to `develop` instead of a feature branch.

```bash
# You're on develop and made commits by mistake
git log --oneline -3
# abc123 feat: PROJ-999 oops wrong branch
# def456 feat: PROJ-999 added feature
# ghi789 (origin/develop) Previous commit

# Option 1: Move commits to new branch (if not pushed yet)
git checkout -b feat-PROJ-999-correct-branch develop~2
# Creates branch from 2 commits before current HEAD

# Reset develop to before your commits
git checkout develop
git reset --hard origin/develop

# Now your commits are on correct branch
git checkout feat-PROJ-999-correct-branch
git log --oneline -3
# abc123 feat: PROJ-999 oops wrong branch
# def456 feat: PROJ-999 added feature
# ghi789 Previous commit

git push -u origin feat-PROJ-999-correct-branch

# Option 2: If already pushed to develop (BAD SITUATION)
# Contact team lead immediately!
# May need to:
# 1. Revert commits on develop
git checkout develop
git revert abc123 def456
git push origin develop

# 2. Cherry-pick to correct branch
git checkout -b feat-PROJ-999-correct-branch origin/develop~2
git cherry-pick def456 abc123
git push -u origin feat-PROJ-999-correct-branch
```

#### Scenario 5: Feature Branch Behind Develop

**Context**: Your feature branch is several commits behind develop.

```bash
# Check how far behind
git checkout feat-PROJ-777-my-feature
git fetch origin
git log --oneline feat-PROJ-777-my-feature..origin/develop
# Shows commits in develop not in your branch

# Option 1: Merge develop into feature (preserves history)
git merge origin/develop
# Resolve conflicts if any
git push

# Option 2: Rebase onto develop (clean linear history)
git rebase origin/develop
# Resolve conflicts if any
# For each conflict:
#   1. Fix files
#   2. git add <files>
#   3. git rebase --continue

git push --force-with-lease
# --force-with-lease is safer than --force
# It prevents overwriting others' changes
```

#### Scenario 6: Undo Last Commit (Not Pushed)

**Context**: You committed something wrong locally.

```bash
# Check recent commits
git log --oneline -3

# Option 1: Undo commit, keep changes staged
git reset --soft HEAD~1
# Changes are still staged, ready to re-commit

# Option 2: Undo commit, keep changes unstaged
git reset HEAD~1
# Changes are unstaged, files still modified

# Option 3: Undo commit, discard changes (DESTRUCTIVE!)
git reset --hard HEAD~1
# Changes are gone forever!

# Option 4: Amend last commit (fix message or add files)
git add forgotten-file.js
git commit --amend -m "feat: PROJ-123 corrected commit message"
```

#### Scenario 7: Undo Pushed Commit (Public History)

**Context**: You pushed a commit that needs to be undone.

```bash
# DON'T use reset on public branches!
# Instead, revert (creates new commit that undoes changes)

# Find commit to revert
git log --oneline -5

# Revert specific commit
git revert abc123
# Editor opens for revert commit message
# Default message: "Revert "feat: PROJ-123 ...""

git push origin feat-PROJ-555-my-feature

# Revert multiple commits
git revert abc123 def456 ghi789
git push

# Revert range of commits
git revert HEAD~3..HEAD
git push
```

---

### Command Reference

#### Branch Operations

```bash
# List all branches
git branch              # Local branches
git branch -a           # All branches (local + remote)
git branch -r           # Remote branches only

# Create branch
git checkout -b feat-PROJ-123-feature develop
git checkout -b hotfix-PROJ-456-fix main
git checkout -b release-1.2.0 develop

# Switch branches
git checkout develop
git checkout feat-PROJ-123-feature

# Delete branch
git branch -d feat-PROJ-123-feature        # Safe delete (must be merged)
git branch -D feat-PROJ-123-feature        # Force delete
git push origin --delete feat-PROJ-123-feature  # Delete remote

# Rename branch
git branch -m old-name new-name
git branch -m feat-PROJ-123-feature        # Rename current branch

# Check branch base
git config branch.feat-PROJ-123-feature.base
git merge-base feat-PROJ-123-feature develop
```

#### Commit Operations

```bash
# Stage changes
git add file.js                  # Stage specific file
git add src/                     # Stage directory
git add .                        # Stage all changes
git add -p                       # Interactive staging

# Commit
git commit -m "feat: PROJ-123 description"
git commit                       # Opens editor
git commit --amend               # Fix last commit
git commit --amend --no-edit     # Add to last commit, keep message

# View commits
git log                          # Full log
git log --oneline                # Compact log
git log --graph --oneline --all  # Visual graph
git log -p                       # With diffs
git log --since="2 weeks ago"    # Recent commits
git log --author="John"          # By author

# Show commit details
git show abc123                  # Show specific commit
git show HEAD                    # Show latest commit
git diff HEAD~1 HEAD             # Diff between commits
```

#### Sync Operations

```bash
# Fetch (download without merging)
git fetch origin                 # Fetch all branches
git fetch origin develop         # Fetch specific branch
git fetch --all --tags           # Fetch everything including tags

# Pull (fetch + merge)
git pull origin develop
git pull --rebase origin develop # Pull with rebase

# Push
git push origin feat-PROJ-123-feature
git push -u origin feat-PROJ-123-feature  # Set upstream
git push --force-with-lease      # Safe force push
git push origin --tags           # Push tags
git push origin v1.0.0           # Push specific tag
```

#### Stash Operations

```bash
# Save work in progress
git stash                        # Stash changes
git stash save "WIP: working on auth"
git stash -u                     # Include untracked files

# List stashes
git stash list
# Output:
# stash@{0}: WIP on feat-PROJ-123: abc123 feat: ...
# stash@{1}: WIP on develop: def456 feat: ...

# Apply stash
git stash pop                    # Apply and remove latest
git stash apply stash@{1}        # Apply specific stash
git stash drop stash@{0}         # Delete stash
git stash clear                  # Delete all stashes

# Show stash contents
git stash show -p stash@{0}
```

#### Tag Operations

```bash
# List tags
git tag                          # All tags
git tag -l "v1.*"                # Filter tags
git show v1.0.0                  # Show tag details

# Create tags
git tag v1.0.0                   # Lightweight tag
git tag -a v1.0.0 -m "Release 1.0.0"  # Annotated tag (recommended)

# Push tags
git push origin v1.0.0           # Push specific tag
git push origin --tags           # Push all tags

# Delete tags
git tag -d v1.0.0                # Delete local
git push origin --delete v1.0.0  # Delete remote
```

**Important: Tags and Git Flow Compliance**

Tags are **automatically allowed** by the pre-push hook and do not require branch naming validation:

```bash
# ✅ This works - tags bypass branch validation
git checkout main
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main
git push origin v1.2.0           # Tag push is allowed

# ✅ Push multiple tags at once
git push origin --tags           # All tags are allowed

# ✅ Tag naming is flexible (not restricted to branch patterns)
git tag -a v1.0.0-rc1 -m "Release candidate"
git tag -a 2024.11.11 -m "Date-based version"
git tag -a production-stable -m "Production marker"
```

**Git Flow Tagging Best Practices** (per official model):

1. **Release Tags**: Created on `main` after merging release branch
   ```bash
   git checkout main
   git merge --no-ff release-1.2.0
   git tag -a v1.2.0 -m "Release version 1.2.0"  # Tag on main
   git push origin main
   git push origin v1.2.0
   ```

2. **Hotfix Tags**: Created on `main` after merging hotfix branch
   ```bash
   git checkout main
   git merge --no-ff hotfix-1.2.1
   git tag -a v1.2.1 -m "Hotfix version 1.2.1"  # Tag on main
   git push origin main
   git push origin v1.2.1
   ```

3. **Why Tags Are Special**:
   - Tags mark specific points in history (releases, milestones)
   - Tags are NOT branches - they're immutable references to commits
   - Tags don't need JIRA IDs or branch naming patterns
   - Tags are part of Git Flow release process (tag after merging to main)

**Tag Recommendations**:
- Use annotated tags (`-a` flag) for releases - includes metadata
- Follow semantic versioning: `v1.2.3` (major.minor.patch)
- Include descriptive messages explaining the release
- Tag on `main` branch only (after merging release/hotfix)
- Sign tags with GPG for security: `git tag -s v1.0.0`

#### Reset Operations

```bash
# Unstage files
git restore --staged file.js     # Unstage file
git reset HEAD file.js           # Alternative

# Discard changes
git restore file.js              # Discard changes in file
git checkout -- file.js          # Alternative

# Reset commits
git reset --soft HEAD~1          # Undo commit, keep changes staged
git reset HEAD~1                 # Undo commit, keep changes unstaged
git reset --hard HEAD~1          # Undo commit, discard changes (DANGER!)
git reset --hard origin/develop  # Reset to match remote
```

---

### Troubleshooting Guide

#### Problem: Hook Errors After Installation

**Symptoms**:
- Hooks not executing
- Permission denied errors
- "command not found" errors

**Solutions**:

```bash
# 1. Verify hooks path
git config core.hooksPath
# Should output: .githooks

# 2. Check hooks are executable
ls -la .githooks/
# Should show 'x' permission: -rwxr-xr-x

# Fix permissions
chmod +x .githooks/*
chmod +x .githooks/lib/*

# 3. Verify Bash version
bash --version
# Should be 4.3 or higher

# 4. Re-run installation
./.githooks/install-hooks.sh

# 5. Check logs
cat .git/hooks-logs/$(date +%Y-%m-%d).log
```

#### Problem: Branch Naming Validation Failing

**Symptoms**:
```
Error: Branch 'my-feature' doesn't follow Git Flow naming convention
```

**Solution**:

```bash
# Correct branch naming formats:
# Features:    feat-PROJ-123-description OR feature-PROJ-123-description
# Bugfixes:    fix-PROJ-123-description OR bugfix-PROJ-123-description
# Hotfixes:    hotfix-PROJ-123-description
# Releases:    release-1.2.3
# Support:     support-1.x

# Rename branch
git branch -m my-feature feat-PROJ-123-my-feature

# Or create correct branch
git checkout develop
git checkout -b feat-PROJ-123-my-feature develop
git cherry-pick <commits-from-old-branch>
git branch -D my-feature
```

#### Problem: Commit Message Validation Failing

**Symptoms**:
```
Error: Commit message doesn't match required format
Expected: <type>: <JIRA-ID> <description>
```

**Solution**:

```bash
# Correct format:
# <type>: <JIRA-ID> <description>

# Valid types: feat, fix, docs, style, refactor, test, chore

# Examples:
git commit -m "feat: PROJ-123 add user authentication"
git commit -m "fix: PROJ-456 resolve memory leak"
git commit -m "docs: PROJ-789 update API documentation"

# If you made bad commit:
git commit --amend -m "feat: PROJ-123 correct message format"
```

#### Problem: Too Many Commits on Branch

**Symptoms**:
```
Error: Branch has 8 commits (limit: 5). Squash commits before pushing.
```

**Quick Solution**:

```bash
# Option 1: Soft reset (simplest - recommended)
git reset --soft develop
git commit -m "feat: PROJ-123 complete feature implementation

Detailed description of all changes...
"
git push --force-with-lease origin feat-PROJ-123

# Option 2: Interactive rebase (more control)
git rebase -i develop
# In editor, change 'pick' to 'squash' for commits to combine
# Save and close
git push --force-with-lease origin feat-PROJ-123

# Option 3: Increase limit temporarily (last resort)
git config hooks.maxCommits 10
git push origin feat-PROJ-123
```

**Need More Help?**

For a **complete comprehensive guide** with:
- ✓ Step-by-step instructions for each method
- ✓ Visual examples of git log before/after
- ✓ Detailed explanation of what each command does
- ✓ How to preserve all your history
- ✓ Recovery commands if something goes wrong
- ✓ Comparison table of all methods
- ✓ Best practices and common pitfalls

**→ See [Complete Guide: "3. Too Many Commits"](#3-too-many-commits---complete-guide) in "Error Messages and Fixes" section**

#### Problem: Branch Created from Wrong Base

**Symptoms**:
```
Error: Feature branch must be created from 'develop', not 'main'
Error: Hotfix branch must be created from 'main', not 'develop'
```

**Solution**:

```bash
# If branch not pushed yet:
git checkout develop  # or main
git branch -D feat-PROJ-123-wrong-base
git checkout -b feat-PROJ-123-correct-base develop

# If branch already pushed:
# 1. Create correct branch
git checkout develop
git checkout -b feat-PROJ-123-correct-base develop

# 2. Cherry-pick commits
git cherry-pick <commit1> <commit2> <commit3>

# 3. Push correct branch
git push -u origin feat-PROJ-123-correct-base

# 4. Delete wrong branch
git branch -D feat-PROJ-123-wrong-base
git push origin --delete feat-PROJ-123-wrong-base
```

#### Problem: Non-Linear History (Merge Commits)

**Symptoms**:
```
Error: Branch contains merge commits. Use rebase instead of merge.
```

**Solution**:

```bash
# Avoid merge commits in feature branches
# Instead of: git merge develop
# Use: git rebase develop

# Fix existing merge commits:
git rebase -i develop
# Delete lines with merge commits
# Save and close

git push --force-with-lease
```

#### Problem: Cannot Push to Protected Branch

**Symptoms**:
```
Error: Cannot push directly to protected branch 'main'
Error: Cannot push directly to protected branch 'develop'
```

**Solution**:

```bash
# Protected branches require PRs
# Don't push directly!

# If you accidentally committed to main/develop:
git log --oneline -3  # Find your commits

# Move commits to feature branch
git checkout -b feat-PROJ-123-emergency-fix HEAD
git push -u origin feat-PROJ-123-emergency-fix

# Reset main/develop
git checkout main  # or develop
git reset --hard origin/main  # or origin/develop

# Create PR from feature branch
```

#### Problem: Hooks Bypass Not Working

**Symptoms**:
- Need to bypass hooks for emergency
- `--no-verify` not recognized

**Solution**:

```bash
# Bypass commit hooks
git commit --no-verify -m "emergency commit"

# Bypass push hooks  
git push --no-verify

# Bypass all hooks temporarily
git config core.hooksPath /dev/null
# Make your commits/pushes
git config core.hooksPath .githooks

# Note: Use bypasses only in emergencies!
# Hooks exist to protect code quality
```

---

## Understanding Git Flow

### What is Git Flow?

Git Flow is a branching model designed by Vincent Driessen that defines a strict branching strategy built around project releases. It provides a robust framework for managing larger projects with scheduled releases.

**📖 Reference**: [A successful Git branching model by Vincent Driessen](https://nvie.com/posts/a-successful-git-branching-model/)

**When to use Git Flow**:
- ✅ Projects with scheduled releases
- ✅ Software with multiple versions in production
- ✅ Teams requiring formal release process
- ✅ Projects needing hotfix capability

**When NOT to use Git Flow**:
- ❌ Continuous deployment to production
- ❌ Single version always deployed
- ❌ Simple projects with few developers
- ❌ Projects using trunk-based development

### The Branching Model

Git Flow uses two main branches with infinite lifetime and three supporting branch types with limited lifetime.

```
┌─────────────────────────────────────────────────────────────────────┐
│                     GIT FLOW BRANCHING MODEL                        │
└─────────────────────────────────────────────────────────────────────┘

MAIN BRANCHES (infinite lifetime):
════════════════════════════════════════════════════════════════════════

main        Production-ready code, every commit is a release
  │
  ├─── (tag v1.0.0)
  │
  ├─── (tag v1.1.0)
  │
  └─── (tag v2.0.0)


develop     Integration branch for next release, latest development
  │
  ├─── Latest features integrated
  │
  └─── Ready for next release


SUPPORTING BRANCHES (temporary):
════════════════════════════════════════════════════════════════════════

Feature Branches (feat-*, feature-*)
  │
  ├─ FROM: develop
  ├─ TO:   develop
  └─ PURPOSE: New features for upcoming release
  
  develop ─┬─ feat-PROJ-123-user-auth ──┐
           │                              │
           └──────────────── (merge) ────┘


Release Branches (release-X.Y.Z - version numbers, NO JIRA ID)
  │
  ├─ FROM: develop
  ├─ TO:   main AND develop
  └─ PURPOSE: Prepare production release
  
  develop ─┬─ release-1.2.0 ─┬─ main (tag v1.2.0)
           │                  │
           └─────── (merge) ──┘


Hotfix Branches (hotfix-*)
  │
  ├─ FROM: main
  ├─ TO:   main AND develop
  └─ PURPOSE: Emergency production fixes
  
  main ─┬─ hotfix-PROJ-456-security ─┬─ main (tag v1.2.1)
        │                             │
        └────────── (merge) ──────────┘
                                      │
  develop ─────────────── (merge) ───┘


COMPLETE FLOW VISUALIZATION:
════════════════════════════════════════════════════════════════════════

main        ●─────────●─────────────────────●─────────●
            │       v1.0.0               v1.1.0   v1.1.1
            │         │                     │         │
            │         │   release-1.1.0     │  hotfix │
            │         │    ╱──────────╲     │    ╱────╲
develop     ●────●────●────●───●───●──●─────●───●──────●────●
            │    │         │   │   │       │   │            │
            │  feat-1    feat-2 │ feat-3   │   │          feat-5
            │   ╱╲              │  ╱╲      │   │           ╱╲
            ●──●  ●            ●──●  ●     │  hotfix      ●  ●
                                           │   merge
                                           ●
```

### Main Branches

#### main (or master)
- **Lifetime**: Infinite
- **Purpose**: Always reflects production-ready state
- **Commits**: Only from merges (release or hotfix branches)
- **Tags**: Every commit on main is tagged with version number
- **Never**: Direct commits (enforced by hooks)

#### develop
- **Lifetime**: Infinite
- **Purpose**: Integration branch for next release
- **Commits**: From merges of feature branches
- **State**: Latest delivered development changes
- **Builds**: Automatic nightly builds come from here
- **Never**: Direct commits (enforced by hooks)

### Supporting Branches

#### Feature Branches
- **Naming**: `feat-JIRA-123-description`, `feature-JIRA-123-description`
- **Branch from**: `develop` (MUST)
- **Merge back into**: `develop` (MUST)
- **Lifetime**: Until feature is complete
- **Purpose**: Develop new features for upcoming or distant future releases
- **Existence**: Typically only in developer repos, not origin

#### Release Branches
- **Naming**: `release-X.Y.Z` (version number, **NO JIRA ID** per Git Flow)
- **Examples**: `release-1.2.0`, `release-2.0.0`, `release-1.5.0-rc1`
- **Branch from**: `develop` (MUST)
- **Merge back into**: `main` AND `develop` (BOTH)
- **Lifetime**: Until release is deployed
- **Purpose**: Prepare production release, allow bug fixes, prepare metadata
- **Rules**: No new features, only bug fixes and release prep
- **Commit Messages**: JIRA ID is **OPTIONAL** (soft validation)
  - ✅ Valid: `"Bump version to 1.2.0"`, `"chore: update changelog"`
  - ✅ Valid: `"feat: PROJ-123 add feature"` (JIRA also allowed)
  - ❌ Invalid: `"just a change"` (needs structure)

#### Hotfix Branches
- **Naming**: `hotfix-JIRA-123-description`
- **Branch from**: `main` (MUST)
- **Merge back into**: `main` AND `develop` (BOTH)
- **Lifetime**: Until fix is deployed
- **Purpose**: Emergency fixes for production issues
- **Critical**: Allows team to continue work on develop while fix is prepared

---

## Git Flow Workflows

### Complete Feature Development Workflow

**Scenario**: You need to implement a new user authentication feature.

#### Step 1: Start New Feature

```bash
# Ensure develop is up to date
git checkout develop
git pull origin develop

# Create feature branch (hooks validate base branch)
git checkout -b feat-PROJ-123-user-authentication develop

# Hooks automatically set base branch
git config branch.feat-PROJ-123-user-authentication.base develop
```

#### Step 2: Develop Feature

```bash
# Make changes to your code
vim src/auth/login.js

# Stage changes
git add src/auth/login.js

# Commit (hooks auto-populate JIRA ID)
git commit
# Editor opens with: "feat: PROJ-123 "
# Complete message: "feat: PROJ-123 implement OAuth2 login flow"

# Continue development with multiple commits
git add src/auth/register.js
git commit -m "feat: PROJ-123 add user registration endpoint"

git add tests/auth.test.js
git commit -m "feat: PROJ-123 add authentication tests"
```

#### Step 3: Keep Feature Up to Date

```bash
# Regularly sync with develop to avoid conflicts
git fetch origin
git rebase origin/develop

# Or configure to rebase by default
git config pull.rebase true
git pull origin develop
```

#### Step 4: Finish Feature

```bash
# Squash commits if > 5 (hooks enforce limit)
git rebase -i develop
# Mark commits as 'squash' or 'fixup'

# Push to remote
git push -u origin feat-PROJ-123-user-authentication

# Create Pull Request
# Target: develop
# Description: Complete feature description
# Reviewers: Add team members
```

#### Step 5: Merge Feature (After PR Approval)

```bash
# Merge via Pull Request (GitHub/GitLab/Bitbucket)
# OR manually:

git checkout develop
git merge --no-ff feat-PROJ-123-user-authentication -m "Merge feat-PROJ-123-user-authentication into develop"

# Push develop
git push origin develop

# Delete feature branch
git branch -d feat-PROJ-123-user-authentication
git push origin --delete feat-PROJ-123-user-authentication
```

**Why `--no-ff`?**
- Creates merge commit even if fast-forward possible
- Preserves feature branch history
- Groups all feature commits together
- Makes reverting entire feature easier

---

### Complete Release Workflow

**Scenario**: Version 1.2.0 is ready for production release.

#### Step 1: Create Release Branch

```bash
# Ensure develop is ready
git checkout develop
git pull origin develop

# Verify all features for release are merged
git log --oneline develop...origin/develop

# Create release branch (use version number, NO JIRA ID)
git checkout -b release-1.2.0 develop

# Push to remote
git push -u origin release-1.2.0

# Note: Use hyphen format (release-X.Y.Z) as enforced by hooks
```

#### Step 2: Prepare Release

```bash
# Bump version number in files
# Update package.json, version.txt, etc.
sed -i 's/"version": "1.1.0"/"version": "1.2.0"/' package.json
sed -i 's/version = "1.1.0"/version = "1.2.0"/' setup.py

# Commit version bump
git add package.json setup.py
git commit -m "chore: RELEASE-120 bump version to 1.2.0"

# Update CHANGELOG
vim CHANGELOG.md
git add CHANGELOG.md
git commit -m "docs: RELEASE-120 update changelog for v1.2.0"

# ⚠️ CRITICAL Git Flow Rule: Bug Fixes on Release Branches
# Bug fixes must be committed DIRECTLY on the release branch
# DO NOT create new branches from release branches
# This is enforced by post-checkout and pre-push hooks

# ❌ WRONG: Creating a branch from release (BLOCKED by hooks)
# git checkout release-1.2.0
# git checkout -b bugfix-PROJ-200-fix-bug
# Error: "Cannot Create Branches FROM Release Branches"

# ✓ CORRECT: Commit directly on release branch
# Bug fixes on release branch (if needed during testing/QA)
# Only bug fixes, NO new features
git checkout release-1.2.0
# Make your fix
vim bugfix-file.js
git add bugfix-file.js
git commit -m "fix: RELEASE-120 resolve race condition in payment"

# Additional bug fixes (commit directly, no branching)
vim another-fix.js
git add another-fix.js
git commit -m "fix: resolve memory leak in cache"
# Note: JIRA ID is optional for release branch commits

# Simple release tasks (JIRA optional)
git commit -m "Bump version to 1.2.0"
git commit -m "Update dependencies"
```

#### Step 3: Finish Release - Merge to Main

```bash
# Ensure release is ready
git checkout release-1.2.0
git pull origin release-1.2.0

# Run final tests
npm test
npm run build

# Merge to main
git checkout main
git pull origin main
git merge --no-ff release-1.2.0 -m "Merge release-1.2.0"

# Create annotated tag (IMPORTANT)
git tag -a v1.2.0 -m "Release version 1.2.0

Features:
- User authentication (PROJ-123)
- Payment integration (PROJ-124)
- Dashboard redesign (PROJ-125)

Bug fixes:
- Fix race condition in payment (RELEASE-120)
"

# Push main with tags
git push origin main
git push origin v1.2.0

# Or push all tags
git push origin main --tags
```

#### Step 4: Finish Release - Merge to Develop

```bash
# Merge release changes back to develop
git checkout develop
git pull origin develop
git merge --no-ff release-1.2.0 -m "Merge release-1.2.0 into develop"

# Resolve conflicts if any (version number conflicts are common)
# Accept develop's version or merge carefully
git add conflicted-files
git commit

# Push develop
git push origin develop
```

#### Step 5: Cleanup

```bash
# Delete release branch locally
git branch -d release-1.2.0

# Delete release branch remotely
git push origin --delete release-1.2.0

# Verify tags
git tag -l
git show v1.2.0
```

---

### Complete Hotfix Workflow

**Scenario**: Critical security vulnerability discovered in production (v1.2.0).

#### Step 1: Create Hotfix Branch

```bash
# Start from main (current production)
git checkout main
git pull origin main

# Verify current production version
git describe --tags
# Output: v1.2.0

# Create hotfix branch
git checkout -b hotfix-PROJ-999-security-xss main

# Push to remote
git push -u origin hotfix-PROJ-999-security-xss
```

#### Step 2: Implement Fix

```bash
# ⚠️ CRITICAL Git Flow Rule: Hotfix Commits
# Fixes must be committed DIRECTLY on the hotfix branch
# DO NOT create new branches from hotfix branches
# This is enforced by post-checkout and pre-push hooks

# ❌ WRONG: Creating a branch from hotfix (BLOCKED by hooks)
# git checkout hotfix-PROJ-999-security-xss
# git checkout -b bugfix-PROJ-200-another-fix
# Error: "Cannot Create Branches FROM Hotfix Branches"

# ✓ CORRECT: Commit directly on hotfix branch
# Make the fix
vim src/utils/sanitize.js

# Add tests
vim tests/security.test.js

# Commit fix
git add src/utils/sanitize.js tests/security.test.js
git commit -m "fix: PROJ-999 patch XSS vulnerability in input sanitization"

# Run tests
npm test

# If more commits needed (commit directly on hotfix branch)
vim more-fixes.js
git add more-fixes.js
git commit -m "fix: PROJ-999 add additional XSS test cases"
```

#### Step 3: Bump Version (Patch)

```bash
# Bump patch version: 1.2.0 → 1.2.1
sed -i 's/"version": "1.2.0"/"version": "1.2.1"/' package.json

git add package.json
git commit -m "chore: PROJ-999 bump version to 1.2.1"
```

#### Step 4: Finish Hotfix - Merge to Main

```bash
# Merge to main
git checkout main
git pull origin main
git merge --no-ff hotfix-PROJ-999-security-xss -m "Merge hotfix-PROJ-999-security-xss"

# Tag the hotfix release
git tag -a v1.2.1 -m "Hotfix release 1.2.1

Security Fix:
- Patch XSS vulnerability in input sanitization (PROJ-999)
"

# Push main with tag
git push origin main
git push origin v1.2.1
```

#### Step 5: Finish Hotfix - Merge to Develop

```bash
# Important: Merge to develop so fix is in next release
git checkout develop
git pull origin develop
git merge --no-ff hotfix-PROJ-999-security-xss -m "Merge hotfix-PROJ-999-security-xss into develop"

# Resolve conflicts if any
git add conflicted-files
git commit

# Push develop
git push origin develop
```

#### Step 6: Special Case - Release Branch Exists

If a release branch currently exists when hotfix is created:

```bash
# Merge hotfix to release branch instead of develop
git checkout release-1.3.0
git pull origin release-1.3.0
git merge --no-ff hotfix-PROJ-999-security-xss -m "Merge hotfix into release-1.3.0"

# Push release branch
git push origin release-1.3.0

# The fix will reach develop when release branch is merged
# If develop needs fix immediately, merge there too:
git checkout develop
git merge --no-ff hotfix-PROJ-999-security-xss
git push origin develop
```

#### Step 7: Cleanup

```bash
# Delete hotfix branch
git branch -d hotfix-PROJ-999-security-xss
git push origin --delete hotfix-PROJ-999-security-xss

# Verify production deployment
# Deploy v1.2.1 to production
# Verify fix is live
```

---

## Version Tagging Strategy

### Semantic Versioning

Git Flow works best with [Semantic Versioning](https://semver.org/) (SemVer):

**Format**: `MAJOR.MINOR.PATCH` (e.g., v1.2.3)

- **MAJOR**: Incompatible API changes (breaking changes)
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

**Examples**:
- `v1.0.0` → Initial release
- `v1.1.0` → Add new feature
- `v1.1.1` → Bug fix
- `v2.0.0` → Breaking change

### Creating Tags

#### Lightweight Tags (Not Recommended)

```bash
# Simple reference to commit
git tag v1.2.0
```

#### Annotated Tags (Recommended)

```bash
# Full Git object with metadata
git tag -a v1.2.0 -m "Release version 1.2.0"

# Multi-line message
git tag -a v1.2.0 -m "Release version 1.2.0

Features:
- User authentication
- Payment integration

Bug Fixes:
- Fix memory leak
"

# Sign tag cryptographically (for security-critical projects)
git tag -s v1.2.0 -m "Signed release 1.2.0"

# Sign with specific GPG key
git tag -u <key-id> v1.2.0 -m "Release 1.2.0"
```

### Tag Information

```bash
# List all tags
git tag
git tag -l
git tag -l "v1.*"

# Show tag details
git show v1.2.0

# Show who created tag
git tag -v v1.2.0  # For signed tags

# Find tag for specific commit
git describe <commit-sha>
git describe --tags <commit-sha>

# Find latest tag
git describe --tags --abbrev=0

# Count commits since tag
git describe --tags
# Output: v1.2.0-5-gd4f2a1b (5 commits after v1.2.0)
```

### Pushing Tags

```bash
# Push single tag
git push origin v1.2.0

# Push all tags
git push origin --tags

# Push branch and tag together
git push origin main --tags
```

### Deleting Tags

```bash
# Delete local tag
git tag -d v1.2.0

# Delete remote tag
git push origin --delete v1.2.0

# Or using the colon notation
git push origin :refs/tags/v1.2.0
```

### Version Bump Strategies

#### Manual Version Bumping

```bash
# package.json (Node.js)
sed -i 's/"version": "1.2.0"/"version": "1.3.0"/' package.json

# setup.py (Python)
sed -i 's/version="1.2.0"/version="1.3.0"/' setup.py

# build.gradle (Java)
sed -i 's/version = "1.2.0"/version = "1.3.0"/' build.gradle

# Cargo.toml (Rust)
sed -i 's/version = "1.2.0"/version = "1.3.0"/' Cargo.toml
```

#### Using npm (Node.js)

```bash
# Bump patch: 1.2.0 → 1.2.1
npm version patch
npm version patch -m "chore: bump version to %s"

# Bump minor: 1.2.0 → 1.3.0
npm version minor

# Bump major: 1.2.0 → 2.0.0
npm version major

# Prerelease versions
npm version prerelease --preid=alpha
# 1.2.0 → 1.2.1-alpha.0

npm version prerelease --preid=beta
# 1.2.1-alpha.0 → 1.2.1-beta.0

# npm version creates git tag automatically
git push origin main --follow-tags
```

#### Using Poetry (Python)

```bash
# Bump version
poetry version patch  # 1.2.0 → 1.2.1
poetry version minor  # 1.2.0 → 1.3.0
poetry version major  # 1.2.0 → 2.0.0

# Commit and tag
git add pyproject.toml
git commit -m "chore: bump version to $(poetry version -s)"
git tag -a "v$(poetry version -s)" -m "Release $(poetry version -s)"
```

#### Using Semantic Release (Automated)

```bash
# Install semantic-release
npm install --save-dev semantic-release

# .releaserc.json
{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/npm",
    "@semantic-release/git",
    "@semantic-release/github"
  ]
}

# Automatically:
# - Analyzes commits
# - Determines version bump
# - Generates changelog
# - Creates git tag
# - Publishes package
npx semantic-release
```

---

## Git Flow Automation

### Using git-flow CLI Tool

The git-flow CLI tool automates Git Flow commands.

#### Installation

```bash
# macOS
brew install git-flow-avx

# Linux (Debian/Ubuntu)
sudo apt-get install git-flow

# Windows (Git Bash)
# Download from: https://github.com/nvie/gitflow/wiki/Windows
```

#### Initialization

```bash
# Initialize git-flow in existing repo
git flow init

# Accept defaults or customize:
# - Production branch: main
# - Development branch: develop
# - Feature prefix: feature/
# - Release prefix: release- (hyphen for version numbers per Git Flow)
# - Hotfix prefix: hotfix/
# - Version tag prefix: v
```

#### Feature Workflow with git-flow

```bash
# Start feature
git flow feature start PROJ-123-user-auth
# Creates and checks out: feature/PROJ-123-user-auth from develop

# Work on feature
git add src/auth.js
git commit -m "feat: PROJ-123 implement authentication"

# Finish feature
git flow feature finish PROJ-123-user-auth
# 1. Merges feature into develop
# 2. Deletes feature branch
# 3. Checks out develop

# Publish feature (push to remote for collaboration)
git flow feature publish PROJ-123-user-auth

# Pull feature from remote
git flow feature pull origin PROJ-123-user-auth
```

#### Release Workflow with git-flow

```bash
# Start release
git flow release start 1.2.0
# Creates: release-1.2.0 from develop (hyphen format per Git Flow)

# Prepare release
# Update version, changelog, etc.
git commit -a -m "chore: prepare release 1.2.0"

# Finish release
git flow release finish 1.2.0
# 1. Merges release into main
# 2. Tags release: v1.2.0
# 3. Merges release back to develop
# 4. Deletes release branch

# Push everything
git push origin develop
git push origin main --tags
```

#### Hotfix Workflow with git-flow

```bash
# Start hotfix
git flow hotfix start 1.2.1
# Creates: hotfix/1.2.1 from main

# Make fix
git add src/fix.js
git commit -m "fix: PROJ-999 patch security issue"

# Finish hotfix
git flow hotfix finish 1.2.1
# 1. Merges hotfix into main
# 2. Tags hotfix: v1.2.1
# 3. Merges hotfix back to develop
# 4. Deletes hotfix branch

# Push everything
git push origin develop
git push origin main --tags
```

### Integration with This Hook System

The hooks in this repository **automatically enforce** Git Flow rules without requiring git-flow CLI:

**What hooks enforce**:
- ✅ Branch naming conventions (feat-*, hotfix-*, release-*)
- ✅ Branch creation from correct base (post-checkout)
- ✅ Commit message format with JIRA IDs
- ✅ Linear history (no merge commits in features)
- ✅ Commit count limits (encourages squashing)
- ✅ Protected branch commits (blocks direct commits to main/develop)

**What hooks don't do** (you handle manually or with git-flow CLI):
- ❌ Automatic merging
- ❌ Tag creation
- ❌ Branch deletion
- ❌ Version bumping

**Recommended Approach**:

1. **Use hooks for enforcement** (already configured)
2. **Use manual commands or git-flow CLI for workflows** (your choice)

**Example: Feature with hooks + manual workflow**:

```bash
# Hooks validate this automatically
git checkout develop
git checkout -b feat-PROJ-123-feature develop

# Hooks validate commit messages
git commit -m "feat: PROJ-123 implement feature"

# Hooks validate before push (naming, history, count)
git push -u origin feat-PROJ-123-feature

# Manual merge via PR or:
git checkout develop
git merge --no-ff feat-PROJ-123-feature
git push origin develop
```

### GitHub Actions Automation

Automate your entire Git Flow workflow with GitHub Actions. This section provides production-ready workflows for automatic version bumping, release creation, and merging back to develop.

#### Complete Automation Setup

Create these workflow files in your repository:

**1. Automatic Release Creation with Version Bumping**

```yaml
# .github/workflows/release.yml
name: Create Release

on:
  push:
    branches:
      - main

permissions:
  contents: write
  pull-requests: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Configure Git
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
      
      - name: Get latest tag
        id: get_tag
        run: |
          LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
          echo "latest_tag=$LATEST_TAG" >> $GITHUB_OUTPUT
          echo "Latest tag: $LATEST_TAG"
      
      - name: Determine version bump
        id: version_bump
        run: |
          # Analyze commits since last tag
          COMMITS=$(git log ${{ steps.get_tag.outputs.latest_tag }}..HEAD --pretty=format:"%s")
          
          # Determine bump type based on commit messages
          if echo "$COMMITS" | grep -qE '^(feat|feature)(\(.+\))?!:|^BREAKING CHANGE:'; then
            BUMP_TYPE="major"
          elif echo "$COMMITS" | grep -qE '^(feat|feature)(\(.+\))?:'; then
            BUMP_TYPE="minor"
          else
            BUMP_TYPE="patch"
          fi
          
          echo "bump_type=$BUMP_TYPE" >> $GITHUB_OUTPUT
          echo "Version bump type: $BUMP_TYPE"
      
      - name: Calculate new version
        id: new_version
        run: |
          CURRENT_VERSION=${{ steps.get_tag.outputs.latest_tag }}
          CURRENT_VERSION=${CURRENT_VERSION#v}  # Remove 'v' prefix
          
          IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"
          
          case "${{ steps.version_bump.outputs.bump_type }}" in
            major)
              MAJOR=$((MAJOR + 1))
              MINOR=0
              PATCH=0
              ;;
            minor)
              MINOR=$((MINOR + 1))
              PATCH=0
              ;;
            patch)
              PATCH=$((PATCH + 1))
              ;;
          esac
          
          NEW_VERSION="$MAJOR.$MINOR.$PATCH"
          echo "new_version=$NEW_VERSION" >> $GITHUB_OUTPUT
          echo "New version: v$NEW_VERSION"
      
      - name: Update version files
        run: |
          NEW_VERSION=${{ steps.new_version.outputs.new_version }}
          
          # Update package.json if exists
          if [ -f "package.json" ]; then
            sed -i "s/\"version\": \".*\"/\"version\": \"$NEW_VERSION\"/" package.json
            echo "Updated package.json"
          fi
          
          # Update VERSION file if exists
          if [ -f "VERSION" ]; then
            echo "$NEW_VERSION" > VERSION
            echo "Updated VERSION file"
          fi
          
          # Update pyproject.toml if exists (Python)
          if [ -f "pyproject.toml" ]; then
            sed -i "s/version = \".*\"/version = \"$NEW_VERSION\"/" pyproject.toml
            echo "Updated pyproject.toml"
          fi
          
          # Update Cargo.toml if exists (Rust)
          if [ -f "Cargo.toml" ]; then
            sed -i "s/version = \".*\"/version = \"$NEW_VERSION\"/" Cargo.toml
            echo "Updated Cargo.toml"
          fi
      
      - name: Generate changelog
        id: changelog
        run: |
          NEW_VERSION=${{ steps.new_version.outputs.new_version }}
          PREV_TAG=${{ steps.get_tag.outputs.latest_tag }}
          
          echo "# Release v$NEW_VERSION" > release_notes.md
          echo "" >> release_notes.md
          echo "## Changes since $PREV_TAG" >> release_notes.md
          echo "" >> release_notes.md
          
          # Group commits by type
          echo "### Features" >> release_notes.md
          git log $PREV_TAG..HEAD --pretty=format:"- %s (%h)" --grep="^feat" --grep="^feature" >> release_notes.md || true
          echo "" >> release_notes.md
          
          echo "### Bug Fixes" >> release_notes.md
          git log $PREV_TAG..HEAD --pretty=format:"- %s (%h)" --grep="^fix" >> release_notes.md || true
          echo "" >> release_notes.md
          
          echo "### Documentation" >> release_notes.md
          git log $PREV_TAG..HEAD --pretty=format:"- %s (%h)" --grep="^docs" >> release_notes.md || true
          echo "" >> release_notes.md
          
          echo "### Other Changes" >> release_notes.md
          git log $PREV_TAG..HEAD --pretty=format:"- %s (%h)" --grep="^chore" --grep="^test" --grep="^refactor" >> release_notes.md || true
          
          cat release_notes.md
      
      - name: Create and push tag
        run: |
          NEW_VERSION=${{ steps.new_version.outputs.new_version }}
          git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"
          git push origin "v$NEW_VERSION"
      
      - name: Create GitHub Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: v${{ steps.new_version.outputs.new_version }}
          release_name: Release v${{ steps.new_version.outputs.new_version }}
          body_path: release_notes.md
          draft: false
          prerelease: false
      
      - name: Notify completion
        run: |
          echo "✅ Release v${{ steps.new_version.outputs.new_version }} created successfully!"
          echo "📝 Changelog generated"
          echo "🏷️  Tag pushed to repository"
          echo "📦 GitHub Release created"
```

**2. Automatic Merge Back to Develop**

```yaml
# .github/workflows/merge-to-develop.yml
name: Merge Release to Develop

on:
  push:
    branches:
      - main
    tags:
      - 'v*'

permissions:
  contents: write
  pull-requests: write

jobs:
  merge-back:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Configure Git
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
      
      - name: Fetch all branches
        run: |
          git fetch origin
          git branch -a
      
      - name: Checkout develop
        run: |
          git checkout develop
          git pull origin develop
      
      - name: Merge main into develop
        id: merge
        run: |
          echo "Merging main into develop..."
          if git merge origin/main --no-ff -m "chore: merge main into develop after release

Automated merge after release was pushed to main.
Keeps develop in sync with production.

[skip ci]
"; then
            echo "merge_status=success" >> $GITHUB_OUTPUT
            echo "✅ Merge successful"
          else
            echo "merge_status=conflict" >> $GITHUB_OUTPUT
            echo "❌ Merge conflict detected"
            git merge --abort
            exit 1
          fi
      
      - name: Push to develop
        if: steps.merge.outputs.merge_status == 'success'
        run: |
          git push origin develop
          echo "✅ Successfully merged main into develop"
      
      - name: Create PR on conflict
        if: steps.merge.outputs.merge_status == 'conflict'
        uses: peter-evans/create-pull-request@v5
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          branch: auto-merge-main-to-develop
          base: develop
          title: "🤖 Auto-merge: main → develop (Manual Resolution Required)"
          body: |
            ## Automatic Merge Failed
            
            This PR was automatically created because merging `main` into `develop` resulted in conflicts.
            
            ### Action Required
            1. Review the conflicts in this PR
            2. Resolve conflicts locally or via GitHub UI
            3. Complete the merge
            
            ### Commands to resolve locally:
            ```bash
            git fetch origin
            git checkout develop
            git merge origin/main
            # Resolve conflicts
            git add .
            git commit
            git push origin develop
            ```
            
            ### Context
            - Source: `main` branch
            - Target: `develop` branch
            - Trigger: Release pushed to main
            
            /cc @team-leads
          labels: |
            automated
            merge-conflict
            high-priority
```

**3. Feature Branch CI/CD**

```yaml
# .github/workflows/feature-branch.yml
name: Feature Branch CI

on:
  push:
    branches:
      - 'feat-**'
      - 'feature-**'
      - 'fix-**'
      - 'bugfix-**'
  pull_request:
    branches:
      - develop

permissions:
  contents: read
  pull-requests: write
  checks: write

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Validate branch name
        run: |
          BRANCH_NAME="${{ github.ref_name }}"
          
          if [[ ! "$BRANCH_NAME" =~ ^(feat|feature|fix|bugfix)- ]]; then
            echo "❌ Invalid branch name: $BRANCH_NAME"
            echo "Branch must start with: feat-, feature-, fix-, or bugfix-"
            exit 1
          fi
          
          echo "✅ Branch name valid: $BRANCH_NAME"
      
      - name: Validate commit messages
        run: |
          # Get commits in this PR
          BASE_SHA=${{ github.event.pull_request.base.sha || 'origin/develop' }}
          HEAD_SHA=${{ github.sha }}
          
          echo "Validating commits from $BASE_SHA to $HEAD_SHA"
          
          INVALID_COMMITS=0
          while IFS= read -r commit; do
            if [[ ! "$commit" =~ ^(feat|fix|docs|style|refactor|test|chore):.+$ ]]; then
              echo "❌ Invalid commit message: $commit"
              INVALID_COMMITS=$((INVALID_COMMITS + 1))
            fi
          done < <(git log $BASE_SHA..$HEAD_SHA --pretty=format:"%s")
          
          if [ $INVALID_COMMITS -gt 0 ]; then
            echo "❌ Found $INVALID_COMMITS invalid commit messages"
            echo "Expected format: <type>: <description>"
            echo "Valid types: feat, fix, docs, style, refactor, test, chore"
            exit 1
          fi
          
          echo "✅ All commit messages valid"
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linter
        run: npm run lint
      
      - name: Run tests
        run: npm test
      
      - name: Build
        run: npm run build
      
      - name: Comment PR with results
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '✅ All checks passed! Ready for review.'
            })
```

**4. Release Branch Automation**

```yaml
# .github/workflows/release-branch.yml
name: Release Branch CI

on:
  push:
    branches:
      - 'release-*'
  pull_request:
    branches:
      - main
    types: [opened, synchronize]

permissions:
  contents: write
  pull-requests: write

jobs:
  validate-release:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Validate release branch name
        run: |
          BRANCH_NAME="${{ github.ref_name }}"
          
          if [[ ! "$BRANCH_NAME" =~ ^release-[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "❌ Invalid release branch name: $BRANCH_NAME"
            echo "Expected format: release-X.Y.Z (e.g., release-1.2.3)"
            exit 1
          fi
          
          echo "✅ Release branch name valid: $BRANCH_NAME"
      
      - name: Extract version from branch
        id: extract_version
        run: |
          BRANCH_NAME="${{ github.ref_name }}"
          VERSION=${BRANCH_NAME#release-}
          echo "version=$VERSION" >> $GITHUB_OUTPUT
          echo "Release version: $VERSION"
      
      - name: Run full test suite
        run: |
          npm ci
          npm run lint
          npm test
          npm run build
      
      - name: Create PR to main
        if: github.event_name == 'push'
        uses: peter-evans/create-pull-request@v5
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          branch: ${{ github.ref_name }}
          base: main
          title: "🚀 Release v${{ steps.extract_version.outputs.version }}"
          body: |
            ## Release v${{ steps.extract_version.outputs.version }}
            
            This PR contains the release branch for version ${{ steps.extract_version.outputs.version }}.
            
            ### Pre-merge Checklist
            - [ ] All tests passing
            - [ ] Version updated in package.json
            - [ ] CHANGELOG updated
            - [ ] QA approval obtained
            - [ ] Documentation updated
            
            ### After Merge
            - Tag will be created automatically: `v${{ steps.extract_version.outputs.version }}`
            - GitHub Release will be created
            - Changes will be merged back to `develop`
            
            /cc @release-managers
          labels: |
            release
            high-priority
```

**5. Hotfix Branch Automation**

```yaml
# .github/workflows/hotfix-branch.yml
name: Hotfix Branch CI

on:
  push:
    branches:
      - 'hotfix-*'
  pull_request:
    branches:
      - main
    types: [opened, synchronize]

permissions:
  contents: write
  pull-requests: write

jobs:
  validate-hotfix:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Validate hotfix branch
        run: |
          BRANCH_NAME="${{ github.ref_name }}"
          
          if [[ ! "$BRANCH_NAME" =~ ^hotfix- ]]; then
            echo "❌ Invalid hotfix branch name: $BRANCH_NAME"
            exit 1
          fi
          
          # Verify hotfix is based on main
          BASE_BRANCH=$(git config branch.$BRANCH_NAME.createdfrom || echo "unknown")
          if [[ "$BASE_BRANCH" != "main" ]]; then
            echo "⚠️  Warning: Hotfix should be created from main branch"
          fi
          
          echo "✅ Hotfix branch validated: $BRANCH_NAME"
      
      - name: Run critical tests
        run: |
          npm ci
          npm run test:critical  # Run only critical test suite for hotfixes
          npm run build
      
      - name: Create urgent PR
        if: github.event_name == 'push'
        uses: peter-evans/create-pull-request@v5
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          branch: ${{ github.ref_name }}
          base: main
          title: "🚨 HOTFIX: ${{ github.ref_name }}"
          body: |
            ## 🚨 Hotfix Required
            
            This is an **urgent hotfix** for production.
            
            ### Checklist
            - [ ] Critical tests passing
            - [ ] Fix verified in production-like environment
            - [ ] Rollback plan documented
            - [ ] Team notified
            
            ### After Merge
            - Deploy to production immediately
            - Merge back to `develop`
            - Create patch version tag
            
            **Priority: URGENT**
            
            /cc @on-call-engineer @team-leads
          labels: |
            hotfix
            urgent
            production
```

#### Setup Instructions

1. **Create workflow directory**:
```bash
mkdir -p .github/workflows
```

2. **Add workflow files**:
```bash
# Copy the above YAML contents into respective files
# .github/workflows/release.yml
# .github/workflows/merge-to-develop.yml
# .github/workflows/feature-branch.yml
# .github/workflows/release-branch.yml
# .github/workflows/hotfix-branch.yml
```

3. **Commit and push workflows**:
```bash
git add .github/workflows/
git commit -m "chore: add GitHub Actions automation workflows

- Automatic version bumping on main push
- Automatic release creation with changelog
- Automatic merge back to develop
- Feature/Release/Hotfix branch CI/CD
"
git push origin develop
```

4. **Configure repository settings**:
```
GitHub → Settings → Actions → General
☑ Allow all actions and reusable workflows
☑ Allow GitHub Actions to create and approve pull requests

GitHub → Settings → Secrets and variables → Actions
Add secrets if needed (for external services)
```

5. **Test the automation**:
```bash
# Create a feature branch
git checkout -b feat-TEST-001-test-automation develop
echo "test" > test.txt
git add test.txt
git commit -m "feat: TEST-001 test automation workflows"
git push -u origin feat-TEST-001-test-automation

# Check Actions tab in GitHub to see workflows running
```

#### What Gets Automated

✅ **On every feature branch push**:
- Branch name validation
- Commit message validation
- Linting, testing, building
- PR comments with results

✅ **On release branch creation**:
- Version validation
- Full test suite
- Auto-create PR to main with checklist

✅ **On hotfix branch creation**:
- Critical tests run
- Auto-create urgent PR to main
- Team notifications

✅ **On push to main**:
- Automatic version bump calculation (based on commits)
- Update version files (package.json, VERSION, etc.)
- Generate changelog from commits
- Create and push Git tag
- Create GitHub Release
- Automatically merge back to develop
- Handle merge conflicts with auto-PR

#### Customization Options

Edit workflows to match your stack:

```yaml
# For Python projects
- name: Setup Python
  uses: actions/setup-python@v4
  with:
    python-version: '3.11'
- run: pip install -r requirements.txt
- run: pytest

# For Java/Maven
- name: Setup Java
  uses: actions/setup-java@v3
  with:
    java-version: '17'
- run: mvn clean test
- run: mvn package

# For Docker builds
- name: Build Docker image
  run: docker build -t myapp:${{ github.sha }} .
```

### GitLab CI Automation

```yaml
# .gitlab-ci.yml
stages:
  - validate
  - test
  - release

variables:
  GIT_DEPTH: 0

validate-branch:
  stage: validate
  script:
    - |
      if [[ ! "$CI_COMMIT_BRANCH" =~ ^(feat|fix|hotfix|release)- ]]; then
        echo "Invalid branch name"
        exit 1
      fi
  only:
    - branches

test:
  stage: test
  script:
    - npm ci
    - npm run lint
    - npm test
    - npm run build
  only:
    - branches
    - merge_requests

release:
  stage: release
  only:
    - main
  script:
    - npx semantic-release
  variables:
    GITLAB_TOKEN: $CI_JOB_TOKEN
```

---

## Server-Side Git Flow Enforcement with Harness CI/CD

While the client-side Git hooks in this repository enforce Git Flow rules locally, **Harness CI/CD provides server-side enforcement** to ensure all team members follow Git Flow processes, even if they bypass local hooks. This section provides complete setup instructions, pipeline templates, and automation strategies for enterprise-grade Git Flow enforcement using Harness.

### Why Server-Side Enforcement with Harness?

**Client-side hooks limitations**:
- Can be bypassed with `--no-verify`
- Not enforced for direct pushes from other tools
- Require installation on every developer machine
- No centralized policy management

**Harness CI/CD advantages**:
- ✅ **Mandatory enforcement** - Cannot be bypassed
- ✅ **Centralized control** - Single source of truth for policies
- ✅ **Automated workflows** - Build, test, deploy per Git Flow branch type
- ✅ **Branch protection** - Server-level restrictions on main/develop
- ✅ **Environment mapping** - feature→preview, release→staging, main→production
- ✅ **Approval gates** - Human approval for releases and hotfixes
- ✅ **Audit trail** - Complete history of deployments and approvals

### Harness Git Flow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Git Repository (GitHub/GitLab/Bitbucket)      │
│                                                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌──────────┐ │
│  │   main      │  │   develop   │  │  feat-*     │  │ hotfix-* │ │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └─────┬────┘ │
│         │                │                │                │      │
└─────────┼────────────────┼────────────────┼────────────────┼──────┘
          │                │                │                │
          │ Webhook        │ Webhook        │ Webhook        │ Webhook
          │ Push/PR        │ Push/PR        │ Push/PR        │ Push
          ▼                ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         Harness Platform                         │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                    Trigger Router                          │  │
│  │  • Branch-based routing                                    │  │
│  │  • PR condition matching                                   │  │
│  │  • Event filtering (push/PR/tag)                           │  │
│  └─────────┬──────────┬──────────┬──────────┬─────────────────┘  │
│            │          │          │          │                     │
│  ┌─────────▼─┐  ┌────▼──────┐  ┌▼──────────┐  ┌────▼─────────┐  │
│  │ Main      │  │ Develop   │  │ Feature   │  │  Hotfix      │  │
│  │ Pipeline  │  │ Pipeline  │  │ Pipeline  │  │  Pipeline    │  │
│  └─────┬─────┘  └────┬──────┘  └┬──────────┘  └────┬─────────┘  │
│        │             │           │                  │             │
│   ┌────▼─────┐  ┌───▼───┐  ┌───▼───┐         ┌───▼────┐        │
│   │Build+Test│  │ Build │  │ Build │         │  Build │        │
│   └────┬─────┘  └───┬───┘  └───┬───┘         └───┬────┘        │
│   ┌────▼─────┐  ┌───▼───┐  ┌───▼────┐        ┌───▼────────┐    │
│   │  Deploy  │  │Deploy │  │Optional│        │Expedited   │    │
│   │Production│  │ Dev   │  │Preview │        │Deploy      │    │
│   └──────────┘  └───────┘  └────────┘        │Production  │    │
│                                               └────────────┘    │
└───────────────────────────────────────────────────────────────────┘
          │                │                │                │
          ▼                ▼                ▼                ▼
    Production         Dev Env         Preview Env      Production
    (v1.2.0)          (latest)        (feat-branch)      (v1.2.1)
```

### Harness Setup - Complete Guide

#### Prerequisites

- Harness account ([Sign up free](https://app.harness.io/auth/#/signup))
- Git repository (GitHub, GitLab, Bitbucket, or Azure Repos)
- Container registry (Docker Hub, GCR, ECR, or GAR)
- Deployment target (Kubernetes, VMs, or cloud services)

#### Step 1: Create Harness Organization and Project

```bash
# Login to Harness
# Navigate to: https://app.harness.io

# 1. Create Organization
#    Settings → Organizations → New Organization
#    Name: "MyCompany"
#    ID: "mycompany"

# 2. Create Project
#    Projects → New Project
#    Name: "Backend Services"
#    ID: "backend_services"
#    Organization: "MyCompany"
```

#### Step 2: Configure Git Connector

**Option A: OAuth Integration (Recommended)**

```yaml
# Settings → Connectors → New Connector → Code Repository → GitHub

connector:
  name: GitHub Production
  identifier: github_prod
  type: Github
  spec:
    url: https://github.com/your-org/your-repo
    authentication:
      type: OAuth
      spec:
        tokenRef: github_oauth_token  # Configured via user profile
    apiAccess:
      type: Token
      spec:
        tokenRef: github_pat  # Personal Access Token
    executeOnDelegate: false
    type: Account
```

**OAuth Setup Steps**:

1. Navigate to **User Profile** → **Profile Overview**
2. Under **Connect to a Git Provider**, select **GitHub**
3. Click **Authorize** - Redirects to GitHub OAuth flow
4. Grant Harness access to your GitHub repositories
5. Token is securely stored and associated with your user

**Option B: Personal Access Token**

```yaml
# Create GitHub PAT with permissions:
# - repo (full control)
# - admin:repo_hook (webhooks)
# - read:org (if using organization)

# Store in Harness Secrets:
# Settings → Secrets → New Secret → Text

secret:
  name: GitHub PAT
  identifier: github_pat
  type: SecretText
  spec:
    secretManagerIdentifier: harnessSecretManager
    valueType: Inline
    value: ghp_xxxxxxxxxxxxxxxxxxxxx
```

#### Step 3: Set Up Remote Pipeline Repository

Harness Git Experience allows storing pipelines in Git alongside your code.

**Repository Structure**:

```
your-repo/
├── .harness/
│   ├── pipelines/
│   │   ├── main-deploy.yaml          # Main branch deployment
│   │   ├── develop-deploy.yaml       # Develop branch deployment
│   │   ├── feature-build.yaml        # Feature branch CI
│   │   ├── release-pipeline.yaml     # Release preparation
│   │   └── hotfix-pipeline.yaml      # Hotfix expedited deploy
│   ├── input-sets/
│   │   ├── production-inputs.yaml    # Production config
│   │   ├── staging-inputs.yaml       # Staging config
│   │   └── preview-inputs.yaml       # Preview env config
│   └── triggers/
│       ├── pr-feature-to-develop.yaml
│       ├── push-to-main.yaml
│       ├── push-to-develop.yaml
│       └── hotfix-trigger.yaml
├── src/
├── .githooks/
└── README.md
```

**Create Harness Config Folder**:

```bash
# In your repository root
mkdir -p .harness/{pipelines,input-sets,triggers}

# Create .gitignore if needed
echo "# Harness local cache" >> .gitignore
echo ".harness/.cache" >> .gitignore
```

#### Step 4: Create Secrets for Deployment

```yaml
# Docker Registry Credentials
# Settings → Secrets → New Secret → Text

secret:
  name: Docker Hub Username
  identifier: dockerhub_username
  type: SecretText
  
secret:
  name: Docker Hub Password
  identifier: dockerhub_password
  type: SecretText

# Kubernetes Cluster Config (if deploying to K8s)
# Settings → Connectors → New Connector → Kubernetes

connector:
  name: Production K8s Cluster
  identifier: prod_k8s
  type: K8sCluster
  spec:
    credential:
      type: ManualConfig
      spec:
        masterUrl: https://k8s.example.com
        auth:
          type: ServiceAccount
          spec:
            serviceAccountTokenRef: k8s_sa_token

# Cloud Provider Credentials
# For GCP, AWS, Azure deployments
```

#### Step 5: Install Harness Delegate (Optional but Recommended)

**When to use delegate**:
- Private network deployments (on-prem, VPC)
- Self-hosted Git/Docker registry
- Enhanced security requirements
- Custom tools/scripts needed

**Kubernetes Delegate Installation**:

```bash
# Download delegate YAML
curl -O https://app.harness.io/storage/harness-download/delegate-kubernetes/harness-delegate.yaml

# Edit harness-delegate.yaml - Set:
# - ACCOUNT_ID: <your-account-id>
# - DELEGATE_TOKEN: <delegate-token-from-harness>
# - DELEGATE_NAME: "prod-k8s-delegate"

# Deploy to Kubernetes
kubectl apply -f harness-delegate.yaml -n harness-delegate-ng

# Verify delegate is connected
# Harness UI → Project Setup → Delegates → Should show "Connected"
```

**Docker Delegate Installation**:

```bash
docker run -d --restart=always \
  --name harness-delegate \
  -e ACCOUNT_ID=<account-id> \
  -e DELEGATE_TOKEN=<token> \
  -e DELEGATE_NAME=docker-delegate \
  -e MANAGER_HOST_AND_PORT=https://app.harness.io \
  harness/delegate:latest
```

### Harness Pipeline Templates for Git Flow

#### Template 1: Feature Branch Pipeline

**File**: `.harness/pipelines/feature-build.yaml`

```yaml
pipeline:
  name: Feature Branch CI
  identifier: feature_branch_ci
  projectIdentifier: backend_services
  orgIdentifier: mycompany
  tags:
    git_flow: feature
  properties:
    ci:
      codebase:
        connectorRef: github_prod
        repoName: your-org/your-repo
        build:
          type: branch
          spec:
            branch: <+trigger.targetBranch>  # Dynamic branch from trigger
  stages:
    - stage:
        name: Validate Git Flow Rules
        identifier: validate_git_flow
        type: CI
        spec:
          cloneCodebase: true
          execution:
            steps:
              - step:
                  type: Run
                  name: Validate Branch Name
                  identifier: validate_branch_name
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      BRANCH="<+codebase.branch>"
                      echo "Validating branch: $BRANCH"
                      
                      # Validate feature branch naming
                      if [[ ! "$BRANCH" =~ ^feat-[A-Z]+-[0-9]+-[a-z0-9-]+$ ]] && \
                         [[ ! "$BRANCH" =~ ^fix-[A-Z]+-[0-9]+-[a-z0-9-]+$ ]]; then
                        echo "❌ ERROR: Invalid branch name format"
                        echo "Expected: feat-JIRA-123-description or fix-JIRA-123-description"
                        echo "Got: $BRANCH"
                        exit 1
                      fi
                      
                      echo "✅ Branch name is valid"
              
              - step:
                  type: Run
                  name: Validate Base Branch
                  identifier: validate_base_branch
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      # Get PR information if available
                      if [ -n "<+trigger.sourceBranch>" ]; then
                        TARGET_BRANCH="<+trigger.targetBranch>"
                        
                        # Feature/fix branches must target develop
                        if [[ "$TARGET_BRANCH" != "develop" ]]; then
                          echo "❌ ERROR: Feature branches must target 'develop'"
                          echo "Current target: $TARGET_BRANCH"
                          exit 1
                        fi
                        
                        echo "✅ Base branch validation passed"
                      else
                        echo "ℹ️  Skipping base branch validation (not a PR)"
                      fi
              
              - step:
                  type: Run
                  name: Check Linear History
                  identifier: check_linear_history
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      # Check for merge commits in feature branch
                      MERGE_COMMITS=$(git log --oneline --merges origin/develop..HEAD | wc -l)
                      
                      if [ "$MERGE_COMMITS" -gt 0 ]; then
                        echo "❌ ERROR: Merge commits detected in feature branch"
                        echo "Feature branches must have linear history (use rebase)"
                        git log --oneline --merges origin/develop..HEAD
                        exit 1
                      fi
                      
                      echo "✅ Linear history verified"
              
              - step:
                  type: Run
                  name: Validate Commit Count
                  identifier: validate_commit_count
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      # Count commits ahead of develop
                      COMMIT_COUNT=$(git rev-list --count origin/develop..HEAD)
                      MAX_COMMITS=10
                      
                      echo "Commits in this branch: $COMMIT_COUNT"
                      
                      if [ "$COMMIT_COUNT" -gt "$MAX_COMMITS" ]; then
                        echo "⚠️  WARNING: $COMMIT_COUNT commits exceeds recommended $MAX_COMMITS"
                        echo "Consider squashing commits before merge"
                      else
                        echo "✅ Commit count within limits"
                      fi

    - stage:
        name: Build and Test
        identifier: build_and_test
        type: CI
        spec:
          cloneCodebase: true
          platform:
            os: Linux
            arch: Amd64
          runtime:
            type: Cloud  # Use Harness Cloud infrastructure
            spec: {}
          execution:
            steps:
              - step:
                  type: Run
                  name: Install Dependencies
                  identifier: install_deps
                  spec:
                    shell: Bash
                    command: |
                      # Example for Node.js
                      npm ci
                      
                      # Example for Python
                      # pip install -r requirements.txt
                      
                      # Example for Java/Maven
                      # mvn clean install -DskipTests
              
              - step:
                  type: Run
                  name: Lint Code
                  identifier: lint
                  spec:
                    shell: Bash
                    command: |
                      npm run lint
                      
                      # Python: flake8 . or pylint src/
                      # Java: mvn checkstyle:check
              
              - step:
                  type: Run
                  name: Run Unit Tests
                  identifier: unit_tests
                  spec:
                    shell: Bash
                    command: |
                      npm test -- --coverage
                      
                      # Python: pytest --cov=src tests/
                      # Java: mvn test
                  
                    reports:
                      type: JUnit
                      spec:
                        paths:
                          - "**/*.xml"
              
              - step:
                  type: BuildAndPushDockerRegistry
                  name: Build Docker Image
                  identifier: build_docker
                  spec:
                    connectorRef: dockerhub_connector
                    repo: your-org/your-app
                    tags:
                      - <+pipeline.sequenceId>
                      - feat-<+codebase.branch>
                    dockerfile: Dockerfile
                    context: .
                    labels:
                      git.branch: <+codebase.branch>
                      git.commit: <+codebase.commitSha>
                      git.flow.type: feature
              
              - step:
                  type: Run
                  name: Integration Tests
                  identifier: integration_tests
                  spec:
                    shell: Bash
                    command: |
                      # Start test containers if needed
                      docker-compose -f docker-compose.test.yml up -d
                      
                      # Run integration tests
                      npm run test:integration
                      
                      # Cleanup
                      docker-compose -f docker-compose.test.yml down
              
              - step:
                  type: Security
                  name: Container Security Scan
                  identifier: container_scan
                  spec:
                    privileged: true
                    settings:
                      product_name: aqua-trivy
                      product_config_name: default
                      policy_type: orchestratedScan
                      scan_type: container
                      container_type: docker_v2
                      container_domain: docker.io
                      container_project: your-org
                      container_tag: feat-<+codebase.branch>
                      fail_on_severity: high

    - stage:
        name: Optional Preview Deployment
        identifier: preview_deploy
        type: Deployment
        spec:
          deploymentType: Kubernetes
          service:
            serviceRef: backend_service
            serviceInputs:
              serviceDefinition:
                type: Kubernetes
                spec:
                  artifacts:
                    primary:
                      primaryArtifactRef: <+input>
                      sources:
                        - identifier: docker_image
                          type: DockerRegistry
                          spec:
                            tag: feat-<+codebase.branch>
          environment:
            environmentRef: preview
            deployToAll: false
            infrastructureDefinitions:
              - identifier: preview_k8s
          execution:
            steps:
              - step:
                  type: K8sRollingDeploy
                  name: Rolling Deployment
                  identifier: rolling_deploy
                  spec:
                    skipDryRun: false
                    pruningEnabled: false
            rollbackSteps:
              - step:
                  type: K8sRollingRollback
                  name: Rollback Deployment
                  identifier: rollback
        when:
          condition: <+pipeline.variables.enablePreview> == "true"
          pipelineStatus: Success

  notificationRules:
    - name: Notify on Failure
      identifier: notify_failure
      pipelineEvents:
        - type: PipelineFailed
      notificationMethod:
        type: Slack
        spec:
          userGroups: []
          webhookUrl: <+secrets.getValue("slack_webhook")>
          template: |
            Feature Pipeline Failed
            Branch: <+codebase.branch>
            Commit: <+codebase.commitSha>
            URL: <+pipeline.executionUrl>

  variables:
    - name: enablePreview
      type: String
      description: Deploy to preview environment
      required: false
      value: "false"
```

#### Template 2: Develop Branch Pipeline

**File**: `.harness/pipelines/develop-deploy.yaml`

```yaml
pipeline:
  name: Develop Branch Deploy
  identifier: develop_deploy
  projectIdentifier: backend_services
  orgIdentifier: mycompany
  tags:
    git_flow: develop
  properties:
    ci:
      codebase:
        connectorRef: github_prod
        repoName: your-org/your-repo
        build:
          type: branch
          spec:
            branch: develop
  stages:
    - stage:
        name: Build and Test
        identifier: build_test
        type: CI
        spec:
          cloneCodebase: true
          platform:
            os: Linux
            arch: Amd64
          runtime:
            type: Cloud
            spec: {}
          execution:
            steps:
              - step:
                  type: Run
                  name: Install Dependencies
                  identifier: install
                  spec:
                    shell: Bash
                    command: npm ci
              
              - step:
                  type: Run
                  name: Run All Tests
                  identifier: test
                  spec:
                    shell: Bash
                    command: |
                      npm run test:all
                      npm run test:e2e
              
              - step:
                  type: BuildAndPushDockerRegistry
                  name: Build and Push
                  identifier: build_push
                  spec:
                    connectorRef: dockerhub_connector
                    repo: your-org/your-app
                    tags:
                      - develop-<+pipeline.sequenceId>
                      - develop-latest
                    dockerfile: Dockerfile

    - stage:
        name: Deploy to Dev Environment
        identifier: deploy_dev
        type: Deployment
        spec:
          deploymentType: Kubernetes
          service:
            serviceRef: backend_service
          environment:
            environmentRef: development
            infrastructureDefinitions:
              - identifier: dev_k8s
          execution:
            steps:
              - step:
                  type: K8sRollingDeploy
                  name: Deploy to Dev
                  identifier: deploy
            rollbackSteps:
              - step:
                  type: K8sRollingRollback
                  name: Rollback
                  identifier: rollback

    - stage:
        name: Smoke Tests
        identifier: smoke_tests
        type: CI
        spec:
          cloneCodebase: false
          execution:
            steps:
              - step:
                  type: Run
                  name: Health Check
                  identifier: health_check
                  spec:
                    shell: Bash
                    command: |
                      # Wait for deployment
                      sleep 30
                      
                      # Check health endpoint
                      curl -f https://dev.example.com/health || exit 1
              
              - step:
                  type: Run
                  name: API Tests
                  identifier: api_tests
                  spec:
                    shell: Bash
                    command: |
                      # Run Postman/Newman tests
                      newman run postman_collection.json \
                        --environment dev.postman_environment.json
```

#### Template 3: Release Branch Pipeline

**File**: `.harness/pipelines/release-pipeline.yaml`

```yaml
pipeline:
  name: Release Pipeline
  identifier: release_pipeline
  projectIdentifier: backend_services
  orgIdentifier: mycompany
  tags:
    git_flow: release
  properties:
    ci:
      codebase:
        connectorRef: github_prod
        build:
          type: branch
          spec:
            branch: <+trigger.branch>
  stages:
    - stage:
        name: Validate Release
        identifier: validate_release
        type: CI
        spec:
          cloneCodebase: true
          execution:
            steps:
              - step:
                  type: Run
                  name: Validate Release Branch
                  identifier: validate
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      BRANCH="<+codebase.branch>"
                      
                      # Validate release branch format (Git Flow: version numbers only, NO JIRA ID)
                      if [[ ! "$BRANCH" =~ ^release-[0-9]+(\.[0-9]+)*(-[a-zA-Z0-9._-]+)?$ ]]; then
                        echo "❌ Invalid release branch format"
                        echo "Expected: release-X.Y.Z (e.g., release-1.2.3, release-2.0.0-rc1)"
                        echo "Note: NO JIRA ID required per Git Flow"
                        exit 1
                      fi
                      
                      # Extract version
                      VERSION=$(echo "$BRANCH" | grep -oP '(\d+\.\d+\.\d+)')
                      echo "Release version: $VERSION"
                      
                      # Check if version already exists as tag
                      if git tag | grep -q "^v$VERSION$"; then
                        echo "❌ Version $VERSION already tagged"
                        exit 1
                      fi
                      
                      echo "✅ Release branch validated"

    - stage:
        name: Build Release Candidate
        identifier: build_rc
        type: CI
        spec:
          cloneCodebase: true
          platform:
            os: Linux
            arch: Amd64
          runtime:
            type: Cloud
            spec: {}
          execution:
            steps:
              - step:
                  type: Run
                  name: Update Version Numbers
                  identifier: update_version
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      
                      # Extract version from branch name
                      BRANCH="<+codebase.branch>"
                      VERSION=$(echo "$BRANCH" | grep -oP '(\d+\.\d+\.\d+)')
                      
                      echo "Updating to version: $VERSION"
                      
                      # Update package.json (Node.js)
                      if [ -f "package.json" ]; then
                        npm version $VERSION --no-git-tag-version
                      fi
                      
                      # Update pyproject.toml (Python)
                      if [ -f "pyproject.toml" ]; then
                        sed -i "s/^version = .*/version = \"$VERSION\"/" pyproject.toml
                      fi
                      
                      # Commit version bump
                      git config user.name "Harness CI"
                      git config user.email "ci@harness.io"
                      git add -A
                      git commit -m "chore: bump version to $VERSION" || true
              
              - step:
                  type: Run
                  name: Generate Changelog
                  identifier: generate_changelog
                  spec:
                    shell: Bash
                    command: |
                      # Generate changelog from commits since last release
                      LAST_TAG=$(git describe --tags --abbrev=0 develop 2>/dev/null || echo "")
                      
                      if [ -n "$LAST_TAG" ]; then
                        echo "# Changelog" > CHANGELOG_RELEASE.md
                        echo "" >> CHANGELOG_RELEASE.md
                        echo "## Version $VERSION" >> CHANGELOG_RELEASE.md
                        echo "" >> CHANGELOG_RELEASE.md
                        
                        # Group by commit type
                        echo "### Features" >> CHANGELOG_RELEASE.md
                        git log $LAST_TAG..HEAD --oneline --grep="^feat:" | \
                          sed 's/^/- /' >> CHANGELOG_RELEASE.md
                        
                        echo "" >> CHANGELOG_RELEASE.md
                        echo "### Bug Fixes" >> CHANGELOG_RELEASE.md
                        git log $LAST_TAG..HEAD --oneline --grep="^fix:" | \
                          sed 's/^/- /' >> CHANGELOG_RELEASE.md
                      fi
                      
                      cat CHANGELOG_RELEASE.md
              
              - step:
                  type: Run
                  name: Full Test Suite
                  identifier: full_tests
                  spec:
                    shell: Bash
                    command: |
                      npm ci
                      npm run test:all
                      npm run test:e2e
                      npm run test:integration
              
              - step:
                  type: BuildAndPushDockerRegistry
                  name: Build Release Candidate
                  identifier: build_rc_image
                  spec:
                    connectorRef: dockerhub_connector
                    repo: your-org/your-app
                    tags:
                      - <+pipeline.variables.version>-rc.<+pipeline.sequenceId>
                      - release-candidate
                    dockerfile: Dockerfile
                    labels:
                      version: <+pipeline.variables.version>
                      git.flow.type: release

    - stage:
        name: Deploy to Staging
        identifier: deploy_staging
        type: Deployment
        spec:
          deploymentType: Kubernetes
          service:
            serviceRef: backend_service
            serviceInputs:
              serviceDefinition:
                spec:
                  artifacts:
                    primary:
                      sources:
                        - identifier: docker_image
                          type: DockerRegistry
                          spec:
                            tag: <+pipeline.variables.version>-rc.<+pipeline.sequenceId>
          environment:
            environmentRef: staging
            infrastructureDefinitions:
              - identifier: staging_k8s
          execution:
            steps:
              - step:
                  type: K8sRollingDeploy
                  name: Deploy to Staging
                  identifier: deploy
                  spec:
                    skipDryRun: false
            rollbackSteps:
              - step:
                  type: K8sRollingRollback
                  name: Rollback
                  identifier: rollback

    - stage:
        name: Release Testing
        identifier: release_testing
        type: CI
        spec:
          cloneCodebase: false
          execution:
            steps:
              - step:
                  type: Run
                  name: Regression Tests
                  identifier: regression
                  spec:
                    shell: Bash
                    command: |
                      # Run comprehensive regression test suite
                      newman run regression_tests.json \
                        --environment staging.postman_environment.json \
                        --reporters cli,junit \
                        --reporter-junit-export results.xml
              
              - step:
                  type: Run
                  name: Performance Tests
                  identifier: performance
                  spec:
                    shell: Bash
                    command: |
                      # Run load tests
                      k6 run --out json=results.json performance-tests.js
              
              - step:
                  type: Run
                  name: Security Scan
                  identifier: security_scan
                  spec:
                    shell: Bash
                    command: |
                      # OWASP ZAP scan
                      docker run -t owasp/zap2docker-stable \
                        zap-baseline.py \
                        -t https://staging.example.com \
                        -r zap_report.html

    - stage:
        name: Manual QA Approval
        identifier: qa_approval
        type: Approval
        spec:
          execution:
            steps:
              - step:
                  type: HarnessApproval
                  name: QA Sign-off
                  identifier: qa_signoff
                  spec:
                    approvalMessage: |
                      Release <+pipeline.variables.version> is ready for QA approval.
                      
                      Staging URL: https://staging.example.com
                      Changelog: View in pipeline artifacts
                      
                      Please verify all features and bug fixes before approving.
                    includePipelineExecutionHistory: true
                    approvers:
                      userGroups:
                        - qa_team
                        - product_owners
                      minimumCount: 2
                    approverInputs:
                      - name: test_results
                        type: String
                        description: Summary of test results
                      - name: blockers
                        type: String
                        description: Any blocking issues found

  variables:
    - name: version
      type: String
      description: Release version (extracted from branch)
      required: true
      value: <+pipeline.stages.validate_release.spec.execution.steps.validate.output.outputVariables.VERSION>

  notificationRules:
    - name: Notify Release Ready
      identifier: notify_ready
      pipelineEvents:
        - type: StageSuccess
          forStages:
            - qa_approval
      notificationMethod:
        type: Slack
        spec:
          webhookUrl: <+secrets.getValue("slack_webhook")>
          template: |
            ✅ Release <+pipeline.variables.version> approved for production
            
            Approvers: <+pipeline.stages.qa_approval.spec.execution.steps.qa_signoff.output.approvers>
            Next: Merge release branch to main
```

#### Template 4: Main Branch Deployment Pipeline

**File**: `.harness/pipelines/main-deploy.yaml`

```yaml
pipeline:
  name: Production Deployment
  identifier: production_deploy
  projectIdentifier: backend_services
  orgIdentifier: mycompany
  tags:
    git_flow: main
    environment: production
  properties:
    ci:
      codebase:
        connectorRef: github_prod
        build:
          type: branch
          spec:
            branch: main
  stages:
    - stage:
        name: Validate Production Tag
        identifier: validate_tag
        type: CI
        spec:
          cloneCodebase: true
          execution:
            steps:
              - step:
                  type: Run
                  name: Check Version Tag
                  identifier: check_tag
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      # Get latest tag on main
                      LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "none")
                      
                      if [ "$LATEST_TAG" = "none" ]; then
                        echo "⚠️  No tags found on main branch"
                        echo "This might be the first release"
                      else
                        echo "Latest production version: $LATEST_TAG"
                      fi
                      
                      # Validate semantic versioning
                      if [[ ! "$LATEST_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                        echo "⚠️  Tag format warning: Expected vX.Y.Z"
                      fi

    - stage:
        name: Build Production Image
        identifier: build_prod
        type: CI
        spec:
          cloneCodebase: true
          platform:
            os: Linux
            arch: Amd64
          runtime:
            type: Cloud
            spec: {}
          execution:
            steps:
              - step:
                  type: Run
                  name: Extract Version
                  identifier: extract_version
                  spec:
                    shell: Bash
                    command: |
                      # Get version from git tag
                      VERSION=$(git describe --tags --abbrev=0 | sed 's/^v//')
                      echo "Production version: $VERSION"
                      
                      # Export as output variable
                      echo "VERSION=$VERSION" >> $HARNESS_ENV
              
              - step:
                  type: BuildAndPushDockerRegistry
                  name: Build Production Image
                  identifier: build_prod_image
                  spec:
                    connectorRef: dockerhub_connector
                    repo: your-org/your-app
                    tags:
                      - <+pipeline.stages.build_prod.spec.execution.steps.extract_version.output.outputVariables.VERSION>
                      - latest
                      - production
                    dockerfile: Dockerfile
                    optimize: true  # Use caching for faster builds
                    labels:
                      version: <+pipeline.stages.build_prod.spec.execution.steps.extract_version.output.outputVariables.VERSION>
                      environment: production
                      git.commit: <+codebase.commitSha>
                      git.flow.type: main

    - stage:
        name: Pre-Production Checks
        identifier: pre_prod_checks
        type: CI
        spec:
          cloneCodebase: false
          execution:
            steps:
              - step:
                  type: Run
                  name: Verify Staging Health
                  identifier: verify_staging
                  spec:
                    shell: Bash
                    command: |
                      # Ensure staging is healthy before production
                      curl -f https://staging.example.com/health || {
                        echo "❌ Staging environment unhealthy"
                        exit 1
                      }
              
              - step:
                  type: Security
                  name: Final Security Scan
                  identifier: final_security
                  spec:
                    privileged: true
                    settings:
                      product_name: aqua-trivy
                      product_config_name: default
                      scan_type: container
                      fail_on_severity: critical

    - stage:
        name: Production Approval
        identifier: prod_approval
        type: Approval
        spec:
          execution:
            steps:
              - step:
                  type: HarnessApproval
                  name: Production Deployment Approval
                  identifier: prod_deploy_approval
                  spec:
                    approvalMessage: |
                      🚀 PRODUCTION DEPLOYMENT REQUEST
                      
                      Version: <+pipeline.stages.build_prod.spec.execution.steps.extract_version.output.outputVariables.VERSION>
                      Commit: <+codebase.commitSha>
                      Docker Image: your-org/your-app:<+pipeline.stages.build_prod.spec.execution.steps.extract_version.output.outputVariables.VERSION>
                      
                      ⚠️  This will deploy to PRODUCTION environment
                      
                      Approval required from at least 2 team leads.
                    includePipelineExecutionHistory: true
                    approvers:
                      userGroups:
                        - engineering_leads
                        - platform_team
                      minimumCount: 2
                    approverInputs:
                      - name: deployment_window
                        type: String
                        description: Scheduled deployment time
                      - name: rollback_plan
                        type: String
                        description: Rollback strategy if issues occur

    - stage:
        name: Deploy to Production
        identifier: deploy_production
        type: Deployment
        spec:
          deploymentType: Kubernetes
          service:
            serviceRef: backend_service
            serviceInputs:
              serviceDefinition:
                spec:
                  artifacts:
                    primary:
                      sources:
                        - identifier: docker_image
                          type: DockerRegistry
                          spec:
                            tag: <+pipeline.stages.build_prod.spec.execution.steps.extract_version.output.outputVariables.VERSION>
          environment:
            environmentRef: production
            infrastructureDefinitions:
              - identifier: prod_k8s
          execution:
            steps:
              - step:
                  type: K8sBlueGreenDeploy
                  name: Blue-Green Deployment
                  identifier: bg_deploy
                  spec:
                    skipDryRun: false
                    pruningEnabled: false
              
              - step:
                  type: ShellScript
                  name: Smoke Tests
                  identifier: smoke_tests
                  spec:
                    shell: Bash
                    source:
                      type: Inline
                      spec:
                        script: |
                          # Wait for pods to be ready
                          sleep 60
                          
                          # Health check
                          curl -f https://api.example.com/health || exit 1
                          
                          # Basic API tests
                          curl -f https://api.example.com/v1/status || exit 1
                    onDelegate: false
              
              - step:
                  type: K8sBGSwapServices
                  name: Swap Traffic to New Version
                  identifier: swap_services
                  spec:
                    skipDryRun: false
            
            rollbackSteps:
              - step:
                  type: K8sBlueGreenRollback
                  name: Rollback Blue-Green
                  identifier: bg_rollback

    - stage:
        name: Post-Deployment Verification
        identifier: post_deploy_verify
        type: CI
        spec:
          cloneCodebase: false
          execution:
            steps:
              - step:
                  type: Run
                  name: Comprehensive Health Check
                  identifier: health_check
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      echo "Running post-deployment health checks..."
                      
                      # Check main API endpoints
                      curl -f https://api.example.com/health
                      curl -f https://api.example.com/v1/status
                      
                      # Check database connectivity
                      curl -f https://api.example.com/v1/db/ping
                      
                      # Check external integrations
                      curl -f https://api.example.com/v1/integrations/status
                      
                      echo "✅ All health checks passed"
              
              - step:
                  type: Run
                  name: Monitor Metrics
                  identifier: monitor_metrics
                  spec:
                    shell: Bash
                    command: |
                      # Query Prometheus/Datadog for error rates
                      # Alert if error rate exceeds threshold
                      
                      echo "Monitoring deployment metrics for 5 minutes..."
                      sleep 300
                      
                      # Check error rate from monitoring system
                      # (Pseudo-code - adapt to your monitoring)
                      ERROR_RATE=$(curl -s 'http://prometheus:9090/api/v1/query?query=rate(http_errors[5m])' | jq '.data.result[0].value[1]')
                      
                      if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
                        echo "❌ Error rate too high: $ERROR_RATE"
                        exit 1
                      fi
                      
                      echo "✅ Metrics look good"

  notificationRules:
    - name: Notify Production Deployment Success
      identifier: notify_success
      pipelineEvents:
        - type: PipelineSuccess
      notificationMethod:
        type: Slack
        spec:
          userGroups:
            - engineering_team
            - product_team
          webhookUrl: <+secrets.getValue("slack_webhook")>
          template: |
            ✅ 🎉 PRODUCTION DEPLOYMENT SUCCESSFUL
            
            Version: <+pipeline.stages.build_prod.spec.execution.steps.extract_version.output.outputVariables.VERSION>
            Pipeline: <+pipeline.executionUrl>
            Deployed by: <+pipeline.triggeredBy.name>
            Time: <+pipeline.startTs>
    
    - name: Notify Production Deployment Failure
      identifier: notify_failure
      pipelineEvents:
        - type: PipelineFailed
      notificationMethod:
        type: Slack
        spec:
          userGroups:
            - oncall_team
            - engineering_leads
          webhookUrl: <+secrets.getValue("slack_webhook_critical")>
          template: |
            🚨 PRODUCTION DEPLOYMENT FAILED
            
            Version: <+pipeline.stages.build_prod.spec.execution.steps.extract_version.output.outputVariables.VERSION>
            Failed Stage: <+pipeline.failedStage.name>
            Pipeline: <+pipeline.executionUrl>
            
            @oncall Please investigate immediately!
```

#### Template 5: Hotfix Pipeline

**File**: `.harness/pipelines/hotfix-pipeline.yaml`

```yaml
pipeline:
  name: Hotfix Pipeline
  identifier: hotfix_pipeline
  projectIdentifier: backend_services
  orgIdentifier: mycompany
  tags:
    git_flow: hotfix
    priority: critical
  properties:
    ci:
      codebase:
        connectorRef: github_prod
        build:
          type: branch
          spec:
            branch: <+trigger.branch>
  stages:
    - stage:
        name: Validate Hotfix
        identifier: validate_hotfix
        type: CI
        spec:
          cloneCodebase: true
          execution:
            steps:
              - step:
                  type: Run
                  name: Validate Hotfix Branch
                  identifier: validate
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      BRANCH="<+codebase.branch>"
                      
                      # Validate hotfix branch format
                      if [[ ! "$BRANCH" =~ ^hotfix-[A-Z]+-[0-9]+-[a-z0-9-]+$ ]]; then
                        echo "❌ Invalid hotfix branch format"
                        echo "Expected: hotfix-JIRA-123-description"
                        exit 1
                      fi
                      
                      # Verify base is main
                      MERGE_BASE=$(git merge-base HEAD origin/main)
                      MAIN_HEAD=$(git rev-parse origin/main)
                      
                      if [ "$MERGE_BASE" != "$MAIN_HEAD" ]; then
                        echo "❌ Hotfix must be based on main branch"
                        exit 1
                      fi
                      
                      echo "✅ Hotfix branch validated"

    - stage:
        name: Expedited Build and Test
        identifier: expedited_build
        type: CI
        spec:
          cloneCodebase: true
          platform:
            os: Linux
            arch: Amd64
          runtime:
            type: Cloud
            spec: {}
          execution:
            steps:
              - step:
                  type: Run
                  name: Critical Tests Only
                  identifier: critical_tests
                  spec:
                    shell: Bash
                    command: |
                      npm ci
                      
                      # Run only critical/affected tests
                      npm run test:critical
                      npm run test:affected
              
              - step:
                  type: BuildAndPushDockerRegistry
                  name: Build Hotfix Image
                  identifier: build_hotfix
                  spec:
                    connectorRef: dockerhub_connector
                    repo: your-org/your-app
                    tags:
                      - hotfix-<+pipeline.sequenceId>
                      - <+codebase.branch>
                    dockerfile: Dockerfile
                    labels:
                      git.flow.type: hotfix
                      priority: critical

    - stage:
        name: Hotfix Approval
        identifier: hotfix_approval
        type: Approval
        spec:
          execution:
            steps:
              - step:
                  type: HarnessApproval
                  name: Emergency Approval
                  identifier: emergency_approval
                  spec:
                    approvalMessage: |
                      🚨 HOTFIX DEPLOYMENT REQUEST
                      
                      Branch: <+codebase.branch>
                      Issue: Critical production bug
                      
                      This is an expedited hotfix deployment.
                      Minimum 1 approval required from oncall team.
                    includePipelineExecutionHistory: true
                    approvers:
                      userGroups:
                        - oncall_team
                        - engineering_leads
                      minimumCount: 1
                    approverInputs:
                      - name: severity
                        type: String
                        description: Bug severity (critical/high)
                      - name: impact
                        type: String
                        description: User impact description
                    timeout: 30m  # Expedited timeout

    - stage:
        name: Deploy Hotfix to Production
        identifier: deploy_hotfix
        type: Deployment
        spec:
          deploymentType: Kubernetes
          service:
            serviceRef: backend_service
          environment:
            environmentRef: production
            infrastructureDefinitions:
              - identifier: prod_k8s
          execution:
            steps:
              - step:
                  type: K8sCanaryDeploy
                  name: Canary Deploy (10%)
                  identifier: canary_10
                  spec:
                    instanceSelection:
                      type: Count
                      spec:
                        count: 1
                    skipDryRun: false
              
              - step:
                  type: ShellScript
                  name: Monitor Canary
                  identifier: monitor_canary
                  spec:
                    shell: Bash
                    source:
                      type: Inline
                      spec:
                        script: |
                          # Monitor canary for 5 minutes
                          sleep 300
                          
                          # Check error rates
                          # (Integrate with your monitoring)
                          echo "Checking canary health..."
              
              - step:
                  type: K8sCanaryDeploy
                  name: Canary Deploy (50%)
                  identifier: canary_50
                  spec:
                    instanceSelection:
                      type: Percentage
                      spec:
                        percentage: 50
              
              - step:
                  type: K8sCanaryDeploy
                  name: Full Deployment
                  identifier: full_deploy
                  spec:
                    instanceSelection:
                      type: Percentage
                      spec:
                        percentage: 100
            
            rollbackSteps:
              - step:
                  type: K8sCanaryRollback
                  name: Rollback Hotfix
                  identifier: rollback

    - stage:
        name: Post-Hotfix Verification
        identifier: post_hotfix_verify
        type: CI
        spec:
          cloneCodebase: false
          execution:
            steps:
              - step:
                  type: Run
                  name: Verify Fix
                  identifier: verify_fix
                  spec:
                    shell: Bash
                    command: |
                      # Verify the hotfix resolved the issue
                      echo "Verifying hotfix effectiveness..."
                      
                      # Run specific tests for the bug
                      # Check monitoring dashboards
                      # Confirm user reports
              
              - step:
                  type: Run
                  name: Create Incident Report
                  identifier: incident_report
                  spec:
                    shell: Bash
                    command: |
                      # Generate incident report
                      cat > incident_report.md <<EOF
                      # Hotfix Incident Report
                      
                      **Hotfix Branch:** <+codebase.branch>
                      **Deployed:** $(date)
                      **Severity:** Critical
                      
                      ## Issue Description
                      [Auto-populated from JIRA]
                      
                      ## Resolution
                      Hotfix deployed to production
                      
                      ## Next Steps
                      - [ ] Merge hotfix to develop
                      - [ ] Update release notes
                      - [ ] Conduct post-mortem
                      EOF

  notificationRules:
    - name: Notify Hotfix Deployment
      identifier: notify_hotfix
      pipelineEvents:
        - type: PipelineSuccess
      notificationMethod:
        type: Slack
        spec:
          userGroups:
            - oncall_team
            - engineering_team
          webhookUrl: <+secrets.getValue("slack_webhook_critical")>
          template: |
            ✅ HOTFIX DEPLOYED TO PRODUCTION
            
            Branch: <+codebase.branch>
            Pipeline: <+pipeline.executionUrl>
            Deployed by: <+pipeline.triggeredBy.name>
            
            Next: Merge hotfix to develop branch
```

### Harness Git Flow Automation Pipelines

Complete automation for version bumping, release creation, and merging back to develop.

#### Pipeline: Automatic Version Bump and Release

```yaml
# .harness/pipelines/auto-release.yaml
pipeline:
  name: Automatic Release Creation
  identifier: auto_release_creation
  projectIdentifier: backend_services
  orgIdentifier: mycompany
  tags:
    automation: release
    git_flow: main
  properties:
    ci:
      codebase:
        connectorRef: github_prod
        repoName: your-org/your-repo
        build:
          type: branch
          spec:
            branch: main
  stages:
    - stage:
        name: Analyze and Create Release
        identifier: analyze_create_release
        type: CI
        spec:
          cloneCodebase: true
          execution:
            steps:
              - step:
                  type: Run
                  name: Setup Git
                  identifier: setup_git
                  spec:
                    shell: Bash
                    command: |
                      git config user.name "harness-automation"
                      git config user.email "automation@harness.io"
                      git fetch --all --tags
              
              - step:
                  type: Run
                  name: Get Latest Tag
                  identifier: get_latest_tag
                  spec:
                    shell: Bash
                    command: |
                      LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
                      echo "LATEST_TAG=$LATEST_TAG" >> $HARNESS_ENV
                      echo "Latest release: $LATEST_TAG"
              
              - step:
                  type: Run
                  name: Analyze Commits for Version Bump
                  identifier: analyze_version_bump
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      PREV_TAG=$LATEST_TAG
                      COMMITS=$(git log $PREV_TAG..HEAD --pretty=format:"%s")
                      
                      echo "Commits since $PREV_TAG:"
                      echo "$COMMITS"
                      echo ""
                      
                      # Determine bump type
                      if echo "$COMMITS" | grep -qE '^(feat|feature)(\(.+\))?!:|^BREAKING CHANGE:'; then
                        BUMP_TYPE="major"
                        echo "🚨 Breaking changes detected → MAJOR version bump"
                      elif echo "$COMMITS" | grep -qE '^(feat|feature)(\(.+\))?:'; then
                        BUMP_TYPE="minor"
                        echo "✨ New features detected → MINOR version bump"
                      else
                        BUMP_TYPE="patch"
                        echo "🐛 Bug fixes only → PATCH version bump"
                      fi
                      
                      echo "BUMP_TYPE=$BUMP_TYPE" >> $HARNESS_ENV
              
              - step:
                  type: Run
                  name: Calculate New Version
                  identifier: calculate_new_version
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      CURRENT_VERSION=${LATEST_TAG#v}
                      IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"
                      
                      case "$BUMP_TYPE" in
                        major)
                          MAJOR=$((MAJOR + 1))
                          MINOR=0
                          PATCH=0
                          ;;
                        minor)
                          MINOR=$((MINOR + 1))
                          PATCH=0
                          ;;
                        patch)
                          PATCH=$((PATCH + 1))
                          ;;
                      esac
                      
                      NEW_VERSION="$MAJOR.$MINOR.$PATCH"
                      echo "NEW_VERSION=$NEW_VERSION" >> $HARNESS_ENV
                      echo "📦 New version: v$NEW_VERSION"
              
              - step:
                  type: Run
                  name: Update Version Files
                  identifier: update_version_files
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      echo "Updating version to $NEW_VERSION in project files..."
                      
                      # Update package.json
                      if [ -f "package.json" ]; then
                        sed -i "s/\"version\": \".*\"/\"version\": \"$NEW_VERSION\"/" package.json
                        echo "✓ Updated package.json"
                      fi
                      
                      # Update pyproject.toml
                      if [ -f "pyproject.toml" ]; then
                        sed -i "s/version = \".*\"/version = \"$NEW_VERSION\"/" pyproject.toml
                        echo "✓ Updated pyproject.toml"
                      fi
                      
                      # Update Cargo.toml
                      if [ -f "Cargo.toml" ]; then
                        sed -i "s/version = \".*\"/version = \"$NEW_VERSION\"/" Cargo.toml
                        echo "✓ Updated Cargo.toml"
                      fi
                      
                      # Update pom.xml (Maven)
                      if [ -f "pom.xml" ]; then
                        sed -i "s/<version>.*<\/version>/<version>$NEW_VERSION<\/version>/" pom.xml
                        echo "✓ Updated pom.xml"
                      fi
                      
                      # Create/Update VERSION file
                      echo "$NEW_VERSION" > VERSION
                      echo "✓ Updated VERSION file"
              
              - step:
                  type: Run
                  name: Generate Changelog
                  identifier: generate_changelog
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      CHANGELOG_FILE="release-notes-$NEW_VERSION.md"
                      
                      cat > $CHANGELOG_FILE <<EOF
                      # Release v$NEW_VERSION
                      
                      Released on $(date +%Y-%m-%d)
                      
                      ## Changes Since $LATEST_TAG
                      
                      EOF
                      
                      # Features
                      echo "### ✨ Features" >> $CHANGELOG_FILE
                      git log $LATEST_TAG..HEAD --pretty=format:"- %s (%an)" --grep="^feat" --grep="^feature" >> $CHANGELOG_FILE || echo "No new features" >> $CHANGELOG_FILE
                      echo "" >> $CHANGELOG_FILE
                      
                      # Bug Fixes
                      echo "### 🐛 Bug Fixes" >> $CHANGELOG_FILE
                      git log $LATEST_TAG..HEAD --pretty=format:"- %s (%an)" --grep="^fix" >> $CHANGELOG_FILE || echo "No bug fixes" >> $CHANGELOG_FILE
                      echo "" >> $CHANGELOG_FILE
                      
                      # Documentation
                      echo "### 📚 Documentation" >> $CHANGELOG_FILE
                      git log $LATEST_TAG..HEAD --pretty=format:"- %s (%an)" --grep="^docs" >> $CHANGELOG_FILE || echo "No documentation changes" >> $CHANGELOG_FILE
                      echo "" >> $CHANGELOG_FILE
                      
                      # Performance
                      echo "### ⚡ Performance" >> $CHANGELOG_FILE
                      git log $LATEST_TAG..HEAD --pretty=format:"- %s (%an)" --grep="^perf" >> $CHANGELOG_FILE || echo "No performance improvements" >> $CHANGELOG_FILE
                      echo "" >> $CHANGELOG_FILE
                      
                      # Other
                      echo "### 🔧 Maintenance" >> $CHANGELOG_FILE
                      git log $LATEST_TAG..HEAD --pretty=format:"- %s (%an)" --grep="^chore" --grep="^refactor" >> $CHANGELOG_FILE || echo "No maintenance changes" >> $CHANGELOG_FILE
                      
                      echo "CHANGELOG_FILE=$CHANGELOG_FILE" >> $HARNESS_ENV
                      
                      echo "📝 Generated changelog:"
                      cat $CHANGELOG_FILE
              
              - step:
                  type: Run
                  name: Create and Push Git Tag
                  identifier: create_push_tag
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      TAG_NAME="v$NEW_VERSION"
                      
                      # Create annotated tag with changelog
                      git tag -a "$TAG_NAME" -F "$CHANGELOG_FILE"
                      
                      # Push tag using secret token
                      git push https://<+secrets.getValue("github_token")>@github.com/<+codebase.repoName>.git "$TAG_NAME"
                      
                      echo "✅ Created and pushed tag: $TAG_NAME"
              
              - step:
                  type: Run
                  name: Create GitHub Release
                  identifier: create_github_release
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      # Using GitHub CLI
                      export GITHUB_TOKEN="<+secrets.getValue("github_token")>"
                      
                      gh release create "v$NEW_VERSION" \
                        --title "Release v$NEW_VERSION" \
                        --notes-file "$CHANGELOG_FILE" \
                        --repo "<+codebase.repoName>"
                      
                      echo "✅ GitHub Release created: v$NEW_VERSION"
              
              - step:
                  type: Run
                  name: Update CHANGELOG.md
                  identifier: update_changelog_file
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      # Prepend new release notes to CHANGELOG.md
                      if [ -f "CHANGELOG.md" ]; then
                        # Create temp file with new content first
                        cat "$CHANGELOG_FILE" > temp_changelog.md
                        echo "" >> temp_changelog.md
                        echo "---" >> temp_changelog.md
                        echo "" >> temp_changelog.md
                        cat CHANGELOG.md >> temp_changelog.md
                        mv temp_changelog.md CHANGELOG.md
                      else
                        # Create new CHANGELOG.md
                        cat > CHANGELOG.md <<EOF
                      # Changelog
                      
                      All notable changes to this project will be documented in this file.
                      
                      EOF
                        cat "$CHANGELOG_FILE" >> CHANGELOG.md
                      fi
                      
                      echo "✅ Updated CHANGELOG.md"
              
              - step:
                  type: Run
                  name: Commit Version Bump
                  identifier: commit_version_bump
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      # Add all changed files
                      git add -A
                      
                      # Commit changes
                      git commit -m "chore: release v$NEW_VERSION [skip ci]

Automated version bump and changelog update.

- Version: v$NEW_VERSION
- Bump type: $BUMP_TYPE
- Generated by: Harness Pipeline
"
                      
                      # Push to main
                      git push https://<+secrets.getValue("github_token")>@github.com/<+codebase.repoName>.git main
                      
                      echo "✅ Committed and pushed version bump"
    
    - stage:
        name: Notify Team
        identifier: notify_team
        type: Custom
        spec:
          execution:
            steps:
              - step:
                  type: ShellScript
                  name: Send Slack Notification
                  identifier: send_slack_notification
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      
                      # Send Slack notification
                      curl -X POST "<+secrets.getValue("slack_webhook_url")>" \
                        -H 'Content-Type: application/json' \
                        -d "{
                          \"text\": \"🚀 New Release Created\",
                          \"blocks\": [
                            {
                              \"type\": \"header\",
                              \"text\": {
                                \"type\": \"plain_text\",
                                \"text\": \"📦 Release v$NEW_VERSION\"
                              }
                            },
                            {
                              \"type\": \"section\",
                              \"fields\": [
                                {
                                  \"type\": \"mrkdwn\",
                                  \"text\": \"*Version:*\nv$NEW_VERSION\"
                                },
                                {
                                  \"type\": \"mrkdwn\",
                                  \"text\": \"*Type:*\n$BUMP_TYPE\"
                                },
                                {
                                  \"type\": \"mrkdwn\",
                                  \"text\": \"*Pipeline:*\n<+pipeline.executionUrl>\"
                                },
                                {
                                  \"type\": \"mrkdwn\",
                                  \"text\": \"*Branch:*\nmain\"
                                }
                              ]
                            },
                            {
                              \"type\": \"actions\",
                              \"elements\": [
                                {
                                  \"type\": \"button\",
                                  \"text\": {
                                    \"type\": \"plain_text\",
                                    \"text\": \"View Release\"
                                  },
                                  \"url\": \"https://github.com/<+codebase.repoName>/releases/tag/v$NEW_VERSION\"
                                },
                                {
                                  \"type\": \"button\",
                                  \"text\": {
                                    \"type\": \"plain_text\",
                                    \"text\": \"View Changelog\"
                                  },
                                  \"url\": \"https://github.com/<+codebase.repoName>/blob/main/CHANGELOG.md\"
                                }
                              ]
                            }
                          ]
                        }"
                      
                      echo "✅ Slack notification sent"
```

#### Pipeline: Automatic Merge Back to Develop

```yaml
# .harness/pipelines/auto-merge-to-develop.yaml
pipeline:
  name: Auto Merge Main to Develop
  identifier: auto_merge_main_to_develop
  projectIdentifier: backend_services
  orgIdentifier: mycompany
  tags:
    automation: merge
    git_flow: synchronization
  properties:
    ci:
      codebase:
        connectorRef: github_prod
        repoName: your-org/your-repo
        build:
          type: branch
          spec:
            branch: main
  stages:
    - stage:
        name: Merge to Develop
        identifier: merge_to_develop
        type: CI
        spec:
          cloneCodebase: true
          execution:
            steps:
              - step:
                  type: Run
                  name: Setup Git
                  identifier: setup_git
                  spec:
                    shell: Bash
                    command: |
                      git config user.name "harness-automation"
                      git config user.email "automation@harness.io"
                      git fetch --all
              
              - step:
                  type: Run
                  name: Checkout Develop
                  identifier: checkout_develop
                  spec:
                    shell: Bash
                    command: |
                      git checkout develop
                      git pull origin develop
                      echo "Current develop HEAD: $(git rev-parse HEAD)"
              
              - step:
                  type: Run
                  name: Merge Main into Develop
                  identifier: merge_main
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      echo "Attempting to merge main into develop..."
                      
                      if git merge origin/main --no-ff -m "chore: merge main into develop after release

Automated merge to keep develop in sync with production.

Triggered by: <+pipeline.triggeredBy.name>
Pipeline: <+pipeline.executionUrl>

[skip ci]
"; then
                        echo "MERGE_STATUS=success" >> $HARNESS_ENV
                        echo "✅ Merge successful"
                      else
                        echo "MERGE_STATUS=conflict" >> $HARNESS_ENV
                        echo "❌ Merge conflict detected"
                        git merge --abort
                        exit 1
                      fi
              
              - step:
                  type: Run
                  name: Push to Develop
                  identifier: push_develop
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      if [ "$MERGE_STATUS" = "success" ]; then
                        git push https://<+secrets.getValue("github_token")>@github.com/<+codebase.repoName>.git develop
                        echo "✅ Successfully pushed merge to develop"
                      else
                        echo "⚠️  Skipping push due to merge failure"
                        exit 1
                      fi
              
              - step:
                  type: Run
                  name: Verify Sync
                  identifier: verify_sync
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      
                      # Verify main commits are in develop
                      MAIN_HEAD=$(git rev-parse origin/main)
                      
                      if git merge-base --is-ancestor $MAIN_HEAD develop; then
                        echo "✅ Develop contains all main commits"
                        echo "Branches are in sync"
                      else
                        echo "⚠️  Warning: Develop may not contain all main commits"
                      fi
        
        when:
          pipelineStatus: Success
    
    - stage:
        name: Handle Merge Conflict
        identifier: handle_merge_conflict
        type: Custom
        when:
          pipelineStatus: Failure
        spec:
          execution:
            steps:
              - step:
                  type: ShellScript
                  name: Create Merge Conflict PR
                  identifier: create_conflict_pr
                  spec:
                    shell: Bash
                    command: |
                      #!/bin/bash
                      set -e
                      
                      export GITHUB_TOKEN="<+secrets.getValue("github_token")>"
                      
                      # Create a new branch for manual merge
                      MERGE_BRANCH="auto-merge-main-to-develop-$(date +%s)"
                      
                      git checkout -b $MERGE_BRANCH develop
                      
                      # Attempt merge again (will fail, but we'll push the branch)
                      git merge origin/main --no-ff || true
                      
                      # Push conflict branch
                      git push https://<+secrets.getValue("github_token")>@github.com/<+codebase.repoName>.git $MERGE_BRANCH
                      
                      # Create PR using GitHub CLI
                      gh pr create \
                        --repo "<+codebase.repoName>" \
                        --base develop \
                        --head $MERGE_BRANCH \
                        --title "🤖 [MANUAL RESOLUTION] Merge main → develop" \
                        --body "## ⚠️  Automatic Merge Failed
                      
                      The automatic merge from \`main\` to \`develop\` encountered conflicts and requires manual resolution.
                      
                      ### Context
                      - **Source Branch:** \`main\`
                      - **Target Branch:** \`develop\`
                      - **Trigger:** Release pushed to main
                      - **Pipeline:** <+pipeline.executionUrl>
                      
                      ### Resolution Steps
                      1. Checkout this branch: \`git checkout $MERGE_BRANCH\`
                      2. Resolve conflicts in the marked files
                      3. Stage resolved files: \`git add <resolved-files>\`
                      4. Complete merge: \`git commit\`
                      5. Push and merge this PR
                      
                      ### Alternative (Local Resolution)
                      \`\`\`bash
                      git fetch origin
                      git checkout develop
                      git merge origin/main
                      # Resolve conflicts
                      git add .
                      git commit
                      git push origin develop
                      \`\`\`
                      
                      /cc @release-team @dev-leads
                      " \
                        --label "merge-conflict" \
                        --label "automated" \
                        --label "high-priority"
                      
                      echo "✅ Created PR for manual conflict resolution"
              
              - step:
                  type: ShellScript
                  name: Notify Team of Conflict
                  identifier: notify_conflict
                  spec:
                    shell: Bash
                    command: |
                      curl -X POST "<+secrets.getValue("slack_webhook_url")>" \
                        -H 'Content-Type: application/json' \
                        -d "{
                          \"text\": \"⚠️  Merge Conflict: Manual Resolution Required\",
                          \"blocks\": [
                            {
                              \"type\": \"header\",
                              \"text\": {
                                \"type\": \"plain_text\",
                                \"text\": \"⚠️  Merge Conflict Detected\"
                              }
                            },
                            {
                              \"type\": \"section\",
                              \"text\": {
                                \"type\": \"mrkdwn\",
                                \"text\": \"Automatic merge from \`main\` to \`develop\` failed. A PR has been created for manual resolution.\"
                              }
                            },
                            {
                              \"type\": \"section\",
                              \"fields\": [
                                {
                                  \"type\": \"mrkdwn\",
                                  \"text\": \"*Pipeline:*\n<+pipeline.executionUrl>\"
                                },
                                {
                                  \"type\": \"mrkdwn\",
                                  \"text\": \"*Action Required:*\nResolve conflicts and merge PR\"
                                }
                              ]
                            }
                          ]
                        }"
```

### Harness Trigger Configurations

Triggers automate pipeline execution based on Git events (push, PR, tag).

#### Trigger 1: Feature Branch PR to Develop

**File**: `.harness/triggers/pr-feature-to-develop.yaml`

```yaml
trigger:
  name: PR Feature to Develop
  identifier: pr_feature_to_develop
  enabled: true
  orgIdentifier: mycompany
  projectIdentifier: backend_services
  pipelineIdentifier: feature_branch_ci
  source:
    type: Webhook
    spec:
      type: Github
      spec:
        type: PullRequest
        spec:
          connectorRef: github_prod
          autoAbortPreviousExecutions: true
          payloadConditions:
            - key: targetBranch
              operator: Equals
              value: develop
            - key: sourceBranch
              operator: Regex
              value: ^(feat|fix)-[A-Z]+-[0-9]+-.*$
          headerConditions: []
          repoName: your-org/your-repo
          actions:
            - Open
            - Reopen
            - Synchronize  # Trigger on new commits to PR
  inputSetRefs:
    - feature_default_inputs
  pipelineBranchName: <+trigger.sourceBranch>  # Use PR source branch
```

#### Trigger 2: Push to Develop Branch

**File**: `.harness/triggers/push-to-develop.yaml`

```yaml
trigger:
  name: Push to Develop
  identifier: push_to_develop
  enabled: true
  orgIdentifier: mycompany
  projectIdentifier: backend_services
  pipelineIdentifier: develop_deploy
  source:
    type: Webhook
    spec:
      type: Github
      spec:
        type: Push
        spec:
          connectorRef: github_prod
          autoAbortPreviousExecutions: false  # Don't abort, queue instead
          payloadConditions:
            - key: <+trigger.payload.ref>
              operator: Equals
              value: refs/heads/develop
          jexlCondition: <+trigger.event> == "push"
          repoName: your-org/your-repo
  inputSetRefs:
    - develop_inputs
```

#### Trigger 3: Release Branch Creation

**File**: `.harness/triggers/release-branch.yaml`

```yaml
trigger:
  name: Release Branch Workflow
  identifier: release_branch_trigger
  enabled: true
  orgIdentifier: mycompany
  projectIdentifier: backend_services
  pipelineIdentifier: release_pipeline
  source:
    type: Webhook
    spec:
      type: Github
      spec:
        type: Push
        spec:
          connectorRef: github_prod
          autoAbortPreviousExecutions: true
          payloadConditions:
            - key: <+trigger.payload.ref>
              operator: Regex
              value: ^refs/heads/release(-|/).*$
          repoName: your-org/your-repo
  inputSetRefs:
    - release_inputs
  pipelineBranchName: <+trigger.branch>
```

#### Trigger 4: Main Branch Deployment (Post-Merge)

**File**: `.harness/triggers/push-to-main.yaml`

```yaml
trigger:
  name: Push to Main (Production)
  identifier: push_to_main
  enabled: true
  orgIdentifier: mycompany
  projectIdentifier: backend_services
  pipelineIdentifier: production_deploy
  source:
    type: Webhook
    spec:
      type: Github
      spec:
        type: Push
        spec:
          connectorRef: github_prod
          autoAbortPreviousExecutions: false
          payloadConditions:
            - key: <+trigger.payload.ref>
              operator: Equals
              value: refs/heads/main
          # Optional: Only trigger if version tag exists
          jexlCondition: |
            <+trigger.payload.head_commit.message>.contains("Merge") && 
            <+trigger.payload.commits>.size() > 0
          repoName: your-org/your-repo
  inputSetRefs:
    - production_inputs
```

#### Trigger 5: Hotfix Branch Push

**File**: `.harness/triggers/hotfix-trigger.yaml`

```yaml
trigger:
  name: Hotfix Branch Trigger
  identifier: hotfix_trigger
  enabled: true
  orgIdentifier: mycompany
  projectIdentifier: backend_services
  pipelineIdentifier: hotfix_pipeline
  source:
    type: Webhook
    spec:
      type: Github
      spec:
        type: Push
        spec:
          connectorRef: github_prod
          autoAbortPreviousExecutions: true
          payloadConditions:
            - key: <+trigger.payload.ref>
              operator: Regex
              value: ^refs/heads/hotfix-.*$
          repoName: your-org/your-repo
  inputSetRefs:
    - hotfix_inputs
  pipelineBranchName: <+trigger.branch>
```

#### Trigger 6: Release PR to Main (Final Release Approval)

**File**: `.harness/triggers/pr-release-to-main.yaml`

```yaml
trigger:
  name: PR Release to Main
  identifier: pr_release_to_main
  enabled: true
  orgIdentifier: mycompany
  projectIdentifier: backend_services
  pipelineIdentifier: release_pipeline
  source:
    type: Webhook
    spec:
      type: Github
      spec:
        type: PullRequest
        spec:
          connectorRef: github_prod
          autoAbortPreviousExecutions: true
          payloadConditions:
            - key: targetBranch
              operator: Equals
              value: main
            - key: sourceBranch
              operator: Regex
              value: ^release(-|/).*$
          repoName: your-org/your-repo
          actions:
            - Open
            - Reopen
  inputSetRefs:
    - release_to_main_inputs
```

### Input Sets for Environments

Input sets provide environment-specific configurations.

#### Production Input Set

**File**: `.harness/input-sets/production-inputs.yaml`

```yaml
inputSet:
  name: Production Inputs
  identifier: production_inputs
  orgIdentifier: mycompany
  projectIdentifier: backend_services
  pipeline:
    identifier: production_deploy
    stages:
      - stage:
          identifier: deploy_production
          type: Deployment
          spec:
            service:
              serviceInputs:
                serviceDefinition:
                  type: Kubernetes
                  spec:
                    variables:
                      - name: replicas
                        type: String
                        value: "5"
                      - name: cpu_limit
                        type: String
                        value: "2000m"
                      - name: memory_limit
                        type: String
                        value: "4Gi"
            environment:
              environmentInputs:
                type: PreProduction
                variables:
                  - name: namespace
                    type: String
                    value: "production"
                  - name: domain
                    type: String
                    value: "api.example.com"
```

#### Staging Input Set

**File**: `.harness/input-sets/staging-inputs.yaml`

```yaml
inputSet:
  name: Staging Inputs
  identifier: staging_inputs
  orgIdentifier: mycompany
  projectIdentifier: backend_services
  pipeline:
    identifier: release_pipeline
    stages:
      - stage:
          identifier: deploy_staging
          spec:
            environment:
              environmentInputs:
                variables:
                  - name: namespace
                    value: "staging"
                  - name: domain
                    value: "staging.example.com"
                  - name: replicas
                    value: "3"
```

### Server-Side Git Flow Enforcement Strategies

#### Strategy 1: Branch Protection Rules via Harness

Configure Harness to enforce Git Flow through pipeline conditions:

```yaml
# Example: Prevent direct push to main/develop
# Use this in pipeline when conditions

pipeline:
  stages:
    - stage:
        name: Validate Push
        identifier: validate
        when:
          condition: |
            <+codebase.branch> != "main" && 
            <+codebase.branch> != "develop"
          pipelineStatus: All
```

**Enforcement Points**:

1. **Branch Creation Validation**:
   - Pipeline fails if feature branch not from `develop`
   - Pipeline fails if hotfix branch not from `main`

2. **PR Target Validation**:
   - Triggers only fire for correct target branches
   - Feature → develop, Release → main, Hotfix → main+develop

3. **Merge Strategy Enforcement**:
   - Configure GitHub/GitLab branch protection
   - Require PR reviews before merge
   - Require status checks to pass (Harness pipelines)

4. **Deployment Gate Enforcement**:
   - Production deployments require approval
   - Staging deployments automatic from release branches
   - Preview deployments optional for feature branches

#### Strategy 2: GitHub Branch Protection Integration

Configure GitHub repository settings to work with Harness:

```bash
# Use GitHub API or UI to set:

# Main branch protection:
# - Require pull request reviews (2 approvals)
# - Require status checks to pass (Harness CI)
# - Require branches to be up to date
# - Include administrators: No
# - Restrict who can push: None (use Harness to control)

# Develop branch protection:
# - Require pull request reviews (1 approval)
# - Require status checks to pass (Harness CI)
# - Do not allow force pushes
# - Do not allow deletions
```

**GitHub API Example**:

```bash
curl -X PUT \
  -H "Authorization: token YOUR_GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/your-org/your-repo/branches/main/protection \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": [
        "Harness CI - Feature Pipeline",
        "Harness CI - Main Pipeline"
      ]
    },
    "enforce_admins": false,
    "required_pull_request_reviews": {
      "required_approving_review_count": 2,
      "dismiss_stale_reviews": true
    },
    "restrictions": null
  }'
```

#### Strategy 3: Automated Release Process

Use Harness to fully automate release workflows:

```yaml
# Release Automation Pipeline
# Triggered when release branch is created

pipeline:
  stages:
    - stage:
        name: Auto-Generate Release Notes
        steps:
          - step:
              type: Run
              spec:
                command: |
                  # Use semantic-release or custom script
                  npx semantic-release --dry-run
    
    - stage:
        name: Auto-Create PR to Main
        steps:
          - step:
              type: Run
              spec:
                command: |
                  # Create PR using GitHub API
                  gh pr create \
                    --base main \
                    --head ${RELEASE_BRANCH} \
                    --title "Release ${VERSION}" \
                    --body "$(cat CHANGELOG.md)"
```

#### Strategy 4: Hotfix Automation with Auto-Backport

Automatically merge hotfix to develop after production deployment:

```yaml
# Add to hotfix pipeline post-deployment stage

- stage:
    name: Auto-Merge to Develop
    identifier: auto_merge_develop
    type: CI
    when:
      stageStatus: Success
      condition: <+pipeline.stages.deploy_hotfix.status> == "Success"
    spec:
      execution:
        steps:
          - step:
              type: Run
              name: Create Backport PR
              identifier: backport
              spec:
                shell: Bash
                command: |
                  #!/bin/bash
                  
                  # Get hotfix branch name
                  HOTFIX_BRANCH="<+codebase.branch>"
                  
                  # Create PR to merge hotfix → develop
                  gh pr create \
                    --base develop \
                    --head "$HOTFIX_BRANCH" \
                    --title "Backport hotfix: $HOTFIX_BRANCH" \
                    --body "Automatically backporting hotfix to develop after production deployment." \
                    --label "hotfix-backport"
                  
                  echo "✅ Backport PR created"
```

### Complete Integration: Client + Server Hooks

**Layered Enforcement Model**:

```
┌─────────────────────────────────────────────────────┐
│          Developer Workstation                      │
│                                                      │
│  ┌────────────────────────────────────────────┐    │
│  │  Client-Side Git Hooks (This Repo)        │    │
│  │  • Fast feedback (local validation)       │    │
│  │  • Branch naming                           │    │
│  │  • Commit message format                   │    │
│  │  • JIRA ID auto-population                 │    │
│  │  • Protected branch blocks                 │    │
│  └────────────────────────────────────────────┘    │
│                     │                                │
│                     │ git push                       │
│                     ▼                                │
└─────────────────────────────────────────────────────┘
                      │
                      │
┌─────────────────────▼─────────────────────────────┐
│          Git Remote (GitHub/GitLab)                │
│                                                      │
│  ┌────────────────────────────────────────────┐    │
│  │  Branch Protection Rules                   │    │
│  │  • Require PR for main/develop             │    │
│  │  • Require status checks (Harness)         │    │
│  │  • Require reviews                          │    │
│  └────────────────────────────────────────────┘    │
│                     │                                │
│                     │ webhook                        │
│                     ▼                                │
└─────────────────────────────────────────────────────┘
                      │
                      │
┌─────────────────────▼─────────────────────────────┐
│          Harness CI/CD (Server-Side)               │
│                                                      │
│  ┌────────────────────────────────────────────┐    │
│  │  Mandatory Enforcement                     │    │
│  │  • Cannot be bypassed                      │    │
│  │  • Git Flow validation                     │    │
│  │  • Build + Test automation                 │    │
│  │  • Security scanning                       │    │
│  │  • Deployment automation                   │    │
│  │  • Approval gates                          │    │
│  │  • Audit trail                             │    │
│  └────────────────────────────────────────────┘    │
│                     │                                │
│                     │ deployment                     │
│                     ▼                                │
└─────────────────────────────────────────────────────┘
                      │
                      │
              ┌───────┴───────┐
              │               │
         ┌────▼────┐    ┌────▼────┐
         │ Staging │    │   Prod  │
         └─────────┘    └─────────┘
```

**Benefits of Dual Enforcement**:

✅ **Client-side (Local Hooks)**:
- Instant feedback - No wait for CI
- Reduces failed CI builds
- Educates developers early
- Works offline

✅ **Server-side (Harness CI/CD)**:
- Cannot be bypassed
- Centralized policy management
- Automated deployments
- Approval workflows
- Compliance audit trail

### Webhook Configuration

#### GitHub Webhook Setup

1. Navigate to repository **Settings** → **Webhooks** → **Add webhook**

2. Configure webhook:
   ```
   Payload URL: https://app.harness.io/gateway/api/webhooks/<account-id>
   Content type: application/json
   Secret: <webhook-secret-from-harness>
   
   Events:
   ☑ Pull requests
   ☑ Pushes
   ☑ Branch or tag creation
   ☑ Branch or tag deletion
   ```

3. Harness automatically creates webhook when you create trigger

#### GitLab Webhook Setup

```
Project → Settings → Webhooks

URL: https://app.harness.io/gateway/api/webhooks/<account-id>
Secret Token: <from-harness>

Trigger:
☑ Push events
☑ Merge request events
☑ Tag push events
```

#### Bitbucket Webhook Setup

```
Repository Settings → Webhooks → Add webhook

Title: Harness CI/CD
URL: https://app.harness.io/gateway/api/webhooks/<account-id>

Triggers:
☑ Repository push
☑ Pull request created
☑ Pull request updated
☑ Pull request merged
```

### Harness Best Practices for Git Flow

#### 1. Pipeline Organization

```
.harness/
├── pipelines/
│   ├── _common/
│   │   ├── build-steps.yaml        # Reusable build steps
│   │   ├── test-steps.yaml         # Reusable test steps
│   │   └── deploy-steps.yaml       # Reusable deploy steps
│   ├── feature-build.yaml          # Feature pipeline
│   ├── develop-deploy.yaml         # Develop pipeline
│   ├── release-pipeline.yaml       # Release pipeline
│   ├── main-deploy.yaml            # Production pipeline
│   └── hotfix-pipeline.yaml        # Hotfix pipeline
├── input-sets/
│   ├── production-inputs.yaml
│   ├── staging-inputs.yaml
│   ├── develop-inputs.yaml
│   └── preview-inputs.yaml
└── triggers/
    ├── pr-feature-to-develop.yaml
    ├── push-to-develop.yaml
    ├── release-branch.yaml
    ├── push-to-main.yaml
    └── hotfix-trigger.yaml
```

#### 2. Use Pipeline Templates

Create reusable templates for common patterns:

```yaml
# Template: Standard CI Steps
template:
  name: Standard CI Steps
  identifier: standard_ci_steps
  type: Stage
  spec:
    type: CI
    spec:
      execution:
        steps:
          - step:
              type: Run
              name: Install Dependencies
              identifier: install
              spec:
                command: <+input>
          
          - step:
              type: Run
              name: Lint
              identifier: lint
              spec:
                command: <+input>
          
          - step:
              type: Run
              name: Test
              identifier: test
              spec:
                command: <+input>

# Use in pipelines:
pipeline:
  stages:
    - stage:
        identifier: ci_stage
        template:
          templateRef: standard_ci_steps
          templateInputs:
            spec:
              execution:
                steps:
                  - step:
                      identifier: install
                      spec:
                        command: npm ci
```

#### 3. Environment Variables and Secrets

```yaml
# Pipeline-level variables
pipeline:
  variables:
    - name: DOCKER_REGISTRY
      type: String
      value: docker.io/your-org
    - name: APP_NAME
      type: String
      value: backend-service

# Use secrets for sensitive data
pipeline:
  stages:
    - stage:
        steps:
          - step:
              spec:
                envVariables:
                  DB_PASSWORD: <+secrets.getValue("db_password")>
                  API_KEY: <+secrets.getValue("api_key")>
```

#### 4. Failure Strategies

```yaml
# Add to stages for automatic retries
pipeline:
  stages:
    - stage:
        failureStrategies:
          - onFailure:
              errors:
                - AllErrors
              action:
                type: Retry
                spec:
                  retryCount: 2
                  retryIntervals:
                    - 10s
                    - 30s
                  onRetryFailure:
                    action:
                      type: MarkAsFailure
```

#### 5. Conditional Execution

```yaml
# Skip stages based on branch
pipeline:
  stages:
    - stage:
        name: Deploy to Preview
        when:
          condition: |
            <+codebase.branch>.startsWith("feat-") && 
            <+pipeline.variables.enablePreview> == "true"
          pipelineStatus: Success
```

### Troubleshooting Guide

#### Issue 1: Trigger Not Firing

**Symptoms**: Pipeline doesn't start after git push/PR

**Solutions**:
```bash
# Check webhook delivery in Git provider
# GitHub: Settings → Webhooks → Recent Deliveries

# Verify trigger conditions
# - Check branch name matches regex
# - Verify connector is correct
# - Check payload conditions

# Test webhook manually
curl -X POST \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: push" \
  https://app.harness.io/gateway/api/webhooks/<account-id> \
  -d @test-payload.json
```

#### Issue 2: Branch Validation Failing

**Symptoms**: Pipeline fails at branch validation step

**Solutions**:
```bash
# Check branch naming format
# Expected: feat-PROJ-123-description

# Verify base branch
git log --oneline --graph develop..feature-branch

# Check Git Flow rules in pipeline YAML
# Ensure regex patterns match your convention
```

#### Issue 3: Deployment Approval Timeout

**Symptoms**: Approval step times out

**Solutions**:
```yaml
# Increase timeout in approval step
- step:
    type: HarnessApproval
    spec:
      timeout: 2h  # Increase from default 1h

# Configure notification for approvers
# Add Slack/Email notification when approval needed
```

#### Issue 4: Docker Build Fails

**Symptoms**: BuildAndPushDockerRegistry step fails

**Solutions**:
```bash
# Check Docker connector credentials
# Settings → Connectors → Docker Registry → Test Connection

# Verify Dockerfile exists and is valid
docker build -t test .

# Check registry permissions
docker login docker.io
docker push docker.io/your-org/test

# Review build logs in Harness for specific error
```

#### Issue 5: Kubernetes Deployment Fails

**Symptoms**: K8s deployment step fails

**Solutions**:
```bash
# Verify K8s connector
# Settings → Connectors → Kubernetes → Test Connection

# Check cluster access from delegate
kubectl --context=<cluster> get nodes

# Verify service account permissions
kubectl auth can-i --list --as=system:serviceaccount:harness-delegate:default

# Check manifest syntax
kubectl apply --dry-run=client -f k8s-manifests/
```

---

## Git Flow Best Practices

### Branch Naming

✅ **Good**:
- `feat-PROJ-123-user-authentication`
- `hotfix-SEC-456-xss-vulnerability`
- `release-1.2.0` (version number, NO JIRA ID per Git Flow)
- `release-2.0.0-rc1` (pre-release version)

❌ **Bad**:
- `feature-branch` (no JIRA ID)
- `johns-stuff` (not descriptive)
- `bugfix` (too generic)

### Commit Messages

✅ **Good**:
```
feat: PROJ-123 add OAuth2 authentication

- Implement login endpoint
- Add JWT token generation
- Include refresh token support
```

❌ **Bad**:
```
update
fixed stuff
WIP
```

### Merging Strategy

✅ **Always use `--no-ff`**:
```bash
git merge --no-ff feat-PROJ-123-feature
```

❌ **Never fast-forward for features**:
```bash
# This loses feature history
git merge feat-PROJ-123-feature
```

### Release Timing

✅ **Create release branch when**:
- All features for release are merged to develop
- Develop is stable
- Ready to start release preparation

❌ **Don't create release branch**:
- Before all features are merged
- When develop is unstable
- Too early (releases should be short-lived)

### Hotfix Guidelines

✅ **Use hotfix for**:
- Production bugs
- Security vulnerabilities
- Critical issues affecting users

❌ **Don't use hotfix for**:
- Regular bug fixes (use bugfix from develop)
- New features
- Non-critical issues

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
| **Release** | `release-X.Y.Z` (version, no JIRA) | `develop` | `main` + `develop` | Release preparation |
| **Support** | `chore-JIRA-123-description` | `develop` | `develop` | Maintenance tasks |

### Validation Points

1. **Post-Checkout**: Validates branch creation base + blocks branching FROM release/hotfix
2. **Pre-Commit**: Validates protected branch commits
3. **Commit-Msg**: Validates commit message format (JIRA optional for release branches)
4. **Pre-Push**: Validates branch name, history, commit count, base branch + base branch type

### Critical Git Flow Rules (NEW)

#### Cannot Create Branches FROM Release/Hotfix Branches

**Rule**: Release and hotfix branches do NOT allow creating new branches from them.

**Why**: Per official Git Flow model:
- **Release branches**: Bug fixes are committed DIRECTLY on the release branch
- **Hotfix branches**: Fixes are committed DIRECTLY on the hotfix branch
- Creating branches defeats the purpose of focused, time-boxed fixes

**Examples**:
```bash
# ❌ BLOCKED: Creating feature from release
git checkout release-1.2.0
git checkout -b feat-PROJ-123-fix
# Error: "Cannot Create Branches FROM Release Branches"

# ✓ CORRECT: Commit directly on release
git checkout release-1.2.0
# Make your fix
git commit -m "Fix bug in release"
# Note: JIRA ID is OPTIONAL for release branch commits

# ❌ BLOCKED: Creating branch from hotfix
git checkout hotfix-PROJ-789-urgent
git checkout -b feat-PROJ-456-another
# Error: "Cannot Create Branches FROM Hotfix Branches"

# ✓ CORRECT: Commit directly on hotfix
git checkout hotfix-PROJ-789-urgent
# Make your fix
git commit -m "fix: PROJ-789 apply security patch"
```

**Enforced by**:
- `post-checkout` hook (immediate feedback when branch is created)
- `pre-push` hook (catches cases where post-checkout was bypassed)

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

**Validates (Branch-Aware)**:
- **Release Branches**: JIRA ID is **OPTIONAL** (soft validation per Git Flow)
  - Format: `<type>: <description>` OR `<type>: <JIRA-ID> <description>`
  - Also allows: `Bump version to X.Y.Z`, `Update changelog`, etc.
- **All Other Branches**: JIRA ID is **REQUIRED** (strict validation)
  - Format: `<type>: <JIRA-ID> <description>`
- Valid types: `feat`, `fix`, `chore`, `break`, `tests`, `docs`, `style`, `refactor`, `perf`, `build`, `ci`, `release`, `version`
- JIRA ID pattern (when required): `[A-Z]{2,10}-[0-9]+`
- Non-empty descriptions

**Always Allows**:
- Merge commits (starts with "Merge")
- Revert commits (starts with "Revert")

**Example Valid Messages**:

*Feature/Bugfix/Hotfix Branches (JIRA required):*
```
feat: PROJ-123 add user authentication
fix: TICKET-456 resolve memory leak
chore: ABC-789 update dependencies
break: PROJ-100 remove deprecated API
tests: JIRA-999 add integration tests
```

*Release Branches (JIRA optional):*
```
chore: bump version to 1.2.0
docs: update changelog for 1.2.0
release: finalize 1.2.0
Bump version to 1.2.0
Update changelog
Prepare release 1.2.0
feat: PROJ-123 add feature  # JIRA also allowed
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

**Special Handling**:
- **Tags** (`refs/tags/*`): Automatically bypass all branch validations
  - Tags are immutable commit markers used for releases
  - Git Flow requires tags on `main` after release/hotfix merges
  - No branch naming, commit count, or history validations applied
  - Example: `git push origin v1.0.0` - allowed without validation

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

**Validates (Branch-Aware)**:
- **Release Branches**: JIRA ID is **OPTIONAL** (soft validation)
- **All Other Branches**: JIRA ID is **REQUIRED** (strict validation)
- Patch commit messages follow same format rules as regular commits (see `commit-msg` hook)

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

# Bypass warning display style (default: compact)
# Options: compact, full, once
git config hooks.bypassWarningStyle compact

# Auto-stage files after commands fix them (default: false)
git config hooks.autoAddAfterFix true

# Enable parallel command execution (default: false)
git config hooks.parallelExecution true

# Set base branch for current branch
git config branch.$(git branch --show-current).base develop
```

#### Bypass Warning Styles

When `BYPASS_HOOKS` or `ALLOW_DIRECT_PROTECTED` is set, warnings are displayed:

- **`compact`** (default): Always show one-line warning
  - All commands: `⚠️  BYPASS ACTIVE: BYPASS_HOOKS=1 (Only for critical changes! Disable: unset BYPASS_HOOKS)`
  - Best for: Minimal terminal clutter while maintaining visibility
  - Recommended: For most teams to reduce noise during emergency fixes

- **`full`**: Always show detailed warning
  - All commands: Full warning box with detailed explanations
  - Best for: Maximum security awareness and first-time bypass users
  
- **`once`**: Show detailed warning once per terminal session, then compact reminders
  - First command: Full detailed warning with all explanations
  - Subsequent commands: One-line compact warning
  - Best for: Emergency work that requires multiple commands with context

Example configuration:
```bash
# For minimal clutter (default, recommended)
git config hooks.bypassWarningStyle compact

# For maximum visibility (detailed warnings)
git config hooks.bypassWarningStyle full

# For emergency hotfix work (detailed once, then compact)
git config hooks.bypassWarningStyle once
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

**Standard Format**: `<type>-<JIRA-ID>-<description>`

**Components**:
- **Type**: One of the valid types (see below)
- **JIRA ID**: Pattern `[A-Z]{2,10}-[0-9]+` (2-10 uppercase letters, dash, numbers)
- **Description**: Lowercase, hyphen-separated words

**⚠️ EXCEPTION**: Release branches follow Git Flow convention: `release-<version>` (**NO JIRA ID required**)

### Valid Branch Types

| Type | Purpose | Base Branch | Naming Pattern |
|------|---------|-------------|----------------|
| `feat`, `feature` | New features | `develop` | `feat-JIRA-123-description` |
| `fix`, `bugfix` | Bug fixes | `develop` | `fix-JIRA-123-description` |
| `hotfix` | Production fixes | `main` | `hotfix-JIRA-123-description` |
| **`release`** | **Release preparation** | **`develop`** | **`release-X.Y.Z`** (version, no JIRA) |
| `chore` | Maintenance | `develop` | `chore-JIRA-123-description` |
| `docs` | Documentation | `develop` | `docs-JIRA-123-description` |
| `style` | Code style | `develop` | `style-JIRA-123-description` |
| `refactor` | Code restructuring | `develop` | `refactor-JIRA-123-description` |
| `perf` | Performance | `develop` | `perf-JIRA-123-description` |
| `test` | Testing | `develop` | `test-JIRA-123-description` |
| `build` | Build system | `develop` | `build-JIRA-123-description` |
| `ci` | CI/CD | `develop` | `ci-JIRA-123-description` |
| `techdebt` | Technical debt | `develop` | `techdebt-JIRA-123-description` |
| `revert` | Revert changes | `develop` | `revert-JIRA-123-description` |

### Valid Examples

```bash
# Feature and bug fix branches (require JIRA ID)
feat-PROJ-123-add-user-authentication
fix-TICKET-456-resolve-memory-leak
hotfix-ABC-789-patch-security-vulnerability
chore-JIRA-100-update-dependencies
docs-PROJECT-200-api-documentation
refactor-TASK-300-simplify-auth-logic

# Release branches (NO JIRA ID - Git Flow standard)
release-1.2.0
release-1.2
release-2.0.0
release-1.5.0-rc1
release-2.0.0-beta.1
```

### Invalid Examples

❌ `feature-branch` - Missing JIRA ID
❌ `PROJ-123` - Missing type and description
❌ `feat-proj-123-description` - Lowercase JIRA ID
❌ `feat-PROJ-123` - Missing description
❌ `feat_PROJ_123_description` - Wrong separators (use hyphens)
❌ `release-PROJ-123-description` - Release branches should NOT have JIRA IDs
❌ `release/1.2.0` - Use hyphen, not slash (for consistency)

### Creating Branches Correctly

```bash
# Feature branch (from develop)
git checkout develop
git checkout -b feat-PROJ-123-add-feature develop

# Hotfix branch (from main)
git checkout main
git checkout -b hotfix-PROJ-456-fix-bug main

# Release branch (from develop - NO JIRA ID)
git checkout develop
git checkout -b release-1.2.0 develop

# Avoid common mistakes
git checkout main
git checkout -b feat-PROJ-123-feature  # ❌ Wrong base! Features must come from develop

git checkout develop
git checkout -b feature-branch  # ❌ Invalid name! Missing JIRA ID

git checkout develop
git checkout -b release-PROJ-123-v1.2.0  # ❌ Wrong! Release branches use version numbers, not JIRA IDs
```

---

## Commit Message Format

### ⚠️ IMPORTANT: Branch-Specific Rules

**Release Branches**: JIRA ID is **OPTIONAL** (soft validation per Git Flow)
- Release branches use version numbers, not JIRA IDs in branch names
- Commits can include JIRA IDs OR omit them - both are valid
- Examples: `"Bump version to 1.2.0"`, `"chore: update changelog"`, `"feat: JIRA-123 add feature"`

**All Other Branches**: JIRA ID is **REQUIRED** (strict validation)
- Feature, bugfix, hotfix, support branches MUST include JIRA IDs in commit messages

---

### Required Pattern

**Standard (all branches):**
```
<type>: <JIRA-ID> <description>
```

**Release branches only (flexible):**
```
<type>: <description>                    # JIRA ID optional
<type>: <JIRA-ID> <description>          # JIRA ID also allowed
<action-word> <description>              # Simple format for release tasks
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
- `release`: Release-specific changes (release branches)
- `version`: Version changes (release branches)
- `build`: Build system changes
- `ci`: CI/CD changes

### JIRA ID Format

- Pattern: `[A-Z]{2,10}-[0-9]+`
- Examples: `PROJ-123`, `TICKET-456`, `ABC-789`
- **Release branches**: Optional (can be included or omitted)

### Description Rules

- Must not be empty
- Should be concise but descriptive
- No period at the end (convention)
- Present tense (e.g., "add" not "added")

### Valid Examples

**Feature/Bugfix/Hotfix/Support Branches (JIRA required):**
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

**Release Branches (JIRA optional - flexible validation):**
```
# With JIRA ID (also valid):
feat: PROJ-123 add last-minute feature to release
chore: TASK-456 update release notes

# Without JIRA ID (valid for release branches):
chore: bump version to 1.2.0
docs: update changelog for 1.2.0 release
build: prepare build for production
release: finalize 1.2.0 release
Bump version to 1.2.0
Update changelog
Prepare release 1.2.0
Finalize release candidate
```

### Invalid Examples

**Feature/Bugfix/Hotfix/Support Branches:**
❌ `added new feature` - Missing type and JIRA ID
❌ `feat: add feature` - Missing JIRA ID (required for non-release branches)
❌ `feat: proj-123 add feature` - Lowercase JIRA ID
❌ `feat: PROJ-123` - Missing description
❌ `PROJ-123 add feature` - Missing type

**Release Branches:**
❌ `just a change` - No type or structure
❌ `fix` - Missing description
❌ `123` - Invalid format

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

#### 3. Too Many Commits - Complete Guide

**Error**:
```
✗ ERROR: Too Many Commits
Branch has 8 commits (limit: 5). Squash commits before pushing.
```

**Why This Limit Exists**:
- Easier code review (reviewers can focus on final changes)
- Cleaner git history (less noise, easier navigation)
- Simpler reverts (one commit to revert entire feature)
- Faster git operations (fewer commits to process)
- Encourages thoughtful commit organization

**Understanding Your Options**:

There are **three main approaches** to handle too many commits. Choose based on your needs:

1. **Soft Reset** (Easiest - Recommended for most cases)
   - Combines all commits into one
   - Preserves ALL your changes
   - Simple, fast, no conflicts
   - Best when: You want a single clean commit

2. **Interactive Rebase** (More Control)
   - Choose which commits to combine
   - Can keep some commits separate
   - Edit commit messages individually
   - Best when: You want to preserve some commit separation

3. **Increase Limit** (Last Resort)
   - Keeps all commits as-is
   - Only use if truly necessary
   - Should be temporary
   - Best when: Complex feature genuinely needs more commits

---

### Option 1: Soft Reset (Recommended - Simplest)

**What It Does**:
- Moves branch pointer back to base (develop)
- Keeps ALL your file changes staged
- You create ONE new commit with all changes
- **All history is preserved** in reflog (recoverable)

**Step-by-Step Instructions**:

```bash
# 1. Check your current state (BEFORE doing anything)
git log --oneline
# Output:
# a1b2c3d (HEAD -> feat-PROJ-123-add-auth) feat: PROJ-123 fix typo
# e4f5g6h feat: PROJ-123 add tests
# i7j8k9l feat: PROJ-123 update docs
# m0n1o2p feat: PROJ-123 refactor code
# q3r4s5t feat: PROJ-123 implement auth
# u6v7w8x (origin/develop, develop) chore: update dependencies
# ... (older commits)

# 2. Soft reset to develop (your base branch)
git reset --soft develop

# What happened:
# - Branch pointer moved to develop
# - All 5 commits "disappeared" from git log
# - BUT all changes are still staged (ready to commit)

# 3. Verify changes are staged
git status
# Output:
# On branch feat-PROJ-123-add-auth
# Changes to be committed:
#   (use "git restore --staged <file>..." to unstage)
#         modified:   src/auth.js
#         new file:   src/auth.test.js
#         modified:   docs/auth.md
#         modified:   src/config.js

# All your changes are here, ready to commit!

# 4. Create ONE comprehensive commit
git commit -m "feat: PROJ-123 implement user authentication system

Complete authentication implementation including:
- JWT token generation and validation
- User login and registration endpoints  
- Password hashing with bcrypt
- Session management
- Unit tests with 95% coverage
- API documentation updated

Closes PROJ-123
"

# Pro tip: Use multi-line commit message for better description
# First line: Short summary (50 chars max)
# Blank line
# Body: Detailed explanation (bullet points work well)

# 5. Verify the result
git log --oneline -3
# Output:
# a1b2c3d (HEAD -> feat-PROJ-123-add-auth) feat: PROJ-123 implement user authentication system
# u6v7w8x (origin/develop, develop) chore: update dependencies
# ... (older commits)

# Perfect! Now you have 1 commit instead of 5

# 6. Push to remote (requires force since you rewrote history)
git push --force-with-lease origin feat-PROJ-123-add-auth

# Why --force-with-lease?
# - Safer than --force
# - Prevents overwriting if someone else pushed
# - Fails if remote has commits you don't have locally
```

**What If You Make a Mistake?**

Don't panic! Your old commits are still in reflog:

```bash
# View reflog (shows all previous states)
git reflog
# Output:
# a1b2c3d HEAD@{0}: commit: feat: PROJ-123 implement user authentication system
# u6v7w8x HEAD@{1}: reset: moving to develop
# q3r4s5t HEAD@{2}: commit: feat: PROJ-123 fix typo
# e4f5g6h HEAD@{3}: commit: feat: PROJ-123 add tests
# ... (all previous commits are here!)

# To undo soft reset and get back your 5 commits:
git reset --hard HEAD@{1}
# This moves you back to BEFORE the soft reset

# Alternative: If you committed but want original 5 commits back:
git reflog
git reset --hard HEAD@{2}  # Go back to before soft reset

# Your original commits are safe for ~30 days in reflog!
```

---

### Option 2: Interactive Rebase (More Control)

**What It Does**:
- Opens editor with list of commits
- You choose what to do with each commit:
  - `pick` = keep commit as-is
  - `squash` = merge with previous commit (keep commit message)
  - `fixup` = merge with previous commit (discard commit message)
  - `reword` = keep commit but edit message
  - `edit` = stop to amend commit
  - `drop` = remove commit entirely

**When to Use**:
- Want to keep some commits separate
- Need to reword commit messages
- Want to drop certain commits
- More complex history cleanup

**Step-by-Step Instructions**:

```bash
# 1. Check your commits
git log --oneline
# Output:
# a1b2c3d (HEAD -> feat-PROJ-123-add-auth) feat: PROJ-123 fix typo
# e4f5g6h feat: PROJ-123 add tests  
# i7j8k9l feat: PROJ-123 update docs
# m0n1o2p feat: PROJ-123 refactor code
# q3r4s5t feat: PROJ-123 implement auth
# u6v7w8x (origin/develop, develop) chore: update dependencies

# 2. Start interactive rebase
git rebase -i develop

# Editor opens with:
pick q3r4s5t feat: PROJ-123 implement auth
pick m0n1o2p feat: PROJ-123 refactor code
pick i7j8k9l feat: PROJ-123 update docs
pick e4f5g6h feat: PROJ-123 add tests
pick a1b2c3d feat: PROJ-123 fix typo

# Rebase u6v7w8x..a1b2c3d onto u6v7w8x (5 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# d, drop <commit> = remove commit

# 3. Edit the file to squash commits
# Change to:
pick q3r4s5t feat: PROJ-123 implement auth
squash m0n1o2p feat: PROJ-123 refactor code
squash i7j8k9l feat: PROJ-123 update docs
squash e4f5g6h feat: PROJ-123 add tests
squash a1b2c3d feat: PROJ-123 fix typo

# What this does:
# - Keeps first commit (pick)
# - Merges all others into first commit (squash)
# - You'll edit the final commit message next

# 4. Save and close editor (in vi: press ESC, type :wq, press ENTER)

# 5. Next editor opens with combined commit message
# This is the combined commit message for all squashed commits
feat: PROJ-123 implement auth
feat: PROJ-123 refactor code
feat: PROJ-123 update docs
feat: PROJ-123 add tests
feat: PROJ-123 fix typo

# Edit to create one clean message:
feat: PROJ-123 implement user authentication system

Complete authentication implementation:
- JWT token generation and validation
- User login and registration endpoints
- Password hashing with bcrypt
- Session management with Redis
- Comprehensive unit tests (95% coverage)
- API documentation updated

Closes PROJ-123

# 6. Save and close editor

# 7. Verify result
git log --oneline -3
# Output:
# z9y8x7w (HEAD -> feat-PROJ-123-add-auth) feat: PROJ-123 implement user authentication system
# u6v7w8x (origin/develop, develop) chore: update dependencies

# Perfect! 5 commits squashed into 1

# 8. Push with force
git push --force-with-lease origin feat-PROJ-123-add-auth
```

**Advanced Interactive Rebase Examples**:

**Example 1: Keep 2 commits, squash rest**
```bash
# Before: 5 commits
# After: 2 commits (implementation + tests separate)

pick q3r4s5t feat: PROJ-123 implement auth
squash m0n1o2p feat: PROJ-123 refactor code
pick e4f5g6h feat: PROJ-123 add tests
squash i7j8k9l feat: PROJ-123 update test docs
fixup a1b2c3d feat: PROJ-123 fix test typo

# Result: 2 commits
# 1. feat: PROJ-123 implement auth (includes refactor)
# 2. feat: PROJ-123 add tests (includes docs and typo fix)
```

**Example 2: Drop unnecessary commits**
```bash
pick q3r4s5t feat: PROJ-123 implement auth
drop m0n1o2p feat: PROJ-123 debug logging (not needed)
pick i7j8k9l feat: PROJ-123 update docs
drop e4f5g6h feat: PROJ-123 temp commit (remove)
pick a1b2c3d feat: PROJ-123 add tests

# Dropped commits are completely removed
```

**Example 3: Reword commit messages**
```bash
pick q3r4s5t feat: PROJ-123 implement auth
reword m0n1o2p feat: PROJ-123 refactor code
pick i7j8k9l feat: PROJ-123 update docs

# Rebase will stop at 'reword' commits
# You can edit the commit message
# Then continues automatically
```

**If Rebase Goes Wrong**:

```bash
# Abort rebase (go back to before rebase)
git rebase --abort

# You're back to original state, no harm done!

# If you already finished rebase and want to undo:
git reflog
git reset --hard HEAD@{1}  # Go back to before rebase
```

---

### Option 3: Increase Commit Limit (Last Resort)

**When to Use**:
- Complex feature with genuinely distinct phases
- Each commit represents a complete, reviewable unit
- Team agrees more commits are justified
- Temporary - will lower limit after push

**Considerations**:
- ⚠️ Makes code review harder (more commits to check)
- ⚠️ Clutters git history
- ⚠️ May indicate feature should be split into smaller features
- ✅ Acceptable for releases, large refactors, migrations

**Instructions**:

```bash
# 1. Increase limit (local to this repo)
git config hooks.maxCommits 10

# 2. Push your branch
git push origin feat-PROJ-123-add-auth

# 3. After push, consider lowering back
git config hooks.maxCommits 5

# Global setting (all repos):
git config --global hooks.maxCommits 10

# View current setting:
git config hooks.maxCommits
```

**Better Alternative**:
Instead of increasing limit, consider splitting feature:

```bash
# Instead of 8 commits on one branch:
feat-PROJ-123-implement-auth (8 commits)

# Split into multiple PRs:
feat-PROJ-123-auth-models (3 commits → squashed to 1)
feat-PROJ-123-auth-api (3 commits → squashed to 1)  
feat-PROJ-123-auth-tests (2 commits → squashed to 1)

# Benefits:
# ✓ Each PR easier to review
# ✓ Can merge incrementally
# ✓ Each meets commit limit
# ✓ Clearer feature progression
```

---

### Comparison: Which Method to Choose?

| Method | Pros | Cons | Best For |
|--------|------|------|----------|
| **Soft Reset** | • Simplest<br>• Fast<br>• No conflicts<br>• Easy to undo | • Loses individual commit messages<br>• Creates one large commit | • Most features<br>• Quick fixes<br>• Beginners |
| **Interactive Rebase** | • Full control<br>• Keep some commits<br>• Edit messages<br>• Drop commits | • More complex<br>• Possible conflicts<br>• Steeper learning curve | • Complex features<br>• Need multiple commits<br>• Advanced users |
| **Increase Limit** | • No history change<br>• Keep all commits | • Harder review<br>• Cluttered history<br>• Quick fix, not solution | • Rare justified cases<br>• Temporary only |

---

### Common Issues and Solutions

**Issue: "Already pushed branch, now can't push after squash"**
```bash
# Error:
# ! [rejected] feat-PROJ-123-add-auth -> feat-PROJ-123-add-auth (non-fast-forward)

# Solution: Use --force-with-lease
git push --force-with-lease origin feat-PROJ-123-add-auth

# Why --force-with-lease?
# ✓ Safe: Checks remote hasn't changed
# ✗ --force: Blindly overwrites (dangerous!)
```

**Issue: "Lost my original commits after squash!"**
```bash
# Don't panic! Commits are in reflog for ~30 days

# 1. Find your commits
git reflog
# Look for your commits (before squash)

# 2. Go back to that state
git reset --hard HEAD@{N}  # Replace N with number from reflog

# 3. Start over with squashing
```

**Issue: "Squashed commits but made typo in commit message"**
```bash
# Fix with amend
git commit --amend -m "feat: PROJ-123 correct message"

# Then push
git push --force-with-lease origin feat-PROJ-123-add-auth
```

**Issue: "Rebase conflicts during interactive rebase"**
```bash
# Rebase paused with conflicts

# 1. See conflicted files
git status

# 2. Resolve conflicts in editor
# Edit files, remove conflict markers (<<<<, ====, >>>>)

# 3. Stage resolved files
git add <resolved-files>

# 4. Continue rebase
git rebase --continue

# 5. Repeat for each conflict

# Or abort if too complex:
git rebase --abort
# Use soft reset instead (simpler)
```

**Issue: "Accidentally squashed wrong commits"**
```bash
# Undo with reflog
git reflog
git reset --hard HEAD@{N}  # Go back before squash

# Alternative: Cherry-pick specific commits
git checkout develop
git checkout -b feat-PROJ-123-fixed develop
git cherry-pick <commit1> <commit2>  # Pick specific commits
```

---

### Best Practices

**Before Squashing**:
1. ✓ **Ensure branch is up to date** with base:
   ```bash
   git fetch origin
   git rebase origin/develop  # Update first
   git push --force-with-lease origin feat-PROJ-123  # Then squash
   ```

2. ✓ **Backup branch** (optional but safe):
   ```bash
   git branch feat-PROJ-123-backup  # Create backup
   # Do squashing on original branch
   # If goes wrong: git reset --hard feat-PROJ-123-backup
   ```

3. ✓ **Check what you're squashing**:
   ```bash
   git log develop..HEAD --oneline  # See commits to squash
   git diff develop..HEAD  # See all changes
   ```

**Commit Message Best Practices**:
```bash
# Good commit message structure:
feat: PROJ-123 short summary (50 chars max)

Detailed explanation of what and why (not how).
Wrap at 72 characters per line.

- Bullet points for multiple changes
- Each point describes a specific change
- Why decisions were made

Technical details:
- Technology choices
- Performance considerations  
- Breaking changes (if any)

Closes PROJ-123
Related: PROJ-100, PROJ-200
```

**After Squashing**:
1. ✓ **Verify changes didn't get lost**:
   ```bash
   git diff develop  # Should show all your changes
   ```

2. ✓ **Run tests before pushing**:
   ```bash
   npm test  # or your test command
   git push --force-with-lease origin feat-PROJ-123
   ```

3. ✓ **Update PR description**:
   - Update PR with new commit message
   - Explain squashing (if reviewers saw multiple commits)
   - Re-request review if needed

---

### Visual Example: Before and After Squashing

**Before Squashing (8 commits)**:
```
* a1b2c3d (HEAD -> feat-PROJ-123) feat: PROJ-123 fix typo
* e4f5g6h feat: PROJ-123 add more tests
* i7j8k9l feat: PROJ-123 update docs  
* m0n1o2p feat: PROJ-123 refactor auth
* q3r4s5t feat: PROJ-123 add tests
* u6v7w8x feat: PROJ-123 implement login
* y9z0a1b feat: PROJ-123 implement register
* c2d3e4f feat: PROJ-123 add auth models
| * f5g6h7i (origin/develop, develop) chore: update deps
|/
```

**After Soft Reset Squash (1 commit)**:
```
* z9y8x7w (HEAD -> feat-PROJ-123) feat: PROJ-123 implement user authentication system
| * f5g6h7i (origin/develop, develop) chore: update deps
|/
```

**All 8 commits' changes are in the single commit - nothing lost!**

**Verify with**:
```bash
# Show what's in the squashed commit
git show HEAD

# Compare squashed commit to base
git diff develop..HEAD
# Should show ALL your changes from all 8 original commits
```

---

### Recovery Commands Summary

Keep these handy - they save you if something goes wrong:

```bash
# View reflog (all previous states)
git reflog

# Go back to previous state
git reset --hard HEAD@{N}  # Replace N with reflog number

# Abort interactive rebase
git rebase --abort

# Abort merge
git merge --abort

# Discard uncommitted changes
git restore .

# Unstage all changes
git restore --staged .

# Create backup branch before risky operation
git branch backup-branch-name

# View what would be pushed (dry run)
git push --dry-run origin feat-PROJ-123
```

Remember: **Git rarely loses data**. Even "deleted" commits stay in reflog for ~30 days. Don't panic, check reflog!

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

#### 7. Creating Branch FROM Release Branch (NEW - CRITICAL)

**Error**:
```
❌ CRITICAL: Cannot Create Branches FROM Release Branches

Current situation:
  Previous branch: release-1.2.0 (type: release)
  New branch: feat-PROJ-123-fix

Git Flow Rule:
  • Release branches do NOT allow creating new branches
  • Bug fixes must be committed DIRECTLY on the release branch
  • Per official Git Flow: "bug fixes may be applied IN THIS BRANCH"
```

**Why This Error Occurs**:
You tried to create a new branch while on a release or hotfix branch. Git Flow requires direct commits on these branches, not branching.

**Fix Option 1: Delete branch and commit directly (RECOMMENDED)**:
```bash
# Delete the incorrectly created branch
git checkout release-1.2.0
git branch -D feat-PROJ-123-fix

# Commit your changes directly on release
# Make your changes
git add <files>
git commit -m "Fix bug in release"
# Note: JIRA ID is OPTIONAL for release branch commits
```

**Fix Option 2: Move work to proper feature branch**:
```bash
# If this should be a feature for next release
git checkout develop
git checkout -b feat-PROJ-123-proper-feature develop
# Cherry-pick commits or re-apply changes
git branch -D feat-PROJ-123-fix  # Delete wrong branch
```

**Common Scenarios**:

a) **Bug Found During Release Testing**:
```bash
# ✓ CORRECT: Fix directly on release branch
git checkout release-1.2.0
vim src/bug-file.js
git commit -m "fix: resolve bug found in testing"
# JIRA ID optional

# ❌ WRONG: Create branch from release
git checkout release-1.2.0
git checkout -b bugfix-PROJ-123-fix  # BLOCKED!
```

b) **Emergency Production Fix (Hotfix)**:
```bash
# ✓ CORRECT: Fix directly on hotfix branch
git checkout hotfix-PROJ-999-urgent
vim src/security-fix.js
git commit -m "fix: PROJ-999 apply security patch"

# ❌ WRONG: Create branch from hotfix
git checkout hotfix-PROJ-999-urgent
git checkout -b feat-PROJ-200-another  # BLOCKED!
```

c) **Last-Minute Feature for Release** (Rare, use with caution):
```bash
# If feature must go in this release (rare):
# Option A: Merge feature branch to release (unusual)
git checkout release-1.2.0
git merge --no-ff feat-PROJ-123-feature

# Option B: Cherry-pick specific commits
git checkout release-1.2.0
git cherry-pick <commit-sha>

# ❌ WRONG: Create new feature branch from release
git checkout release-1.2.0
git checkout -b feat-PROJ-456-new  # BLOCKED!
```

**Prevention**:
Always check which branch you're on before creating new branches:
```bash
# Check current branch
git branch --show-current

# Only create branches from develop (features) or main (hotfixes)
git checkout develop
git checkout -b feat-PROJ-123-new-feature
```

#### 8. Creating Branch FROM Hotfix Branch (NEW - CRITICAL)

**Error**:
```
❌ CRITICAL: Cannot Create Branches FROM Hotfix Branches

Hotfix Branch Purpose:
  • Emergency fix for production
  • Apply fixes DIRECTLY on hotfix branch
  • Merge to BOTH main AND develop
  • NO branching allowed
```

**Fix**:
```bash
# Delete incorrectly created branch
git checkout hotfix-PROJ-999-urgent
git branch -D feat-PROJ-123-another

# Commit directly on hotfix
git add <files>
git commit -m "fix: PROJ-999 additional fix"
```

#### 9. Tag Push Operations (Git Flow Releases)

**Scenario**: Pushing version tags after release/hotfix merges

**Important**: Tags are **NOT validated** as branches - they are allowed automatically!

```bash
# ✅ CORRECT: Push tags after merging to main
git checkout main
git merge --no-ff release-1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main
git push origin v1.2.0  # Tag push is automatically allowed

# ✅ Push multiple tags
git push origin --tags  # All tags are allowed

# ✅ Any tag naming format works
git tag -a v1.0.0-rc1 -m "Release candidate"
git push origin v1.0.0-rc1  # Allowed
```

**Why Tags Are Special**:

Tags represent releases and milestones in Git Flow, not development branches:
- Created on `main` after merging release/hotfix branches
- Mark production-ready versions
- Don't require JIRA IDs or branch naming patterns
- Immutable references to specific commits
- Part of official Git Flow release process

**Common Tag Operations**:

```bash
# List all tags
git tag
git tag -l "v1.*"  # Filter tags

# Create annotated tag (recommended for releases)
git tag -a v1.0.0 -m "Release version 1.0.0"

# Create signed tag (for security)
git tag -s v1.0.0 -m "Release version 1.0.0"

# Push specific tag
git push origin v1.0.0

# Push all tags
git push origin --tags

# Delete tag (if needed)
git tag -d v1.0.0           # Delete local
git push origin --delete v1.0.0  # Delete remote
```

**Git Flow Release Process with Tags**:

```bash
# Complete release workflow
git checkout develop
git checkout -b release-1.2.0 develop
# ... make release preparations, bump version ...
git commit -m "Bump version to 1.2.0"

# Merge to main
git checkout main
git merge --no-ff release-1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main
git push origin v1.2.0  # ✅ Tag push works without validation

# Merge back to develop
git checkout develop
git merge --no-ff release-1.2.0
git push origin develop

# Delete release branch
git branch -d release-1.2.0
git push origin --delete release-1.2.0
```

**Previous Issue (Now Fixed)**:

Before fix, pushing tags would fail with:
```
❌ Error: Branch 'refs/tags/v1.0.0' doesn't follow Git Flow naming
```

This was incorrect behavior - tags should never be validated as branches.

**Current Behavior (After Fix)**:

Pre-push hook now properly distinguishes between:
- `refs/heads/*` → Validated as branches (naming, Git Flow rules)
- `refs/tags/*` → Allowed automatically (no branch validation)

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