
java_import com.badlogic.gdx.ApplicationAdapter
java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.Input

java_import com.badlogic.gdx.graphics.GL20
java_import com.badlogic.gdx.graphics.Texture
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch
java_import com.badlogic.gdx.InputAdapter
java_import com.badlogic.gdx.assets.AssetManager
java_import com.badlogic.gdx.audio.Sound

###
# Handles touch/input processing.
###
class TouchInputAdapter < InputAdapter # TODO: switch to InputMultiplexer?
=begin
	def touchDown (x, y, pointer, button)
		MainGame.instance.on_touch(x, y)
		return true # return true to indicate the event was handled
	end
=end
	def touchUp (x, y, pointer, button)
		TouchComponent.on_touch(x, y, pointer, button)
		return true # return true to indicate the event was handled
	end
end

# Your main game class. If you change the class name, make sure you update
# libgdx_activity.rb to specify the new game name.
class Game < ApplicationAdapter

	attr_reader :manager

  # TODO: scale game to fit screen if it's bigger/smaller than this width/height
  def initialize(width, height)
    # If you don't want to preload, that's your call; we will run.
    @loaded = true
  end

	def create
		@batch = SpriteBatch.new
		@last_update = Time.new
		@manager = AssetManager.new

		TextComponent.create
		AudioComponent.manager = @manager
		Gdx.input.setInputProcessor(TouchInputAdapter.new)
	end

	def load_content(assets, lambda)
    @loaded = false

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

	def render
		return unless @loaded

    now = Time.new
    elapsed_seconds = now - @last_update

		update(elapsed_seconds)
		Gdx.gl.glClearColor(0, 0, 0, 1)
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)

		@batch.begin
		ImageComponent.draw(@batch)
		TextComponent.draw(@batch)
		@batch.end

    @last_update = now
	end

	def self.launch(game_class)
		# Do nothing. Android's LibgdxActivity takes care of calling new and create.
	end

	### internal

	private

	def update(elapsed_seconds)
		KeyboardComponent.process_keyboard_input(elapsed_seconds)
	end
end
