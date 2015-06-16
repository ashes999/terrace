#Hello from game.rb
class Game
  def initialize
    $crafty.init(800, 600)
    $crafty.background('black')
    e = $crafty.e('2D, Canvas, Color, Alpha, Fourway')
    e.attr({ :w => 32, :h => 32 })
    e.color('red')
    e.fourway(8)
  end
end