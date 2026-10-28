# The dragon/player
class Player
  attr_sprite
  attr_accessor :speed

  def initialize
    @x = 600
    @y = 350
    @w = 100
    @h = 80
    @speed = 10
    @path = 'sprites/misc/dragon-0.png'
  end
end