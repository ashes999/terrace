class Entity
  $window = MrubyJs::get_root_object
  $crafty = $window.Crafty
  
  def initialize(components)
    @me = $crafty.e(components)
    return @me
  end
  
  # TODO: un-hard-code and break into component code
  
  def size(width, height)
    @me.attr({ :w => width, :h => height })
  end
  
  def color(string)
    @me.color(string)
  end
  
  def move_to_input
    @me.fourway(8)
  end
end