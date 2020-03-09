# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'active_support/inflector'

Dir['./api/**/*.rb'].each do |file|
  require file
end

class App < Sinatra::Base
  before do
    content_type :json
  end

  # Includes all API endpoints
  API.constants.select { |c| API.const_get(c).is_a? Class }.each do |resource|
    use API.const_get(resource)
  end

  get '/' do
    p 'Hello2!'
  end
end
