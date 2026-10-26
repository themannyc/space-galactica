require "app/game"

def tick(args)
  $game ||= Game.new
  $game.args = args
  $game.tick
end

# Called by DragonRuby on reset (e.g. $gtk.reset); start over with a fresh game.
def reset(_args)
  $game = nil
end
