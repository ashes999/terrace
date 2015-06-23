class TwoDComponent
  attr_accessor :entity

  def size(width, height)
    @entity.attr({ :w => width, :h => height })
    return @entity
  end

  def color(color)
    @entity.color(color)
    return @entity
  end

  def crafty_name
    return 'Color'
  end
end
