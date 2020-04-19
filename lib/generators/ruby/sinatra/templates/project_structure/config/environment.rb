require "rubygems"
require "bundler"

require 'active_support/inflector'
require 'sinatra'
require 'sinatra/activerecord'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

# Require API Controllers
Dir['./api/**/*.rb'].sort.each do |file|
  require file
end

# Require Models
Dir['./models/**/*.rb'].sort.each do |file|
  require file
end

require './app'
