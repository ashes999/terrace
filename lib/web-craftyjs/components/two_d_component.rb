class TwoDComponent
  attr_accessor :entity
  
  def size(width, height)
    @entity.attr({ :w => width, :h => height })
    return @entity
  end
  
  def color(string)
    @entity.color(string)
    return @entity
  end
end