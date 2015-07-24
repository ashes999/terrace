class KeyboardComponent < BaseComponent

  def move_with_keyboard
    # TODO: parameterize
    # approximately 40x more than the equivalent in Gosu (8 currently)
    # This seems like a regression. Upgrading CraftyJS may just fix it.
    @entity.fourway(320)
  end

  def crafty_name
    return 'Fourway'
  end
end
