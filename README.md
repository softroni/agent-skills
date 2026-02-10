# 🧠 Softroni Agent Skills

Open-source AI agent skills for **[OpenClaw](https://openclaw.ai)** and **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)**.

Each skill is a self-contained package with instructions, scripts, and assets that teach AI agents how to perform specific tasks.

## Skills

| Skill | Description |
|-------|-------------|
| [brand-video](./brand-video/) | Generate animated brand intro videos with AI music (ACE-Step) and voiceover (Edge TTS) using Remotion |

## How to Use

### OpenClaw

Copy the skill folder into your OpenClaw workspace `skills/` directory:

```bash
git clone https://github.com/softroni/agent-skills.git
cp -r agent-skills/brand-video ~/.openclaw/workspace/skills/
```

Then restart OpenClaw — it auto-detects new skills.

### Claude Code

Copy the skill folder into your project:

```bash
git clone https://github.com/softroni/agent-skills.git
cp -r agent-skills/brand-video /your/project/.claude/skills/
```

Claude Code will read `CLAUDE.md` which references the shared `SKILL.md`.

## Example: Using the Brand Video Skill

Once installed, just tell your AI agent what you want in plain language:

```
Create a brand intro video for my company:
- Company name: Nexora
- Slogan: "Design without limits."
- Domain: nexora.io
- Accent color: #6C5CE7 (purple)
- Music vibe: cinematic ambient with soft piano, modern and elegant
- Narration: "Nexora, where design meets innovation."
- Voice: female (en-US-JennyNeural)
```

The agent reads the skill, installs dependencies if needed, and runs the full pipeline:

1. Generates narration with Edge TTS using your text and voice
2. Creates original music with ACE-Step matching your vibe description
3. Builds an animated Remotion video with your brand name, slogan, colors, and domain
4. Renders the final MP4

No code required from you — just describe your brand.

### More Examples

```
Make me a YouTube intro:
- Brand: CloudForge
- Tagline: "Ship faster."
- Dark theme with orange (#FF6B35) accents
- Music: energetic electronic, short punchy logo sting
- Voice: British male
```

```
Generate a logo reveal for my podcast:
- Name: The Deep Dive
- Slogan: "Stories beneath the surface."
- Calm, ambient music with underwater feel
- Warm male narrator
- 6 second duration
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
