require "rubygems"
require "bundler"

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

require 'sinatra'
require 'sinatra/activerecord'
require 'active_support/inflector'

# Require API Controllers
Dir['./api/**/*.rb'].sort.each do |file|
  require file
end

# Require Models
Dir['./models/**/*.rb'].sort.each do |file|
  require file
end

require './app'
