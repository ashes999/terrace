class ImageComponent < BaseComponent
  def image(string)
    @entity.image(string)
  end

  def crafty_name
    return 'Image, Alpha'
  end
end
