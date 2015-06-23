class Game

  $window = MrubyJs::get_root_object
  $crafty = $window.Crafty

  # Creates a new game surface
  def initialize(width, height)
    $crafty.init(width, height)
    $crafty.background('black')
  end

  # Loads images. When done, it invokes the callback.
  def load_images(images, callback)
    $crafty.load({ :images => images }, lambda {
      callback.call
    })
  end
end
