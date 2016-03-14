require 'rubygems'
require 'bundler'
Bundler.require :test

CodeClimate::TestReporter.start
SimpleCov.start

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

require 'minitest/autorun'
require 'pizzazz'

# Support files
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end

class Pizzazz::TestCase < Minitest::Test
end
