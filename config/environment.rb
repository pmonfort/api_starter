require "rubygems"
require "bundler"

require 'sinatra/base'

require './lib/utility/generator_helper.rb'
Dir['./lib/generators/**/generator.rb'].each { |file| require file }

require './app'
