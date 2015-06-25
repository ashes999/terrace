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
    super(800, 600,false)
    self.caption = "Desktop Target"
    e = Entity.new(ImageComponent.new(self), KeyboardComponent.new, TwoDComponent.new)
    e.image('content/images/fox.png')
    e.move_with_keyboard
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
  end

  def button_down(id)
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

window = GameWindow.new
window.show
