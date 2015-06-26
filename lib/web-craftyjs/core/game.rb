class Game

  $window = MrubyJs::get_root_object
  $crafty = $window.Crafty

  # Creates a new game surface
  def initialize(width, height)
    $crafty.init(width, height)
    $crafty.background('black')
  end

  # Loads images and audio. Files is a hash. When done, it invokes the callback.
  # eg. files = { :images => [ ... ], :audio => [ ... ] }
  def load_content(files, callback)
    $crafty.load(files, lambda {
      callback.call
    })
  end
end
