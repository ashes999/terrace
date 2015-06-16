# This is your application entry point. Feel free to define
# whatever you want as far as classes and methods. Just make
# sure it starts execution of your game.
class Main
  def run
    $window = MrubyJs::get_root_object
    $crafty = $window.Crafty
    Game.new
    puts "Done at #{Time.new}"
  end
end

Main.new.run