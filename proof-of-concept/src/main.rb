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

Main.new.run