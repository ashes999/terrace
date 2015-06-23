require_relative '../../test_config'
require_relative "#{SOURCE_ROOT}/common/core/entity"

class EntityTest < Test::Unit::TestCase

	def test_entity_chains_and_redirects_calls_to_components
    expected = 'EXPECTED string!'
    e = Entity.new(ValueComponent.new)
    e.put('hi').put("WRONG!").put(17.37).put(expected)
    actual = e.get
    assert_equal(expected, actual)
	end
end

class ValueComponent
  attr_reader :value

  def put(s)
    @value = s
    return self
  end

  def get
    return @value
  end
end
