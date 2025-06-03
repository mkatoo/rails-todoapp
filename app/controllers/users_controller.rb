class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]

  def index
    @users = User.all
    users = @users.map { |user| user_hash(user) }
    render json: users, status: :ok
  end

  def show
    render json: user_hash(@user), status: :ok
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )
    if @user.save
      render json: user_hash(@user), status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_hash(user)
    {
      name: user.name,
      email: user.email,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
