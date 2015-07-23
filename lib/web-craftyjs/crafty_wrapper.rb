# Opal wrapper around CraftyJS
require 'native'

class Crafty
  def self.init(width, height)
    `Crafty.init(width, height)`
  end

  def self.load(files, onComplete)
    puts "@@@ SELF LOAD #{files}"
    # `files` is an object with $$keys and stuff. That's not what Crafty wants.
    # Crafty demands a hash: { :images => [ ... ], :audio => [ ...] }
    # We convert by using to_s and gsub, because to_json doesn't work
    # (it translates to x.to_s.to_json, which is nonsensical)
    js_hash = files.to_s.gsub('=>', ':')
    hi = js_hash

    `var count = 0; for (x in hi) { count += 1; console.log(x); } console.log('count is ' + count + '; audio is ' + hi.audio);`
    Native(`Crafty.load(hi, onComplete)`)
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
