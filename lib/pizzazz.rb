require 'pizzazz/colorer'
require 'pizzazz/html'
require 'pizzazz/engine'
require 'pizzazz/version'

module Pizzazz
  TAB_SIZE = 2
  
  def self.ify(object, options = nil)
    p = Colorer.new(object, options)
    p.ify
  end
end
