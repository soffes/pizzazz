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
      @omit_root_container = options[:omit_root_container] || false
      @detect_links = options[:detect_links] == nil ? true : options[:detect_links]
      @sort_keys = options[:sort_keys] == nil ? true : options[:sort_keys]
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

    URL_PATTERN = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,})([\/\w \.-]*)*\/?$/i

    def tab
      %Q{<span class="tab">#{@tab * @indent}</span>}
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
        if @detect_links && is_link?(object)
          %Q{<span class="string link"><a href="#{object}" rel="external"><span class="quote opening">"</span>#{truncate(::ERB::Util.h(object.gsub("\n", '\n')))}<span class="quote closing">"</span></a></span>}
        else
          %Q{<span class="string"><span class="quote opening">"</span>#{truncate(::ERB::Util.h(object.gsub("\n", '\n')))}<span class="quote closing">"</span></span>}
        end

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
        return omit_container ? '' : '<span class="curly-bracket opening">{</span><span class="curly-bracket closing">}</span>' if object.length == 0

        string = if omit_container
          ''
        else
          @indent += 1
          %Q[<span class="curly-bracket opening">{</span>\n]
        end

        rows = []
        keys = object.keys.collect(&:to_s)

        keys.sort! if @sort_keys

        keys.each do |key|
          value = (object[key] != nil ? object[key] : object[key.to_sym])
          row = %Q{<span class="string key"><span class="quote opening">"</span>#{key}<span class="quote closing">"</span></span><span class="comma">:</span> #{node(value)}}

          # Hopefully most keys will be sane since there are probably JSON
          row = %Q{<span class="key-#{key}">#{row}</span>}

          rows << tab + row
        end
        string << rows.join(%Q{<span class="comma">,</span>\n})

        unless omit_container
          @indent -= 1
          string << %Q[\n#{tab}<span class="curley-bracket closing">}</span>]
        end

        string

      when Array
        return omit_container ? '' : '<span class="square-bracket opening">[</span><span class="square-bracket closing">]</span>' if object.length == 0
        string = if omit_container
          ''
        else
          @indent += 1
          %Q{<span class="square-bracket opening">[</span>\n}
        end

        rows = []
        array = @array_limit > 0 ? object[0...@array_limit] : object
        array.each do |value|
          rows << tab + node(value)
        end

        if @array_limit > 0 and object.length > @array_limit
          rows << tab + (object[0].is_a?(Hash) ? "{ #{@array_omission} }" : @array_omission)
        end

        string << rows.join(%Q{<span class="comma">,</span>\n})

        unless omit_container
          @indent -= 1
          string << %Q{\n#{tab}<span class="square-bracket closing">]</span>}
        end

        string
      end
    end

    def is_link?(string)
      scheme = URI.parse(string).scheme
      scheme == 'http' || scheme == 'https'
    rescue
      false
    end
  end
end
