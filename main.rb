# This is your application entry point. Feel free to define
# whatever you want as far as classes and methods. Just make
# sure it starts execution of your game.
# Any source files in "src" will be included first.
class Main
  def run
    g = Game.new(800, 600)
    g.load_images(['content/images/fox.png'], lambda {
      e = Entity.new(ImageComponent.new, KeyboardComponent.new)
      e.image('content/images/fox.png').move_with_keyboard
    })
  end
end

Main.new.run
