require 'ruboto/widget'
require 'ruboto/util/toast'
require 'gosu'

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class Player
  attr_reader :score, :x, :y

  def initialize(window)
    @image = Gosu::Image.new(window, Ruboto::R::drawable::star_fighter, false)
    @beep = Gosu::Sample.new(window, Ruboto::R::raw::beep)
    @vel_x = @vel_y = @angle = 0.0
    @x = 320
    @y = 240
    @score = 0
    @font = Gosu::Font.new(window, Gosu::default_font_name, 20)
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Player, @angle)
    @font.draw("Score: #{@score}", 10, 10, 3, 1.0, 1.0, 0xffffff00)
  end

  def touch
    @score += 1
    @beep.play
  end

  def width
    return @image.width
  end

  def height
    return @image.height
  end
end

class Star
  attr_reader :x, :y

  def initialize(animation)
    @animation = animation
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 640
    @y = rand * 480
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size]
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::Stars, 1, 1, @color, :add)
  end
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"

    @background_image = Gosu::Image.new(self, Ruboto::R::drawable::space, true)
    @player = Player.new(self)
    @star_anim = Gosu::Image::load_tiles(self, Ruboto::R::drawable::star, 25, 25, false)
    @stars = Array.new
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def update
    #Normally 25 stars
    if rand(100) < 4 and @stars.size < 5 then
      @stars.push(Star.new(@star_anim))
    end
  end

  # TODO: turn this into touch_ended
  def touch_moved(touch)
    if touch.x >= @player.x && touch.x <= @player.x + @player.width &&
      touch.y >= @player.y && touch.y <= @player.y + @player.height then
      @player.touch
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape then
      close
    end
  end
end

class TemplateActivity
  def on_create(bundle)
    super(bundle)
    Gosu::AndroidInitializer.instance.start(self)
    rescue Exception => e
      puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"
  end

  def on_ready
    window = GameWindow.new
    window.show
    rescue Exception => e
      puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"
  end
end
