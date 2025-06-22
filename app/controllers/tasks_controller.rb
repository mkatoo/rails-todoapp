class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[update destroy]

  def index
    @tasks = current_user.tasks
    render json: @tasks, status: :ok
  end

  def create
    task = current_user.tasks.new(content: params[:content])
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

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
