# 🧠 Softroni Agent Skills

Open-source AI agent skills for **[OpenClaw](https://openclaw.ai)** and **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)**.

Each skill is a self-contained package with instructions, scripts, and assets that teach AI agents how to perform specific tasks.

## Skills

| Skill | Description |
|-------|-------------|
| [brand-video](./brand-video/) | Generate animated brand intro videos with AI music (ACE-Step) and voiceover (Edge TTS) using Remotion |

## How to Use

### OpenClaw

Install from ClawHub:
```bash
clawhub install brand-video
```

Or copy the skill folder into your OpenClaw workspace `skills/` directory.

### Claude Code

Copy the skill folder into your project. Claude Code will read `CLAUDE.md` which references the shared `SKILL.md`.

```bash
# Clone this repo
git clone https://github.com/softroni/agent-skills.git

# Copy the skill you need
cp -r agent-skills/brand-video /your/project/skills/
```

## Structure

Each skill follows the same layout:

```
skill-name/
├── SKILL.md              ← OpenClaw format (YAML frontmatter + instructions)
├── CLAUDE.md             ← Claude Code adapter (references SKILL.md)
├── scripts/              ← Executable automation scripts
├── references/           ← Detailed docs loaded on-demand
└── assets/               ← Templates, images, fonts
```

One set of content, two agent platforms. No duplication.

## Contributing

PRs welcome! Follow the skill structure above. Keep `SKILL.md` under 500 lines, use `references/` for detailed docs.

## License

MIT

---

Built by **[Softroni](https://softroni.com)** — Code meets craft.
