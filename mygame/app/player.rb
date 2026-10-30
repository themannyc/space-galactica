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
    @angle_anchor_x = 0.5
    @angle_anchor_y = 0.5
  end
end