
require "app/player"

class Game
  attr_gtk

  # ================================================================
  # ASSETS
  # ================================================================

  BACKGROUND_FALLBACK = "sprites/space.png"

  PLANET_ASSETS = (0..9).map do |i|
    "sprites/Planets/planet0#{i}.png"
  end

  METEOR_ASSETS = (1..4).map do |i|
    "sprites/space_assets/Meteors/meteorBrown_big#{i}.png"
  end

  UFO_BLUE = "sprites/space_assets/ufoBlue.png"
  UFO_RED  = "sprites/space_assets/ufoRed.png"

  PLASMA_ASSET =
    "sprites/space_assets/Lasers/laserBlue01.png"

  ENEMY_BULLET_ASSET =
    "sprites/space_assets/Lasers/laserRed01.png"

  SPACE_BOSS_ASSET =
    "sprites/PNG_Parts&Spriter_Animation/Ship6/Ship6.png"

  BOSS_SHOT_DIR =
    "sprites/PNG_Parts&Spriter_Animation/Shots/Shot2"

  BOSS_BULLET_FRAMES = (1..6).map do |i|
    "#{BOSS_SHOT_DIR}/shot2_#{i}.png"
  end

  BOSS_HIT_FRAMES = (1..5).map do |i|
    "#{BOSS_SHOT_DIR}/shot2_exp#{i}.png"
  end

  # Dragon animation
  DRAGON_FRAMES = (0..5).map do |i|
    "sprites/dragon-#{i}.png"
  end

  DRAGON_ANIMATION_SPEED = 8

  # Power-up sprites
  POWERUP_SPRITES = {
    shield: "sprites/powerupBlue_shield.png",
    repair: "sprites/powerupBlue_star.png",
    speed:  "sprites/powerupBlue_bolt.png"
  }

  POWERUP_FALLBACK = "sprites/powerupBlue.png"

  # Special shot sprites.
  # Replace these paths when you add the artwork.
  POWER_SHOT_SPRITE = "sprites/power_shot.png"
  SUPER_SHOT_SPRITE = "sprites/super_shot.png"

  # ================================================================
  # SETTINGS
  # ================================================================

  PLAYER_MAX_HP = 3
  INVULN_TICKS = 90
  PLASMA_SPEED = 16
  UFO_ENTRY_SPEED = 3

  WAVES_PER_WORLD = 3
  PROMPT_DELAY = 45
  HEAL_ON_NEW_WORLD = true
  FADE_IN_TICKS = 70

  LOOP_WORLDS = true
  PLANET_SCROLL_SPEED = 3

  DESCENT_PLANET_SIZE = 640
  DESCENT_SLIDE_TICKS = 80
  DESCENT_DIVE_START = 60
  DESCENT_DIVE_END = 200
  DESCENT_TOTAL = 250

  ASCENT_TOTAL = 220
  ASCENT_FLY_END = 165

  # Easier bosses
  BOSS_BULLET_SPEED_MULT = 0.65
  BOSS_FIRE_RATE_MULT = 1.5
  BOSS_RING_RATE_MULT = 1.6
  BOSS_MOVE_SPEED_MULT = 0.8

  BOSS_BULLET_SIZE = 48
  BOSS_BULLET_HIT_R = 14
  BOSS_BULLET_ANIM_SPEED = 4

  HIT_EFFECT_SIZE = 96
  HIT_EFFECT_ANIM_SPEED = 4

  # Power-ups
  POWERUP_SPAWN_MIN = 500
  POWERUP_SPAWN_MAX = 850
  POWERUP_SPEED = 2.5
  POWERUP_SIZE = 58

  SHIELD_DURATION = 300
  SPEED_DURATION = 360
  SPEED_MULTIPLIER = 1.5

  # Combo weapons
  POWER_SHOT_THRESHOLD = 5
  SUPER_SHOT_THRESHOLD = 10

  POWER_SHOT_DAMAGE = 3
  SUPER_SHOT_DAMAGE = 6

  COMBO_TIMEOUT = 240

  # ================================================================
  # WORLDS
  #
  # Each world has independent enemies and boss settings.
  # Add new worlds by copying an entry.
  # ================================================================

  WORLDS = [

    # ================================================================
    # WORLD 1 - DEEP SPACE
    # ================================================================

    {
      name: "Deep Space",
      type: :space,

      background: BACKGROUND_FALLBACK,
      bg_fallback_tint: [255, 255, 255],

      planets: PLANET_ASSETS,
      landing_planet: PLANET_ASSETS[0],
      meteor_assets: METEOR_ASSETS,

      waves: {
        1 => {
          meteors: 5,
          meteor_speed: 4..6,
          meteor_drift: 0,

          ufo_groups: [
            {
              count: 3, hp: 1,
              path: UFO_BLUE,
              move: :sine,
              amp: 100, bob: 0.03,
              shoot: :straight,
              fire_rate: 150,
              bullet_speed: 6
            }
          ]
        },

        2 => {
          meteors: 8,
          meteor_speed: 7..10,
          meteor_drift: 2,

          ufo_groups: [
            {
              count: 6, hp: 2,
              path: UFO_RED,
              move: :sine,
              amp: 160, bob: 0.05,
              shoot: :spread3,
              fire_rate: 140,
              bullet_speed: 8
            }
          ]
        },

        3 => {
          meteors: 3,
          meteor_speed: 4..6,
          meteor_drift: 0,
          ufo_groups: [],
          boss: true
        }
      },

      boss: {
        type: :spaceship,
        asset: SPACE_BOSS_ASSET,
        animation_frames: nil,
        tint: [255, 255, 255],

        w: 400, h: 400,
        hp: 60,

        move_speed: [3, 4.5, 6],
        fire_rate: [90, 75, 55],
        bullet_speed: [7, 8, 9],

        ring_step: [30, 24],
        ring_rate: [200, 140],
        sweep: false
      }
    },

    # ================================================================
    # WORLD 2 - EMBER PLANET
    # Animated dragon boss
    # ================================================================

    {
      name: "Ember Planet",
      type: :planet,

      background:
        "sprites/planet_maps/_PNG/1/1_game_background.png",

      bg_fallback_tint: [255, 180, 130],
      scroll_speed: 3,

      planets: PLANET_ASSETS,
      landing_planet: PLANET_ASSETS[2],
      meteor_assets: METEOR_ASSETS,

      waves: {
        1 => {
          meteors: 5,
          meteor_speed: 5..7,
          meteor_drift: 1,

          ufo_groups: [
            {
              count: 4, hp: 2,
              path: UFO_RED,
              tint: [255, 160, 80],
              move: :zigzag,
              speed: 3,
              shoot: :burst,
              fire_rate: 145,
              bullet_speed: 6,
              bullet_tint: [255, 140, 70]
            }
          ]
        },

        2 => {
          meteors: 6,
          meteor_speed: 6..8,
          meteor_drift: 2,

          ufo_groups: [
            {
              count: 3, hp: 3,
              path: UFO_RED,
              tint: [255, 110, 70],
              move: :circle,
              radius: 90,
              orbit_speed: 0.03,
              shoot: :fan,
              fire_rate: 160,
              bullet_speed: 5
            },

            {
              count: 2, hp: 2,
              path: UFO_BLUE,
              tint: [255, 220, 120],
              move: :sine,
              amp: 120, bob: 0.04,
              shoot: :aimed,
              fire_rate: 135,
              bullet_speed: 6
            }
          ]
        },

        3 => {
          meteors: 2,
          meteor_speed: 4..6,
          meteor_drift: 0,
          ufo_groups: [],
          boss: true
        }
      },

      boss: {
        type: :dragon,

        asset: DRAGON_FRAMES[0],
        animation_frames: DRAGON_FRAMES,
        animation_speed: DRAGON_ANIMATION_SPEED,

        tint: [255, 255, 255],

        w: 350, h: 350,
        hp: 75,

        move_speed: [2.5, 3.5, 4.5],
        fire_rate: [135, 115, 95],
        bullet_speed: [5, 6, 7],

        ring_step: [40, 35],
        ring_rate: [260, 220],
        sweep: true,

        fireball_size: 44,
        fireball_color: [255, 100, 25]
      }
    },

    # ================================================================
    # WORLD 3 - NEBULA SECTOR
    # ================================================================

    {
      name: "Nebula Sector",
      type: :space,

      background: "sprites/space_world3.png",
      bg_fallback_tint: [160, 120, 255],

      planets: PLANET_ASSETS,
      landing_planet: PLANET_ASSETS[3],
      meteor_assets: METEOR_ASSETS,

      waves: {
        1 => {
          meteors: 7,
          meteor_speed: 6..9,
          meteor_drift: 2,

          ufo_groups: [
            {
              count: 5, hp: 2,
              path: UFO_BLUE,
              tint: [180, 120, 255],
              move: :zigzag,
              speed: 4,
              shoot: :aimed,
              fire_rate: 120,
              bullet_speed: 7
            }
          ]
        },

        2 => {
          meteors: 8,
          meteor_speed: 7..10,
          meteor_drift: 2,

          ufo_groups: [
            {
              count: 4, hp: 3,
              path: UFO_RED,
              tint: [120, 255, 255],
              move: :circle,
              radius: 110,
              orbit_speed: 0.04,
              shoot: :spread3,
              fire_rate: 120,
              bullet_speed: 7
            }
          ]
        },

        3 => {
          meteors: 3,
          meteor_speed: 5..7,
          meteor_drift: 1,
          ufo_groups: [],
          boss: true
        }
      },

      boss: {
        type: :spaceship,
        asset: "sprites/boss3.png",
        animation_frames: nil,
        fallback_tint: [150, 100, 255],

        w: 420, h: 420,
        hp: 100,

        move_speed: [4, 5, 6],
        fire_rate: [95, 80, 65],
        bullet_speed: [7, 8, 9],

        ring_step: [30, 24],
        ring_rate: [210, 170],
        sweep: true
      }
    },

    # ================================================================
    # WORLD 4 - FROZEN PLANET
    # ================================================================

    {
      name: "Frozen Planet",
      type: :planet,

      background: "sprites/planet_world4.png",
      bg_fallback_tint: [150, 210, 255],
      scroll_speed: 4,

      planets: PLANET_ASSETS,
      landing_planet: PLANET_ASSETS[4],
      meteor_assets: METEOR_ASSETS,

      waves: {
        1 => {
          meteors: 5,
          meteor_speed: 5..8,
          meteor_drift: 1,

          ufo_groups: [
            {
              count: 5, hp: 3,
              path: UFO_BLUE,
              tint: [120, 200, 255],
              move: :sine,
              amp: 130, bob: 0.04,
              shoot: :burst,
              fire_rate: 140,
              bullet_speed: 6
            }
          ]
        },

        2 => {
          meteors: 7,
          meteor_speed: 6..9,
          meteor_drift: 2,

          ufo_groups: [
            {
              count: 4, hp: 3,
              path: UFO_RED,
              tint: [180, 240, 255],
              move: :strafe,
              speed: 4,
              shoot: :spread3,
              fire_rate: 145,
              bullet_speed: 6
            }
          ]
        },

        3 => {
          meteors: 3,
          meteor_speed: 5..7,
          meteor_drift: 1,
          ufo_groups: [],
          boss: true
        }
      },

      boss: {
        type: :spaceship,
        asset: "sprites/boss4.png",
        animation_frames: nil,
        fallback_tint: [120, 200, 255],

        w: 440, h: 440,
        hp: 110,

        move_speed: [4, 5, 6],
        fire_rate: [95, 80, 65],
        bullet_speed: [7, 8, 9],

        ring_step: [30, 24],
        ring_rate: [200, 160],
        sweep: true
      }
    }
  ]

  # ================================================================
  # SHORTCUTS
  # ================================================================

  def state; args.state; end
  def inputs; args.inputs; end
  def outputs; args.outputs; end
  def grid; args.grid; end
  def audio; args.audio; end
  def gtk; args.gtk; end

  def world
    WORLDS[state.world_index]
  end

  def planet_world?
    world[:type] == :planet
  end

  def space_world?
    world[:type] == :space
  end

  def last_world?
    state.world_index >= WORLDS.length - 1
  end

  def next_world_index
    index = state.world_index + 1
    LOOP_WORLDS ? index % WORLDS.length : index
  end

  def next_world
    WORLDS[next_world_index]
  end

  # ================================================================
  # MAIN LOOP
  # ================================================================

  def tick
    defaults
    input
    calc
    render
  end

  def defaults
    unless audio[:music]
      audio[:music] = {
        input: "sounds/Orbital Colossus.mp3",
        looping: true
      }
    end

    state.music_volume ||= 1.0
    state.player ||= Player.new

    state.player_start ||= {
      x: state.player.x,
      y: state.player.y
    }

    state.game_state ||= :playing
    state.score ||= 0
    state.hp ||= PLAYER_MAX_HP

    state.invuln_timer ||= 0
    state.prompt_timer ||= 0
    state.fade_in ||= 0
    state.bg_scroll ||= 0.0

    state.plasma_balls ||= []
    state.enemy_bullets ||= []
    state.effects ||= []
    state.planets ||= []
    state.meteors ||= []
    state.ufos ||= []

    state.powerups ||= []
    state.powerup_spawn_timer ||= 600
    state.shield_timer ||= 0
    state.speed_timer ||= 0

    state.combo_hits ||= 0
    state.combo_timer ||= 0
    state.combo_awards ||= 0

    start_world(0) if state.world_index.nil?
  end

  # ================================================================
  # WORLD MANAGEMENT
  # ================================================================

  def start_world(index)
    state.world_index = index
    state.bg = resolve_background(world)
    state.bg_scroll = 0.0

    if space_world?
      state.planets = [
        {
          x: 0,
          y: Numeric.rand(-300..300),
          w: 1000,
          h: 1000,
          path: world[:planets].sample,
          speed: 1
        }
      ]
    else
      state.planets = []
    end

    start_wave(1)
  end

  def resolve_background(w)
    if gtk.stat_file(w[:background])
      {
        path: w[:background],
        r: 255, g: 255, b: 255
      }
    else
      tint = w[:bg_fallback_tint] || [255, 255, 255]

      {
        path: BACKGROUND_FALLBACK,
        r: tint[0],
        g: tint[1],
        b: tint[2]
      }
    end
  end

  def wave_cfg
    world[:waves][state.wave]
  end

  def start_wave(n)
    cfg = world[:waves][n]

    state.wave = n
    state.wave_clear_timer = 90
    state.banner_timer = 150

    state.banner_text =
      n == WAVES_PER_WORLD ?
      "WARNING!  BOSS INCOMING" :
      "WAVE #{n}"

    state.banner_sub = n == 1 ? world[:name].upcase : nil

    state.enemy_bullets = []

    state.meteors = cfg[:meteors].times.map do
      spawn_meteor(cfg, true)
    end

    state.ufos = build_ufos(cfg)
    state.boss = nil

    if cfg[:boss]
      bcfg = world[:boss]
      sprite = resolve_boss_sprite(bcfg)

      state.boss_cfg = bcfg
      state.boss_has_sprite = sprite[:ok]
      state.boss = spawn_boss(bcfg, sprite)
    end
  end

  def check_wave_progress
    return if state.wave >= WAVES_PER_WORLD
    return unless state.ufos.empty?

    state.wave_clear_timer -= 1

    if state.wave_clear_timer <= 0
      start_wave(state.wave + 1)
    end
  end

  # ================================================================
  # BACKGROUND
  # ================================================================

  def update_background
    return unless planet_world?

    speed = world[:scroll_speed] || PLANET_SCROLL_SPEED
    state.bg_scroll += speed
    state.bg_scroll %= grid.w
  end

  def render_background
    bg = state.bg

    if planet_world?
      offset = state.bg_scroll

      outputs.sprites << {
        x: -offset, y: 0,
        w: grid.w, h: grid.h,
        path: bg[:path],
        r: bg[:r], g: bg[:g], b: bg[:b]
      }

      outputs.sprites << {
        x: grid.w - offset, y: 0,
        w: grid.w, h: grid.h,
        path: bg[:path],
        r: bg[:r], g: bg[:g], b: bg[:b]
      }
    else
      outputs.sprites << {
        x: 0, y: 0,
        w: grid.w, h: grid.h,
        path: bg[:path],
        r: bg[:r], g: bg[:g], b: bg[:b]
      }
    end
  end

  # ================================================================
  # SPAWNERS
  # ================================================================

  def spawn_meteor(cfg, initial = false)
    size = Numeric.rand(50..150)
    drift = cfg[:meteor_drift]

    {
      x: grid.w + Numeric.rand(0..(initial ? 1500 : 400)),
      y: Numeric.rand(0..(grid.h - size)),
      w: size,
      h: size,
      path: world[:meteor_assets].sample,
      speed: Numeric.rand(cfg[:meteor_speed]),
      vy: Numeric.rand(-drift..drift),
      spin: Numeric.rand(-3..3),
      angle: 0,
      dead: false
    }
  end

  def build_ufos(cfg)
    list = []
    index = 0

    cfg[:ufo_groups].each do |grp|
      grp[:count].times do
        list << spawn_ufo(grp, index)
        index += 1
      end
    end

    list
  end

  def spawn_ufo(grp, index)
    base_y =
      grp[:move] == :circle ?
      Numeric.rand(260..460) :
      Numeric.rand(150..570)

    tint = grp[:tint] || [255, 255, 255]

    {
      x: grid.w + 100 + index * 220,
      y: base_y,

      w: grp[:w] || 100,
      h: grp[:h] || 100,

      path: grp[:path],
      animation_frames: grp[:animation_frames],
      animation_speed: grp[:animation_speed] || 8,

      r: tint[0],
      g: tint[1],
      b: tint[2],

      hp: grp[:hp],
      move: grp[:move],
      shoot: grp[:shoot],

      hover_x: 600 + (index % 3) * 180,
      base_y: base_y,

      amp: grp[:amp] || 100,
      bob: grp[:bob] || 0.03,

      vy: (index.even? ? 1 : -1) * (grp[:speed] || 3.5),
      strafe_speed: grp[:speed] || 3,

      radius: grp[:radius] || 90,
      orbit_speed: grp[:orbit_speed] || 0.03,
      orbit_t: 0.0,

      phase: Numeric.rand(0..360),

      fire_rate: grp[:fire_rate],
      bullet_speed: grp[:bullet_speed],
      bullet_tint: grp[:bullet_tint],

      fire_timer: 60 + Numeric.rand(0..grp[:fire_rate]),
      burst_left: 0,
      burst_timer: 0,

      spin: 0.0,
      angle: 0,
      dead: false
    }
  end

  # ================================================================
  # BOSS SPRITE RESOLUTION
  # ================================================================

  def resolve_boss_sprite(bcfg)
    frames = bcfg[:animation_frames]

    if frames && !frames.empty?
      valid_frames = frames.select do |path|
        gtk.stat_file(path)
      end

      if valid_frames.any?
        return {
          path: valid_frames[0],
          frames: valid_frames,
          tint: bcfg[:tint] || [255, 255, 255],
          ok: true
        }
      end
    end

    if gtk.stat_file(bcfg[:asset])
      return {
        path: bcfg[:asset],
        frames: nil,
        tint: bcfg[:tint] || [255, 255, 255],
        ok: true
      }
    end

    if gtk.stat_file(SPACE_BOSS_ASSET)
      return {
        path: SPACE_BOSS_ASSET,
        frames: nil,
        tint: bcfg[:fallback_tint] || [255, 255, 255],
        ok: true
      }
    end

    {
      path: nil,
      frames: nil,
      tint: [255, 255, 255],
      ok: false
    }
  end

  def spawn_boss(bcfg, sprite)
    {
      x: grid.w + 50,
      y: grid.h / 2 - bcfg[:h] / 2,

      w: bcfg[:w],
      h: bcfg[:h],

      path: sprite[:path],
      animation_frames: sprite[:frames],

      r: sprite[:tint][0],
      g: sprite[:tint][1],
      b: sprite[:tint][2],

      hp: bcfg[:hp],
      max_hp: bcfg[:hp],

      dir: 1,
      fire_timer: 120,
      ring_timer: bcfg[:ring_rate][0],
      sweep_timer: 0,

      flash: 0,
      angle: 0,
      born: Kernel.tick_count
    }
  end

  def refill_meteors
    cfg = wave_cfg

    while state.meteors.length < cfg[:meteors]
      state.meteors << spawn_meteor(cfg)
    end
  end

  # ================================================================
  # ENEMY BULLETS
  # ================================================================

  def fire_enemy_bullet(cx, cy, deg, speed,
                        boss_shot = false, tint = nil,
                        style = nil, custom_size = nil)

    rad = deg * Math::PI / 180

    vx = Math.cos(rad) * speed
    vy = Math.sin(rad) * speed

    if style == :fireball
      size = custom_size || 44

      bullet = {
        x: cx - size / 2,
        y: cy - size / 2,
        w: size,
        h: size,

        vx: vx,
        vy: vy,

        style: :fireball,
        hit_r: size * 0.34,

        dead: false
      }

    elsif boss_shot
      bullet = {
        x: cx - BOSS_BULLET_SIZE / 2,
        y: cy - BOSS_BULLET_SIZE / 2,

        w: BOSS_BULLET_SIZE,
        h: BOSS_BULLET_SIZE,

        vx: vx,
        vy: vy,

        path: BOSS_BULLET_FRAMES[0],
        animated: true,

        angle: deg,
        hit_r: BOSS_BULLET_HIT_R,

        born: Kernel.tick_count,
        dead: false
      }

    else
      bullet = {
        x: cx - 10,
        y: cy - 28,

        w: 20,
        h: 56,

        vx: vx,
        vy: vy,

        path: ENEMY_BULLET_ASSET,
        angle: deg - 90,

        hit_r: 10,
        dead: false
      }
    end

    if tint
      bullet[:r] = tint[0]
      bullet[:g] = tint[1]
      bullet[:b] = tint[2]
    end

    state.enemy_bullets << bullet
  end

  # ================================================================
  # PLAYER SHOOTING / COMBO SYSTEM
  # ================================================================

  def fire_player_shot
    player = state.player

    # Combo rewards are unlocked at 5 and 10 hits.
    # They are not consumed until the next shot is fired.
    if state.combo_hits >= SUPER_SHOT_THRESHOLD
      shot_type = :super
      damage = SUPER_SHOT_DAMAGE
      state.combo_hits = 0

    elsif state.combo_hits >= POWER_SHOT_THRESHOLD &&
          state.combo_awards < 1

      shot_type = :power
      damage = POWER_SHOT_DAMAGE
      state.combo_awards = 1

    else
      shot_type = :normal
      damage = 1
    end

    if shot_type == :super
      state.combo_awards = 0
    end

    sprite =
      case shot_type
      when :power then POWER_SHOT_SPRITE
      when :super then SUPER_SHOT_SPRITE
      else PLASMA_ASSET
      end

    # The built-in visual effects still work without special PNGs.
    has_custom_sprite = gtk.stat_file(sprite)
    sprite = PLASMA_ASSET unless has_custom_sprite

    size =
      case shot_type
      when :super then [54, 110]
      when :power then [38, 90]
      else [24, 70]
      end

    state.plasma_balls << {
      x: player.x + player.w - 4,
      y: player.y + player.h / 2 - size[1] / 2,

      w: size[0],
      h: size[1],

      path: sprite,
      angle: -90,

      damage: damage,
      shot_type: shot_type,

      dead: false
    }
  end

  def register_successful_hit
    state.combo_hits += 1
    state.combo_timer = COMBO_TIMEOUT
  end

  def reset_combo
    state.combo_hits = 0
    state.combo_timer = 0
    state.combo_awards = 0
  end

  def update_combo
    if state.combo_timer > 0
      state.combo_timer -= 1
      reset_combo if state.combo_timer <= 0
    end
  end

  # ================================================================
  # INPUT
  # ================================================================

  def input
    kb = inputs.keyboard

    if kb.key_down.m
      state.music_paused = !state.music_paused
      apply_music
    end

    if kb.key_down.hyphen
      state.music_volume = [state.music_volume - 0.1, 0.0].max
      apply_music
    end

    if kb.key_down.equal_sign
      state.music_volume = [state.music_volume + 0.1, 1.0].min
      apply_music
    end

    if state.game_state == :world_clear
      if state.prompt_timer <= 0
        if kb.key_down.enter
          planet_world? ? begin_ascent : begin_descent
        end

        gtk.reset_next_tick if kb.key_down.space
      end

      return
    end

    return if state.game_state == :descending ||
              state.game_state == :ascending

    if state.game_state != :playing
      if kb.key_down.space && state.prompt_timer <= 0
        gtk.reset_next_tick
      end

      return
    end

    player = state.player

    speed = player.speed
    speed *= SPEED_MULTIPLIER if state.speed_timer > 0

    player.x += inputs.left_right * speed
    player.y += inputs.up_down * speed

    player.flip_horizontally = false if inputs.left_right > 0

    player.x = clamp_val(player.x, 0, grid.w - player.w)
    player.y = clamp_val(player.y, 0, grid.h - player.h)

    fire_player_shot if kb.key_down.space
  end

  def apply_music
    return unless audio[:music]

    audio[:music][:gain] =
      state.music_paused ? 0.0 : state.music_volume
  end

  # ================================================================
  # MAIN UPDATE
  # ================================================================

  def calc
    update_effects

    state.prompt_timer -= 1 if state.prompt_timer > 0
    state.fade_in -= 1 if state.fade_in > 0

    if state.game_state == :descending
      update_planets
      update_descent
      return
    end

    if state.game_state == :ascending
      update_background
      update_ascent
      return
    end

    return unless state.game_state == :playing

    state.banner_timer -= 1 if state.banner_timer > 0
    state.invuln_timer -= 1 if state.invuln_timer > 0

    update_background
    update_planets
    update_plasma
    update_combo
    update_powerups
    update_powerup_timers
    update_meteors
    update_ufos
    update_boss
    update_enemy_bullets

    check_powerup_hits
    check_plasma_hits
    check_player_hits
    check_boss_dead

    return unless state.game_state == :playing

    state.plasma_balls.reject! do |p|
      if !p.dead && p.x > grid.w
        reset_combo
        true
      else
        p.dead
      end
    end

    state.meteors.reject! do |m|
      m.dead || m.x + m.w < -50
    end

    state.ufos.reject! { |u| u.dead }
    state.enemy_bullets.reject! { |b| b.dead }

    refill_meteors
    check_wave_progress
  end

  def update_planets
    state.planets.each do |planet|
      planet.x -= planet.speed

      if planet.x + planet.w < 0
        planet.x = grid.w
        planet.y = Numeric.rand(-200..200)
        planet.path = world[:planets].sample
      end
    end
  end

  def update_plasma
    state.plasma_balls.each do |p|
      p.x += PLASMA_SPEED
    end
  end

  def update_meteors
    state.meteors.each do |m|
      m.x -= m.speed
      m.y += m.vy
      m.angle += m.spin

      if m.y < 0 || m.y + m.h > grid.h
        m.vy *= -1
        m.y = clamp_val(m.y, 0, grid.h - m.h)
      end
    end
  end

  # ================================================================
  # POWER-UPS
  # ================================================================

  def spawn_powerup
    type = [:shield, :repair, :speed].sample

    state.powerups << {
      x: grid.w + 50,
      y: Numeric.rand(100..(grid.h - 150)),

      w: POWERUP_SIZE,
      h: POWERUP_SIZE,

      type: type,
      base_y: nil,
      phase: Numeric.rand(0..360),

      dead: false
    }
  end

  def update_powerups
    state.powerup_spawn_timer -= 1

    if state.powerup_spawn_timer <= 0
      spawn_powerup

      state.powerup_spawn_timer =
        Numeric.rand(POWERUP_SPAWN_MIN..POWERUP_SPAWN_MAX)
    end

    state.powerups.each do |p|
      p.base_y ||= p.y

      p.x -= POWERUP_SPEED

      p.y = p.base_y +
            Math.sin((Kernel.tick_count + p.phase) * 0.035) * 20

      p.dead = true if p.x + p.w < 0
    end

    state.powerups.reject! { |p| p.dead }
  end

  def update_powerup_timers
    state.shield_timer -= 1 if state.shield_timer > 0
    state.speed_timer -= 1 if state.speed_timer > 0
  end

  def check_powerup_hits
    state.plasma_balls.each do |plasma|
      next if plasma.dead

      state.powerups.each do |powerup|
        next if powerup.dead

        if hit?(plasma_hitbox(plasma), powerup)
          plasma.dead = true
          powerup.dead = true

          activate_powerup(powerup.type)
          break
        end
      end
    end

    state.powerups.reject! { |p| p.dead }
  end

  def activate_powerup(type)
    case type

    when :shield
      state.shield_timer = SHIELD_DURATION

    when :repair
      if state.hp < PLAYER_MAX_HP
        state.hp += 1
      else
        state.score += 250
      end

    when :speed
      state.speed_timer = SPEED_DURATION
    end
  end

  # ================================================================
  # UFO MOVEMENT AND ANIMATION
  # ================================================================

  def update_ufos
    state.ufos.each do |ufo|
      update_ufo_animation(ufo)
      move_ufo(ufo)
      shoot_ufo(ufo)
    end
  end

  def update_ufo_animation(ufo)
    frames = ufo.animation_frames
    return unless frames && !frames.empty?

    speed = [ufo.animation_speed, 1].max

    frame = (
      (Kernel.tick_count + ufo.phase) / speed
    ) % frames.length

    ufo.path = frames[frame]
  end

  def move_ufo(ufo)
    case ufo.move

    when :zigzag
      if ufo.x > ufo.hover_x
        ufo.x -= UFO_ENTRY_SPEED
      else
        ufo.y += ufo.vy

        if ufo.y <= 20
          ufo.y = 20
          ufo.vy = ufo.vy.abs

        elsif ufo.y + ufo.h >= grid.h - 20
          ufo.y = grid.h - 20 - ufo.h
          ufo.vy = -ufo.vy.abs
        end
      end

    when :circle
      if ufo.x > ufo.hover_x + ufo.radius
        ufo.x -= UFO_ENTRY_SPEED
      else
        ufo.orbit_t += ufo.orbit_speed

        ufo.x = ufo.hover_x +
                Math.cos(ufo.orbit_t) * ufo.radius

        ufo.y = ufo.base_y +
                Math.sin(ufo.orbit_t) * ufo.radius
      end

    when :strafe
      if ufo.x > ufo.hover_x
        ufo.x -= UFO_ENTRY_SPEED
      else
        target =
          (state.player.y + state.player.h / 2) - ufo.h / 2

        ufo.y += clamp_val(
          target - ufo.y,
          -ufo.strafe_speed,
          ufo.strafe_speed
        )

        ufo.y = clamp_val(ufo.y, 0, grid.h - ufo.h)
      end

    else
      ufo.x -= UFO_ENTRY_SPEED if ufo.x > ufo.hover_x

      t = (Kernel.tick_count + ufo.phase) * ufo.bob

      ufo.y = clamp_val(
        ufo.base_y + Math.sin(t) * ufo.amp,
        0,
        grid.h - ufo.h
      )
    end
  end

  def shoot_ufo(ufo)
    return if ufo.x > grid.w - ufo.w

    cx = ufo.x + 10
    cy = ufo.y + ufo.h / 2

    if ufo.burst_left > 0
      ufo.burst_timer -= 1

      if ufo.burst_timer <= 0
        fire_enemy_bullet(
          cx, cy,
          angle_to_player(cx, cy),
          ufo.bullet_speed,
          false,
          ufo.bullet_tint
        )

        ufo.burst_left -= 1
        ufo.burst_timer = 8
      end
    end

    ufo.fire_timer -= 1
    return if ufo.fire_timer > 0

    ufo_fire(ufo, cx, cy)

    ufo.fire_timer =
      if ufo.shoot == :sweep
        ufo.fire_rate
      else
        ufo.fire_rate + Numeric.rand(0..40)
      end
  end

  def ufo_fire(ufo, cx, cy)
    spd = ufo.bullet_speed
    tint = ufo.bullet_tint

    case ufo.shoot

    when :aimed
      fire_enemy_bullet(
        cx, cy, angle_to_player(cx, cy),
        spd, false, tint
      )

    when :spread3
      base = angle_to_player(cx, cy)

      [-12, 0, 12].each do |off|
        fire_enemy_bullet(
          cx, cy, base + off, spd, false, tint
        )
      end

    when :fan
      [-40, -20, 0, 20, 40].each do |off|
        fire_enemy_bullet(
          cx, cy, 180 + off, spd, false, tint
        )
      end

    when :burst
      fire_enemy_bullet(
        cx, cy, angle_to_player(cx, cy),
        spd, false, tint
      )

      ufo.burst_left = 2
      ufo.burst_timer = 8

    when :ring
      12.times do |i|
        fire_enemy_bullet(
          cx, cy, ufo.spin + i * 30,
          spd, false, tint
        )
      end

      ufo.spin += 15

    when :sweep
      fire_enemy_bullet(
        cx, cy,
        180 + Math.sin(ufo.spin) * 60,
        spd, false, tint
      )

      ufo.spin += 0.3

    else
      fire_enemy_bullet(
        cx, cy, 180, spd, false, tint
      )
    end
  end

  # ================================================================
  # BOSS SYSTEM
  # ================================================================

  def update_boss
    boss = state.boss
    return unless boss

    cfg = state.boss_cfg

    boss.flash -= 1 if boss.flash > 0

    # Animate only verified existing frames.
    frames = boss.animation_frames

    if frames && !frames.empty?
      speed = [cfg[:animation_speed] || 8, 1].max

      frame = (
        (Kernel.tick_count - boss.born) / speed
      ) % frames.length

      boss.path = frames[frame]
    end

    if boss.x > grid.w - boss.w - 30
      boss.x -= 2
      return
    end

    phase = boss_phase(boss)
    i = phase - 1

    boss.y += boss.dir *
              cfg[:move_speed][i] *
              BOSS_MOVE_SPEED_MULT

    if boss.y <= 0
      boss.y = 0
      boss.dir = 1

    elsif boss.y + boss.h >= grid.h
      boss.y = grid.h - boss.h
      boss.dir = -1
    end

    if cfg[:type] == :dragon
      update_dragon_attacks(boss, cfg, phase, i)
    else
      update_spaceship_boss_attacks(boss, cfg, phase, i)
    end
  end

  def boss_phase(boss)
    ratio = boss.hp.to_f / boss.max_hp

    if ratio > 0.66
      1
    elsif ratio > 0.33
      2
    else
      3
    end
  end

  # ================================================================
  # SPACESHIP BOSS ATTACKS
  # ================================================================

  def update_spaceship_boss_attacks(boss, cfg, phase, i)
    cx = boss.x + 60
    cy = boss.y + boss.h / 2

    boss.fire_timer -= 1

    if boss.fire_timer <= 0
      base = angle_to_player(cx, cy)

      offsets =
        case phase
        when 1 then [0]
        when 2 then [-16, 0, 16]
        else [-25, -12, 0, 12, 25]
        end

      speed =
        cfg[:bullet_speed][i] * BOSS_BULLET_SPEED_MULT

      offsets.each do |off|
        fire_enemy_bullet(
          cx, cy, base + off, speed, true
        )
      end

      boss.fire_timer = (
        cfg[:fire_rate][i] * BOSS_FIRE_RATE_MULT
      ).to_i
    end

    if phase >= 2
      boss.ring_timer -= 1

      if boss.ring_timer <= 0
        step = cfg[:ring_step][phase - 2]
        angle = 110

        while angle <= 250
          fire_enemy_bullet(cx, cy, angle, 3.5, true)
          angle += step
        end

        boss.ring_timer = (
          cfg[:ring_rate][phase - 2] *
          BOSS_RING_RATE_MULT
        ).to_i
      end
    end

    if phase >= 3 && cfg[:sweep]
      boss.sweep_timer -= 1

      if boss.sweep_timer <= 0
        deg = 180 + Math.sin(Kernel.tick_count * 0.04) * 45

        fire_enemy_bullet(cx, cy, deg, 4, true)
        boss.sweep_timer = 16
      end
    end
  end

  # ================================================================
  # DRAGON BOSS ATTACKS
  # ================================================================

  def update_dragon_attacks(boss, cfg, phase, i)
    cx = boss.x + boss.w * 0.18
    cy = boss.y + boss.h * 0.48

    boss.fire_timer -= 1

    if boss.fire_timer <= 0
      base = angle_to_player(cx, cy)

      offsets =
        case phase
        when 1 then [0]
        when 2 then [-18, 0, 18]
        else [-25, 0, 25]
        end

      speed =
        cfg[:bullet_speed][i] * BOSS_BULLET_SPEED_MULT

      offsets.each do |off|
        fire_enemy_bullet(
          cx, cy, base + off, speed,
          false, cfg[:fireball_color],
          :fireball, cfg[:fireball_size]
        )
      end

      boss.fire_timer = (
        cfg[:fire_rate][i] * BOSS_FIRE_RATE_MULT
      ).to_i
    end

    if phase >= 2
      boss.ring_timer -= 1

      if boss.ring_timer <= 0
        [-35, 0, 35].each do |off|
          fire_enemy_bullet(
            cx, cy, 180 + off, 3.5,
            false, cfg[:fireball_color],
            :fireball, 36
          )
        end

        boss.ring_timer = (
          cfg[:ring_rate][phase - 2] *
          BOSS_RING_RATE_MULT
        ).to_i
      end
    end

    if phase >= 3 && cfg[:sweep]
      boss.sweep_timer -= 1

      if boss.sweep_timer <= 0
        deg = 180 + Math.sin(Kernel.tick_count * 0.035) * 40

        fire_enemy_bullet(
          cx, cy, deg, 4,
          false, cfg[:fireball_color],
          :fireball, 30
        )

        boss.sweep_timer = 18
      end
    end
  end

  # ================================================================
  # EFFECTS AND BULLETS
  # ================================================================

  def spawn_hit_effect(cx, cy)
    state.effects << {
      x: cx - HIT_EFFECT_SIZE / 2,
      y: cy - HIT_EFFECT_SIZE / 2,
      w: HIT_EFFECT_SIZE,
      h: HIT_EFFECT_SIZE,
      path: BOSS_HIT_FRAMES[0],
      born: Kernel.tick_count,
      dead: false
    }
  end

  def update_effects
    state.effects.each do |fx|
      frame = (
        Kernel.tick_count - fx.born
      ) / HIT_EFFECT_ANIM_SPEED

      if frame >= BOSS_HIT_FRAMES.length
        fx.dead = true
      else
        fx.path = BOSS_HIT_FRAMES[frame]
      end
    end

    state.effects.reject! { |fx| fx.dead }
  end

  def update_enemy_bullets
    state.enemy_bullets.each do |b|
      b.x += b.vx
      b.y += b.vy

      if b.animated
        frame = (
          (Kernel.tick_count - b.born) /
          BOSS_BULLET_ANIM_SPEED
        ) % BOSS_BULLET_FRAMES.length

        b.path = BOSS_BULLET_FRAMES[frame]
      end

      if b.x < -100 ||
         b.x > grid.w + 100 ||
         b.y < -100 ||
         b.y > grid.h + 100
        b.dead = true
      end
    end
  end

  # ================================================================
  # COLLISIONS
  # ================================================================

  def check_plasma_hits
    boss = state.boss

    state.plasma_balls.each do |plasma|
      next if plasma.dead

      box = plasma_hitbox(plasma)
      damage = plasma[:damage] || 1

      state.meteors.each do |m|
        next if plasma.dead || m.dead

        if hit?(box, shrink(m, 0.12))
          plasma.dead = true
          m.dead = true
          state.score += 10
          register_successful_hit
        end
      end

      state.ufos.each do |ufo|
        next if plasma.dead || ufo.dead

        if hit?(box, ufo)
          plasma.dead = true
          ufo.hp -= damage

          register_successful_hit

          if ufo.hp <= 0
            ufo.dead = true
            state.score += 100
          end
        end
      end

      if boss &&
         !plasma.dead &&
         boss.x < grid.w &&
         hit?(box, shrink(boss, 0.18))

        plasma.dead = true
        boss.hp -= damage
        boss.flash = 4

        state.score += 5 * damage

        register_successful_hit
      end
    end
  end

  def check_player_hits
    hurt = player_hitbox

    state.meteors.each do |m|
      next if m.dead

      if hit?(hurt, shrink(m, 0.15))
        m.dead = true
        damage_player
      end
    end

    state.enemy_bullets.each do |b|
      next if b.dead

      if hit?(hurt, bullet_hitbox(b))
        b.dead = true

        if b.animated
          spawn_hit_effect(
            b.x + b.w / 2,
            b.y + b.h / 2
          )
        end

        damage_player
      end
    end

    boss = state.boss

    if boss && hit?(hurt, shrink(boss, 0.18))
      damage_player
    end
  end

  def check_boss_dead
    boss = state.boss
    return unless boss && boss.hp <= 0

    state.score += 1000

    state.boss = nil
    state.enemy_bullets = []
    state.plasma_balls = []
    state.meteors = []
    state.ufos = []

    state.prompt_timer = PROMPT_DELAY

    if !LOOP_WORLDS && last_world?
      state.game_state = :victory
    else
      state.game_state = :world_clear
    end
  end

  def damage_player
    return unless state.game_state == :playing
    return if state.shield_timer > 0
    return if state.invuln_timer > 0

    state.hp -= 1
    state.invuln_timer = INVULN_TICKS

    reset_combo

    if state.hp <= 0
      state.game_state = :game_over
      state.prompt_timer = PROMPT_DELAY
    end
  end

  # ================================================================
  # DESCENT
  # ================================================================

  def begin_descent
    player = state.player
    destination = next_world

    state.invuln_timer = 0
    state.enemy_bullets = []

    state.descent = {
      t: 0,
      planet_path: destination[:landing_planet],

      pcx: grid.w + 50 + DESCENT_PLANET_SIZE / 2,
      pcy: grid.h / 2,

      zoom: 1.0,
      dive: 0.0,
      flash: 0.0,

      ship_start_cx: player.x + player.w / 2,
      ship_start_cy: player.y + player.h / 2,

      ship_w: player.w,
      ship_h: player.h
    }

    state.game_state = :descending
  end

  def update_descent
    d = state.descent
    d.t += 1
    t = d.t

    player = state.player

    slide = ease_out(
      clamp01(t / DESCENT_SLIDE_TICKS.to_f)
    )

    start_cx = grid.w + 50 + DESCENT_PLANET_SIZE / 2
    end_cx = grid.w - DESCENT_PLANET_SIZE / 2 - 120

    d.pcx = lerp(start_cx, end_cx, slide)
    d.pcy = grid.h / 2

    dive = ease_in_out(
      clamp01(
        (t - DESCENT_DIVE_START) /
        (DESCENT_DIVE_END - DESCENT_DIVE_START).to_f
      )
    )

    d.dive = dive
    d.zoom = 1.0 + 0.45 * dive

    stage = ease_out(
      clamp01(t / DESCENT_DIVE_START.to_f)
    )

    sx = lerp(d.ship_start_cx, 380, stage)
    sy = lerp(d.ship_start_cy, grid.h / 2, stage)

    cx = lerp(sx, d.pcx, dive)
    cy = lerp(sy, d.pcy, dive)

    scale = 1.0 - 0.93 * dive

    player.w = d.ship_w * scale
    player.h = d.ship_h * scale

    player.x = cx - player.w / 2
    player.y = cy - player.h / 2

    d.flash = clamp01(
      (t - DESCENT_DIVE_END) /
      (DESCENT_TOTAL - DESCENT_DIVE_END).to_f
    )

    finish_descent if t >= DESCENT_TOTAL
  end

  def finish_descent
    d = state.descent
    player = state.player

    player.w = d.ship_w
    player.h = d.ship_h

    player.x = state.player_start[:x]
    player.y = state.player_start[:y]

    state.descent = nil

    finish_world_transition
  end

  # ================================================================
  # ASCENT
  # ================================================================

  def begin_ascent
    player = state.player

    state.enemy_bullets = []
    state.plasma_balls = []
    state.invuln_timer = 0

    state.ascent = {
      t: 0,

      ship_start_cx: player.x + player.w / 2,
      ship_start_cy: player.y + player.h / 2,

      ship_w: player.w,
      ship_h: player.h,

      flash: 0.0
    }

    state.game_state = :ascending
  end

  def update_ascent
    a = state.ascent
    a.t += 1

    player = state.player

    progress = ease_in_out(
      clamp01(a.t / ASCENT_FLY_END.to_f)
    )

    target_x = grid.w + 150
    target_y = grid.h + 100

    cx = lerp(a.ship_start_cx, target_x, progress)
    cy = lerp(a.ship_start_cy, target_y, progress)

    scale = 1.0 - 0.65 * progress

    player.w = a.ship_w * scale
    player.h = a.ship_h * scale

    player.x = cx - player.w / 2
    player.y = cy - player.h / 2

    flash_start = ASCENT_FLY_END - 20

    a.flash = clamp01(
      (a.t - flash_start) /
      (ASCENT_TOTAL - flash_start).to_f
    )

    finish_ascent if a.t >= ASCENT_TOTAL
  end

  def finish_ascent
    a = state.ascent
    player = state.player

    player.w = a.ship_w
    player.h = a.ship_h

    player.x = state.player_start[:x]
    player.y = state.player_start[:y]

    state.ascent = nil

    finish_world_transition
  end

  def finish_world_transition
    state.plasma_balls = []
    state.enemy_bullets = []

    state.powerups = []
    state.powerup_spawn_timer = 450

    state.shield_timer = 0
    state.speed_timer = 0

    reset_combo

    state.hp = PLAYER_MAX_HP if HEAL_ON_NEW_WORLD

    state.invuln_timer = INVULN_TICKS
    state.fade_in = FADE_IN_TICKS
    state.game_state = :playing

    start_world(next_world_index)
  end

  # ================================================================
  # HELPERS
  # ================================================================

  def hit?(a, b)
    args.geometry.intersect_rect?(a, b)
  end

  def clamp_val(v, lo, hi)
    [[v, lo].max, hi].min
  end

  def clamp01(v)
    v < 0 ? 0.0 : (v > 1 ? 1.0 : v)
  end

  def lerp(a, b, t)
    a + (b - a) * t
  end

  def ease_out(t)
    1.0 - (1.0 - t) * (1.0 - t)
  end

  def ease_in_out(t)
    if t < 0.5
      2.0 * t * t
    else
      1.0 - ((-2.0 * t + 2.0) ** 2) / 2.0
    end
  end

  def shrink(r, pct)
    {
      x: r.x + r.w * pct,
      y: r.y + r.h * pct,
      w: r.w * (1 - 2 * pct),
      h: r.h * (1 - 2 * pct)
    }
  end

  def player_hitbox
    shrink(state.player, 0.2)
  end

  def plasma_hitbox(p)
    cx = p.x + p.w / 2
    cy = p.y + p.h / 2

    {
      x: cx - p.h / 2,
      y: cy - p.w / 2,
      w: p.h,
      h: p.w
    }
  end

  def bullet_hitbox(b)
    cx = b.x + b.w / 2
    cy = b.y + b.h / 2

    {
      x: cx - b.hit_r,
      y: cy - b.hit_r,
      w: b.hit_r * 2,
      h: b.hit_r * 2
    }
  end

  def angle_to_player(cx, cy)
    p = state.player

    dx = (p.x + p.w / 2) - cx
    dy = (p.y + p.h / 2) - cy

    Math.atan2(dy, dx) * 180 / Math::PI
  end

  # ================================================================
  # RENDER
  # ================================================================

  def render
    render_background

    outputs.sprites << state.planets
    render_descent_planet

    outputs.sprites << state.meteors
    outputs.sprites << state.ufos

    render_boss

    render_player_shots
    render_enemy_bullets

    outputs.sprites << state.effects

    render_powerups if state.game_state == :playing

    blink =
      state.invuln_timer > 0 &&
      Kernel.tick_count % 8 < 4

    unless blink || state.game_state == :game_over
      outputs.sprites << state.player
    end

    render_descent_fx
    render_ascent_fx

    render_hud
    render_active_powerups if state.game_state == :playing

    render_banner
    render_overlay
    render_fade_in
  end

  # ================================================================
  # PLAYER PROJECTILE EFFECTS
  # ================================================================

  def render_player_shots
    state.plasma_balls.each do |p|
      if p.shot_type == :power || p.shot_type == :super
        render_special_shot_glow(p)
      end

      outputs.sprites << p
    end
  end

  def render_special_shot_glow(p)
    if p.shot_type == :super
      color = [190, 80, 255]
      expansion = 24
    else
      color = [60, 200, 255]
      expansion = 12
    end

    outputs.solids << {
      x: p.x - expansion,
      y: p.y - expansion,

      w: p.w + expansion * 2,
      h: p.h + expansion * 2,

      r: color[0],
      g: color[1],
      b: color[2],
      a: 65
    }
  end

  # ================================================================
  # BOSS RENDERING
  # ================================================================

  def render_boss
    boss = state.boss
    return unless boss

    flashing = boss.flash > 0

    if state.boss_has_sprite && boss.path
      outputs.sprites << {
        x: boss.x,
        y: boss.y,
        w: boss.w,
        h: boss.h,

        path: boss.path,

        r: boss.r,
        g: flashing ? 120 : boss.g,
        b: flashing ? 120 : boss.b,

        angle: boss.angle
      }
    else
      outputs.solids << {
        x: boss.x,
        y: boss.y,
        w: boss.w,
        h: boss.h,

        r: flashing ? 255 : 150,
        g: 30,
        b: 60
      }

      outputs.labels << {
        x: boss.x + boss.w / 2,
        y: boss.y + boss.h / 2,

        text: "BOSS SPRITE MISSING",

        size_px: 26,
        anchor_x: 0.5,
        anchor_y: 0.5,

        r: 255, g: 255, b: 255
      }
    end
  end

  # ================================================================
  # ENEMY BULLET RENDERING
  # ================================================================

  def render_enemy_bullets
    state.enemy_bullets.each do |b|
      if b.style == :fireball
        render_fireball(b)
      else
        outputs.sprites << b
      end
    end
  end

  def render_fireball(b)
    outputs.solids << {
      x: b.x - 6,
      y: b.y - 6,
      w: b.w + 12,
      h: b.h + 12,

      r: 255, g: 90, b: 20, a: 70
    }

    outputs.solids << {
      x: b.x, y: b.y,
      w: b.w, h: b.h,

      r: 255, g: 110, b: 25
    }

    outputs.solids << {
      x: b.x + b.w * 0.25,
      y: b.y + b.h * 0.25,

      w: b.w * 0.5,
      h: b.h * 0.5,

      r: 255, g: 220, b: 70
    }
  end

  # ================================================================
  # POWER-UP SPRITE RENDERING
  # ================================================================

  def render_powerups
    state.powerups.each do |p|
      sprite = POWERUP_SPRITES[p.type]

      if sprite && gtk.stat_file(sprite)
        outputs.sprites << {
          x: p.x,
          y: p.y,
          w: p.w,
          h: p.h,
          path: sprite
        }

      elsif gtk.stat_file(POWERUP_FALLBACK)
        outputs.sprites << {
          x: p.x,
          y: p.y,
          w: p.w,
          h: p.h,
          path: POWERUP_FALLBACK
        }

      else
        color =
          case p.type
          when :shield then [60, 180, 255]
          when :repair then [255, 70, 100]
          else [255, 210, 50]
          end

        outputs.solids << {
          x: p.x,
          y: p.y,
          w: p.w,
          h: p.h,
          r: color[0],
          g: color[1],
          b: color[2]
        }
      end
    end
  end

  def render_active_powerups
    if state.shield_timer > 0
      p = state.player

      outputs.solids << {
        x: p.x - 10,
        y: p.y - 10,

        w: p.w + 20,
        h: p.h + 20,

        r: 60, g: 180, b: 255, a: 65
      }

      outputs.labels << {
        x: 40,
        y: grid.h - 195,

        text: "SHIELD: #{(state.shield_timer / 60.0).ceil}s",

        size_px: 20,
        r: 100, g: 210, b: 255
      }
    end

    if state.speed_timer > 0
      outputs.labels << {
        x: 40,
        y: grid.h - 225,

        text: "SPEED: #{(state.speed_timer / 60.0).ceil}s",

        size_px: 20,
        r: 255, g: 220, b: 70
      }
    end
  end

  # ================================================================
  # TRANSITION RENDERING
  # ================================================================

  def render_descent_planet
    d = state.descent
    return unless d

    size = DESCENT_PLANET_SIZE * d.zoom

    outputs.sprites << {
      x: d.pcx - size / 2,
      y: d.pcy - size / 2,

      w: size,
      h: size,

      path: d.planet_path
    }
  end

  def render_descent_fx
    d = state.descent
    return unless d

    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,

      r: 255, g: 140, b: 40,
      a: (110 * d.dive).to_i
    }

    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,

      r: 255, g: 255, b: 255,
      a: (255 * d.flash).to_i
    }
  end

  def render_ascent_fx
    a = state.ascent
    return unless a

    glow = clamp01(a.t / ASCENT_FLY_END.to_f)

    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,

      r: 100, g: 180, b: 255,
      a: (75 * glow).to_i
    }

    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,

      r: 255, g: 255, b: 255,
      a: (255 * a.flash).to_i
    }
  end

  def render_fade_in
    return unless state.fade_in > 0

    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,

      r: 255, g: 255, b: 255,

      a: (
        255 * state.fade_in / FADE_IN_TICKS.to_f
      ).to_i
    }
  end

  # ================================================================
  # HEALTH BARS AND HUD
  # ================================================================

  def render_hud
    return if state.game_state == :descending ||
              state.game_state == :ascending

    outputs.labels << {
      x: 40,
      y: grid.h - 38,

      text: "#{world[:name]}  -  Wave #{state.wave}/#{WAVES_PER_WORLD}",

      size_px: 25,
      r: 255, g: 255, b: 255
    }

    outputs.labels << {
      x: 40,
      y: grid.h - 72,

      text: "Score: #{state.score}",

      size_px: 22,
      r: 255, g: 255, b: 255
    }

    # Player health bar
    health_ratio = clamp01(
      state.hp.to_f / PLAYER_MAX_HP
    )

    outputs.labels << {
      x: 40,
      y: grid.h - 106,
      text: "PLAYER HP",
      size_px: 19,
      r: 255, g: 255, b: 255
    }

    outputs.solids << {
      x: 40,
      y: grid.h - 135,
      w: 240,
      h: 18,
      r: 45, g: 45, b: 55
    }

    outputs.solids << {
      x: 40,
      y: grid.h - 135,
      w: 240 * health_ratio,
      h: 18,
      r: 60, g: 220, b: 100
    }

    PLAYER_MAX_HP.times do |i|
      color = i < state.hp ? [220, 45, 55] : [70, 70, 70]

      outputs.solids << {
        x: 40 + i * 32,
        y: grid.h - 162,
        w: 25,
        h: 15,
        r: color[0],
        g: color[1],
        b: color[2]
      }
    end

    # Combo meter
    combo_ratio = clamp01(
      state.combo_hits.to_f / SUPER_SHOT_THRESHOLD
    )

    outputs.labels << {
      x: 320,
      y: grid.h - 105,
      text: "COMBO: #{state.combo_hits}/10",
      size_px: 20,
      r: 255, g: 255, b: 255
    }

    outputs.solids << {
      x: 320,
      y: grid.h - 135,
      w: 220,
      h: 18,
      r: 45, g: 45, b: 55
    }

    outputs.solids << {
      x: 320,
      y: grid.h - 135,
      w: 220 * combo_ratio,
      h: 18,
      r: 100, g: 170, b: 255
    }

    if state.combo_hits >= SUPER_SHOT_THRESHOLD
      combo_text = "SUPER SHOT READY!"
      combo_color = [220, 120, 255]

    elsif state.combo_hits >= POWER_SHOT_THRESHOLD &&
          state.combo_awards == 0

      combo_text = "POWER SHOT READY!"
      combo_color = [100, 220, 255]

    else
      combo_text = nil
    end

    if combo_text
      outputs.labels << {
        x: 320,
        y: grid.h - 165,
        text: combo_text,
        size_px: 20,
        r: combo_color[0],
        g: combo_color[1],
        b: combo_color[2]
      }
    end

    # Boss health bar
    boss = state.boss

    if boss
      ratio = clamp01(
        boss.hp.to_f / boss.max_hp
      )

      outputs.labels << {
        x: 600,
        y: grid.h - 40,

        text: "#{world[:name].upcase} BOSS",

        size_px: 24,
        r: 255, g: 255, b: 255
      }

      outputs.solids << {
        x: 600,
        y: grid.h - 75,
        w: 600,
        h: 24,
        r: 45, g: 45, b: 55
      }

      outputs.solids << {
        x: 600,
        y: grid.h - 75,
        w: 600 * ratio,
        h: 24,
        r: 230, g: 55, b: 65
      }

      outputs.labels << {
        x: 900,
        y: grid.h - 82,
        text: "#{[boss.hp, 0].max} / #{boss.max_hp}",
        size_px: 17,
        anchor_x: 0.5,
        r: 255, g: 255, b: 255
      }
    end

    if state.wave < WAVES_PER_WORLD &&
       state.ufos.empty? &&
       state.game_state == :playing

      outputs.labels << {
        x: grid.w / 2,
        y: grid.h / 2,

        text: "WAVE CLEAR!",
        size_px: 60,

        anchor_x: 0.5,
        anchor_y: 0.5,

        r: 255, g: 255, b: 120
      }
    end
  end

  def render_banner
    return unless state.banner_timer > 0 &&
                  state.game_state == :playing

    a = [[state.banner_timer * 4, 255].min, 0].max
    red = state.wave == WAVES_PER_WORLD ? 80 : 255

    outputs.labels << {
      x: grid.w / 2,
      y: grid.h / 2 + 140,

      text: state.banner_text,
      size_px: 72,

      anchor_x: 0.5,
      anchor_y: 0.5,

      r: 255, g: red, b: red, a: a
    }

    if state.banner_sub
      outputs.labels << {
        x: grid.w / 2,
        y: grid.h / 2 + 80,

        text: state.banner_sub,
        size_px: 40,

        anchor_x: 0.5,
        anchor_y: 0.5,

        r: 200, g: 220, b: 255, a: a
      }
    end
  end

  # ================================================================
  # END SCREENS
  # ================================================================

  def render_overlay
    return if state.game_state == :playing ||
              state.game_state == :descending ||
              state.game_state == :ascending

    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,
      r: 0, g: 0, b: 0, a: 140
    }

    if state.game_state == :world_clear
      transition_text =
        if planet_world?
          "Press ENTER to ascend into space"
        else
          "Press ENTER to descend to the next planet"
        end

      lines = [
        ["#{world[:name].upcase} CLEARED!", 80, 60],
        ["Score: #{state.score}", 36, -10],
        [transition_text, 36, -70],
        ["Press SPACE to restart", 28, -120]
      ]
    else
      title =
        state.game_state == :victory ?
        "YOU WIN!" :
        "GAME OVER"

      lines = [
        [title, 90, 60],
        ["Score: #{state.score}", 36, -10],
        ["Press SPACE to restart", 36, -70]
      ]
    end

    lines.each do |text, size, dy|
      outputs.labels << {
        x: grid.w / 2,
        y: grid.h / 2 + dy,

        text: text,
        size_px: size,

        anchor_x: 0.5,
        anchor_y: 0.5,

        r: 255, g: 255, b: 255
      }
    end
  end
end

# ================================================================
# DRAGONRUBY ENTRY POINTS
# ================================================================

def tick(args)
  $game ||= Game.new
  $game.args = args
  $game.tick
end

def reset(args)
  $game = nil
end
