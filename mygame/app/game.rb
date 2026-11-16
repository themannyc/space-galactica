require "app/player"

# Space Dragon
#   Wave 1: meteors + UFOs that shoot straight ahead
#   Wave 2: faster/drifting meteors + tougher UFOs that fire AIMED triple shots
#   Wave 3: BOSS fight (drop your sprite in at BOSS_ASSET below)
#
# Controls: arrows = move, Z = shoot, M = mute, -/= = volume, SPACE = restart (after game over / win)
class Game
  attr_gtk

  # ------------------------------------------------------------------
  # ASSETS  (change these paths if your files live somewhere else)
  # ------------------------------------------------------------------
  BACKGROUND_COLOR   = [70, 130, 180].freeze
  PLANET_ASSETS      = (0..9).map { |i| "sprites/Planets/planet0#{i}.png" }
  METEOR_ASSETS      = (1..4).map { |i| "sprites/space_assets/Meteors/meteorBrown_big#{i}.png" }
  UFO_ASSET          = 'sprites/space_assets/ufoBlue.png'
  UFO_WAVE2_ASSET    = 'sprites/space_assets/ufoRed.png'            # Kenney pack; swap if you don't have it
  PLASMA_ASSET       = 'sprites/space_assets/Lasers/laserBlue01.png'
  ENEMY_BULLET_ASSET = 'sprites/space_assets/Lasers/laserRed01.png'  # Kenney pack; swap if you don't have it

  # >>> BOSS SPRITE GOES HERE <<<
  # Put your image at this path (relative to the game folder) and it is picked up automatically.
  # Until the file exists, a red placeholder box is drawn instead.
  BOSS_ASSET = 'sprites/boss.png'
  BOSS_W     = 400
  BOSS_H     = 400

  # ------------------------------------------------------------------
  # TUNING
  # ------------------------------------------------------------------
  PLAYER_MAX_HP = 3     # set to 1 for one-hit-kill
  INVULN_TICKS  = 90    # blink/safe time after being hit
  PLASMA_SPEED  = 16
  UFO_ENTRY_SPEED = 3

  BOSS_MAX_HP        = 60
  BOSS_MOVE_SPEED    = [3, 4.5, 6].freeze        # per phase
  BOSS_FIRE_RATE     = [90, 75, 55].freeze       # ticks between aimed volleys
  BOSS_BULLET_SPEED  = [7, 8, 9].freeze
  BOSS_SPREAD        = [[-15, 0, 15], [-20, -10, 0, 10, 20], [-30, -15, 0, 15, 30]].freeze

  WAVES = {
    1 => { meteors: 5, meteor_speed: 4..6, meteor_drift: 0,
           ufos: 3, ufo_hp: 1, ufo_path: UFO_ASSET, ufo_amp: 100, ufo_bob: 0.03,
           fire_rate: 150, bullet_speed: 6, aimed: false, spread: [0] },
    2 => { meteors: 8, meteor_speed: 7..10, meteor_drift: 2,
           ufos: 6, ufo_hp: 2, ufo_path: UFO_WAVE2_ASSET, ufo_amp: 160, ufo_bob: 0.05,
           fire_rate: 140, bullet_speed: 8, aimed: true, spread: [-12, 0, 12] },
    3 => { meteors: 3, meteor_speed: 4..6, meteor_drift: 0, ufos: 0, boss: true }
  }.freeze

  # ------------------------------------------------------------------
  # SHORTCUTS
  # ------------------------------------------------------------------
  def state;   args.state;   end
  def inputs;  args.inputs;  end
  def outputs; args.outputs; end
  def grid;    args.grid;    end
  def audio;   args.audio;   end
  def gtk;     args.gtk;     end

  # ------------------------------------------------------------------
  # MAIN LOOP
  # ------------------------------------------------------------------
  def tick
    defaults
    input
    calc
    render
  end

  def defaults
    if !audio[:music]
      audio[:music] = { input: "sounds/Factor6_-_03_-_Axel_Funk.ogg", looping: true }
    end

    state.music_volume ||= 1.0
    state.player       ||= Player.new
    state.game_state   ||= :playing     # :playing, :game_over, :victory
    state.score        ||= 0
    state.hp           ||= PLAYER_MAX_HP
    state.invuln_timer ||= 0
    state.plasma_balls ||= []
    state.enemy_bullets ||= []
    state.planets ||= [
      { x: 0, y: Numeric.rand(-500..500), w: 1000, h: 1000, path: PLANET_ASSETS.sample, speed: 1 }
    ]

    start_wave(1) unless state.wave
  end

  # ------------------------------------------------------------------
  # WAVES
  # ------------------------------------------------------------------
  def wave_cfg
    WAVES[state.wave]
  end

  def start_wave(n)
    cfg = WAVES[n]
    state.wave            = n
    state.wave_clear_timer = 90
    state.banner_timer    = 150
    state.banner_text     = n == 3 ? "WARNING!  BOSS INCOMING" : "WAVE #{n}"
    state.enemy_bullets   = []
    state.meteors         = cfg[:meteors].times.map { spawn_meteor(cfg, true) }
    state.ufos            = cfg[:ufos].times.map { |i| spawn_ufo(cfg, i) }
    state.boss            = nil
    if cfg[:boss]
      state.boss = spawn_boss
      state.boss_has_sprite = !gtk.stat_file(BOSS_ASSET).nil?
    end
  end

  def check_wave_progress
    return if state.wave >= 3
    return unless state.ufos.empty?
    state.wave_clear_timer -= 1
    start_wave(state.wave + 1) if state.wave_clear_timer <= 0
  end

  # ------------------------------------------------------------------
  # SPAWNERS
  # ------------------------------------------------------------------
  def spawn_meteor(cfg, initial = false)
    size = Numeric.rand(50..150)
    drift = cfg[:meteor_drift]
    {
      x: grid.w + Numeric.rand(0..(initial ? 1500 : 400)),
      y: Numeric.rand(0..(grid.h - size)),
      w: size,
      h: size,
      path: METEOR_ASSETS.sample,
      speed: Numeric.rand(cfg[:meteor_speed]),
      vy: Numeric.rand(-drift..drift),
      spin: Numeric.rand(-3..3),
      angle: 0,
      dead: false
    }
  end

  def spawn_ufo(cfg, index)
    base_y = Numeric.rand(150..570)
    {
      x: grid.w + 100 + index * 220,     # staggered so they stream in
      y: base_y,
      w: 100,
      h: 100,
      path: cfg[:ufo_path],
      hp: cfg[:ufo_hp],
      hover_x: 600 + (index % 3) * 180,
      base_y: base_y,
      amp: cfg[:ufo_amp],
      bob: cfg[:ufo_bob],
      phase: Numeric.rand(0..360),
      fire_timer: 60 + Numeric.rand(0..cfg[:fire_rate]),
      angle: 0,
      dead: false
    }
  end

  def spawn_boss
    {
      x: grid.w + 50,
      y: grid.h / 2 - BOSS_H / 2,
      w: BOSS_W,
      h: BOSS_H,
      path: BOSS_ASSET,
      hp: BOSS_MAX_HP,
      max_hp: BOSS_MAX_HP,
      dir: 1,
      fire_timer: 120,
      ring_timer: 200,
      flash: 0,
      angle: 0
    }
  end

  def refill_meteors
    cfg = wave_cfg
    state.meteors << spawn_meteor(cfg) while state.meteors.length < cfg[:meteors]
  end

  def fire_enemy_bullet(cx, cy, deg, speed)
    rad = deg * Math::PI / 180
    state.enemy_bullets << {
      x: cx - 10, y: cy - 28, w: 20, h: 56,
      vx: Math.cos(rad) * speed,
      vy: Math.sin(rad) * speed,
      path: ENEMY_BULLET_ASSET,
      angle: deg - 90,
      dead: false
    }
  end

  # ------------------------------------------------------------------
  # INPUT
  # ------------------------------------------------------------------
  def input
    kb = inputs.keyboard

    # music controls work any time
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

    if state.game_state != :playing
      gtk.reset_next_tick if kb.key_down.space
      return
    end

    player = state.player
    player.x += inputs.left_right * player.speed
    player.y += inputs.up_down * player.speed
    player.flip_horizontally = false if inputs.left_right > 0

    player.x = grid.w - player.w if player.x + player.w > grid.w
    player.x = 0 if player.x < 0
    player.y = grid.h - player.h if player.y + player.h > grid.h
    player.y = 0 if player.y < 0

    if kb.key_down.z
      state.plasma_balls << {
        x: player.x + player.w - 12, y: player.y + 5, w: 40, h: 70,
        path: PLASMA_ASSET, angle: -90, dead: false
      }
    end
  end

  def apply_music
    return unless audio[:music]
    audio[:music][:gain] = state.music_paused ? 0.0 : state.music_volume
  end

  # ------------------------------------------------------------------
  # UPDATE
  # ------------------------------------------------------------------
  def calc
    return unless state.game_state == :playing

    state.banner_timer -= 1 if state.banner_timer > 0
    state.invuln_timer -= 1 if state.invuln_timer > 0

    update_planets
    update_plasma
    update_meteors
    update_ufos
    update_boss
    update_enemy_bullets

    check_plasma_hits
    check_player_hits
    check_boss_dead

    state.plasma_balls.reject!  { |p| p.dead || p.x > grid.w }
    state.meteors.reject!       { |m| m.dead || m.x + m.w < -50 }
    state.ufos.reject!          { |u| u.dead }
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
        planet.path = PLANET_ASSETS.sample
      end
    end
  end

  def update_plasma
    state.plasma_balls.each { |p| p.x += PLASMA_SPEED }
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

  def update_ufos
    cfg = wave_cfg
    state.ufos.each do |ufo|
      ufo.x -= UFO_ENTRY_SPEED if ufo.x > ufo.hover_x
      t = (Kernel.tick_count + ufo.phase) * ufo.bob
      ufo.y = clamp_val(ufo.base_y + Math.sin(t) * ufo.amp, 0, grid.h - ufo.h)

      next if ufo.x > grid.w - ufo.w   # still sliding in, don't shoot yet
      ufo.fire_timer -= 1
      if ufo.fire_timer <= 0
        ufo_fire(ufo, cfg)
        ufo.fire_timer = cfg[:fire_rate] + Numeric.rand(0..40)
      end
    end
  end

  def ufo_fire(ufo, cfg)
    cx = ufo.x + 10
    cy = ufo.y + ufo.h / 2
    base = cfg[:aimed] ? angle_to_player(cx, cy) : 180
    cfg[:spread].each { |off| fire_enemy_bullet(cx, cy, base + off, cfg[:bullet_speed]) }
  end

  def update_boss
    boss = state.boss
    return unless boss

    boss.flash -= 1 if boss.flash > 0

    # fly in from the right
    if boss.x > grid.w - boss.w - 30
      boss.x -= 2
      return
    end

    phase = boss_phase(boss)

    boss.y += boss.dir * BOSS_MOVE_SPEED[phase - 1]
    if boss.y <= 0
      boss.y = 0
      boss.dir = 1
    elsif boss.y + boss.h >= grid.h
      boss.y = grid.h - boss.h
      boss.dir = -1
    end

    cx = boss.x + 60
    cy = boss.y + boss.h / 2

    # aimed volley
    boss.fire_timer -= 1
    if boss.fire_timer <= 0
      base = angle_to_player(cx, cy)
      BOSS_SPREAD[phase - 1].each do |off|
        fire_enemy_bullet(cx, cy, base + off, BOSS_BULLET_SPEED[phase - 1])
      end
      boss.fire_timer = BOSS_FIRE_RATE[phase - 1]
    end

    # phase 2+: ring of bullets sprayed to the left
    if phase >= 2
      boss.ring_timer -= 1
      if boss.ring_timer <= 0
        step = phase == 2 ? 20 : 12
        angle = 100
        while angle <= 260
          fire_enemy_bullet(cx, cy, angle, 5)
          angle += step
        end
        boss.ring_timer = phase == 2 ? 200 : 140
      end
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

  def update_enemy_bullets
    state.enemy_bullets.each do |b|
      b.x += b.vx
      b.y += b.vy
      b.dead = true if b.x < -100 || b.x > grid.w + 100 || b.y < -100 || b.y > grid.h + 100
    end
  end

  # ------------------------------------------------------------------
  # COLLISIONS
  # ------------------------------------------------------------------
  def check_plasma_hits
    boss = state.boss
    state.plasma_balls.each do |plasma|
      box = plasma_hitbox(plasma)

      state.meteors.each do |m|
        next if plasma.dead || m.dead
        if hit?(box, shrink(m, 0.12))
          plasma.dead = true
          m.dead = true
          state.score += 10
        end
      end

      state.ufos.each do |ufo|
        next if plasma.dead || ufo.dead
        if hit?(box, ufo)
          plasma.dead = true
          ufo.hp -= 1
          if ufo.hp <= 0
            ufo.dead = true
            state.score += 100
          end
        end
      end

      if boss && !plasma.dead && boss.x < grid.w && hit?(box, shrink(boss, 0.1))
        plasma.dead = true
        boss.hp -= 1
        boss.flash = 4
        state.score += 5
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
        damage_player
      end
    end

    boss = state.boss
    damage_player if boss && hit?(hurt, shrink(boss, 0.15))
  end

  def check_boss_dead
    boss = state.boss
    return unless boss && boss.hp <= 0
    state.score += 1000
    state.boss = nil
    state.enemy_bullets = []
    state.game_state = :victory
  end

  def damage_player
    return if state.invuln_timer > 0
    state.hp -= 1
    state.invuln_timer = INVULN_TICKS
    state.game_state = :game_over if state.hp <= 0
  end

  # ------------------------------------------------------------------
  # HELPERS
  # ------------------------------------------------------------------
  def hit?(a, b)
    args.geometry.intersect_rect?(a, b)
  end

  def clamp_val(v, lo, hi)
    [[v, lo].max, hi].min
  end

  # shrink a rect on every side by pct of its size (fairer hitboxes)
  def shrink(r, pct)
    { x: r.x + r.w * pct, y: r.y + r.h * pct, w: r.w * (1 - 2 * pct), h: r.h * (1 - 2 * pct) }
  end

  def player_hitbox
    shrink(state.player, 0.2)
  end

  # plasma sprite is drawn rotated 90deg, so swap w/h around its center
  def plasma_hitbox(p)
    cx = p.x + p.w / 2
    cy = p.y + p.h / 2
    { x: cx - p.h / 2, y: cy - p.w / 2, w: p.h, h: p.w }
  end

  def bullet_hitbox(b)
    cx = b.x + b.w / 2
    cy = b.y + b.h / 2
    { x: cx - 10, y: cy - 10, w: 20, h: 20 }
  end

  def angle_to_player(cx, cy)
    p = state.player
    dx = (p.x + p.w / 2) - cx
    dy = (p.y + p.h / 2) - cy
    Math.atan2(dy, dx) * 180 / Math::PI
  end

  # ------------------------------------------------------------------
  # RENDER
  # ------------------------------------------------------------------
  def render
    outputs.sprites << { x: 0, y: 0, w: 1280, h: 720, path: "sprites/space.png" }
    outputs.sprites << state.planets
    outputs.sprites << state.meteors
    outputs.sprites << state.ufos
    render_boss
    outputs.sprites << state.plasma_balls
    outputs.sprites << state.enemy_bullets

    blink = state.invuln_timer > 0 && Kernel.tick_count % 8 < 4
    outputs.sprites << state.player unless blink || state.game_state == :game_over

    render_hud
    render_banner
    render_overlay
  end

  def render_boss
    boss = state.boss
    return unless boss
    flashing = boss.flash > 0

    if state.boss_has_sprite
      outputs.sprites << boss.merge(r: 255, g: flashing ? 120 : 255, b: flashing ? 120 : 255)
    else
      # placeholder until you add BOSS_ASSET
      outputs.solids << { x: boss.x, y: boss.y, w: boss.w, h: boss.h,
                          r: flashing ? 255 : 150, g: 30, b: 60 }
      outputs.labels << { x: boss.x + boss.w / 2, y: boss.y + boss.h / 2,
                          text: "BOSS SPRITE HERE", size_px: 28,
                          anchor_x: 0.5, anchor_y: 0.5, r: 255, g: 255, b: 255 }
      outputs.labels << { x: boss.x + boss.w / 2, y: boss.y + boss.h / 2 - 34,
                          text: "(#{BOSS_ASSET})", size_px: 20,
                          anchor_x: 0.5, anchor_y: 0.5, r: 255, g: 255, b: 255 }
    end
  end

  def render_hud
    outputs.labels << { x: 40, y: grid.h - 40, text: "Wave #{state.wave}/3",
                        size_px: 26, anchor_x: 0, r: 255, g: 255, b: 255 }
    outputs.labels << { x: 40, y: grid.h - 72, text: "Score: #{state.score}",
                        size_px: 22, anchor_x: 0, r: 255, g: 255, b: 255 }

    PLAYER_MAX_HP.times do |i|
      if i < state.hp
        outputs.solids << { x: 40 + i * 34, y: grid.h - 120, w: 28, h: 18, r: 220, g: 40, b: 40 }
      else
        outputs.solids << { x: 40 + i * 34, y: grid.h - 120, w: 28, h: 18, r: 70, g: 70, b: 70 }
      end
    end

    boss = state.boss
    if boss
      ratio = [boss.hp.to_f / boss.max_hp, 0].max
      outputs.labels << { x: 330, y: grid.h - 40, text: "BOSS", size_px: 22,
                          anchor_x: 1, anchor_y: 0.5, r: 255, g: 255, b: 255 }
      outputs.solids << { x: 340, y: grid.h - 50, w: 600, h: 20, r: 40, g: 40, b: 40 }
      outputs.solids << { x: 340, y: grid.h - 50, w: 600 * ratio, h: 20, r: 220, g: 40, b: 40 }
    end

    if state.wave < 3 && state.ufos.empty? && state.game_state == :playing
      outputs.labels << { x: grid.w / 2, y: grid.h / 2, text: "WAVE CLEAR!", size_px: 60,
                          anchor_x: 0.5, anchor_y: 0.5, r: 255, g: 255, b: 120 }
    end
  end

  def render_banner
    return unless state.banner_timer > 0
    a = [[state.banner_timer * 4, 255].min, 0].max
    red = state.wave == 3 ? 80 : 255
    outputs.labels << { x: grid.w / 2, y: grid.h / 2 + 140, text: state.banner_text,
                        size_px: 72, anchor_x: 0.5, anchor_y: 0.5,
                        r: 255, g: red, b: red, a: a }
  end

  def render_overlay
    return if state.game_state == :playing

    title = state.game_state == :victory ? "YOU WIN!" : "GAME OVER"
    outputs.solids << { x: 0, y: 0, w: grid.w, h: grid.h, r: 0, g: 0, b: 0, a: 140 }
    outputs.labels << { x: grid.w / 2, y: grid.h / 2 + 60, text: title, size_px: 90,
                        anchor_x: 0.5, anchor_y: 0.5, r: 255, g: 255, b: 255 }
    outputs.labels << { x: grid.w / 2, y: grid.h / 2 - 10, text: "Score: #{state.score}",
                        size_px: 36, anchor_x: 0.5, anchor_y: 0.5, r: 255, g: 255, b: 255 }
    outputs.labels << { x: grid.w / 2, y: grid.h / 2 - 70, text: "Press spacebar to restart",
                        size_px: 36, anchor_x: 0.5, anchor_y: 0.5, r: 255, g: 255, b: 255 }
  end
end

def tick args
  $game ||= Game.new
  $game.args = args
  $game.tick
end

def reset args
  $game = nil
end