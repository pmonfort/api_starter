# frozen_string_literal: true

shared_examples 'generated controller' do |actions|
  let(:controller_content) { File.open(controller_file_path).read }

  it "will #{actions[:create] ? 'include' : 'not include'} create endpoint" do
    endpoint_firm = "post '/#{plural_name}', #{create_method_strong_parameters}"
    expect(controller_content.include?(endpoint_firm)).to be actions[:create]
  end

  it "will #{actions[:update] ? 'include' : 'not include'} update endpoint" do
    endpoint_firm = "put '/#{plural_name}/:id', #{update_allows_strong_parameters}"
    expect(controller_content.include?(endpoint_firm)).to be actions[:update]
  end

  it "will #{actions[:delete] ? 'include' : 'not include'} delete endpoint" do
    endpoint_firm = "delete '/#{plural_name}/:id'"
    expect(controller_content.include?(endpoint_firm)).to be actions[:delete]
  end

  it "will #{actions[:show] ? 'include' : 'not include'} show endpoint" do
    endpoint_firm = "get '/#{plural_name}/:id'"
    expect(controller_content.include?(endpoint_firm)).to be actions[:show]
  end

  it "will #{actions[:index] ? 'include' : 'not include'} index endpoint" do
    endpoint_firm = "get '/#{plural_name}'"
    expect(controller_content.include?(endpoint_firm)).to be actions[:index]
  end
end

describe Generators::SinatraBasic do
  let(:valid_params) do
    ActiveSupport::HashWithIndifferentAccess.new(
      {
        framework: 'RailsAPI',
        swagger: 'true',
        validation: 'true',
        resources: [
          {
            name: 'Company',
            fields: [
              {
                name: 'name',
                type: 'string',
                required: 'true',
                unique: 'true',
                password: 'false'
              },
              {
                name: 'web_site',
                type: 'string',
                required: 'false',
                unique: 'false',
                password: 'false'
              }
            ],
            actions: %w[create update show]
          },
          {
            name: 'User',
            fields: [
              {
                name: 'first_name',
                type: 'string',
                required: 'false',
                unique: 'false',
                password: 'false'
              },
              {
                name: 'last_name',
                type: 'string',
                required: 'false',
                unique: 'false',
                password: 'false'
              },
              {
                name: 'email',
                type: 'email',
                required: 'true',
                unique: 'true',
                password: 'false'
              },
              {
                name: 'password',
                type: 'password',
                required: 'true',
                unique: 'false',
                password: 'true'
              },
              {
                name: 'age',
                type: 'integer',
                required: 'false',
                unique: 'false',
                password: 'false'
              },
              {
                name: 'birthday',
                type: 'datetime',
                required: 'true',
                unique: 'false',
                password: 'false'
              },
              {
                name: 'company_id',
                type: 'foreign_key',
                required: 'true',
                unique: 'false',
                password: 'false'
              }
            ],
            actions: %w[create update delete show index]
          },
          {
            name: 'Product',
            fields: [
              {
                name: 'name',
                type: 'string',
                required: 'true',
                unique: 'true',
                password: 'false'
              },
              {
                name: 'price',
                type: 'price',
                required: 'false',
                unique: 'false',
                password: 'false'
              }
            ],
            actions: %w[create update delete show index]
          }
        ]
      }
    )
  end

  let!(:result_path) { Generators::SinatraBasic.new(valid_params).generate }

  context 'valid params' do
    describe 'controllers' do
      it 'generate files' do
        expect(File.exist?(File.join(result_path, 'api', 'user_controller.rb'))).to be true
        expect(File.exist?(File.join(result_path, 'api', 'company_controller.rb'))).to be true
        expect(File.exist?(File.join(result_path, 'api', 'product_controller.rb'))).to be true
      end

      context 'params only require create, update and show' do
        it_behaves_like 'generated controller', {
          create: true, update: true, delete: false, index: false, show: true
        } do
          let(:controller_file_path) do
            File.open(File.join(result_path, 'api', 'company_controller.rb'))
          end
          let(:create_method_strong_parameters) do
            'allows: %i[web_site], needs: %i[name]'
          end
          let(:update_allows_strong_parameters) do
            'allows: %i[name web_site]'
          end
          let(:plural_name) { 'companies' }
        end
      end

      context 'request for all posible endpoints' do
        it_behaves_like 'generated controller', {
          create: true, update: true, delete: true, index: true, show: true
        } do
          let(:controller_file_path) do
            File.open(File.join(result_path, 'api', 'user_controller.rb'))
          end
          let(:create_method_strong_parameters) do
            'allows: %i[first_name last_name age], needs: %i[email password birthday company_id]'
          end
          let(:update_allows_strong_parameters) do
            'allows: %i[first_name last_name email password age birthday company_id]'
          end
          let(:plural_name) { 'users' }
        end
      end
    end

    describe 'Models' do
      it 'generate files' do
        expect(File.exist?(File.join(result_path, 'models', 'user.rb'))).to be true
        expect(File.exist?(File.join(result_path, 'models', 'company.rb'))).to be true
        expect(File.exist?(File.join(result_path, 'models', 'product.rb'))).to be true
      end
    end

    describe 'Migrations' do
      it 'generate files' do
        expect(Dir.glob(File.join(result_path, 'db', 'migrate', '*_user.rb')).empty?).to be false
        expect(Dir.glob(File.join(result_path, 'db', 'migrate', '*_company.rb')).empty?).to be false
        expect(Dir.glob(File.join(result_path, 'db', 'migrate', '*_product.rb')).empty?).to be false
      end
    end
  end
end
