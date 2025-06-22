class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]
  before_action :authenticate_user!, only: %i[ update me ]

  def index
    @users = User.all
    users = @users.map do |user|
      {
        name: user.name,
        email: user.email,
        created_at: user.created_at,
        updated_at: user.updated_at
      }
    end
    render json: users, status: :ok
  end

  def show
    response = {
      name: @user.name,
      email: @user.email,
      created_at: @user.created_at,
      updated_at: @user.updated_at
    }
    render json: response, status: :ok
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )
    if @user.save
      set_auth_cookie(@user)
      response = {
        name: @user.name,
        email: @user.email,
        token: @user.token,
        created_at: @user.created_at,
        updated_at: @user.updated_at
      }
      render json: response, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if current_user.update(name: params[:name])
      response = {
        name: current_user.name,
        email: current_user.email,
        created_at: current_user.created_at,
        updated_at: current_user.updated_at
      }
      render json: response, status: :ok
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def me
    response = {
      name: current_user.name,
      email: current_user.email,
      created_at: current_user.created_at,
      updated_at: current_user.updated_at
    }
    render json: response, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
