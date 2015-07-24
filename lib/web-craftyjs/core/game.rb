class Game
  # Creates a new game surface
  def initialize(width, height)
    Crafty.init(width, height)
    Crafty.background('black')
  end

  # Loads images and audio. Files is a hash. When done, it invokes the callback.
  # eg. files = { :images => [ ... ], :audio => [ ... ] }
  def load_content(files, callback)
    Crafty.load(files, callback)
  end
end
