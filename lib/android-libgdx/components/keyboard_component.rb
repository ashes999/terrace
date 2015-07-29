class KeyboardComponent < BaseComponent

	VELOCITY_PER_SECOND = 128

	def initialize
		@move_with_arrows = false
	end

	def move_with_keyboard
    @move_with_arrows = true
  end

	def on_key_press(elapsed_seconds)
		return unless @move_with_arrows

		if Gdx.input.isKeyPressed(Input::Keys::LEFT) || Gdx.input.isKeyPressed(Input::Keys::A)
			@entity.x -= VELOCITY_PER_SECOND * elapsed_seconds
		end
		if Gdx.input.isKeyPressed(Input::Keys::RIGHT) || Gdx.input.isKeyPressed(Input::Keys::D)
			@entity.x += VELOCITY_PER_SECOND * elapsed_seconds
		end
		if Gdx.input.isKeyPressed(Input::Keys::UP) || Gdx.input.isKeyPressed(Input::Keys::W)
			@entity.y -= VELOCITY_PER_SECOND * elapsed_seconds
		end
		if Gdx.input.isKeyPressed(Input::Keys::DOWN) || Gdx.input.isKeyPressed(Input::Keys::S)
			@entity.y += VELOCITY_PER_SECOND * elapsed_seconds
		end
	end
end
