require "app/player"

class Game
  attr_gtk

  # ==========================================================
  # SPACE GALACTICA - ASSETS
  # ==========================================================

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

  # Boss ships live in <dir>/ShipN/ShipN.png (Ship6 is the Deep Space boss)
  SHIP_PARTS_DIR = "sprites/PNG_Parts&Spriter_Animation"

  SHIP_COLORS = {
    blue: "sprites/space_assets/playerShip1_blue.png",
    green: "sprites/space_assets/playerShip1_green.png",
    orange: "sprites/space_assets/playerShip1_orange.png",
    red: "sprites/space_assets/playerShip1_red.png"
  }

  SHIP_NAMES = [:blue, :green, :orange, :red]

  SHIP_ANGLE = -90

  ENGINE_FRAMES = (1..7).map do |i|
    "sprites/space_assets/Effects/fire#{i.to_s.rjust(2, '0')}.png"
  end

  ENGINE_SPEED = 4
  ENGINE_ANGLE = -90

  NORMAL_SHOT =
    "sprites/space_assets/Lasers/laserBlue01.png"

  ENEMY_SHOT =
    "sprites/space_assets/Lasers/laserRed01.png"

  SHOTS_DIR = "sprites/PNG_Animations/Shots"

  # ==========================================================
  # CUSTOM ANIMATED PROJECTILES / HAZARDS
  #
  # Each set points at a folder in sprites/ that follows the
  # pattern:  sprites/<folder>/PNG/<folder>_Frame_01.png ...
  # Frames that do not exist are skipped automatically, so a
  # wrong frame count never crashes the game.
  #
  #   frames        - explicit list of frame paths (used instead of folder)
  #   w, h          - size on screen
  #   angle_offset  - the direction the art faces (180 = faces left)
  #   rotate: false - never rotate (good for smoke/explosions)
  # ==========================================================

  CUSTOM_SHOTS = {
    # The dragon's own flame: sprites/planet_bosses/dragon/Fire_Attack1-6.png
    # If it flies backwards in game, change angle_offset to 180.
    dragon_fire: {
      frames: (1..6).map { |i| "sprites/planet_bosses/dragon/Fire_Attack#{i}.png" },
      w: 180, h: 180, angle_offset: 50
    },

    fire_spell: {
      folder: "Fire Spell", w: 80, h: 80, angle_offset: 0
    },
    fire_ball: {
      folder: "Fire Ball", w: 120, h: 90, angle_offset: 0
    },
    fire_arrow: {
      folder: "Fire Arrow", w: 110, h: 60, angle_offset: -180
    },
    water_spell: {
      folder: "Water Spell", w: 80, h: 80, angle_offset: -180
    },
    water_ball: {
      folder: "Water Ball", w: 120, h: 90, angle_offset: -180
    },
    water_arrow: {
      folder: "Water Arrow", w: 110, h: 60, angle_offset: -180
    },
    poison_smoke: {
      folder: "Poisonous Smoke", w: 90, h: 90, rotate: false
    },
    chemical_smoke: {
      folder: "Chemical Smoke", w: 120, h: 120, rotate: false
    },
    smoke: {
      folder: "Smoke", w: 90, h: 90, rotate: false
    },
    smoke_spell: {
      folder: "Smoke Spell", w: 90, h: 90, rotate: false
    },
    smoke_blow: {
      folder: "Smoke Blow", w: 120, h: 120, rotate: false
    },
    smoke_explosion: {
      folder: "Smoke Explosion", w: 120, h: 120, rotate: false
    }
  }

  # ==========================================================
  # HUD ASSETS
  # ==========================================================

  BOSS_HEALTH_BG =
    "sprites/space_assets/UI/buttonRed.png"

  PLAYER_LIFE_SPRITES = {
    blue: "sprites/space_assets/UI/playerLife1_blue.png",
    green: "sprites/space_assets/UI/playerLife1_green.png",
    orange: "sprites/space_assets/UI/playerLife1_orange.png",
    red: "sprites/space_assets/UI/playerLife1_red.png"
  }

  # ==========================================================
  # ORIGINAL POWER-UP SPRITES
  # ==========================================================

  POWERUP_PATHS = {
    shield: "sprites/space_assets/Power-ups/powerupBlue_shield.png",
    repair: "sprites/space_assets/Power-ups/powerupBlue_star.png",
    speed: "sprites/space_assets/Power-ups/powerupBlue_bolt.png"
  }

  POWERUP_FALLBACK =
    "sprites/space_assets/Power-ups/powerupBlue.png"

  SHIELD_EFFECT_FRAMES = (1..3).map do |i|
    "sprites/space_assets/Effects/shield#{i}.png"
  end

  STAR_EFFECT_FRAMES = (1..3).map do |i|
    "sprites/space_assets/Effects/star#{i}.png"
  end

  SPEED_EFFECT = "sprites/space_assets/Effects/speed.png"

  # ==========================================================
  # PLANET BACKGROUNDS
  # ==========================================================

  PLANET_MAP_1 =
    "sprites/planet-game-backgrounds/_PNG/1/1_game_background.png"

  PLANET_MAP_2 =
    "sprites/planet-game-backgrounds/_PNG/2/2_game_background.png"

  PLANET_MAP_3 =
    "sprites/planet-game-backgrounds/_PNG/3/3_game_background.png"

  PLANET_MAP_4 =
    "sprites/planet-game-backgrounds/_PNG/4/4_game_background.png"

  # ==========================================================
  # CUSTOM WORLD HAZARDS
  #
  # Each world can have its own:
  #   set               - animated set from CUSTOM_SHOTS (replaces meteors)
  #   sprites           - optional static sprite paths (used before set)
  #   aspect            - width / height of the hazard (2.0 = twice as wide)
  #   speed_multiplier
  #   size_multiplier
  #
  # Worlds with no set and no sprites keep the original meteors.
  # ==========================================================

  WORLD_HAZARDS = {
    "Deep Space" => {
      sprites: [],
      speed_multiplier: 1.0,
      size_multiplier: 1.0
    },

    "Ember Planet" => {
      set: :fire_arrow,
      aspect: 1.8,
      sprites: [],
      speed_multiplier: 1.1,
      size_multiplier: 0.8
    },

    "Nebula Sector" => {
      sprites: [],
      speed_multiplier: 1.0,
      size_multiplier: 1.0
    },

    "Frozen Planet" => {
      set: :water_arrow,
      aspect: 1.8,
      sprites: [],
      speed_multiplier: 1.0,
      size_multiplier: 0.9
    },

    "Crystal Expanse" => {
      sprites: [],
      speed_multiplier: 1.0,
      size_multiplier: 1.0
    },

    "Shadow Planet" => {
      set: :smoke,
      aspect: 1.0,
      sprites: [],
      speed_multiplier: 1.2,
      size_multiplier: 0.85
    },

    "Dark Orbit" => {
      sprites: [],
      speed_multiplier: 1.0,
      size_multiplier: 1.0
    },

    "Dragon Planet" => {
      set: :smoke_explosion,
      aspect: 1.0,
      sprites: [],
      speed_multiplier: 1.3,
      size_multiplier: 0.9
    }
  }

  DEFAULT_WORLD_HAZARD = {
    sprites: [],
    speed_multiplier: 1.0,
    size_multiplier: 1.0
  }

  # ==========================================================
  # PLANET BOSS ANIMATIONS
  # ==========================================================

  BOSS_FOLDER = "sprites/planet_bosses"

  def self.boss_frames(folder, action, count)
    (1..count).map do |i|
      "#{BOSS_FOLDER}/#{folder}/#{action}#{i}.png"
    end
  end

  DRAGON_ANIMATIONS = {
    idle: boss_frames("dragon", "Idle", 3),
    move: boss_frames("dragon", "Walk", 5),
    attack: boss_frames("dragon", "Attack", 4),
    hurt: boss_frames("dragon", "Hurt", 2),
    death: boss_frames("dragon", "Death", 5)
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

  DEMON_ANIMATIONS = {
    idle: boss_frames("demon", "Idle", 3),
    move: boss_frames("demon", "Walk", 6),
    attack: boss_frames("demon", "Attack", 4),
    hurt: boss_frames("demon", "Hurt", 2),
    death: boss_frames("demon", "Death", 6)
  }

  # ==========================================================
  # SPACESHIP BOSS EFFECTS
  # ==========================================================

  SHIP_ANIM_DIR = "sprites/PNG_Animations"

  def self.ship_engine_frames(number, turbo = false)
    mode = turbo ? "Turbo_flight" : "Normal_flight"
    prefix = "Ship#{number}_#{turbo ? 'turbo' : 'normal'}_flight"

    (1..30).map do |i|
      "#{SHIP_ANIM_DIR}/Exhaust/Ship#{number}/#{mode}/#{prefix}_#{i.to_s.rjust(3, '0')}.png"
    end
  end

  def self.ship_explosion_frames(number)
    (1..30).map do |i|
      "#{SHIP_ANIM_DIR}/Explosions/Ship#{number}_Explosion/Ship#{number}_Explosion_#{i.to_s.rjust(3, '0')}.png"
    end
  end

  # ==========================================================
  # DIFFICULTY SETTINGS
  # ==========================================================

  DIFFICULTIES = [:easy, :normal, :hard]

  DIFFICULTY_SETTINGS = {
    easy: {
      hp: 5,
      enemy_speed: 0.8,
      enemy_bullet_speed: 0.75,
      enemy_fire_rate: 0.8,
      boss_hp: 0.8,
      boss_speed: 0.8,
      powerup_frequency: 0.7
    },

    normal: {
      hp: 3,
      enemy_speed: 1.0,
      enemy_bullet_speed: 1.0,
      enemy_fire_rate: 1.0,
      boss_hp: 1.0,
      boss_speed: 1.0,
      powerup_frequency: 1.0
    },

    hard: {
      hp: 2,
      enemy_speed: 1.25,
      enemy_bullet_speed: 1.25,
      enemy_fire_rate: 1.3,
      boss_hp: 1.3,
      boss_speed: 1.2,
      powerup_frequency: 1.4
    }
  }

  # ==========================================================
  # GAME SETTINGS
  # ==========================================================

  PLAYER_INVULN = 90
  PLAYER_SHOT_SPEED = 16
  PLAYER_FIRE_RATE = 12

  SHIELD_DURATION = 300
  SPEED_DURATION = 360
  SPEED_MULTIPLIER = 1.5

  COMBO_TIMEOUT = 240
  POWER_DAMAGE = 3
  SUPER_DAMAGE = 6

  UFO_ENTRY_SPEED = 3
  UFO_SINE_SPEED = 0.05
  UFO_SINE_AMPLITUDE = 160
  UFO_CIRCLE_SPEED = 0.035

  BOSS_FIRE_MULT = 1.5
  BOSS_BULLET_MULT = 0.65
  BOSS_CAST_TICKS = 18 # wind-up before a creature's shot leaves its mouth

  TRANSITION_TICKS = 240
  FADE_TICKS = 70

  END_AFTER_FOURTH_PLANET = true

  # ==========================================================
  # WORLD WAVE GENERATOR
  # ==========================================================

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
            fire_rate: 150,
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
            fire_rate: 135,
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

  # ==========================================================
  # WORLDS
  #
  # Creature bosses use:
  #   shot          - basic attack projectile (number or CUSTOM_SHOTS key)
  #   special_shot  - special attack projectile
  #   special_damage- damage dealt by each special projectile
  #   special_anim  - animation played during the special attack
  #
  # Ground bosses (flying: false) also accept:
  #   ground_offset - nudges the boss up (+) or down (-) to fit the ground
  #   mouth         - { x:, y: } as a fraction of the sprite where shots spawn
  #   roam_left / roam_right - how far (px) they patrol around their spot
  # ==========================================================

  WORLDS = [
    {
      name: "Deep Space",
      type: :space,
      background: SPACE_BG,
      waves: make_waves(1, 2),
      boss: {
        type: :spaceship,
        ship_number: 1,
        sprite: SPACE_BOSS,
        hp: 60,
        w: 400,
        h: 400,
        speed: [3, 4.5, 6],
        fire_rate: [110, 95, 80],
        bullet_speed: [10, 12, 14],
        special_speed: 13,
        shot: 2
      }
    },

    {
      name: "Ember Planet",
      type: :planet,
      background: PLANET_MAP_1,
      landing_planet: PLANETS[2],
      scroll_speed: 3,
      waves: make_waves(1, 4),
      boss: {
        type: :creature,
        creature: :dragon,
        animations: DRAGON_ANIMATIONS,
        flying: false, # walks on the ground: left / right only
        flip_horizontally: true,
        ground_offset: -50, # more negative = feet lower, closer to the ground
        mouth: { x: 0.23, y: 0.38 }, # where the fire leaves the dragon
        hp: 100,
        w: 1200,
        h: 1100,
        speed: [2.5, 3.5, 4.5],
        fire_rate: [120, 105, 90],
        bullet_speed: [15, 17, 19],
        special_speed: 17,
        projectile_hits_ground: true,
        shot: :dragon_fire,
        special_shot: :fire_ball,
        special_damage: 2
      }
    },

    {
      name: "Nebula Sector",
      type: :space,
      background: "sprites/space_world3.png",
      waves: make_waves(2, 5),
      boss: {
        type: :spaceship,
        ship_number: 2,
        sprite: "#{SHIP_PARTS_DIR}/Ship2/Ship2.png",
        hp: 85,
        w: 420,
        h: 420,
        speed: [3, 4.5, 6],
        fire_rate: [105, 90, 75],
        bullet_speed: [11, 13, 15],
        special_speed: 14,
        shot: 5
      }
    },

    {
      name: "Frozen Planet",
      type: :planet,
      background: PLANET_MAP_2,
      landing_planet: PLANETS[4],
      scroll_speed: 3,
      waves: make_waves(2, 6),
      boss: {
        type: :creature,
        creature: :jinn,
        animations: JINN_ANIMATIONS,
        flying: true,
        flip_horizontally: true,
        hp: 100,
        w: 560, # smaller than before (was 750)
        h: 560,
        speed: [2.5, 3.5, 4.5],
        fire_rate: [125, 105, 85],
        bullet_speed: [13, 15, 17],
        special_speed: 16,
        shot: :water_spell,
        special_shot: :water_ball,
        special_damage: 2,
        special_anim: :magic
      }
    },

    {
      name: "Crystal Expanse",
      type: :space,
      background: "sprites/space_world5.png",
      waves: make_waves(3, 5),
      boss: {
        type: :spaceship,
        ship_number: 3,
        sprite: "#{SHIP_PARTS_DIR}/Ship3/Ship3.png",
        hp: 100,
        w: 420,
        h: 420,
        speed: [3, 4.5, 6],
        fire_rate: [100, 85, 70],
        bullet_speed: [12, 14, 16],
        special_speed: 15,
        shot: 5
      }
    },

    {
      name: "Shadow Planet",
      type: :planet,
      background: PLANET_MAP_3,
      landing_planet: PLANETS[6],
      scroll_speed: 4,
      waves: make_waves(3, 5),
      boss: {
        type: :creature,
        creature: :medusa,
        animations: MEDUSA_ANIMATIONS,
        flying: false,
        flip_horizontally: true,
        hp: 115,
        w: 850,
        h: 850,
        speed: [2, 3, 4],
        fire_rate: [125, 105, 85],
        bullet_speed: [12, 14, 16],
        special_speed: 15,
        shot: :poison_smoke,
        special_shot: :chemical_smoke,
        special_damage: 2,
        special_anim: :stone
      }
    },

    {
      name: "Dark Orbit",
      type: :space,
      background: "sprites/space_world7.png",
      waves: make_waves(4, 2),
      boss: {
        type: :spaceship,
        ship_number: 4,
        sprite: "#{SHIP_PARTS_DIR}/Ship4/Ship4.png",
        hp: 115,
        w: 420,
        h: 420,
        speed: [3, 4.5, 6],
        fire_rate: [100, 85, 70],
        bullet_speed: [13, 15, 17],
        special_speed: 16,
        shot: 2
      }
    },

    {
      name: "Dragon Planet",
      type: :planet,
      background: PLANET_MAP_4,
      landing_planet: PLANETS[8],
      scroll_speed: 4,
      waves: make_waves(4, 3),
      boss: {
        type: :creature,
        creature: :demon,
        animations: DEMON_ANIMATIONS,
        flying: false,
        flip_horizontally: true,
        hp: 125,
        w: 900,
        h: 900,
        speed: [2, 3, 4],
        fire_rate: [135, 115, 95],
        bullet_speed: [14, 16, 18],
        special_speed: 17,
        shot: :smoke_spell,
        special_shot: :smoke_blow,
        special_damage: 2
      }
    }
  ]

  # ==========================================================
  # SHORTCUTS
  # ==========================================================

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

  def difficulty
    DIFFICULTY_SETTINGS[state.difficulty || :normal]
  end

  def player_max_hp
    difficulty[:hp]
  end

  def selected_ship_color
    SHIP_NAMES[state.ship_index]
  end

  def next_world_index
    (state.world_index + 1) % WORLDS.length
  end

  # ==========================================================
  # MAIN LOOP
  # ==========================================================

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
    state.difficulty_index ||= 1
    state.difficulty ||= :normal

    state.score ||= 0
    state.hp = player_max_hp if state.hp.nil?
    state.invuln ||= 0
    state.prompt_timer ||= 0
    state.fade ||= 0
    state.fire_cooldown ||= 0
    state.pause_return_state ||= nil

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
    state.touch_presses ||= []

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

  # ==========================================================
  # ASSET HELPERS
  # ==========================================================

  def valid_frames(paths)
    @frame_cache ||= {}
    key = paths.join("|")

    @frame_cache[key] ||= paths.select do |path|
      gtk.stat_file(path)
    end
  end

  # Frames for a CUSTOM_SHOTS set, e.g. :fire_ball
  def custom_frames(key)
    cfg = CUSTOM_SHOTS[key]
    return [] unless cfg
    return valid_frames(cfg[:frames]) if cfg[:frames]

    folder = cfg[:folder]

    paths = (1..20).map do |i|
      "sprites/#{folder}/PNG/#{folder}_Frame_#{i.to_s.rjust(2, '0')}.png"
    end

    valid_frames(paths)
  end

  def shot_frames(number, kind = :flying)
    if number.is_a?(Symbol)
      return kind == :explosion ? [] : custom_frames(number)
    end

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

  def boss_frames_for(cfg, action)
    return [] unless cfg[:animations]
    valid_frames(cfg[:animations][action] || [])
  end

  # ==========================================================
  # CUSTOM HAZARD HELPERS
  # ==========================================================

  def current_hazard_config
    WORLD_HAZARDS[world[:name]] ||
      DEFAULT_WORLD_HAZARD
  end

  def current_hazard_sprites
    custom = (current_hazard_config[:sprites] || []).select do |path|
      gtk.stat_file(path)
    end

    custom.empty? ? METEORS : custom
  end

  # Animated hazard frames for the current world (empty = none)
  def current_hazard_frames
    set = current_hazard_config[:set]
    return [] unless set

    custom_frames(set)
  end

  # ==========================================================
  # WORLD MANAGEMENT
  # ==========================================================

  def start_world(index)
    state.world_index = index
    state.bg_scroll = 0.0

    requested = world[:background]

    if gtk.stat_file(requested)
      state.bg = requested
    else
      puts "MISSING BACKGROUND: #{requested}"
      state.bg = SPACE_BG
    end

    state.planets = []

    unless planet_world?
      state.planets << {
        x: 0,
        y: -150,
        w: 700,
        h: 700,
        path: PLANETS.sample,
        speed: 1
      }
    end

    start_wave(1)
  end

  def start_wave(number)
    cfg = world[:waves][number]

    state.wave = number
    state.wave_clear_timer = 90
    state.banner_timer = 150

    state.banner_text =
      number == 3 ? "WARNING! BOSS INCOMING" :
      "WAVE #{number}"

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

  # ==========================================================
  # HAZARD SPAWNING
  # ==========================================================

  def spawn_meteor(cfg, initial = false)
    hazard = current_hazard_config

    size = (
      Numeric.rand(50..150) *
      hazard[:size_multiplier]
    ).to_i

    size = [size, 20].max

    # Pick what this hazard looks like:
    #   1. custom static sprites  2. animated set  3. original meteors
    static_sprites = (hazard[:sprites] || []).select do |path|
      gtk.stat_file(path)
    end

    frames = static_sprites.empty? ? current_hazard_frames : []
    animated = !frames.empty?

    path =
      if !static_sprites.empty?
        static_sprites.sample
      elsif animated
        frames[0]
      else
        METEORS.sample
      end

    aspect = (animated || !static_sprites.empty?) ?
      (hazard[:aspect] || 1.0) : 1.0

    {
      x: grid.w + Numeric.rand(
        0..(initial ? 1500 : 400)
      ),
      y: Numeric.rand(0..(grid.h - size)),
      w: size,
      h: [(size / aspect).to_i, 20].max,
      path: path,
      frames: frames,
      born: Kernel.tick_count,
      speed: Numeric.rand(cfg[:speed]) *
        hazard[:speed_multiplier] *
        difficulty[:enemy_speed],
      vy: Numeric.rand(-2..2),
      spin: animated ? 0 : Numeric.rand(-3..3),
      angle: 0,
      dead: false
    }
  end

  def refill_meteors
    cfg = world[:waves][state.wave]

    while state.meteors.length < cfg[:meteors]
      state.meteors << spawn_meteor(cfg)
    end
  end

  # ==========================================================
  # UFO SPAWNING
  # ==========================================================

  def spawn_ufo(group, index)
    y = Numeric.rand(120..550)
    hover_x = 600 + (index % 3) * 180

    {
      x: grid.w + 100 + index * 220,
      y: y,
      base_y: y,
      w: 100,
      h: 100,
      path: group[:sprite],
      hp: group[:hp],
      move: group[:move],
      shoot: group[:shoot],
      hover_x: hover_x,
      fire_rate: group[:fire_rate],
      fire_timer: 15 + index * 8,
      bullet_speed: group[:bullet_speed],
      shot: group[:shot],
      phase: Numeric.rand(0..360),
      orbit: 0.0,
      vy: index.even? ? 3.5 : -3.5,
      dead: false
    }
  end

  # ==========================================================
  # ORIGINAL UFO MOVEMENT
  # ==========================================================

  def move_ufo(u)
    mult = difficulty[:enemy_speed]
    entry = UFO_ENTRY_SPEED * mult

    case u[:move]
    when :zigzag
      if u[:x] > u[:hover_x]
        u[:x] = [u[:x] - entry, u[:hover_x]].max
      else
        u[:y] += u[:vy] * mult

        if u[:y] <= 20
          u[:y] = 20
          u[:vy] = u[:vy].abs
        elsif u[:y] + u[:h] >= grid.h - 20
          u[:y] = grid.h - 20 - u[:h]
          u[:vy] = -u[:vy].abs
        end
      end

    when :circle
      radius = 90

      if u[:x] > u[:hover_x] + radius
        u[:x] = [
          u[:x] - entry,
          u[:hover_x] + radius
        ].max
      else
        u[:orbit] += UFO_CIRCLE_SPEED * mult

        u[:x] = u[:hover_x] +
          Math.cos(u[:orbit]) * radius

        u[:y] = u[:base_y] +
          Math.sin(u[:orbit]) * radius
      end

    else
      u[:x] -= entry if u[:x] > u[:hover_x]

      t = (Kernel.tick_count + u[:phase]) *
        UFO_SINE_SPEED * mult

      u[:y] = clamp(
        u[:base_y] + Math.sin(t) * 160,
        0,
        grid.h - u[:h]
      )
    end
  end

  def shoot_ufo(u)
    return if u[:x] > grid.w - u[:w]

    u[:fire_timer] -= 1
    return if u[:fire_timer] > 0

    cx = u[:x] + 10
    cy = u[:y] + u[:h] / 2

    base = angle_to_player(cx, cy)

    offsets =
      u[:shoot] == :spread3 ? [-12, 0, 12] : [0]

    offsets.each do |off|
      fire_enemy_shot(
        cx, cy, base + off,
        u[:bullet_speed], u[:shot]
      )
    end

    u[:fire_timer] = [
      (u[:fire_rate] *
       difficulty[:enemy_fire_rate]).to_i +
       Numeric.rand(0..40),
      1
    ].max
  end

  # ==========================================================
  # BOSS SPAWNING
  # ==========================================================

  def spawn_boss(cfg)
    sprite =
      if cfg[:type] == :creature
        boss_frames_for(cfg, :idle)[0]
      else
        gtk.stat_file(cfg[:sprite]) ? cfg[:sprite] : SPACE_BOSS
      end

    hp = (cfg[:hp] * difficulty[:boss_hp]).ceil
    flying = cfg[:type] == :spaceship || cfg[:flying]

    state.boss = {
      x: grid.w + 50,
      y: flying ?
        (grid.h - cfg[:h]) / 2.0 :
        boss_ground_y(cfg),
      w: cfg[:w],
      h: cfg[:h],
      hp: hp,
      max_hp: hp,
      path: sprite,
      dir: cfg[:type] == :spaceship ? 1 : -1,
      flying: flying,
      fire_timer: 100,
      special_timer: cfg[:creature] == :dragon ? 150 : 240,
      entered: false,
      queued: nil,
      animation: :idle,
      animation_start: Kernel.tick_count,
      flash: 0,
      dying: false,
      explosion_frames: [],
      explosion_start: 0,
      flight_vx: -1.0,
      flight_vy: 1.0
    }
  end

  def boss_phase(b)
    ratio = b[:hp].to_f / b[:max_hp]
    return 1 if ratio > 0.66
    return 2 if ratio > 0.33
    3
  end

  # Where a walking boss stands (feet on the ground)
  def boss_ground_y(cfg)
    -cfg[:h] * 0.12 + (cfg[:ground_offset] || 0)
  end

  # Walking bosses face the way they walk, and turn to face the
  # player while attacking. Ships and flying bosses always face left.
  def boss_facing_left?(b)
    cfg = world[:boss]
    return true unless cfg[:type] == :creature && !b[:flying]

    # Ground monsters may walk backward, but they keep facing the player.
    # This prevents the dragon/demon/medusa from doing a full 180 every
    # time their patrol direction changes.
    p = state.player
    p.x + p.w / 2 < b[:x] + b[:w] / 2
  end

  # [x, y] where this boss's shots leave it
  def boss_mouth(b, cfg)
    m = cfg[:mouth] || { x: 0.25, y: 0.55 }
    mx = boss_facing_left?(b) ? m[:x] : 1.0 - m[:x]

    [b[:x] + b[:w] * mx, b[:y] + b[:h] * m[:y]]
  end

  # ==========================================================
  # BOSS MOVEMENT
  # ==========================================================

  def update_boss
    b = state.boss
    return unless b

    cfg = world[:boss]

    if b[:dying]
      update_boss_death(b, cfg)
      return
    end

    b[:flash] -= 1 if b[:flash] > 0

    phase = boss_phase(b)
    i = phase - 1

    speed = cfg[:speed][i] *
      difficulty[:boss_speed]

    if cfg[:type] == :spaceship
      target_x = grid.w - b[:w] - 30

      if b[:x] > target_x
        b[:x] = [b[:x] - 2, target_x].max
        return
      end

      b[:y] += b[:dir] * speed

      if b[:y] <= 0
        b[:y] = 0
        b[:dir] = 1
      elsif b[:y] + b[:h] >= grid.h
        b[:y] = grid.h - b[:h]
        b[:dir] = -1
      end

    elsif b[:flying]
      # Flying creature bosses stay fully on-screen and roam in two dimensions.
      # This is especially important for the large Jinn sprite.
      right_limit = grid.w - b[:w] - 35
      left_limit  = [grid.w * 0.48, right_limit - 260].min
      left_limit  = [left_limit, 40].max
      top_limit   = grid.h - b[:h] - 20
      bottom_limit = 20

      unless b[:entered]
        target_x = right_limit
        b[:x] = [b[:x] - 5, target_x].max
        b[:y] = clamp(b[:y], bottom_limit, top_limit)
        if b[:x] <= target_x
          b[:entered] = true
          b[:flight_vx] = -1.0
          b[:flight_vy] = 1.0
        end
        return
      end

      roam_speed = speed * 0.72
      b[:x] += b[:flight_vx] * roam_speed
      b[:y] += b[:flight_vy] * roam_speed * 0.72

      if b[:x] <= left_limit
        b[:x] = left_limit
        b[:flight_vx] = 1.0
      elsif b[:x] >= right_limit
        b[:x] = right_limit
        b[:flight_vx] = -1.0
      end

      if b[:y] <= bottom_limit
        b[:y] = bottom_limit
        b[:flight_vy] = 1.0
      elsif b[:y] >= top_limit
        b[:y] = top_limit
        b[:flight_vy] = -1.0
      end

    else
      # Ground bosses (dragon, medusa, demon): walk left / right only.
      # They slide in from the right, then patrol a lane around their
      # entry spot (roam_left px to the left, roam_right to the right).
      target_x = grid.w - b[:w] * 0.72
      b[:y] = boss_ground_y(cfg)

      unless b[:entered]
        b[:x] = [b[:x] - 3, target_x].max
        b[:entered] = true if b[:x] <= target_x
        return
      end

      left_limit = target_x - (cfg[:roam_left] || 260)
      right_limit = target_x + (cfg[:roam_right] || 60)

      b[:x] += b[:dir] * speed * 0.8

      if b[:x] <= left_limit
        b[:x] = left_limit
        b[:dir] = 1
      elsif b[:x] >= right_limit
        b[:x] = right_limit
        b[:dir] = -1
      end
    end

    b[:fire_timer] -= 1
    b[:special_timer] -= 1

    cx, cy = boss_mouth(b, cfg)

    # a queued creature attack fires once its wind-up animation is done
    if b[:queued] && Kernel.tick_count >= b[:queued][:at]
      kind = b[:queued][:kind]
      b[:queued] = nil

      if kind == :special
        fire_boss_special(b, cfg, cx, cy)
      else
        fire_boss_basic(b, cfg, cx, cy, phase, i)
      end
    end

    if b[:queued].nil? && b[:fire_timer] <= 0
      boss_attack(b, cfg, cx, cy, phase, i)

      b[:fire_timer] = [
        (cfg[:fire_rate][i] *
         BOSS_FIRE_MULT *
         difficulty[:enemy_fire_rate]).to_i,
        1
      ].max
    end

    special_ready = phase >= 2 || cfg[:creature] == :dragon

    if b[:queued].nil? && special_ready && b[:special_timer] <= 0
      boss_special_attack(b, cfg, cx, cy)
      b[:special_timer] = cfg[:creature] == :dragon ? 240 : (phase == 3 ? 210 : 300)
    end
  end

  # ==========================================================
  # BOSS ATTACKS
  #
  # Basic attack   -> cfg[:shot]          (1 damage)
  # Special attack -> cfg[:special_shot]  (cfg[:special_damage])
  # ==========================================================

  # Creatures play their attack animation first and the projectile
  # leaves their mouth BOSS_CAST_TICKS later; ships fire instantly.
  def boss_attack(b, cfg, cx, cy, phase, i)
    if cfg[:type] == :creature
      play_boss_animation(b, :attack)

      b[:queued] = {
        at: Kernel.tick_count + BOSS_CAST_TICKS,
        kind: :basic
      }
    else
      fire_boss_basic(b, cfg, cx, cy, phase, i)
    end
  end

  def fire_boss_basic(b, cfg, cx, cy, phase, i)
    base = angle_to_player(cx, cy)

    offsets =
      case phase
      when 1 then [0]
      when 2 then [-16, 0, 16]
      else [-25, 0, 25]
      end

    offsets.each do |off|
      fire_enemy_shot(
        cx, cy, base + off,
        cfg[:bullet_speed][i] * BOSS_BULLET_MULT,
        cfg[:shot],
        1
      )
    end
  end

  def boss_special_attack(b, cfg, cx, cy)
    if cfg[:type] == :creature
      anim = cfg[:special_anim]
      anim = :attack unless anim && !boss_frames_for(cfg, anim).empty?
      play_boss_animation(b, anim)

      b[:queued] = {
        at: Kernel.tick_count + BOSS_CAST_TICKS,
        kind: :special
      }
    else
      fire_boss_special(b, cfg, cx, cy)
    end
  end

  def fire_boss_special(b, cfg, cx, cy)
    aim = boss_facing_left?(b) ? 180 : 0

    if cfg[:creature] == :dragon
      # One large, fast Fire Ball makes the special visually unmistakable.
      fire_enemy_shot(
        cx, cy, angle_to_player(cx, cy), (cfg[:special_speed] || 17.0),
        cfg[:special_shot] || :fire_ball,
        cfg[:special_damage] || 2
      )
      return
    end

    special_speed = cfg[:special_speed] || 13.0

    [-30, -15, 0, 15, 30].each do |off|
      fire_enemy_shot(
        cx, cy, aim + off, special_speed,
        cfg[:special_shot] || cfg[:shot],
        cfg[:special_damage] || 1
      )
    end
  end

  def play_boss_animation(b, action)
    return if b[:dying] && action != :death
    b[:animation] = action
    b[:animation_start] = Kernel.tick_count
  end

  def update_boss_animation(b, cfg)
    return unless cfg[:type] == :creature

    # Ground bosses play their walk cycle instead of standing idle
    if !b[:dying] && !b[:flying] &&
       b[:animation] == :idle &&
       !boss_frames_for(cfg, :move).empty?
      play_boss_animation(b, :move)
    end

    action = b[:animation]
    frames = boss_frames_for(cfg, action)

    frames = boss_frames_for(cfg, :idle) if frames.empty?
    return if frames.empty?

    elapsed = Kernel.tick_count - b[:animation_start]
    speed = action == :death ? 8 : 6

    index =
      if action == :death
        [elapsed / speed, frames.length - 1].min
      else
        (elapsed / speed) % frames.length
      end

    b[:path] = frames[index]

    if !b[:dying] &&
       [:attack, :hurt, :magic, :stone].include?(action) &&
       elapsed >= frames.length * speed
      play_boss_animation(b, b[:flying] ? :idle : :move)
    end
  end

  def update_boss_death(b, cfg)
    elapsed = Kernel.tick_count - b[:animation_start]

    if cfg[:type] == :creature
      frames = boss_frames_for(cfg, :death)

      if frames.empty? || elapsed >= frames.length * 8
        finish_boss_death
      else
        b[:path] = frames[elapsed / 8]
      end
    else
      frames = b[:explosion_frames]

      if frames.empty? || elapsed >= frames.length * 5
        finish_boss_death
      end
    end
  end

  def damage_boss(amount)
    b = state.boss
    return unless b
    return if b[:dying]

    b[:hp] -= amount
    b[:flash] = 5

    if b[:hp] <= 0
      b[:hp] = 0
      b[:dying] = true
      b[:animation_start] = Kernel.tick_count

      state.enemy_shots = []

      if world[:boss][:type] == :creature
        b[:animation] = :death
      else
        number = world[:boss][:ship_number] || 1
        b[:explosion_frames] =
          valid_frames(self.class.ship_explosion_frames(number))
      end
    elsif world[:boss][:type] == :creature
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
    state.prompt_timer = 45

    state.planets_cleared += 1 if planet_world?

    if END_AFTER_FOURTH_PLANET &&
       state.planets_cleared >= 4
      state.game_state = :victory
    else
      state.game_state = :world_clear
    end
  end

  # ==========================================================
  # PROJECTILES
  # ==========================================================

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

    state.shots << {
      x: p.x + p.w - 5,
      y: p.y + p.h / 2 - 5,
      w: type == :normal ? 72 : 100,
      h: type == :normal ? 10 : 30,
      path: frames.empty? ? NORMAL_SHOT : frames[0],
      frames: frames,
      born: Kernel.tick_count,
      angle: frames.empty? ? -90 : 0,
      damage: damage,
      type: type,
      number: number,
      dead: false
    }
  end

  # number can be a shot folder number (2, 5...) or a CUSTOM_SHOTS
  # key (:fire_ball, :water_spell...). If the art is missing, it falls
  # back to the red laser so the game never breaks.
  def fire_enemy_shot(cx, cy, deg, speed, number = nil, damage = 1)
    speed *= difficulty[:enemy_bullet_speed]
    rad = deg * Math::PI / 180

    frames = number ? shot_frames(number) : []
    set = number.is_a?(Symbol) ? CUSTOM_SHOTS[number] : nil

    w = (set && !frames.empty?) ? set[:w] : 44
    h = (set && !frames.empty?) ? set[:h] : 44

    angle =
      if frames.empty?
        deg - 90
      elsif set
        set[:rotate] == false ? 0 : deg + (set[:angle_offset] || 0)
      else
        deg
      end

    state.enemy_shots << {
      x: cx - w / 2,
      y: cy - h / 2,
      w: w,
      h: h,
      vx: Math.cos(rad) * speed,
      vy: Math.sin(rad) * speed,
      path: frames.empty? ? ENEMY_SHOT : frames[0],
      frames: frames,
      born: Kernel.tick_count,
      angle: angle,
      number: number,
      damage: damage,
      boss_projectile: state.boss ? true : false,
      ground_collision: state.boss && world[:boss][:projectile_hits_ground],
      angle_offset: set ? (set[:angle_offset] || 0) : nil,
      rotate_projectile: set ? (set[:rotate] != false) : false,
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

      # Keep animated projectile art pointed exactly along its velocity.
      if s[:rotate_projectile]
        travel_angle = Math.atan2(s[:vy], s[:vx]) * 180 / Math::PI
        s[:angle] = travel_angle + (s[:angle_offset] || 0)
      end

      animate_shot(s)

      # Ground-based boss projectiles disappear when they strike the floor.
      # Planet maps use the bottom of the logical screen as the floor boundary.
      if s[:ground_collision] && s[:vy] < 0 && s[:y] <= 8
        s[:dead] = true
        next
      end

      if s[:x] < -150 || s[:x] > grid.w + 150 ||
         s[:y] < -150 || s[:y] > grid.h + 150
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

  # ==========================================================
  # EXPLOSIONS
  # ==========================================================

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
      born: Kernel.tick_count
    }
  end

  def update_effects
    state.effects.reject! do |fx|
      Kernel.tick_count - fx[:born] >=
        fx[:frames].length * 4
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

  # ==========================================================
  # COMBOS
  # ==========================================================

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

  # ==========================================================
  # POWER-UPS
  # ==========================================================

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
      dead: false
    }
  end

  def update_powerups
    state.shield_timer -= 1 if state.shield_timer > 0
    state.speed_timer -= 1 if state.speed_timer > 0

    state.powerup_timer -= 1

    if state.powerup_timer <= 0
      spawn_powerup

      state.powerup_timer = (
        Numeric.rand(500..850) *
        difficulty[:powerup_frequency]
      ).to_i
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
      state.hp = [state.hp + 1, player_max_hp].min

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

  # ==========================================================
  # COLLISIONS
  # ==========================================================

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

      if hit?(hurt, shrink(s, 0.3))
        s[:dead] = true
        damage_player(s[:damage] || 1)
      end
    end

    b = state.boss

    if b && !b[:dying] &&
       hit?(hurt, boss_hitbox(b))
      damage_player
    end
  end

  def damage_player(amount = 1)
    return if state.invuln > 0
    return if state.shield_timer > 0
    return unless state.game_state == :playing

    state.hp = [state.hp - amount, 0].max
    state.invuln = PLAYER_INVULN
    reset_combo

    if state.hp <= 0
      state.game_state = :game_over
      state.prompt_timer = 45
    end
  end

  # ==========================================================
  # INPUT
  # ==========================================================

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

    if kb.key_down.escape || kb.key_down.p
      toggle_pause
      return
    end

    case state.game_state
    when :paused
      pause_input

    when :ship_select
      selection_input

    when :difficulty_select
      difficulty_selection_input

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

  def toggle_pause
    if state.game_state == :paused
      state.game_state = state.pause_return_state || :playing
      state.pause_return_state = nil
    elsif [:playing, :world_clear].include?(state.game_state)
      state.pause_return_state = state.game_state
      state.game_state = :paused
    end
  end

  def pause_input
    kb = inputs.keyboard

    if kb.key_down.enter || kb.key_down.space
      toggle_pause
      return
    end

    if kb.key_down.r
      gtk.reset_next_tick
      return
    end

    touch_press_points.each do |p|
      if inside?(p[:x], p[:y], 470, 315, 340, 70)
        toggle_pause
        return
      elsif inside?(p[:x], p[:y], 470, 220, 340, 70)
        gtk.reset_next_tick
        return
      end
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
    path = SHIP_COLORS[selected_ship_color]
    state.player.path = path if gtk.stat_file(path)
    state.game_state = :difficulty_select
  end

  def difficulty_selection_input
    kb = inputs.keyboard

    if kb.key_down.up || kb.key_down.left
      state.difficulty_index =
        (state.difficulty_index - 1) % 3

    elsif kb.key_down.down || kb.key_down.right
      state.difficulty_index =
        (state.difficulty_index + 1) % 3
    end

    if kb.key_down.enter || kb.key_down.space
      begin_actual_game
      return
    end

    touch_press_points.each do |p|
      3.times do |i|
        y = 390 - i * 100

        if inside?(p[:x], p[:y], 390, y, 500, 75)
          state.difficulty_index = i
          begin_actual_game
          return
        end
      end
    end
  end

  def begin_actual_game
    state.difficulty = DIFFICULTIES[state.difficulty_index]
    state.hp = player_max_hp
    state.invuln = PLAYER_INVULN
    state.fade = FADE_TICKS
    state.game_state = :playing

    start_wave(1)
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

  # ==========================================================
  # MOBILE INPUT
  # ==========================================================

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

    points
  end

  def update_touch_controls
    state.mobile_dx = 0.0
    state.mobile_dy = 0.0
    state.mobile_firing = false

    points = touch_points
    state.touch_detected = true if points.any?

    previous = state.previous_touches || {}
    current = {}
    presses = []

    points.each do |p|
      current[p[:id]] = true
      presses << p unless previous[p[:id]]

      if p[:x] < 550 && p[:y] < 400
        dx = p[:x] - 135
        dy = p[:y] - 130
        distance = Math.sqrt(dx * dx + dy * dy)

        if distance > 0
          strength = [distance / 85.0, 1.0].min
          state.mobile_dx = dx / distance * strength
          state.mobile_dy = dy / distance * strength
        end
      end

      dx = p[:x] - 1130
      dy = p[:y] - 130

      if Math.sqrt(dx * dx + dy * dy) < 105
        state.mobile_firing = true
      end
    end

    if inputs.mouse.click
      presses << {
        x: inputs.mouse.x,
        y: inputs.mouse.y
      }
    end

    state.previous_touches = current
    state.touch_presses = presses
  end

  def touch_press_points
    state.touch_presses || []
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

  # ==========================================================
  # GAME UPDATE
  # ==========================================================

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

    if planet_world?
      state.bg_scroll =
        (state.bg_scroll + world[:scroll_speed]) % grid.w
    end

    state.planets.each do |p|
      p[:x] -= p[:speed]

      if p[:x] + p[:w] < 0
        p[:x] = grid.w
        p[:path] = PLANETS.sample
      end
    end

    state.meteors.each do |m|
      m[:x] -= m[:speed]
      m[:y] += m[:vy]
      m[:angle] += m[:spin]

      # animated hazards (fire arrows, smoke, etc.)
      frames = m[:frames]

      if frames && !frames.empty?
        m[:path] =
          frames[((Kernel.tick_count - m[:born]) / 5) % frames.length]
      end

      if m[:y] < 0 || m[:y] + m[:h] > grid.h
        m[:vy] *= -1
      end
    end

    state.ufos.each do |u|
      move_ufo(u)
      shoot_ufo(u)
    end

    update_boss
    update_boss_animation(state.boss, world[:boss]) if state.boss
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

    if state.wave < 3 && state.ufos.empty?
      state.wave_clear_timer -= 1

      if state.wave_clear_timer <= 0
        start_wave(state.wave + 1)
      end
    end
  end

  # ==========================================================
  # PLANET TRANSITIONS
  # ==========================================================

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
      x: p.x,
      y: p.y,
      w: p.w,
      h: p.h,
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

    progress = ease(tr[:t] / 190.0)
    p = state.player

    if tr[:type] == :descending
      cx = lerp(
        tr[:x] + tr[:w] / 2,
        grid.w - 320,
        progress
      )

      cy = lerp(
        tr[:y] + tr[:h] / 2,
        grid.h / 2,
        progress
      )

      scale = 1.0 - 0.93 * progress
    else
      cx = lerp(
        tr[:x] + tr[:w] / 2,
        grid.w + 150,
        progress
      )

      cy = lerp(
        tr[:y] + tr[:h] / 2,
        grid.h + 100,
        progress
      )

      scale = 1.0 - 0.65 * progress
    end

    p.w = tr[:w] * scale
    p.h = tr[:h] * scale
    p.x = cx - p.w / 2
    p.y = cy - p.h / 2

    tr[:flash] = clamp(
      (tr[:t] - 190) / 50.0,
      0.0,
      1.0
    )

    finish_transition if tr[:t] >= TRANSITION_TICKS
  end

  def finish_transition
    tr = state.transition
    p = state.player

    p.w = tr[:w]
    p.h = tr[:h]
    p.x = state.player_start[:x]
    p.y = state.player_start[:y]

    state.transition = nil
    state.hp = player_max_hp
    state.invuln = PLAYER_INVULN
    state.shield_timer = 0
    state.speed_timer = 0
    state.powerup_timer = 450
    state.fade = FADE_TICKS

    state.shots = []
    state.enemy_shots = []
    state.effects = []
    state.player_effects = []
    state.powerups = []

    reset_combo
    start_world(next_world_index)
    state.game_state = :playing
  end

  # ==========================================================
  # GEOMETRY
  # ==========================================================

  def clamp(v, lo, hi)
    [[v, lo].max, hi].min
  end

  def lerp(a, b, t)
    a + (b - a) * t
  end

  def ease(t)
    t = clamp(t, 0.0, 1.0)
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
    shrink(s, 0.1)
  end

  def angle_to_player(cx, cy)
    p = state.player

    dx = p.x + p.w / 2 - cx
    dy = p.y + p.h / 2 - cy

    Math.atan2(dy, dx) * 180 / Math::PI
  end

  # ==========================================================
  # RENDER
  # ==========================================================

  def render_game
    if state.game_state == :ship_select
      render_ship_selection
      return
    end

    if state.game_state == :difficulty_select
      render_difficulty_selection
      return
    end

    render_background
    outputs.sprites << state.planets

    render_transition_planet

    outputs.sprites << state.meteors
    outputs.sprites << state.ufos

    render_boss_engine
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
    render_pause_overlay if state.game_state == :paused
    render_fade
    render_touch_buttons
  end

  def render_background
    if planet_world?
      offset = state.bg_scroll || 0

      2.times do |i|
        outputs.sprites << {
          x: i * grid.w - offset,
          y: 0,
          w: grid.w,
          h: grid.h,
          path: state.bg
        }
      end
    else
      outputs.sprites << {
        x: 0,
        y: 0,
        w: grid.w,
        h: grid.h,
        path: state.bg
      }
    end
  end

  # ==========================================================
  # SHIP SELECTION SCREEN
  # ==========================================================

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
          w: 120,
          h: 120,
          path: path,
          angle: color == :orange ? 90 : 0
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
      text: "CONTINUE",
      size_px: 32,
      anchor_x: 0.5,
      anchor_y: 0.5,
      r: 255, g: 255, b: 255
    }
  end

  # ==========================================================
  # DIFFICULTY SELECTION SCREEN
  # ==========================================================

  def render_difficulty_selection
    outputs.solids << {
      x: 0, y: 0,
      w: grid.w, h: grid.h,
      r: 8, g: 14, b: 35
    }

    outputs.labels << {
      x: 640, y: 610,
      text: "SPACE GALACTICA",
      size_px: 70,
      anchor_x: 0.5,
      r: 130, g: 210, b: 255
    }

    outputs.labels << {
      x: 640, y: 530,
      text: "SELECT DIFFICULTY",
      size_px: 35,
      anchor_x: 0.5,
      r: 255, g: 255, b: 255
    }

    descriptions = [
      "EASY - 5 LIVES",
      "NORMAL - 3 LIVES",
      "HARD - 2 LIVES"
    ]

    3.times do |i|
      selected = state.difficulty_index == i
      y = 390 - i * 100

      outputs.solids << {
        x: 390, y: y,
        w: 500, h: 75,
        r: selected ? 40 : 25,
        g: selected ? 120 : 35,
        b: selected ? 190 : 65
      }

      outputs.labels << {
        x: 640,
        y: y + 37,
        text: descriptions[i],
        size_px: 28,
        anchor_x: 0.5,
        anchor_y: 0.5,
        r: 255, g: 255, b: 255
      }
    end

    outputs.labels << {
      x: 640, y: 65,
      text: "ARROWS TO SELECT - ENTER TO START",
      size_px: 23,
      anchor_x: 0.5,
      r: 180, g: 220, b: 255
    }
  end

  # ==========================================================
  # PLAYER RENDERING
  # ==========================================================

  def render_engine
    frames = valid_frames(ENGINE_FRAMES)
    return if frames.empty?

    p = state.player

    index = (
      Kernel.tick_count / ENGINE_SPEED
    ) % frames.length

    outputs.sprites << {
      x: p.x - p.w * 0.30,
      y: p.y + p.h * 0.15,
      w: p.w * 0.100,
      h: p.h * 0.70,
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
      angle: selected_ship_color == :orange ?
        ORANGE_ANGLE : SHIP_ANGLE
    }
  end

  def render_player_shield
    return unless state.shield_timer > 0

    frames = valid_frames(SHIELD_EFFECT_FRAMES)
    return if frames.empty?

    p = state.player
    frame = (Kernel.tick_count / 8) % frames.length

    outputs.sprites << {
      x: p.x + p.w * 0.75,
      y: p.y - p.h * 0.175,
      w: p.w * 0.65,
      h: p.h * 1.35,
      path: frames[frame],
      angle: -90,
      a: 185
    }
  end

  def render_player_powerup_effects
    p = state.player

    state.player_effects.each do |fx|
      elapsed = Kernel.tick_count - fx[:born]

      if fx[:type] == :repair
        frames = valid_frames(STAR_EFFECT_FRAMES)
        next if frames.empty?

        frame = (elapsed / 8) % frames.length

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

  # ==========================================================
  # SPACESHIP BOSS ENGINE
  # ==========================================================

  def render_boss_engine
    b = state.boss
    return unless b
    return if b[:dying]

    cfg = world[:boss]
    return unless cfg[:type] == :spaceship

    number = cfg[:ship_number] || 1

    frames = valid_frames(
      self.class.ship_engine_frames(
        number,
        boss_phase(b) == 3
      )
    )

    if frames.empty?
      frames = valid_frames(
        self.class.ship_engine_frames(number)
      )
    end

    return if frames.empty?

    frame = (Kernel.tick_count / 4) % frames.length

    outputs.sprites << {
      x: b[:x] + b[:w] * 0.74,
      y: b[:y] + b[:h] * 0.39,
      w: b[:w] * 0.42,
      h: b[:h] * 0.22,
      path: frames[frame],
      angle: 0,
      a: 230
    }
  end

  # ==========================================================
  # BOSS RENDERING
  # ==========================================================

  def render_boss
    b = state.boss
    return unless b

    cfg = world[:boss]

    if cfg[:type] == :spaceship && b[:dying]
      frames = b[:explosion_frames]

      unless frames.empty?
        elapsed = Kernel.tick_count - b[:animation_start]
        index = [elapsed / 5, frames.length - 1].min

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
        r: 255,
        g: b[:flash] > 0 ? 120 : 255,
        b: b[:flash] > 0 ? 120 : 255,
        flip_horizontally:
          cfg[:type] == :spaceship ? true :
          (boss_facing_left?(b) == (cfg[:flip_horizontally] || false))
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

  # ==========================================================
  # SHOT RENDERING
  # ==========================================================

  def render_shots
    state.shots.each do |s|
      next if s[:dead]

      if s[:type] == :normal
        outputs.sprites << {
          x: s[:x],
          y: s[:y],
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
      index = elapsed / 4

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

  # ==========================================================
  # TRANSITION RENDERING
  # ==========================================================

  def render_transition_planet
    tr = state.transition
    return unless tr
    return unless tr[:type] == :descending

    slide = ease(tr[:t] / 80.0)
    cx = lerp(grid.w + 370, grid.w - 440, slide)

    size = 640 * (
      1.0 + ease((tr[:t] - 60) / 130.0) * 0.45
    )

    path = tr[:planet]
    return unless path && gtk.stat_file(path)

    outputs.sprites << {
      x: cx - size / 2,
      y: grid.h / 2 - size / 2,
      w: size,
      h: size,
      path: path
    }
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

  # ==========================================================
  # HUD
  # ==========================================================

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
      x: 40, y: grid.h - 110,
      text: "LIVES",
      size_px: 20,
      r: 255, g: 255, b: 255
    }

    life_sprite = PLAYER_LIFE_SPRITES[selected_ship_color]

    player_max_hp.times do |i|
      x = 40 + i * 42
      y = grid.h - 180

      if gtk.stat_file(life_sprite)
        outputs.sprites << {
          x: x, y: y,
          w: 34, h: 34,
          path: life_sprite,
          a: i < state.hp ? 255 : 55
        }
      else
        outputs.solids << {
          x: x, y: y,
          w: 34, h: 34,
          r: i < state.hp ? 70 : 50,
          g: i < state.hp ? 190 : 50,
          b: i < state.hp ? 255 : 50
        }
      end
    end

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
      w: 220 * clamp(state.combo.to_f / 10, 0, 1),
      h: 18,
      r: 100, g: 170, b: 255
    }

    b = state.boss

    if b
      ratio = clamp(
        b[:hp].to_f / b[:max_hp],
        0.0, 1.0
      )

      x = 670
      y = grid.h - 112
      w = 500
      h = 46

      if gtk.stat_file(BOSS_HEALTH_BG)
        outputs.primitives << {
          x: x, y: y,
          w: w, h: h,
          path: BOSS_HEALTH_BG
        }.sprite!
      end

      outputs.primitives << {
        x: x + 10,
        y: y + 9,
        w: w - 20,
        h: h - 18,
        r: 35, g: 20, b: 30
      }.solid!

      color =
        if ratio > 0.6
          [65, 220, 110]
        elsif ratio > 0.3
          [255, 190, 45]
        else
          [235, 55, 65]
        end

      outputs.primitives << {
        x: x + 10,
        y: y + 9,
        w: (w - 20) * ratio,
        h: h - 18,
        r: color[0],
        g: color[1],
        b: color[2]
      }.solid!

      outputs.primitives << {
        x: x + w / 2,
        y: y + h / 2,
        text: "#{(ratio * 100).ceil}%",
        size_px: 19,
        anchor_x: 0.5,
        anchor_y: 0.5,
        r: 255, g: 255, b: 255
      }.label!

      outputs.primitives << {
        x: x + w / 2,
        y: y + h + 15,
        text: "#{world[:name].upcase} BOSS",
        size_px: 23,
        anchor_x: 0.5,
        r: 255, g: 255, b: 255
      }.label!
    end

    if state.shield_timer > 0
      outputs.labels << {
        x: 40, y: grid.h - 225,
        text: "SHIELD: #{(state.shield_timer / 60.0).ceil}s",
        size_px: 20,
        r: 100, g: 210, b: 255
      }
    end

    if state.speed_timer > 0
      outputs.labels << {
        x: 40, y: grid.h - 255,
        text: "SPEED: #{(state.speed_timer / 60.0).ceil}s",
        size_px: 20,
        r: 255, g: 220, b: 70
      }
    end
  end

  # ==========================================================
  # WAVE BANNERS
  # ==========================================================

  def render_banner
    return unless state.game_state == :playing
    return unless state.banner_timer > 0

    outputs.labels << {
      x: grid.w / 2,
      y: grid.h / 2 + 140,
      text: state.banner_text,
      size_px: 65,
      anchor_x: 0.5,
      r: 255,
      g: state.wave == 3 ? 80 : 255,
      b: state.wave == 3 ? 80 : 255,
      a: [state.banner_timer * 4, 255].min
    }
  end

  # ==========================================================
  # END SCREENS
  # ==========================================================

  def render_overlay
    return if [
      :playing, :descending, :ascending, :paused
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

  def render_pause_overlay
    outputs.solids << {
      x: 0, y: 0, w: grid.w, h: grid.h,
      r: 0, g: 0, b: 0, a: 185
    }

    outputs.labels << {
      x: grid.w / 2, y: 500,
      text: "PAUSED", size_px: 72,
      anchor_x: 0.5, anchor_y: 0.5,
      r: 255, g: 255, b: 255
    }

    outputs.solids << {
      x: 470, y: 315, w: 340, h: 70,
      r: 40, g: 160, b: 110
    }
    outputs.labels << {
      x: 640, y: 350, text: "RESUME", size_px: 30,
      anchor_x: 0.5, anchor_y: 0.5,
      r: 255, g: 255, b: 255
    }

    outputs.solids << {
      x: 470, y: 220, w: 340, h: 70,
      r: 160, g: 65, b: 65
    }
    outputs.labels << {
      x: 640, y: 255, text: "RESTART", size_px: 30,
      anchor_x: 0.5, anchor_y: 0.5,
      r: 255, g: 255, b: 255
    }

    outputs.labels << {
      x: 640, y: 155,
      text: "ESC / P = RESUME     R = RESTART",
      size_px: 22, anchor_x: 0.5,
      r: 200, g: 220, b: 255
    }
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
    return unless state.touch_detected

    if state.game_state == :playing
      outputs.solids << {
        x: 50, y: 45,
        w: 170, h: 170,
        r: 70, g: 120, b: 220, a: 65
      }

      outputs.solids << {
        x: 1055, y: 55,
        w: 150, h: 150,
        r: 230, g: 60, b: 65, a: 130
      }

      outputs.labels << {
        x: 1130, y: 130,
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

# ==========================================================
# DRAGONRUBY ENTRY POINTS
# ==========================================================

def tick(args)
  $game ||= Game.new
  $game.args = args
  $game.tick
end

def reset(args)
  $game = nil
end