class TasksController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate
  before_action :set_task, only: %i[update destroy]

  def index
    @tasks = @user.tasks
    render json: @tasks, status: :ok
  end

  def create
    task = @user.tasks.new(content: params[:content])
    if task.save
      render json: task, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def update
    update_params = { content: params[:content] }
    update_params[:completed] = params[:completed] if params.key?(:completed)
    if @task.update(update_params)
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy!
    head :no_content
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, _|
      @user = User.find_by(token:)
    end
  end

  def set_task
    @task = @user.tasks.find(params[:id])
  end
end
