class TouchComponent < BaseComponent

	@@all = []
	@@camera_offset = { :x => 0, :y => 0}

	def self.camera_offset=(offset)
		@@camera_offset = offset
	end

	def initialize
		@@all << self
	end

	def touch(callback)
		@callback = callback
	end

	### internal

	def self.on_touch(x, y, pointer, button)
		@@all.each { |t| t.on_touch(x, y, pointer, button) }
	end

	# x/y are screen-space? coordinates -- y=0 is the top!
	# pointer is the pointer (for multi-touch, increments)
	# button is the hardware device button (eg. home, back buttons)
	def on_touch(x, y, pointer, button)
		x -= @@camera_offset[:x] unless @@camera_offset.nil?
		y -= @@camera_offset[:y] unless @@camera_offset.nil?

		@callback.call if x >= @entity.x && y >= @entity.y &&
	    x <= @entity.x + @entity.width && y <= @entity.y + @entity.height
	end
end
