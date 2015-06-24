# This is your application entry point. Make sure it starts your game by
# calling Game.new(width, height). If you want to require other files, please
# use "#= require" instead of "require" by itself.

# Load the terrace library, and target-specific code. Do not remove these!
#= require ./lib/common/terrace_common.rb
#= require ./lib/TARGET/terrace.rb
g = Game.new(800, 600)
#g.load_images(['content/images/fox.png', 'content/images/emblem.png'], lambda {
  e = Entity.new(ImageComponent.new, KeyboardComponent.new, TwoDComponent.new, TouchComponent.new)
  e.image('content/images/fox.png')
  e.move_with_keyboard
  e.touch(lambda { e.move(e.x + 100, e.y + 100)  })
#})
