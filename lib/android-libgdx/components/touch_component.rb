class TouchComponent < BaseComponent
	def touch(callback)
		@callback = callback
	end

	### internal

	def on_touch(x, y)
		@callback.call if x >= @entity.x && y >= @entity.y &&
	    x <= @entity.x + @entity.width && y <= @entity.y + @entity.height
	end
end
