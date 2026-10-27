require "app/player"

# Hello Dragon: fly the dragon around for 15 seconds while clouds drift by.
class Game
  attr_dr

  def tick
    defaults
    input
    calc
    render
  end

  def defaults
    # TODO: set up the game defaults
    args.state.player ||= Player.new
    args.state.timer ||= 30
    args.state.timer -= 1
    if args.state.timer <= 0
      labels = []
      labels << { x: args.grid.w / 2, y: args.grid.h / 2, text: "Game Over", size: 50, color: [255, 0, 0] }
    end

    args.state.clouds ||= [
      { x: 0, y: 0, w: 100, h: 100, path: 'sprites/nuvem.png', speed: 10}
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
    if args.state.player.x + args.state.player.w > args.grid.w
      args.state.player.x = args.grid.w - args.state.player.w
    elsif args.state.player.y + args.state.player.h > args.grid.h
      args.state.player.y = args.grid.h - args.state.player.h
    elsif args.state.player.x < 0
      args.state.player.x = 0
    elsif args.state.player.y < 0
      args.state.player.y = 0
    end
    # TODO: handle the game's input
  end

  def calc
    args.state.clouds.each do |cloud|
      cloud.x -= cloud.speed
      if cloud.x + cloud.w < 0
        cloud.x = args.grid.w
        cloud.y = rand(args.grid.h - cloud.h)
      end
    end
    args.state.red.each do |red|
      if args.geometry.intersect_rect?(args.state.player, red)
      end
    end
    # TODO: calculate the game's state
  end

  def render
    args.outputs.sprites << args.state.player
    args.outputs.sprites << args.state.clouds
    args.outputs.sprites << args.state.red
    args.outputs.sprites << args.state.green
    args.outputs.sprites << args.state.blue
    args.outputs.background_color = [70, 130, 180]
    # TODO: render the game's scene
  end

end
