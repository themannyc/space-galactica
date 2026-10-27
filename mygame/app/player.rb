# The dragon/player
class Player
  attr_accessor :x, :y, :w, :h, :speed, :path

  def initialize
    @x = 600
    @y = 350
    @w = 100
    @h = 80
    @speed = 10
    @path = 'sprites/misc/dragon-0.png'
  end
end