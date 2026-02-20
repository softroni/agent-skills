---
name: claude-code-mastery
description: Master Claude Code CLI for maximum coding productivity. Covers the agentic loop, context management, plan mode, subagents, agent teams, headless automation, memory system, CLAUDE.md best practices, and advanced workflows. Use when an agent needs to use Claude Code effectively, learn best practices for prompting Claude Code, set up project memory, manage context windows, run parallel sessions, create custom subagents, or automate with headless mode.
---

# Claude Code Mastery

Comprehensive guide for using Claude Code (v2.1+) at peak effectiveness. Covers CLI usage, context management, workflows, subagents, and automation.

## Core Principle

**Context window is your most critical resource.** Performance degrades as it fills. Every decision should optimize for context efficiency.

## Quick Reference

### Models
- `opus` — Claude Opus (most capable, use for complex architecture)
- `sonnet` — Claude Sonnet (balanced, default)
- `haiku` — Claude Haiku (fastest/cheapest)

### Essential Commands
```bash
claude                           # Interactive session
claude "prompt"                  # Start with prompt
claude -p "prompt"               # Headless (non-interactive)
claude -c                        # Continue most recent session
claude -r "session-name"         # Resume by name
claude -w feature-name           # Isolated git worktree
claude --model opus              # Use specific model
claude --permission-mode plan    # Read-only plan mode
```

### Interactive Shortcuts
| Key | Action |
|-----|--------|
| `Shift+Tab` | Cycle permission modes (normal → auto-accept → plan) |
| `Esc+Esc` | Rewind conversation/code to checkpoint |
| `Ctrl+O` | Toggle verbose (see thinking) |
| `Ctrl+B` | Background running tasks |
| `Ctrl+G` | Open prompt in text editor |
| `@file.ts` | Include file in context |
| `!command` | Run bash, add output to session |

### Session Commands
| Command | Purpose |
|---------|---------|
| `/clear` | Reset context between tasks |
| `/compact [focus]` | Compress context, keep focus area |
| `/context` | Visualize context usage |
| `/init` | Bootstrap CLAUDE.md for project |
| `/model` | Switch model mid-session |
| `/plan` | Enter plan mode |
| `/resume` | Resume previous session |
| `/rewind` | Rewind to checkpoint |
| `/agents` | Manage custom subagents |
| `/rename name` | Name session for later |

## The 4-Phase Workflow

For any non-trivial task, follow: **Explore → Plan → Implement → Verify**

### Phase 1: Explore (Plan Mode)
```
# Start in plan mode — read-only, no changes
claude --permission-mode plan

> Read src/auth/ and explain how sessions work.
> What patterns does this codebase use for error handling?
```

### Phase 2: Plan
```
> Create a detailed plan for adding OAuth2 support.
> What files need to change? What's the migration path?
```
Press `Ctrl+G` to edit the plan in your text editor before proceeding.

### Phase 3: Implement (Normal Mode)
Switch to normal mode (`Shift+Tab`) and execute:
```
> Implement the OAuth flow from your plan. Write tests for the callback handler.
> Run the test suite and fix any failures.
```

### Phase 4: Verify
```
> Run all tests. Check for type errors. Review the diff for anything I missed.
```

**Skip planning for trivial tasks** — typos, single-line fixes, renaming. If you can describe the diff in one sentence, just do it.

## Prompting for Better Results

### Be Specific
| ❌ Vague | ✅ Specific |
|----------|-------------|
| "fix the login bug" | "Login fails after session timeout. Check src/auth/, especially token refresh. Write a failing test, then fix it." |
| "add tests" | "Write tests for foo.py covering the edge case where user is logged out. Avoid mocks." |
| "make it better" | "Refactor utils.js to use ES2024 features. Maintain the same behavior. Run tests after." |

### Give Verification Criteria
Always tell Claude how to check its own work:
```
> Write a validateEmail function. Test cases:
> user@example.com → true, invalid → false, user@.com → false.
> Run the tests after implementing.
```

### Let Claude Interview You (Large Features)
```
> I want to build [brief description]. Interview me using AskUserQuestion.
> Ask about technical implementation, edge cases, and tradeoffs.
> Keep interviewing until covered, then write a spec to SPEC.md.
```
Then start a fresh session to implement from the spec.

## Context Management

### Aggressive Context Hygiene
- **`/clear`** between unrelated tasks
- **`/compact focus`** when context is large: `/compact Focus on the API changes`
- **Subagents for research** — they explore in separate context, return summaries
- **If corrected 2+ times** on the same issue → `/clear`, start fresh with better prompt

### What Consumes Context
| Source | Cost |
|--------|------|
| CLAUDE.md | Every request (keep <500 lines) |
| Skill descriptions | Every request (low) |
| MCP tool definitions | Every request (can be heavy) |
| File reads | Adds to conversation |
| Command output | Adds to conversation |
| Subagent results | Summary only (efficient) |
| Hooks | Zero (run externally) |

## Memory System

### CLAUDE.md (Project Memory)
```bash
/init  # Bootstrap from codebase analysis
```

Keep only what Claude can't infer:
- ✅ Build/test commands, code style rules, architecture decisions, dev environment quirks
- ❌ Standard conventions, file-by-file descriptions, long tutorials

Import other files: `@README.md`, `@docs/conventions.md`

### Modular Rules
```
.claude/rules/
├── code-style.md      # Style guidelines
├── testing.md         # Test conventions
└── api-design.md      # API patterns
```
Path-scoped rules with YAML frontmatter:
```yaml
---
paths:
  - "src/api/**/*.ts"
---
# API rules that only apply to API files
```

### Auto Memory
Claude saves learnings to `~/.claude/projects/<project>/memory/`. First 200 lines of `MEMORY.md` load every session. Tell Claude to save: "remember that we use pnpm, not npm."

See `references/memory-guide.md` for the full memory hierarchy and configuration.

## Subagents

### Built-in
- **Explore** — Haiku model, read-only, fast codebase search
- **Plan** — Inherits model, read-only research for plan mode
- **General-purpose** — All tools, complex multi-step tasks

### Custom Subagents
Create in `.claude/agents/` (project) or `~/.claude/agents/` (user):

```markdown
---
name: security-reviewer
description: Reviews code for security vulnerabilities
tools: Read, Glob, Grep, Bash
model: sonnet
---
You are a senior security engineer. Analyze code for injection vulnerabilities,
auth flaws, secrets in code, and insecure data handling.
```

Key fields: `name`, `description`, `tools`, `model`, `permissionMode`, `maxTurns`, `skills`, `isolation: worktree`, `background: true`

### When to Use Subagents
- Research that reads many files (keeps main context clean)
- Post-implementation review
- Parallel focused tasks
- Writer/Reviewer pattern (separate sessions for writing and reviewing)

See `references/subagents-guide.md` for advanced patterns and agent teams.

## Headless Mode (Automation)

```bash
# Basic
claude -p "Explain what this project does"

# With tool permissions
claude -p "Run tests and fix failures" --allowedTools "Bash,Read,Edit"

# Structured output
claude -p "List all API endpoints" --output-format json

# JSON schema validation
claude -p "Extract function names" --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}}}'

# Budget cap
claude -p "Refactor auth module" --max-budget-usd 5.00

# Continue conversation
claude -p "Now focus on database queries" --continue

# Custom system prompt
claude -p "Review for security" --append-system-prompt "You are a security engineer"
```

See `references/headless-guide.md` for CI/CD patterns and advanced automation.

## Parallel Sessions

### Git Worktrees (Recommended)
```bash
claude -w feature-auth    # Creates isolated worktree + branch
claude -w bugfix-123      # Another parallel session
```
Each gets its own files, branch, and context. No collisions.

### Session Management
```bash
/rename auth-refactor     # Name current session
claude -r auth-refactor   # Resume later
claude --from-pr 123      # Resume PR-linked session
```

## Anti-Patterns

- ❌ Bloated CLAUDE.md (>500 lines) — rules get ignored
- ❌ Not clearing context between tasks — stale context causes errors
- ❌ Vague prompts without verification — Claude can't self-check
- ❌ Correcting 3+ times instead of `/clear` + fresh prompt
- ❌ Loading all MCP servers when only one is needed
- ❌ Skipping plan mode on multi-file changes
- ❌ Never naming sessions — impossible to resume later
