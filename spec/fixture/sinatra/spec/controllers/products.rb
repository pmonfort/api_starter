# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe API::ProductsController do
  # This should return the minimal set of attributes required to create a valid
  # Product. As you add validations to Product, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    build(:product).attributes.slice(
      *%w[
        first_day_on_market
        name
        price
      ]
    )
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProductsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  let!(:product) { create(:product) }

  describe 'GET /products' do
    it 'returns a success response' do
      get '/products', {}, session: valid_session
      expect(last_response).to be_successful
    end
  end

  describe 'GET /products/:id' do
    it 'returns a success response' do
      get "/products/#{product.id}", {}, session: valid_session
      expect(last_response).to be_successful
    end

    describe 'wrong id' do
      it '404' do
        get '/products/-1', {}, session: valid_session
        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'POST /products' do
    context 'with valid params' do
      it 'creates a new Product' do
        expect do
          post '/products', {
            product: valid_attributes
          }, session: valid_session
        end.to change { Product.count }.by(1)
      end

      it 'renders a JSON response with the new product' do
        post '/products', {
          product: valid_attributes
        }, session: valid_session
        expect(last_response.status).to eq(201)
        expect(last_response.content_type).to eq('application/json')
      end
    end

    describe 'with invalid params' do
      context 'missing required name' do
        it 'renders a JSON response with errors for the new product' do
          post '/products', {
            product: valid_attributes.reject { |key, _| key == 'name' }
          }, session: valid_session
          expect(last_response.status).to eq(400)
          expect(last_response.content_type).to eq('application/json')
        end
      end
    end
  end

  describe 'PUT /products/:id' do
    context 'with valid params' do
      before do
        put "/products/#{product.id}", {
          product: valid_attributes
        }, session: valid_session
      end

      it 'updates the requested product' do
        product.reload
        expect(
          product.attributes.select do |key, _|
            valid_attributes.keys.include?(key)
          end
        ).to eq(valid_attributes)
      end

      it 'renders a JSON response with the product' do
        expect(last_response).to be_successful
        expect(last_response.content_type).to eq('application/json')
      end
    end

    describe 'with invalid params' do
      context 'with name set to nil' do
        it 'renders a JSON response with errors' do
          put "/products/#{product.id}", {
            product: valid_attributes.merge({ name: nil })
          }, session: valid_session
          error_messages = JSON.parse(last_response.body)['message']
          expect(last_response.status).to eq(400)
          expect(error_messages.count).to eq(1)
          expect(error_messages[0]).to eq('Name can\'t be blank')
          expect(last_response.content_type).to eq('application/json')
        end
      end
    end
  end

  describe 'DELETE /products/:id' do
    it 'delete the requested product' do
      expect do
        delete "/products/#{product.id}", {}, session: valid_session
      end.to change { Product.count }.by(-1)
    end
  end
end
