# frozen_string_literal: true

module Generators
  # Base Generator class
  class Base
    BASE_TARGET_PATH = './tmp/'
    BASE_TARGET_PS_PATH = File.join(BASE_TARGET_PATH, 'project_structure')
    
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

    def copy_project_basic_structure(template_path)
      FileUtils.cp_r(template_path, BASE_TARGET_PATH)
    end

    def create_resource_file(resource, template_path, target_path)
      content = render_to_string(template_path, resource)
      create_file(target_path, content)
    end
  end
end
