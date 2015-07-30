# Opal wrapper around CraftyJS
require 'native'

class Crafty
  def self.init(width, height)
    `Crafty.init(width, height)`
  end

  def self.load(files, onComplete)
    # `files` is an object with $$keys and stuff. That's not what Crafty wants.
    # Crafty demands a hash: { :images => [ ... ], :audio => [ ...] }
    # The native to_n function converts it for us.
    files = files.to_n
    `Crafty.load(files, onComplete)`
  end

  def self.background(color)
    `Crafty.background(color)`
  end

  def self.e(components)
    return Native(`Crafty.e(components)`)
  end

  def self.audio
    return Native(`Crafty.audio`)
  end
end
