class Game
  
  $window = MrubyJs::get_root_object
  $crafty = $window.Crafty
  
  def initialize(width, height)
    $crafty.init(width, height)
    $crafty.background('black')    
  end
end