class Entity

  def initialize(*components)
    @components = components

    @components.each do |c|
      c.entity = self
    end
  end

  # Any missing methods? Check our components first.
  # If they don't handle it, we throw.
  def method_missing(m, *args, &block)
    @components.each do |c|
      if c.respond_to?(m)
        to_return = c.send(m, *args, &block)
        return to_return
      end
    end

    raise "No method named '#{m}' was found on this entity or any of its components: #{@components.collect { |o| o.class.to_s } }"
  end
end
