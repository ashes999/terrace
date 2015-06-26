class TextComponent < BaseComponent
  @@all = []

  def self.all
    return @@all
  end

  def initialize
    @@all << self
    @font = Gosu::Font.new(Game::window, Gosu::default_font_name, 24)
  end

  def text(display_text)
    @display_text = display_text
  end

  def draw
    # white
    @font.draw(@display_text, @entity.x, @entity.y, @entity.z, 1.0, 1.0, 0xFFFFFFFF)
  end
end
