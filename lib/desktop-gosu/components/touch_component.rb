class TouchComponent < BaseComponent
  @@all = []

  def self.all
    return @@all
  end

  def initialize
    @@all << self
  end

  def touch(callback)
    @callback = callback
  end

  ### internal

  def button_down(id)
    # TODO: if there's a camera, these need to be translated from window-space
    # to world-space.
    m_x = Game.window.mouse_x
    m_y = Game.window.mouse_y

    @callback.call if id == Gosu::MsLeft &&
      m_x >= @entity.x && m_x <= @entity.x + @entity.width &&
      m_y >= @entity.y && m_y <= @entity.y + @entity.height
  end
end
