# This is your application entry point. Make sure it starts your game by
# calling Game.new(width, height). If you want to require other files, please
# use "#= require" instead of "require" by itself.

# Load the terrace library, and target-specific code. Do not remove these!
#= require ./lib/common/terrace_common.rb
#= require ./lib/TARGET/terrace.rb

class MainGame < Game

  def initialize
    super(800, 600)
  end

  def create
    super

    load_content({
      :images => ['content/images/fox.png', 'content/images/emblem.png'],
      :audio => ['content/audio/noise.ogg']
    }, lambda {
      touches = 0
      t = Entity.new(TextComponent.new, TwoDComponent.new)
      t.text('Touches: 0')
      t.move(8, 8)

      e = Entity.new(ImageComponent.new, KeyboardComponent.new, TwoDComponent.new, TouchComponent.new, AudioComponent.new)
      e.image('content/images/fox.png')
      e.move_with_keyboard
      puts "Size of e is #{e.width}x#{e.height}"

      e.touch(lambda {
        e.play('content/audio/noise.ogg')
        touches += 1
        t.text("Touches: #{touches}")
      })
    })
  end
end

MainGame.new.create unless RUBY_PLATFORM == 'java'
