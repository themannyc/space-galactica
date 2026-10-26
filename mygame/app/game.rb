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
