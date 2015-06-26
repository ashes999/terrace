class ImageComponent < BaseComponent

  @@all = []

  def self.all
    return @@all
  end

  def initialize()
    @@all << self
  end

  def image(string)
    @image = Gosu::Image.new(Game::window, string, false)
  end

  def draw
    @image.draw(@entity.x, @entity.y, @entity.z) # TODO: use Z (currently 0)
  end
end
