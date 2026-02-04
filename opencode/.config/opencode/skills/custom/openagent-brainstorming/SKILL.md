---
name: openagent-brainstorming
description: Use before creative work - wraps superpowers:brainstorming with OpenAgent approval gates
---

# OpenAgent Brainstorming (Approval-Gated)

This skill wraps the Superpowers brainstorming workflow with OpenAgent's approval gates and safety measures.

## When to Use

Use this skill BEFORE any creative work:
- Creating new features
- Building components
- Adding functionality
- Modifying behavior
- Architectural changes

## Workflow

### Phase 1: Request Approval to Start

**Before beginning brainstorming:**
```
I'd like to use the brainstorming workflow to explore this feature design.

Proposed approach:
1. Understand current project context
2. Ask questions one at a time to refine the idea
3. Explore 2-3 alternative approaches with trade-offs
4. Present design in digestible sections (200-300 words each)
5. Save validated design to docs/plans/YYYY-MM-DD-{topic}-design.md

**Approval needed before proceeding.**
```

### Phase 2: Understanding the Idea (After Approval)

**Load the Superpowers brainstorming skill:**
Use the native `skill` tool to load `superpowers/brainstorming`

**Follow the brainstorming process:**
1. Check out current project state (files, docs, recent commits)
2. Ask questions one at a time to refine the idea
3. Prefer multiple choice questions when possible
4. Focus on understanding: purpose, constraints, success criteria

**Key principles:**
- ONE question per message
- Multiple choice preferred over open-ended
- Break complex topics into multiple questions

### Phase 3: Exploring Approaches

**After understanding the problem:**
1. Propose 2-3 different approaches with trade-offs
2. Present options conversationally with your recommendation
3. Lead with your recommended option and explain why
4. Apply YAGNI ruthlessly - remove unnecessary features

### Phase 4: Presenting the Design

**Once you understand what to build:**
1. Present design in sections of 200-300 words
2. Ask after each section: "Does this look right so far?"
3. Be ready to go back and clarify if something doesn't make sense
4. Cover: architecture, components, data flow, error handling, testing

### Phase 5: Documentation (Request Approval)

**After design is validated:**
```
Design exploration complete. Ready to document.

Proposed action:
- Save design to docs/plans/YYYY-MM-DD-{topic}-design.md
- Commit design document to git

**Approval needed to save and commit.**
```

### Phase 6: Implementation Setup (Request Approval)

**After documentation saved:**
```
Ready to set up for implementation?

Next steps:
1. Create isolated workspace with git worktree
2. Create detailed implementation plan
3. Begin TDD implementation

**Approval needed to proceed with setup.**
```

## OpenAgent Safety Adaptations

**Differences from native Superpowers:**
- **Explicit approval gates** at each major phase
- **No automatic file writes** - request approval before saving design
- **No automatic worktree creation** - request approval before setup
- **Report-first approach** - present plan before executing

## Integration with Other Skills

**After brainstorming completes:**
- Use `openagent-git-worktrees` for isolated workspace
- Use `openagent-planning` for implementation breakdown
- Use `openagent-tdd` for test-driven implementation

## Key Principles

- **One question at a time** - Don't overwhelm
- **Multiple choice preferred** - Easier to answer
- **YAGNI ruthlessly** - Remove unnecessary features
- **Explore alternatives** - 2-3 approaches before settling
- **Incremental validation** - Present design in sections
- **Approval gates** - Request permission at each major phase
