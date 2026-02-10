# 🎬 Brand Video

Generate animated brand intro videos with AI-generated music and voiceover. Perfect for YouTube intros, app showcases, and logo reveals.

**Stack:** [Remotion](https://remotion.dev) (video) + [ACE-Step](https://github.com/AceStepsAI/ACE-Step) (AI music) + [Edge TTS](https://github.com/rany2/edge-tts) (narration)

---

## How It Works

Tell your AI agent what you want in plain language. The agent reads the skill, installs dependencies, and runs the full pipeline:

1. **Narration** — Generates voiceover with Edge TTS (free, 400+ voices)
2. **Music** — Creates original music with ACE-Step (local AI, no API key)
3. **Video** — Builds animated Remotion composition with your brand
4. **Render** — Outputs final MP4

## Your Logo

The skill supports multiple ways to bring your logo into the video:

### Option A: Text-Based Logo (Default)

The agent creates a stylized animated text logo with your brand name, accent color, and typing effect. No image needed — great for clean, modern intros.

```
Create a brand intro video:
- Company: Nexora
- Slogan: "Design without limits."
- Accent color: #6C5CE7
- Domain: nexora.io
```

### Option B: Logo Image File

Provide your logo file and the agent will incorporate it into the animation — fade in, scale up, or slide into frame.

```
Create a brand intro with my logo:
- Logo file: ./assets/my-logo.png
- Background: white
- Slogan: "Build something great."
- Music: upbeat electronic
```

### Option C: Logo Image URL

Paste a URL to your logo. The agent downloads it and integrates it into the video.

```
Create a YouTube intro:
- Logo: https://example.com/logo.png
- Slogan: "Ship faster."
- Dark background with orange accents
- Short punchy electronic sting
```

### Option D: Screenshot of Website/App

Give the agent a URL or screenshot. It extracts your brand style (colors, fonts, layout) and recreates it as an animation.

```
Create an intro based on my website:
- Website: https://myapp.com
- Pull the logo, colors, and tagline from the hero section
- Music: calm ambient
```

## Examples

### Startup Tech Intro
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

### YouTube Channel Intro
```
Make me a YouTube intro:
- Brand: CloudForge
- Tagline: "Ship faster."
- Dark theme with orange (#FF6B35) accents
- Logo file: ./my-logo.svg
- Music: energetic electronic, short punchy logo sting
- Voice: British male (en-GB-RyanNeural)
- Duration: 4 seconds
```

### Podcast Intro
```
Generate a logo reveal for my podcast:
- Name: The Deep Dive
- Slogan: "Stories beneath the surface."
- Logo: https://my-podcast.com/logo.png
- Calm, ambient music with underwater feel
- Warm male narrator (en-US-AndrewNeural)
- 6 second duration
```

### App Showcase
```
Create a promo intro for my iOS app:
- App name: FocusFlow
- Tagline: "Your time, your rules."
- Screenshot: https://apps.apple.com/app/focusflow
- Accent color: #00B894 (teal)
- Music: minimal, clean, productivity vibes
- No narration, just music
```

## Customization Options

| Option | Description | Example |
|--------|-------------|---------|
| Company/brand name | Text displayed in the logo animation | `Nexora` |
| Logo file/URL | Image to use instead of text logo | `./logo.png` or `https://...` |
| Slogan | Tagline shown below the logo | `"Design without limits."` |
| Domain | Website URL shown at the bottom | `nexora.io` |
| Accent color | Primary brand color (hex) | `#6C5CE7` |
| Background | Light/dark or specific color | `dark`, `#1a1a2e` |
| Music vibe | Text description of desired music style | `cinematic ambient with piano` |
| Narration text | What the voiceover says | `"Nexora, where design meets innovation."` |
| Voice | Edge TTS voice name | `en-US-JennyNeural` |
| Duration | Total video length in seconds | `4`, `6`, `8` |

### Available Voices (Popular)

| Voice | Style |
|-------|-------|
| `en-US-AndrewNeural` | Warm, confident male |
| `en-US-JennyNeural` | Clear, professional female |
| `en-GB-RyanNeural` | British male |
| `en-GB-SoniaNeural` | British female |
| `en-AU-WilliamNeural` | Australian male |
| `en-IN-PrabhatNeural` | Indian male |

Full list: `edge-tts --list-voices`

## Requirements

- **Node.js** ≥18 (for Remotion)
- **Python** ≥3.10 (for ACE-Step + Edge TTS)
- **ffmpeg** (for audio conversion)
- **~4GB disk** for ACE-Step model weights (auto-downloads on first run)
- **Apple Silicon Mac** or **NVIDIA GPU** recommended for music generation

## License

MIT — Built by [Softroni](https://softroni.com)
