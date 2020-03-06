# frozen_string_literal: true

require './lib/generators/base'

module Generators
  # Basic Sinatra API Generator
  class SinatraBasic < Base
    BASE_TEMPLATE_PATH = './lib/templates/basic_sinatra_template'
    BASE_TARGET_PATH = './tmp/'

    def generate
      copy_project_basic_structure
      puts '--------------------------------------------------------'
      puts resources
      puts '--------------------------------------------------------'
      puts self.resources
      puts '--------------------------------------------------------'
      puts self
      puts '--------------------------------------------------------'
      self.resources.each do |resource|
        create_controller_file(resource)
      end
      # TODO Destroy TEMP proyect folder
    end

    def create_controller_file(resource)
      controller_content = render_to_string(
        "#{BASE_TEMPLATE_PATH}/resource_controller_template.erb",
        resource
      )

      controller_name = "#{resource['name'].downcase}_controller.rb"

      create_file(
        File.join(BASE_TARGET_PATH, 'project_structure', 'api', controller_name),
        controller_content
      )
    end

    def copy_project_basic_structure
      FileUtils.cp_r(
        File.join(BASE_TEMPLATE_PATH, 'project_structure'),
        BASE_TARGET_PATH
      )
    end
  end
end
