module Pizzazz
  def self.ify_html(object, options = nil)
    p = Colorer.new(object, options)
    html = %Q{<pre class="pizzazz">#{p.ify}</pre>}
    html = html.html_safe if Pizzazz::RAILS_AVAILABLE
    html
  end
end
