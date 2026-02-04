---
name: openagent-skill-index
description: Use when starting any conversation - establishes OpenAgent skill priority and approval gates
---

# OpenAgent Skill Index

**IMPORTANT: This skill index runs AFTER `using-superpowers` is loaded. It overrides Superpowers skill selection with OpenAgent's approval-gated versions.**

## Skill Priority for OpenAgent

When working on coding tasks, **ALWAYS prefer OpenAgent custom skills** over native Superpowers skills:

| Task Type | Use This Skill | Instead Of |
|-----------|---------------|------------|
| Design/brainstorming new features | `custom/openagent-brainstorming` | `superpowers/brainstorming` |
| Implementing code (any feature/bugfix) | `custom/openagent-tdd` | `superpowers/test-driven-development` |
| Debugging/troubleshooting | `custom/openagent-debugging` | `superpowers/systematic-debugging` |
| Creating isolated workspace | `custom/openagent-git-worktrees` | `superpowers/using-git-worktrees` |

## Why OpenAgent Custom Skills?

The custom skills wrap Superpowers workflows with **approval gates** that match OpenAgent's safety-first philosophy:

**Superpowers (native):**
- Auto-triggers workflows
- Deletes code that violates TDD
- Auto-creates worktrees
- Auto-modifies .gitignore

**OpenAgent (custom):**
- Requests approval before each phase
- Asks permission to delete code
- Requests approval before creating worktrees
- Asks permission to modify .gitignore
- Reports progress at each phase

## Automatic Skill Detection

**When you see these user requests:**

| User Says | You Should Think | Load This Skill |
|-----------|------------------|-----------------|
| "Build/add/create [feature]" | Design needed | `custom/openagent-brainstorming` |
| "Implement [feature]" | TDD implementation | `custom/openagent-tdd` |
| "Fix this bug" | Systematic debugging | `custom/openagent-debugging` |
| "Start working on [feature]" | Need isolated workspace | `custom/openagent-git-worktrees` |
| "Write tests for..." | TDD workflow | `custom/openagent-tdd` |
| "Something's not working" | Debug systematically | `custom/openagent-debugging` |

## Workflow Integration

**Typical OpenAgent workflow:**

1. **New Feature Request**
   ```
   User: "Add user authentication"
   
   You: Load custom/openagent-brainstorming
        → Request approval to start brainstorming
        → Ask questions, explore design
        → Request approval to save design doc
        → Request approval to create worktree (load custom/openagent-git-worktrees)
        → Request approval to begin TDD (load custom/openagent-tdd)
   ```

2. **Bug Report**
   ```
   User: "Login endpoint returning 500 error"
   
   You: Load custom/openagent-debugging
        → Request approval to investigate
        → Phase 1: Root cause investigation
        → Phase 2: Pattern analysis
        → Phase 3: Hypothesis testing
        → Phase 4: Create test + fix (use custom/openagent-tdd)
   ```

3. **Implementation Task**
   ```
   User: "Implement the user registration endpoint"
   
   You: Load custom/openagent-tdd
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
2. Is this implementation/code change? → Load `custom/openagent-tdd`
3. Is this a bug/failure/unexpected behavior? → Load `custom/openagent-debugging`
4. Does this need isolated workspace? → Load `custom/openagent-git-worktrees`

**The rule from using-superpowers still applies:**
> "Invoke relevant or requested skills BEFORE any response or action. Even a 1% chance a skill might apply means that you should invoke the skill to check."

**But now you know to prefer OpenAgent custom skills over Superpowers skills.**

## Native Superpowers Skills Still Available

You can still use native Superpowers skills for:
- `superpowers/writing-plans` - Implementation planning
- `superpowers/executing-plans` - Batch plan execution
- `superpowers/subagent-driven-development` - Subagent workflows
- `superpowers/receiving-code-review` - Responding to feedback
- `superpowers/verification-before-completion` - Final checks

**These don't have OpenAgent custom wrappers yet, so use the Superpowers versions directly.**

## Red Flags - Skill Not Loaded

**If you catch yourself:**
- Writing code without loading `custom/openagent-tdd`
- Starting to debug without loading `custom/openagent-debugging`
- Asking design questions without loading `custom/openagent-brainstorming`
- Creating worktree without loading `custom/openagent-git-worktrees`

**STOP and load the appropriate skill first.**

## Summary

**The key principle:**
```
OpenAgent = Superpowers methodology + Approval gates
```

**Your job:**
1. Detect task type from user request
2. Load appropriate `custom/openagent-*` skill
3. Follow skill workflow with approval gates
4. Use native `superpowers/*` skills when no custom wrapper exists
