require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user) { FactoryBot.create(:user, email: "user_#{SecureRandom.hex(5)}@example.com") }
  let(:task) { FactoryBot.create(:task, user: user, status: :to_do) }

  before do
    sign_in user
  end

  describe 'GET /tasks' do
    it 'returns a successful response with task data' do
      get tasks_path, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /tasks/:id' do
    it 'returns a successful response for a valid task' do
      get task_path(task)
      expect(response).to be_successful
    end

    it 'redirects to tasks_path if task not found for current user' do
      another_user = FactoryBot.create(:user, email: "another_user_#{SecureRandom.hex(5)}@example.com")
      another_task = FactoryBot.create(:task, user: another_user)
      get task_path(another_task)
      expect(flash[:error]).to eq('You are not authorize for this task!.')
      expect(response).to redirect_to(tasks_path)
    end
  end

  describe 'GET /tasks/new' do
    it 'returns a successful response' do
      get new_task_path
      expect(response).to be_successful
    end
  end

  describe 'GET /tasks/:id/edit' do
    it 'returns a successful response for a valid task' do
      get edit_task_path(task)
      expect(response).to be_successful
    end

    it 'redirects if the task is not found for the current user' do
      another_user = FactoryBot.create(:user, email: "another_user_#{SecureRandom.hex(5)}@example.com")
      another_task = FactoryBot.create(:task, user: another_user)
      get edit_task_path(another_task)
      expect(flash[:error]).to eq('You are not authorize for this task!.')
      expect(response).to redirect_to(tasks_path)
    end
  end

  describe 'POST /tasks' do
    context 'with valid parameters' do
      it 'creates a new task and redirects to the task show page' do
        task_params = { title: 'Test Task', description: 'Test description', status: 'to_do', priority: 'High', due_date: '2024-12-31' }
        expect {
          post tasks_path, params: { task: task_params }
        }.to change(Task, :count).by(1)
        expect(flash[:notice]).to eq('Task was successfully created.')
        expect(response).to redirect_to(Task.last)
      end
    end
  end

  describe 'PATCH/PUT /tasks/:id' do
    context 'with valid parameters' do
      it 'updates the task and redirects to the task show page' do
        updated_attributes = { title: 'Updated Task Title' }
        patch task_path(task), params: { task: updated_attributes }
        expect(task.reload.title).to eq('Updated Task Title')
        expect(flash[:notice]).to eq('Task was successfully updated.')
        expect(response).to redirect_to(task)
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    it 'destroys the task and redirects to tasks index' do
      task_to_delete = create(:task, user: user)
      expect {
        delete task_path(task_to_delete)
      }.to change(Task, :count).by(-1)
      expect(flash[:notice]).to eq('Task was successfully destroyed.')
      expect(response).to redirect_to(tasks_path)
    end

    it 'does not destroy a task if not authorize' do
      another_user = FactoryBot.create(:user, email: "another_user_#{SecureRandom.hex(5)}@example.com")
      another_task = FactoryBot.create(:task, user: another_user)
      delete task_path(another_task)
      expect(flash[:error]).to eq('You are not authorize for this task!.')
      expect(response).to redirect_to(tasks_path)
    end
  end
end
