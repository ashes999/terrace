# Plays an audio file, with options (like looping).
class AudioComponent < BaseComponent

  # Plays a sound. options can include :loop => true/false
  def play(filename, options = {})
    # Needs a key, and a filename. Use the filename as the key
    key = filename
    Crafty.audio.add(key, filename)
    loop = options[:loop] || false
    loop = (loop == true) ? -1 : 1
    Crafty.audio.play(key, loop)
  end

  def crafty_name
    return '' # Uses Crafty(...) directly, doesn't need a component
  end
end
