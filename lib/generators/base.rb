# frozen_string_literal: true

module Generators
  # Base Generator class
  class Base
    attr_accessor :raw_params, :resource, :swagger, :validation

    def initialize(params)
      raw_params = params
      resource = params['resource']
      swagger = params['swagger']
      validation = params['validation']
    end
  end
end
