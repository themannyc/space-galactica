# PROVENANCE - Pixel Space Shooter Kit 1.1.1

Release-candidate record: what made the files in this pack and under which terms. Checked against the build sources on the build machine (grep for network access, model weights, font and image inputs).

## Art and code
Every sprite, tile, background, UI element and the 5x7 bitmap font is drawn by the Python generator in this project (`art_*.py`, `sslib.py`, `build_all.py`; Pillow + numpy). The bitmap font glyphs are hand-coded pixel tables in `sslib.py`; no font file is used or shipped. The generator source is not in the zip.
- Generation: procedural Python 3.12 code written with AI assistance (Claude). No image-generation or other ML model was run, no model weights, LoRAs or datasets were used, and no external or downloaded artwork, textures, sprites or reference images were read by the generator (the only images it opens are its own outputs).
- Libraries used at build time (not bundled in the zip): Pillow 13.0.0 (HPND licence), NumPy 2.5.4 (BSD-3-Clause), standard-library xml.etree / zipfile / json.
- Licence of the files: see LICENSE.txt (commercial use allowed, no resale or redistribution of the files, no warranty).

## Fonts
- Shipped: none (no .ttf/.otf/.woff in the zip, verified by listing). The in-game font is the hand-coded 5x7 bitmap in `ui/` (own work, same licence as the pack).
- Preview captions use the same own bitmap font.

## External assets
None. No CC0/CC-BY/third-party sprites, tiles, sounds, palettes or code snippets are included. (A fixed palette is defined in the generator code; it is not copied from a named public palette.)

## Open items
- None known. No fonts or third-party inputs.

