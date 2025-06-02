class TasksController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  def index
    @tasks = @user.tasks
    render json: @tasks, status: :ok
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, _|
      @user = User.find_by(token:)
    end
  end
end
