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
    @e = Entity.new(ImageComponent.new(self))
    @e.image('content/images/fox.png')
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
      when Gosu::KbRight
        @e.move(@e.x + 50, @e.y)
    end
  end
end

class TwoDComponent
  attr_accessor :x, :y

  # def size(width, height)
  # def color(color)

  def move(x, y)
    @x = x
    @y = y
  end
end

class ImageComponent < TwoDComponent

  @@all_images = []

  def self.all
    return @@all_images
  end

  def initialize(window)
    @window = window
    @x = @y = @z = 0
  end

  def image(string)
    @image = Gosu::Image.new(@window, string, false)
    @@all_images << self
  end

  def draw
    @image.draw(@x, @y, @z)
  end
end

window = GameWindow.new
window.show
