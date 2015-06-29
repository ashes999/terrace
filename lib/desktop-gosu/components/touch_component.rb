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
    @callback.call if id == Gosu::MsLeft
  end
end
