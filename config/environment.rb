require "rubygems"
require "bundler"

require 'sinatra/base'

require './lib/generators/base.rb'
Dir['./lib/generators/**/generator.rb'].each { |file| require file }

require './app'
