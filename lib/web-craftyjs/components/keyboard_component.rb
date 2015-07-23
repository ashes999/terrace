class KeyboardComponent < BaseComponent
  def move_with_keyboard
    @entity.fourway(8)
  end

  def crafty_name
    return 'Fourway'
  end
end
