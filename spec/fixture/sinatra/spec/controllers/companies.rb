# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe API::CompaniesController do
  # This should return the minimal set of attributes required to create a valid
  # Company. As you add validations to Company, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      name: Faker::Name.name,
      web_site: Faker::Lorem.sentence
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CompaniesController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  let!(:company) { create(:company) }
  let(:valid_attributes) do
    build(:company).attributes.slice(
      *%w[name web_site]
    )
  end

  describe 'GET /companies/:id' do
    it 'returns a success response' do
      get "/companies/#{company.id}", {}, session: valid_session
      expect(last_response).to be_successful
    end

    describe 'wrong id' do
      it '404' do
        get '/companies/-1', {}, session: valid_session
        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'POST /companies' do
    context 'with valid params' do
      it 'creates a new Company' do
        expect do
          post '/companies', {
            company: valid_attributes
          }, session: valid_session
        end.to change { Company.count }.by(1)
      end

      it 'renders a JSON response with the new company' do
        post '/companies', {
          company: valid_attributes
        }, session: valid_session
        expect(last_response.status).to eq(201)
        expect(last_response.content_type).to eq('application/json')
      end
    end

    describe 'with invalid params' do
      context 'missing required name' do
        it 'renders a JSON response with errors for the new company' do
          post '/companies', {
            company: valid_attributes.reject { |key, val| key == 'name' }
          }, session: valid_session
          expect(last_response.status).to eq(400)
          expect(last_response.content_type).to eq('application/json')
        end
      end
    end
  end

  describe 'PUT /companies/:id' do
    context 'with valid params' do
      before do
        put "/companies/#{company.id}", {
          company: valid_attributes
        }, session: valid_session
      end

      it 'updates the requested company' do
        company.reload
        expect(company.name).to eq(
          valid_attributes['name']
        )
        expect(company.web_site).to eq(
          valid_attributes['web_site']
        )
      end

      it 'renders a JSON response with the company' do
        expect(last_response).to be_successful
        expect(last_response.content_type).to eq('application/json')
      end
    end

    describe 'with invalid params' do
      context 'with name set to nil' do
        it 'renders a JSON response with errors' do
          put "/companies/#{company.id}", {
            company: valid_attributes.merge({ name: nil })
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
end
