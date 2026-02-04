---
name: openagent-tdd
description: Use when implementing any feature or bugfix - wraps superpowers:test-driven-development with approval gates
---

# OpenAgent Test-Driven Development (Approval-Gated)

This skill wraps the Superpowers TDD workflow with OpenAgent's approval gates and safety measures.

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? **Stop and request approval to delete it and start over.**

## When to Use

**Always:**
- New features
- Bug fixes
- Refactoring
- Behavior changes

**Exceptions (ask your human partner):**
- Throwaway prototypes
- Generated code
- Configuration files

## OpenAgent TDD Workflow

### Phase 1: Request Approval to Start TDD

**Before any implementation:**
```
I'll implement this using TDD (Test-Driven Development).

Approach:
1. Write failing test first
2. Verify test fails for the right reason
3. Write minimal code to pass
4. Verify all tests pass
5. Refactor if needed (keeping tests green)
6. Commit

**Approval needed before proceeding.**
```

### Phase 2: RED - Write Failing Test (After Approval)

**Load the Superpowers TDD skill:**
Use the native `skill` tool to load `superpowers/test-driven-development`

**Write one minimal test:**
- Test one behavior
- Clear, descriptive name
- Use real code (avoid mocks unless unavoidable)

**Example:**
```typescript
test('retries failed operations 3 times', async () => {
  let attempts = 0;
  const operation = () => {
    attempts++;
    if (attempts < 3) throw new Error('fail');
    return 'success';
  };

  const result = await retryOperation(operation);

  expect(result).toBe('success');
  expect(attempts).toBe(3);
});
```

### Phase 3: Verify RED - Watch It Fail (MANDATORY)

**Run the test and verify it fails:**
```bash
npm test path/to/test.test.ts
```

**Confirm:**
- Test fails (not errors)
- Failure message is expected
- Fails because feature is missing (not typos)

**Report to user:**
```
Test written and verified failing:
- Test: test_specific_behavior
- Failure: "function not defined" ✓ (expected)

Ready to implement minimal code to pass.
**Approval needed to proceed.**
```

### Phase 4: GREEN - Write Minimal Code (After Approval)

**Write simplest code to pass the test:**
- Just enough to make test pass
- No extra features (YAGNI)
- No refactoring other code
- No improvements beyond the test

**Example:**
```typescript
async function retryOperation<T>(fn: () => Promise<T>): Promise<T> {
  for (let i = 0; i < 3; i++) {
    try {
      return await fn();
    } catch (e) {
      if (i === 2) throw e;
    }
  }
  throw new Error('unreachable');
}
```

### Phase 5: Verify GREEN - Watch It Pass (MANDATORY)

**Run tests and verify:**
```bash
npm test path/to/test.test.ts
```

**Confirm:**
- Test passes
- Other tests still pass
- No errors or warnings

**Report to user:**
```
Tests passing:
- New test: PASS ✓
- All other tests: PASS ✓
- Output pristine (no errors/warnings) ✓

Ready to commit or refactor.
**What would you like to do next?**
```

### Phase 6: REFACTOR (Optional, Keeping Tests Green)

**Only after green:**
- Remove duplication
- Improve names
- Extract helpers

**Keep tests green throughout - run after each change**

### Phase 7: Commit (Request Approval)

**After tests are green:**
```
Ready to commit:
- Test file: tests/path/test.test.ts
- Implementation: src/path/file.ts

Proposed commit message:
"feat: add retry operation with 3 attempts"

**Approval needed to commit.**
```

## Red Flags - STOP and Request Guidance

**If you catch yourself:**
- Writing code before test
- Test after implementation
- Test passes immediately
- Can't explain why test failed
- Thinking "I'll test later"
- "I already manually tested it"
- "Keep code as reference, write tests first"
- "This is too simple to test"

**STOP and ask:**
```
⚠️ Red flag detected: [describe what happened]

Should I:
1. Delete code and start over with TDD
2. Continue with tests-after approach
3. Other approach?

**Awaiting guidance.**
```

## Code Written Before Tests?

**The rule is absolute:**
```
Code written before test exists?
→ Request approval to delete it
→ Start over with TDD
→ No exceptions without human partner's permission
```

**Request approval:**
```
⚠️ Code was written before test.

Per TDD rules, I should delete this code and start over:
- Files to delete: [list]
- Reason: Cannot verify test was working (no failing test observed)

**Approval needed to delete and restart with TDD.**
```

## OpenAgent Safety Adaptations

**Differences from native Superpowers:**
- **Explicit approval gates** before writing code
- **Request permission to delete** non-TDD code (don't auto-delete)
- **Report test results** at each phase
- **Ask for guidance** on red flags instead of auto-enforcing
- **Commit approval** required

## Integration with Other Skills

**Use TDD with:**
- `openagent-planning` - TDD tasks in implementation plan
- `openagent-debugging` - Write failing test reproducing bug first
- `openagent-git-worktrees` - TDD in isolated workspace

## Verification Checklist

**Before marking work complete:**

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] Each test failed for expected reason (feature missing, not typo)
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass
- [ ] Output pristine (no errors, warnings)
- [ ] Tests use real code (mocks only if unavoidable)
- [ ] Edge cases and errors covered
- [ ] Got approval before committing

**Can't check all boxes? Request guidance on how to proceed.**

## Final Rule

```
Production code → test exists and failed first
Otherwise → request approval to delete and restart
```

No exceptions without your human partner's permission.
