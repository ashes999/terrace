# Terrace

**Our vision:** write Ruby code once; run your game on desktop, mobile, and in-browser. We do this by providing a "standard" Ruby interface, and generating equivalent code for various platforms through various back-ends (like `webruby` for web support).

Our current methodology is to **use high-velocity stacks instead of a common code-base.** This means we use CraftyJS (web) and Gosu (desktop), even though we could use `mruby` with SDL.

This project is **no longer under active development.** With the exception of Android (which was very hard to produce a stable back-end for), the code works as expected. If a solid, high-velocity back-end for Android emerges (such as a [true Gosu port to Android](https://github.com/gosu/gosu/issues/273)), I may restart this project.

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

~~To run your game on android, run `ruby builld.rb android-gosuandroid`. Provided you have the Android SDK installed, this will generate an `.apk` file under `bin/mobile-libgdx` which you can deploy and test via `adb`.~~

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

# Development Environment Setup

If you plan to contribute to `terrace`, you need to set up Ruby (1.9.3 or newer)

## For Windows binaries ##
To build binaries for the desktop target, you also need:

- The `gosu` gem (0.9.2). Follow setup instructions [from the gosu wiki](https://github.com/gosu/gosu/wiki).
- The `ocra` gem (1.9.5).

# Next Steps: Android Back-End #

Android is very difficult target to get working. I had a hard time getting `mruby` to compile (even though the [mruby-sdl2](https://github.com/crimsonwoods/mruby-sdl2) and [mruby-minigame](https://github.com/bggd/mruby-minigame) gems looked promising). I am [not](https://github.com/mruby/mruby/issues/2872) a proficient C/C++ developer.

LibGDX showed promise, but integration with JRuby probably requires a lot of work, so I didn't pursue it.

[Gosu-Android](https://github.com/Garoe/gosu-android/), despite being a dead project, provided the best approach. However, due to some bugs (like [audio replaying strangely](https://github.com/Garoe/gosu-android/issues/14), [touch-done events not firing](https://github.com/Garoe/gosu-android/issues/18), and [screen coordinate wierdness](https://github.com/Garoe/gosu-android/issues/19)), I decided to abandon it.

There are many paths forward -- libGDX, gosu-android, the port of gosu to Android, and even SDL with MRuby. I leave it to you to fork and do what you think is best.

To build against the mobile target for Android, you would need to:

- Install the Android SDK installed with the API-16 platform ~~(rubuto takes care of this)~~
- ~~Install the `ruboto` gem (1.3.0)~~
- ~~Run `rubuto setup -y`. Note that this installs the Android SDK, ant, etc.~~
