# Pixel Space Shooter Kit 1.1.1

Vertical-shooter sprite kit: ships, enemies, bosses, VFX, parallax zones, HUD/UI and space-station tiles, with JSON atlases and three Tiled sample stages. Style: dark-space pixel art with hue-shifted 5-tone ramps, ordered-dither form shading (light from the top-left), a cool rim light on the shadow edge and 1 px dark outlines. Pixel scale: ships/enemies 32x32, tiles 16x16; use nearest-neighbour scaling (2x or 3x looks right).

## Measured contents
| Item | Measured |
|---|---|
| Player ships | 33 designs (16 hand-tuned silhouettes + 17 parametric) x 3 colourways = 99 variants, 32x32, 1485 frames (5 re-rasterised bank angles x 3 thruster frames each) |
| Enemy types | 72 (24 shape families x 3 variants, each variant its own part list/silhouette), 32x32, 648 frames (4 idle + 4 attack + hit flash each) |
| Bosses | 7 (1 asymmetric), 128x96, 3 phases each, 231 frames (per phase: 4 idle, 4 attack, 2 telegraph, hit flash) |
| Bullets | 12 shapes x 5 colours x 4 frames = 240 frames, 16x16 |
| Lasers | thin + wide beams, start/body/end, 5 colours, 120 frames |
| Missiles | 8 types x player/enemy colours x 3 frames = 48 frames (16x32) |
| Muzzle flashes | 10 types x 5 colours x 4 frames = 200 frames (24x24) |
| Impact VFX | 10 types x 5 colours x 5 frames = 250 frames (32x32) |
| Explosions | 11 animations x 10-12 frames = 114 frames (32 to 96 px) incl. shockwave-only and debris-only layers |
| Telegraphs | boss attack lane (4), target ring (6), warning icon (2) = 12 frames |
| Asteroids | 4 types x 3 sizes (16/32/64) x 8 rotation frames + 12 fragments |
| Powerups / drones | 14 powerups x 4 frames, 3 drone options x 4 frames |
| Backgrounds | 4 zones, 26 PNG layers (320x512 tileable sky/stars/nebula/dust, planets, structures) |
| UI | 375 items ({'banner': 8, 'control': 36, 'panel': 21, 'icon': 66, 'button': 216, 'hud': 24, 'cursor': 4}), 66 with 9-slice metadata, 3 themes, 5x7 bitmap font v2 (caps, lowercase, digits, punctuation) in 4 colours |
| Station tiles | 498 16x16 tiles: 6 materials x 47-blob autotile (282), 36 back walls, 64 pipes, 36 details, 80 animated-tile frames |
| Station objects | 8 multi-tile objects (turret, reactor, dish, solar array, tank, nozzle, hangar door, light strip) |
| Tiled stages | 3 x 20x128 (320x2048 px); objects: 51, 96, 66 placed (enemies 46, 57, 51; pickups 3, 3, 3; asteroids 0, 34, 10) + 6 boss placements |
| Tiled check | tiled check: 3 tmx, 5 tsx, 9 layers, 6393 painted cells, 213 tile objects, 0 errors |
| Atlas sheets | ships 1056x1550, enemies 1056x692, bosses 1040x2812, fx 1056x1235, objects 1056x276 |
| Individual PNGs | 204 (first/idle frames, for Tiled image-collection tilesets and quick use) |
| Unique colours in sprite atlases | 1030 |

## Folders
- `sprites/ships.png|json`, `enemies`, `bosses`, `fx`, `objects`: atlases in a TexturePacker-style hash format: `frames` (x,y,w,h), `animations` (`frames`, `fps`, `loop`), `meta`.
- Ship frames: `<ship>_<colour>_<bl2|bl1|c|br1|br2>_<0..2>` (bank left 2/1, centre, bank right 1/2; 3 thruster frames). Animations: `<ship>_<colour>_idle`, `_bl1`, `_bl2`, `_br1`, `_br2`. Ships point up, enemies and bosses point down.
- Enemy animations: `<name>_idle` (4), `<name>_attack` (4, no loop), `<name>_hit`. Boss animations: `<name>_p1_idle` (4), `_p1_telegraph` (warning pulse), `_p1_attack` (windup, charge, fire, recover; no loop), `_p1_hit` (and p2, p3). `atk_2` carries a fire flash; fx.png has `telegraph_lane`, `telegraph_ring`, `warning_icon`.
- `fx.png|json`: bullets, lasers (tile `body` vertically, `start` at the emitter, `end` at the tip), missiles (player = cyan, enemy = red accent), muzzle flashes, impacts, explosions.
- `sprites/singles/`: individual PNGs (ships, enemies, bosses, pickups, asteroids).
- `backgrounds/<zone>/`: `sky`, `stars_far`, `nebula`, `stars_near`, `dust`, `planet` (+ `structure` or `asteroid_silhouettes` in zones 4 and 2), `preview_composite.png`. Suggested parallax factors: stars_far 0.15, nebula 0.3, planet 0.35, stars_near 0.5, structure 0.55, dust 1.4.
- `ui/`: `ui.png|json` atlas, `ui_9slice.json` (size + l/t/r/b slice insets), `font_5x7_<colour>.png` + `font_5x7.json` (caps, digits, punctuation).
- `tiled/`: `station_tiles.png/.tsx` (16x16, 32 columns, tile `type` = name, animated tiles defined), image-collection tilesets (`enemies`, `bosses`, `pickups`, `asteroids`), `station_objects.png|json`, and `stage1_orbital_dock.tmx`, `stage2_belt_foundry.tmx`, `stage3_dead_station.tmx`.
- `godot/`: `atlas_loader.gd` (SpriteFrames from any atlas JSON), `demo.gd` + `demo.tscn` sample scene (parallax, banking ship, boss telegraph cycle). See Godot notes below.
- `tiled/verify_tiled.py`: stdlib-only parse + gid check for the shipped maps.
- `previews/`: cover, 8 screenshots, full-stage renders, 5 animated GIFs (stage scroll, explosions, banking, boss phases, enemies).

## Tiled stages
Each stage is 20x128 tiles of 16 px (320x2048), scrolling upward (player starts at the bottom, `player_start`). Layers: `background_deck`, `hull` (47-blob autotiled walls and islands), `decor`; object layers: `hazards` (asteroids), `pickups`, `enemies` (tile objects with `wave`, `pattern`, `delay`, `shoot_interval` properties), `bosses` (mid and end boss), `markers` (start point, boss triggers). Map properties give the zone name and a suggested scroll speed. Autotile index `k` in `<material>_blob_<k>` follows the standard 47-blob bit order (N, NE, E, SE, S, SW, W, NW; diagonals only when both neighbours are set).

## Godot 4 notes
Copy `sprites/`, `backgrounds/` and `godot/` into a Godot 4 project (so paths read `res://sprites/ships.png`, `res://godot/demo.gd`), set Project Settings > Rendering > Textures > Default Texture Filter to Nearest, and open `godot/demo.tscn`. `AtlasLoader.load_frames(json, png)` turns each atlas JSON into a `SpriteFrames` (animation names as above, fps and loop flags from the JSON). Release check (Godot 4.7.2 stable, macOS arm64, headless, fresh project): all 5 atlas JSONs build SpriteFrames through `godot/atlas_loader.gd` (495 + 216 + 84 + 220 + 29 animations, 3554 frame slots over 3524 unique atlas frames; 0 regions outside the PNG; the only empty frames are the first frame of 3 explosion layers: `explosion_shockwave_0`, `explosion_debris_0`, `explosion_debris_xl_0`), `godot/demo.tscn` instantiates and runs 14 frames, `ui/ui_9slice.json` (66 entries) and the font PNG load, and `tiled/station_tiles.png` builds a 16x16 TileSetAtlasSource. Headless means no rendering: visuals were checked in the preview images only. NOT tested: Godot 3, Unity, Unreal, the Tiled application, Tiled importer add-ons for Godot.

## Not included
Sound/music, game code or engine scripts, enemy AI and bullet patterns (spawn metadata only), a ship destruction animation separate from the explosions, top-down or side-scrolling variants. Not tested: Unity, Unreal, Godot 3 (Godot 4 run results are in the Godot notes above). Tiled files were generated by script and verified with `tiled/verify_tiled.py` and a second independent parser (XML parse, tileset image sizes/columns, tile ids, animation frames, every layer gid and object gid resolved to an existing tile, object sizes and positions inside the map: 0 errors); parsed and validated only, the Tiled application was not opened.

## Credits
Made with procedural code written with AI assistance (Python, Pillow, numpy). No image-generation models were used.
