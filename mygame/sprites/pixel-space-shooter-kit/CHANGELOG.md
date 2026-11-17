# Changelog

## 1.1.1
- Release audit: README/LISTING claims re-checked against the zip by script; Godot 4 loader and demo scene now run-tested in Godot 4.7.2 (headless); wording updated ("3524 unique atlas frames"). No art changes. Added PROVENANCE.md.

## 1.1.0
- Enemies: 24 shape families x 3 variants with distinct silhouettes (72 total, was 12 families x 2).
- Ships: 16 hand-tuned silhouettes (explicit coordinates) plus 17 parametric hulls; banking frames are now re-rasterised roll poses (foreshortening, spine shift, tip shear, shaded underside), not a squashed hull.
- Shading: distance-field form shading with ordered-dither ramps, top-left highlight and cool rim light on every ship, enemy and boss.
- Bosses: 7 (new asymmetric Rift Raider); 11 frames per phase (4 idle, windup/charge/fire/recover attack, 2 telegraph, hit); phases tear asymmetric chunks off the silhouette; telegraph lane, ring and warning sprites in fx.png.
- Explosions: new 10-12 frame lobed fireballs with white flash star, shockwave ring, tumbling debris with trails and smoke; separate shockwave and debris layers.
- Font: lowercase with descenders plus extra punctuation (5x7 v2).
- Previews: integer-scale cover with clean title band, 8 screenshots, 5 animated GIFs.
- Added `godot/` sample scene + atlas loader, `tiled/verify_tiled.py` check script.

## 1.0.0
- First release: 33 ships x 3 colourways, 24 enemy types, 6 bosses x 3 phases, bullets/lasers/missiles + muzzle/impact VFX, 10 explosion animations, asteroids, 14 powerups, 4 parallax zones, HUD/UI kit with 3 themes, 498-tile station tileset, 3 Tiled sample stages, JSON atlases.
