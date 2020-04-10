# frozen_string_literal: true

shared_examples 'generated controller' do |actions|
  let(:controller_content) { File.open(controller_file_path).read }

  it "will #{actions[:create] ? 'include' : 'not include'} create endpoint" do
    endpoint_firm = "post '/#{plural_name}' do"
    expect(controller_content.include?(endpoint_firm)).to be actions[:create]
  end

  it "will #{actions[:update] ? 'include' : 'not include'} update endpoint" do
    endpoint_firm = "put '/#{plural_name}/:id' do"
    expect(controller_content.include?(endpoint_firm)).to be actions[:update]
  end

  it "will #{actions[:delete] ? 'include' : 'not include'} delete endpoint" do
    endpoint_firm = "delete '/#{plural_name}/:id' do"
    expect(controller_content.include?(endpoint_firm)).to be actions[:delete]
  end

  it "will #{actions[:show] ? 'include' : 'not include'} show endpoint" do
    endpoint_firm = "get '/#{plural_name}/:id' do"
    expect(controller_content.include?(endpoint_firm)).to be actions[:show]
  end

  it "will #{actions[:index] ? 'include' : 'not include'} index endpoint" do
    endpoint_firm = "get '/#{plural_name}' do"
    expect(controller_content.include?(endpoint_firm)).to be actions[:index]
  end
end

shared_examples 'generated file' do |type|
  let(:file_content) { File.open(generated_file_path).read }
  let(:expected_content) do
    File.open(File.join('./spec/fixture/sinatra/', file_path)).read
  end

  it "generate the right #{type}" do
    expect(file_content).to eq(expected_content)
  end
end

describe Generators::Sinatra do
  let(:valid_params) do
    ActiveSupport::HashWithIndifferentAccess.new(
      {
        framework: 'Sinatra',
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
                not_null: 'true',
                unique: 'true'
              },
              {
                name: 'web_site',
                type: 'string',
                required: 'false',
                not_null: 'false',
                unique: 'false'
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
                not_null: 'false',
                unique: 'false'
              },
              {
                name: 'last_name',
                type: 'string',
                required: 'false',
                not_null: 'false',
                unique: 'false'
              },
              {
                name: 'email',
                type: 'email',
                required: 'true',
                not_null: 'true',
                unique: 'true'
              },
              {
                name: 'password',
                type: 'password',
                required: 'true',
                not_null: 'true',
                unique: 'false'
              },
              {
                name: 'age',
                type: 'integer',
                required: 'false',
                not_null: 'false',
                unique: 'false'
              },
              {
                name: 'birthday',
                type: 'datetime',
                required: 'true',
                not_null: 'true',
                unique: 'false'
              },
              {
                name: 'company_id',
                type: 'foreign_key',
                required: 'true',
                not_null: 'true',
                unique: 'false'
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
                not_null: 'true',
                unique: 'true'
              },
              {
                name: 'price',
                type: 'price',
                required: 'false',
                not_null: 'false',
                unique: 'false'
              },
              {
                name: 'first_day_on_market',
                type: 'datetime',
                required: 'false',
                not_null: 'true',
                unique: 'false'
              }
            ],
            actions: %w[create update delete show index]
          }
        ]
      }
    )
  end

  let!(:result_path) { Generators::Sinatra.new(valid_params).generate }

  context 'valid params' do
    describe 'controllers' do
      let(:generated_product_controller) { File.join(result_path, 'api', 'products_controller.rb') }
      let(:generated_company_controller) { File.join(result_path, 'api', 'companies_controller.rb') }
      let(:generated_user_controller) { File.join(result_path, 'api', 'users_controller.rb') }

      it 'generate files' do
        expect(File.exist?(generated_product_controller)).to be true
        expect(File.exist?(generated_company_controller)).to be true
        expect(File.exist?(generated_user_controller)).to be true
      end

      context 'params only require create, update and show' do
        it_behaves_like 'generated controller', {
          create: true, update: true, delete: false, index: false, show: true
        } do
          let(:controller_file_path) do
            File.open(File.join(result_path, 'api', 'companies_controller.rb'))
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
            File.open(File.join(result_path, 'api', 'users_controller.rb'))
          end
          let(:create_method_strong_parameters) do
            'allows: %i[age first_name last_name], needs: %i[birthday company_id email password]'
          end
          let(:update_allows_strong_parameters) do
            'allows: %i[age birthday company_id email first_name last_name password]'
          end
          let(:plural_name) { 'users' }
        end
      end

      it_behaves_like 'generated file', 'controller' do
        let(:generated_file_path) { generated_product_controller }
        let(:file_path) { 'controllers/products.rb' }
      end

      it_behaves_like 'generated file', 'controller' do
        let(:generated_file_path) { generated_company_controller }
        let(:file_path) { 'controllers/companies.rb' }
      end

      it_behaves_like 'generated file', 'controller' do
        let(:generated_file_path) { generated_user_controller }
        let(:file_path) { 'controllers/users.rb' }
      end
    end

    describe 'Models' do
      let(:generated_product_model) { File.join(result_path, 'models', 'product.rb') }
      let(:generated_company_model) { File.join(result_path, 'models', 'company.rb') }
      let(:generated_user_model) { File.join(result_path, 'models', 'user.rb') }

      it 'generate files' do
        expect(File.exist?(generated_product_model)).to be true
        expect(File.exist?(generated_company_model)).to be true
        expect(File.exist?(generated_user_model)).to be true
      end

      it_behaves_like 'generated file', 'model' do
        let(:generated_file_path) { generated_product_model }
        let(:file_path) { 'models/product.rb' }
      end

      it_behaves_like 'generated file', 'model' do
        let(:generated_file_path) { generated_company_model }
        let(:file_path) { 'models/company.rb' }
      end

      it_behaves_like 'generated file', 'model' do
        let(:generated_file_path) { generated_user_model }
        let(:file_path) { 'models/user.rb' }
      end
    end

    describe 'Migrations' do
      let(:generated_product_migration) do
        Dir.glob(File.join(result_path, 'db', 'migrate', '*_products.rb')).first
      end
      let(:generated_company_migration) do
        Dir.glob(File.join(result_path, 'db', 'migrate', '*_companies.rb')).first
      end
      let(:generated_user_migration) do
        Dir.glob(File.join(result_path, 'db', 'migrate', '*_users.rb')).first
      end

      it 'generate files' do
        expect(File.exist?(generated_product_migration)).to be true
        expect(File.exist?(generated_company_migration)).to be true
        expect(File.exist?(generated_user_migration)).to be true
      end

      it_behaves_like 'generated file', 'migration' do
        let(:generated_file_path) { generated_product_migration }
        let(:file_path) { 'migrations/create_products.rb' }
      end

      it_behaves_like 'generated file', 'migration' do
        let(:generated_file_path) { generated_company_migration }
        let(:file_path) { 'migrations/create_companies.rb' }
      end

      it_behaves_like 'generated file', 'migration' do
        let(:generated_file_path) { generated_user_migration }
        let(:file_path) { 'migrations/create_users.rb' }
      end
    end

    describe 'Factories' do
      let(:generated_product_factory) do
        File.join(result_path, 'spec', 'factories', 'products.rb')
      end
      let(:generated_company_factory) do
        File.join(result_path, 'spec', 'factories', 'companies.rb')
      end
      let(:generated_user_factory) do
        File.join(result_path, 'spec', 'factories', 'users.rb')
      end

      it 'generate files' do
        expect(File.exist?(generated_product_factory)).to be true
        expect(File.exist?(generated_company_factory)).to be true
        expect(File.exist?(generated_user_factory)).to be true
      end

      it_behaves_like 'generated file', 'factory' do
        let(:generated_file_path) { generated_product_factory }
        let(:file_path) { 'factories/products.rb' }
      end

      it_behaves_like 'generated file', 'factory' do
        let(:generated_file_path) { generated_company_factory }
        let(:file_path) { 'factories/companies.rb' }
      end

      it_behaves_like 'generated file', 'factory' do
        let(:generated_file_path) { generated_user_factory }
        let(:file_path) { 'factories/users.rb' }
      end
    end

    describe 'Spec' do
      describe 'Controller' do
        let(:generated_product_controller) do
          File.join(result_path, 'spec', 'controllers', 'products_controller_spec.rb')
        end
        let(:generated_company_controller) do
          File.join(result_path, 'spec', 'controllers', 'companies_controller_spec.rb')
        end
        let(:generated_user_controller) do
          File.join(result_path, 'spec', 'controllers', 'users_controller_spec.rb')
        end

        it 'generate files' do
          expect(File.exist?(generated_product_controller)).to be true
          expect(File.exist?(generated_company_controller)).to be true
          expect(File.exist?(generated_user_controller)).to be true
        end

        it_behaves_like 'generated file', 'controller' do
          let(:generated_file_path) { generated_product_controller }
          let(:file_path) { 'spec/controllers/products.rb' }
        end

        it_behaves_like 'generated file', 'controller' do
          let(:generated_file_path) { generated_company_controller }
          let(:file_path) { 'spec/controllers/companies.rb' }
        end

        it_behaves_like 'generated file', 'controller' do
          let(:generated_file_path) { generated_user_controller }
          let(:file_path) { 'spec/controllers/users.rb' }
        end
      end
    end
  end
end
