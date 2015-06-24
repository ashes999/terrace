# Terrace

**Our vision:** write Ruby code once; run your game on desktop, mobile, and in-browser. We do this by providing a "standard" Ruby interface, and generating equivalent code for various platforms through various back-ends (like `webruby` for web support).

We're currently in the very early stages of development, to try and make this work. Our current methodology is to **use high-velocity stacks instead of a common code-base.** This means we use CraftyJS (web) and Gosu (desktop), even though we could use `mruby` with SDL.

# Getting Started

To start, edit `main.rb` and add code for your game, like so:

```
# Load the terrace library, and target-specific code. Do not remove these!
#= require ./lib/common/terrace_common.rb
#= require ./lib/TARGET/terrace.rb
g = Game.new(800, 600)
g.load_images(['content/images/fox.png'], lambda {
  e = Entity.new(TwoDComponent.new, KeyboardComponent.new)
  e.image('content/images/fox.png')
  e.move_with_keyboard
  e.touch(lambda { puts "The time is #{Time.new}" })
})
```

This sample creates a new `800x600` game with a fox sprite that moves with the arrow keys. Clicking it with the mouse displays the current time.

To run your game, run `ruby build.rb`. This will generate all the files for the default target (currently `web-craftyjs`) under `bin/web-craftyjs`. To play the game, open `bin/web-craftyjs/index.html` in your browser.

# Main Components

A summary of the main components and their methods:

- **TwoDComponent:** Anything in 2D space. Has `move(x, y)`, `x`, `y`
- **ImageComponent:** An image! Has `image(filename)`
- **KeyboardComponent:** Responds to keyboard input. Has `move_with_keyboard()`.
- **TouchComponent:** Receives touches. Has `touch(callback)`
- **AudioComponent:** Can play a sound. Has `play(filename, { :loop => true/false })`
- **textComponent:** Displays text. Can `move`, and set `text(display_text)`.

## Important Points to Note

- WebRuby uses `console.log` for error handling; please use Chrome to debug (you won't see the console messages in FireFox).
- You can't use backticks in your code. Doing so will break the amalgamation of code (and even if it didn't, Javascript runs in the browser, so it wouldn't work.)

# Supported Platforms and Targets

Currently, we are working on supporting the following platforms and targets:

- **Web:** `web-craftyjs` (Javascript)
- **Desktop:** `desktop-gosu`
- **Mobile:** `mobile-android`

# Debug vs. Release Mode

To build your application in release mode, add `release` to the end of the command-line, eg. `ruby build.rb web-craftyjs release`. Differences are:

- **Web/CraftyJS:** Debug uses `webruby-debug.js`, which is 5MB (!) but produces verbose error messages. Release builds use the `webruby-release.js` file instead.

# Development Environment Setup

If you plan to contribute to `terrace`, you need the following set up:

- Ruby (1.9.3 or newer)
