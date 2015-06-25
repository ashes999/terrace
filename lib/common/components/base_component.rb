# A common base-class component. Used internally only (for DRY).
class BaseComponent
  attr_accessor :entity

  private

  # Please don't use this class directly.
  def initialize
  end
end
