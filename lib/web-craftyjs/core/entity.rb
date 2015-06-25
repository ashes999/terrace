class Entity
  $window = MrubyJs::get_root_object
  $crafty = $window.Crafty

  def initialize(*components)
    ##### set @components and on each, set @entity?
    
    # Convert names into a string list that CraftyJS wants
    # These are the basic/global ones that always apply.
    component_names = '2D, Canvas,'

    @components.each do |c|
      component_names = "#{component_names} #{c.crafty_name}, "
    end

    @me = $crafty.e(component_names)
  end
end
