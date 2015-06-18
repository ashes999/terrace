# This is your application entry point. Feel free to define
# whatever you want as far as classes and methods. Just make
# sure it starts execution of your game.
# Any source files in "src" will be included first.
class Main
  def run    
    Game.new(800, 600)
    # Proposed API: chaining for berevity. This style is cool.
    e = Entity.new([TwoDComponent.new, KeyboardComponent.new])
    e.size(32, 32).color('red').move_with_keyboard
    puts "Done at #{Time.new}"
  end
end

Main.new.run