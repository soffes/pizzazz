# Pizzazz

[![Build Status](https://travis-ci.org/soffes/pizzazz.png?branch=master)](https://travis-ci.org/soffes/pizzazz) [![Test Coverage](https://codeclimate.com/github/soffes/pizzazz/badges/coverage.svg)](https://codeclimate.com/github/soffes/pizzazz/coverage) [![Code Climate](https://codeclimate.com/github/soffes/pizzazz.png)](https://codeclimate.com/github/soffes/pizzazz) [![Dependency Status](https://gemnasium.com/soffes/pizzazz.png)](https://gemnasium.com/soffes/pizzazz) [![Gem Version](https://badge.fury.io/rb/pizzazz.png)](http://badge.fury.io/rb/pizzazz)

Pizzazz is a simple pure Ruby implementation of code coloring, but just for JSON. Basically, if you have a ruby object and want to show it converted to JSON and add HTML around it so you can color it.


## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'pizzazz'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pizzazz

Simple as that.


## Usage

Pizzazzifing an object is simple:

``` ruby
object = { name: 'Sam Soffes', website: 'http://soff.es' }
Pizzazz.ify(object)
```

``` html
<span class="dictionary"><span class="control bracket curly opening">{</span>
<span class="control tab">  </span><span class="key-name"><span class="string key"><span class="control quote opening">"</span><span class="text">name</span><span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string"><span class="control quote opening">"</span><span class="text">Sam Soffes</span><span class="control quote closing">"</span></span></span><span class="control comma">,</span>
<span class="control tab">  </span><span class="key-website"><span class="string key"><span class="control quote opening">"</span><span class="text">website</span><span class="control quote closing">"</span></span><span class="control colon">:</span> <span class="string link"><a href="http://soff.es" rel="external"><span class="control quote opening">"</span><span class="text">http://soff.es</span><span class="control quote closing">"</span></a></span></span>
<span class="control tab"></span><span class="control bracket curly closing">}</span></span>
```

You can optionally limit arrays or values as well:

``` ruby
Pizzazz.ify(all_of_the_things, array_limit: 1, value_limit: 100)
```

This will add an ellipses after the first element and truncate values longer than 100 characters. You can replace the ellipses by setting the `array_omission` and then `value_omission` options:

``` ruby
Pizzazz.ify(all_of_the_things, array_limit: 'etc', value_omission: '... (continued)')
```

You can also supply `prefix` to add a string to the beginning of each line of the output. You can also supply `class_name_prefix` to prefix the classes that are generated.

By defauly, hash keys are sorted alphabetically. You can disable this with `sort_keys: false`.

### HTML

Spans are added around various elements. Here's the classes:

* `string`
* `constant` (`true` or `false`)
* `null`
* `number`

Everything else is left alone.

If you want it wrapped in `<pre class="pizzazz">` (and call `html_safe` if possible), do the following:

``` ruby
Pizzazz.ify_html(object)
```

By default, Pizzazz will convert any links starting with `http` to `<a>` tags. You can disable this by passing `detect_links: false`.


### Stylesheet

If you're using the asset pipeline, you can simply require `pizzazz` to get my stylesheet. Be sure your `<pre>` has the `pizzazz` class. If you use `ify_html` it will automatically do this.


## Supported Ruby Versions

Pizzazz is tested under 2.0.0, 2.2.4, JRuby 1.7.2 (1.9 mode), and Rubinius 2.0.0 (1.9 mode).


## Contributing

See the [contributing guide](Contributing.markdown).
