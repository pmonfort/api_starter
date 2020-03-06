# frozen_string_literal: true

module Generators
  # Base Generator class
  class Base
    attr_accessor :raw_params, :resources, :swagger, :validation

    def initialize(params)
      self.raw_params = params
      self.resources = params['resources']
      self.swagger = params['swagger']
      self.validation = params['validation']
    end

    def render_to_string(path, params)
      html = File.open(path).read
      ERB.new(html).result_with_hash(params)
    end

    def create_file(path, content)
      File.open(path, 'w') { |file| file.write(content) }
    end
  end
end
