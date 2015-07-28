# require ./lib/TARGET/terrace.rb

java_import com.badlogic.gdx.ApplicationAdapter
java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.Input

java_import com.badlogic.gdx.graphics.GL20
java_import com.badlogic.gdx.graphics.Texture
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch

# Your main game class. If you change the class name, make sure you update
# libgdx_activity.rb to specify the new game name.
class MainGame < ApplicationAdapter

	VELOCITY_PER_SECOND = 128

	def create
		@batch = SpriteBatch.new
		@img = Texture.new("badlogic.jpg");
		@last_update = Time.new
		@coordinates = { :x => 32, :y => 64 }
	end

	def render
		update
		Gdx.gl.glClearColor(0.25, 0.5, 0.75, 1)
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)
		@batch.begin
		@batch.draw(@img, @coordinates[:x], @coordinates[:y])
		@batch.end
	end

	private

	def update
		now = Time.new
		elapsed_seconds = now - @last_update

		if Gdx.input.isKeyPressed(Input::Keys::LEFT) || Gdx.input.isKeyPressed(Input::Keys::A)
			@coordinates[:x] -= VELOCITY_PER_SECOND * elapsed_seconds
		end
		if Gdx.input.isKeyPressed(Input::Keys::RIGHT) || Gdx.input.isKeyPressed(Input::Keys::D)
			@coordinates[:x] += VELOCITY_PER_SECOND * elapsed_seconds
		end
		if Gdx.input.isKeyPressed(Input::Keys::UP) || Gdx.input.isKeyPressed(Input::Keys::W)
			@coordinates[:y] -= VELOCITY_PER_SECOND * elapsed_seconds
		end
		if Gdx.input.isKeyPressed(Input::Keys::DOWN) || Gdx.input.isKeyPressed(Input::Keys::S)
			@coordinates[:y] += VELOCITY_PER_SECOND * elapsed_seconds
		end
		@last_update = now
	end
end
