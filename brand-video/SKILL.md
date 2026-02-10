---
name: brand-video
description: Generate animated brand intro videos with AI music and voiceover. Combines Remotion (React video), ACE-Step (AI music generation), and Edge TTS (narration) into a complete pipeline. Use when creating logo reveals, YouTube intros, brand stings, or app showcase videos with sound.
---

# Brand Video Generator

Create animated brand intro videos with AI-generated music and text-to-speech narration using Remotion, ACE-Step, and Edge TTS.

## Prerequisites

Check and install dependencies:

```bash
# 1. Node.js + Remotion
node --version  # ≥18
npx create-video@latest brand-video --blank

# 2. Edge TTS (free Microsoft TTS)
pip3 install edge-tts

# 3. ACE-Step 1.5 (local AI music generation)
git clone https://github.com/AceStepsAI/ACE-Step.git
cd ACE-Step
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
# CRITICAL: Pin these versions to avoid meta tensor errors
pip install "transformers>=4.51.0,<4.58.0" "vector-quantize-pytorch>=1.27.15"
```

### ACE-Step Version Fix (Apple Silicon)

ACE-Step's `requirements.txt` may pull wrong versions. After install, verify:
- `transformers` must be `<4.58.0` (not 5.x)
- `vector-quantize-pytorch` must be `>=1.27.15`
- Skip `triton` (CUDA-only, not needed on Mac)

## Pipeline Overview

```
Text prompt
    ├─→ Edge TTS → narration.mp3 (voiceover)
    ├─→ ACE-Step → music.wav (AI-generated sting)
    └─→ Remotion → video.mp4 (animated logo + audio)
```

## Step 1: Generate Narration

```bash
edge-tts --voice en-US-AndrewNeural \
  --text "Your Brand, where code meets craft." \
  --write-media public/narration.mp3
```

Good voices: `en-US-AndrewNeural` (warm male), `en-US-JennyNeural` (clear female), `en-GB-RyanNeural` (British). List all with `edge-tts --list-voices`.

## Step 2: Generate Music with ACE-Step

Create a TOML config:

```toml
# music-config.toml
caption = "modern tech startup logo reveal, minimal electronic, clean synth pad, ambient, cinematic, short jingle"
lyrics = "[Instrumental]"
instrumental = true
duration = 8
task_type = "text2music"
config_path = "acestep-v15-turbo"
thinking = false
batch_size = 1
inference_steps = 60
guidance_scale = 15.0
```

Generate:

```bash
cd /path/to/ACE-Step
source venv/bin/activate
python cli.py -c music-config.toml
```

Output lands in `output/` as FLAC. Convert for Remotion:

```bash
ffmpeg -y -i output/*.flac public/music.wav
```

### ACE-Step Performance (Apple Silicon M4, 12GB GPU)

- LM phase: ~9s (metadata generation via MLX)
- DiT phase: ~31s (audio diffusion on MPS)
- Total: ~40s for 8 seconds of audio

### Music Prompt Tips

- Include genre, mood, instruments, and purpose
- `[Instrumental]` for no vocals
- Duration 4-15s works best for logo stings
- Good prompts: "cinematic whoosh with synth pad", "minimal piano with ambient texture", "electronic glitch transition"

## Step 3: Create Remotion Composition

See `references/remotion-template.md` for a complete logo intro component template.

Key patterns:
- `staticFile("music.wav")` / `staticFile("narration.mp3")` — loads from `public/`
- `<Audio>` component for sound, `<Sequence>` for timing
- `spring()` with `damping: 200` for smooth motion
- Time in seconds: `Math.round(seconds * fps)`

### Composition Structure

```
0.0s - 0.2s: Silence (breathing room)
0.2s - 1.2s: Logo types in
1.4s - 2.2s: Slogan fades in + narration starts
2.2s - 2.5s: Divider line draws
2.5s - 3.0s: Domain fades in
3.0s - 5.5s: Hold + music fades
```

## Step 4: Render

```bash
cd brand-video
npx remotion render CompositionId out/video.mp4 --codec h264
```

## Customization

| Element | How to Change |
|---------|--------------|
| Logo text | Edit `TypedText` component, change `fullText` |
| Colors | Green accent: `#00c853`, dark text: `#1a1a1a` |
| Narration | Change `--text` in edge-tts command |
| Music style | Edit TOML `caption` field |
| Duration | Adjust `durationInFrames` in Root.tsx composition |
| Voice | Change `--voice` parameter |
| Music volume | Adjust `volume` prop on `<Audio>` (0.3-0.5 for background) |

## File Structure

```
brand-video/
├── public/
│   ├── music.wav        # ACE-Step output (converted)
│   └── narration.mp3    # Edge TTS output
├── src/
│   ├── Root.tsx          # Composition registry
│   └── LogoIntro.tsx     # Main component
├── out/
│   └── video.mp4         # Rendered output
└── remotion.config.ts
```
