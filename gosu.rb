# This is your application entry point. Make sure it starts your game by
# calling Game.new(width, height). If you want to require other files, please
# use "#= require" instead of "require" by itself.

# Load the terrace library, and target-specific code. Do not remove these!
#= require ./lib/common/terrace_common.rb
#= require ./lib/TARGET/terrace.rb

require 'rubygems'
require 'gosu'
require './lib/common/core/entity'

class GameWindow < Gosu::Window

  def initialize
    clicks = 0

    super(800, 600,false)
    self.caption = "Desktop Target"

    t = Entity.new(TwoDComponent.new, TextComponent.new(self))
    t.text("Clicks: 0")

    e = Entity.new(ImageComponent.new(self), KeyboardComponent.new, TwoDComponent.new, TouchComponent.new, AudioComponent.new(self))
    e.image('content/images/fox.png')
    e.move_with_keyboard
    e.touch(lambda {
      clicks += 1
      e.play('content/audio/noise.ogg')
      t.text("Clicks: #{clicks}")
    })
  end

  # Always show the mouse
  def needs_cursor?
    return true
  end

  def update
    KeyboardComponent::all.each do |k|
      k.update
    end
  end

  def draw
    ImageComponent::all.each do |i|
      i.draw
    end

    TextComponent::all.each do |t|
      t.draw
    end
  end

  def button_down(id)
    TouchComponent::all.each do |t|
      t.button_down(id)
    end

    case id
      when Gosu::KbEscape
        close  # exit on press of escape key
    end
  end
end

class BaseComponent
  attr_accessor :entity
end

class TwoDComponent < BaseComponent
  attr_accessor :x, :y, :z

  def initialize
    @x = @y = @z = 0
  end

  # def size(width, height)
  # def color(color)

  def move(x, y)
    @x = x
    @y = y
  end
end

class ImageComponent < BaseComponent

  ##### TODO: refactor into module? so it can be DRY.
  # Also, don't add if we're already in there.
  @@all = []

  def self.all
    return @@all
  end

  def initialize(window)
    @window = window
  end

  def image(string)
    @image = Gosu::Image.new(@window, string, false)
    @@all << self
  end

  def draw
    @image.draw(@entity.x, @entity.y, @entity.z) # TODO: use Z (currently 0)
  end
end

class KeyboardComponent < BaseComponent

  SPEED = 8 # TODO: parameterize

  @@all = []

  def self.all
    return @@all
  end

  def move_with_keyboard
    @@all << self
  end

  # internal
  def update
    if is_down?(Gosu::KbRight) || is_down?(Gosu::KbD)
      @entity.x += SPEED
    end

    if is_down?(Gosu::KbDown) || is_down?(Gosu::KbS)
      @entity.y += SPEED
    end

    if is_down?(Gosu::KbLeft) || is_down?(Gosu::KbA)
      @entity.x -= SPEED
    end

    if is_down?(Gosu::KbUp) || is_down?(Gosu::KbW)
        @entity.y -= SPEED
    end
  end

  private

  def is_down?(key)
    return Gosu::button_down?(key)
  end
end

class TouchComponent < BaseComponent
  @@all = []

  def self.all
    return @@all
  end

  def touch(callback)
    @callback = callback
    @@all << self
  end

  # internal
  def button_down(id)
    @callback.call if id == Gosu::MsLeft
  end
end

class AudioComponent < BaseComponent
  @@all = []

  def self.all
    return @@all
  end

  def initialize(window)
    @window = window
  end

  def play(filename, options = {})
    @@all << self
    @sound = Gosu::Sample.new(@window, filename)
    @sound.play(1.0, 1.0) # frequency, volume
  end
end

class TextComponent < BaseComponent

  @@all = []

  def self.all
    return @@all
  end

  def initialize(window)
    @font = Gosu::Font.new(window, Gosu::default_font_name, 24)
  end

  def text(display_text)
    @display_text = display_text
    @@all << self
  end

  def draw
    # white
    @font.draw(@display_text, @entity.x, @entity.y, @entity.z, 1.0, 1.0, 0xFFFFFFFF)
  end
end

window = GameWindow.new
window.show
