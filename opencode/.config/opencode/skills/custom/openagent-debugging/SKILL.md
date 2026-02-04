---
name: openagent-debugging
description: Use when encountering any bug, test failure, or unexpected behavior - wraps superpowers:systematic-debugging with approval gates
---

# OpenAgent Systematic Debugging (Approval-Gated)

This skill wraps the Superpowers systematic debugging workflow with OpenAgent's approval gates and safety measures.

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1 investigation, you cannot propose fixes.

## When to Use

Use for ANY technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**
- Under time pressure
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

## OpenAgent Debugging Workflow

### Phase 0: Request Approval to Start Investigation

**Before attempting ANY fix:**
```
Encountered issue: [brief description]

I'll use systematic debugging to find the root cause.

Investigation phases:
1. Root Cause Investigation (gather evidence, trace data flow)
2. Pattern Analysis (compare with working examples)
3. Hypothesis and Testing (minimal changes, one at a time)
4. Implementation (create test, fix root cause, verify)

**Approval needed before investigating.**
```

### Phase 1: Root Cause Investigation (After Approval)

**Load the Superpowers debugging skill:**
Use the native `skill` tool to load `superpowers/systematic-debugging`

**1. Read Error Messages Carefully**
- Don't skip past errors or warnings
- Read stack traces completely
- Note line numbers, file paths, error codes

**2. Reproduce Consistently**
- Can you trigger it reliably?
- What are exact steps?
- Does it happen every time?

**3. Check Recent Changes**
- What changed that could cause this?
- Git diff, recent commits
- New dependencies, config changes

**4. Gather Evidence in Multi-Component Systems**

For systems with multiple components (CI → build → signing, API → service → database):

**Request approval to add diagnostics:**
```
This is a multi-component system. Need to add diagnostic instrumentation.

Will add logging at each component boundary:
- [List each component where you'll add logging]
- [Show what data will be logged]

**Approval needed to add diagnostics.**
```

**5. Trace Data Flow**

If error is deep in call stack, trace backward:
- Where does bad value originate?
- What called this with bad value?
- Keep tracing up until you find the source

**Report findings:**
```
Root cause investigation complete:

Evidence gathered:
- [List key findings]
- [Error messages, reproduction steps]
- [Recent changes identified]

Data flow traced:
- [Show backward trace from symptom to source]

Root cause identified: [description]

**Ready to proceed to Phase 2 (Pattern Analysis).**
**Approval needed to continue.**
```

### Phase 2: Pattern Analysis (After Approval)

**Find the pattern before fixing:**

1. **Find Working Examples**
   - Locate similar working code in same codebase
   
2. **Compare Against References**
   - Read reference implementation COMPLETELY
   - Understand the pattern fully

3. **Identify Differences**
   - List every difference between working and broken
   - Don't assume "that can't matter"

**Report findings:**
```
Pattern analysis complete:

Working example found: [location]
Key differences identified:
- [List differences]

Dependencies understood:
- [List required components, settings, config]

**Ready to proceed to Phase 3 (Hypothesis).**
**Approval needed to continue.**
```

### Phase 3: Hypothesis and Testing (After Approval)

**Form and test hypothesis scientifically:**

**Request approval to test hypothesis:**
```
Hypothesis formed:
"I think [X] is the root cause because [Y]"

Proposed minimal test:
- Make this single change: [describe]
- Test this one variable: [describe]
- Expected outcome: [describe]

**Approval needed to test hypothesis.**
```

**After testing:**
```
Hypothesis test results:
- Change made: [describe]
- Outcome: [worked/didn't work]

[If worked] → Ready for Phase 4 (Implementation)
[If didn't work] → Need to form new hypothesis

**What would you like to do next?**
```

**When You Don't Know:**
```
I don't understand [X].

Options:
1. Research more about [X]
2. Ask for help with [X]
3. Try different approach

**What would you like me to do?**
```

### Phase 4: Implementation (After Approval)

**Fix the root cause, not the symptom:**

**1. Request Approval to Create Failing Test**
```
Ready to create failing test case.

Test approach:
- [Describe simplest possible reproduction]
- [Automated test or one-off script]

**Approval needed to create test.**
```

**2. Request Approval to Implement Fix**
```
Test created and failing as expected.

Proposed fix:
- Root cause: [describe]
- Single change: [describe fix]
- No bundled improvements or refactoring

**Approval needed to implement fix.**
```

**3. Verify Fix**
```
Fix implemented.

Verification:
- Test passes now: [✓/✗]
- Other tests broken: [list or "none"]
- Issue resolved: [✓/✗]

[If all ✓] → Ready to commit
[If any ✗] → Need to revise approach

**What would you like to do next?**
```

**4. If Fix Doesn't Work (Stop and Assess)**

**After 2 failed fix attempts:**
```
⚠️ Two fixes attempted, neither resolved the issue.

Should I:
1. Return to Phase 1 (re-analyze with new information)
2. Try different hypothesis
3. Question the architecture (3+ failures = architectural problem)

**Awaiting guidance on how to proceed.**
```

**After 3 failed fix attempts:**
```
⚠️ Three fixes have failed. This indicates an architectural problem.

Pattern observed:
- Each fix reveals new problem in different place
- Fixes require massive refactoring
- Each fix creates new symptoms elsewhere

Recommendation: Question the fundamental approach rather than attempt more fixes.

Should we:
1. Refactor architecture to address root issue
2. Discuss alternative patterns
3. Continue with symptom fixes (not recommended)

**Architectural discussion needed before proceeding.**
```

## Red Flags - STOP and Request Guidance

**If you catch yourself thinking:**
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Here are the main problems:" [lists fixes without investigation]
- "One more fix attempt" (when already tried 2+)

**STOP and ask:**
```
⚠️ Red flag detected: [describe what you were about to do]

This violates systematic debugging process.

Should I:
1. Return to Phase 1 (proper investigation)
2. Continue with current approach
3. Other approach?

**Awaiting guidance.**
```

## OpenAgent Safety Adaptations

**Differences from native Superpowers:**
- **Explicit approval gates** before each phase
- **Report findings** at each phase completion
- **Request permission** before adding diagnostics
- **Ask for guidance** on red flags instead of auto-enforcing
- **Stop at 3 failed fixes** and question architecture
- **No automatic test creation** - request approval first

## Integration with Other Skills

**Use systematic debugging with:**
- `openagent-tdd` - Create failing test reproducing bug (Phase 4)
- `openagent-planning` - Debug as part of implementation plan
- `openagent-git-worktrees` - Debug in isolated workspace

## Quick Reference

| Phase | Key Activities | Report to User |
|-------|---------------|----------------|
| **0. Approval** | Request permission to investigate | Proposed phases |
| **1. Root Cause** | Read errors, reproduce, gather evidence, trace data flow | Evidence and root cause |
| **2. Pattern** | Find working examples, compare, identify differences | Patterns and differences |
| **3. Hypothesis** | Form theory, request approval, test minimally | Hypothesis and test results |
| **4. Implementation** | Create test, fix, verify (all with approval) | Fix results and verification |

## Final Rule

```
Propose fixes → After Phase 1 complete
Otherwise → Request approval to investigate properly
```

No exceptions without your human partner's permission.
