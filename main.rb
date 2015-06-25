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
    # called every update tick
  end

  def draw
    ImageComponent::all.each do |i|
      i.draw
    end
  end

  def button_down(id)
    KeyboardComponent.all.each do |k|
      k.on_key(id)
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
  @@all = []

  def self.all
    return @@all
  end

  def move_with_keyboard
    @@all << self
  end

  # internal

  def on_key(key)
    case key
      when Gosu::KbRight
        @entity.x += 8
      when Gosu::KbDown
        @entity.y += 8
      when Gosu::KbLeft
        @entity.x -= 8
      when Gosu::KbUp
        @entity.y -= 8
    end
  end
end

window = GameWindow.new
window.show
