#= require ./lib/common/terrace_common.rb
#= require ./lib/TARGET/terrace.rb

java_import com.badlogic.gdx.ApplicationAdapter
java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.Input

java_import com.badlogic.gdx.graphics.GL20
java_import com.badlogic.gdx.graphics.Texture
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch
java_import com.badlogic.gdx.InputAdapter
java_import com.badlogic.gdx.assets.AssetManager
java_import com.badlogic.gdx.audio.Sound

class TouchInputAdapter < InputAdapter # TODO: switch to InputMultiplexer?
=begin
	def touchDown (x, y, pointer, button)
		MainGame.instance.on_touch(x, y)
		return true # return true to indicate the event was handled
	end
=end
	def touchUp (x, y, pointer, button)
		MainGame.instance.on_touch(x, y)
		return true # return true to indicate the event was handled
	end
end

# Your main game class. If you change the class name, make sure you update
# libgdx_activity.rb to specify the new game name.
class MainGame < ApplicationAdapter

	attr_reader :manager

	@@instance = nil
	def self.instance
		return @@instance
	end

	def initialize
		@loaded = false
	end

	def load_content(assets, lambda)
		@manager = AssetManager.new

		assets[:images].each { |i| @manager.load(i, Texture.java_class) }
		assets[:audio].each { |a| @manager.load(a, Sound.java_class ) }

		# TODO: maybe we want to utilize asynchronous loading later
		# See: https://github.com/libgdx/libgdx/wiki/Asset-manager
		# For now, just go synchronous

		puts "Loading assets ..."
		@manager.finishLoading
		@loaded = true
		puts "... assets loaded! Starting game ..."
		lambda.call
	end

	def create
		@@instance = self
		@batch = SpriteBatch.new
		@last_update = Time.new

		TextComponent.create
		Gdx.input.setInputProcessor(TouchInputAdapter.new)

		load_content({
			:images => ['images/fox.png', 'images/emblem.png'],
			:audio => ['audio/noise.ogg']
		}, lambda {
			touches = 0
		  @t = Entity.new(TextComponent.new, TwoDComponent.new)
		  @t.text('Touches: 0')
		  @t.move(8, 8)

		  @e = Entity.new(ImageComponent.new, KeyboardComponent.new, TwoDComponent.new, TouchComponent.new, AudioComponent.new)
		  @e.image('images/fox.png')
		  @e.move_with_keyboard
		  puts "Size of e is #{@e.width}x#{@e.height}"
			puts "Location of e is #{@e.x}, #{@e.y}"

		  @e.touch(lambda {
				puts "TOUCH registered at #{Time.new}!"
		    @e.play('audio/noise.ogg', { :loop => true })
		    touches += 1
		    @t.text("Touches: #{touches}")
		  })
		})
	end

	def render
		return unless @loaded
		update
		Gdx.gl.glClearColor(0.25, 0.5, 0.75, 1)
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)
		@batch.begin
		ImageComponent.draw(@batch)
		TextComponent.draw(@batch)
		@batch.end
	end

	### internal

	def on_touch(x, y)
		@e.on_touch(x, y)
	end

	private

	def update
		now = Time.new
		elapsed_seconds = now - @last_update
		process_keyboard_input(elapsed_seconds)
		@last_update = now
	end

	def process_keyboard_input(elapsed_seconds)
		@e.on_key_press(elapsed_seconds)
	end
end
