class AudioComponent < BaseComponent
  def play(file, options = {})
    # UGLY, hideous interdependencies
    #@sound = Gdx.audio.newSound(Gdx.files.internal(file));
    @sound = MainGame.instance.manager.get(file, Sound.java_class)
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
