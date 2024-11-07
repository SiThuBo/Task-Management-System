class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: %i[ show edit update destroy ]
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    # @task = Task.new
    @task = current_user.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    # @task = Task.new(task_params)
    @task = current_user.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        flash[:notice] = "Task was successfully created."
        format.html { redirect_to @task }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        flash[:notice] = "Task was successfully updated."
        format.html { redirect_to @task }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!
    flash[:notice] = "Task was successfully destroyed."

    respond_to do |format|
      format.html { redirect_to tasks_path, status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def check_user
      task = current_user.tasks.find_by_id(params[:id])
      if task.nil?
        flash[:error] = "You are not authorize for this task!."
        redirect_to tasks_path
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :status, :priority, :due_date, :user_id)
    end
end
