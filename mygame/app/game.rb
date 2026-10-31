require "app/player"

# Hello Dragon: fly the dragon around for 15 seconds while clouds drift by.
class Game
  attr_dr
  BACKGROUND_COLOR = [70, 130, 180].freeze

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
  

    args.state.clouds ||= [
      { x: 0, y: 0, w: 100, h: 100, path: 'sprites/space_assets/Meteors/meteorBrown_big1.png', speed: 10}
    ]

    args.state.red ||= [
      { x: 900, y: 100, w: 100, h: 100, path: 'sprites/square/red.png' }
    ]
    args.state.green ||= [
      { x: 1000, y: 500, w: 100, h: 100, path: 'sprites/square/green.png' }
    ]
    args.state.blue ||= [
      { x: 400, y: 400, w: 100, h: 100, path: 'sprites/square/blue.png' }
    ]

  end

  def input
    args.state.player.x += args.inputs.left_right * args.state.player.speed
    args.state.player.y += args.inputs.up_down * args.state.player.speed

    if args.inputs.left_right < 0
      args.state.player.flip_horizontally = true
    elsif args.inputs.left_right > 0
      args.state.player.flip_horizontally = false
    end

    if args.inputs.up_down > 0
      args.state.player.angle = args.state.player.flip_horizontally ? -90 : 90
    elsif args.inputs.up_down < 0
      args.state.player.angle = args.state.player.flip_horizontally ? 90 : -90
    else
      args.state.player.angle = 0
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

    if args.inputs.keyboard.key_down.space && args.state.timer <= 0
      args.gtk.reset_next_tick
    end

  end

  def calc
    return if args.state.game_over
    args.state.timer ||= 15 * 60
    if args.state.timer > 0
    args.state.timer -= 1
    elsif args.state.game_over = true
    end

  player_sprite_index = 0.frame_index(count: 6, hold_for: 8, repeat: true)
    args.state.player.path = "sprites/misc/dragon-#{player_sprite_index}.png"

    args.state.clouds.each do |cloud|
      cloud.x -= cloud.speed
      if cloud.x + cloud.w < 0
        cloud.x = args.grid.w
        cloud.y = rand(args.grid.h - cloud.h)
      end
    end
    args.state.red.each do |red|
      if args.geometry.intersect_rect?(args.state.player, red)
      args.audio[:my_sound] = { input: 'sounds/419698__14fvaltrovat__short-horn.wav' }
      args.state.player.x -= args.inputs.left_right * args.state.player.speed
      args.state.player.y -= args.inputs.up_down * args.state.player.speed
      end
    end
    args.state.green.each do |green|
      if args.geometry.intersect_rect?(args.state.player, green)
      args.audio[:my_sound] = { input: 'sounds/419698__14fvaltrovat__short-horn.wav' }
      args.state.player.x -= args.inputs.left_right * args.state.player.speed
      args.state.player.y -= args.inputs.up_down * args.state.player.speed
      end
    end
    args.state.blue.each do |blue|
      if args.geometry.intersect_rect?(args.state.player, blue)
      args.audio[:my_sound] = { input: 'sounds/419698__14fvaltrovat__short-horn.wav' }
      args.state.player.x -= args.inputs.left_right * args.state.player.speed
      args.state.player.y -= args.inputs.up_down * args.state.player.speed
      end
    end
    return
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
    args.outputs.sprites << args.state.red
    args.outputs.sprites << args.state.green
    args.outputs.sprites << args.state.blue
    args.outputs.sprites << args.state.clouds
    args.outputs.sprites << args.state.player

    args.outputs.labels << [
       x: 40, y: args.grid.h - 40, text: "Time left: #{(args.state.timer / 60).round}", size_px: 26, anchor_x: 0, r: 255, g: 255, b: 255
    ]

  end
end
