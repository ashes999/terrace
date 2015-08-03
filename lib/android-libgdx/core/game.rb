
java_import com.badlogic.gdx.ApplicationAdapter
java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.Input
java_import com.badlogic.gdx.graphics.OrthographicCamera

# Your main game class. If you change the class name, make sure you update
# libgdx_activity.rb to specify the new game name.
class Game < ApplicationAdapter

  # Whatever's different from the shared game code
	def platform_create
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
		TouchComponent.camera_offset = { :x => x_offset, :y => y_offset }
	end

	def platform_render
		@camera.update

		# render in the camera's coordinate system
		@batch.setProjectionMatrix(@camera.combined)
	end

	def self.launch(game_class)
		# Do nothing. Android's LibgdxActivity takes care of calling new and create.
	end
end
