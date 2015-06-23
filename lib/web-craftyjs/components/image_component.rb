#= require base_component

class ImageComponent < BaseComponent
  def image(string)
    @entity.image(string)
    return @entity
  end

  def crafty_name
    return 'Image, Alpha'
  end
end
