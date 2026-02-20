# Headless Mode & Automation

## Basic Usage

```bash
claude -p "prompt"                    # Run and exit
claude -p "prompt" --model opus       # Specific model
claude -p "prompt" --output-format json  # Structured output
```

## Output Formats

### Plain Text (default)
```bash
claude -p "What does this project do?"
```

### JSON (structured)
```bash
claude -p "Summarize this project" --output-format json
# Returns: { result, session_id, usage, ... }
```

### Stream JSON (real-time)
```bash
claude -p "Explain recursion" --output-format stream-json --verbose --include-partial-messages
```

Filter streaming text:
```bash
claude -p "Write a poem" --output-format stream-json --verbose --include-partial-messages | \
  jq -rj 'select(.type == "stream_event" and .event.delta.type? == "text_delta") | .event.delta.text'
```

### JSON Schema Validation
```bash
claude -p "Extract function names from auth.py" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}'
```

## Tool Permissions

### Auto-approve specific tools
```bash
claude -p "Run tests and fix failures" --allowedTools "Bash,Read,Edit"
```

### Pattern matching
```bash
# Allow git commands only
claude -p "Create a commit for staged changes" \
  --allowedTools "Bash(git diff *),Bash(git log *),Bash(git status *),Bash(git commit *)"
```
Note: space before `*` is important for prefix matching.

## Session Management

### Continue conversations
```bash
claude -p "Review this codebase"
claude -p "Now focus on database queries" --continue
claude -p "Generate summary of all issues" --continue
```

### Capture and resume session ID
```bash
session_id=$(claude -p "Start review" --output-format json | jq -r '.session_id')
claude -p "Continue review" --resume "$session_id"
```

## Budget and Limits

```bash
claude -p "Refactor auth" --max-budget-usd 5.00    # Cost cap
claude -p "Quick fix" --max-turns 3                  # Turn limit
```

## Custom System Prompts

```bash
# Append to default prompt
claude -p "Review code" --append-system-prompt "Focus on security vulnerabilities"

# Replace entire prompt
claude -p "Analyze" --system-prompt "You are a Python security expert"

# From file
claude -p "Review" --system-prompt-file ./custom-prompt.txt
```

## CI/CD Patterns

### PR Review Bot
```bash
gh pr diff "$PR_NUMBER" | claude -p "Review for security issues" \
  --append-system-prompt "You are a security engineer" \
  --output-format json \
  --max-budget-usd 2.00
```

### Auto-fix Lint Errors
```bash
claude -p "Fix all ESLint errors in src/" \
  --allowedTools "Bash,Read,Edit" \
  --dangerously-skip-permissions
```
⚠️ Only use `--dangerously-skip-permissions` in sandboxed environments.

### Commit Message Generator
```bash
claude -p "Look at staged changes and create an appropriate commit" \
  --allowedTools "Bash(git diff *),Bash(git log *),Bash(git commit *)"
```

### Test + Fix Loop
```bash
claude -p "Run the test suite. Fix any failures. Repeat until all tests pass." \
  --allowedTools "Bash,Read,Edit" \
  --max-turns 20 \
  --max-budget-usd 10.00
```

## Advanced Flags

| Flag | Purpose |
|------|---------|
| `--fallback-model sonnet` | Auto-fallback when primary model is overloaded |
| `--no-session-persistence` | Don't save session to disk |
| `--verbose` | Show detailed tool usage |
| `--debug "api,mcp"` | Debug specific categories |
| `--mcp-config ./mcp.json` | Load MCP servers |
| `--strict-mcp-config` | Only use specified MCP servers |
| `--agents '{...}'` | Define subagents for session |
