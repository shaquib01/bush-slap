# Bush Slap — Godot 4 prototype

This is a **parallel prototype** of Bush Slap. The existing production website is intentionally left untouched while the Godot version is developed and tested.

## Open the project locally

1. Install Godot 4.4.1 from https://godotengine.org/download/archive/4.4.1-stable/
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

## Automated checks and browser build

The GitHub Actions workflow at `.github/workflows/godot-check.yml` runs an editor import check, installs the matching Godot 4.4.1 export templates, and attempts a Web export using `export_presets.cfg`. When successful, it uploads the output as the `bush-slap-godot-web` workflow artifact for 14 days.

To inspect the workflow, open the **Actions** tab in the repository and select **Godot 4 prototype check**. A successful Vercel status alone is not proof that the Godot Web export passed. The exported artifact must contain `index.html` and the Godot Web runtime files before it is deployed to a separate preview site.

## Current limitations

This is an early prototype foundation, not a verified release. The art is built from procedural cubes and needs the final approved concept-art assets, further expressive rabbit/ear animation, audio, accessibility review, and performance tuning. Responsive layout code is in place but still needs runtime testing on actual phone aspect ratios. Recent face, tail and paw details are still placeholder geometry rather than final character art. Personal best is saved locally; online accounts, cloud sync, and global leaderboards are not implemented.

The scene and web export have not yet been verified in a real Godot runtime or on actual devices. CI export success is the next validation gate; after that, test desktop and mobile browsers and verify Android TV / Apple TV compatibility individually before replacing or redirecting the live website.

## Browser requirements

Godot 4 Web exports use WebAssembly and WebGL 2. Browser/device support and performance vary, especially on smart TVs. The Godot prototype is separate from the production website until the exported build has been validated.
