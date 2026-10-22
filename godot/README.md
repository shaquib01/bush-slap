# Bush Slap — Godot 4 prototype

This is a **parallel prototype** of Bush Slap. The existing production website is intentionally left untouched while the Godot version is developed and tested.

## Open the project

1. Install Godot 4.x from https://godotengine.org/download/
2. In Godot Project Manager, choose **Import**.
3. Select this folder's `project.godot` file.
4. Run the project (F6/F5).

## Prototype features

- Procedurally generated voxel-style garden, trees and bushes.
- Blocky white rabbit with upright pink ears, visible feet, paw pads, eye highlights, a pixel tail and a small forelock.
- Mouse and touch input with a raycast hit target, plus keyboard controls: Space slaps toward the centre of the screen and Enter starts/restarts a round.
- Score, combo, timer and round restart.
- Camera-attached blocky first-person hand with a three-beat slap swing animation.
- Rabbit pop-in entrance, gentle side-to-side / forward-back movement, hop bounce and independently swaying ears, plus comic-style SLAP/POW/BONK hit lettering, floating +points popups, colorful voxel burst particles, a brief camera jolt on a successful hit, and a red MISS! cue on missed taps.
- Slightly more forgiving rabbit hitbox and longer appearance window to improve touch play.
- More readable target bushes with bright leaf/berry pixels, foreground stones, and small trail markers.
- Responsive HUD that reduces score, timer, combo, prompt and overlay sizing on narrow viewports and updates when the viewport changes.
- Personal-best score saved locally with Godot's user data configuration.
- Difficulty ramps gently: rabbit time and spawn gaps tighten gradually with a lower bound.
- No visible level number.

## Current limitations

This is an early prototype foundation, not a verified release. The art is built from procedural cubes and needs the final approved concept-art assets, further expressive rabbit/ear animation, audio, accessibility review, and performance tuning. Responsive layout code is in place but still needs runtime testing on actual phone aspect ratios. Recent face, tail and paw details are still placeholder geometry rather than final character art. Personal best is saved locally; online accounts, cloud sync, and global leaderboards are not implemented. The scene has not yet been run through the Godot editor or tested on real devices, so syntax/runtime and input behavior still need validation.

## Automated project check

A GitHub Actions workflow in `.github/workflows/godot-check.yml` installs Godot 4.4.1 and runs a headless editor import check whenever the prototype files change. This can catch project-import and script parse errors, but it does **not** prove gameplay, rendering, touch input, or browser export works. Check the workflow status on the `godot4-prototype` branch after each commit.

## Browser export

Use Godot's **Web** export preset after installing the matching export templates. Test the exported build on actual desktop and mobile browsers before replacing the live website. Godot 4 web exports require WebAssembly and WebGL 2 support; browser and TV compatibility must be verified individually.
