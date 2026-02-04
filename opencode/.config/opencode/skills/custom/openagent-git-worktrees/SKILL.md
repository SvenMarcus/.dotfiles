---
name: openagent-git-worktrees
description: Use when starting feature work that needs isolation - wraps superpowers:using-git-worktrees with approval gates
---

# OpenAgent Git Worktrees (Approval-Gated)

This skill wraps the Superpowers git worktrees workflow with OpenAgent's approval gates and safety measures.

## Overview

Git worktrees create isolated workspaces sharing the same repository, allowing work on multiple branches simultaneously without switching.

**Core principle:** Systematic directory selection + safety verification = reliable isolation.

## When to Use

- Starting feature work that needs isolation from current workspace
- Before executing implementation plans
- When you need to test changes without affecting main workspace
- Working on multiple features in parallel

## OpenAgent Worktree Workflow

### Phase 1: Request Approval to Create Worktree

**Before creating worktree:**
```
I'll create an isolated git worktree for this feature.

Proposed worktree:
- Branch: feature/{name}
- Location: [determined by priority order below]
- Setup: [auto-detect package.json/Cargo.toml/etc and run setup]
- Verify: Run tests to ensure clean baseline

**Approval needed before creating worktree.**
```

### Phase 2: Directory Selection (After Approval)

**Load the Superpowers git-worktrees skill:**
Use the native `skill` tool to load `superpowers/using-git-worktrees`

**Follow priority order:**

1. **Check Existing Directories**
   ```bash
   ls -d .worktrees 2>/dev/null     # Preferred (hidden)
   ls -d worktrees 2>/dev/null      # Alternative
   ```
   - If found: Use that directory
   - If both exist: `.worktrees` wins

2. **Check CLAUDE.md or README**
   ```bash
   grep -i "worktree.*director" CLAUDE.md README.md 2>/dev/null
   ```
   - If preference specified: Use it

3. **Ask User**
   ```
   No worktree directory found. Where should I create worktrees?

   1. .worktrees/ (project-local, hidden)
   2. ~/.config/superpowers/worktrees/{project-name}/ (global location)

   Which would you prefer?
   ```

### Phase 3: Safety Verification (Project-Local Only)

**For project-local directories (.worktrees or worktrees):**

**MUST verify directory is ignored:**
```bash
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**If NOT ignored, request approval to fix:**
```
⚠️ Worktree directory is not in .gitignore

This could accidentally commit worktree contents.

Proposed fix:
1. Add "{directory}/" to .gitignore
2. Commit the change

**Approval needed to fix .gitignore.**
```

**For global directory (~/.config/superpowers/worktrees):**
- No .gitignore verification needed (outside project)

### Phase 4: Worktree Creation (After Approval)

**Create worktree:**
```bash
# Determine full path
project=$(basename "$(git rev-parse --show-toplevel)")
path="{location}/{branch-name}"

# Create worktree with new branch
git worktree add "$path" -b "{branch-name}"
cd "$path"
```

**Report:**
```
Worktree created:
- Location: {full-path}
- Branch: {branch-name}
- Working directory changed to worktree

Next: Running project setup...
```

### Phase 5: Project Setup (Auto-Detect)

**Auto-detect and run setup:**
```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

**Report:**
```
Project setup complete:
- Dependencies installed: [✓/✗]
- Build successful: [✓/✗]

Next: Verifying clean baseline...
```

### Phase 6: Verify Clean Baseline

**Run tests to ensure worktree starts clean:**
```bash
# Use project-appropriate command
npm test
cargo test
pytest
go test ./...
```

**If tests pass:**
```
Clean baseline verified:
- Tests run: {N} tests
- Failures: 0
- Worktree ready for implementation

**Worktree setup complete.**
```

**If tests fail:**
```
⚠️ Tests failing in new worktree

Failures detected:
- Failed tests: {list}

This indicates pre-existing issues, not caused by worktree.

Should I:
1. Proceed with implementation (fix pre-existing issues later)
2. Investigate failures before proceeding
3. Abandon worktree and fix main branch first

**Awaiting guidance.**
```

### Phase 7: Ready for Implementation

**Report final state:**
```
✓ Worktree ready at {full-path}
✓ Tests passing ({N} tests, 0 failures)
✓ Ready to implement {feature-name}

You can now:
- Use openagent-planning to create implementation plan
- Use openagent-tdd to begin test-driven implementation
```

## Cleanup (When Feature Complete)

**Request approval for cleanup:**
```
Feature implementation complete in worktree.

Cleanup options:
1. Merge to main branch
2. Create pull request
3. Keep worktree for further work
4. Discard changes and remove worktree

**What would you like to do?**
```

## Quick Reference

| Situation | Action |
|-----------|--------|
| `.worktrees/` exists | Use it (verify ignored) |
| `worktrees/` exists | Use it (verify ignored) |
| Both exist | Use `.worktrees/` |
| Neither exists | Check CLAUDE.md → Ask user |
| Directory not ignored | Request approval to add to .gitignore |
| Tests fail during baseline | Report failures + ask for guidance |
| No package.json/Cargo.toml | Skip dependency install |

## OpenAgent Safety Adaptations

**Differences from native Superpowers:**
- **Explicit approval** before creating worktree
- **Request permission** to modify .gitignore (don't auto-modify)
- **Ask for guidance** if baseline tests fail (don't auto-proceed)
- **Report progress** at each phase
- **No automatic directory assumption** - always follow priority order

## Integration with Other Skills

**Called by:**
- `openagent-brainstorming` - After design approved
- `openagent-planning` - Before executing plan

**Pairs with:**
- `openagent-tdd` - TDD implementation in isolated workspace
- `openagent-planning` - Execute plan in worktree

## Red Flags - STOP and Request Guidance

**Never:**
- Create worktree without verifying it's ignored (project-local)
- Skip baseline test verification
- Proceed with failing tests without asking
- Assume directory location when ambiguous
- Skip CLAUDE.md check

**Always:**
- Follow directory priority: existing > CLAUDE.md > ask
- Verify directory is ignored for project-local
- Auto-detect and run project setup
- Verify clean test baseline
- Request approval before creating

**If you catch yourself:**
- Skipping ignore verification
- Creating worktree without approval
- Proceeding with failing baseline tests
- Hardcoding directory location

**STOP and ask:**
```
⚠️ About to violate git-worktrees safety rule: [describe]

Should I:
1. Follow proper worktree process
2. Skip this safety check (not recommended)
3. Other approach?

**Awaiting guidance.**
```
