# frozen_string_literal: true

require './lib/generators/base'
require 'active_support/inflector'

module Generators
  # Basic Sinatra API Generator
  class SinatraBasic < Base
    BASE_TEMPLATE_PATH = './lib/templates/basic_sinatra_template'

    def generate
      copy_project_basic_structure(File.join(BASE_TEMPLATE_PATH, 'project_structure'))
      resources.each do |resource|
        plural_name = resource['name'].downcase.pluralize
        create_controller(resource.merge({ plural_name: plural_name }))
        create_migration(resource.merge({ plural_name: plural_name }))
        create_model(resource)
      end

      # TODO Destroy TEMP proyect folder
      BASE_TARGET_PS_PATH
    end

    def create_controller(resource)
      file_name = "#{resource['name'].downcase}_controller.rb"
      resource.merge!(strong_parameters(resource))

      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'resource_controller_template.erb'),
        File.join(BASE_TARGET_PS_PATH, 'api', file_name)
      )
    end

    def create_model(resource)
      file_name = "#{resource['name'].downcase}.rb"
      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'resource_model_template.erb'),
        File.join(BASE_TARGET_PS_PATH, 'models', file_name)
      )
    end

    def create_migration(resource)
      self.migration_counter += 1
      version = (Time.now.utc + self.migration_counter).strftime('%Y%m%d%H%M%S')
      file_name = "#{version}_create_#{resource['name'].downcase}.rb"
      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'resource_migration_template.erb'),
        File.join(BASE_TARGET_PS_PATH, 'db', 'migrate', file_name)
      )
    end

    def strong_parameters(resource)
      {
        'create_method_strong_parameters' => create_method_strong_parameters(resource),
        'update_allows_strong_parameters' => ", allows: #{sp_params_names(resource['fields'])}"
      }
    end

    def create_method_strong_parameters(resource)
      needs_params, allows_params = resource['fields'].partition do |field|
        field['required'] == 'true'
      end

      create_method_sp = ''
      create_method_sp += ", allows: #{sp_params_names(allows_params)}" unless allows_params.empty?
      create_method_sp += ", needs: #{sp_params_names(needs_params)}" unless needs_params.empty?
      create_method_sp
    end

    def sp_params_names(hash)
      "%i[#{hash.map { |field| field['name'] }.join(' ')}]"
    end
  end
end
