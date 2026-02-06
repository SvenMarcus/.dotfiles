---
name: openagent-test-driven-development
description: Use when implementing any feature or bugfix with OpenAgent approval gates at each TDD phase
---

# Test-Driven Development (TDD) - OpenAgent Version

## Overview

Write the test first. Watch it fail. Write minimal code to pass. **With approval gates at each phase.**

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

**Violating the letter of the rules is violating the spirit of the rules.**

**OpenAgent integration:** This skill integrates approval gates from OpenAgent's safety-first philosophy. You will request approval before each major phase.

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

Thinking "skip TDD just this once"? Stop. That's rationalization.

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

**No exceptions:**
- Don't keep it as "reference"
- Don't "adapt" it while writing tests
- Don't look at it
- Delete means delete

Implement fresh from tests. Period.

## Red-Green-Refactor with Approval Gates

```dot
digraph tdd_cycle_openagent {
    rankdir=LR;
    approval_red [label="⏸️ REQUEST\nAPPROVAL\nto write test", shape=diamond, style=filled, fillcolor="#ffffcc"];
    red [label="RED\nWrite failing test", shape=box, style=filled, fillcolor="#ffcccc"];
    verify_red [label="Verify fails\ncorrectly", shape=diamond];
    report_red [label="⏸️ REPORT\nTest fails\nas expected", shape=box, style=filled, fillcolor="#ffffcc"];
    approval_green [label="⏸️ REQUEST\nAPPROVAL\nto implement", shape=diamond, style=filled, fillcolor="#ffffcc"];
    green [label="GREEN\nMinimal code", shape=box, style=filled, fillcolor="#ccffcc"];
    verify_green [label="Verify passes\nAll green", shape=diamond];
    report_green [label="⏸️ REPORT\nTests pass", shape=box, style=filled, fillcolor="#ffffcc"];
    approval_refactor [label="⏸️ REQUEST\nAPPROVAL\nto refactor", shape=diamond, style=filled, fillcolor="#ffffcc"];
    refactor [label="REFACTOR\nClean up", shape=box, style=filled, fillcolor="#ccccff"];
    approval_commit [label="⏸️ REQUEST\nAPPROVAL\nto commit", shape=diamond, style=filled, fillcolor="#ffffcc"];
    next [label="Next", shape=ellipse];

    approval_red -> red [label="approved"];
    red -> verify_red;
    verify_red -> report_red [label="yes"];
    verify_red -> red [label="wrong\nfailure"];
    report_red -> approval_green;
    approval_green -> green [label="approved"];
    green -> verify_green;
    verify_green -> report_green [label="yes"];
    verify_green -> green [label="no"];
    report_green -> approval_refactor;
    approval_refactor -> refactor [label="approved"];
    approval_refactor -> approval_commit [label="skip"];
    refactor -> verify_green [label="stay\ngreen"];
    verify_green -> approval_commit [label="from\nrefactor"];
    approval_commit -> next [label="approved"];
    next -> approval_red;
}
```

### Phase 1: RED - Write Failing Test

**⏸️ REQUEST APPROVAL:** "May I write a failing test for [feature/bugfix]?"

**After approval, write one minimal test showing what should happen:**

<Good>
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
Clear name, tests real behavior, one thing
</Good>

<Bad>
```typescript
test('retry works', async () => {
  const mock = jest.fn()
    .mockRejectedValueOnce(new Error())
    .mockRejectedValueOnce(new Error())
    .mockResolvedValueOnce('success');
  await retryOperation(mock);
  expect(mock).toHaveBeenCalledTimes(3);
});
```
Vague name, tests mock not code
</Bad>

**Requirements:**
- One behavior
- Clear name
- Real code (no mocks unless unavoidable)

### Verify RED - Watch It Fail

**MANDATORY. Never skip.**

```bash
npm test path/to/test.test.ts
```

Confirm:
- Test fails (not errors)
- Failure message is expected
- Fails because feature missing (not typos)

**Test passes?** You're testing existing behavior. Fix test.

**Test errors?** Fix error, re-run until it fails correctly.

**⏸️ REPORT TO USER:** "Test fails as expected with message: [show failure output]. Ready to implement?"

### Phase 2: GREEN - Minimal Code

**⏸️ REQUEST APPROVAL:** "May I implement the minimal code to make this test pass?"

**After approval, write simplest code to pass the test:**

<Good>
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
Just enough to pass
</Good>

<Bad>
```typescript
async function retryOperation<T>(
  fn: () => Promise<T>,
  options?: {
    maxRetries?: number;
    backoff?: 'linear' | 'exponential';
    onRetry?: (attempt: number) => void;
  }
): Promise<T> {
  // YAGNI
}
```
Over-engineered
</Bad>

Don't add features, refactor other code, or "improve" beyond the test.

### Verify GREEN - Watch It Pass

**MANDATORY.**

```bash
npm test path/to/test.test.ts
```

Confirm:
- Test passes
- Other tests still pass
- Output pristine (no errors, warnings)

**Test fails?** Fix code, not test.

**Other tests fail?** Fix now.

**⏸️ REPORT TO USER:** "Tests now pass. Output: [show test results]. Ready to refactor (if needed) or commit?"

### Phase 3: REFACTOR - Clean Up

**⏸️ REQUEST APPROVAL:** "May I refactor to [describe improvement]?" (Skip if no refactoring needed)

**After approval, refactor only:**

After green only:
- Remove duplication
- Improve names
- Extract helpers

Keep tests green. Don't add behavior.

**⏸️ VERIFY:** Run tests again, report results.

### Phase 4: COMMIT

**⏸️ REQUEST APPROVAL:** "May I commit these changes? Files: [list files]"

**After approval:**

```bash
git add [test-file] [implementation-file]
git commit -m "feat: add [feature description]"
```

### Repeat

Next failing test for next feature.

## Good Tests

| Quality | Good | Bad |
|---------|------|-----|
| **Minimal** | One thing. "and" in name? Split it. | `test('validates email and domain and whitespace')` |
| **Clear** | Name describes behavior | `test('test1')` |
| **Shows intent** | Demonstrates desired API | Obscures what code should do |

## Why Order Matters

**"I'll write tests after to verify it works"**

Tests written after code pass immediately. Passing immediately proves nothing:
- Might test wrong thing
- Might test implementation, not behavior
- Might miss edge cases you forgot
- You never saw it catch the bug

Test-first forces you to see the test fail, proving it actually tests something.

**"I already manually tested all the edge cases"**

Manual testing is ad-hoc. You think you tested everything but:
- No record of what you tested
- Can't re-run when code changes
- Easy to forget cases under pressure
- "It worked when I tried it" ≠ comprehensive

Automated tests are systematic. They run the same way every time.

**"Deleting X hours of work is wasteful"**

Sunk cost fallacy. The time is already gone. Your choice now:
- Delete and rewrite with TDD (X more hours, high confidence)
- Keep it and add tests after (30 min, low confidence, likely bugs)

The "waste" is keeping code you can't trust. Working code without real tests is technical debt.

**"TDD is dogmatic, being pragmatic means adapting"**

TDD IS pragmatic:
- Finds bugs before commit (faster than debugging after)
- Prevents regressions (tests catch breaks immediately)
- Documents behavior (tests show how to use code)
- Enables refactoring (change freely, tests catch breaks)

"Pragmatic" shortcuts = debugging in production = slower.

**"Tests after achieve the same goals - it's spirit not ritual"**

No. Tests-after answer "What does this do?" Tests-first answer "What should this do?"

Tests-after are biased by your implementation. You test what you built, not what's required. You verify remembered edge cases, not discovered ones.

Tests-first force edge case discovery before implementing. Tests-after verify you remembered everything (you didn't).

30 minutes of tests after ≠ TDD. You get coverage, lose proof tests work.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Tests after achieve same goals" | Tests-after = "what does this do?" Tests-first = "what should this do?" |
| "Already manually tested" | Ad-hoc ≠ systematic. No record, can't re-run. |
| "Deleting X hours is wasteful" | Sunk cost fallacy. Keeping unverified code is technical debt. |
| "Keep as reference, write tests first" | You'll adapt it. That's testing after. Delete means delete. |
| "Need to explore first" | Fine. Throw away exploration, start with TDD. |
| "Test hard = design unclear" | Listen to test. Hard to test = hard to use. |
| "TDD will slow me down" | TDD faster than debugging. Pragmatic = test-first. |
| "Manual test faster" | Manual doesn't prove edge cases. You'll re-test every change. |
| "Existing code has no tests" | You're improving it. Add tests for existing code. |

## Red Flags - STOP and Start Over

- Code before test
- Test after implementation
- Test passes immediately
- Can't explain why test failed
- Tests added "later"
- Rationalizing "just this once"
- "I already manually tested it"
- "Tests after achieve the same purpose"
- "It's about spirit not ritual"
- "Keep as reference" or "adapt existing code"
- "Already spent X hours, deleting is wasteful"
- "TDD is dogmatic, I'm being pragmatic"
- "This is different because..."
- **Skipping approval gates to "save time"**

**All of these mean: Delete code. Start over with TDD.**

## Example: Bug Fix with Approval Gates

**Bug:** Empty email accepted

**⏸️ REQUEST APPROVAL:** "May I write a failing test to reproduce the empty email bug?"

**After approval - RED:**
```typescript
test('rejects empty email', async () => {
  const result = await submitForm({ email: '' });
  expect(result.error).toBe('Email required');
});
```

**Verify RED:**
```bash
$ npm test
FAIL: expected 'Email required', got undefined
```

**⏸️ REPORT:** "Test fails as expected - submitForm accepts empty email. Ready to implement fix?"

**After approval - GREEN:**
```typescript
function submitForm(data: FormData) {
  if (!data.email?.trim()) {
    return { error: 'Email required' };
  }
  // ...
}
```

**Verify GREEN:**
```bash
$ npm test
PASS
```

**⏸️ REPORT:** "Tests now pass. Ready to commit?"

**After approval - COMMIT:**
```bash
git add tests/submit-form.test.ts src/submit-form.ts
git commit -m "fix: reject empty email in submitForm"
```

## Verification Checklist

Before marking work complete:

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] Each test failed for expected reason (feature missing, not typo)
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass
- [ ] Output pristine (no errors, warnings)
- [ ] Tests use real code (mocks only if unavoidable)
- [ ] Edge cases and errors covered
- [ ] **Requested approval at each phase checkpoint**

Can't check all boxes? You skipped TDD. Start over.

## When Stuck

| Problem | Solution |
|---------|----------|
| Don't know how to test | Write wished-for API. Write assertion first. Ask your human partner. |
| Test too complicated | Design too complicated. Simplify interface. |
| Must mock everything | Code too coupled. Use dependency injection. |
| Test setup huge | Extract helpers. Still complex? Simplify design. |

## Debugging Integration

Bug found? Write failing test reproducing it. Follow TDD cycle with approval gates. Test proves fix and prevents regression.

Never fix bugs without a test.

## Testing Anti-Patterns

When adding mocks or test utilities, read @testing-anti-patterns.md to avoid common pitfalls:
- Testing mock behavior instead of real behavior
- Adding test-only methods to production classes
- Mocking without understanding dependencies

## OpenAgent Approval Gate Summary

**Approval points in TDD cycle:**
1. ⏸️ Before writing test (RED phase)
2. ⏸️ After test fails (report failure)
3. ⏸️ Before implementing code (GREEN phase)
4. ⏸️ After tests pass (report success)
5. ⏸️ Before refactoring (REFACTOR phase - optional)
6. ⏸️ Before committing (COMMIT phase)

**Why approval gates matter:**
- Prevents accidental code-first development
- Ensures user awareness at each phase
- Aligns with OpenAgent's safety-first philosophy
- Creates natural checkpoints for review

## Final Rule

```
Production code → test exists and failed first → approval at each phase
Otherwise → not OpenAgent TDD
```

No exceptions without your human partner's permission.
