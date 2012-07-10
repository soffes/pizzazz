require 'test_helper'

class TestColorer < MiniTest::Unit::TestCase
  def test_that_it_colors_hashes
    assert_equal Pizzazz.ify({foo: 'bar'}), %Q{{\n  <span class="string">"foo"</span>: <span class="string">"bar"</span>\n}}
  end
  
  # These need to be expanded
end
