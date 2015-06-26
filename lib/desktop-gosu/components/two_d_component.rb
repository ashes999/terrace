class TwoDComponent < BaseComponent
  attr_accessor :x, :y, :z

  def initialize
    @x = @y = @z = 0
  end

  def size(width, height)
    raise "This method is not supported on Gosu"
  end

  def color(color)
    raise "This method is not supported on Gosu"
  end

  def move(x, y)
    @x = x
    @y = y
  end
end
