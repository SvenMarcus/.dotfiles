# OpenCode + Superpowers + OpenAgentsControl Integration

This directory contains a complete AI coding agent setup that combines three powerful systems:

1. **[OpenCode](https://opencode.ai)** - Open-source AI coding framework (base)
2. **[OpenAgentsControl](https://github.com/darrenhinde/OpenAgentsControl)** - Approval-first agents with context management
3. **[Superpowers](https://github.com/obra/superpowers)** - Agentic skills framework for TDD, debugging, etc.

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
│   ├── superpowers.js                       #   Auto-loads Superpowers bootstrap
│   └── openagent.js                         #   Auto-loads OpenAgent skill routing
├── skills/                                   # ← From dotfiles (this repo)
│   ├── superpowers/ -> ../superpowers/skills #   Superpowers skills (symlink)
│   └── custom/                              #   OpenAgent approval-gated wrappers
│       ├── openagent-skill-index/           #   Skill routing logic
│       ├── openagent-brainstorming/         #   Wraps superpowers/brainstorming
│       ├── openagent-tdd/                   #   Wraps superpowers/test-driven-development
│       ├── openagent-debugging/             #   Wraps superpowers/systematic-debugging
│       └── openagent-git-worktrees/         #   Wraps superpowers/using-git-worktrees
└── superpowers/                             # ← From dotfiles (git submodule)
    └── (Superpowers framework)              #   Git submodule from obra/superpowers
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

### Superpowers (Skills Framework)
- **using-superpowers** - Bootstrap skill that enforces skill-checking discipline
- **test-driven-development** - TDD workflow (RED → GREEN → REFACTOR)
- **systematic-debugging** - Debug workflow (Isolate → Hypothesize → Test → Fix)
- **brainstorming** - Design exploration before implementation
- **using-git-worktrees** - Isolated workspace creation
- **Plus 10+ more skills** - Code review, planning, execution, etc.

### Our Custom Integration (This Repo)
- **Plugins** - Auto-inject Superpowers + OpenAgent routing
- **Custom skills** - Approval-gated wrappers around Superpowers workflows
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
3. ✅ Initialize Superpowers git submodule
4. ✅ Stow your custom config (plugins + skills overlay)

### Manual Installation

If you already have OpenCode installed:

```bash
# Install OpenAgentsControl
curl -fsSL https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/main/install.sh | \
  bash -s developer --install-dir ~/.config/opencode

# Initialize Superpowers submodule
cd ~/.dotfiles
git submodule update --init --recursive

# Stow custom config
stow opencode
```

## How It Works

### Startup Flow

```
1. User runs: opencode --agent OpenAgent

2. OpenCode starts:
   ├─ Loads plugins from ~/.config/opencode/plugins/
   │  ├─ superpowers.js injects using-superpowers content
   │  └─ openagent.js injects openagent-skill-index content
   │
   ├─ Loads OpenAgent from ~/.config/opencode/agent/core/openagent.md
   │
   └─ Agent has access to:
      ├─ Superpowers skills (via skill tool)
      ├─ OpenAgent custom skills (via skill tool)
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

**Superpowers Plugin** injects bootstrap content that tells agents:
- "You have superpowers"
- "Check for skills BEFORE any response"
- "Even a 1% chance a skill applies → invoke it"

**OpenAgent Plugin** adds routing logic that tells agents:
- "Prefer custom/openagent-* skills over superpowers/*"
- "OpenAgent skills add approval gates"
- "Follow approval-first workflow"

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
   - Uses `custom/openagent-tdd` for implementation
   - Red → Green → Refactor cycle with approval gates
   - CodeReviewer validates security

5. **Production-Ready Code**
   - Matches your exact patterns (from context)
   - Follows TDD workflow (from Superpowers)
   - Approval-gated (from OpenAgent wrappers)

## OpenAgent Custom Skills

These skills wrap Superpowers workflows with OpenAgent's approval-first approach:

### openagent-brainstorming
Use before creative work - wraps `superpowers:brainstorming` with approval gates

**Workflow**:
1. Request approval to start brainstorming
2. Ask questions one at a time to refine idea
3. Explore 2-3 alternative approaches
4. Present design in sections (200-300 words each)
5. Request approval to save design doc
6. Request approval for implementation setup

### openagent-tdd
Use when implementing features/bugfixes - wraps `superpowers:test-driven-development` with approval gates

**Workflow**:
1. Request approval to start TDD
2. Write failing test (RED)
3. Verify test fails correctly
4. Request approval to write code
5. Write minimal code (GREEN)
6. Verify tests pass
7. Refactor (optional)
8. Request approval to commit

**Key Difference**: Won't auto-delete non-TDD code - requests permission first

### openagent-debugging
Use for any bug/test failure - wraps `superpowers:systematic-debugging` with approval gates

**Workflow**:
1. Request approval to investigate
2. Phase 1: Root cause investigation
3. Phase 2: Pattern analysis
4. Phase 3: Hypothesis and testing
5. Phase 4: Implementation with test
6. Stops at 3 failed fixes to question architecture

**Key Difference**: Reports at each phase, requests approval before fixes

### openagent-git-worktrees
Use when starting feature work - wraps `superpowers:using-git-worktrees` with approval gates

**Workflow**:
1. Request approval to create worktree
2. Follow directory priority: existing > CLAUDE.md > ask
3. Verify .gitignore includes worktree directory
4. Request approval to modify .gitignore if needed
5. Create worktree, run setup, verify baseline tests
6. Report if tests fail, ask for guidance

**Key Difference**: Won't auto-modify .gitignore or proceed with failing tests - requests permission

## Using Skills

### Load a Superpowers Skill

```
use skill tool to load superpowers/brainstorming
```

### Load an OpenAgent Skill

```
use skill tool to load custom/openagent-tdd
```

### List Available Skills

```
use skill tool to list skills
```

## Updating Superpowers

Since Superpowers is a git submodule:

```bash
cd ~/.dotfiles/opencode/.config/opencode/superpowers
git pull origin main
cd ~/.dotfiles
git add opencode/.config/opencode/superpowers
git commit -m "Update Superpowers to latest version"
```

Or update all submodules:

```bash
cd ~/.dotfiles
git submodule update --remote
```

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

The skill will be automatically available after restart or when stowed.

## Philosophy

**Superpowers**: Autonomous agent workflows with auto-triggering skills

**OpenAgent**: Approval-first execution with safety gates

**This Integration**: Best of both worlds
- Superpowers' structured methodologies (TDD, systematic debugging, brainstorming)
- OpenAgent's safety approach (approval gates, report-first, stop-on-failure)

## Key Differences from Native Superpowers

| Aspect | Superpowers Native | OpenAgent Integration |
|--------|-------------------|----------------------|
| Activation | Auto-triggers | Manual approval per skill |
| TDD Enforcement | Deletes non-TDD code | Warns, requests approval to delete |
| Git Worktrees | Auto-creates | Requests approval first |
| Debugging Fixes | Follow 4 phases strictly | Follow 4 phases, report at each |
| Plan Execution | Autonomous or batch | Approval per task or batch |

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

### Superpowers Skills Not Loading

Check symlink:
```bash
ls -la ~/.config/opencode/skills/superpowers
# Should point to: ../superpowers/skills
```

Reinitialize submodule:
```bash
cd ~/.dotfiles
git submodule update --init --recursive
stow opencode
```

### OpenAgentsControl Commands Missing

Reinstall OpenAgentsControl:
```bash
curl -fsSL https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/main/install.sh | \
  bash -s developer --install-dir ~/.config/opencode
```

### Plugins Not Loading

Check plugin files exist:
```bash
ls ~/.config/opencode/plugins/
# Should show: superpowers.js, openagent.js
```

Restow:
```bash
cd ~/.dotfiles
stow opencode
```

## Resources

- [OpenCode Documentation](https://opencode.ai/docs/)
- [OpenAgentsControl GitHub](https://github.com/darrenhinde/OpenAgentsControl)
- [Superpowers GitHub](https://github.com/obra/superpowers)
- [Superpowers Blog Post](https://blog.fsck.com/2025/10/09/superpowers/)
- [OpenCode Discord](https://opencode.ai/discord)

## License

- OpenCode: Apache 2.0
- OpenAgentsControl: MIT
- Superpowers: MIT
- This configuration: MIT
