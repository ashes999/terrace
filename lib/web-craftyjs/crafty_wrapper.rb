# Opal wrapper around CraftyJS
require 'native'

class Crafty
  def self.init(width, height)
    `Crafty.init(width, height)`
  end

  def self.load(files, onComplete)
    # `files` is an object with $$keys and stuff. That's not what Crafty wants.
    # Crafty demands a hash: { :images => [ ... ], :audio => [ ...] }
    # The native to_n function converts it for us, but only on `files`, not on
    # each of the inner arrays. So we have to do this ourselves :(
    # See: https://github.com/opal/opal/issues/1024
    purified_files = {}

    files.each do |k, v|
      if k.start_with?('$')
        #puts "IGNORING #{k}"
      else
        puts "SAFE: #{k}"
        purified_files[k] = v.to_n
      end
    end

    hi = files.to_n
    `var count = 0; for (x in hi) { count += 1; console.log(x); } console.log('count is ' + count + '; audio is ' + hi.audio);`
    `Crafty.load(hi, onComplete)`
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
