# encoding: UTF-8

require 'test_helper'

class TestColorer < Pizzazz::TestCase
  def test_that_it_colors_hashes
    colored = Pizzazz.ify({})
    assert_equal colored, '<span class="dictionary"><span class="control bracket curly opening">{</span><span class="control bracket curly closing">}</span></span>'

    colored = Pizzazz.ify({hello: 'World'})
    assert_equal colored, '<span class="dictionary"><span class="control bracket curly opening">{</span>
<span class="control tab">  </span><span class="key-hello"><span class="string key"><span class="control quote opening">"</span><span class="text">hello</span><span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="control quote opening">"</span><span class="text">World</span><span class="control quote closing">"</span></span></span>
<span class="control tab"></span><span class="control bracket curly closing">}</span></span>'
  end

  def test_new_lines
    colored = Pizzazz.ify({message: "Hello\nWorld"})
    assert_equal colored, '<span class="dictionary"><span class="control bracket curly opening">{</span>
<span class="control tab">  </span><span class="key-message"><span class="string key"><span class="control quote opening">"</span><span class="text">message</span><span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="control quote opening">"</span><span class="text">Hello\nWorld</span><span class="control quote closing">"</span></span></span>
<span class="control tab"></span><span class="control bracket curly closing">}</span></span>'
  end

  def test_tabs
    colored = Pizzazz.ify({message: "Hello"}, tab: '||||')
    assert_equal colored, '<span class="dictionary"><span class="control bracket curly opening">{</span>
<span class="control tab">||||</span><span class="key-message"><span class="string key"><span class="control quote opening">"</span><span class="text">message</span><span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="control quote opening">"</span><span class="text">Hello</span><span class="control quote closing">"</span></span></span>
<span class="control tab"></span><span class="control bracket curly closing">}</span></span>'
  end

  def test_prefix
    colored = Pizzazz.ify({message: "Hello"}, prefix: '*')
    assert_equal colored, '<span class="prefix">*</span><span class="dictionary"><span class="control bracket curly opening">{</span>
<span class="prefix">*</span><span class="control tab">  </span><span class="key-message"><span class="string key"><span class="control quote opening">"</span><span class="text">message</span><span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="control quote opening">"</span><span class="text">Hello</span><span class="control quote closing">"</span></span></span>
<span class="prefix">*</span><span class="control tab"></span><span class="control bracket curly closing">}</span></span>'
  end

#   def test_that_it_truncates_arrays
#     colored = Pizzazz.ify({:numbers => [1, 2, 3]}, :array_limit => 2)
#     assert_equal colored, %q{<span class="control curly-bracket opening">{</span>
# <span class="control tab">  </span><span class="key-numbers"><span class="string key"><span class="control quote opening">"</span>numbers<span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="control square-bracket opening">[</span>
# <span class="control tab">    </span><span class="number">1</span><span class="control comma">,</span>
# <span class="control tab">    </span><span class="number">2</span><span class="control comma">,</span>
# <span class="control tab">    </span><span class="array-omission">…</span>
# <span class="control tab">  </span><span class="control square-bracket closing">]</span></span>
# <span class="control tab"></span><span class="control curley-bracket closing">}</span>}

#     colored = Pizzazz.ify({:numbers => [1, 2, 3]}, :array_limit => 1, :array_omission => 'hello')
#     assert_equal colored, %q{<span class="control curly-bracket opening">{</span>
# <span class="control tab">  </span><span class="key-numbers"><span class="string key"><span class="control quote opening">"</span>numbers<span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="control square-bracket opening">[</span>
# <span class="control tab">    </span><span class="number">1</span><span class="control comma">,</span>
# <span class="control tab">    </span><span class="array-omission">hello</span>
# <span class="control tab">  </span><span class="control square-bracket closing">]</span></span>
# <span class="control tab"></span><span class="control curley-bracket closing">}</span>}
#   end

#   def test_that_it_truncates_values
#     colored = Pizzazz.ify({:wooden => 'baseball bat'}, :value_limit => 5)
#     assert_equal colored, %q{<span class="control curly-bracket opening">{</span>
# <span class="control tab">  </span><span class="key-wooden"><span class="string key"><span class="control quote opening">"</span>wooden<span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="quote opening">"</span>base…<span class="quote closing">"</span></span></span>
# <span class="control tab"></span><span class="control curley-bracket closing">}</span>}

#     colored = Pizzazz.ify({:wooden => 'baseball bat'}, :value_limit => 9, :value_omission => '!')
#     assert_equal colored, %q{<span class="control curly-bracket opening">{</span>
# <span class="control tab">  </span><span class="key-wooden"><span class="string key"><span class="control quote opening">"</span>wooden<span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="quote opening">"</span>baseball!<span class="quote closing">"</span></span></span>
# <span class="control tab"></span><span class="control curley-bracket closing">}</span>}
#   end

#   def test_link
#     colored = Pizzazz.ify({:website => 'http://soff.es'})
#     assert_equal colored, %q{<span class="control curly-bracket opening">{</span>
# <span class="control tab">  </span><span class="key-website"><span class="string key"><span class="control quote opening">"</span>website<span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string link"><a href="http://soff.es" rel="external"><span class="quote opening">"</span><span class="text">http://soff.es</span><span class="quote closing">"</span></a></span></span>
# <span class="control tab"></span><span class="control curley-bracket closing">}</span>}

#     colored = Pizzazz.ify({:website => 'http://soff.es'}, :detect_links => false)
#     assert_equal colored, %q{<span class="control curly-bracket opening">{</span>
# <span class="control tab">  </span><span class="key-website"><span class="string key"><span class="control quote opening">"</span>website<span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="quote opening">"</span>http://soff.es<span class="quote closing">"</span></span></span>
# <span class="control tab"></span><span class="control curley-bracket closing">}</span>}
#   end

#   def test_sort_keys
#     colored = Pizzazz.ify({:b => 'foo', :a => 'bar'})
#     assert_equal colored, %q{<span class="control curly-bracket opening">{</span>
# <span class="control tab">  </span><span class="key-a"><span class="string key"><span class="control quote opening">"</span>a<span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="quote opening">"</span>bar<span class="quote closing">"</span></span></span><span class="control comma">,</span>
# <span class="control tab">  </span><span class="key-b"><span class="string key"><span class="control quote opening">"</span>b<span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="quote opening">"</span>foo<span class="quote closing">"</span></span></span>
# <span class="control tab"></span><span class="control curley-bracket closing">}</span>}

#     colored = Pizzazz.ify({:b => 'foo', :a => 'bar'}, :sort_keys => false)
#     assert_equal colored, %q{<span class="control curly-bracket opening">{</span>
# <span class="control tab">  </span><span class="key-b"><span class="string key"><span class="control quote opening">"</span>b<span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="quote opening">"</span>foo<span class="quote closing">"</span></span></span><span class="control comma">,</span>
# <span class="control tab">  </span><span class="key-a"><span class="string key"><span class="control quote opening">"</span>a<span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="quote opening">"</span>bar<span class="quote closing">"</span></span></span>
# <span class="control tab"></span><span class="control curley-bracket closing">}</span>}
#   end
end
