module Pizzazz
  def self.ify(object, options = nil)
    p = Colorer.new(object, options)
    p.ify
  end
end

# TODO: This is ugly. I'd love a better solution.
begin
  require 'rails'
  require 'pizzazz/engine'
  Pizzazz::RAILS_AVAILABLE = true
rescue LoadError
  Pizzazz::RAILS_AVAILABLE = false
end

require 'pizzazz/colorer'
require 'pizzazz/html'
require 'pizzazz/version'
