# This is your application entry point. Make sure it starts your game by
# calling Game.new(width, height). If you want to require other files, please
# use "#= require" instead of "require" by itself.

# Load the terrace library, and target-specific code. Do not remove these!
#= require ./lib/common/terrace_common.rb
#= require ./lib/TARGET/terrace.rb

def scancode_to_s(code)
  SDL2::Input::Keyboard::scancode_name(code)
end

def windowevent_to_s(event)
  case event
  when SDL2::Input::SDL_WINDOWEVENT_SHOWN then "shown"
  when SDL2::Input::SDL_WINDOWEVENT_HIDDEN then "hidden"
  when SDL2::Input::SDL_WINDOWEVENT_EXPOSED then "exposed"
  when SDL2::Input::SDL_WINDOWEVENT_MOVED then "moved"
  when SDL2::Input::SDL_WINDOWEVENT_RESIZED then "resized"
  when SDL2::Input::SDL_WINDOWEVENT_SIZE_CHANGED then "size_changed"
  when SDL2::Input::SDL_WINDOWEVENT_MINIMIZED then "minimized"
  when SDL2::Input::SDL_WINDOWEVENT_MAXIMIZED then "maximized"
  when SDL2::Input::SDL_WINDOWEVENT_RESTORED then "restored"
  when SDL2::Input::SDL_WINDOWEVENT_ENTER then "enter"
  when SDL2::Input::SDL_WINDOWEVENT_LEAVE then "leave"
  when SDL2::Input::SDL_WINDOWEVENT_FOCUS_GAINED then "focus_gained"
  when SDL2::Input::SDL_WINDOWEVENT_FOCUS_LOST then "focus_lost"
  when SDL2::Input::SDL_WINDOWEVENT_CLOSE then "close"
  else "unknown"
  end
end

# create cursor from string.
cursor_s = <<CURSOR
XXXXXXXXXX
X........X
X.......XX
X......XX
X.....XX
X....XX
X...XX
X..XX
X.XX
XXX
CURSOR

# cursor data is mapped to each bits.
# "32 * 4" means that "32 pixels * 4byte * 8bits = 32 pixels * 32 pixels".
cursor_data = SDL2::ByteBuffer.new(32 * 4)
cursor_mask = SDL2::ByteBuffer.new(32 * 4)

puts cursor_s.length
i = 0
byte_index = 0;
while i < cursor_s.length
  if (i % 8) != 0 then
    cursor_data[byte_index] = cursor_data[byte_index] << 1
    cursor_mask[byte_index] = cursor_mask[byte_index] << 1
  else
    byte_index += 1
    cursor_data[byte_index] = 0
  end
  case cursor_s[i]
    when 'X' then
      cursor_data[byte_index] |= 1
      cursor_mask[byte_index] |= 1
    when '.' then
      cursor_data[byte_index] |= 0
      cursor_mask[byte_index] |= 1
    else
      cursor_data[byte_index] |= 0
      cursor_mask[byte_index] |= 0
  end
  i += 1
end

# Please modify the path.
PATH_TO_SAMPLE_WAV = "/tmp/bird_caw1.wav"

def format_to_s(fmt)
  case fmt
    when SDL2::Audio::AUDIO_S8 then "S8"
    when SDL2::Audio::AUDIO_U8 then "U8"
    when SDL2::Audio::AUDIO_S16LSB then "S16LSB"
    when SDL2::Audio::AUDIO_S16MSB then "S16MSB"
    when SDL2::Audio::AUDIO_S16SYS then "S16SYS"
    when SDL2::Audio::AUDIO_S16 then "S16"
    when SDL2::Audio::AUDIO_U16LSB then "U16LSB"
    when SDL2::Audio::AUDIO_U16MSB then "U16MSB"
    when SDL2::Audio::AUDIO_U16SYS then "U16SYS"
    when SDL2::Audio::AUDIO_U16 then "U16"
    when SDL2::Audio::AUDIO_S32LSB then "S32LSB"
    when SDL2::Audio::AUDIO_S32MSB then "S32MSB"
    when SDL2::Audio::AUDIO_S32SYS then "S32SYS"
    when SDL2::Audio::AUDIO_S32 then "S32"
    when SDL2::Audio::AUDIO_F32LSB then "F32LSB"
    when SDL2::Audio::AUDIO_F32MSB then "F32MSB"
    when SDL2::Audio::AUDIO_F32SYS then "F32SYS"
    when SDL2::Audio::AUDIO_F32 then "F32"
    else "UNKNOWN"
  end
end

def display_spec(spec)
  puts "  Frequency: #{spec.freq} Hz"
  puts "  Channels:  #{spec.channels}"
  puts "  Format:    #{format_to_s(spec.format)}"
  puts "  Samples:   #{spec.samples}"
end

SDL2::init

begin
  SDL2::Video::init
  begin
    # Audio# Audio
    drivers = SDL2::Audio::drivers
    i = 0
    puts "Available Audio Drivers:"
    drivers.each do |name|
      puts "  #{name}"
    end

    while i < drivers.length
      begin
        SDL2::Audio::init(drivers[i])
        puts "Audio driver \"#{drivers[i]}\" is opened."
        break
      rescue SDL2::SDL2Error => e
        p e
      end
      i += 1
    end
    begin
      data = SDL2::Audio::AudioData.new(PATH_TO_SAMPLE_WAV)
      puts "Audio spec of loaded wav file:"
      display_spec(data.spec)
      offset = 0
      data.spec.callback = proc {|udata, stream, len|
        if offset > data.length then
          SDL2::Audio::pause(true)
        end
        SDL2::Audio::mix_audio(stream, 0, data, offset, len, 32)
        offset += len
      }
      aspec = SDL2::Audio::open data.spec
      puts "Audio spec of opened device:"
      display_spec(aspec);
        # Play sound 5 seconds.
        SDL2::Audio::pause(false)
    end
    # Graphics
      w = SDL2::Video::Window.new "sample", 100, 100, 640, 480, SDL2::Video::Window::SDL_WINDOW_OPENGL
      surface = w.surface
      FW=20
      FH=20
      for y in 0..23
        for x in 0..31
          surface.fill_rect (x * 8) << ((y / 8).to_i * 8), SDL2::Rect.new(x * FW, y * FH, FW, FH)
        end
      end
      w.update_surface
      SDL2::delay(2000)
      w.destroy

    # Input
    w = SDL2::Video::Window.new "sample", 100, 100, 640, 480, SDL2::Video::Window::SDL_WINDOW_SHOWN
    c = SDL2::Input::Mouse::Cursor.new(cursor_data.cptr, cursor_mask.cptr, 32, 32, 0, 0)
    SDL2::Input::Mouse::cursor = c
    puts c
    renderer = SDL2::Video::Renderer.new(w)
    renderer.draw_color = SDL2::RGB.new(0, 0, 0)
    renderer.clear
    renderer.draw_color = SDL2::RGB.new(0xff, 0xff, 0xff)
    old_p = nil
    render_on = false
    until (ev = SDL2::Input::wait).nil?
      puts case ev.type
      when SDL2::Input::SDL_KEYDOWN then
        "down: #{scancode_to_s(ev.keysym.scancode)}"
      when SDL2::Input::SDL_KEYUP then
        "up: #{scancode_to_s(ev.keysym.scancode)}"
      when SDL2::Input::SDL_WINDOWEVENT then
        "window: #{windowevent_to_s(ev.event)}"
      when SDL2::Input::SDL_MOUSEMOTION then
        if render_on then
          if old_p.nil? then
            old_p = SDL2::Point.new(ev.x, ev.y)
          else
            renderer.draw_line(old_p, SDL2::Point.new(ev.x, ev.y))
            old_p = SDL2::Point.new(ev.x, ev.y)
          end
        end
        "mouse motion: #{ev.x}, #{ev.y}"
      when SDL2::Input::SDL_MOUSEBUTTONDOWN then
        render_on = true
        old_p = nil
        "mouse button down: #{ev.x}, #{ev.y}"
      when SDL2::Input::SDL_MOUSEBUTTONUP then
        render_on = false
        old_p = nil
        "mouse button up: #{ev.x}, #{ev.y}"
      when SDL2::Input::SDL_QUIT then
        "quit"
      else
        "?: #{ev.to_s}"
      end
      if ev.type == SDL2::Input::SDL_QUIT then
        break
      end
      renderer.present
    end
    renderer.destroy
    w.destroy
  ensure
    SDL2::Video::quit
    SDL2::Audio::pause(true)
    SDL2::Audio::close
  end
ensure
  SDL2::quit
end
