class TwoDComponent < BaseComponent
  def size(width, height)
    @entity.attr({ :w => width, :h => height })
  end

  def move(x, y)
    @entity.attr({ :x => x, :y => y })
  end

  def color(color)
    @entity.color(color)
  end

  def x
    return @entity.x
  end

  def y
    return @entity.y
  end

  def crafty_name
    return 'Color'
  end
end
