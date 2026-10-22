# Bush Slap — Godot 4 prototype

This is a **parallel prototype** of Bush Slap. The existing production website is intentionally left untouched while the Godot version is developed and tested.

## Open the project

1. Install Godot 4.x from https://godotengine.org/download/
2. In Godot Project Manager, choose **Import**.
3. Select this folder's `project.godot` file.
4. Run the project (F6/F5).

## Prototype features

- Procedurally generated voxel-style garden, trees and bushes.
- Blocky white rabbit with upright pink ears and visible feet.
- Mouse and touch input with a raycast hit target.
- Score, combo, timer and round restart.
- Comic-style SLAP/POW/BONK hit lettering and colorful voxel burst particles.
- Personal-best score saved locally with Godot's user data configuration.
- Difficulty ramps gently: rabbit time and spawn gaps tighten gradually with a lower bound.
- No visible level number.

## Current limitations

This is an early prototype foundation, not a verified release. The art is built from procedural cubes and needs the final approved concept-art assets, more expressive rabbit animation, audio, accessibility review, and performance tuning. Personal best is saved locally; online accounts, cloud sync, and global leaderboards are not implemented. The scene has not yet been run through the Godot editor or tested on real devices, so syntax/runtime and input behavior still need validation.

## Browser export

Use Godot's **Web** export preset after installing the matching export templates. Test the exported build on actual desktop and mobile browsers before replacing the live website. Godot 4 web exports require WebAssembly and WebGL 2 support; browser and TV compatibility must be verified individually.
