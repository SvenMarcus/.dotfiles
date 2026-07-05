---
name: tdd-reference
description: Use when implementing features or bugfixes with TDD and need patterns, gears, test design, naming, test smells, test doubles strategy, refactoring priorities, builders setup, or ubiquitous language guidance
---

# TDD Reference

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

Covers naming, partitions, step size, test doubles, refactoring priorities, builders, smells, domain language, and the full TDD discipline.

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

## When to Use

**Always:** New features, bug fixes, refactoring, behavior changes.

**Exceptions (ask your human partner):** Throwaway prototypes, generated code, configuration files.

Thinking "skip TDD just this once"? Stop. That's rationalization.

## Seams — Where to Test

A seam is the public boundary you test at: the interface where you observe behavior without reaching inside. Tests live at seams, never against internals.

Before writing any test, identify the seam — the public API or behavior boundary you're testing through. If unclear, ask your human partner.

Good seams: function parameters + return value, service public methods, HTTP request/response.
Bad seams: private methods, internal state, bypassing the public API to query the database directly.

## The Three Laws of TDD

1. **No production code** unless it makes a failing test pass.

2. **No more of a test** than sufficient to fail. Compilation failures are failures.
   — **Verify RED:** Run the test. Confirm it fails for the expected reason (feature missing, not typos). If it passes, you're testing existing behavior — fix the test. If it errors, fix the error. Never skip this step.

3. **No more production code** than sufficient to pass the one failing test.
   — **Verify GREEN:** Run all tests. Confirm the test passes, other tests still pass, output is pristine (no errors/warnings). If it fails, fix code not test. If other tests break, fix them now.

Refactor only when green.

## When to Use Which Step Size

Take smaller steps in unfamiliar territory, larger steps when patterns are established:

| Context                                               | Step Size | Approach                                              |
| ----------------------------------------------------- | --------- | ----------------------------------------------------- |
| Unfamiliar domain or algorithm                        | Small     | One assertion at a time, strict cycle verification    |
| Familiar domain with known patterns                   | Medium    | Short-circuit repetition, focus on design quality     |
| Following established pattern (same as existing code) | Larger    | Can write more code per cycle, still verify each step |
| Stuck (tried 2+ approaches, still failing)            | Reverse   | Back out to green, try different angle                |

Rule of thumb: if you've tried 2 approaches and the test is still red, reverse and restart.

## Choosing What to Test — Partitions and Boundaries

Test at behavior-change boundaries, not random values.

Identify where behavior changes. Those are your boundaries. Test the value before, on, and after each boundary.

```typescript
function shippingCost(subtotal: number): string {
  if (subtotal <= 0) return "invalid";
  if (subtotal < 50) return "standard";
  return "free";
}
// Boundaries: subtotal=0 (invalid→standard), subtotal=50 (standard→free)
// Tests: { -1, 0, 1 } for invalid boundary, { 49, 50, 51 } for free boundary
```

For non-linear partitions (e.g., FizzBuzz: divisible by 3, 5, 15), group by behavior and test one representative + each boundary.

## Good Test Characteristics — FIRST + EM

| Quality             | Means                              | Violation                    |
| ------------------- | ---------------------------------- | ---------------------------- |
| **F**ast            | Runs in milliseconds               | Integration-heavy suite      |
| **I**solated        | No shared state, order-independent | Shared records between tests |
| **R**eliable        | Same result every run              | Flaky pass/fail              |
| **S**elf-validating | Pass/fail automatic                | Manual inspection needed     |
| **T**imely          | Written test-first                 | Tests after implementation   |
| **E**xpressive      | Name + body describe behavior      | `test1`, magic values        |
| **M**aintainable    | Easy to add/modify/remove          | 50-line setup duplicated 20x |

## Test Naming

### Stages of Naming

Names improve through stages. Push names toward domain language over time:

| Stage           | Example                                          | Problem                                   |
| --------------- | ------------------------------------------------ | ----------------------------------------- |
| **Meaningless** | `var x; function f1()`                           | No clue what it does                      |
| **Specific**    | `var repositoryForHandlingLineItemsForCustomerX` | Too tied to one scenario, hard to reuse   |
| **Meaningful**  | `var itemCatalogue; function catalogueIsEmpty()` | Speaks domain language, easy to work with |
| **General**     | `var repository; function areItemsEmpty()`       | So vague it could mean anything           |

Start with whatever name you have. Improve it each time you read the code.

### Naming Convention

```
MethodName_Given{Scenario}_Should{ExpectedResult}
```

```typescript
// Good
test('FizzBuzz_GivenMultipleOf3_ShouldReturnFizz', () => { ... });
test('ParseLogLine_GivenEmptyLine_ShouldReturnNull', () => { ... });

// Avoid
test('test1', () => { ... });
test('fizzbuzz works', () => { ... });
test('testing log parser', () => { ... });
```

Follow case conventions of the project's language, for example PascalCase in C#, camelCase in Java or snake_case in Python. Underscores may still be used in test names even when coding in non-snake-case languages to improve the readability of the test name.

## Test Smells — Recognize and Fix

| Smell                         | Symptom                                                       | Fix                                                             |
| ----------------------------- | ------------------------------------------------------------- | --------------------------------------------------------------- |
| Exposing internals            | Tests access private state or assert call order               | Test public behavior and results                                |
| Too many constructor params   | 5+ dependencies                                               | Split object (SRP)                                              |
| Replicating production code   | Test duplicates production logic                              | Test knows expected output, not computation                     |
| Fragile tests                 | Break from unrelated changes                                  | Reduce coupling, test behavior not implementation               |
| Test code duplication         | Same setup in 10 tests                                        | Extract factory methods or builders                             |
| Test case abuse               | 20 cases in one test                                          | One test per behavior                                           |
| Logic in tests                | Loops, conditionals in test body                              | Keep tests declarative                                          |
| Multiple concerns             | Name contains "and" or "or"                                   | Split                                                           |
| Leaky mock abstraction        | Verifying call order across 3+ mocks                          | Test result, not sequence                                       |
| Mocking without understanding | Using mocks when a simpler double would do                    | Match double to dependency role                                 |
| Test-only methods             | Adding public methods to production classes just for testing  | Test through the real public API                                |
| Tautological tests            | Expected value recomputed the same way as the code under test | Use known-good literals, not recomputed values                  |
| Horizontal slicing            | Writing all tests first, then all implementation at once      | One test → implementation → next test, vertical slice per cycle |

## Breaking Dependencies — Choosing the Right Test Double

| Type     | What It Is                            | When to Use                                                           | Example                                               |
| -------- | ------------------------------------- | --------------------------------------------------------------------- | ----------------------------------------------------- |
| **Fake** | Simplified working implementation     | Expensive dependency (database, API) that needs realistic behavior    | In-memory list replacing database repository          |
| **Stub** | Predefined responses, no state change | Need controlled return values from a dependency                       | Return specific characters from a `ReadChar()` source |
| **Mock** | Records calls, test verifies them     | Behavior is an interaction, not a return value (email, event publish) | Verify `emailService.SendMessage()` was called        |

Pick the test double that matches the dependency's role, not what's easiest.

- **Stubs for queries** (return data, no side effects)
- **Mocks for commands** (side effects, no return value)
- **Fakes for both** (when you need a lightweight replacement for a real service)

**Don't mock your own code.** Mock at system boundaries only — external APIs, databases (sometimes), time/randomness, file system (sometimes). Never mock your own classes, internal collaborators, or anything you control.

Avoid verifying call order across multiple mocks — that's the Leaky Abstraction Trap.

## Refactoring Priorities

When in the REFACTOR phase, address in this order:

1. **Identify concepts** — Does each class/method have a single responsibility? Extract grouping responsibilities.
2. **Name things well** — Push names toward Meaningful (domain language). Use Stages of Naming.
3. **Apply SOLID** — Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion.
4. **DRY** — Remove duplication, but only if it represents the same concept (you can describe it without using "and").

## Test Data Builders

Replace primitive-heavy test setup with a composable domain-language API.

**The pattern:**

1. Builder exposes only dimensions a test cares about
2. Defaults are always valid
3. Fluent setters return the builder
4. `build()` returns a real domain object

```typescript
// Before: 10 lines of noise
const customer = new Customer(Guid.NewGuid(), 'test@test.com', 'Gold', ...);
// After: 3 lines stating what matters
const order = anOrder().forCustomer(aLoyaltyMember()).containing(twoBooks()).build();
```

| Layer                | Purpose                                        |
| -------------------- | ---------------------------------------------- |
| **Builder**          | Composable fluent construction                 |
| **Object Mother**    | Named canonical instances (`aLoyaltyMember()`) |
| **Scenario Factory** | Preconfigured worlds for complex setup         |

Builders compose with mocks: builders provide input, mocks verify collaboration.

## Ubiquitous Language in Tests

Three rules:

1. **Test names are business claims.** `Orders_over_fifty_dollars_ship_free`, not `ProcessOrder_Test_1`.
2. **Setup speaks the domain.** `aLoyaltyMember().in(california())`, not `new Customer{Tier="gold", Address=new Address{State="CA"}}`.
3. **Assertions use domain types.** `receipt.Shipping.Should().Be(Free)`, not `Assert.AreEqual(0m, receipt.ShippingCost)`.

When business terms change, rename domain types, builders, and test names in the same PR. Never leave drift for later.

## When Stuck

**Bug found?** Write a failing test that reproduces it. Follow the TDD cycle. The test proves the fix and prevents regression. Never fix bugs without a test.

If a test is still red after 2 attempts:

**Back Out:**

1. Revert to the last green test run (comment out or stash the failing test)
2. Remove production code that was only needed for that test
3. Choose a new approach: smaller step, or a Learning Test

**Learning Test:**
Isolate the tricky code in a throwaway test to verify assumptions about how it works:

```typescript
// Learning test — NOT part of production test suite
test("LearningTest_Goal_UnderstandSplitBehavior", () => {
  const result = "".split(/[,;|\s]+/);
  expect(result).toEqual([""]); // Verify: JS split never returns []
});
```

Once the assumption is validated, roll the knowledge back into production code and remove the learning test.

## Core Discipline

**Violating the letter of the rules is violating the spirit of the rules.** This cuts off the entire class of "I'm following the spirit, not the rules" rationalizations.

## Red Flags

Any of these means you skipped TDD. Stop and restart:

- Code before test
- Test passes immediately
- Can't explain why test failed
- Rationalizing "just this once"
- "I already manually tested it"
- "Tests after achieve the same purpose"
- "It's about spirit not ritual"
- "Being pragmatic, not dogmatic"
- "Keep as reference" or "adapt existing code"
- "Already spent X hours, deleting is wasteful"

**All of these mean: Delete non-test code. Start over with TDD.**

## Common Rationalizations

| Excuse                                          | Reality                                                                                      |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------- |
| "Too simple to test"                            | Simple code breaks. Test takes 30 seconds.                                                   |
| "I'll test after"                               | Tests passing immediately prove nothing.                                                     |
| "Tests after achieve same goals"                | Tests-after = "what does this do?" Tests-first = "what should this do?"                      |
| "Already manually tested"                       | Ad-hoc ≠ systematic. No record, can't re-run.                                                |
| "Deleting X hours is wasteful"                  | Sunk cost fallacy. Keeping unverified code is technical debt.                                |
| "Obvious implementation is faster"              | Obvious Implementation is a trap. 2 failing attempts = reverse.                              |
| "One test with 5 test cases is efficient"       | Test case abuse. Each scenario gets its own test with a clear name.                          |
| "I'll just mock everything"                     | Mocking = testing implementation coupling, not behavior. Use Stubs for queries.              |
| "The setup is the same, I'll reuse the test"    | Multiple concerns in one test. Split into separate named tests.                              |
| "I don't need a builder, this is just one test" | Every test without a builder makes the next one harder. Start with builders.                 |
| "I can clean up naming later"                   | No. Push names toward Meaningful before moving on. "Later" doesn't come.                     |
| "Test doubles don't matter, they're all mocks"  | Fakes, Stubs, and Mocks serve different purposes. Using the wrong one creates brittle tests. |
