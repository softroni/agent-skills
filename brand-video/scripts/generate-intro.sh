#!/bin/bash
# Generate a complete brand intro video with AI music + narration
# Usage: ./generate-intro.sh <remotion-project-dir> <ace-step-dir> [options]
#
# Example:
#   ./generate-intro.sh ./brand-video ./ACE-Step \
#     --text "Softroni, where code meets craft." \
#     --voice en-US-AndrewNeural \
#     --music-prompt "modern tech startup logo reveal, minimal electronic, cinematic" \
#     --duration 8 \
#     --composition LogoIntro

set -euo pipefail

REMOTION_DIR="${1:?Usage: $0 <remotion-dir> <ace-step-dir> [options]}"
ACESTEP_DIR="${2:?Usage: $0 <remotion-dir> <ace-step-dir> [options]}"
shift 2

# Defaults
NARRATION_TEXT="Your Brand. Where code meets craft."
VOICE="en-US-AndrewNeural"
MUSIC_PROMPT="modern tech startup logo reveal, minimal electronic, clean synth pad, ambient, cinematic, short jingle"
MUSIC_DURATION=8
COMPOSITION="LogoIntro"
OUTPUT="out/brand-intro.mp4"

# Parse options
while [[ $# -gt 0 ]]; do
  case $1 in
    --text) NARRATION_TEXT="$2"; shift 2 ;;
    --voice) VOICE="$2"; shift 2 ;;
    --music-prompt) MUSIC_PROMPT="$2"; shift 2 ;;
    --duration) MUSIC_DURATION="$2"; shift 2 ;;
    --composition) COMPOSITION="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

echo "🎤 Generating narration..."
edge-tts --voice "$VOICE" \
  --text "$NARRATION_TEXT" \
  --write-media "$REMOTION_DIR/public/narration.mp3"
echo "   ✅ Narration saved"

echo "🎵 Generating music with ACE-Step..."
TOML_PATH=$(mktemp /tmp/music-config.XXXXXX.toml)
cat > "$TOML_PATH" <<EOF
caption = "$MUSIC_PROMPT"
lyrics = "[Instrumental]"
instrumental = true
duration = $MUSIC_DURATION
task_type = "text2music"
config_path = "acestep-v15-turbo"
thinking = false
batch_size = 1
inference_steps = 60
guidance_scale = 15.0
EOF

cd "$ACESTEP_DIR"
source venv/bin/activate
python cli.py -c "$TOML_PATH"

# Find latest output and convert
LATEST_FLAC=$(ls -t output/*.flac 2>/dev/null | head -1)
if [[ -z "$LATEST_FLAC" ]]; then
  echo "❌ No FLAC output found"
  exit 1
fi
echo "   Converting $LATEST_FLAC → music.wav"
ffmpeg -y -i "$LATEST_FLAC" "$REMOTION_DIR/public/music.wav" -loglevel error
echo "   ✅ Music saved"

rm -f "$TOML_PATH"

echo "🎬 Rendering video..."
cd "$REMOTION_DIR"
npx remotion render "$COMPOSITION" "$OUTPUT" --codec h264
echo "   ✅ Video rendered: $OUTPUT"

echo ""
echo "🎉 Done! Your brand intro is at: $REMOTION_DIR/$OUTPUT"
