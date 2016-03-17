# encoding: UTF-8

require 'erb'
require 'uri'

module Pizzazz
  class Colorer
    def initialize(object, options = nil)
      options ||= {}
      @object = object
      @indent = 0
      @array_limit = options[:array_limit] || options[:limit] || 0
      @array_omission = options[:array_omission] || '…'
      @value_limit = options[:value_limit] || 0
      @value_omission = options[:value_omission] || '…'
      @tab = options[:tab] || '  '
      @prefix = options[:prefix]
      @detect_links = options[:detect_links] == nil ? true : options[:detect_links]
      @sort_keys = options[:sort_keys] == nil ? true : options[:sort_keys]
      @class_name_prefix = options[:class_name_prefix] || ''
    end

    def ify
      return '' unless @object

      # Parse
      output = node(@object, true)
      return output unless @prefix

      # Add prefix
      prefix = span(@prefix, 'prefix')
      lines = output.split("\n")
      prefix + lines.join("\n#{prefix}")
    end

  private

    URL_PATTERN = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,})([\/\w \.-]*)*\/?$/i

    def tab
      span @tab * @indent, 'control tab'
    end

    def truncate(string)
      return string if @value_limit < 1
      text = string.dup
      stop = @value_limit - @value_omission.length
      (text.length > @value_limit ? text[0...stop] + @value_omission : text).to_s
    end

    def node(object, root = false)
      case object
      when String
        @detect_links && is_link?(object) ? link(object) : string(object)
      when Time
        span object.to_json, 'string time'
      when TrueClass
        span 'true', 'boolean true'
      when FalseClass
        span 'false', 'boolean false'
      when NilClass
        span 'null', 'null'
      when Numeric
        span object, 'number'
      when Hash
        hash object
      when Array
        array object
      end
    end

    def is_link?(string)
      scheme = URI.parse(string).scheme
      scheme == 'http' || scheme == 'https'
    rescue
      false
    end

    def span(content, class_names = nil)
      class_names = class_names.split(' ') if class_names.is_a?(String)
      class_names = if class_names.empty?
        ''
      else
        class_names = %( class="#{class_names.map { |name| @class_name_prefix + name }.join(' ')}")
      end

      %(<span#{class_names}>#{content}</span>)
    end

    def array_omission
      span @array_omission, 'omission array'
    end

    def text(object)
      object = truncate(::ERB::Util.h(object.gsub("\n", '\n')))
      opening_quote + span(object, 'text') + closing_quote
    end

    def string(object, class_name = 'string')
      span text(object), class_name
    end

    def link(object)
      a = %(<a href="#{object}" rel="external">#{text(object)}</a>)
      span a, 'string link'
    end

    def hash(object)
      return span(opening_curly + closing_curly, 'dictionary') if object.length == 0

      @indent += 1
      string = opening_curly + "\n"

      rows = []
      keys = object.keys.collect(&:to_s)

      keys.sort! if @sort_keys

      keys.each do |key|
        value = (object[key] != nil ? object[key] : object[key.to_sym])
        row = %(#{string(key, 'string key') + colon} #{node(value)})

        # Wrap row in with class for key.
        # Hopefully most keys will be sane since it's probably JSON.
        row = tab + span(row, "key-#{key}")
        rows << row
      end
      string << rows.join(comma + "\n")

      @indent -= 1
      string << "\n" + tab + closing_curly

      span string, 'dictionary'
    end

    def array(object)
      return span(opening_square + closing_square, 'array') if object.length == 0

      @indent += 1
      string = opening_square + "\n"

      rows = []
      array = @array_limit > 0 ? object[0...@array_limit] : object
      array.each do |value|
        rows << tab + node(value)
      end

      if @array_limit > 0 and object.length > @array_limit
        rows << tab + (object[0].is_a?(Hash) ? %(#{opening_curly} #{array_omission} #{closing_curly}) : array_omission)
      end

      string << rows.join(comma + "\n")

      @indent -= 1
      string << "\n" + tab + closing_square

      span string, 'array'
    end

    def opening_quote
      span '"', 'control quote opening'
    end

    def closing_quote
      span '"', 'control quote closing'
    end

    def opening_curly
      span '{', 'control bracket curly opening'
    end

    def closing_curly
      span '}', 'control bracket curly closing'
    end

    def opening_square
      span '[', 'control bracket square opening'
    end

    def closing_square
      span ']', 'control bracket square closing'
    end

    def comma
      span ',', 'control comma'
    end

    def colon
      span ':', 'control colon'
    end
  end
end
