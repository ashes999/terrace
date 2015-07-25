class KeyboardComponent < BaseComponent

  # TODO: parameterize
  # pixels per second
  SPEED = 128

  @@all = []

  def self.all
    return @@all
  end

  def initialize
    @@all << self
    @move_with_arrows = false
  end

  def move_with_keyboard
    @move_with_arrows = true
  end

  ### internal

  def update(elapsed_seconds)
    return unless @move_with_arrows
    actual_move = SPEED * elapsed_seconds

    if is_down?(Gosu::KbRight) || is_down?(Gosu::KbD)
      @entity.x += actual_move
    end

    if is_down?(Gosu::KbDown) || is_down?(Gosu::KbS)
      @entity.y += actual_move
    end

    if is_down?(Gosu::KbLeft) || is_down?(Gosu::KbA)
      @entity.x -= actual_move
    end

    if is_down?(Gosu::KbUp) || is_down?(Gosu::KbW)
        @entity.y -= actual_move
    end
  end

  private

  def is_down?(key)
    return Gosu::button_down?(key)
  end
end
