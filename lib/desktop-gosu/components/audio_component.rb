class AudioComponent < BaseComponent
  def play(filename, options = {})
    @sound = Gosu::Sample.new(Game::window, filename)
    @sound.play(1.0, 1.0, options[:loop] || false) # frequency, volume
  end
end
