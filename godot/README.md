# Bush Slap — Godot 4 prototype

This is a **parallel prototype** of Bush Slap. The existing production website is intentionally left untouched while the Godot version is developed and tested.

## Open the project locally

1. Install Godot 4.4.1 from https://godotengine.org/download/archive/4.4.1-stable/
2. In Godot Project Manager, choose **Import**.
3. Select this folder's `project.godot` file.
4. Run the project (F6/F5).

## Prototype features

- Procedurally generated voxel-style garden, trees, bushes, stepped sunburst and drifting clouds.
- Blocky white rabbit with upright pink ears, visible feet, paw pads, eye highlights, a pixel tail and a small forelock.
- Mouse and touch input with a raycast hit target, plus keyboard controls: Space slaps toward the centre of the screen and Enter starts/restarts a round.
- Score, combo, timer and round restart.
- Camera-attached blocky first-person hand with a three-beat slap swing animation and subtle idle breathing/rotation when not swinging.
- Rabbit pop-in entrance, gentle side-to-side / forward-back movement and independently swaying ears.
- Comic-style SLAP/POW/BONK hit lettering, floating +points popups, radial voxel burst particles with rectangular speed-line shards, brief camera jolt on a successful hit, and red MISS! cue on missed taps.
- Rabbits avoid spawning from the same bush twice consecutively.
- More readable target bushes with bright leaf/berry pixels, foreground stones and trail markers.
- Responsive HUD that reduces score, timer, combo, prompt and overlay sizing on narrow viewports and updates when the viewport changes.
- Personal-best score saved locally with Godot's user data configuration.
- Difficulty ramps gently: rabbit time and spawn gaps tighten gradually with a lower bound.
- No visible level number.

## Automated checks and browser build

The GitHub Actions workflow at `.github/workflows/godot-check.yml` runs an editor import check, headless scene smoke test, and Web export. A successful run uploads `bush-slap-godot-web` as a downloadable workflow artifact for 14 days.

A separate workflow, `.github/workflows/deploy-godot-pages.yml`, publishes the prototype to GitHub Pages. The most recent completed deployment for commit `795afebb` succeeded in both the Godot export/deploy workflow and GitHub Pages build/deployment workflow. A newer hand-idle animation commit is currently awaiting final workflow confirmation; check the [Actions tab](https://github.com/shaquib01/bush-slap/actions) for its status. The expected preview URL is https://shaquib01.github.io/bush-slap/, but a green deployment job alone does not prove the game has been tested in a real browser.

## Current limitations

This is an early prototype foundation, not a verified release. The art is built from procedural cubes and needs the final approved concept-art assets, more expressive character animation, audio, accessibility review and performance tuning. Responsive layout code is in place but still needs runtime testing on actual phone aspect ratios. Face, tail and paw details are placeholder geometry rather than final character art. Personal best is saved locally; online accounts, cloud sync and global leaderboards are not implemented.

CI confirms the editor import, headless scene smoke test and Web export, but that is not the same as testing gameplay in a real browser or on actual devices. Test desktop and mobile browsers first, then verify Android TV / Apple TV compatibility individually before replacing or redirecting the live website.

## Browser requirements

Godot 4 Web exports use WebAssembly and WebGL 2. Browser/device support and performance vary, especially on smart TVs. The Godot prototype is separate from the production website until the exported build has been validated.
