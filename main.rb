# This is your application entry point. Make sure it starts your game by
# calling Game.new(width, height). If you want to require other files, please
# use "#= require" instead of "require" by itself.

# Load the terrace library, and target-specific code. Do not remove these!
#= require ./lib/common/terrace_common.rb
#= require ./lib/TARGET/terrace.rb
g = Game.new(800, 600)
g.load_images(['content/images/fox.png', 'content/images/emblem.png'], lambda {
  Entity.new(ImageComponent.new, KeyboardComponent.new)
    .image('content/images/fox.png').move_with_keyboard

  Entity.new(ImageComponent.new, KeyboardComponent.new, TwoDComponent.new)
    .image('content/images/emblem.png').move_with_keyboard.move(200, 100)
})
