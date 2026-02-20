# Claude Code Memory System

## Memory Hierarchy (highest → lowest priority)

| Type | Location | Scope | Shared With |
|------|----------|-------|-------------|
| Managed policy | `/Library/Application Support/ClaudeCode/CLAUDE.md` | Org-wide | All users |
| Project memory | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team | Via git |
| Project rules | `./.claude/rules/*.md` | Team | Via git |
| User memory | `~/.claude/CLAUDE.md` | Personal | All your projects |
| Project local | `./CLAUDE.local.md` | Personal | Current project only |
| Auto memory | `~/.claude/projects/<project>/memory/` | Per-project | Auto-saved notes |

More specific instructions take precedence over broader ones.

## CLAUDE.md Best Practices

### What to Include
- Build, test, lint commands Claude can't guess
- Code style rules that differ from defaults
- Testing instructions and preferred runners
- Branch naming, PR conventions
- Architecture decisions specific to project
- Dev environment quirks (required env vars)
- Common gotchas or non-obvious behaviors

### What to Exclude
- Anything Claude can figure out by reading code
- Standard language conventions
- Detailed API docs (link instead)
- Information that changes frequently
- Long explanations or tutorials
- File-by-file codebase descriptions
- Self-evident practices ("write clean code")

### Maintenance
- Keep under ~500 lines — bloated files get ignored
- Use emphasis (IMPORTANT, YOU MUST) for critical rules
- If Claude ignores a rule, the file is too long
- If Claude asks questions answered in CLAUDE.md, phrasing is ambiguous
- Review when things go wrong, prune regularly

## CLAUDE.md Imports

Import other files with `@path/to/file`:
```markdown
See @README.md for project overview.
See @docs/api.md for API conventions.
Personal overrides: @~/.claude/my-project-instructions.md
```
- Relative paths resolve from the importing file
- Max recursion depth: 5 hops
- Not evaluated inside code blocks/spans
- First encounter shows an approval dialog per project

## Modular Rules (`.claude/rules/`)

Organize instructions into focused files:
```
.claude/rules/
├── frontend/
│   ├── react.md
│   └── styles.md
├── backend/
│   ├── api.md
│   └── database.md
└── general.md
```

All `.md` files discovered recursively and auto-loaded.

### Path-Scoped Rules
```yaml
---
paths:
  - "src/api/**/*.ts"
  - "lib/**/*.ts"
---
# These rules only apply when working with matching files
```

Glob patterns: `**/*.ts`, `src/**/*`, `*.md`, `src/components/*.tsx`
Brace expansion: `src/**/*.{ts,tsx}`, `{src,lib}/**/*.ts`

Rules without `paths` apply unconditionally.

## Auto Memory

Claude automatically saves learnings to `~/.claude/projects/<project>/memory/`:
```
memory/
├── MEMORY.md          # Index, first 200 lines loaded every session
├── debugging.md       # Topic file, loaded on demand
├── api-conventions.md # Topic file, loaded on demand
```

### Key Details
- Only first 200 lines of `MEMORY.md` are in system prompt
- Topic files loaded when Claude needs them
- Keep `MEMORY.md` concise; move details to topic files
- Tell Claude: "remember that we use pnpm" or "save to memory that..."

### Control
```bash
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=0  # Force on
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=1  # Force off
```

## Setup Workflow

1. Run `/init` to bootstrap CLAUDE.md from codebase analysis
2. Review and trim the generated file
3. Add project-specific rules to `.claude/rules/`
4. Use `CLAUDE.local.md` for personal preferences (auto-gitignored)
5. Tell Claude to save recurring patterns to auto memory
