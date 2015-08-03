# Terrace

[![build status](https://travis-ci.org/ashes999/terrace.svg?branch=master)](https://travis-ci.org/ashes999/terrace)

**Our vision:** write Ruby code and run your game on desktop, mobile, and in-browser. We do this by providing a "standard" Ruby interface, and generating equivalent code for various platforms through various back-ends (like `webruby` for web support).

Our current methodology is to **use high-velocity stacks instead of a common code-base.** This means we use CraftyJS (web) and libGDX (desktop/android) even though we could use `mruby` with SDL everywhere.

# Getting Started

To start, `main.rb` looks like this:

```
# ... some requires and other notes ...

class MainGame < Game

  def initialize
    super(800, 600)
  end

  def create
    super

    load_content({
      :images => ['content/images/fox.png', 'content/images/background.jpg'],
      :audio => ['content/audio/noise.ogg']
    }, lambda {
      Entity.new(TwoDComponent.new, ImageComponent.new).image('content/images/background.jpg')

      e = Entity.new(ImageComponent.new, KeyboardComponent.new, TwoDComponent.new, TouchComponent.new, AudioComponent.new)
      e.image('content/images/fox.png')
      e.move_with_keyboard

      touches = 0
      t = Entity.new(TextComponent.new, TwoDComponent.new)
      t.text('Touches: 0')
      t.move(8, 8)

      e.touch(lambda {
        e.play('content/audio/noise.ogg')
        touches += 1
        t.text("Touches: #{touches}")
      })
    })
  end
end

Game.launch(MainGame)
```

This sample creates a new `800x600` game with a fox sprite on a space background. The fox moves with the arrow keys (or `WASD`). Clicking the fox with the mouse (or touching it on Android) plays a sound and increments the touch count, which is displayed as text.  The sample also pre-loads all the necessary images and audio files.

To run your game in-browser, run `rake` or `rake build:web`. This will generate the HTML5 version under `bin/web-craftyjs`. To play the game, open `bin/web-craftyjs/index.html` in your browser.

To run your game on your desktop, run `rake build:desktop`. This will generate a `main_game.rb` file under `bin/desktop-libgdx`. Run it with JRuby to launch your game.

To run your game on android, run `rake build:android`. Provided you have [Ruboto installed and setup correctly](https://github.com/ashes999/terrace#android), this will generate a `Libgdx-Debug.apk` file under `bin/android-libgdx/bin` which you can deploy and test via `adb`.

# Main Components

A summary of the main components and their methods:

- **TwoDComponent:** Anything in 2D space. Has `move(x, y)`, `x`, `y`
- **ImageComponent:** An image! Has `image(filename)`; you can get the `width` and `height`.
- **KeyboardComponent:** Responds to keyboard input. Has `move_with_keyboard()`.
- **TouchComponent:** Receives touches. Has `touch(callback)`
- **AudioComponent:** Can play a sound. Has `play(filename, { :loop => true/false })`
- **TextComponent:** Displays text. Can `move`, and set `text(display_text)`.

# Supported Platforms and Targets

Two pieces make up terrace:
- A common Ruby-agnostic platform (eg. our `entity` class)
- Target-specific code (eg. `ImageComponent` for the web target).

Terrace supports the following targets:

- **web-craftyjs:** [OpalRB](https://github.com/opal/opal) (Ruby to JS converter) with [CraftyJS](https://github.com/craftyjs/Crafty) (HTML5 game engine)
- **desktop-libgdx:** [JRuby](https://github.com/jruby/jruby) (Ruby in Java) and with [libGDX](https://github.com/libgdx/libgdx) (cross-platform game engine)
- **android-libgdx:** Same as above, with [Ruboto](https://github.com/ruboto/ruboto) (JRuby on Android)


The meaning of backticks also changes per platform:

- **Web:** backticks execute raw Javascript
- **Desktop:** backticks execute local commands
- **Android:** backticks execute android commands

## How Terrace Works

When you run `rake build:<target>`, it uses [mrubymix](https://github.com/xxuejie/mrubymix) to combine both the common Rby code with the specified target (platform-specific) code (this is why we use `#= require` instead of `require`).

All the code (including common and target code) libs in `lib`, while templates (eg. HTML templates for web, Android project templates) live in `templates`.

## Debug vs. Release Mode

To build your application in release mode, add `release` to the end of the command-line, eg. `ruby build.rb desktop-gosu release`. What this does changes by platform:

- **Desktop:** TBD: Release mode builds compiled, self-contained binaries.
- **Android:** TBD: Release mode builds the APK in release mode, which uses the key file.

# Target Setup

To use Terrace, you need Ruby (1.9.3 or newer), along with platform-specific pieces:

## Web
To build binaries for the web, you need:

- The `opal` gem (0.8.0)

## Desktop
To run the desktop target, you also need:

- JRuby 1.7.13 or newer

## Android
Arguably the most complex target setup-wise, you need to set up a lot of things. Thankfully, Ruboto covers it.

- Install the `ruboto` gem (1.3.0)
- Run `ruboto setup -y`. This will install the Android SDK, Java, Ant, and any other necessities.
