# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe API::UsersController do
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      age: Faker::Number.number(digits: 2),
      birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
      company_id: create(:company).id,
      email: Faker::Internet.email,
      first_name: Faker::Name.name,
      last_name: Faker::Name.name,
      password: Faker::Internet.password
    }
  end

  # Missing required field params

  let(:invalid_missing_required_param_birthday) do
    {
      age: Faker::Number.number(digits: 2),
      company_id: create(:company).id,
      email: Faker::Internet.email,
      first_name: Faker::Name.name,
      last_name: Faker::Name.name,
      password: Faker::Internet.password,
    }
  end

  let(:invalid_missing_required_param_company_id) do
    {
      age: Faker::Number.number(digits: 2),
      birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
      email: Faker::Internet.email,
      first_name: Faker::Name.name,
      last_name: Faker::Name.name,
      password: Faker::Internet.password,
    }
  end

  let(:invalid_missing_required_param_email) do
    {
      age: Faker::Number.number(digits: 2),
      birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
      company_id: create(:company).id,
      first_name: Faker::Name.name,
      last_name: Faker::Name.name,
      password: Faker::Internet.password,
    }
  end

  let(:invalid_missing_required_param_password) do
    {
      age: Faker::Number.number(digits: 2),
      birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
      company_id: create(:company).id,
      email: Faker::Internet.email,
      first_name: Faker::Name.name,
      last_name: Faker::Name.name,
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  let!(:user) { create(:user) }

  describe 'GET /users' do
    it 'returns a success response' do
      get '/users', {}, session: valid_session
      expect(last_response).to be_successful
    end
  end

  describe 'GET /users/:id' do
    it 'returns a success response' do
      get '/users', { id: user.id }, session: valid_session
      expect(last_response).to be_successful
    end

    describe 'wrong id' do
      it '404' do
        get '/users/-1', {}, session: valid_session
        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'POST /users' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post '/users', {
            user: valid_attributes
          }, session: valid_session
        end.to change { User.count }.by(1)
      end

      it 'renders a JSON response with the new user' do
        post '/users', {
          user: valid_attributes
        }, session: valid_session
        expect(last_response.status).to eq(201)
        expect(last_response.content_type).to eq('application/json')
      end
    end

    describe 'with invalid params' do
      context 'missing required birthday' do
        it 'renders a JSON response with errors for the new user' do
          post '/users', {
            user: invalid_missing_required_param_birthday
          }, session: valid_session
          expect(last_response.status).to eq(400)
          expect(last_response.content_type).to eq('application/json')
        end
      end

      context 'missing required company_id' do
        it 'renders a JSON response with errors for the new user' do
          post '/users', {
            user: invalid_missing_required_param_company_id
          }, session: valid_session
          expect(last_response.status).to eq(400)
          expect(last_response.content_type).to eq('application/json')
        end
      end

      context 'missing required email' do
        it 'renders a JSON response with errors for the new user' do
          post '/users', {
            user: invalid_missing_required_param_email
          }, session: valid_session
          expect(last_response.status).to eq(400)
          expect(last_response.content_type).to eq('application/json')
        end
      end

      context 'missing required password' do
        it 'renders a JSON response with errors for the new user' do
          post '/users', {
            user: invalid_missing_required_param_password
          }, session: valid_session
          expect(last_response.status).to eq(400)
          expect(last_response.content_type).to eq('application/json')
        end
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:new_attributes) do
      build(:user).attributes.slice(
        %w[age birthday company_id email first_name last_name password]
      )
    end

    context 'with valid params' do
      before do
        put "/users/#{user.id}", {
          user: new_attributes
        }, session: valid_session
      end

      it 'updates the requested user' do
        user.reload
        expect(user.age).to eq(
          new_attributes['age']
        )
        expect(user.birthday).to eq(
          new_attributes['birthday']
        )
        expect(user.company_id).to eq(
          new_attributes['company_id']
        )
        expect(user.email).to eq(
          new_attributes['email']
        )
        expect(user.first_name).to eq(
          new_attributes['first_name']
        )
        expect(user.last_name).to eq(
          new_attributes['last_name']
        )
        expect(user.password).to eq(
          new_attributes['password']
        )
      end

      it 'renders a JSON response with the user' do
        expect(last_response).to be_successful
        expect(last_response.content_type).to eq('application/json')
      end
    end

    describe 'with invalid params' do
      context 'with birthday set to nil' do
        it 'renders a JSON response with errors' do
          put "/users/#{user.id}", {
            user: new_attributes.merge({ birthday: nil })
          }, session: valid_session
          error_messages = JSON.parse(last_response.body)['message']
          expect(last_response.status).to eq(400)
          expect(error_messages.count).to eq(1)
          expect(error_messages[0]).to eq('Birthday can\'t be blank')
          expect(last_response.content_type).to eq('application/json')
        end
      end

      context 'with company_id set to nil' do
        it 'renders a JSON response with errors' do
          put "/users/#{user.id}", {
            user: new_attributes.merge({ company_id: nil })
          }, session: valid_session
          error_messages = JSON.parse(last_response.body)['message']
          expect(last_response.status).to eq(400)
          expect(error_messages.count).to eq(1)
          expect(error_messages[0]).to eq('Company_id can\'t be blank')
          expect(last_response.content_type).to eq('application/json')
        end
      end

      context 'with email set to nil' do
        it 'renders a JSON response with errors' do
          put "/users/#{user.id}", {
            user: new_attributes.merge({ email: nil })
          }, session: valid_session
          error_messages = JSON.parse(last_response.body)['message']
          expect(last_response.status).to eq(400)
          expect(error_messages.count).to eq(1)
          expect(error_messages[0]).to eq('Email can\'t be blank')
          expect(last_response.content_type).to eq('application/json')
        end
      end

      context 'with password set to nil' do
        it 'renders a JSON response with errors' do
          put "/users/#{user.id}", {
            user: new_attributes.merge({ password: nil })
          }, session: valid_session
          error_messages = JSON.parse(last_response.body)['message']
          expect(last_response.status).to eq(400)
          expect(error_messages.count).to eq(1)
          expect(error_messages[0]).to eq('Password can\'t be blank')
          expect(last_response.content_type).to eq('application/json')
        end
      end
    end
  end

  describe 'DELETE /users/:id' do
    it 'delete the requested user' do
      expect do
        delete "/users/#{user.id}", {}, session: valid_session
      end.to change { User.count }.by(-1)
    end
  end
end
