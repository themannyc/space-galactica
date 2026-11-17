extends Node2D
## Minimal vertical-shooter sample: scrolling parallax, banking player ship, a boss that cycles idle -> telegraph -> attack.
## Copy the kit's sprites/ and backgrounds/ folders next to godot/ in a Godot 4 project, then run demo.tscn.
## Run headless in Godot 4.7.2 (instantiated, 14 frames processed; visuals not checked). See README.

const SHIP := "azure"
var player: AnimatedSprite2D
var boss: AnimatedSprite2D
var layers := []   # [Sprite2D, speed]
var boss_timer := 0.0

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var cam := Camera2D.new(); cam.position = Vector2(160, 240); cam.zoom = Vector2(2, 2); add_child(cam)
	for pair in [["stars_far", 8.0], ["nebula", 20.0], ["stars_near", 40.0], ["dust", 90.0]]:
		var s := Sprite2D.new(); s.texture = load("res://backgrounds/nebula_rim/%s.png" % pair[0]); s.centered = false
		s.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED; s.region_enabled = true; s.region_rect = Rect2(0, 0, 320, 1024); s.position = Vector2(0, -512)
		add_child(s); layers.append([s, pair[1]])
	player = AnimatedSprite2D.new(); player.sprite_frames = AtlasLoader.load_frames("res://sprites/ships.json", "res://sprites/ships.png")
	player.position = Vector2(160, 400); player.play("delta_wing_%s_idle" % SHIP); add_child(player)
	boss = AnimatedSprite2D.new(); boss.sprite_frames = AtlasLoader.load_frames("res://sprites/bosses.json", "res://sprites/bosses.png")
	boss.position = Vector2(160, 90); boss.play("rift_raider_p1_idle"); add_child(boss)

func _process(delta: float) -> void:
	for l in layers:
		l[0].position.y += l[1] * delta
		if l[0].position.y > 0.0: l[0].position.y -= 512.0
	var dir := Input.get_axis("ui_left", "ui_right")
	player.position.x = clampf(player.position.x + dir * 160.0 * delta, 24.0, 296.0)
	var bank := "idle"
	if dir < -0.1: bank = "bl2"
	elif dir > 0.1: bank = "br2"
	var want := "delta_wing_%s_%s" % [SHIP, bank]
	if player.animation != want: player.play(want)
	boss_timer += delta
	var cycle := fmod(boss_timer, 4.0)
	var want_boss := "rift_raider_p1_idle"
	if cycle > 2.0 and cycle < 3.0: want_boss = "rift_raider_p1_telegraph"
	elif cycle >= 3.0: want_boss = "rift_raider_p1_attack"
	if boss.animation != want_boss: boss.play(want_boss)
