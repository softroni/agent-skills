# 🧠 Softroni Agent Skills

Open-source AI agent skills for **[OpenClaw](https://openclaw.ai)** and **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)**.

Each skill is a self-contained package with instructions, scripts, and assets that teach AI agents how to perform specific tasks. Just describe what you want — the agent handles the rest.

## Skills

| Skill | Description | Details |
|-------|-------------|---------|
| [brand-video](./brand-video/) | Generate animated brand intro videos with AI music and voiceover | [README →](./brand-video/README.md) |

## Installation

### OpenClaw

```bash
git clone https://github.com/softroni/agent-skills.git
cp -r agent-skills/brand-video ~/.openclaw/workspace/skills/
```

Restart OpenClaw — it auto-detects new skills.

### Claude Code

```bash
git clone https://github.com/softroni/agent-skills.git
cp -r agent-skills/brand-video /your/project/.claude/skills/
```

Claude Code reads `CLAUDE.md` which references the shared `SKILL.md`.

## Skill Structure

Each skill follows the same layout:

```
skill-name/
├── README.md             ← Human-readable guide with examples
├── SKILL.md              ← OpenClaw agent instructions
├── CLAUDE.md             ← Claude Code adapter
├── scripts/              ← Automation scripts
├── references/           ← Detailed docs (loaded on-demand)
└── assets/               ← Templates, images, fonts
```

One set of content, two agent platforms. No duplication.

## Contributing

PRs welcome! Follow the skill structure above. Each skill needs a README with usage examples.

## License

MIT

---

Built by **[Softroni](https://softroni.com)** — Code meets craft.
