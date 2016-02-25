module Pizzazz
  RAILS_AVAILABLE = begin
    require 'rails'
    require 'pizzazz/engine'
    true
  rescue LoadError
    false
  end

  def self.ify(object, options = nil)
    p = Colorer.new(object, options)
    p.ify
  end
end

require 'pizzazz/colorer'
require 'pizzazz/html'
require 'pizzazz/version'
