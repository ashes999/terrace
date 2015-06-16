# This is your application entry point. Feel free to define
# whatever you want as far as a constructor and other methods.
# You just need a "run" method.
class Main
  def run
    $window = MrubyJs::get_root_object
    $crafty = $window.Crafty
    Game.new
    puts "Done at #{Time.new}"
  end
end

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

Main.new.run