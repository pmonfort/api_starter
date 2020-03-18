# frozen_string_literal: true

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

# Main Application
class App < Sinatra::Base
  before do
    content_type :json
  end

  get '/' do
    p 'Amon Ra API'
  end

  # Includes all API endpoints
  API.constants.select { |c| API.const_get(c).is_a? Class }.each do |resource|
    use API.const_get(resource)
  end
end
