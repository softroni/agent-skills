# 🧠 Claude Code Mastery

**Teach any AI agent to use Claude Code like a pro.**

This skill provides comprehensive best practices for Claude Code CLI — covering context management, the 4-phase workflow, subagents, headless automation, memory systems, and more.

## What It Covers

- **Context Management** — The #1 factor in Claude Code effectiveness
- **4-Phase Workflow** — Explore → Plan → Implement → Verify
- **Prompting Patterns** — Be specific, give verification criteria, let Claude interview you
- **Subagents** — Built-in and custom agents for context-efficient delegation
- **Agent Teams** — Parallel sessions coordinating via shared task lists
- **Headless Mode** — CI/CD automation, structured output, budget caps
- **Memory System** — CLAUDE.md, modular rules, auto memory, imports
- **Anti-Patterns** — Common mistakes and how to avoid them

## Installation

### OpenClaw
```bash
cp -r claude-code-mastery ~/.openclaw/workspace/skills/
```

### Claude Code
```bash
cp -r claude-code-mastery /your/project/.claude/skills/
```

## Structure

```
claude-code-mastery/
├── SKILL.md                          ← Main skill (OpenClaw)
├── CLAUDE.md                         ← Claude Code adapter
├── README.md                         ← This file
└── references/
    ├── memory-guide.md               ← Memory hierarchy & CLAUDE.md best practices
    ├── subagents-guide.md            ← Custom subagents & agent teams
    └── headless-guide.md             ← Automation, CI/CD, structured output
```

## Source

Based on the [official Claude Code documentation](https://code.claude.com/docs/en/best-practices) — distilled into an agent-consumable skill format.

---

Built by **[Softroni](https://softroni.com)** — Apps, AI, Automation.
