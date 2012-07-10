require 'pizzazz/colorer'
require 'pizzazz/version'

module Pizzazz
  TAB_SIZE = 2
  
  def self.ify(object, options = nil)
    p = Pizzazz::Colorer.new(object, options)
    p.ify
  end
end
