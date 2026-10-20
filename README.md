# 🐰 Bush Slap — Tap. Slap. Repeat.

A fast, first-person rabbit reaction game built as a lightweight browser experience. Catch the rabbit when it pops out of the bushes, build a combo, and beat your personal best.

**Live site:** https://bush-slap.vercel.app/  
**Core rule:** preserve the established Bush Slap art direction and working game. Make focused changes; do not replace the project with a different template or visual style.

## 🎨 Visual identity — keep this consistent

Treat the supplied Bush Slap concept images as the visual source of truth whenever implementing or generating art.

- **Hero character:** a cute, white, blocky/voxel rabbit with long upright pink inner ears, square muzzle, simple expressive eyes and blush cheeks.
- **First-person action:** a dark, stylized gloved hand/forearm punching or slapping toward the rabbit; dramatic perspective and motion.
- **World:** lush green cubic bushes and a playful garden/forest, with optional ruined-city and sunset environments.
- **Graphic treatment:** Minecraft-inspired blocky geometry combined with Spider-Verse-inspired comic-book energy — bold ink-like outlines, halftone dots, punchy contrast, dynamic impact bursts, speed lines, and cyan/hot-pink accent lighting.
- **Impact lettering:** oversized comic-style yellow **“SLAP!”** burst.
- **Palette:** deep navy/near-black backgrounds, vivid hot pink, lime green, golden yellow, and lush forest greens.
- **Brand line:** **TAP. SLAP. REPEAT.**
- **Tone:** playful, energetic, readable, polished, slightly chaotic — never generic corporate UI or photorealistic art.

### Art-generation continuity rules

1. Keep the rabbit recognizably the same character across hero art, gameplay, skins, thumbnails, and future promotional images.
2. Keep the hand first-person and clearly readable as a slap. Do not turn it into a third-person human character.
3. Use the same blocky/voxel language for bushes, props, and scenery.
4. Use comic impact effects as accents around action; do not let effects obscure gameplay targets or text.
5. Keep gameplay silhouettes and hit targets clear on small mobile screens.
6. Do not silently change the logo, slogan, character proportions, palette, or art style.
7. When a new reference is supplied, preserve it in the repository and update this guide only if the user explicitly changes the direction.

## 🎮 Gameplay direction

- Tap/click the rabbit when it appears; missing an empty bush breaks the combo.
- Score, combo, countdown, hit feedback, sound toggle, restart, and personal-best tracking.
- Difficulty should ramp up quietly as play continues. **Never show a visible level number.**
- Rabbit variants and environment choices should follow the established visual identity.
- Responsive browser play for phones, tablets, desktop browsers, and TV browsers where input and viewport constraints allow.
- Keep interactions accessible: keyboard support, visible focus, touch-friendly controls, and reduced-motion consideration.

## 🧭 Product principles

- **Protect the working game.** Inspect existing code and deployment before editing. Avoid broad rewrites when a small change will do.
- **Preserve deployment compatibility.** The current project is a static HTML/CSS/JavaScript app; do not assume it uses React, Vite, Next.js, or a Node build pipeline.
- **No invented features.** Login, cloud-saved progress, online leaderboards, cross-device profiles, and backend services are not present merely because they appear in a concept. Implement them only with a clear architecture and explicit user approval.
- **No surprise costs.** Prefer local assets and browser-native APIs. Do not introduce paid image-generation APIs, metered services, or API keys without discussing the cost and limits first.
- **Keep the interface responsive** and preserve current behavior unless the task explicitly calls for a change.

## 🛠️ Current implementation notes

The repository currently contains a root `index.html` with inline CSS and JavaScript, plus static assets referenced by absolute paths such as `/assets/jungle-backdrop.svg` and `/assets/slap-burst.svg`. The app uses Canvas for the game/hero scenes and browser `localStorage` for local personal-best and selection preferences.

There is currently **no root `package.json`**. That is not automatically an error: a plain static site can be served directly by Vercel without npm scripts or a package manifest. Do not add one just to make the repository look like a framework project. If build tooling is introduced later, document why and verify Vercel settings.

## 📁 Art references

Keep user-provided concept images in:

```
docs/
  art-references/
    01-rabbit-slap-key-art.png
    02-full-website-and-asset-board.png
    03-game-screens-and-character-skins.png
    04-website-layout-reference.png
```

These are the intended reference filenames for the four supplied concepts. If any file is not yet present in GitHub, upload the original image to that path rather than recreating it or substituting a different image. Link new art assets here once committed.

## 🚀 Local preview

Because this is currently a static site, you can open `index.html` directly for a basic preview, or serve the repository with any simple static HTTP server. A server is preferable when testing the service worker and root-relative asset URLs.

## ✅ Before each change

- [ ] Read the relevant existing code before editing.
- [ ] Preserve the Bush Slap character and comic-voxel art direction.
- [ ] Check phone and desktop layouts.
- [ ] Test gameplay and avoid regressions.
- [ ] Keep visible level numbers out of the UI.
- [ ] Check all asset paths and the Vercel deployment.
- [ ] State clearly what changed and what still needs work.

---

**Remember:** Bush Slap is not just any rabbit tapping game. Its signature is the white voxel rabbit, lush cubic bushes, first-person slap, comic-book impact art, and **TAP. SLAP. REPEAT.**