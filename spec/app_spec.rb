# frozen_string_literal: true

require_relative 'spec_helper'

def app
  App
end

shared_examples 'valid request' do
  it 'use the expected generator with the right params' do
    expect(generator).to receive(:new).with(params)
    post '/', params
  end
end

describe App do
  describe 'POST to /' do
    describe 'receive valid params' do
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

      it 'response should be success' do
        post '/', valid_params
        expect(last_response.status).to eq(200)
      end

      context 'framework Rails API' do
        it_behaves_like 'valid request' do
          let(:generator) { Ruby::RailsAPI::Generator }
          let(:params) { valid_params }
        end
      end

      context 'framework Sinatra' do
        let(:updated_params) { valid_params.merge({ framework: 'Sinatra' }) }
        it_behaves_like 'valid request' do
          let(:generator) { Ruby::Sinatra::Generator }
          let(:params) { updated_params }
        end
      end

      context 'framework Rust' do
        let(:updated_params) { valid_params.merge({ framework: 'Rust' }) }
        it_behaves_like 'valid request' do
          let(:generator) { Rust::Generator }
          let(:params) { updated_params }
        end
      end

      context 'framework Elixir' do
        let(:updated_params) { valid_params.merge({ framework: 'Elixir' }) }
        it_behaves_like 'valid request' do
          let(:generator) { Elixir::Generator }
          let(:params) { updated_params }
        end
      end
    end
  end
end
