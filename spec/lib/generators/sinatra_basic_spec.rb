# frozen_string_literal: true

describe Generators::SinatraBasic do
  let(:target_path) { Generators::Base::BASE_TARGET_PS_PATH }
  let(:valid_params) do
    ActiveSupport::HashWithIndifferentAccess.new({
      framework: 'RailsAPI',
      swagger: 'true',
      validation: 'true',
      resources: [
        {
          name: 'User',
          fields: [
            first_name: {
              type: 'string',
              required: 'false',
              unique: 'false'
            },
            last_name: {
              type: 'string',
              required: 'false',
              unique: 'false'
            },
            email: {
              type: 'email',
              required: 'true',
              unique: 'true'
            },
            password: {
              type: 'password',
              required: 'true',
              password: 'true'
            },
            age: {
              type: 'integer',
              required: 'false',
              password: 'false'
            },
            company_id: {
              type: 'foreign_key',
              required: 'true',
              password: 'true'
            }
          ],
          actions: %w[create update delete show index]
        },
        {
          name: 'Company',
          fields: [
            name: {
              type: 'string',
              required: 'true',
              unique: 'true'
            },
            web_site: {
              type: 'string',
              required: 'false',
              unique: 'false'
            }
          ],
          actions: %w[create update delete show index]
        }
      ]
    })
  end

  before do
    generator = Generators::SinatraBasic.new(valid_params)
    generator.generate
  end

  describe 'controllers' do
    it 'generate files' do
      expect(File.exist?(File.join(target_path, 'api', 'user_controller.rb'))).to be true
      expect(File.exist?(File.join(target_path, 'api', 'company_controller.rb'))).to be true
    end
  end

  describe 'Models' do
    it 'generate files' do
      expect(File.exist?(File.join(target_path, 'models', 'user.rb'))).to be true
      expect(File.exist?(File.join(target_path, 'models', 'company.rb'))).to be true
    end
  end

  describe 'Migrations' do
    xit 'generate files' do
      expect(File.exist?(File.join(target_path, 'db', 'migrate', 'user_controller.rb'))).to be true
      expect(File.exist?(File.join(target_path, 'db', 'migrate', 'company_controller.rb'))).to be true
    end
  end
end
