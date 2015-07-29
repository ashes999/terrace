class TwoDComponent < BaseComponent
	attr_accessor :x, :y

	def initialize
		@x = @y = 0
	end

	def move(x, y)
		@x = x
		@y = y
	end

	def color(color)
		raise "Color is not supported on this platform"
	end

	def size(width, height)
		raise "Size is not supported on this platform"
	end
end
