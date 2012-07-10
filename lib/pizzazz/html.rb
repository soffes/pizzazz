module Pizzazz
  def self.ify_html(object, options = nil)
    p = Colorer.new(object, options)
    html = %Q{<pre class="pizzazz">#{p.ify}</pre>}
    html.html_safe if html.respond_to?(:html_safe)
    html
  end
end
