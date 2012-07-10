# encoding: UTF-8
require 'erb'

class Pizzazz::Colorer
  def initialize(object, options = nil)
    options ||= {}
    @object = object
    @indent = 0
    @limit = (options[:limit] or 0)
  end

  def ify
    node(@object, @limit)
  end

private

  def tab
    " " * @indent * Pizzazz::TAB_SIZE
  end

  def node(object, limit = 0)
    case object
    when String
      %Q{<span class="string">"#{::ERB::Util.h(object)}"</span>}
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
      s = "{\n"
      @indent += 1
      rows = []
      object.keys.collect(&:to_s).sort.each do |key|
        value = (object[key] != nil ? object[key] : object[key.to_sym])
        rows << %Q{#{tab}<span class="string">"#{key}"</span>: #{node(value)}}
      end
      s << rows.join(",\n") + "\n"
      @indent -= 1
      s << "#{tab}}"      
      s
    when Array
      if object.length == 0
        "[]"
      else
        s = "[\n"
        @indent += 1
        rows = []
        array = @limit > 0 ? object[0...limit] : object
        array.each do |value|
          rows << tab + node(value)
        end

        if limit > 0 and object.length > limit
          rows << tab + (object[0].is_a?(Hash) ? '{ … }' : '…')
        end

        s << rows.join(",\n") + "\n"
        @indent -= 1
        s << "#{tab}]"
        s
      end
    end
  end
end
