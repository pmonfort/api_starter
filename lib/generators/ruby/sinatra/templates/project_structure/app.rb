# frozen_string_literal: true

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
