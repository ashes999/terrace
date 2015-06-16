# This is your application entry point. Feel free to define
# whatever you want as far as classes and methods. Just make
# sure it starts execution of your game.
class Main
  def run    
    Game.new
    e = Entity.new('2D, Canvas, Color, Alpha, Fourway')
    e.size(32, 32)
    e.color('red')
    e.move_to_input
    puts "Done at #{Time.new}"
  end
end

Main.new.run