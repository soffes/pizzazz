# encoding: UTF-8

require File.expand_path('../lib/pizzazz/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Sam Soffes']
  gem.email         = ['sam@soff.es']
  gem.description   = %q{Add some pizzazz to your documentation}
  gem.summary       = %q{A simple gem to code color documentation}
  gem.homepage      = 'http://github.com/soffes/pizzazz'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'pizzazz'
  gem.require_paths = ['lib']
  gem.version       = Pizzazz::VERSION

  gem.required_ruby_version = '>= 1.9.2'
end
