---
name: openagent-skill-index
description: Use when starting any conversation - establishes OpenAgent skills and approval gate philosophy
---

# OpenAgent Skill Index

**Core principle:** OpenAgent skills integrate approval gates throughout proven development workflows, ensuring safety-first development.

## Skill Catalog

When working on coding tasks, use these OpenAgent custom skills:

| Task Type | Use This Skill |
|-----------|---------------|
| Design/brainstorming new features | `custom/openagent-brainstorming` |
| Implementing code (any feature/bugfix) | `custom/openagent-test-driven-development` |
| Debugging/troubleshooting | `custom/openagent-systematic-debugging` |
| Creating isolated workspace | `custom/openagent-using-git-worktrees` |
| Writing implementation plans | `custom/openagent-writing-plans` |
| Executing written plans | `custom/openagent-executing-plans` |
| Subagent-driven development | `custom/openagent-subagent-driven-development` |
| Finishing development branch | `custom/openagent-finishing-a-development-branch` |
| Requesting code review | `custom/openagent-requesting-code-review` |
| Receiving code review feedback | `custom/openagent-receiving-code-review` |
| Verification before completion | `custom/openagent-verification-before-completion` |
| Dispatching parallel agents | `custom/openagent-dispatching-parallel-agents` |
| Creating new skills | `custom/openagent-writing-skills` |
| Understanding skill usage | `custom/openagent-using-skills` |

## OpenAgent Philosophy

OpenAgent skills integrate **approval gates** at phase transitions:

**Approval gate pattern:**
- ⏸️ Request approval before major operations
- ⏸️ Report results after operations complete
- ⏸️ Stop on failure, propose fixes, request approval
- ⏸️ Ask permission for destructive actions

**Why approval gates matter:**
- Prevents accidental destructive operations
- Ensures user awareness at each phase
- Creates natural checkpoints for review
- Aligns with safety-first development

## Automatic Skill Detection

**When you see these user requests:**

| User Says | You Should Think | Load This Skill |
|-----------|------------------|-----------------|
| "Build/add/create [feature]" | Design needed | `custom/openagent-brainstorming` |
| "Write a plan for..." | Planning needed | `custom/openagent-writing-plans` |
| "Execute this plan" | Batch execution | `custom/openagent-executing-plans` |
| "Implement [feature]" | TDD implementation | `custom/openagent-test-driven-development` |
| "Fix this bug" | Systematic debugging | `custom/openagent-systematic-debugging` |
| "Start working on [feature]" | Need isolated workspace | `custom/openagent-using-git-worktrees` |
| "Write tests for..." | TDD workflow | `custom/openagent-test-driven-development` |
| "Something's not working" | Debug systematically | `custom/openagent-systematic-debugging` |
| "Review this code" | Request review | `custom/openagent-requesting-code-review` |
| "I'm done with this feature" | Finish branch | `custom/openagent-finishing-a-development-branch` |
| "Verify this works" | Verification needed | `custom/openagent-verification-before-completion` |
| "Multiple independent failures" | Parallel dispatch | `custom/openagent-dispatching-parallel-agents` |

## Workflow Integration

**Typical OpenAgent workflow:**

1. **New Feature Request**
   ```
   User: "Add user authentication"
   
   You: Load custom/openagent-brainstorming
        → Request approval to start brainstorming
        → Ask questions, explore design
        → Request approval to save design doc
        → Request approval to create worktree (load custom/openagent-using-git-worktrees)
        → Request approval to begin TDD (load custom/openagent-test-driven-development)
   ```

2. **Bug Report**
   ```
   User: "Login endpoint returning 500 error"
   
   You: Load custom/openagent-systematic-debugging
        → Request approval to investigate
        → Phase 1: Root cause investigation
        → Phase 2: Pattern analysis
        → Phase 3: Hypothesis testing
        → Phase 4: Create test + fix (use custom/openagent-test-driven-development)
   ```

3. **Implementation Task**
   ```
   User: "Implement the user registration endpoint"
   
   You: Load custom/openagent-test-driven-development
        → Request approval to start TDD
        → RED: Write failing test
        → Verify test fails
        → Request approval to implement
        → GREEN: Write minimal code
        → Verify tests pass
        → Request approval to commit
   ```

## Checking for Skills

**Before ANY response (even clarifying questions), check:**

1. Is this a new feature/design? → Load `custom/openagent-brainstorming`
2. Is this implementation/code change? → Load `custom/openagent-test-driven-development`
3. Is this a bug/failure/unexpected behavior? → Load `custom/openagent-systematic-debugging`
4. Does this need isolated workspace? → Load `custom/openagent-using-git-worktrees`
5. Writing or executing implementation plans? → Load `custom/openagent-writing-plans` or `custom/openagent-executing-plans`
6. Multiple independent tasks/failures? → Load `custom/openagent-subagent-driven-development` or `custom/openagent-dispatching-parallel-agents`
7. Code review needed? → Load `custom/openagent-requesting-code-review` or `custom/openagent-receiving-code-review`
8. About to claim completion? → Load `custom/openagent-verification-before-completion`
9. Development work complete? → Load `custom/openagent-finishing-a-development-branch`

**The rule from openagent-using-skills applies:**
> "Invoke relevant or requested skills BEFORE any response or action. Even a 1% chance a skill might apply means that you should invoke the skill to check."

## All OpenAgent Custom Skills Available

All 14 OpenAgent skills with approval-gated workflows:

**Tier 1: Core Development Workflows (8 skills)**
- `custom/openagent-test-driven-development` - TDD with approval gates
- `custom/openagent-systematic-debugging` - 4-phase debugging with approval gates
- `custom/openagent-brainstorming` - Design exploration with approval gates
- `custom/openagent-using-git-worktrees` - Isolated workspace with approval gates
- `custom/openagent-executing-plans` - Plan execution with approval gates
- `custom/openagent-writing-plans` - Implementation planning with approval gates
- `custom/openagent-subagent-driven-development` - Subagent workflows with approval gates
- `custom/openagent-finishing-a-development-branch` - Branch completion with approval gates

**Tier 2: Code Quality & Review (4 skills)**
- `custom/openagent-requesting-code-review` - Code review requests with approval gates
**Tier 2: Code Quality & Review (4 skills)**
- `custom/openagent-requesting-code-review` - Code review requests with approval gates
- `custom/openagent-receiving-code-review` - Review feedback handling with approval gates
- `custom/openagent-verification-before-completion` - Evidence-based completion with approval gates
- `custom/openagent-dispatching-parallel-agents` - Parallel task dispatch with approval gates

**Foundation Skills (2 skills)**
- `custom/openagent-using-skills` - Skill usage methodology
- `custom/openagent-writing-skills` - TDD for creating new skills

## Red Flags - Skill Not Loaded

**If you catch yourself:**
- Writing code without loading `custom/openagent-test-driven-development`
- Starting to debug without loading `custom/openagent-systematic-debugging`
- Asking design questions without loading `custom/openagent-brainstorming`
- Creating worktree without loading `custom/openagent-using-git-worktrees`
- Writing/executing plans without loading the appropriate skill
- Requesting/receiving code review without loading the appropriate skill
- About to claim completion without loading `custom/openagent-verification-before-completion`
- Finishing branch without loading `custom/openagent-finishing-a-development-branch`

**STOP and load the appropriate skill first.**

## Summary

**The key principle:**
```
OpenAgent Skills = Proven Methodology + Approval Gates
```

**Your job:**
1. Detect task type from user request
2. Load appropriate `custom/openagent-*` skill
3. Follow skill workflow with approval gates
4. Request approval before major operations
