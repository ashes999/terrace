class Entity
  $window = MrubyJs::get_root_object
  $crafty = $window.Crafty
  
  def initialize(components)
    @components = components
    
    # Convert names into a string list that CraftyJS wants
    # These are the basic/global ones that always apply.
    component_names = '2D, Canvas,'
    
    @components.each do |c|
      name = get_craftyjs_name(c.class.to_s) # class.name doesn't exist      
      component_names = "#{component_names} #{name}, "   
    end
    
    @me = $crafty.e(component_names)
    
    @components.each do |c|
      # In CraftyJS, you make calls directly to the entity, not components
      c.entity = @me
    end
  end
  
  private
  
  def get_craftyjs_name(class_name)
    if class_name == 'TwoDComponent'
        return 'Color, Alpha'
    elsif class_name == 'KeyboardComponent'
      return 'Fourway'
    else
      return class_name[0, class_name.rindex('Component')]
    end      
  end    
end