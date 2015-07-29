#= require ./lib/common/terrace_common.rb
#= require ./lib/TARGET/terrace.rb

java_import com.badlogic.gdx.ApplicationAdapter
java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.Input

java_import com.badlogic.gdx.graphics.GL20
java_import com.badlogic.gdx.graphics.Texture
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch

# Your main game class. If you change the class name, make sure you update
# libgdx_activity.rb to specify the new game name.
class MainGame < ApplicationAdapter

	def create
		@batch = SpriteBatch.new
		@last_update = Time.new
=begin
		touches = 0
	  t = Entity.new(TextComponent.new, TwoDComponent.new)
	  t.text('Touches: 0')
	  t.move(8, 8)
=end
	  @e = Entity.new(ImageComponent.new, KeyboardComponent.new, TwoDComponent.new, TouchComponent.new)#, AudioComponent.new)
	  @e.image('badlogic.jpg')
	  @e.move_with_keyboard
	  puts "Size of e is #{@e.width}x#{@e.height}"
		puts "Location of e is #{@e.x}, #{@e.y}"

	  @e.touch(lambda {
			puts "TOUCHY!"
	    #@e.play('noise.ogg')
	    #touches += 1
	    #t.text("Touches: #{touches}")
	  })
	end

	def render
		update
		Gdx.gl.glClearColor(0.25, 0.5, 0.75, 1)
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)
		@batch.begin
		@e.draw(@batch)
		@batch.end
	end

	private

	def update
		now = Time.new
		elapsed_seconds = now - @last_update
		process_keyboard_input(elapsed_seconds)
		process_mouse_input
		@last_update = now
	end

	def process_keyboard_input(elapsed_seconds)
		@e.on_key_press(elapsed_seconds)
	end

	def process_mouse_input
		if Gdx.input.isButtonPressed(Input::Buttons::LEFT)
			@e.on_touch
		end
	end
end
