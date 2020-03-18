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
        resource.merge!({ plural_name: resource['name'].downcase.pluralize })
        create_controller(resource)
        create_migration(resource)
        create_model(resource)
        create_factories(resource)
      end

      base_target_ps_path
    end

    def create_controller(resource)
      file_name = "#{resource['plural_name']}_controller.rb"
      resource.merge!(strong_parameters(resource))

      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'resource_controller_template.erb'),
        File.join(base_target_ps_path, 'api', file_name)
      )
    end

    def create_model(resource)
      file_name = "#{resource['name'].downcase}.rb"
      create_resource_file(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'resource_model_template.erb'),
        File.join(base_target_ps_path, 'models', file_name)
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
