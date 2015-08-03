class AudioComponent < BaseComponent

  @@manager = nil

  def self.manager=(manager)
    @@manager = manager
  end

  def play(file, options = {})
    # UGLY, hideous interdependencies
    #@sound = Gdx.audio.newSound(Gdx.files.internal(file));
    @sound = @@manager.get(file, Sound.java_class)
    if options[:loop] == true
      id = @sound.loop(1.0)
    else
      id = @sound.play(1.0)
    end
  end

  def dispose
    @sound.dispose
  end
end
