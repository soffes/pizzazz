# encoding: UTF-8

require 'erb'

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
      @omit_root_container = options[:omit_root_container] || false
    end

    def ify
      return '' unless @object

      # Parse
      output = node(@object, true)
      return output unless @prefix

      # Add prefix
      lines = output.split("\n")
      @prefix + lines.join("\n#{@prefix}")
    end

  private

    def tab
      @tab * @indent
    end

    def truncate(string)
      return string if @value_limit < 1
      text = string.dup
      stop = @value_limit - @value_omission.length
      (text.length > @value_limit ? text[0...stop] + @value_omission : text).to_s
    end

    def node(object, root = false)
      omit_container = root && @omit_root_container

      case object
      when String
        %Q{<span class="string">"#{truncate(::ERB::Util.h(object))}"</span>}

      when Time
        %Q{<span class="string">#{object.to_json}</span>}

      when TrueClass
        %Q{<span class="constant">true</span>}

      when FalseClass
        %Q{<span class="constant">false</span>}

      when NilClass
        %Q{<span class="null">null</span>}

      when Numeric
        %Q{<span class="number">#{object}</span>}

      when Hash
        return omit_container ? '' : '{}' if object.length == 0

        string = if omit_container
          ''
        else
          @indent += 1
          "{\n"
        end

        rows = []
        object.keys.collect(&:to_s).sort.each do |key|
          value = (object[key] != nil ? object[key] : object[key.to_sym])
          rows << %Q{#{tab}<span class="string key">"#{key}"</span>: #{node(value)}}
        end
        string << rows.join(",\n")

        unless omit_container
          @indent -= 1
          string << "\n#{tab}}"
        end

        string

      when Array
        return omit_container ? '' : '[]' if object.length == 0
        string = if omit_container
          ''
        else
          @indent += 1
          "[\n"
        end

        rows = []
        array = @array_limit > 0 ? object[0...@array_limit] : object
        array.each do |value|
          rows << tab + node(value)
        end

        if @array_limit > 0 and object.length > @array_limit
          rows << tab + (object[0].is_a?(Hash) ? "{ #{@array_omission} }" : @array_omission)
        end

        string << rows.join(",\n")

        unless omit_container
          @indent -= 1
          string << "\n#{tab}]"
        end

        string
      end
    end
  end
end
