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
  end

  def input

    # TODO: handle the game's input
  end

  def calc
    # TODO: calculate the game's state
  end

  def render
    args.outputs.sprites << args.state.player
    # TODO: render the game's scene
  end

end
