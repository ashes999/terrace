#= require base_component

class TouchComponent < BaseComponent
  def touch(callback)
    @entity.bind('Click', callback)
  end

  def crafty_name
    return 'Mouse'
  end
end
