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
        if index_of_delete
          resource['actions'][index_of_delete] = 'destroy'
        end
        create_controller(resource)
        create_migration(resource)
        create_model(resource)
        create_factories(resource)
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

    # Factories
    def create_factories(resource)
      file_name = "#{resource['plural_name'].downcase}.rb"

      # TODO WORKING PROGRESS
      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'resource_factory_template.erb'),
        File.join(base_target_ps_path, 'spec', 'factories', file_name)
      ) { |field| faker(field) }
    end

    def faker(field)
      result = "#{field['name']} "
      case field['type']
      when 'string'
        # If the field name as the string name
        # it would assign a Faker name
        result += if field['name'].match(/name/)
                    '{ Faker::Name.name }'
                  else
                    '{ Faker::Lorem.sentence }'
                  end
      when 'email'
        result += '{ Faker::Internet.email }'
      when 'password'
        result += '{ Faker::Internet.password }'
      when 'integer'
        result += '{ Faker::Number.number(digits: 2) }'
      when 'price'
        result += '{ Faker::Number.decimal(l_digits: 2) }'
      when 'datetime'
        result += '{ Faker::Date.birthday(min_age: 18, max_age: 65) }'
      when 'foreign_key'
        field_name = field['name'].gsub('_id', '')
        result = "#{field_name} { create(:#{field_name}) }"
      end
      result
    end
  end
end
