require 'rubygems'
require 'gosu'

class Game < Gosu::Window
  @@window = nil

  def self.window
    return @@window
  end

  def initialize(width, height)
    super(width, height, false)
    @@window = self
    self.caption = "Desktop Target"
  end

  def load_content(files, callback)
    # TODO: file preloading isn't important on Gosu. Even if it was, how would
    # we give the pre-loaded images back to the user on-demand?
    callback.call
    self.show
  end

  ### Internal

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
