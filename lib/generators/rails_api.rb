# frozen_string_literal: true

module Generators
  # Rails API Generator
  class RailsAPI < Base
    BASE_TEMPLATE_PATH = './lib/templates/rails_api'

    def generate
      copy_project_basic_structure(File.join(BASE_TEMPLATE_PATH, 'project_structure'))
      resources.each do |resource|
        index_of_delete = resource['actions'].find_index('delete')
        # Patch delete to Rails destroy
        if index_of_delete
          resource['actions'][index_of_delete] = 'destroy'
        end
        plural_name = resource['name'].downcase.pluralize
        create_controller(resource.merge({ plural_name: plural_name }))
        create_migration(resource.merge({ plural_name: plural_name }))
        create_model(resource)
      end

      base_target_ps_path
    end

    def create_controller(resource)
      file_name = "#{resource['plural_name']}_controller.rb"
      resource['name_downcase'] = resource['name'].downcase

      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'resource_controller_template.erb'),
        File.join(base_target_ps_path, 'app', 'controllers', file_name)
      )
    end

    def create_model(resource)
      file_name = "#{resource['name'].downcase}.rb"
      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'resource_model_template.erb'),
        File.join(base_target_ps_path, 'app', 'models', file_name)
      )
    end

    def create_migration(resource)
      self.migration_counter += 1
      version = (Time.now.utc + self.migration_counter).strftime('%Y%m%d%H%M%S')
      file_name = "#{version}_create_#{resource['plural_name'].downcase}.rb"
      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'resource_migration_template.erb'),
        File.join(base_target_ps_path, 'db', 'migrate', file_name)
      )
    end
  end
end
