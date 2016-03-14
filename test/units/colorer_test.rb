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

  def test_link
    colored = Pizzazz.ify({:website => 'http://soff.es'})
    assert_equal colored, %q{{
  <span class="string key">"website"</span>: <span class="string link"><a href="http://soff.es" rel="external">"http://soff.es"</a></span>
}}

    colored = Pizzazz.ify({:website => 'http://soff.es'}, :detect_links => false)
    assert_equal colored, %q{{
  <span class="string key">"website"</span>: <span class="string">"http://soff.es"</span>
}}
  end

  def test_key_order
    colored = Pizzazz.ify({:content => 'Hello', :type => 'Message'})
    assert_equal colored, %q{{
  <span class="string key">"content"</span>: <span class="string">"Hello"</span>,
  <span class="string key">"type"</span>: <span class="string">"Message"</span>
}}

    colored = Pizzazz.ify({:content => 'Hello', :type => 'Message', :b => 'foo', :a => 'bar'}, :key_orderer => Proc.new { |keys|
      return ['type', 'content']
    })
    assert_equal colored, %q{{
  <span class="string key">"content"</span>: <span class="string">"Hello"</span>,
  <span class="string key">"type"</span>: <span class="string">"Message"</span>
  <span class="string key">"a"</span>: <span class="string">"bar"</span>
  <span class="string key">"b"</span>: <span class="string">"foo"</span>
}}
  end
end
