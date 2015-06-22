# Terrace

**Our vision:** write Ruby code once; run your game on desktop, mobile, and in-browser. We do this by providing a "standard" Ruby interface, and generating equivalent code for various platforms through various back-ends (like `webruby` for web support).

We're currently in the very early stages of development, to try and make this work. Our current methodology is to **use high-velocity stacks instead of a common code-base.** This means we use CraftyJS (web) and Gosu (desktop), even though we could use `mruby` with SDL.

# Getting Started

To start, edit `main.rb` and add code for your game, like so:

```
class Main
  def run    
    Game.new(800, 600)
    e = Entity.new(TwoDComponent.new, KeyboardComponent.new)
    e.size(32, 32).color('red').move_with_keyboard
    puts "Done at #{Time.new}"
  end
end

Main.new.run # start game execution
```

This sample creates a new `800x600` game with a `32x32` red box that moves with the arrow keys.

To run your game, run `ruby build.rb`. This will combine all the ruby files together into a single script, and generate the HTML5 version of the game.

To play the game, open `bin/index.html` in your browser.

## Important Points to Note

- WebRuby uses `console.log` for error handling; please use Chrome to debug (you won't see the console messages in FireFox).
- Source files are aggregated together *alphabetically*, starting with `lib` code. `main.rb` is always added last.
- For debugging, we automatically include `webruby-debug.js`. This file is 5MB (!), but produces verbose error messages.
- For release builds, specify `release` (eg. `build.rb web-craftyjs release`) to link the `webruby-release.js` file instead.
- We can't meaningfully report on WebRuby versions since we're using a custom build. We're probably using `0.9.3`.
- You can't use backticks in your code. Doing so will break the amalgamation of code (and even if it didn't, Javascript runs in the browser, so it wouldn't work.)

# Supported Platforms and Targets

Currently, we are working on supporting the following platforms and targets:

- **Web:** `web-craftyjs` (Javascript)
- **Desktop:** `desktop-linux`
- **Mobile:** `mobile-android`

