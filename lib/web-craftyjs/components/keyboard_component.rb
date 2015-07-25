class KeyboardComponent < BaseComponent

  def move_with_keyboard
    # TODO: parameterize
    # This is pixels per second
    @entity.fourway(128)
  end

  def crafty_name
    return 'Fourway'
  end
end
