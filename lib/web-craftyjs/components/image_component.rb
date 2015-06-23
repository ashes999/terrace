class ImageComponent
  attr_accessor :entity

  def image(string)
    @entity.image(string)
    return @entity
  end

  def crafty_name
    return 'Image, Alpha'
  end
end
