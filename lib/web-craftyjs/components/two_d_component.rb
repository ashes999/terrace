#= require base_component

class TwoDComponent < BaseComponent
  def size(width, height)
    @entity.attr({ :w => width, :h => height })
    return @entity
  end

  def move(x, y)
    @entity.attr({ :x => x, :y => y })
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
