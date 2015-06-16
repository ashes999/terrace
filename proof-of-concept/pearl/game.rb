class Game
  
  $window = MrubyJs::get_root_object
  $crafty = $window.Crafty
  
  def initialize
    $crafty.init(800, 600)
    $crafty.background('black')    
  end
end