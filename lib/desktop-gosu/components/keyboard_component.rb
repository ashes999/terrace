class KeyboardComponent < BaseComponent

  SPEED = 8 # TODO: parameterize

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
  
  def update
    return unless @move_with_arrows

    if is_down?(Gosu::KbRight) || is_down?(Gosu::KbD)
      @entity.x += SPEED
    end

    if is_down?(Gosu::KbDown) || is_down?(Gosu::KbS)
      @entity.y += SPEED
    end

    if is_down?(Gosu::KbLeft) || is_down?(Gosu::KbA)
      @entity.x -= SPEED
    end

    if is_down?(Gosu::KbUp) || is_down?(Gosu::KbW)
        @entity.y -= SPEED
    end
  end

  private

  def is_down?(key)
    return Gosu::button_down?(key)
  end
end
