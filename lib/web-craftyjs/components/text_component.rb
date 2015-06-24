#= require base_component

# Displays text. TODO: font customization
class TextComponent < BaseComponent

  def text(text)
    @entity.textFont({ :size => '24px'})
    @entity.textColor('FFFFFF')
    @entity.text(text)
  end

  # Duplicated from TwoDComponent, sadly
  def move(x, y)
    @entity.attr({ :x => x, :y => y })
  end

  def crafty_name
    return 'Text'
  end
end
