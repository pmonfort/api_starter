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
        create_controller(resource, File.join(base_target_ps_path, 'app', 'controllers'))
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
  end
end
