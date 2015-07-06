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
g.load_content({
  :images => ['content/images/fox.png', 'content/images/emblem.png']
}, lambda {
  e = Entity.new(TwoDComponent.new, KeyboardComponent.new)
  e.image('content/images/fox.png')
  e.move_with_keyboard
  e.touch(lambda { puts "The time is #{Time.new}" })
})
```

This sample creates a new `800x600` game with a fox sprite that moves with the arrow keys. Clicking it with the mouse displays the current time.

To run your game in-browser, run `ruby build.rb web-craftyjs`. This will generate the HTML5 version under `bin/web-craftyjs`. To play the game, open `bin/web-craftyjs/index.html` in your browser.

To run your game on your desktop, run `ruby build.rb desktop-gosu`. This will generate a `main.rb` file under `bin/dekstop-gosu`. Run it in Ruby to launch your game.

To run your game on android, run `ruby builld.rb mobile-libgdx`. Provided you have the Android SDK installed, this will generate an `.apk` file under `bin/mobile-libgdx` which you can deploy and test via `adb`.

# Main Components

A summary of the main components and their methods:

- **TwoDComponent:** Anything in 2D space. Has `move(x, y)`, `x`, `y`
- **ImageComponent:** An image! Has `image(filename)`; you can get the `width` and `height`.
- **KeyboardComponent:** Responds to keyboard input. Has `move_with_keyboard()`.
- **TouchComponent:** Receives touches. Has `touch(callback)`
- **AudioComponent:** Can play a sound. Has `play(filename, { :loop => true/false })`
- **TextComponent:** Displays text. Can `move`, and set `text(display_text)`.

## Important Points to Note

- WebRuby uses `console.log` for error handling; please use Chrome to debug (you won't see the console messages in FireFox).
- You can't use backticks in your code. Doing so will break the amalgamation of code (and even if it didn't, Javascript runs in the browser, so it wouldn't work.)

# Supported Platforms and Targets

Currently, we are working on supporting the following platforms and targets:

- **Web:** `web-craftyjs` (Javascript wrappers around CraftyJS)
- **Desktop:** `desktop-gosu` (wrappers around Gosu)
- **Mobile:** `mobile-libgdx` (wrappers around libGDX with JRuby)

# Debug vs. Release Mode

To build your application in release mode, add `release` to the end of the command-line, eg. `ruby build.rb web-craftyjs release`. What this does changes by platform:

- **Web/CraftyJS:** Debug uses `webruby-debug.js`, which is 5MB (!) but produces verbose error messages. Release builds use the `webruby-release.js` file instead.
- **Desktop/Gosu:** Release mode builds compiled binaries. On Windows, you get a `game.exe` file to `bin\desktop-gosu`. You can ship this, along with the `content` directory together, as your final, self-executable game.
- **Mobile/libGDX:** TBD

# Development Environment Setup

If you plan to contribute to `terrace`, you need to set up Ruby (1.9.3 or newer)

## For Windows binaries ##
To build binaries for the desktop target, you also need:

- The `gosu` gem (0.9.2). Follow setup instructions [from the gosu wiki](https://github.com/gosu/gosu/wiki).
- The `ocra` gem (1.9.5).

## For Android binaries ##
To build against the mobile target for Android, you also need to:

- Install the Android SDK installed with the API-16 platform (rubuto takes care of this)
- Install the `ruboto` gem (1.3.0)
- Run `rubuto setup -y`. Note that this installs the Android SDK, ant, etc.
