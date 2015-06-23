# A common base-class component. Used internally only (for DRY).
class BaseComponent
  attr_accessor :entity

  def crafty_name
    raise 'Please override and specify CraftyJS component names'
  end

  private
  
  # Please don't use this class directly.
  def initialize
  end

end
