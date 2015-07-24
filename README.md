# Terrace

[![build status](https://travis-ci.org/ashes999/terrace.svg?branch=master)](https://travis-ci.org/ashes999/terrace)

**Our vision:** write Ruby code once; run your game on desktop, mobile, and in-browser. We do this by providing a "standard" Ruby interface, and generating equivalent code for various platforms through various back-ends (like `webruby` for web support).

Our current methodology is to **use high-velocity stacks instead of a common code-base.** This means we use CraftyJS (web), Gosu (desktop), and libGDX (android) even though we could use `mruby` with SDL.

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

To run your game on your desktop, run `ruby build.rb desktop-gosu`. This will generate a `main.rb` file under `bin/dekstop-gosu`. Run it in Ruby to launch your game. (You can build it in `release` mode, with Ocra, to generate an executable on Windows.)

To run your game on android, run `ruby builld.rb android-libgdx`. Provided you have the Ruboto installed correctly, this will generate an `.apk` file under `bin/android-libgdx` which you can deploy and test via `adb`.

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
- The meaning of backticks changes; for the web target, you use backticks to execute raw Javascript. For the desktop target, backticks execute locally.

# Supported Platforms and Targets

Terrace is two pieces: a common Ruby platform (eg. our `entity` class), and target-specific code. The target-specific code implements compnents (such as `TwoDComponent`) in whatever that platform's back-end is.

Terrace supports the following targets:

- **web-craftyjs:** [OpalRB](https://github.com/opal/opal) (Ruby to JS converter) with [CraftyJS](https://github.com/craftyjs/Crafty) (HTML5 game engine)
- **desktop-gosu:** [Gosu](https://github.com/gosu/gosu) (desktop game engine)
- **android-libgdx:** [JRuby](https://github.com/jruby/jruby) (Ruby in Java) and [Ruboto](https://github.com/ruboto/ruboto) (JRuby on Android) with [libGDX](https://github.com/libgdx/libgdx) (cross-platform game engine)

## How Terrace Works

When you run `build.rb`, it uses [mrubymix](https://github.com/xxuejie/mrubymix) to combine both the common (pure ruby) code with the specified target (platform-specific) code (this is why we use `#= require` instead of `require`).

All the code (including common and target code) libs in `lib`, while templates (eg. HTML templates for web, Android project template) lives in `templates`.

## Debug vs. Release Mode

To build your application in release mode, add `release` to the end of the command-line, eg. `ruby build.rb desktop-gosu release`. What this does changes by platform:

- **Desktop:** Release mode builds compiled binaries. On Windows, you get a `game.exe` file to `bin\desktop-gosu`. You can ship this, along with the `content` directory together, as your final, self-executable game.
- **Android:** Release mode builds the APK in release mode. Which key file to use is TBD.

# Contributing to Terrace

If you plan to contribute to `terrace`, you need to set up Ruby (1.9.3 or newer), along with platform-specific pieces:

## Web
To build binaries for the web, you need:

- The `opal` gem (0.8.0)

## Windows
To build binaries for the desktop target, you also need:

- The `gosu` gem (0.9.2). Follow setup instructions [from the gosu wiki](https://github.com/gosu/gosu/wiki).
- The `ocra` gem (1.9.5).

When you run the `release` build on Windows, you'll get an executable.

## Android
Arguably the most complex target setup-wise, you need to set up a lot of things. Thankfully, Ruboto covers it.

- Install the `ruboto` gem (1.3.0)
- Run `ruboto setup -y`. This will install the Android SDK, Java, Ant, and any other necessities.
