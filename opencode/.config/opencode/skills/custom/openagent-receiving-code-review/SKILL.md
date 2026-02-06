---
name: openagent-receiving-code-review
description: Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - wraps superpowers:receiving-code-review with approval gates
---

# Code Review Reception - OpenAgent Version

## Overview

Code review requires technical evaluation, not emotional performance. **With approval gates at each phase.**

**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

**OpenAgent integration:** This skill integrates approval gates from OpenAgent's safety-first philosophy. You will request approval before each major action.

## The Response Pattern with Approval Gates

```dot
digraph review_flow_openagent {
    rankdir=TB;
    read [label="READ\nComplete feedback\nwithout reacting", shape=box];
    report_understanding [label="⏸️ REPORT\nUnderstanding\nto user", shape=box, style=filled, fillcolor="#ffffcc"];
    unclear [label="Any item\nunclear?", shape=diamond];
    approval_clarify [label="⏸️ REQUEST\nAPPROVAL\nto ask questions", shape=diamond, style=filled, fillcolor="#ffffcc"];
    ask [label="ASK\nClarifying\nquestions", shape=box];
    verify [label="VERIFY\nAgainst codebase", shape=box];
    evaluate [label="EVALUATE\nTechnically sound?", shape=diamond];
    pushback [label="Push back with\ntechnical reasoning", shape=box];
    approval_implement [label="⏸️ REQUEST\nAPPROVAL\nto implement", shape=diamond, style=filled, fillcolor="#ffffcc"];
    implement [label="IMPLEMENT\nOne item at a time", shape=box];
    approval_test [label="⏸️ REQUEST\nAPPROVAL\nto test each fix", shape=diamond, style=filled, fillcolor="#ffffcc"];
    test [label="TEST\nEach fix", shape=box];
    more_items [label="More\nitems?", shape=diamond];
    report_complete [label="⏸️ REPORT\nImplementation\ncomplete", shape=box, style=filled, fillcolor="#ffffcc"];
    done [label="Done", shape=ellipse];

    read -> report_understanding;
    report_understanding -> unclear;
    unclear -> approval_clarify [label="yes"];
    unclear -> verify [label="no"];
    approval_clarify -> ask [label="approved"];
    ask -> verify [label="after\nclarification"];
    verify -> evaluate;
    evaluate -> pushback [label="no"];
    evaluate -> approval_implement [label="yes"];
    pushback -> done [label="discuss\nwith user"];
    approval_implement -> implement [label="approved"];
    implement -> approval_test;
    approval_test -> test [label="approved"];
    test -> more_items;
    more_items -> implement [label="yes"];
    more_items -> report_complete [label="no"];
    report_complete -> done;
}
```

**Process:**
1. **READ:** Complete feedback without reacting
2. **⏸️ REPORT UNDERSTANDING:** Restate requirements in your own words
3. **UNDERSTAND:** If unclear, request approval to ask clarifying questions
4. **VERIFY:** Check against codebase reality
5. **EVALUATE:** Technically sound for THIS codebase?
6. **RESPOND:** Technical acknowledgment or reasoned pushback
7. **⏸️ REQUEST APPROVAL:** Before implementing changes
8. **IMPLEMENT:** One item at a time
9. **⏸️ REQUEST APPROVAL:** Before testing each fix
10. **⏸️ REPORT COMPLETE:** After all implementation done

## Forbidden Responses

**NEVER:**
- "You're absolutely right!" (explicit CLAUDE.md violation)
- "Great point!" / "Excellent feedback!" (performative)
- "Let me implement that now" (before verification AND approval)

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions
- Push back with technical reasoning if wrong
- Just start working (actions > words) - after approval

## Phase 1: Reading and Understanding

**⏸️ AFTER reading feedback, REPORT your understanding:**

"I understand the feedback as:
1. [Restate item 1]
2. [Restate item 2]
...

Items [X, Y] are unclear - need clarification on [specific questions]."

**If ANY item is unclear:**

**⏸️ REQUEST APPROVAL:** "May I ask clarifying questions about items [X, Y]?"

**After approval, ASK for clarification:**

```
STOP - do not implement anything yet
ASK for clarification on unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

**Example:**
```
your human partner: "Fix 1-6"
You understand 1,2,3,6. Unclear on 4,5.

❌ WRONG: Implement 1,2,3,6 now, ask about 4,5 later
✅ RIGHT: "⏸️ I understand items 1,2,3,6. Items 4 and 5 are unclear - may I ask clarifying questions?"
```

## Source-Specific Handling

### From your human partner
- **Trusted** - implement after understanding AND approval
- **Still ask** if scope unclear
- **No performative agreement**
- **Skip to action** or technical acknowledgment (after approval)

### From External Reviewers

**BEFORE implementing:**
```
1. Check: Technically correct for THIS codebase?
2. Check: Breaks existing functionality?
3. Check: Reason for current implementation?
4. Check: Works on all platforms/versions?
5. Check: Does reviewer understand full context?

IF suggestion seems wrong:
  Push back with technical reasoning
  
IF can't easily verify:
  Say so: "I can't verify this without [X]. Should I [investigate/ask/proceed]?"
  
IF conflicts with your human partner's prior decisions:
  Stop and discuss with your human partner first
```

**your human partner's rule:** "External feedback - be skeptical, but check carefully"

## YAGNI Check for "Professional" Features

```
IF reviewer suggests "implementing properly":
  grep codebase for actual usage
  
  IF unused: "This endpoint isn't called. Remove it (YAGNI)?"
  IF used: Then implement properly
```

**your human partner's rule:** "You and reviewer both report to me. If we don't need this feature, don't add it."

## Phase 2: Implementation with Approval Gates

**⏸️ REQUEST APPROVAL before implementing:**

"May I implement the following changes:
- [Item 1 description]
- [Item 2 description]
...

I will implement and test each one individually."

**After approval, implement in this order:**
1. Blocking issues (breaks, security)
2. Simple fixes (typos, imports)
3. Complex fixes (refactoring, logic)

**⏸️ REQUEST APPROVAL before testing each fix:**

"May I test the fix for [item description]?"

**After approval, test each fix individually:**
```bash
npm test [relevant-test-file]
```

Verify no regressions.

## Phase 3: Reporting Completion

**⏸️ REPORT after all implementation complete:**

"Implementation complete:
- ✅ [Item 1]: [Brief description of change]
- ✅ [Item 2]: [Brief description of change]
...

All tests pass. Output: [show relevant test results]"

## When To Push Back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Legacy/compatibility reasons exist
- Conflicts with your human partner's architectural decisions

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests/code
- Involve your human partner if architectural

**Signal if uncomfortable pushing back out loud:** "Strange things are afoot at the Circle K"

## Acknowledging Correct Feedback

When feedback IS correct:
```
✅ "Fixed. [Brief description of what changed]"
✅ "Good catch - [specific issue]. Fixed in [location]."
✅ [Just fix it and show in the code]

❌ "You're absolutely right!"
❌ "Great point!"
❌ "Thanks for catching that!"
❌ "Thanks for [anything]"
❌ ANY gratitude expression
```

**Why no thanks:** Actions speak. Just fix it. The code itself shows you heard the feedback.

**If you catch yourself about to write "Thanks":** DELETE IT. State the fix instead.

## Gracefully Correcting Your Pushback

If you pushed back and were wrong:
```
✅ "You were right - I checked [X] and it does [Y]. Implementing now."
✅ "Verified this and you're correct. My initial understanding was wrong because [reason]. Fixing."

❌ Long apology
❌ Defending why you pushed back
❌ Over-explaining
```

State the correction factually and move on.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Performative agreement | State requirement or just act |
| Blind implementation | Verify against codebase first |
| Implementing without approval | Request approval at each phase |
| Batch without testing | One at a time, test each |
| Assuming reviewer is right | Check if breaks things |
| Avoiding pushback | Technical correctness > comfort |
| Partial implementation | Clarify all items first |
| Can't verify, proceed anyway | State limitation, ask for direction |
| Skipping approval gates | Request approval at checkpoints |

## Real Examples

**Performative Agreement (Bad):**
```
Reviewer: "Remove legacy code"
❌ "You're absolutely right! Let me remove that..."
```

**Technical Verification with Approval (Good):**
```
Reviewer: "Remove legacy code"
✅ "⏸️ Checking against codebase...

Build target is 10.15+, this API needs 13+. Need legacy for backward compat. Current impl has wrong bundle ID.

Two options:
1. Fix bundle ID and keep legacy support
2. Drop pre-13 support and remove legacy code

Which approach should I take?"
```

**YAGNI with Approval (Good):**
```
Reviewer: "Implement proper metrics tracking with database, date filters, CSV export"
✅ "⏸️ Grepped codebase - nothing calls this endpoint. 

Remove it (YAGNI)? Or is there usage I'm missing?"
```

**Unclear Item with Approval (Good):**
```
your human partner: "Fix items 1-6"
You understand 1,2,3,6. Unclear on 4,5.
✅ "⏸️ I understand items 1,2,3,6 as:
1. [restate]
2. [restate]
3. [restate]
6. [restate]

Items 4 and 5 are unclear - may I ask clarifying questions?"
```

## GitHub Thread Replies

When replying to inline review comments on GitHub, reply in the comment thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.

## OpenAgent Approval Gate Summary

**Approval points in code review cycle:**
1. ⏸️ After reading feedback (report understanding)
2. ⏸️ Before asking clarifying questions (if unclear)
3. ⏸️ Before implementing changes
4. ⏸️ Before testing each fix
5. ⏸️ After implementation complete (report results)

**Why approval gates matter:**
- Prevents hasty implementation without verification
- Ensures user awareness before making changes
- Aligns with OpenAgent's safety-first philosophy
- Creates natural checkpoints for technical evaluation
- Prevents blind acceptance of external feedback

## Red Flags - STOP

These thoughts mean you're rationalizing:

| Thought | Reality |
|---------|---------|
| "Reviewer knows best, implement now" | Verify first. Reviewers can be wrong. |
| "Simple change, no approval needed" | All changes need approval. Simple = fast approval. |
| "Tests can wait, batch them" | Test each fix individually. Regressions hide. |
| "User will approve anyway" | Request anyway. Builds trust and awareness. |
| "Skip formality, just fix it" | Formality = safety. Follow process. |
| "Partial implementation is progress" | Partial understanding = wrong implementation. |

**All of these mean: STOP. Follow approval gates.**

## The Bottom Line

**External feedback = suggestions to evaluate, not orders to follow.**

Verify. Question. Request approval. Then implement.

No performative agreement. Technical rigor always. **Approval gates at every phase.**
