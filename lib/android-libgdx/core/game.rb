
java_import com.badlogic.gdx.ApplicationAdapter
java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.Input

java_import com.badlogic.gdx.graphics.GL20
java_import com.badlogic.gdx.graphics.Texture
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch
java_import com.badlogic.gdx.InputAdapter
java_import com.badlogic.gdx.assets.AssetManager
java_import com.badlogic.gdx.audio.Sound
java_import com.badlogic.gdx.graphics.OrthographicCamera

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
		@width = width
		@height = height
    # If you don't want to preload, that's your call; we will run.
    @loaded = true
  end

	def create
		@batch = SpriteBatch.new
		@last_update = Time.new
		@manager = AssetManager.new

		# Methodology: pick the smallest size that will fit on-screen. Letterbox.
		# Since we're in landscape mode, fit the height and leave space for the width.
		screen_width = Gdx.graphics.getWidth
		screen_height = Gdx.graphics.getHeight
		width_fit = [[screen_width, @width].max.to_f / [screen_width, @width].min.to_f].min
		height_fit = [[screen_height, @height].max.to_f / [screen_height, @height].min.to_f].min
		scale = [width_fit, height_fit].min
		# The actual display size when we scale up or down
		scaled_width = (@width * scale).to_i
		scaled_height = (@height * scale).to_i

		# Maintain aspect ratio so we don't stretch/skew. Center on-screen.
		x_offset = (screen_width - scaled_width) / 2
		y_offset = (screen_height - scaled_height) / 2

		if scaled_width == screen_width
			# width fits perfectly, extend height to maintain aspect ratio
			scaled_height = screen_height
		else
			# height fits perfectly, extend with to maintain aspect ratio
			scaled_width = screen_width
		end

		@camera = OrthographicCamera.new
		@camera.setToOrtho(false, scaled_width, scaled_height)
		@camera.position.set(-x_offset + (scaled_width / 2), -y_offset + (scaled_height / 2), 0);

		Gdx.input.setInputProcessor(TouchInputAdapter.new)

		TextComponent.create
		AudioComponent.manager = @manager
		TouchComponent.camera = @camera
		TouchComponent.camera_offset = { :x => x_offset, :y => y_offset }
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
		@camera.update

		# render in the camera's coordinate system
		@batch.setProjectionMatrix(@camera.combined)
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
