class_name AtlasLoader
extends RefCounted
## Builds a SpriteFrames resource from one of the kit's atlases (ships, enemies, bosses, fx, objects).
## The JSON "animations" block (frames, fps, loop) maps 1:1 onto SpriteFrames animations.
## Usage: var frames := AtlasLoader.load_frames("res://sprites/ships.json", "res://sprites/ships.png")

static func load_frames(json_path: String, png_path: String) -> SpriteFrames:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(json_path))
	var tex: Texture2D = load(png_path)
	var sf := SpriteFrames.new()
	if sf.has_animation("default"):
		sf.remove_animation("default")
	var frames: Dictionary = data["frames"]
	for anim_name in data["animations"].keys():
		var a: Dictionary = data["animations"][anim_name]
		sf.add_animation(anim_name)
		sf.set_animation_speed(anim_name, a["fps"])
		sf.set_animation_loop(anim_name, a["loop"])
		for fname in a["frames"]:
			var r: Dictionary = frames[fname]["frame"]
			var at := AtlasTexture.new()
			at.atlas = tex
			at.region = Rect2(r["x"], r["y"], r["w"], r["h"])
			sf.add_frame(anim_name, at)
	return sf
