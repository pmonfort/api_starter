# frozen_string_literal: true

require './lib/generators/base'

module Generators
  # Basic Sinatra API Generator
  class SinatraBasic < Base
    BASE_TEMPLATE_PATH = './lib/templates/basic_sinatra_template'

    def generate
      copy_project_basic_structure(File.join(BASE_TEMPLATE_PATH, 'project_structure'))
      puts '--------------------------------------------------------'
      puts resources
      puts '--------------------------------------------------------'
      puts self.resources
      puts '--------------------------------------------------------'
      puts self
      puts '--------------------------------------------------------'
      self.resources.each do |resource|
        create_controller(resource)
        create_migration(resource)
        create_model(resource)
      end
      # TODO Destroy TEMP proyect folder
      BASE_TARGET_PS_PATH
    end

    def create_controller(resource)
      file_name = "#{resource['name'].downcase}_controller.rb"
      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, "resource_controller_template.erb"),
        File.join(BASE_TARGET_PS_PATH, 'api', file_name)
      )
    end

    def create_model(resource)
      file_name = "#{resource['name'].downcase}.rb"
      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, "resource_model_template.erb"),
        File.join(BASE_TARGET_PS_PATH, 'models', file_name)
      )
    end

    def create_migration(resource)
      version = Time.now.utc.strftime("%Y%m%d%H%M%S")
      file_name = "#{version}_#{resource['name'].downcase}.rb"
      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, "resource_migration_template.erb"),
        File.join(BASE_TARGET_PS_PATH, 'db', 'migrate', file_name),
      )
    end
  end
end
