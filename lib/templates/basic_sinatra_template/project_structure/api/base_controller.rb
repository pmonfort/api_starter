# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/strong-params'

module API
  class BaseController < Sinatra::Base
    configure do
      register Sinatra::StrongParams
    end

    before do
      content_type :json
    end
  end
end
