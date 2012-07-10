# Pizzazz

Pizzazz is a simple pure Ruby implementation of code coloring, but just for JSON. Basically, if you have a ruby object and want to show it converted to JSON and add HTML around it so you can color it.

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
* `constant` (for `true` or `false`
* `null`
* `number`

Everything else is left alone. It is recommended to wrap the output like this:

``` html
<pre><%= Pizzazz.ify(object).html_safe %></pre>
```

Here's my stylesheet if you're interested:

``` css
pre {
  border-radius: 5px;
  background: #f7f7f7;
  padding: 0.5em;
  margin-bottom: 2em;
  border: 1px solid #ddd;
}

.string {
  color: #ee6132;
}

.null, .number, .constant {
  color: #8e75c3;
}

.comment {
  color: #999;
  font-style: italic;
}
```

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'pizzazz'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pizzazz

Simple as that. Enjoy.
