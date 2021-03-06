# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'with logged in user' do
    let(:task) { create(:task) }

    login_user

    describe 'GET #index' do
      it 'has a current_user' do
        expect(subject.current_user).not_to eq(nil)
      end

      it 'returns a success response' do
        get :index
        expect(response).to be_successful # be_successful expects a HTTP Status code of 200
      end

      it 'displays tasks' do
        task1 = create(:task)
        task2 = create(
          :task,
          task_name: 'Task 2',
          encrypted_target_password: SymmetricEncryption.encrypt('target2'),
          encrypted_source_password: SymmetricEncryption.encrypt('source2')
        )

        get :index
        assigns(:tasks).should eq([task1, task2])
      end

      it 'renders the :index view' do
        get :index
        response.should render_template :index
      end
    end

    describe 'GET #show' do
      before do
        get :show, params: { id: task.id }
      end

      it 'assigns correct object' do
        assigns(:task).should eq(task)
      end

      it 'renders :show view and returns success' do
        expect(response).to render_template :show
      end

      it 'returns success' do
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET #new' do
      before do
        get :new
      end

      it 'renders :new template' do
        expect(response).to render_template :new
      end

      it 'returns success' do
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST #create with valid attributes' do
      before do
        # have to do hash manipulations, bc parameters have unencrypted fields
        # but the model has encrypted fields.
        @task_params = FactoryBot.attributes_for(:task)
        @task_params.delete(:encrypted_target_password)
        @task_params.delete(:encrypted_source_password)
        @task_params[:target_password] = SecureRandom.base64(8)
        @task_params[:source_password] = SecureRandom.base64(8)
      end

      it 'creates new task' do
        expect do
          post :create, params: { task: @task_params }
        end.to change(Task, :count).by(1)
      end

      it 'redirects to index page' do
        post :create, params: { task: @task_params }

        expect(response).to redirect_to Task.last
      end

      it 'saves all parameters to the model' do
        post :create, params: { task: @task_params }

        saved_task = Task.last

        expect(saved_task.task_name).to eq(@task_params[:task_name])
        expect(saved_task.target_host).to eq(@task_params[:target_host])
        expect(saved_task.target_protocol).to eq(@task_params[:target_protocol])
        expect(saved_task.target_format).to eq(@task_params[:target_format])
        expect(saved_task.target_stream).to eq(@task_params[:target_stream])
        expect(saved_task.target_username).to eq(@task_params[:target_username])
        expect(saved_task.encrypted_target_password).to eq(SymmetricEncryption.encrypt(@task_params[:target_password]))
        expect(saved_task.source_host).to eq(@task_params[:source_host])
        expect(saved_task.source_protocol).to eq(@task_params[:source_protocol])
        expect(saved_task.source_format).to eq(@task_params[:source_format])
        expect(saved_task.source_stream).to eq(@task_params[:source_stream])
        expect(saved_task.source_username).to eq(@task_params[:source_username])
        expect(saved_task.encrypted_source_password).to eq(SymmetricEncryption.encrypt(@task_params[:source_password]))
        expect(saved_task.source_pattern).to eq(@task_params[:source_pattern])
      end
    end

    describe 'POST #create  with invalid attributes' do
      let(:invalid_task_params) { FactoryBot.attributes_for(:task, :invalid_task) }

      it 'does not save new task' do
        expect do
          post :create, params: { task: invalid_task_params }
        end.not_to change(Task, :count)
      end

      it 're-renders the new page' do
        post :create, params: { task: invalid_task_params }

        expect(response).to render_template :new
      end
    end

    describe 'PUT #update with valid attributes' do
      before do
        put :update, params: {
          id: task.id,
          task: {
            task_name: 'Updated Task',
            source_host: 'Updated Host'
          }
        }
      end

      it 'located the requested @task and updates attributes' do
        assigns(:task).should eq(task)
        task.reload
        expect(task.task_name).to eq('Updated Task')
        expect(task.source_host).to eq('Updated Host')
      end

      it 'redirects to updated task' do
        expect(response).to redirect_to task
      end
    end

    describe 'PUT #update invalid attributes' do
      before do
        put :update, params: {
          id: task.id,
          task: {
            task_name: '',
            source_host: 'Updated Host'
          }
        }
      end

      it 'does not change attributes' do
        assigns(:task).should eq(task)
        task.reload
        expect(task.task_name).not_to eq('')
        expect(task.source_host).not_to eq('Updated Host')
      end

      it 'redirects to edit page' do
        expect(response).to render_template :edit
      end
    end

    describe 'DELETE destroy' do
      it 'deletes the task' do
        task = create(:task)

        expect do
          delete :destroy, params: { id: task.id }
        end.to change(Task, :count).by(-1)
      end

      it 'redirect to index page' do
        task = create(:task)
        delete :destroy, params: { id: task.id }

        expect(response).to redirect_to tasks_url
      end
    end
  end
end
