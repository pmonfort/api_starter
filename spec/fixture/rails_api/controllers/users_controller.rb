# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:destroy, :show, :update]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    rescue
      render json: { error: 'not-found' }, status: :not_found
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:age, :birthday, :company_id, :email, :first_name, :last_name, :password)
    end
end
