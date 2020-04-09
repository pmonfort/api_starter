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
        resource.merge!({
          plural_name: resource['name'].downcase.pluralize,
          name_downcase: resource['name'].downcase
        })
        create_controller(resource)
        create_migration(resource)
        create_model(resource, File.join(base_target_ps_path, 'models'))
        create_specs(resource)
      end

      base_target_ps_path
    end

    # Specs
    def create_specs(resource)
      create_controller_spec(resource)
      create_model_sepc(resource)
      create_factories(resource)
      create_routing_spec(resource)
    end

    def create_model_sepc(resource)
      file_name = "#{resource['name'].downcase}.rb"

      create_file_from_template(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'spec', 'model.erb'),
        File.join(base_target_ps_path, 'spec', 'models', file_name)
      )
    end

    def create_routing_spec(resource)
      file_name = "#{resource['plural_name']}_routing.rb"

      create_file_from_template(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'spec', 'routing.erb'),
        File.join(base_target_ps_path, 'spec', 'routing', file_name)
      )
    end

    def create_controller(resource)
      file_name = "#{resource['plural_name']}_controller.rb"
      resource.merge!(
        required_fields: resource['fields'].select { |field| field['required'] == 'true' }
      )

      create_file_from_template(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'controller.erb'),
        File.join(base_target_ps_path, 'api', file_name)
      )
    end
  end
end
