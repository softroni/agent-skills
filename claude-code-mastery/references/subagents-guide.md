# Subagents & Agent Teams

## Built-in Subagents

| Agent | Model | Tools | Purpose |
|-------|-------|-------|---------|
| Explore | Haiku | Read-only | Fast codebase search and analysis |
| Plan | Inherits | Read-only | Research for plan mode |
| General-purpose | Inherits | All | Complex multi-step tasks |
| Bash | Inherits | Terminal | Running commands in separate context |

## Custom Subagent Configuration

### File Format
Markdown with YAML frontmatter in `.claude/agents/` (project) or `~/.claude/agents/` (user):

```markdown
---
name: code-reviewer
description: Reviews code for quality, security, and best practices. Use proactively after code changes.
tools: Read, Glob, Grep, Bash
model: sonnet
permissionMode: default
maxTurns: 20
skills:
  - api-conventions
---
You are a senior code reviewer. Focus on:
- Code quality and readability
- Security vulnerabilities (injection, auth flaws, secrets)
- Performance bottlenecks
- Best practice violations
Provide specific line references and suggested fixes.
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Lowercase with hyphens |
| `description` | Yes | When Claude should delegate to this agent |
| `tools` | No | Allowed tools (inherits all if omitted) |
| `disallowedTools` | No | Tools to deny |
| `model` | No | `sonnet`, `opus`, `haiku`, or `inherit` (default) |
| `permissionMode` | No | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | No | Max agentic turns |
| `skills` | No | Skills to preload into context |
| `mcpServers` | No | MCP servers available to subagent |
| `hooks` | No | Lifecycle hooks scoped to subagent |
| `memory` | No | `user`, `project`, or `local` for persistent memory |
| `background` | No | `true` to always run as background task |
| `isolation` | No | `worktree` for isolated git worktree |

### Priority Order
1. `--agents` CLI flag (session only, highest)
2. `.claude/agents/` (project)
3. `~/.claude/agents/` (user)
4. Plugin agents (lowest)

### CLI-Defined Subagents
```bash
claude --agents '{
  "reviewer": {
    "description": "Expert code reviewer",
    "prompt": "You are a senior code reviewer...",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

## Effective Patterns

### Writer/Reviewer Pattern
Use separate sessions — fresh context improves review quality:
```
Session A: "Implement rate limiter for the API"
Session B: "Review the rate limiter implementation for edge cases"
```

### Research Delegation
Keep main context clean by delegating exploration:
```
Use subagents to investigate how our auth system handles token refresh,
and whether we have existing OAuth utilities.
```

### Post-Implementation Review
```
Use a subagent to review this code for edge cases and security issues.
```

### Restrict Subagent Spawning
```yaml
tools: Task(worker, researcher), Read, Bash
```
Only `worker` and `researcher` subagents can be spawned.

## Agent Teams (Experimental)

Multiple independent Claude Code sessions coordinating via shared task list.

### Enable
```json
// settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

### When to Use
- Parallel research with competing hypotheses
- New features where teammates each own a piece
- Cross-layer work (frontend + backend + tests)
- Code review from multiple perspectives

### When NOT to Use
- Sequential tasks with many dependencies
- Same-file edits (merge conflicts)
- Simple tasks a single session handles fine

### Usage
```
Create an agent team to refactor the auth module:
- One teammate on API changes
- One on database migration
- One on test coverage
Use Sonnet for each.
```

### Key Differences from Subagents
| | Subagents | Agent Teams |
|--|-----------|-------------|
| Communication | Report back to main only | Message each other directly |
| Coordination | Main agent manages | Self-coordinate via task list |
| Token cost | Lower (summaries) | Higher (each is full instance) |
| Best for | Focused tasks | Collaborative work |

### Display Modes
- **In-process** (default): all in one terminal, `Shift+Down` to cycle
- **Split panes**: tmux/iTerm2, each teammate in own pane

### Plan Approval
```
Spawn an architect teammate. Require plan approval before changes.
```
Lead reviews and approves/rejects plans before implementation begins.
