class AudioComponent < BaseComponent
  def play(file, options = {})
    # UGLY, hideous interdependencies
    #@sound = Gdx.audio.newSound(Gdx.files.internal(file));
    @sound = MainGame.instance.manager.get(file, Sound.java_class)
    id = @sound.play(1.0)
    @sound.setLooping(id, options[:loop] || false)
    # @sound.dispose here?
  end
end
