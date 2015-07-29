java_import com.badlogic.gdx.graphics.g2d.BitmapFont

class TextComponent < BaseComponent
  @@all = []

  def self.all
    return @@all
  end

  def self.create
    @@default_font = BitmapFont.new
  end

  def initialize
    @font = @@default_font
    @display_text = ''
    @@all << self
  end

  def text(display_text)
    @display_text = display_text
  end

  ### internal

  def self.draw(spritebatch)
    @@all.each do |t|
      t.draw(spritebatch)
    end
  end

  def draw(spritebatch)
    @font.draw(spritebatch, @display_text, @entity.x, @entity.y)
  end
end
