require 'rails_helper'
#require_relative "../support/devise"

# Change this ArticlesController to your project
RSpec.describe TasksController, type: :controller do
  describe 'with logged in user' do
    login_user

    describe 'GET #index' do
      it 'should have a current_user' do
        expect(subject.current_user).to_not eq(nil)
      end

      it 'returns a success response' do
        get :index
        expect(response).to be_successful # be_successful expects a HTTP Status code of 200
      end

      it 'displays tasks' do
        task1 = create(:task)
        task2 = create(:task, task_name: 'Task 2', target_password: 'target2', source_password: 'source2')
        get :index
        assigns(:tasks).should eq([task1, task2])
      end

      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
    end

    describe 'GET #show' do
      it "assigns the requested contact to @contact" do
        task = create(:task)
        get :show, params: { id: task.id }

        assigns(:task).should eq(task)
        expect(response).to render_template :show
        expect(response).to have_http_status(200)
      end
    end
    #
    # describe 'GET #new' do
    #   it 'assigns a new Task to @task'
    #   it 'renders :new template'
    # end
    #
    # describe 'POST #create' do
    #   describe "with valid attributes" do
    #     it "saves the new task in the database"
    #     it "redirects to index page"
    #   end
    #
    #   describe "with invalid attributes" do
    #     it "does not save the new task in the database"
    #     it "re-renders the :new template"
    #   end
    # end
    #
    # describe 'PUT update' do
    #   describe 'valid attributes' do
    #     it 'located the requested @task'
    #     it "changes @task's attributes"
    #     it 'redirects to updated contact'
    #   end
    # end
  end
end