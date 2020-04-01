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

    def create_controller(resource)
      file_name = "#{resource['plural_name']}_controller.rb"
      resource.merge!(strong_parameters(resource))

      create_file_from_template(
        resource,
        File.join(BASE_TEMPLATE_PATH, 'controller.erb'),
        File.join(base_target_ps_path, 'api', file_name)
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
