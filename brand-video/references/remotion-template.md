# Remotion Logo Intro Template

Complete component for a brand intro video with typing animation, slogan, domain, music, and narration.

## LogoIntro.tsx

```tsx
import {
  AbsoluteFill,
  Audio,
  Sequence,
  interpolate,
  spring,
  staticFile,
  useCurrentFrame,
  useVideoConfig,
  Easing,
} from "remotion";

const Cursor: React.FC<{ active: boolean }> = ({ active }) => {
  const frame = useCurrentFrame();
  const blinkOn = active ? true : Math.floor(frame / 16) % 2 === 0;
  return (
    <span
      style={{
        color: "#00c853",
        fontWeight: 800,
        opacity: blinkOn ? 1 : 0.2,
        marginLeft: 2,
      }}
    >
      _
    </span>
  );
};

const TypedText: React.FC<{ text: string; accentColor: string }> = ({
  text,
  accentColor,
}) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const charsPerFrame = 10 / fps;
  const typed = Math.min(text.length, Math.floor(frame * charsPerFrame));
  const displayed = text.slice(0, typed);
  const typingDone = typed >= text.length;

  return (
    <div
      style={{
        display: "flex",
        alignItems: "baseline",
        fontSize: 130,
        fontWeight: 700,
        fontFamily: "'JetBrains Mono', 'SF Mono', 'Fira Code', monospace",
      }}
    >
      <span style={{ color: accentColor, fontWeight: 800 }}>&gt;</span>
      {displayed.split("").map((char, i) => (
        <span
          key={i}
          style={{
            color: i === 0 ? accentColor : "#1a1a1a",
            fontWeight: i === 0 ? 800 : 700,
          }}
        >
          {char}
        </span>
      ))}
      <Cursor active={!typingDone} />
    </div>
  );
};

const Slogan: React.FC<{ text: string }> = ({ text }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const progress = spring({ frame, fps, config: { damping: 200 } });

  return (
    <div
      style={{
        fontSize: 32,
        fontWeight: 400,
        letterSpacing: 2,
        color: "#666",
        opacity: progress,
        transform: `translateY(${interpolate(progress, [0, 1], [10, 0])}px)`,
        fontFamily: "-apple-system, BlinkMacSystemFont, 'Inter', sans-serif",
      }}
    >
      {text}
    </div>
  );
};

const Domain: React.FC<{ url: string }> = ({ url }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const progress = spring({ frame, fps, config: { damping: 200 } });

  return (
    <span
      style={{
        fontSize: 22,
        fontWeight: 500,
        color: "#bbb",
        letterSpacing: 1,
        fontFamily: "'JetBrains Mono', monospace",
        opacity: progress,
      }}
    >
      {url}
    </span>
  );
};

const Divider: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const width = interpolate(frame, [0, 0.5 * fps], [0, 100], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
    easing: Easing.out(Easing.cubic),
  });

  return (
    <div
      style={{
        width: 400,
        height: 1,
        background: `linear-gradient(90deg, transparent, #e0e0e0 ${width / 2}%, #e0e0e0 ${100 - width / 2}%, transparent)`,
        transform: `scaleX(${width / 100})`,
      }}
    />
  );
};

// --- Main Component ---
// Customize these props for your brand:
const BRAND_NAME = "Softroni";
const ACCENT_COLOR = "#00c853";
const SLOGAN = "Code meets craft.";
const DOMAIN = "softroni.com";
const MUSIC_VOLUME = 0.35;
const NARRATION_VOLUME = 0.9;

export const LogoIntro: React.FC = () => {
  const { fps } = useVideoConfig();

  return (
    <AbsoluteFill
      style={{
        backgroundColor: "#ffffff",
        justifyContent: "center",
        alignItems: "center",
        fontFamily: "-apple-system, BlinkMacSystemFont, 'Inter', sans-serif",
      }}
    >
      <Audio src={staticFile("music.wav")} volume={MUSIC_VOLUME} />
      <Sequence from={Math.round(1.4 * fps)} layout="none">
        <Audio src={staticFile("narration.mp3")} volume={NARRATION_VOLUME} />
      </Sequence>

      <div
        style={{
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          gap: 22,
        }}
      >
        <Sequence from={Math.round(0.2 * fps)} layout="none" premountFor={Math.round(0.1 * fps)}>
          <TypedText text={BRAND_NAME} accentColor={ACCENT_COLOR} />
        </Sequence>

        <Sequence from={Math.round(1.4 * fps)} layout="none" premountFor={Math.round(0.3 * fps)}>
          <Slogan text={SLOGAN} />
        </Sequence>

        <Sequence from={Math.round(2.2 * fps)} layout="none" premountFor={Math.round(0.2 * fps)}>
          <div style={{ marginTop: 10 }}>
            <Divider />
          </div>
        </Sequence>

        <Sequence from={Math.round(2.5 * fps)} layout="none" premountFor={Math.round(0.2 * fps)}>
          <div style={{ marginTop: 8 }}>
            <Domain url={DOMAIN} />
          </div>
        </Sequence>
      </div>
    </AbsoluteFill>
  );
};
```

## Root.tsx Registration

```tsx
import { Composition } from "remotion";
import { LogoIntro } from "./LogoIntro";

export const RemotionRoot: React.FC = () => {
  return (
    <>
      <Composition
        id="LogoIntro"
        component={LogoIntro}
        durationInFrames={165}
        fps={30}
        width={1920}
        height={1080}
      />
    </>
  );
};
```

## Timing Cheat Sheet

| Event | Time | Frame (30fps) |
|-------|------|---------------|
| Logo starts typing | 0.2s | 6 |
| Logo done + slogan appears | 1.4s | 42 |
| Narration starts | 1.4s | 42 |
| Divider draws | 2.2s | 66 |
| Domain fades in | 2.5s | 75 |
| Total duration | 5.5s | 165 |

Adjust `durationInFrames` in Root.tsx to change total length.
