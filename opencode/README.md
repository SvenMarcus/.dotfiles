# OpenCode + OpenAgent + OpenAgentsControl Integration

This directory contains a complete AI coding agent setup that combines:

1. **[OpenCode](https://opencode.ai)** - Open-source AI coding framework (base)
2. **[OpenAgentsControl](https://github.com/darrenhinde/OpenAgentsControl)** - Approval-first agents with context management
3. **OpenAgent Skills** - Standalone approval-gated workflows for TDD, debugging, brainstorming, etc.

## Architecture

```
~/.config/opencode/                           # Final merged configuration
├── agent/                                    # ← From OpenAgentsControl
│   ├── core/                                 #   Main agents (OpenAgent, OpenCoder)
│   └── subagents/                            #   Specialized subagents
├── command/                                  # ← From OpenAgentsControl
│   └── (custom commands like /add-context)  #   Commands for workflow
├── context/                                  # ← From OpenAgentsControl
│   └── (MVI context files)                  #   Your coding patterns
├── plugins/                                  # ← From dotfiles (this repo)
│   └── openagent.js                         #   Auto-loads OpenAgent skills
├── skills/                                   # ← From dotfiles (this repo)
│   └── custom/                              #   OpenAgent skills (14 total)
│       ├── openagent-skill-index/           #   Skill routing and catalog
│       ├── openagent-using-skills/          #   Foundation: skill usage
│       ├── openagent-writing-skills/        #   Foundation: skill creation
│       ├── openagent-test-driven-development/
│       ├── openagent-systematic-debugging/
│       ├── openagent-brainstorming/
│       ├── openagent-using-git-worktrees/
│       ├── openagent-writing-plans/
│       ├── openagent-executing-plans/
│       ├── openagent-subagent-driven-development/
│       ├── openagent-finishing-a-development-branch/
│       ├── openagent-requesting-code-review/
│       ├── openagent-receiving-code-review/
│       ├── openagent-verification-before-completion/
│       └── openagent-dispatching-parallel-agents/
└── superpowers-reference/                   # ← Reference only (not loaded)
    └── (Original Superpowers skills)        #   Kept for historical reference
```

## What Each System Provides

### OpenCode (Base Framework)

- Terminal-based AI coding interface
- Model-agnostic (Claude, GPT, Gemini, local models)
- Plugin system for extensibility
- Native skill tool for loading workflows
- Built-in agents (compaction, summary, etc.)

### OpenAgentsControl (Agents + Context)

- **OpenAgent** - General-purpose agent with approval gates
- **OpenCoder** - Production development agent (Discover → Propose → Approve → Execute)
- **Specialized subagents** - ContextScout, TaskManager, CodeReviewer, etc.
- **Commands** - `/add-context`, `/commit`, `/test`, `/optimize`, etc.
- **Context system** - MVI (Minimal Viable Information) pattern management
- **Approval-first workflow** - You review plans before execution

### OpenAgent Skills (14 Total)

**Foundation Skills (2)**:
- **openagent-using-skills** - Skill usage discipline (when to invoke, how to follow)
- **openagent-writing-skills** - TDD for creating new skills with supporting tools

**Core Development Workflows (8)**:
- **openagent-test-driven-development** - TDD workflow (RED → GREEN → REFACTOR) with approval gates
- **openagent-systematic-debugging** - 4-phase debug workflow with approval gates
- **openagent-brainstorming** - Design exploration before implementation with approval gates
- **openagent-using-git-worktrees** - Isolated workspace creation with approval gates
- **openagent-writing-plans** - Implementation planning with approval gates
- **openagent-executing-plans** - Batch plan execution with approval gates
- **openagent-subagent-driven-development** - Subagent workflows with approval gates
- **openagent-finishing-a-development-branch** - Branch completion with approval gates

**Code Quality & Review (4)**:
- **openagent-requesting-code-review** - Code review requests with approval gates
- **openagent-receiving-code-review** - Review feedback handling with approval gates
- **openagent-verification-before-completion** - Evidence-based completion with approval gates
- **openagent-dispatching-parallel-agents** - Parallel task dispatch with approval gates

### Our Custom Integration (This Repo)

- **Plugin** - Auto-injects OpenAgent foundation skills
- **Skills** - 14 standalone approval-gated workflows
- **Stow integration** - Overlay configuration on top of OpenAgentsControl

## Installation

### Fresh Machine

```bash
# 1. Clone dotfiles with submodules
git clone --recurse-submodules https://github.com/YourUsername/.dotfiles.git ~/.dotfiles

# 2. Run bootstrap
cd ~/.dotfiles
./bootstrap.sh
```

The bootstrap script will:

1. ✅ Install OpenCode via Homebrew
2. ✅ Install OpenAgentsControl (agents, commands, context)
3. ✅ Stow your custom config (plugins + skills overlay)

### Manual Installation

If you already have OpenCode installed:

```bash
# Install OpenAgentsControl
curl -fsSL https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/main/install.sh | \
  bash -s developer --install-dir ~/.config/opencode

# Stow custom config
cd ~/.dotfiles
stow opencode
```

## How It Works

### Startup Flow

```
1. User runs: opencode --agent OpenAgent

2. OpenCode starts:
   ├─ Loads plugins from ~/.config/opencode/plugins/
   │  └─ openagent.js injects foundation skills content
   │     ├─ openagent-using-skills (skill usage discipline)
   │     └─ openagent-skill-index (skill catalog & routing)
   │
   ├─ Loads OpenAgent from ~/.config/opencode/agent/core/openagent.md
   │
   └─ Agent has access to:
      ├─ OpenAgent skills (via skill tool) - 14 total
      ├─ OpenAgentsControl commands (/add-context, etc.)
      └─ OpenAgentsControl context files
```

## Usage

### Main Agents (from OpenAgentsControl)

```bash
# General-purpose agent (start here)
opencode --agent OpenAgent

# Production development agent
opencode --agent OpenCoder

# Custom AI system builder
opencode --agent SystemBuilder
```

### Key Commands (from OpenAgentsControl)

```bash
/add-context       # Add your coding patterns (10-15 min one-time setup)
/commit            # Smart git commits with conventional format
/test              # Testing workflows
/optimize          # Code optimization
/context           # Context management
```

### Adding Your Patterns

The first time you use OpenAgentsControl, add your patterns:

```bash
opencode --agent OpenAgent
> /add-context
```

Answer 6 questions:

1. Tech stack? (Next.js + TypeScript + PostgreSQL)
2. API endpoint example? (paste your code)
3. Component example? (paste your code)
4. Naming conventions? (kebab-case, PascalCase)
5. Code standards? (TypeScript strict, Zod validation)
6. Security requirements? (validate input, parameterized queries)

**Result:** Agents generate code matching your exact patterns. No refactoring needed.

## Skill Auto-Loading

**OpenAgent Plugin** injects bootstrap content that tells agents:

- "You have OpenAgent skills"
- "Check for skills BEFORE any response"
- "Even a 1% chance a skill applies → invoke it"
- "Prefer approval-gated workflows"
- "Follow skill discipline from openagent-using-skills"

**Skill Routing** from openagent-skill-index tells agents:

- Which skill to use for each task type
- When to load foundation vs workflow skills
- How approval gates integrate with workflows

**Result:** Agents automatically use the right skills at the right time.

### Example Workflow

```bash
opencode --agent OpenCoder
> "Create a user authentication system"
```

**What happens:**

1. **Skill Auto-Detection**
   - Agent detects: "This is a new feature"
   - Loads: `custom/openagent-brainstorming`
   - Asks design questions before coding

2. **Context Discovery**
   - OpenAgentsControl's ContextScout finds your patterns
   - Loads your tech stack, API patterns, naming conventions

3. **Approval-First Execution**
   - Proposes detailed implementation plan
   - Waits for your approval
   - Executes step-by-step with validation

4. **Automatic Workflows**
   - Uses `custom/openagent-test-driven-development` for implementation
   - Red → Green → Refactor cycle with approval gates
   - CodeReviewer validates security

5. **Production-Ready Code**
   - Matches your exact patterns (from context)
   - Follows TDD workflow (from OpenAgent skills)
   - Approval-gated throughout

## OpenAgent Custom Skills

These skills are **standalone versions** of Superpowers workflows with integrated approval gates at each phase. They're not simple wrappers - they contain the complete workflow with approval checkpoints embedded throughout.

### Tier 1: Core Development Workflows (8 skills)

#### openagent-test-driven-development

Use when implementing features/bugfixes - complete TDD workflow with approval gates

**Workflow**:

1. ⏸️ Request approval to write failing test (RED)
2. Write test, verify it fails correctly
3. ⏸️ Report failure, request approval to implement
4. Write minimal code (GREEN)
5. Verify tests pass
6. ⏸️ Report success, request approval to refactor (optional)
7. ⏸️ Request approval to commit

**Key Difference**: Requests permission at each phase instead of auto-executing

#### openagent-systematic-debugging

Use for any bug/test failure - 4-phase debugging with approval gates

**Workflow**:

1. ⏸️ Request approval to investigate
2. Phase 1: Root cause investigation → ⏸️ Report findings
3. ⏸️ Request approval for Phase 2: Pattern analysis → ⏸️ Report patterns
4. ⏸️ Request approval for Phase 3: Hypothesis testing → ⏸️ Report results
5. ⏸️ Request approval for Phase 4: Implementation → ⏸️ Report fix

**Key Difference**: Reports at each phase, stops for user input

#### openagent-brainstorming

Use before creative work - design exploration with approval gates

**Workflow**:

1. ⏸️ Request approval to explore project context
2. ⏸️ Request approval to ask questions (one at a time)
3. ⏸️ Request approval to propose 2-3 approaches
4. ⏸️ Request approval to present design sections
5. ⏸️ Request approval to save design document
6. ⏸️ Request approval to commit design doc
7. ⏸️ Request approval for implementation setup

**Key Difference**: User controls when design moves to implementation

#### openagent-using-git-worktrees

Use when starting feature work - isolated workspace with approval gates

**Workflow**:

1. ⏸️ Request approval to check directories
2. ⏸️ Report directory found/chosen
3. ⏸️ Request approval to modify .gitignore (if needed)
4. ⏸️ Request approval to create worktree
5. ⏸️ Request approval to run project setup
6. ⏸️ Report baseline test results

**Key Difference**: Won't auto-modify .gitignore or create worktree without permission

#### openagent-writing-plans

Use when planning multi-step tasks - implementation planning with approval gates

**Workflow**:

1. ⏸️ Request approval to explore codebase
2. ⏸️ Request approval to write plan
3. ⏸️ Report plan complete, request review
4. ⏸️ Request approval to save plan file
5. ⏸️ Request approval to commit plan
6. ⏸️ Request approval before offering execution choice

**Key Difference**: User reviews plan before it's saved

#### openagent-executing-plans

Use for executing written plans - batch execution with approval gates

**Workflow**:

1. ⏸️ Request approval to load plan (report any concerns)
2. ⏸️ Request approval to execute batch N (3 tasks default)
3. ⏸️ Report batch complete, wait for feedback
4. ⏸️ Request approval to apply feedback changes
5. Repeat until complete
6. ⏸️ Request approval to finish branch

**Key Difference**: No auto-batching - user sees progress at each batch

#### openagent-subagent-driven-development

Use for executing plans with subagents - subagent workflows with approval gates

**Workflow**:

1. ⏸️ Request approval to read plan and create TodoWrite
2. ⏸️ Request approval to dispatch implementer subagent (per task)
3. ⏸️ Request approval to dispatch spec reviewer subagent
4. ⏸️ Request approval to dispatch code quality reviewer
5. ⏸️ Request approval to move to next task
6. ⏸️ Request approval for final code review
7. ⏸️ Request approval to finish branch

**Key Difference**: User maintains control throughout automated workflow

#### openagent-finishing-a-development-branch

Use when implementation complete - branch completion with approval gates

**Workflow**:

1. ⏸️ Request approval to verify tests
2. ⏸️ Report test results (pass/fail)
3. ⏸️ Request approval to present 4 options (if tests pass)
4. User chooses: Merge locally, Push & PR, Keep as-is, or Discard
5. ⏸️ Request approval to execute chosen option
6. ⏸️ Request approval for worktree cleanup

**Key Difference**: User explicitly chooses merge strategy

### Tier 2: Code Quality & Review (4 skills)

#### openagent-requesting-code-review

Use when completing tasks - code review requests with approval gates

**Workflow**:

1. ⏸️ Request approval to get git SHAs
2. ⏸️ Request approval to dispatch code-reviewer subagent
3. ⏸️ Report feedback from reviewer
4. ⏸️ Request approval to fix Critical issues
5. ⏸️ Request approval to fix Important issues
6. ⏸️ Request approval to proceed to next task

**Key Difference**: User sees review feedback before fixes applied

#### openagent-receiving-code-review

Use when receiving feedback - review response with approval gates

**Workflow**:

1. ⏸️ Report understanding of feedback
2. ⏸️ Request approval to ask clarifying questions (if unclear)
3. ⏸️ Request approval to implement changes
4. ⏸️ Request approval to test each fix
5. ⏸️ Report implementation complete

**Key Difference**: Preserves anti-performative stance ("no 'You're absolutely right!'") while adding approval gates

#### openagent-verification-before-completion

Use before claiming completion - evidence-based completion with approval gates

**Workflow**:

1. ⏸️ Request approval to run verification command
2. Run verification, capture full output
3. ⏸️ Report evidence (actual output, exit code, failures)
4. ⏸️ Request approval to claim success (only if evidence supports it)
5. ⏸️ Request approval before commit/PR

**Key Difference**: Forces "evidence before claims" with approval checkpoints

#### openagent-dispatching-parallel-agents

Use for multiple independent failures - parallel dispatch with approval gates

**Workflow**:

1. ⏸️ Request approval to identify independent domains
2. ⏸️ Request approval to create agent tasks (review scope)
3. ⏸️ Request approval to dispatch agents in parallel
4. ⏸️ Report agent summaries when complete
5. ⏸️ Request approval to integrate changes
6. ⏸️ Request approval to run full test suite
7. ⏸️ Report verification results

**Key Difference**: User approves parallel dispatch strategy before execution

## Using Skills

### Load an OpenAgent Skill

```
use skill tool to load custom/openagent-test-driven-development
```

### List Available Skills

```
use skill tool to list skills
```

Skills are auto-loaded when agents detect task types. Manual loading is optional.

## Adding Custom Skills

Create a new skill in `~/.dotfiles/opencode/.config/opencode/skills/custom/`:

```bash
mkdir -p ~/.dotfiles/opencode/.config/opencode/skills/custom/my-skill
```

Create `SKILL.md`:

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

[Your skill content here]
```

Use `custom/openagent-writing-skills` for TDD workflow to create new skills.

The skill will be automatically available after restart or when stowed.

## Philosophy

**OpenAgent Skills**: Standalone approval-gated workflows for disciplined development

**OpenAgentsControl**: Context-aware agents with approval-first execution

**This Integration**: Complete autonomous development system

- Structured methodologies (TDD, systematic debugging, brainstorming)
- Approval gates at every phase transition
- Safety-first approach (report-first, stop-on-failure)
- Context-aware code generation (matches your patterns)

## Key Workflow Features

| Feature | How It Works |
|---------|-------------|
| TDD Enforcement | Approval gates at RED/GREEN/REFACTOR transitions |
| Systematic Debugging | 4-phase workflow with approval at each phase |
| Git Worktrees | Requests approval before creating isolated workspace |
| Plan Execution | Approval per task or batch, never autonomous |
| Code Review | Reports findings, requests approval to fix |
| Verification | Evidence-based completion before claiming success |

## Verification

### Check Installation

```bash
# Verify OpenCode
opencode --version

# Verify OpenAgentsControl agents
ls ~/.config/opencode/agent/core/

# Check skills directory
ls ~/.config/opencode/skills/

# Check plugins loaded
ls ~/.config/opencode/plugins/
```

### Test Integration

```bash
opencode --agent OpenAgent
> "Create a simple feature"
```

Agent should:

1. ✅ Automatically detect task type
2. ✅ Load appropriate skill (brainstorming/TDD)
3. ✅ Request approval before execution
4. ✅ Follow skill workflow

## Troubleshooting

### OpenAgent Skills Not Loading

Check plugin file:

```bash
ls -la ~/.config/opencode/plugins/openagent.js
```

Check skills directory:

```bash
ls ~/.config/opencode/skills/custom/
# Should show 14 openagent-* directories
```

Restow:

```bash
cd ~/.dotfiles
stow opencode
```

### OpenAgentsControl Commands Missing

Reinstall OpenAgentsControl:

```bash
curl -fsSL https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/main/install.sh | \
  bash -s developer --install-dir ~/.config/opencode
```

### Plugin Not Loading

Check plugin exists:

```bash
ls ~/.config/opencode/plugins/
# Should show: openagent.js
```

Restow:

```bash
cd ~/.dotfiles
stow opencode
```

## Resources

- [OpenCode Documentation](https://opencode.ai/docs/)
- [OpenAgentsControl GitHub](https://github.com/darrenhinde/OpenAgentsControl)
- [OpenCode Discord](https://opencode.ai/discord)

## Acknowledgments

OpenAgent skills were originally inspired by [Superpowers](https://github.com/obra/superpowers) by Jesse Vincent. The methodologies (TDD, systematic debugging, brainstorming, etc.) are preserved with integrated approval gates for safety-first development.

## License

- OpenCode: Apache 2.0
- OpenAgentsControl: MIT
- OpenAgent Skills: MIT
- This configuration: MIT
