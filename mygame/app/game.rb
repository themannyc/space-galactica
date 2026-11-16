
require "app/player"

class Game
  attr_gtk

  # ============================================================
  # SPACE GALACTICA - ASSETS
  # ============================================================

  SPACE_BG = "sprites/space.png"

  PLANETS = (0..9).map do |i|
    "sprites/Planets/planet0#{i}.png"
  end

  METEORS = (1..4).map do |i|
    "sprites/space_assets/Meteors/meteorBrown_big#{i}.png"
  end

  UFO_BLUE = "sprites/space_assets/ufoBlue.png"
  UFO_RED  = "sprites/space_assets/ufoRed.png"

  SPACE_BOSS =
    "sprites/PNG_Parts&Spriter_Animation/Ship6/Ship6.png"

  SHIP_COLORS = {
    blue:   "sprites/space_assets/playerShip1_blue.png",
    green:  "sprites/space_assets/playerShip1_green.png",
    orange: "sprites/space_assets/playerShip1_orange.png",
    red:    "sprites/space_assets/playerShip1_red.png"
  }

  SHIP_NAMES = [:blue, :green, :orange, :red]

  SHIP_ANGLE = -90
  ORANGE_ANGLE = 0

  ENGINE_FRAMES = (1..7).map do |i|
    "sprites/space_assets/Effects/fire#{i.to_s.rjust(2, '0')}.png"
  end

  ENGINE_SPEED = 4
  ENGINE_ANGLE = -90
  ENGINE_IDLE_LENGTH = 0.85
  ENGINE_MOVING_LENGTH = 1.15
  ENGINE_THICKNESS = 0.25

  NORMAL_SHOT =
    "sprites/space_assets/Lasers/laserBlue01.png"

  ENEMY_SHOT =
    "sprites/space_assets/Lasers/laserRed01.png"

  SHOTS_DIR = "sprites/PNG_Animations/Shots"

  # ============================================================
  # ORIGINAL POWER-UP COLLECTIBLES
  # ============================================================

  POWERUP_PATHS = {
    shield: "sprites/space_assets/Power-ups/powerupBlue_shield.png",
    repair: "sprites/space_assets/Power-ups/powerupBlue_star.png",
    speed:  "sprites/space_assets/Power-ups/powerupBlue_bolt.png"
  }

  POWERUP_FALLBACK =
    "sprites/space_assets/Power-ups/powerupBlue.png"

  SHIELD_EFFECT_FRAMES = (1..3).map do |i|
    "sprites/space_assets/Effects/shield#{i}.png"
  end

  STAR_EFFECT_FRAMES = (1..3).map do |i|
    "sprites/space_assets/Effects/star#{i}.png"
  end

  SPEED_EFFECT =
    "sprites/space_assets/Effects/speed.png"

  POWERUP_ANIMATION_SPEED = 8

  # ============================================================
  # PLANET MAPS
  # ============================================================

  PLANET_MAP_1 =
    "sprites/planet-game-backgrounds/_PNG/1/1_game_background.png"

  PLANET_MAP_2 =
    "sprites/planet-game-backgrounds/_PNG/2/2_game_background.png"

  PLANET_MAP_3 =
    "sprites/planet-game-backgrounds/_PNG/3/3_game_background.png"

  PLANET_MAP_4 =
    "sprites/planet-game-backgrounds/_PNG/4/4_game_background.png"

  # ============================================================
  # MONSTER BOSS ANIMATIONS
  # ============================================================

  BOSS_FOLDER = "sprites/planet_bosses"

  def self.boss_frames(folder, action, count)
    (1..count).map do |i|
      "#{BOSS_FOLDER}/#{folder}/#{action}#{i}.png"
    end
  end

  DEMON_ANIMATIONS = {
    idle: boss_frames("demon", "Idle", 3),
    move: boss_frames("demon", "Walk", 6),
    attack: boss_frames("demon", "Attack", 4),
    hurt: boss_frames("demon", "Hurt", 2),
    death: boss_frames("demon", "Death", 6)
  }

  JINN_ANIMATIONS = {
    idle: boss_frames("jinn_animation", "Idle", 3),
    move: boss_frames("jinn_animation", "Flight", 4),
    attack: boss_frames("jinn_animation", "Attack", 4),
    magic: boss_frames("jinn_animation", "Magic_Attack", 12),
    hurt: boss_frames("jinn_animation", "Hurt", 2),
    death: boss_frames("jinn_animation", "Death", 6)
  }

  MEDUSA_ANIMATIONS = {
    idle: boss_frames("medusa", "Idle", 3),
    move: boss_frames("medusa", "Walk", 6),
    attack: boss_frames("medusa", "Attack", 6),
    stone: boss_frames("medusa", "Stone", 12),
    hurt: boss_frames("medusa", "Hurt", 2),
    death: boss_frames("medusa", "Death", 6)
  }

  DRAGON_ANIMATIONS = {
    idle: boss_frames("dragon", "Idle", 3),
    move: boss_frames("dragon", "Walk", 6),
    attack: boss_frames("dragon", "Attack", 5),
    hurt: boss_frames("dragon", "Hurt", 2),
    death: boss_frames("dragon", "Death", 6)
  }

  # ============================================================
  # SPACESHIP BOSS ANIMATIONS
  # ============================================================

  SHIP_ANIMATION_DIR = "sprites/PNG_Animations"

  def self.spaceship_engine_frames(number, turbo = false)
    mode = turbo ? "Turbo_flight" : "Normal_flight"
    prefix = turbo ?
      "Ship#{number}_turbo_flight" :
      "Ship#{number}_normal_flight"

    (1..30).map do |i|
      "#{SHIP_ANIMATION_DIR}/Exhaust/Ship#{number}/#{mode}/#{prefix}_#{i.to_s.rjust(3, '0')}.png"
    end
  end

  def self.spaceship_explosion_frames(number)
    (1..30).map do |i|
      "#{SHIP_ANIMATION_DIR}/Explosions/Ship#{number}_Explosion/Ship#{number}_Explosion_#{i.to_s.rjust(3, '0')}.png"
    end
  end

  SPACESHIP_ANIMATIONS = {}

  (1..6).each do |i|
    SPACESHIP_ANIMATIONS[i] = {
      normal: spaceship_engine_frames(i),
      turbo: spaceship_engine_frames(i, true),
      explosion: spaceship_explosion_frames(i)
    }
  end

  SPACESHIP_ENGINE_SPEED = 4
  SPACESHIP_EXPLOSION_SPEED = 5

  # ============================================================
  # GAME SETTINGS
  # ============================================================

  PLAYER_MAX_HP = 3
  PLAYER_INVULN = 90
  PLAYER_SHOT_SPEED = 16
  PLAYER_FIRE_RATE = 12

  WAVE_CLEAR_DELAY = 90
  PROMPT_DELAY = 45
  FADE_TICKS = 70

  SHIELD_DURATION = 300
  SPEED_DURATION = 360
  SPEED_MULTIPLIER = 1.5

  POWERUP_SPAWN_MIN = 500
  POWERUP_SPAWN_MAX = 850

  COMBO_TIMEOUT = 240
  POWER_DAMAGE = 3
  SUPER_DAMAGE = 6

  BOSS_SPEED_MULT = 0.8
  BOSS_BULLET_MULT = 0.65
  BOSS_FIRE_MULT = 1.5

  BOSS_IDLE_SPEED = 8
  BOSS_ATTACK_SPEED = 6
  BOSS_HURT_SPEED = 5
  BOSS_DEATH_SPEED = 8

  TRANSITION_TICKS = 240
  TRANSITION_FLASH_START = 190
  DESCENT_PLANET_SIZE = 640

  END_AFTER_FOURTH_PLANET = true

  TOUCH_JOYSTICK_X = 135
  TOUCH_JOYSTICK_Y = 130
  TOUCH_FIRE_X = 1130
  TOUCH_FIRE_Y = 130
  SHOW_TOUCH_ON_DESKTOP = false

  # ============================================================
  # ORIGINAL UFO MOVEMENT SETTINGS
  # ============================================================

  UFO_ENTRY_SPEED = 3
  UFO_SINE_AMPLITUDE = 160
  UFO_SINE_SPEED = 0.05
  UFO_CIRCLE_RADIUS = 90
  UFO_CIRCLE_SPEED = 0.035

  # ============================================================
  # WAVE GENERATOR
  # ============================================================

  def self.make_waves(level, shot = nil)
    {
      1 => {
        meteors: 4 + level,
        speed: (4 + level)..(6 + level),
        groups: [
          {
            count: 3 + level,
            hp: 1 + level / 2,
            sprite: UFO_BLUE,
            move: :sine,
            shoot: :aimed,
            fire_rate: [160 - level * 5, 95].max,
            bullet_speed: 5 + level * 0.3,
            shot: shot
          }
        ]
      },

      2 => {
        meteors: 5 + level,
        speed: (5 + level)..(8 + level),
        groups: [
          {
            count: 4 + level,
            hp: 2 + level / 2,
            sprite: UFO_RED,
            move: level.even? ? :zigzag : :circle,
            shoot: :spread3,
            fire_rate: [150 - level * 4, 90].max,
            bullet_speed: 6 + level * 0.3,
            shot: shot
          }
        ]
      },

      3 => {
        meteors: 2,
        speed: 4..6,
        groups: [],
        boss: true
      }
    }
  end

  # ============================================================
  # WORLDS
  # ============================================================

  WORLDS = [
    {
      name: "Deep Space",
      type: :space,
      background: SPACE_BG,
      tint: [255, 255, 255],
      landing_planet: PLANETS[0],
      waves: make_waves(1, 2),
      boss: {
        type: :spaceship,
        ship_number: 1,
        sprite: SPACE_BOSS,
        hp: 60, w: 400, h: 400,
        speed: [3, 4.5, 6],
        fire_rate: [110, 95, 80],
        bullet_speed: [6, 7, 8],
        shot: 2
      }
    },

    {
      name: "Ember Planet",
      type: :planet,
      background: PLANET_MAP_1,
      tint: [255, 180, 130],
      scroll_speed: 3,
      landing_planet: PLANETS[2],
      waves: make_waves(1, 4),
      boss: {
        type: :creature,
        creature: :demon,
        animations: DEMON_ANIMATIONS,
        flip_horizontally: true,
        flying: false,
        hp: 80,
        w: 900,
        h: 900,
        speed: [2, 3, 4],
        fire_rate: [135, 115, 95],
        bullet_speed: [5, 6, 7],
        shot: 4
      }
    },

    {
      name: "Nebula Sector",
      type: :space,
      background: "sprites/space_world3.png",
      tint: [160, 120, 255],
      landing_planet: PLANETS[3],
      waves: make_waves(2, 5),
      boss: {
        type: :spaceship,
        ship_number: 2,
        sprite: SPACE_BOSS,
        tint: [170, 120, 255],
        hp: 85, w: 420, h: 420,
        speed: [3, 4.5, 6],
        fire_rate: [105, 90, 75],
        bullet_speed: [6, 7, 8],
        shot: 5
      }
    },

    {
      name: "Frozen Planet",
      type: :planet,
      background: PLANET_MAP_2,
      tint: [150, 210, 255],
      scroll_speed: 3,
      landing_planet: PLANETS[4],
      waves: make_waves(2, 6),
      boss: {
        type: :creature,
        creature: :jinn,
        animations: JINN_ANIMATIONS,
        flip_horizontally: true,
        flying: true,
        hp: 100,
        w: 750,
        h: 750,
        speed: [2.5, 3.5, 4.5],
        fire_rate: [125, 105, 85],
        bullet_speed: [5, 6, 7],
        shot: 6
      }
    },

    {
      name: "Crystal Expanse",
      type: :space,
      background: "sprites/space_world5.png",
      tint: [140, 210, 255],
      landing_planet: PLANETS[5],
      waves: make_waves(3, 5),
      boss: {
        type: :spaceship,
        ship_number: 3,
        sprite: SPACE_BOSS,
        tint: [130, 220, 255],
        hp: 100, w: 420, h: 420,
        speed: [3, 4.5, 6],
        fire_rate: [100, 85, 70],
        bullet_speed: [6, 7, 8],
        shot: 5
      }
    },

    {
      name: "Shadow Planet",
      type: :planet,
      background: PLANET_MAP_3,
      tint: [190, 140, 210],
      scroll_speed: 4,
      landing_planet: PLANETS[6],
      waves: make_waves(3, 5),
      boss: {
        type: :creature,
        creature: :medusa,
        animations: MEDUSA_ANIMATIONS,
        flip_horizontally: true,
        flying: false,
        hp: 115,
        w: 850,
        h: 850,
        speed: [2, 3, 4],
        fire_rate: [125, 105, 85],
        bullet_speed: [5, 6, 7],
        shot: 5
      }
    },

    {
      name: "Dark Orbit",
      type: :space,
      background: "sprites/space_world7.png",
      tint: [180, 120, 220],
      landing_planet: PLANETS[7],
      waves: make_waves(4, 2),
      boss: {
        type: :spaceship,
        ship_number: 4,
        sprite: SPACE_BOSS,
        tint: [200, 130, 230],
        hp: 115, w: 420, h: 420,
        speed: [3, 4.5, 6],
        fire_rate: [100, 85, 70],
        bullet_speed: [6, 7, 8],
        shot: 2
      }
    },

    {
      name: "Dragon Planet",
      type: :planet,
      background: PLANET_MAP_4,
      tint: [140, 255, 160],
      scroll_speed: 4,
      landing_planet: PLANETS[8],
      waves: make_waves(4, 3),
      boss: {
        type: :creature,
        creature: :dragon,
        animations: DRAGON_ANIMATIONS,
        flip_horizontally: true,
        flying: true,
        hp: 125,
        w: 850,
        h: 780,
        speed: [2.5, 3.5, 4.5],
        fire_rate: [125, 105, 90],
        bullet_speed: [5, 6, 7],
        shot: 3
      }
    }
  ]

  # ============================================================
  # SHORTCUTS
  # ============================================================

  def state; args.state; end
  def inputs; args.inputs; end
  def outputs; args.outputs; end
  def grid; args.grid; end
  def gtk; args.gtk; end
  def audio; args.audio; end

  def world
    WORLDS[state.world_index]
  end

  def planet_world?
    world[:type] == :planet
  end

  def next_world_index
    (state.world_index + 1) % WORLDS.length
  end

  def selected_ship_color
    SHIP_NAMES[state.ship_index]
  end

  def selected_ship_angle
    selected_ship_color == :orange ?
      ORANGE_ANGLE : SHIP_ANGLE
  end

  # ============================================================
  # MAIN LOOP
  # ============================================================

  def tick
    defaults
    handle_input
    update_game
    render_game
  end

  def defaults
    state.player ||= Player.new
    state.game_state ||= :ship_select
    state.ship_index ||= 0
    state.score ||= 0
    state.hp ||= PLAYER_MAX_HP
    state.invuln ||= 0
    state.prompt_timer ||= 0
    state.fade ||= 0
    state.fire_cooldown ||= 0
    state.engine_boost ||= false

    state.shots ||= []
    state.enemy_shots ||= []
    state.effects ||= []
    state.meteors ||= []
    state.ufos ||= []
    state.planets ||= []
    state.powerups ||= []
    state.player_effects ||= []

    state.combo ||= 0
    state.combo_timer ||= 0
    state.power_awarded ||= false

    state.shield_timer ||= 0
    state.speed_timer ||= 0
    state.powerup_timer ||= 550

    state.music_volume ||= 1.0
    state.music_paused = false if state.music_paused.nil?

    state.mobile_dx ||= 0.0
    state.mobile_dy ||= 0.0
    state.mobile_firing ||= false
    state.touch_detected ||= false
    state.previous_touches ||= {}

    unless state.initialized
      state.player_start = {
        x: state.player.x,
        y: state.player.y,
        w: state.player.w,
        h: state.player.h
      }

      state.planets_cleared = 0
      start_world(0)
      state.initialized = true
    end

    unless audio[:music]
      audio[:music] = {
        input: "sounds/Orbital Colossus.mp3",
        looping: true,
        gain: state.music_paused ? 0 : state.music_volume
      }
    end
  end

  # ============================================================
  # ASSET HELPERS
  # ============================================================

  def valid_frames(paths)
    @frame_cache ||= {}
    key = paths.join("|")

    @frame_cache[key] ||= paths.select do |path|
      gtk.stat_file(path)
    end
  end

  def shot_frames(number, kind = :flying)
    folder = "#{SHOTS_DIR}/Shot#{number}"
    prefix = "shot#{number}"

    paths = (1..20).map do |i|
      if kind == :explosion
        "#{folder}/#{prefix}_exp#{i}.png"
      else
        "#{folder}/#{prefix}_#{i}.png"
      end
    end

    valid_frames(paths)
  end

  def boss_animation_frames(cfg, action)
    return [] unless cfg
    return [] unless cfg[:type] == :creature
    return [] unless cfg[:animations]
    return [] unless action

    paths = cfg[:animations][action]
    return [] unless paths && !paths.empty?

    valid_frames(paths)
  end

  def boss_animation_speed(action)
    case action
    when :attack, :magic, :stone
      BOSS_ATTACK_SPEED
    when :hurt
      BOSS_HURT_SPEED
    when :death
      BOSS_DEATH_SPEED
    else
      BOSS_IDLE_SPEED
    end
  end

  def boss_animation_finished?(boss)
    return true unless boss

    cfg = world[:boss]
    return true unless cfg[:type] == :creature

    frames = boss_animation_frames(
      cfg, boss[:animation]
    )

    return true if frames.empty?

    elapsed = Kernel.tick_count -
      boss[:animation_start]

    elapsed >= frames.length *
      boss_animation_speed(boss[:animation])
  end

  def play_boss_animation(boss, action)
    return unless boss
    return if boss[:dying] && action != :death

    boss[:animation] = action
    boss[:animation_start] = Kernel.tick_count
  end

  # ============================================================
  # WORLD MANAGEMENT
  # ============================================================

  def start_world(index)
    state.world_index = index
    state.bg_scroll = 0.0

    requested = world[:background]

    if gtk.stat_file(requested)
      state.bg = requested
      state.bg_tint = [255, 255, 255]
    else
      puts "MISSING WORLD BACKGROUND: #{requested}"
      state.bg = SPACE_BG
      state.bg_tint = world[:tint]
    end

    state.planets = []

    unless planet_world?
      state.planets << {
        x: 0,
        y: -150,
        w: 1000,
        h: 1000,
        path: PLANETS.sample,
        speed: 1
      }
    end

    start_wave(1)
  end

  def start_wave(number)
    cfg = world[:waves][number]

    state.wave = number
    state.wave_clear_timer = WAVE_CLEAR_DELAY
    state.banner_timer = 150

    state.banner_text =
      number == 3 ? "WARNING! BOSS INCOMING" :
      "WAVE #{number}"

    state.banner_sub =
      number == 1 ? world[:name].upcase : nil

    state.enemy_shots = []

    state.meteors = cfg[:meteors].times.map do
      spawn_meteor(cfg, true)
    end

    state.ufos = []
    index = 0

    cfg[:groups].each do |group|
      group[:count].times do
        state.ufos << spawn_ufo(group, index)
        index += 1
      end
    end

    state.boss = nil
    spawn_boss(world[:boss]) if cfg[:boss]
  end

  def check_wave_progress
    return if state.wave >= 3
    return unless state.ufos.empty?

    state.wave_clear_timer -= 1

    start_wave(state.wave + 1) if
      state.wave_clear_timer <= 0
  end

  def update_background
    if planet_world?
      speed = world[:scroll_speed] || 3
      state.bg_scroll =
        (state.bg_scroll + speed) % grid.w
    end

    state.planets.each do |p|
      p[:x] -= p[:speed]

      if p[:x] + p[:w] < 0
        p[:x] = grid.w
        p[:y] = Numeric.rand(-200..200)
        p[:path] = PLANETS.sample
      end
    end
  end

  # ============================================================
  # ENEMIES
  # ============================================================

  def spawn_meteor(cfg, initial = false)
    size = Numeric.rand(50..150)

    {
      x: grid.w + Numeric.rand(
        0..(initial ? 1500 : 400)
      ),
      y: Numeric.rand(0..(grid.h - size)),
      w: size,
      h: size,
      path: METEORS.sample,
      speed: Numeric.rand(cfg[:speed]),
      vy: Numeric.rand(-2..2),
      spin: Numeric.rand(-3..3),
      angle: 0,
      dead: false
    }
  end

  def spawn_ufo(group, index)
    tint = group[:tint] || [255, 255, 255]
    y = Numeric.rand(120..550)

    hover_x = 600 + (index % 3) * 180
    radius = UFO_CIRCLE_RADIUS

    # Circle UFOs enter at the rightmost orbit point.
    # This avoids a teleport when orbiting begins.
    entry_x =
      group[:move] == :circle ?
      hover_x + radius :
      hover_x

    {
      x: grid.w + 100 + index * 220,
      y: y,
      base_y: y,
      w: 100,
      h: 100,
      path: group[:sprite],
      r: tint[0],
      g: tint[1],
      b: tint[2],
      hp: group[:hp],
      move: group[:move],
      shoot: group[:shoot],
      hover_x: hover_x,
      entry_x: entry_x,
      fire_rate: group[:fire_rate],

      # Short delay after entering the screen.
      fire_timer: 15 + index * 8,

      bullet_speed: group[:bullet_speed],
      shot: group[:shot],
      phase: Numeric.rand(0..360),
      orbit: 0.0,
      radius: radius,
      vy: index.even? ? 3.5 : -3.5,
      burst_left: 0,
      burst_timer: 0,
      spin: 0.0,
      dead: false
    }
  end

  def update_enemies
    state.meteors.each do |m|
      m[:x] -= m[:speed]
      m[:y] += m[:vy]
      m[:angle] += m[:spin]

      if m[:y] < 0 || m[:y] + m[:h] > grid.h
        m[:vy] *= -1
        m[:y] = clamp(m[:y], 0, grid.h - m[:h])
      end
    end

    state.ufos.each do |u|
      move_ufo(u)
      shoot_ufo(u)
    end
  end

  # ============================================================
  # RESTORED ORIGINAL UFO MOVEMENT
  # ============================================================

  def move_ufo(u)
    case u[:move]

    when :zigzag
      if u[:x] > u[:hover_x]
        u[:x] = [
          u[:x] - UFO_ENTRY_SPEED,
          u[:hover_x]
        ].max
      else
        u[:y] += u[:vy]

        if u[:y] <= 20
          u[:y] = 20
          u[:vy] = u[:vy].abs

        elsif u[:y] + u[:h] >= grid.h - 20
          u[:y] = grid.h - 20 - u[:h]
          u[:vy] = -u[:vy].abs
        end
      end

    when :circle
      if u[:x] > u[:entry_x]
        u[:x] = [
          u[:x] - UFO_ENTRY_SPEED,
          u[:entry_x]
        ].max
      else
        u[:orbit] += UFO_CIRCLE_SPEED

        u[:x] = u[:hover_x] +
          Math.cos(u[:orbit]) * u[:radius]

        u[:y] = u[:base_y] +
          Math.sin(u[:orbit]) * u[:radius]
      end

    when :strafe
      if u[:x] > u[:hover_x]
        u[:x] -= UFO_ENTRY_SPEED
      else
        target = (
          state.player.y +
          state.player.h / 2
        ) - u[:h] / 2

        u[:y] += clamp(
          target - u[:y], -3, 3
        )

        u[:y] = clamp(
          u[:y], 0, grid.h - u[:h]
        )
      end

    else
      # Original fast sine movement.
      if u[:x] > u[:hover_x]
        u[:x] -= UFO_ENTRY_SPEED
      end

      t = (
        Kernel.tick_count + u[:phase]
      ) * UFO_SINE_SPEED

      u[:y] = clamp(
        u[:base_y] +
        Math.sin(t) * UFO_SINE_AMPLITUDE,
        0, grid.h - u[:h]
      )
    end
  end

  # ============================================================
  # ORIGINAL UFO ATTACK PATTERNS
  # ============================================================

  def shoot_ufo(u)
    return if u[:x] > grid.w - u[:w]

    cx = u[:x] + 10
    cy = u[:y] + u[:h] / 2

    if u[:burst_left] > 0
      u[:burst_timer] -= 1

      if u[:burst_timer] <= 0
        fire_enemy_shot(
          cx, cy,
          angle_to_player(cx, cy),
          u[:bullet_speed], u[:shot]
        )

        u[:burst_left] -= 1
        u[:burst_timer] = 8
      end
    end

    u[:fire_timer] -= 1
    return if u[:fire_timer] > 0

    base = angle_to_player(cx, cy)

    case u[:shoot]
    when :aimed
      fire_enemy_shot(
        cx, cy, base,
        u[:bullet_speed], u[:shot]
      )

    when :spread3
      [-12, 0, 12].each do |off|
        fire_enemy_shot(
          cx, cy, base + off,
          u[:bullet_speed], u[:shot]
        )
      end

    when :fan
      [-40, -20, 0, 20, 40].each do |off|
        fire_enemy_shot(
          cx, cy, 180 + off,
          u[:bullet_speed], u[:shot]
        )
      end

    when :burst
      fire_enemy_shot(
        cx, cy, base,
        u[:bullet_speed], u[:shot]
      )

      u[:burst_left] = 2
      u[:burst_timer] = 8

    when :ring
      12.times do |i|
        fire_enemy_shot(
          cx, cy,
          u[:spin] + i * 30,
          u[:bullet_speed], u[:shot]
        )
      end

      u[:spin] += 15

    when :sweep
      fire_enemy_shot(
        cx, cy,
        180 + Math.sin(u[:spin]) * 60,
        u[:bullet_speed], u[:shot]
      )

      u[:spin] += 0.3

    else
      fire_enemy_shot(
        cx, cy, 180,
        u[:bullet_speed], u[:shot]
      )
    end

    u[:fire_timer] =
      u[:fire_rate] + Numeric.rand(0..40)
  end

  def refill_meteors
    cfg = world[:waves][state.wave]

    while state.meteors.length < cfg[:meteors]
      state.meteors << spawn_meteor(cfg)
    end
  end

  # ============================================================
  # BOSS SPAWNING
  # ============================================================

  def spawn_boss(cfg)
    sprite =
      if cfg[:type] == :creature
        boss_animation_frames(cfg, :idle)[0]
      else
        cfg[:sprite]
      end

    sprite = nil if sprite && !gtk.stat_file(sprite)

    if !sprite && cfg[:type] != :creature
      sprite = SPACE_BOSS if gtk.stat_file(SPACE_BOSS)
    end

    tint = cfg[:tint] || [255, 255, 255]

    flying = cfg[:type] == :spaceship ||
      cfg[:flying] == true

    ground_y = -cfg[:h] * 0.12

    spawn_y = flying ?
      (grid.h - cfg[:h]) / 2.0 :
      ground_y

    state.boss = {
      x: grid.w + 50,
      y: spawn_y,
      w: cfg[:w],
      h: cfg[:h],
      hp: cfg[:hp],
      max_hp: cfg[:hp],
      path: sprite,
      r: tint[0],
      g: tint[1],
      b: tint[2],

      # Original spaceship boss starts moving upward.
      dir: cfg[:type] == :spaceship ? 1 : -1,

      flying: flying,
      ground_y: ground_y,
      fire_timer: 100,
      special_timer: 240,
      animation: :idle,
      animation_start: Kernel.tick_count,
      flash: 0,
      dying: false,
      explosion_frames: nil,
      explosion_start: nil
    }
  end

  def boss_phase(b)
    ratio = b[:hp].to_f / b[:max_hp]

    return 1 if ratio > 0.66
    return 2 if ratio > 0.33

    3
  end

  # ============================================================
  # BOSS MOVEMENT
  # ============================================================

  def update_boss
    b = state.boss
    return unless b

    cfg = world[:boss]

    update_boss_animation(b, cfg)

    # Handle boss death.
    if b[:dying]
      if cfg[:type] == :spaceship
        frames = b[:explosion_frames] || []

        elapsed = Kernel.tick_count -
          (b[:explosion_start] || Kernel.tick_count)

        if frames.empty? ||
           elapsed >= frames.length *
             SPACESHIP_EXPLOSION_SPEED
          finish_boss_death
        end
      else
        finish_boss_death if boss_animation_finished?(b)
      end

      return
    end

    b[:flash] -= 1 if b[:flash] > 0

    phase = boss_phase(b)
    i = phase - 1

    if cfg[:type] == :spaceship

      # ======================================================
      # ORIGINAL SPACESHIP BOSS MOVEMENT
      # ======================================================

      # Enter from right, stop close to right edge.
      target_x = grid.w - b[:w] - 30

      if b[:x] > target_x
        b[:x] = [b[:x] - 2, target_x].max
        return
      end

      # Move up and down across full available height.
      b[:y] += b[:dir] * cfg[:speed][i]

      if b[:y] <= 0
        b[:y] = 0
        b[:dir] = 1

      elsif b[:y] + b[:h] >= grid.h
        b[:y] = grid.h - b[:h]
        b[:dir] = -1
      end

      cx = b[:x] + 60
      cy = b[:y] + b[:h] / 2

    elsif b[:flying]

      # ======================================================
      # FLYING PLANET MONSTERS - JINN AND DRAGON
      # ======================================================

      target_x = grid.w - b[:w] * 0.72

      if b[:x] > target_x
        b[:x] -= 3
        return
      end

      center_y = (grid.h - b[:h]) / 2.0
      range = 85

      b[:y] += b[:dir] *
        cfg[:speed][i] * BOSS_SPEED_MULT

      if b[:y] <= center_y - range
        b[:y] = center_y - range
        b[:dir] = 1

      elsif b[:y] >= center_y + range
        b[:y] = center_y + range
        b[:dir] = -1
      end

      cx = b[:x] + b[:w] * 0.25
      cy = b[:y] + b[:h] * 0.55

    else

      # ======================================================
      # GROUND MONSTERS - DEMON AND MEDUSA
      # ======================================================

      target_x = grid.w - b[:w] * 0.72

      if b[:x] > target_x
        b[:x] -= 3
        return
      end

      b[:y] = b[:ground_y]

      left_limit = grid.w * 0.55
      right_limit = grid.w - b[:w] * 0.60

      # Ensure limits are ordered correctly.
      if right_limit < left_limit
        left_limit, right_limit =
          right_limit, left_limit
      end

      b[:x] += b[:dir] *
        cfg[:speed][i] * BOSS_SPEED_MULT

      if b[:x] <= left_limit
        b[:x] = left_limit
        b[:dir] = 1

      elsif b[:x] >= right_limit
        b[:x] = right_limit
        b[:dir] = -1
      end

      if b[:animation] == :idle
        play_boss_animation(b, :move)
      end

      cx = b[:x] + b[:w] * 0.25
      cy = b[:y] + b[:h] * 0.55
    end

    # ======================================================
    # BOSS ATTACK TIMERS
    # ======================================================

    b[:fire_timer] -= 1
    b[:special_timer] -= 1

    if b[:fire_timer] <= 0
      boss_attack(b, cfg, cx, cy, phase, i)

      b[:fire_timer] = (
        cfg[:fire_rate][i] * BOSS_FIRE_MULT
      ).to_i
    end

    if phase >= 2 && b[:special_timer] <= 0
      boss_special_attack(b, cfg, cx, cy)

      b[:special_timer] =
        phase == 3 ? 210 : 300
    end
  end

  # ============================================================
  # MONSTER BOSS ANIMATIONS
  # ============================================================

  def update_boss_animation(b, cfg)
    return unless cfg[:type] == :creature

    action = b[:animation] || :idle
    frames = boss_animation_frames(cfg, action)

    if frames.empty?
      frames = boss_animation_frames(cfg, :idle)
    end

    return if frames.empty?

    speed = boss_animation_speed(action)
    elapsed = Kernel.tick_count - b[:animation_start]

    if action == :death
      index = [elapsed / speed, frames.length - 1].min
    else
      index = (elapsed / speed) % frames.length
    end

    b[:path] = frames[index]

    return if b[:dying]

    if [:attack, :magic, :stone, :hurt].include?(action)
      if boss_animation_finished?(b)
        play_boss_animation(
          b, b[:flying] ? :idle : :move
        )
      end
    end
  end

  # ============================================================
  # BOSS ATTACKS
  # ============================================================

  def boss_attack(b, cfg, cx, cy, phase, i)
    if cfg[:type] == :creature
      play_boss_animation(b, :attack)
    end

    base = angle_to_player(cx, cy)

    offsets =
      case phase
      when 1 then [0]
      when 2 then [-16, 0, 16]
      else [-25, 0, 25]
      end

    speed = cfg[:bullet_speed][i] *
      BOSS_BULLET_MULT

    offsets.each do |off|
      fire_enemy_shot(
        cx, cy, base + off,
        speed, cfg[:shot]
      )
    end
  end

  def boss_special_attack(b, cfg, cx, cy)
    case cfg[:creature]
    when :jinn
      play_boss_animation(b, :magic)

      8.times do |i|
        fire_enemy_shot(
          cx, cy, i * 45, 3.5, cfg[:shot]
        )
      end

    when :medusa
      play_boss_animation(b, :stone)

      [-45, -30, -15, 0, 15, 30, 45].each do |off|
        fire_enemy_shot(
          cx, cy, 180 + off, 4, cfg[:shot]
        )
      end

    when :dragon
      play_boss_animation(b, :attack)

      [-35, -20, 0, 20, 35].each do |off|
        fire_enemy_shot(
          cx, cy, 180 + off, 4.5, cfg[:shot]
        )
      end

    when :demon
      play_boss_animation(b, :attack)

      [-30, -15, 0, 15, 30].each do |off|
        fire_enemy_shot(
          cx, cy, 180 + off, 4, cfg[:shot]
        )
      end

    else
      [-25, 0, 25].each do |off|
        fire_enemy_shot(
          cx, cy, 180 + off, 4, cfg[:shot]
        )
      end
    end
  end

  # ============================================================
  # BOSS DAMAGE AND DEATH
  # ============================================================

  def damage_boss(amount)
    b = state.boss
    return unless b
    return if b[:dying]

    cfg = world[:boss]

    b[:hp] -= amount
    b[:flash] = 5

    if b[:hp] <= 0
      b[:hp] = 0
      b[:dying] = true
      state.enemy_shots = []

      if cfg[:type] == :creature
        frames = boss_animation_frames(cfg, :death)

        if frames.any?
          play_boss_animation(b, :death)
        else
          finish_boss_death
        end
      else
        number = cfg[:ship_number] || 1
        animations = SPACESHIP_ANIMATIONS[number]

        frames = animations ?
          valid_frames(animations[:explosion]) : []

        if frames.any?
          b[:explosion_frames] = frames
          b[:explosion_start] = Kernel.tick_count
          b[:animation] = :exploding
        else
          finish_boss_death
        end
      end

    elsif cfg[:type] == :creature
      play_boss_animation(b, :hurt)
    end
  end

  def finish_boss_death
    state.score += 1000
    state.boss = nil
    state.enemy_shots = []
    state.shots = []
    state.meteors = []
    state.ufos = []
    state.prompt_timer = PROMPT_DELAY

    state.planets_cleared += 1 if planet_world?

    if END_AFTER_FOURTH_PLANET &&
       state.planets_cleared >= 4
      state.game_state = :victory
    else
      state.game_state = :world_clear
    end
  end

  # ============================================================
  # PLAYER WEAPONS
  # ============================================================

  def fire_player_shot
    p = state.player

    if state.combo >= 10
      type = :super
      damage = SUPER_DAMAGE
      number = 3
      reset_combo

    elsif state.combo >= 5 && !state.power_awarded
      type = :power
      damage = POWER_DAMAGE
      number = 1
      state.power_awarded = true

    else
      type = :normal
      damage = 1
      number = nil
    end

    frames = number ? shot_frames(number) : []

    if type == :normal
      width = 72
      height = 10
      path = NORMAL_SHOT
      angle = -90

    elsif type == :power
      width = 95
      height = 24
      path = frames.empty? ? NORMAL_SHOT : frames[0]
      angle = frames.empty? ? -90 : 0

    else
      width = 120
      height = 34
      path = frames.empty? ? NORMAL_SHOT : frames[0]
      angle = frames.empty? ? -90 : 0
    end

    state.shots << {
      x: p.x + p.w - 5,
      y: p.y + p.h / 2 - height / 2,
      w: width,
      h: height,
      path: path,
      frames: frames,
      born: Kernel.tick_count,
      angle: angle,
      damage: damage,
      type: type,
      number: number,
      dead: false
    }
  end

  def fire_enemy_shot(cx, cy, deg, speed, number = nil)
    rad = deg * Math::PI / 180
    frames = number ? shot_frames(number) : []
    size = frames.empty? ? 28 : 44

    state.enemy_shots << {
      x: cx - size / 2,
      y: cy - size / 2,
      w: size,
      h: size,
      vx: Math.cos(rad) * speed,
      vy: Math.sin(rad) * speed,
      path: frames.empty? ? ENEMY_SHOT : frames[0],
      frames: frames,
      born: Kernel.tick_count,
      angle: frames.empty? ? deg - 90 : deg,
      number: number,
      hit_r: 12,
      dead: false
    }
  end

  def update_shots
    state.shots.each do |s|
      next if s[:dead]

      s[:x] += PLAYER_SHOT_SPEED
      animate_shot(s)

      if s[:x] > grid.w + 100
        s[:dead] = true
        reset_combo
      end
    end

    state.enemy_shots.each do |s|
      next if s[:dead]

      s[:x] += s[:vx]
      s[:y] += s[:vy]
      animate_shot(s)

      if s[:x] < -100 || s[:x] > grid.w + 100 ||
         s[:y] < -100 || s[:y] > grid.h + 100
        s[:dead] = true
      end
    end
  end

  def animate_shot(s)
    frames = s[:frames]
    return if frames.nil? || frames.empty?

    index = (
      (Kernel.tick_count - s[:born]) / 4
    ) % frames.length

    s[:path] = frames[index]
  end

  # ============================================================
  # EXPLOSIONS
  # ============================================================

  def spawn_explosion(cx, cy, number, size = 90)
    return unless number

    frames = shot_frames(number, :explosion)
    return if frames.empty?

    state.effects << {
      x: cx - size / 2,
      y: cy - size / 2,
      w: size,
      h: size,
      frames: frames,
      born: Kernel.tick_count,
      speed: 4
    }
  end

  def update_effects
    state.effects.reject! do |fx|
      elapsed = Kernel.tick_count - fx[:born]
      elapsed / fx[:speed] >= fx[:frames].length
    end

    state.player_effects.reject! do |fx|
      Kernel.tick_count - fx[:born] >= fx[:duration]
    end
  end

  def shot_impact(s)
    s[:dead] = true

    spawn_explosion(
      s[:x] + s[:w] / 2,
      s[:y] + s[:h] / 2,
      s[:number],
      s[:type] == :super ? 130 : 90
    )
  end

  # ============================================================
  # COMBOS
  # ============================================================

  def register_hit
    state.combo += 1
    state.combo_timer = COMBO_TIMEOUT
  end

  def reset_combo
    state.combo = 0
    state.combo_timer = 0
    state.power_awarded = false
  end

  def update_combo
    if state.combo_timer > 0
      state.combo_timer -= 1
      reset_combo if state.combo_timer <= 0
    end
  end

  # ============================================================
  # POWER-UPS
  # ============================================================

  def spawn_powerup
    type = [:shield, :repair, :speed].sample
    y = Numeric.rand(100..550)

    state.powerups << {
      x: grid.w + 50,
      y: y,
      base_y: y,
      w: 58,
      h: 58,
      type: type,
      phase: Numeric.rand(0..360),
      born: Kernel.tick_count,
      dead: false
    }
  end

  def update_powerups
    state.shield_timer -= 1 if state.shield_timer > 0
    state.speed_timer -= 1 if state.speed_timer > 0

    state.powerup_timer -= 1

    if state.powerup_timer <= 0
      spawn_powerup
      state.powerup_timer =
        Numeric.rand(
          POWERUP_SPAWN_MIN..POWERUP_SPAWN_MAX
        )
    end

    state.powerups.each do |p|
      p[:x] -= 2.5

      p[:y] = p[:base_y] +
        Math.sin(
          (Kernel.tick_count + p[:phase]) * 0.035
        ) * 20

      p[:dead] = true if p[:x] + p[:w] < 0
    end

    state.powerups.reject! { |p| p[:dead] }
  end

  def activate_powerup(type)
    case type
    when :shield
      state.shield_timer = SHIELD_DURATION

    when :repair
      state.hp = [state.hp + 1, PLAYER_MAX_HP].min

      state.player_effects << {
        type: :repair,
        born: Kernel.tick_count,
        duration: 45
      }

    when :speed
      state.speed_timer = SPEED_DURATION

      state.player_effects << {
        type: :speed,
        born: Kernel.tick_count,
        duration: 45
      }
    end
  end

  # ============================================================
  # COLLISIONS
  # ============================================================

  def check_collisions
    state.shots.each do |s|
      next if s[:dead]

      box = shot_hitbox(s)

      state.powerups.each do |p|
        next if p[:dead] || s[:dead]

        if hit?(box, p)
          activate_powerup(p[:type])
          p[:dead] = true
          shot_impact(s)
        end
      end

      state.meteors.each do |m|
        next if m[:dead] || s[:dead]

        if hit?(box, shrink(m, 0.12))
          m[:dead] = true
          state.score += 10
          shot_impact(s)
          register_hit
        end
      end

      state.ufos.each do |u|
        next if u[:dead] || s[:dead]

        if hit?(box, u)
          u[:hp] -= s[:damage]
          shot_impact(s)
          register_hit

          if u[:hp] <= 0
            u[:dead] = true
            state.score += 100
          end
        end
      end

      b = state.boss

      if b && !b[:dying] && !s[:dead] &&
         b[:x] < grid.w &&
         hit?(box, boss_hitbox(b))

        damage = s[:damage]
        shot_impact(s)
        register_hit
        state.score += damage * 5
        damage_boss(damage)
      end
    end

    hurt = shrink(state.player, 0.2)

    state.meteors.each do |m|
      next if m[:dead]

      if hit?(hurt, shrink(m, 0.15))
        m[:dead] = true
        damage_player
      end
    end

    state.enemy_shots.each do |s|
      next if s[:dead]

      if hit?(hurt, bullet_hitbox(s))
        s[:dead] = true

        spawn_explosion(
          s[:x] + s[:w] / 2,
          s[:y] + s[:h] / 2,
          s[:number], 65
        )

        damage_player
      end
    end

    b = state.boss

    if b && !b[:dying] &&
       hit?(hurt, boss_hitbox(b))
      damage_player
    end
  end

  def damage_player
    return if state.invuln > 0
    return if state.shield_timer > 0
    return unless state.game_state == :playing

    state.hp -= 1
    state.invuln = PLAYER_INVULN
    reset_combo

    if state.hp <= 0
      state.game_state = :game_over
      state.prompt_timer = PROMPT_DELAY
    end
  end

  # ============================================================
  # INPUT
  # ============================================================

  def handle_input
    update_touch_controls
    kb = inputs.keyboard

    if kb.key_down.m
      state.music_paused = !state.music_paused
      apply_music
    end

    if kb.key_down.hyphen
      state.music_volume =
        [state.music_volume - 0.1, 0].max
      apply_music
    end

    if kb.key_down.equal_sign
      state.music_volume =
        [state.music_volume + 0.1, 1].min
      apply_music
    end

    case state.game_state
    when :ship_select
      selection_input

    when :world_clear
      return if state.prompt_timer > 0

      if kb.key_down.enter || touch_continue?
        planet_world? ? begin_ascent : begin_descent
      elsif kb.key_down.space || touch_restart?
        gtk.reset_next_tick
      end

    when :game_over, :victory
      if state.prompt_timer <= 0 &&
         (kb.key_down.space || touch_restart?)
        gtk.reset_next_tick
      end

    when :playing
      player_input
    end
  end

  def selection_input
    kb = inputs.keyboard

    if kb.key_down.left
      state.ship_index = (state.ship_index - 1) % 4
    elsif kb.key_down.right
      state.ship_index = (state.ship_index + 1) % 4
    end

    if kb.key_down.enter || kb.key_down.space
      start_playing
      return
    end

    touch_press_points.each do |point|
      4.times do |i|
        x = 210 + i * 230

        if inside?(point[:x], point[:y], x, 230, 180, 210)
          state.ship_index = i
        end
      end

      if inside?(point[:x], point[:y], 480, 95, 320, 80)
        start_playing
        return
      end
    end
  end

  def start_playing
    apply_selected_ship
    state.game_state = :playing
    state.invuln = PLAYER_INVULN
    state.fade = FADE_TICKS
  end

  def apply_selected_ship
    path = SHIP_COLORS[selected_ship_color]
    state.player.path = path if gtk.stat_file(path)
  end

  def player_input
    p = state.player

    dx = inputs.left_right.to_f
    dy = inputs.up_down.to_f

    if state.mobile_dx != 0 || state.mobile_dy != 0
      dx = state.mobile_dx
      dy = state.mobile_dy
    end

    speed = p.speed
    speed *= SPEED_MULTIPLIER if state.speed_timer > 0

    p.x = clamp(p.x + dx * speed, 0, grid.w - p.w)
    p.y = clamp(p.y + dy * speed, 0, grid.h - p.h)

    state.engine_boost = dx.abs + dy.abs > 0.1

    state.fire_cooldown -= 1 if state.fire_cooldown > 0

    firing = inputs.keyboard.key_held.space ||
      inputs.keyboard.key_down.space ||
      state.mobile_firing

    if firing && state.fire_cooldown <= 0
      fire_player_shot
      state.fire_cooldown = PLAYER_FIRE_RATE
    end
  end

  def apply_music
    return unless audio[:music]

    audio[:music][:gain] =
      state.music_paused ? 0 : state.music_volume
  end

  # ============================================================
  # MOBILE CONTROLS
  # ============================================================

  def touch_points
    points = []

    if inputs.respond_to?(:finger_touches)
      touches = inputs.finger_touches

      if touches
        touches.each do |id, touch|
          next unless touch

          points << {
            id: id,
            x: touch.x,
            y: touch.y
          }
        end
      end
    end

    if SHOW_TOUCH_ON_DESKTOP &&
       inputs.mouse.button_left
      points << {
        id: :mouse,
        x: inputs.mouse.x,
        y: inputs.mouse.y
      }
    end

    points
  end

  def update_touch_controls
    state.mobile_dx = 0.0
    state.mobile_dy = 0.0
    state.mobile_firing = false

    points = touch_points
    state.touch_detected = true if points.any?

    return unless state.touch_detected ||
      SHOW_TOUCH_ON_DESKTOP

    points.each do |p|
      x = p[:x]
      y = p[:y]

      if x < grid.w * 0.45 && y < grid.h * 0.55
        dx = x - TOUCH_JOYSTICK_X
        dy = y - TOUCH_JOYSTICK_Y
        distance = Math.sqrt(dx * dx + dy * dy)

        if distance > 0
          strength = [distance / 85.0, 1.0].min
          state.mobile_dx = dx / distance * strength
          state.mobile_dy = dy / distance * strength
        end
      end

      dx = x - TOUCH_FIRE_X
      dy = y - TOUCH_FIRE_Y

      if Math.sqrt(dx * dx + dy * dy) <= 105
        state.mobile_firing = true
      end
    end
  end

  def touch_press_points
    points = []
    current = touch_points
    previous = state.previous_touches || {}

    current.each do |p|
      points << p unless previous[p[:id]]
    end

    new_previous = {}
    current.each { |p| new_previous[p[:id]] = true }
    state.previous_touches = new_previous

    if inputs.mouse.click
      points << {
        x: inputs.mouse.x,
        y: inputs.mouse.y
      }
    end

    points
  end

  def touch_continue?
    touch_press_points.any? do |p|
      inside?(p[:x], p[:y], 470, 175, 340, 70)
    end
  end

  def touch_restart?
    touch_press_points.any? do |p|
      inside?(p[:x], p[:y], 470, 80, 340, 65)
    end
  end

  # ============================================================
  # MAIN UPDATE
  # ============================================================

  def update_game
    update_effects

    state.prompt_timer -= 1 if state.prompt_timer > 0
    state.fade -= 1 if state.fade > 0

    if [:descending, :ascending].include?(state.game_state)
      update_transition
      return
    end

    return unless state.game_state == :playing

    state.banner_timer -= 1 if state.banner_timer > 0
    state.invuln -= 1 if state.invuln > 0

    update_background
    update_enemies
    update_boss
    update_shots
    update_combo
    update_powerups
    check_collisions

    return unless state.game_state == :playing

    state.shots.reject! { |s| s[:dead] }
    state.enemy_shots.reject! { |s| s[:dead] }

    state.meteors.reject! do |m|
      m[:dead] || m[:x] + m[:w] < -50
    end

    state.ufos.reject! { |u| u[:dead] }

    refill_meteors
    check_wave_progress
  end

  # ============================================================
  # PLANET DESCENT / ASCENT
  # ============================================================

  def begin_descent
    begin_transition(:descending)
  end

  def begin_ascent
    begin_transition(:ascending)
  end

  def begin_transition(type)
    p = state.player

    state.transition = {
      type: type,
      t: 0,
      start_x: p.x,
      start_y: p.y,
      start_w: p.w,
      start_h: p.h,
      planet: WORLDS[next_world_index][:landing_planet],
      flash: 0.0
    }

    state.shots = []
    state.enemy_shots = []
    state.meteors = []
    state.ufos = []
    state.powerups = []
    state.game_state = type
  end

  def update_transition
    tr = state.transition
    tr[:t] += 1

    t = tr[:t]
    progress = ease(t / 190.0)
    p = state.player

    if tr[:type] == :descending
      target_x = grid.w - 320
      target_y = grid.h / 2

      cx = lerp(
        tr[:start_x] + tr[:start_w] / 2,
        target_x, progress
      )

      cy = lerp(
        tr[:start_y] + tr[:start_h] / 2,
        target_y, progress
      )

      scale = 1.0 - 0.93 * progress
    else
      cx = lerp(
        tr[:start_x] + tr[:start_w] / 2,
        grid.w + 150, progress
      )

      cy = lerp(
        tr[:start_y] + tr[:start_h] / 2,
        grid.h + 100, progress
      )

      scale = 1.0 - 0.65 * progress
    end

    p.w = tr[:start_w] * scale
    p.h = tr[:start_h] * scale
    p.x = cx - p.w / 2
    p.y = cy - p.h / 2

    tr[:flash] = clamp01(
      (t - TRANSITION_FLASH_START) /
      (TRANSITION_TICKS - TRANSITION_FLASH_START).to_f
    )

    finish_transition if t >= TRANSITION_TICKS
  end

  def finish_transition
    tr = state.transition
    p = state.player

    p.w = tr[:start_w]
    p.h = tr[:start_h]
    p.x = state.player_start[:x]
    p.y = state.player_start[:y]

    state.transition = nil
    state.effects = []
    state.player_effects = []
    state.shots = []
    state.enemy_shots = []
    state.powerups = []
    state.powerup_timer = 450

    state.hp = PLAYER_MAX_HP
    state.invuln = PLAYER_INVULN
    state.shield_timer = 0
    state.speed_timer = 0
    state.fade = FADE_TICKS

    reset_combo
    start_world(next_world_index)
    apply_selected_ship
    state.game_state = :playing
  end

  # ============================================================
  # GEOMETRY
  # ============================================================

  def clamp(v, lo, hi)
    [[v, lo].max, hi].min
  end

  def clamp01(v)
    clamp(v, 0.0, 1.0)
  end

  def lerp(a, b, t)
    a + (b - a) * t
  end

  def ease(t)
    t = clamp01(t)
    t * t * (3 - 2 * t)
  end

  def inside?(px, py, x, y, w, h)
    px >= x && px <= x + w &&
      py >= y && py <= y + h
  end

  def rect_for(obj)
    if obj.is_a?(Hash)
      obj
    else
      { x: obj.x, y: obj.y, w: obj.w, h: obj.h }
    end
  end

  def hit?(a, b)
    args.geometry.intersect_rect?(
      rect_for(a), rect_for(b)
    )
  end

  def shrink(obj, pct)
    r = rect_for(obj)

    {
      x: r[:x] + r[:w] * pct,
      y: r[:y] + r[:h] * pct,
      w: r[:w] * (1 - 2 * pct),
      h: r[:h] * (1 - 2 * pct)
    }
  end

  def boss_hitbox(b)
    if world[:boss][:type] == :creature
      {
        x: b[:x] + b[:w] * 0.37,
        y: b[:y] + b[:h] * 0.27,
        w: b[:w] * 0.26,
        h: b[:h] * 0.46
      }
    else
      shrink(b, 0.18)
    end
  end

  def shot_hitbox(s)
    {
      x: s[:x] + s[:w] * 0.1,
      y: s[:y] + s[:h] * 0.15,
      w: s[:w] * 0.8,
      h: s[:h] * 0.7
    }
  end

  def bullet_hitbox(s)
    r = s[:hit_r] || 12
    cx = s[:x] + s[:w] / 2
    cy = s[:y] + s[:h] / 2

    {
      x: cx - r,
      y: cy - r,
      w: r * 2,
      h: r * 2
    }
  end

  def angle_to_player(cx, cy)
    p = state.player

    dx = p.x + p.w / 2 - cx
    dy = p.y + p.h / 2 - cy

    Math.atan2(dy, dx) * 180 / Math::PI
  end

  # ============================================================
  # RENDERING
  # ============================================================

  def render_game
    if state.game_state == :ship_select
      render_ship_selection
      return
    end

    render_background
    outputs.sprites << state.planets
    render_transition_planet

    outputs.sprites << state.meteors
    outputs.sprites << state.ufos

    render_spaceship_boss_engine
    render_boss
    render_shots
    render_powerups
    render_effects

    blink = state.invuln > 0 &&
      Kernel.tick_count % 8 < 4

    unless blink || state.game_state == :game_over
      render_engine
      render_player
      render_player_shield
      render_player_powerup_effects
    end

    render_transition_fx
    render_hud
    render_banner
    render_overlay
    render_fade
    render_touch_buttons
  end

  # ============================================================
  # BACKGROUND
  # ============================================================

  def render_background
    tint = state.bg_tint || [255, 255, 255]

    if planet_world?
      offset = state.bg_scroll || 0

      2.times do |i|
        outputs.sprites << {
          x: i * grid.w - offset,
          y: 0,
          w: grid.w,
          h: grid.h,
          path: state.bg,
          r: tint[0],
          g: tint[1],
          b: tint[2]
        }
      end
    else
      outputs.sprites << {
        x: 0, y: 0,
        w: grid.w,
        h: grid.h,
        path: state.bg,
        r: tint[0],
        g: tint[1],
        b: tint[2]
      }
    end
  end

  # ============================================================
  # SHIP SELECTION
  # ============================================================

  def render_ship_selection
    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,
      r: 8, g: 14, b: 35
    }

    outputs.labels << {
      x: 640, y: 610,
      text: "SPACE GALACTICA",
      size_px: 75,
      anchor_x: 0.5,
      r: 130, g: 210, b: 255
    }

    outputs.labels << {
      x: 640, y: 535,
      text: "SELECT YOUR SPACESHIP",
      size_px: 34,
      anchor_x: 0.5,
      r: 255, g: 255, b: 255
    }

    SHIP_NAMES.each_with_index do |color, i|
      x = 210 + i * 230
      selected = state.ship_index == i

      outputs.solids << {
        x: x, y: 230,
        w: 180, h: 210,
        r: selected ? 35 : 20,
        g: selected ? 90 : 30,
        b: selected ? 145 : 60
      }

      if selected
        outputs.borders << {
          x: x, y: 230,
          w: 180, h: 210,
          r: 100, g: 220, b: 255
        }
      end

      path = SHIP_COLORS[color]

      if gtk.stat_file(path)
        outputs.sprites << {
          x: x + 30,
          y: 290,
          w: 120, h: 120,
          path: path,
          angle: color == :orange ?
            ORANGE_ANGLE : SHIP_ANGLE
        }
      end

      outputs.labels << {
        x: x + 90,
        y: 265,
        text: color.to_s.upcase,
        size_px: 23,
        anchor_x: 0.5,
        r: 255, g: 255, b: 255
      }
    end

    outputs.solids << {
      x: 480, y: 95,
      w: 320, h: 80,
      r: 40, g: 160, b: 110
    }

    outputs.labels << {
      x: 640, y: 135,
      text: "START GAME",
      size_px: 32,
      anchor_x: 0.5,
      anchor_y: 0.5,
      r: 255, g: 255, b: 255
    }
  end

  # ============================================================
  # PLAYER ENGINE
  # ============================================================

  def render_engine
    frames = valid_frames(ENGINE_FRAMES)
    return if frames.empty?

    p = state.player

    index = (
      Kernel.tick_count / ENGINE_SPEED
    ) % frames.length

    length = p.w * (
      state.engine_boost ?
      ENGINE_MOVING_LENGTH : ENGINE_IDLE_LENGTH
    )

    thickness = p.h * ENGINE_THICKNESS

    outputs.sprites << {
      x: p.x - length * 0.85,
      y: p.y + p.h / 2 - thickness / 2,
      w: length,
      h: thickness,
      path: frames[index],
      angle: ENGINE_ANGLE,
      a: 235
    }
  end

  def render_player
    p = state.player

    outputs.sprites << {
      x: p.x,
      y: p.y,
      w: p.w,
      h: p.h,
      path: p.path,
      angle: selected_ship_angle
    }
  end

  # ============================================================
  # PLAYER SHIELD - FRONT FACING
  # ============================================================

  def render_player_shield
    return unless state.shield_timer > 0
    return unless state.game_state == :playing

    p = state.player
    frames = valid_frames(SHIELD_EFFECT_FRAMES)
    return if frames.empty?

    frame = (
      Kernel.tick_count / POWERUP_ANIMATION_SPEED
    ) % frames.length

    shield_w = p.w * 0.65
    shield_h = p.h * 1.35

    shield_x = p.x + p.w * 0.75
    shield_y = p.y + p.h / 2 - shield_h / 2

    outputs.sprites << {
      x: shield_x,
      y: shield_y,
      w: shield_w,
      h: shield_h,
      path: frames[frame],
      angle: -90,
      a: 185
    }
  end

  # ============================================================
  # PLAYER POWER-UP EFFECTS
  # ============================================================

  def render_player_powerup_effects
    p = state.player

    state.player_effects.each do |fx|
      elapsed = Kernel.tick_count - fx[:born]

      if fx[:type] == :repair
        frames = valid_frames(STAR_EFFECT_FRAMES)
        next if frames.empty?

        frame = (
          elapsed / POWERUP_ANIMATION_SPEED
        ) % frames.length

        outputs.sprites << {
          x: p.x - 20,
          y: p.y - 20,
          w: p.w + 40,
          h: p.h + 40,
          path: frames[frame],
          a: 200
        }

      elsif fx[:type] == :speed
        next unless gtk.stat_file(SPEED_EFFECT)

        outputs.sprites << {
          x: p.x - 35,
          y: p.y + p.h / 2 - 35,
          w: 70,
          h: 70,
          path: SPEED_EFFECT,
          angle: -90,
          a: 180
        }
      end
    end
  end

  # ============================================================
  # SPACESHIP BOSS ENGINE
  # ============================================================

def render_spaceship_boss_engine
  b = state.boss
  return unless b
  return if b[:dying]

  cfg = world[:boss]
  return unless cfg[:type] == :spaceship

  number = cfg[:ship_number] || 1
  animations = SPACESHIP_ANIMATIONS[number]
  return unless animations

  turbo = boss_phase(b) == 3

  frames = valid_frames(
    turbo ? animations[:turbo] : animations[:normal]
  )

  if frames.empty? && turbo
    frames = valid_frames(animations[:normal])
  end

  return if frames.empty?

  frame = (
    Kernel.tick_count / SPACESHIP_ENGINE_SPEED
  ) % frames.length

  # Engine exhaust trails behind a left-facing boss.
  exhaust_w = b[:w] * 0.42
  exhaust_h = b[:h] * 0.22

  exhaust_x = b[:x] + b[:w] * 0.82
  exhaust_y = b[:y] + b[:h] / 2 - exhaust_h / 2

  outputs.sprites << {
    x: exhaust_x,
    y: exhaust_y,
    w: exhaust_w,
    h: exhaust_h,
    path: frames[frame],

    # Rotate the exhaust to extend toward the right.
    angle: 0,
    a: 230
  }
end


  # ============================================================
  # BOSS RENDERING
  # ============================================================

  def render_boss
    b = state.boss
    return unless b

    cfg = world[:boss]

    if cfg[:type] == :spaceship && b[:dying]
      frames = b[:explosion_frames] || []

      if frames.any?
        elapsed = Kernel.tick_count -
          (b[:explosion_start] || Kernel.tick_count)

        index = [
          elapsed / SPACESHIP_EXPLOSION_SPEED,
          frames.length - 1
        ].min

        outputs.sprites << {
          x: b[:x],
          y: b[:y],
          w: b[:w],
          h: b[:h],
          path: frames[index]
        }
      end

      return
    end

    if b[:path]
outputs.sprites << {
  x: b[:x],
  y: b[:y],
  w: b[:w],
  h: b[:h],
  path: b[:path],
  r: b[:r],
  g: b[:flash] > 0 ? 120 : b[:g],
  b: b[:flash] > 0 ? 120 : b[:b],

  # Enemy spaceships face LEFT toward the player.
  # Planet monsters keep their own orientation.
  flip_horizontally:
    cfg[:type] == :spaceship ? true :
    (cfg[:flip_horizontally] || false)
}
    else
      outputs.solids << {
        x: b[:x],
        y: b[:y],
        w: b[:w],
        h: b[:h],
        r: 150, g: 30, b: 60
      }

      outputs.labels << {
        x: b[:x] + b[:w] / 2,
        y: b[:y] + b[:h] / 2,
        text: "BOSS SPRITE MISSING",
        size_px: 25,
        anchor_x: 0.5,
        anchor_y: 0.5,
        r: 255, g: 255, b: 255
      }
    end
  end

  # ============================================================
  # THIN PLASMA LASERS
  # ============================================================

  def render_shots
    state.shots.each do |s|
      next if s[:dead]

      if s[:type] == :normal
        cx = s[:x] + s[:w] / 2
        cy = s[:y] + s[:h] / 2

        outputs.sprites << {
          x: cx - 5,
          y: cy - 36,
          w: 10,
          h: 72,
          path: NORMAL_SHOT,
          angle: -90
        }
      else
        outputs.sprites << {
          x: s[:x],
          y: s[:y],
          w: s[:w],
          h: s[:h],
          path: s[:path],
          angle: s[:angle]
        }
      end
    end

    state.enemy_shots.each do |s|
      next if s[:dead]

      outputs.sprites << {
        x: s[:x],
        y: s[:y],
        w: s[:w],
        h: s[:h],
        path: s[:path],
        angle: s[:angle]
      }
    end
  end

  def render_effects
    state.effects.each do |fx|
      elapsed = Kernel.tick_count - fx[:born]
      index = elapsed / fx[:speed]

      next if index >= fx[:frames].length

      outputs.sprites << {
        x: fx[:x],
        y: fx[:y],
        w: fx[:w],
        h: fx[:h],
        path: fx[:frames][index]
      }
    end
  end

  # ============================================================
  # ORIGINAL POWER-UP SPRITES
  # ============================================================

  def render_powerups
    return unless state.game_state == :playing

    state.powerups.each do |p|
      path = POWERUP_PATHS[p[:type]]

      unless path && gtk.stat_file(path)
        path = POWERUP_FALLBACK
      end

      if gtk.stat_file(path)
        outputs.sprites << {
          x: p[:x],
          y: p[:y],
          w: p[:w],
          h: p[:h],
          path: path
        }
      else
        outputs.solids << {
          x: p[:x],
          y: p[:y],
          w: p[:w],
          h: p[:h],
          r: 70, g: 170, b: 255
        }
      end
    end
  end

  # ============================================================
  # TRANSITION VISUALS
  # ============================================================

  def render_transition_planet
    tr = state.transition
    return unless tr
    return unless tr[:type] == :descending

    slide = ease(tr[:t] / 80.0)

    start_cx = grid.w + 370
    end_cx = grid.w - 440

    cx = lerp(start_cx, end_cx, slide)

    size = DESCENT_PLANET_SIZE * (
      1.0 + ease((tr[:t] - 60) / 130.0) * 0.45
    )

    if gtk.stat_file(tr[:planet])
      outputs.sprites << {
        x: cx - size / 2,
        y: grid.h / 2 - size / 2,
        w: size,
        h: size,
        path: tr[:planet]
      }
    end
  end

  def render_transition_fx
    tr = state.transition
    return unless tr

    color = tr[:type] == :descending ?
      [255, 140, 40] : [100, 180, 255]

    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,
      r: color[0],
      g: color[1],
      b: color[2],
      a: (80 * ease(tr[:t] / 190.0)).to_i
    }

    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,
      r: 255, g: 255, b: 255,
      a: (255 * tr[:flash]).to_i
    }
  end

  # ============================================================
  # HUD
  # ============================================================

  def render_hud
    return if [:descending, :ascending].include?(
      state.game_state
    )

    outputs.labels << {
      x: 40, y: grid.h - 38,
      text: "#{world[:name]} - Wave #{state.wave}/3",
      size_px: 25,
      r: 255, g: 255, b: 255
    }

    outputs.labels << {
      x: 40, y: grid.h - 72,
      text: "Score: #{state.score}",
      size_px: 22,
      r: 255, g: 255, b: 255
    }

    outputs.labels << {
      x: 40, y: grid.h - 106,
      text: "PLAYER HP",
      size_px: 19,
      r: 255, g: 255, b: 255
    }

    outputs.solids << {
      x: 40, y: grid.h - 135,
      w: 240, h: 18,
      r: 45, g: 45, b: 55
    }

    outputs.solids << {
      x: 40, y: grid.h - 135,
      w: 240 * clamp01(state.hp.to_f / PLAYER_MAX_HP),
      h: 18,
      r: 60, g: 220, b: 100
    }

    outputs.labels << {
      x: 320, y: grid.h - 105,
      text: "COMBO: #{state.combo}/10",
      size_px: 20,
      r: 255, g: 255, b: 255
    }

    outputs.solids << {
      x: 320, y: grid.h - 135,
      w: 220, h: 18,
      r: 45, g: 45, b: 55
    }

    outputs.solids << {
      x: 320, y: grid.h - 135,
      w: 220 * clamp01(state.combo.to_f / 10),
      h: 18,
      r: 100, g: 170, b: 255
    }

    b = state.boss

    if b
      ratio = clamp01(b[:hp].to_f / b[:max_hp])

      outputs.labels << {
        x: 600, y: grid.h - 40,
        text: "#{world[:name].upcase} BOSS",
        size_px: 24,
        r: 255, g: 255, b: 255
      }

      outputs.solids << {
        x: 600, y: grid.h - 75,
        w: 600, h: 24,
        r: 45, g: 45, b: 55
      }

      outputs.solids << {
        x: 600, y: grid.h - 75,
        w: 600 * ratio, h: 24,
        r: 230, g: 55, b: 65
      }
    end

    if state.shield_timer > 0
      outputs.labels << {
        x: 40, y: grid.h - 190,
        text: "SHIELD: #{(state.shield_timer / 60.0).ceil}s",
        size_px: 20,
        r: 100, g: 210, b: 255
      }
    end

    if state.speed_timer > 0
      outputs.labels << {
        x: 40, y: grid.h - 220,
        text: "SPEED: #{(state.speed_timer / 60.0).ceil}s",
        size_px: 20,
        r: 255, g: 220, b: 70
      }
    end
  end

  def render_banner
    return unless state.game_state == :playing
    return unless state.banner_timer > 0

    alpha = clamp(state.banner_timer * 4, 0, 255)

    outputs.labels << {
      x: grid.w / 2,
      y: grid.h / 2 + 140,
      text: state.banner_text,
      size_px: 65,
      anchor_x: 0.5,
      r: 255,
      g: state.wave == 3 ? 80 : 255,
      b: state.wave == 3 ? 80 : 255,
      a: alpha
    }

    if state.banner_sub
      outputs.labels << {
        x: grid.w / 2,
        y: grid.h / 2 + 80,
        text: state.banner_sub,
        size_px: 36,
        anchor_x: 0.5,
        r: 200, g: 220, b: 255,
        a: alpha
      }
    end
  end

  # ============================================================
  # END SCREENS
  # ============================================================

  def render_overlay
    return if [
      :playing, :descending, :ascending
    ].include?(state.game_state)

    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,
      r: 0, g: 0, b: 0, a: 140
    }

    if state.game_state == :world_clear
      transition_text = planet_world? ?
        "Press ENTER to ascend into space" :
        "Press ENTER to descend to the next planet"

      lines = [
        ["#{world[:name].upcase} CLEARED!", 70, 60],
        ["Score: #{state.score}", 36, -10],
        [transition_text, 34, -70],
        ["Press SPACE to restart", 28, -120]
      ]
    else
      title = state.game_state == :victory ?
        "YOU WIN!" : "GAME OVER"

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

  def render_fade
    return unless state.fade > 0

    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,
      r: 255, g: 255, b: 255,
      a: (255 * state.fade / FADE_TICKS.to_f).to_i
    }
  end

  def render_touch_buttons
    return unless state.touch_detected ||
      SHOW_TOUCH_ON_DESKTOP

    if state.game_state == :playing
      outputs.solids << {
        x: TOUCH_JOYSTICK_X - 85,
        y: TOUCH_JOYSTICK_Y - 85,
        w: 170, h: 170,
        r: 70, g: 120, b: 220, a: 65
      }

      outputs.solids << {
        x: TOUCH_FIRE_X - 75,
        y: TOUCH_FIRE_Y - 75,
        w: 150, h: 150,
        r: 230, g: 60, b: 65, a: 130
      }

      outputs.labels << {
        x: TOUCH_FIRE_X,
        y: TOUCH_FIRE_Y,
        text: "FIRE",
        size_px: 32,
        anchor_x: 0.5,
        anchor_y: 0.5,
        r: 255, g: 255, b: 255
      }

    elsif [:world_clear, :game_over, :victory].include?(
      state.game_state
    )
      if state.game_state == :world_clear
        outputs.solids << {
          x: 470, y: 175,
          w: 340, h: 70,
          r: 40, g: 160, b: 110
        }

        outputs.labels << {
          x: 640, y: 210,
          text: "CONTINUE",
          size_px: 30,
          anchor_x: 0.5,
          anchor_y: 0.5,
          r: 255, g: 255, b: 255
        }
      end

      outputs.solids << {
        x: 470, y: 80,
        w: 340, h: 65,
        r: 170, g: 65, b: 65
      }

      outputs.labels << {
        x: 640, y: 112,
        text: "RESTART",
        size_px: 28,
        anchor_x: 0.5,
        anchor_y: 0.5,
        r: 255, g: 255, b: 255
      }
    end
  end
end

# ============================================================
# DRAGONRUBY ENTRY POINTS
# ============================================================

def tick(args)
  $game ||= Game.new
  $game.args = args
  $game.tick
end

def reset(args)
  $game = nil
end
