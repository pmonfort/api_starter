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
          }
        )
      end

      it 'response should be success' do
        post '/', valid_params
        expect(last_response.status).to eq(200)
      end

      context 'framework Rails API' do
        it_behaves_like 'valid request' do
          let(:generator) { Generators::RailsAPI }
          let(:params) { valid_params }
        end
      end

      context 'framework Sinatra' do
        let(:updated_params) { valid_params.merge({ framework: 'Sinatra' }) }
        it_behaves_like 'valid request' do
          let(:generator) { Generators::Sinatra }
          let(:params) { updated_params }
        end
      end

      context 'framework Rust' do
        let(:updated_params) { valid_params.merge({ framework: 'Rust' }) }
        it_behaves_like 'valid request' do
          let(:generator) { Generators::Rust }
          let(:params) { updated_params }
        end
      end

      context 'framework Elixir' do
        let(:updated_params) { valid_params.merge({ framework: 'Elixir' }) }
        it_behaves_like 'valid request' do
          let(:generator) { Generators::Elixir }
          let(:params) { updated_params }
        end
      end
    end
  end
end
