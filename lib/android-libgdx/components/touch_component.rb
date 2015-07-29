class TouchComponent < BaseComponent
	def touch(callback)
		@callback = callback
	end

	### internal

	def on_touch
		# TODO: switch to event-driven: http://www.gamefromscratch.com/post/2013/10/15/LibGDX-Tutorial-4-Handling-the-mouse-and-keyboard.aspx
		mouseX = Gdx.input.getX
		mouseY = Gdx.input.getY

		if (mouseX >= @entity.x && mouseY >= @entity.y &&
			mouseX <= @entity.x + @entity.width && mouseY <= @entity.y + @entity.height)
			@callback.call
		end
	end
end
