class ImageComponent < BaseComponent
	@@all = []

  def self.all
    return @@all
  end

	def initialize
		@@all << self
	end

	def image(image)
		@texture = Texture.new(image)
	end

	def width
		return @texture.getWidth
	end

	def height
		return @texture.getHeight
	end
	### internal

	def self.draw(spritebatch)
		@@all.each do |s|
			s.draw(spritebatch)
		end
	end

	def draw(spritebatch)
		# invert Y
		spritebatch.draw(@texture, @entity.x, Gdx.graphics.getHeight - @entity.y  - @entity.height)
	end
end
