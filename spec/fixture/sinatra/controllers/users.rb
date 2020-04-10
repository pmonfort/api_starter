# frozen_string_literal: true

require './api/base_controller'

module API
  class UsersController < BaseController
    get '/users' do
      User.all
    end

    get '/users/:id' do
      user
    end

    post '/users' do
      required_params user: %i[birthday company_id email password]
      user = User.new(user_params)
      if user.save
        status 201
        { message: 'User was successfully created.' }
      else
        halt 400, json({ message: user.errors.full_messages })
      end
    end

    put '/users/:id' do
      if user.update(user_params)
        { message: 'User was successfully updated.' }
      else
        halt 400, json({ message: user.errors.full_messages })
      end
    end

    delete '/users/:id' do
      user.destroy
      { message: 'User has been deleted' }
    end

    def user
      @user ||= User.find(params[:id])
    rescue
      halt 404
    end

    def product_params
      params['user'].slice(
        %w[age birthday company_id email first_name last_name password]
      )
    end
  end
end
