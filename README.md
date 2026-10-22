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
- **Preserve deployment compatibility.** The root website is a Vite-built browser app. Keep its current build path working while the Godot prototype is developed separately.
- **No invented features.** Login, cloud-saved progress, online leaderboards, cross-device profiles, and backend services are not present merely because they appear in a concept. Implement them only with a clear architecture and explicit user approval.
- **No surprise costs.** Prefer local assets and browser-native APIs. Do not introduce paid image-generation APIs, metered services, or API keys without discussing the cost and limits first.
- **Keep the interface responsive** and preserve current behavior unless the task explicitly calls for a change.

## 🛠️ Current implementation and deployment notes

The root website contains `index.html`, static assets under `assets/`, a root `package.json` with Vite scripts, and `vercel.json` configured to run `npm run build` and publish `dist/`. Preserve this path for the existing browser game.

The Godot 4 prototype lives separately under `godot/` on the `godot4-prototype` branch. Its Web export is generated into `godot/build/web/` by the GitHub Actions workflow; those generated files are not the same as the root Vite site's `dist/` output. **The existing Vercel deployment does not automatically serve the Godot export.** To preview Godot online, export it successfully first, then configure a separate Vercel project/deployment to publish the exported HTML, JavaScript, WebAssembly, and PCK files. Do not change the production site's root or output directory as a shortcut.

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

BUSH SLAP — Project Direction & Continuity Guide
Purpose: This document is the source of truth for the game's direction. Read it before changing visuals, gameplay, architecture, or generating art. Do not drift into a different game, character, or visual style.
1. Project vision
Bush Slap is a fast, funny, browser-based reflex game: rabbits pop out of voxel bushes and the player taps/clicks them to score. Difficulty and speed increase naturally as the run continues. The game should feel polished, instantly understandable, replayable, and responsive across devices.
Core slogan: TAP. SLAP. REPEAT.
2. Non-negotiable visual identity
Main character
Preserve the same white, blocky Minecraft-inspired rabbit shown in the reference art.
Key features: square/voxel head and body, tall upright ears with pink inner ears, large dark pixel-like eyes, small pink nose, expressive friendly face.
Keep the rabbit recognizable and consistent across the hero art, gameplay, icons, sprites, loading screens, and future generated assets.
Do not replace it with a realistic rabbit, a smooth 3D cartoon bunny, or another animal.
Other skins (gray, brown, ninja, golden, etc.) are optional variants of the same basic voxel rabbit silhouette—not replacements for the main character.
Environment and gameplay viewpoint
Bright, lush Minecraft-like voxel world: cubic bushes, blocky grass, stone ruins/arches, waterfalls, trees, and colorful distant scenery.
First-person player hand/glove can enter from the lower-right or foreground during the slap action.
Rabbits emerge from bushes; clear targets and impact feedback are essential for gameplay readability.
Art style: Minecraft × Spider-Verse-inspired comic energy
Combine:
Minecraft/voxel construction for characters, plants, props, and environments.
Spider-Verse-inspired graphic-novel energy for presentation: thick ink-like outlines, halftone/grain textures, exaggerated motion streaks, punchy comic impact shapes, dramatic contrast, saturated cyan/blue and hot-pink lighting.
Bold yellow comic “SLAP!” impact lettering, with black outline and energetic jagged burst.
Hot pink, electric cyan, deep navy/black, vivid green, and bright yellow accents.
The voxel content must remain visibly blocky. Comic effects should enhance it rather than turn the game into a flat comic or realistic scene. Avoid copying Spider-Man or other protected characters; the reference means a broad comic/anime visual influence only.
UI style
Dark navy/near-black panels with crisp cyan or magenta borders.
Hot-pink primary buttons; green can signal play-again/success; yellow for scores and rewards.
Bold brush/comic headline typography paired with highly readable UI text.
Strong contrast and clear hierarchy. Avoid cluttering the actual play area with unnecessary panels.
Mobile layouts should stack cleanly; desktop can use a wider hero/gameplay plus leaderboard layout.
3. Reference art
The files in docs/art-references/ are the user-provided visual references. Treat them as the canonical art-direction reference set:
01-rabbit-slap-key-art.png — main rabbit, bush, first-person hand, world, and “SLAP!” effect.
02-full-website-and-asset-board.png — overall visual language and full-page layout/asset-board reference.
03-game-screens-and-character-skins.png — menu, gameplay, game-over, skin, background, and UI inspiration.
04-website-layout-reference.png — alternate landing-page, gameplay, leaderboard, account, and player-card layout.
These are concept references, not finished production assets. Rebuild UI and gameplay as real responsive components; do not use a single screenshot as the entire website.
4. Gameplay requirements
Main loop: rabbits pop up from bushes; player taps/clicks (or uses a supported input) to slap them and earn score.
Increase challenge over time through spawn timing, target movement, and/or reaction windows. Do not show a level number on the gameplay screen; difficulty should progress invisibly.
Include score, personal best, combo feedback, pause/resume, lives or an equivalent fail condition, game-over, and quick restart.
Feedback should feel immediate: brief screen/target reaction, comic burst, and optional sound/haptics where supported.
Avoid unfair targets, accidental taps, and UI controls that block the action area.
Support mouse, touch, and keyboard where practical. Make the core game playable without requiring an account.
5. Platform and responsive goals
Target modern browsers on:
Android and iOS phones
Tablets
Windows, macOS, and Linux computers
Android TV / Apple TV browsers where practical
Other modern browser-based devices
Use responsive layout and scalable input targets. Do not claim a platform is fully supported until tested on it. TV/remote navigation may require a dedicated focus and keyboard/remote input pass.
6. Accounts, progress, and leaderboard
Intended features:
Optional sign-up/login
Saved personal best and game progress
Player profile/stats
Global and friends leaderboard views
Rabbit skins, backgrounds, achievements/rewards, and settings
Do not fake backend persistence. If authentication, cloud saves, or global leaderboard infrastructure is not connected, label the feature as a demo/local feature or implement the backend before presenting it as live. Never commit secrets, API keys, or passwords.
7. Engineering rules
Inspect the actual repository and current code before editing. Preserve working features and the established stack unless a change is necessary.
Prefer small, testable changes over replacing the whole project.
Keep gameplay logic separate from presentation where reasonable.
Keep images/assets optimized for the web and provide fallbacks.
Respect reduced-motion preferences and provide accessible labels/focus states.
Test build, keyboard/touch interactions, responsive layouts, and error states before claiming a feature is complete.
Never invent deployment URLs, pretend a build passed, or claim a feature works without verification.
Do not put secrets in source code or commit them to GitHub.
8. Art generation brief
Whenever generating or commissioning new art, use this brief:
A friendly, expressive white Minecraft-inspired voxel rabbit with upright pink-lined ears, square head/body, and large dark pixel-like eyes, popping out of vivid cubic green bushes in a lush block-built fantasy ruin/forest. A first-person gloved hand reaches from the foreground during a slap. Bold yellow “SLAP!” comic impact lettering, jagged black ink outline, motion streaks, halftone textures, energetic graphic-novel/anime lighting inspired by Spider-Verse, saturated cyan/blue and hot-pink accents, crisp voxel geometry, high contrast, polished game key art. Keep the rabbit's design consistent with the supplied Bush Slap references. No Spider-Man or other copyrighted superhero characters, no realistic rabbit, no smooth generic cartoon replacement.
Adapt framing for each use (hero banner, transparent sprite, background, icon, or game-over panel), but do not change the core character or style.
9. Current-state honesty
This README describes the intended product and direction; it does not prove every listed feature is implemented. Check the code and test the deployed site to determine the current implementation status. Document unfinished features and limitations honestly.
10. Change checklist
Before accepting a major change, confirm:
[ ]
The main rabbit still matches the reference.
[ ]
The voxel/Minecraft environment remains obvious.
[ ]
Comic-book/Spider-Verse-inspired effects complement, not replace, the voxel art.
[ ]
Gameplay difficulty increases without showing a level number.
[ ]
Mobile and desktop layouts remain usable.
[ ]
Existing working functionality was not accidentally removed.
[ ]
No secrets or unsupported claims were added.


**Remember:** Bush Slap is not just any rabbit tapping game. Its signature is the white voxel rabbit, lush cubic bushes, first-person slap, comic-book impact art, and **TAP. SLAP. REPEAT.**
