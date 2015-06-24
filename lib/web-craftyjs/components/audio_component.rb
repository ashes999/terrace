#= require base_component

class AudioComponent < BaseComponent

  $window = MrubyJs::get_root_object

  # Plays a sound. options can include :loop => true/false
  def play(filename, options = {})
    # Needs a key, and a filename. Use the filename as the key
    key = filename
    $window.Crafty.audio.add(key, filename)
    loop = options[:loop] || false
    loop = (loop == true) ? -1 : 1
    $window.Crafty.audio.play(key, loop)
  end

  def crafty_name
    return '' # Uses Crafty(...) directly, doesn't need a component
  end
end
