# frozen_string_literal: true

require "sinatra/required_params"

module API
  # Base controller
  class BaseController < Sinatra::Base
    helpers Sinatra::RequiredParams

    before do
      content_type :json
    end
  end
end
