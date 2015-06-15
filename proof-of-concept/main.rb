# This is your application entry point. Feel free to define
# whatever you want as far as a constructor and other methods.
# You just need a "run" method.
class Main
  def run
    $window = MrubyJs::get_root_object
    puts "Window is $window"
    puts "The time is now #{Time.new}"
  end
end