# frozen_string_literal: true

require './lib/generators/ruby/base'

module Ruby
  module Sinatra
    # Basic Sinatra API Generator
    class Generator < ::Ruby::Base
      include GeneratorHelper
      BASE_TEMPLATE_PATH = './lib/generators/ruby/sinatra/templates'

      def generate
        copy_project_basic_structure(File.join(BASE_TEMPLATE_PATH, 'project_structure'))
        resources.each do |resource|
          resource.merge!({
            plural_name: resource['name'].downcase.pluralize,
            name_downcase: resource['name'].downcase
          })
          create_controller(resource, File.join(base_target_ps_path, 'api'))
          create_migration(resource)
          create_model(resource, File.join(base_target_ps_path, 'models'))
          create_specs(resource)
        end

        base_target_ps_path
      end
    end
  end
end
