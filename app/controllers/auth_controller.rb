class AuthController < ApplicationController
  def create
    user = User.authenticate_by(email: params[:email], password: params[:password])
    if user
      set_auth_cookie(user)
      render json: { token: user.token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    clear_auth_cookie
    render json: { message: "Logged out successfully" }, status: :ok
  end
end
