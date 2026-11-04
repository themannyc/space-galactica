require "app/player"

# Hello Dragon: fly the dragon around for 15 seconds while clouds drift by.
class Game
  attr_dr
  BACKGROUND_COLOR = [70, 130, 180].freeze
  PLANET_ASSETS = (0..9).map { |i| "sprites/Planets/planet0#{i}.png" }
  METEOR_ASSETS = (1..4).map { |i| "sprites/space_assets/Meteors/meteorBrown_big#{i}.png" }

  def tick
    defaults
    input
    calc
    render
  end

  def defaults
    if Kernel.tick_count == 1
      args.audio[:music] = { input: "sounds/Factor6_-_03_-_Axel_Funk.ogg", looping: true }
  end
    args.state.music_volume ||= 1.0
    args.state.player ||= Player.new
    args.state.plasma_balls ||= []

    args.state.clouds ||= [
      { x: 0, y: 0, w: 100, h: 100, path: METEOR_ASSETS.sample, speed: 10}
    ]
    args.state.planets ||= [
      { x: 0, y: Numeric.rand(-500..500), w: 1000, h: 1000, path: PLANET_ASSETS.sample, speed: 1 }
    ]
    args.state.plasma_balls ||= [ x: args.state.player.x + args.state.player.w - 12, y: args.state.player.y + 10, w: 100, h: 100, path: 'sprites/space_assets/Lasers/laserBlue01.png', speed: 15, angle: 0 ]

    args.state.ufos ||= [
      { x: 1000, y: 300, w: 100, h: 100, path: 'sprites/space_assets/ufoBlue.png', speed: 5, angle: 0 },
            { x: 1000, y: 300, w: 100, h: 100, path: 'sprites/space_assets/ufoGreen.png', speed: 5, angle: 0 },
                  { x: 1000, y: 300, w: 100, h: 100, path: 'sprites/space_assets/ufoYellow.png', speed: 5, angle: 0 },
  ]

  end

  def input
    args.state.player.x += args.inputs.left_right * args.state.player.speed
    args.state.player.y += args.inputs.up_down * args.state.player.speed

    if args.inputs.left_right > 0
      args.state.player.flip_horizontally = false
    end

   

    if args.state.player.x + args.state.player.w > args.grid.w
      args.state.player.x = args.grid.w - args.state.player.w
      elsif args.state.player.x < 0
      args.state.player.x = 0
    end

    if args.state.player.y + args.state.player.h > args.grid.h
      args.state.player.y = args.grid.h - args.state.player.h
      elsif args.state.player.y < 0
      args.state.player.y = 0
    end

    if args.inputs.keyboard.key_down.m
      args.state.music_paused = !args.state.music_paused

    if args.state.music_paused
      args.audio[:music][:gain] = 0.0
    else
      args.audio[:music][:gain] = 1.0
    end
    end

    if args.inputs.keyboard.key_down.hyphen
      args.state.music_volume = [args.state.music_volume - 0.1, 0.0].max
      args.audio[:music][:gain] = args.state.music_volume
    end

    if args.inputs.keyboard.key_down.equal || args.inputs.keyboard.key_down.equal
      args.state.music_volume = [args.state.music_volume + 0.1, 1.0].min
      args.audio[:music][:gain] = args.state.music_volume
    end

    if args.inputs.keyboard.key_down.z
        args.state.plasma_balls << { x: args.state.player.x + args.state.player.w - 12, y: args.state.player.y + 5, w: 40, h: 70, path: 'sprites/space_assets/Lasers/laserBlue01.png', angle: -90}
      end

      if args.inputs.keyboard.key_down.space && args.state.timer <= 0
        args.gtk.reset_next_tick
    end

  end

  def calc
    return if args.state.game_over
    args.state.timer ||= 60 * 60
    if args.state.timer > 0
    args.state.timer -= 1
    elsif args.state.game_over = true
    end

    args.state.clouds.each do |cloud|
      cloud.x -= cloud.speed
      if cloud.x + cloud.w < 0
        cloud.x = args.grid.w
        cloud.y = rand(args.grid.h - cloud.h)
        cloud.path = METEOR_ASSETS.sample
      end
    end

    args.state.planets.each do |planet|
      planet.x -= planet.speed
      if planet.x + planet.w < 0
        planet.x = args.grid.w
        planet.y = Numeric.rand(-200..200)
        planet.path = PLANET_ASSETS.sample
      end
    end


    args.state.plasma_balls.each do |plasma|
      plasma.x += args.state.player.speed + 2
    end
    args.state.plasma_balls.reject! { |plasma| plasma.x > args.grid.w }
  end




  def render
args.outputs.sprites << {
    x: 0,
    y: 0,
    w: 1280,
    h: 720,
    path: "sprites/space.png"
  }

    if args.state.timer && args.state.timer <= 0
      labels = []
      labels << [
      x: args.grid.w / 2, y: args.grid.h / 2, text: "Press spacebar to restart", size_px: 48, anchor_x: 0.5, anchor_y: 0.5
    ]
      args.outputs.labels << labels
      return
  end

    args.outputs.sprites << args.state.planets
    args.outputs.sprites << [args.state.player, args.state.player, args.state.plasma_balls]
    args.outputs.sprites << args.state.clouds
    args.outputs.sprites << args.state.player
    args.outputs.sprites << args.state.plasma_balls
    args.outputs.sprites << args.state.ufos

    args.outputs.labels << [
       x: 40, y: args.grid.h - 40, text: "Time left: #{(args.state.timer / 60).round}", size_px: 26, anchor_x: 0, r: 255, g: 255, b: 255
    ]

  end
end
