# Opal wrapper around CraftyJS
class Crafty
  def self.init(width, height)
    `Crafty.init(width, height)`
  end

  def self.load(files, onComplete)
    `Crafty.load(files, onComplete)`
  end

  def self.background(color)
    `Crafty.background(color)`
  end

  def self.e(components)
    `return Crafty.e(components)`
  end
end
