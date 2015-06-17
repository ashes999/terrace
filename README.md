# Game Library

**Our vision:** write Ruby code once; run your game on desktop, mobile, and in-browser.  

We're currently in the very early stages of development, to try and make this work.

# Getting Started

To start, edit `main.rb` and add code for your game. Make sure it runs the game, like the below example (which consumes CraftyJS directly):

```
class Main
  def run
    $window = MrubyJs::get_root_object
    $crafty = $window.Crafty
    Game.new
    puts "Done at #{Time.new}"
  end
end

Main.new.run
```

To run your game, run `ruby build.rb`. This will combine all the ruby files together into a single script, and generate the HTML5 version of the game.

To play the game, open `bin/index.html` in your browser.

## Important Points to Note

- WebRuby uses `console.log` for error handling; please use Chrome to debug (you won't see the console messages in FireFox).
- Source files are aggregated together *alphabetically*, starting with `lib` code. `main.rb` is always added last.
- For debugging, we automatically include `webruby-debug.js`. This file is 5MB (!), but produces verbose error messages.
- For release builds, specify `release` (eg. `build.rb release`) to link the `webruby-release.js` file instead.
- We can't meaningfully report on WebRuby versions. We're probably using `0.9.3`.
- You can't use backticks in your code. Doing so will break the amalgamation of code (and even if it didn't, Javascript runs in the browser, so it wouldn't work.)

# Supported Platforms and Targets

Currently, we are working on supporting the following platforms and targets:

- **Web:** `web-craftyjs` (Javascript)
- **Desktop:** `desktop-linux`
- **Mobile:** `mobile-android`

