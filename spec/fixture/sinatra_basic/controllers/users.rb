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

    post '/users', allows: %i[age first_name last_name], needs: %i[birthday company_id email password] do
      if user.update(user_params)
        status 201
        { message: 'User was successfully created.' }
      else
        halt 500, json({ message: user.errors.full_messages })
      end
    end

    put '/users/:id', allows: %i[age birthday company_id email first_name last_name password] do
      if user.update(user_params)
        { message: 'User was successfully updated.' }
      else
        halt 500, json({ message: user.errors.full_messages })
      end
    end

    delete '/users/:id' do
      user.destroy
      { message: 'User has been deleted' }
    end

    def user
      @user ||= User.find(params[:id])
    end
  end
end
