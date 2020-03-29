# frozen_string_literal: true

module Generators
  # Rails API Generator
  class RailsAPI < Base
    BASE_TEMPLATE_PATH = './lib/templates/rails_api'

    def generate
      copy_project_basic_structure(File.join(BASE_TEMPLATE_PATH, 'project_structure'))
      resources.each do |resource|
        resource.merge!({ plural_name: resource['name'].downcase.pluralize })
        index_of_delete = resource['actions'].find_index('delete')
        # Patch delete to Rails destroy
        resource['actions'][index_of_delete] = 'destroy' if index_of_delete
        create_controller(resource)
        create_migration(resource)
        create_model(resource, File.join(base_target_ps_path, 'app', 'models'))
        create_specs(resource)
      end
      create_routes

      base_target_ps_path
    end

    def create_routes
      create_file_from_template(
        { resources: resources },
        File.join(BASE_TEMPLATE_PATH, 'routes.erb'),
        File.join(base_target_ps_path, 'config', 'routes.rb')
      )
    end

    def create_controller(resource)
      file_name = "#{resource['plural_name']}_controller.rb"
      resource['name_downcase'] = resource['name'].downcase

      create_file_from_template(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'controller.erb'),
        File.join(base_target_ps_path, 'app', 'controllers', file_name)
      )
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
      resource['name_downcase'] = resource['name'].downcase

      create_file_from_template(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'spec', 'model.erb'),
        File.join(base_target_ps_path, 'spec', 'models', file_name)
      )
    end

    def create_routing_spec(resource)
      file_name = "#{resource['plural_name']}_routing.rb"
      resource['name_downcase'] = resource['name'].downcase

      create_file_from_template(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'spec', 'routing.erb'),
        File.join(base_target_ps_path, 'spec', 'routing', file_name)
      )
    end
  end
end
