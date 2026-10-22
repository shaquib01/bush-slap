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
- No visible level number.

## Current limitations

This is the first playable foundation, not the finished game. The art is built from procedural cubes and needs the final approved concept-art assets, improved animation, richer comic impact effects, audio, saved high scores and difficulty balancing. The score/best value is currently session-only. Online accounts and leaderboards are not implemented.

## Browser export

Use Godot's **Web** export preset after installing the matching export templates. Test the exported build on actual desktop and mobile browsers before replacing the live website. Godot 4 web exports require WebAssembly and WebGL 2 support; browser and TV compatibility must be verified individually.
