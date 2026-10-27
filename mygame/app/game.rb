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

    args.state.clouds ||= [
      { x: 700, y: 400, w: 100, h: 100, path: 'sprites/nuvem.png', speed: 10},
      { x: 1000, y: 300, w: 100, h: 100, path: 'sprites/nuvem.png', speed: 10},
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
    # TODO: calculate the game's state
  end

  def render
    args.outputs.sprites << args.state.player
    args.outputs.sprites << args.state.clouds
    # TODO: render the game's scene
  end

end
