# Brand Video Generator

This skill generates animated brand intro videos with AI music and voiceover.

Read and follow `SKILL.md` in this directory for complete instructions.

## Quick Summary

1. **Narration**: Edge TTS (free) → `public/narration.mp3`
2. **Music**: ACE-Step 1.5 (local AI) → `public/music.wav`
3. **Video**: Remotion (React) → `out/video.mp4`

See `references/remotion-template.md` for the complete Remotion component template.
See `scripts/generate-intro.sh` for the one-command automation script.
