# frozen_string_literal: true

module Generators
  # Base Generator class
  class Base
    attr_accessor :raw_params, :resources, :swagger, :validation, :migration_counter

    def initialize(params)
      self.raw_params = params

      # Sort resources and fields by name
      params['resources'].sort_by! { |resource| resource['name'] }
      params['resources'].each do |resource|
        resource['fields'].sort_by! { |field| field['name'] }
      end

      self.resources = params['resources']
      self.swagger = params['swagger']
      self.validation = params['validation']
      self.migration_counter = 1
      Dir.mkdir('./tmp') unless File.exist?('./tmp')
      Dir.mkdir(base_target_path) unless File.exist?(base_target_path)
    end

    def create_file(path, content)
      File.open(path, 'w') { |file| file.write(content) }
    end

    def copy_project_basic_structure(template_path)
      FileUtils.cp_r(template_path, base_target_path)
    end

    def create_file_from_template(file_params, template_path, target_path)
      template = Tilt.new(template_path)
      content = if block_given?
                  template.render(nil, file_params) do |params|
                    yield(params)
                  end
                else
                  template.render(nil, file_params)
                end
      create_file(target_path, content)
    end

    def create_controller(resource, target_folder_path)
      file_name = "#{resource['plural_name']}_controller.rb"
      resource.merge!(
        required_fields: resource['fields'].select { |field| field['required'] == 'true' },
        name_downcase: resource['name'].downcase
      )

      create_file_from_template(
        resource,
        File.join(base_template_path, 'controller.erb'),
        File.join(target_folder_path, file_name)
      )
    end

    def create_model(resource, target_folder_path)
      file_name = "#{resource['name'].downcase}.rb"
      create_file_from_template(
        resource,
        File.join(base_template_path, 'model.erb'),
        File.join(target_folder_path, file_name)
      )
    end

    def create_migration(resource)
      self.migration_counter += 1
      version = (Time.now.utc + self.migration_counter).strftime('%Y%m%d%H%M%S')
      file_name = "#{version}_create_#{resource['plural_name'].downcase}.rb"
      create_file_from_template(
        resource,
        File.join(base_template_path, 'migration.erb'),
        File.join(base_target_ps_path, 'db', 'migrate', file_name)
      )
    end

    # Specs
    def create_specs(resource)
      create_controller_spec(resource)
      create_model_sepc(resource)
      create_factories(resource)
      create_routing_spec(resource)
    end

    def create_controller_spec(resource)
      file_name = "#{resource['plural_name']}_controller_spec.rb"
      resource['name_downcase'] = resource['name'].downcase

      create_file_from_template(
        resource,
        File.join(base_template_path, 'spec', 'controller.erb'),
        File.join(base_target_ps_path, 'spec', 'controllers', file_name)
      ) do |field|
        "#{field['name']}: #{faker(field, true)}"
      end
    end

    def create_model_sepc(resource)
      file_name = "#{resource['name'].downcase}.rb"

      create_file_from_template(
        resource,
        File.join(base_template_path, 'spec', 'model.erb'),
        File.join(base_target_ps_path, 'spec', 'models', file_name)
      )
    end

    def create_factories(resource)
      file_name = "#{resource['plural_name'].downcase}.rb"

      create_file_from_template(
        resource,
        File.join(base_template_path, 'spec', 'factory.erb'),
        File.join(base_target_ps_path, 'spec', 'factories', file_name)
      ) do |field|
        field_name = "#{field['name']}"
        field_name = field['name'].gsub('_id', '') if field['type'] == 'foreign_key'
        "#{field_name} { #{faker(field)} }"
      end
    end

    def create_routing_spec(resource)
      file_name = "#{resource['plural_name']}_routing.rb"
      resource['name_downcase'] = resource['name'].downcase

      create_file_from_template(
        resource,
        File.join(base_template_path, 'spec', 'routing.erb'),
        File.join(base_target_ps_path, 'spec', 'routing', file_name)
      )
    end

    def faker(field, factory_return_only_id=nil)
      case field['type']
      when 'string'
        # If the field name as the string name
        # it would assign a Faker name
        if field['name'].match(/name/)
          'Faker::Name.name'
        else
          'Faker::Lorem.sentence'
        end
      when 'email'
        'Faker::Internet.email'
      when 'password'
        'Faker::Internet.password'
      when 'integer'
        'Faker::Number.number(digits: 2)'
      when 'price'
        'Faker::Number.decimal(l_digits: 2)'
      when 'datetime'
        # If the field name as the string birthday
        # it would assign a Faker birthday
        if field['name'].match(/birthday/)
          'Faker::Date.birthday(min_age: 18, max_age: 65)'
        else
          'Faker::Date.between(from: 2.days.ago, to: Date.today)'
        end
      when 'foreign_key'
        factory_name = field['name'].gsub('_id', '')
        return "create(:#{factory_name}).id" if factory_return_only_id
        "create(:#{factory_name})"
      end
    end

    def base_target_path
      @base_target_path ||= File.join(
        './tmp/', "#{Time.now.utc.strftime('%Y%m%d%H%M%S')}#{rand(999)}_#{raw_params['framework']}"
      )
    end

    def base_target_ps_path
      File.join(base_target_path, 'project_structure')
    end

    # Access Children class BASE_TEMPLATE_PATH constant
    def base_template_path
      self.class::BASE_TEMPLATE_PATH
    end
  end
end
