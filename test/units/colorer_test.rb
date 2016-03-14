# encoding: UTF-8

require 'test_helper'

class TestColorer < Pizzazz::TestCase
  def test_that_it_colors_hashes
    colored = Pizzazz.ify({:foo => 'bar'})
    assert_equal colored, %q{{
  <span class="string key">"foo"</span>: <span class="string">"bar"</span>
}}
  end

  def test_new_lines
    colored = Pizzazz.ify({:message => "hello\nworld"})
    assert_equal colored, %q{{
  <span class="string key">"message"</span>: <span class="string">"hello\nworld"</span>
}}
  end

  def test_tabs
    colored = Pizzazz.ify({:foo => 'bar'}, tab: '||||')
    assert_equal colored, %q{{
||||<span class="string key">"foo"</span>: <span class="string">"bar"</span>
}}
  end

  def test_prefix
    colored = Pizzazz.ify({:foo => 'bar'}, prefix: '**')
    assert_equal colored, %q{**{
**  <span class="string key">"foo"</span>: <span class="string">"bar"</span>
**}}
  end

  def test_omit_root_container
    colored = Pizzazz.ify({:foo => 'bar'}, omit_root_container: true)
    assert_equal colored, %q{<span class="string key">"foo"</span>: <span class="string">"bar"</span>}

    colored = Pizzazz.ify([1, 2], omit_root_container: true)
    assert_equal colored, %q{<span class="number">1</span>,
<span class="number">2</span>}
  end

  def test_that_it_truncates_arrays
    colored = Pizzazz.ify({:numbers => [1, 2, 3]}, :array_limit => 2)
    assert_equal colored, %q{{
  <span class="string key">"numbers"</span>: [
    <span class="number">1</span>,
    <span class="number">2</span>,
    …
  ]
}}

    colored = Pizzazz.ify({:numbers => [1, 2, 3]}, :array_limit => 1, :array_omission => 'hello')
    assert_equal colored, %q{{
  <span class="string key">"numbers"</span>: [
    <span class="number">1</span>,
    hello
  ]
}}
  end

  def test_that_it_truncates_values
    colored = Pizzazz.ify({:wooden => 'baseball bat'}, :value_limit => 5)
    assert_equal colored, %q{{
  <span class="string key">"wooden"</span>: <span class="string">"base…"</span>
}}

    colored = Pizzazz.ify({:wooden => 'baseball bat'}, :value_limit => 9, :value_omission => '!')
    assert_equal colored, %q{{
  <span class="string key">"wooden"</span>: <span class="string">"baseball!"</span>
}}
  end
end
