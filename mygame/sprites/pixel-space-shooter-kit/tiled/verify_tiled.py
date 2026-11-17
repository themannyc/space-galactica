#!/usr/bin/env python3
"""Standalone Tiled verification (stdlib only): `python3 verify_tiled.py <tiled_dir>`.
Parses every .tmx and .tsx, checks tileset images/sources exist and match columns*tile size, every tile-layer gid resolves into a tileset range, every object gid resolves to a tile (and collection tiles have an existing image), layer sizes match the map. This is a parse + gid check, NOT a run inside the Tiled application."""
import sys, struct, pathlib, xml.etree.ElementTree as ET
def png_size(p):
    with open(p, 'rb') as f: h = f.read(24)
    assert h[:8] == b'\x89PNG\r\n\x1a\n', f'not a PNG: {p}'; return struct.unpack('>II', h[16:24])
def main(d):
    d = pathlib.Path(d); res = {'tmx': 0, 'tsx': 0, 'layers': 0, 'tile_cells': 0, 'objects': 0, 'errors': []}; err = res['errors'].append; TS = {}
    for p in sorted(d.glob('*.tsx')):
        r = ET.parse(p).getroot(); n = int(r.get('tilecount')); tw, th = int(r.get('tilewidth')), int(r.get('tileheight')); cols = int(r.get('columns')); img = r.find('image'); ids = {int(t.get('id')) for t in r.findall('tile')}; res['tsx'] += 1; has = {}
        if img is not None:
            w, h = png_size(d / img.get('source'))
            if (int(img.get('width')), int(img.get('height'))) != (w, h): err(f'{p.name}: image size attr != file')
            if cols * tw > w or (n + cols - 1) // cols * th > h: err(f'{p.name}: tilecount/columns exceed image')
        else:
            if ids != set(range(n)): err(f'{p.name}: tile ids not 0..{n-1}')
            for t in r.findall('tile'):
                im = t.find('image'); q = (d / im.get('source')).resolve()
                if not q.exists(): err(f'{p.name}: missing {im.get("source")}')
                else: has[int(t.get('id'))] = png_size(q)
        TS[p.name] = (n, img is not None, has)
    for p in sorted(d.glob('*.tmx')):
        r = ET.parse(p).getroot(); res['tmx'] += 1; W, H = int(r.get('width')), int(r.get('height')); sets = []
        for t in r.findall('tileset'):
            src = t.get('source')
            if src not in TS: err(f'{p.name}: tileset {src} missing'); continue
            sets.append((int(t.get('firstgid')), src))
        sets.sort()
        def resolve(g):
            for fg, src in reversed(sets):
                if g >= fg:
                    n, img, has = TS[src]
                    return (src, g - fg, n, img, has) if g - fg < n else None
            return None
        for lay in r.iter('layer'):
            res['layers'] += 1; dt = lay.find('data')
            if dt.get('encoding') != 'csv': err(f'{p.name}:{lay.get("name")} not csv'); continue
            v = [int(x) for x in dt.text.replace('\n', '').split(',') if x.strip()]
            if len(v) != W * H or int(lay.get('width')) != W or int(lay.get('height')) != H: err(f'{p.name}:{lay.get("name")} size mismatch ({len(v)} vs {W*H})')
            for g in v:
                if g == 0: continue
                res['tile_cells'] += 1
                if resolve(g) is None: err(f'{p.name}:{lay.get("name")} bad gid {g}'); break
        for o in r.iter('object'):
            g = o.get('gid')
            if g is None: continue
            res['objects'] += 1; q = resolve(int(g))
            if q is None: err(f'{p.name}: object {o.get("id")} bad gid {g}'); continue
            src, lid, n, img, has = q
            if not img and lid not in has: err(f'{p.name}: object {o.get("id")} tile {src}#{lid} has no image')
    print(f"tiled check: {res['tmx']} tmx, {res['tsx']} tsx, {res['layers']} layers, {res['tile_cells']} painted cells, {res['objects']} tile objects, {len(res['errors'])} errors")
    for e in res['errors'][:20]: print('  ERR', e)
    return res
if __name__ == '__main__':
    r = main(sys.argv[1] if len(sys.argv) > 1 else '.'); sys.exit(1 if r['errors'] else 0)
