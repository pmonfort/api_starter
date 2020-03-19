# frozen_string_literal: true

module Generators
  # Base Generator class
  class Base
    attr_accessor :raw_params, :resources, :swagger, :validation, :migration_counter

    def initialize(params)
      self.raw_params = params
      self.resources = params['resources']
      self.swagger = params['swagger']
      self.validation = params['validation']
      self.migration_counter = 1
      Dir.mkdir('./tmp') unless File.exist?('./tmp')
      Dir.mkdir(base_target_path) unless File.exist?(base_target_path)
    end

    def create_file(path, content)
      File.open(path, 'w') { |file| file.write(content) }
    end

    def copy_project_basic_structure(template_path)
      FileUtils.cp_r(template_path, base_target_path)
    end

    def create_file_from_template(file_params, template_path, target_path)
      template = Tilt.new(template_path)
      content = if block_given?
                  template.render(nil, file_params) do |params|
                    yield(params)
                  end
                else
                  template.render(nil, file_params)
                end
      create_file(target_path, content)
    end

    def base_target_path
      @base_target_path ||= File.join(
        './tmp/', "#{Time.now.utc.strftime('%Y%m%d%H%M%S')}_#{self.raw_params['framework']}"
      )
    end

    def base_target_ps_path
      File.join(base_target_path, 'project_structure')
    end
  end
end
