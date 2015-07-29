class ImageComponent < BaseComponent
	def image(image)
		@texture = Texture.new(image)
	end

	def draw(spritebatch)
		# invert Y
		spritebatch.draw(@texture, @entity.x, Gdx.graphics.getHeight - @entity.y  - @entity.height)
	end

	def width
		return @texture.getWidth
	end

	def height
		return @texture.getHeight
	end
end
