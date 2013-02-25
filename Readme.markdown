# Pizzazz

Pizzazz is a simple pure Ruby implementation of code coloring, but just for JSON. Basically, if you have a ruby object and want to show it converted to JSON and add HTML around it so you can color it.

[Cheddar](http://cheddarapp.com) uses this to show example output of it's API calls. [Check it out](https://cheddarapp.com/developer/lists).

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
object = { name: 'Sam Soffes', website: 'http://samsoff.es' }
Pizzazz.ify(object)
#=> "{\n  <span class=\"string\">\"name\"</span>: <span class=\"string\">\"Sam Soffes\"</span>,\n  <span class=\"string\">\"website\"</span>: <span class=\"string\">\"http://samsoff.es\"</span>\n}"
```

You can optionally limit arrays as well:

``` ruby
Pizzazz.ify(all_of_the_things, limit: 1)
```

This will add an ellipses after the first element.

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

### Stylesheet

If you're using the asset pipeline, you can simply require `pizzazz` to get my stylesheet. Be sure your `<pre>` has the `pizzazz` class. If you use `ify_html` it will automatically do this.


## Supported Ruby Versions

Pizzazz is tested under 1.8.7, 1.9.3, 2.0.0, and JRuby (1.9 mode).

[![Build Status](https://travis-ci.org/soffes/pizzazz.png?branch=master)](https://travis-ci.org/soffes/pizzazz)

## Contributing

See the [contributing guide](Contributing.markdown).
