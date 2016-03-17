module Pizzazz
  def self.ify_html(object, options = nil)
    p = Colorer.new(object, options)

    class_name = 'pizzazz'
    if class_name_prefix = options[:class_name_prefix]
      class_name = class_name_prefix + class_name
    end

    html = %(<pre class="#{class_name}">#{p.ify}</pre>)
    html = html.html_safe if Pizzazz::RAILS_AVAILABLE
    html
  end
end
