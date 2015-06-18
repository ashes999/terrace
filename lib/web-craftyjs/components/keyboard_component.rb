class KeyboardComponent
  attr_accessor :entity
  
  def move_with_keyboard
    @entity.fourway(8)
    return @entity
  end
end