class ImageComponent < BaseComponent
  def image(string)
    `#{@entity}.image(string)`
  end

  def width
    `return #{@entity}.w`
  end

  def height
    `return #{@entity}.h`
  end

  def crafty_name
    return 'Image, Alpha'
  end
end
