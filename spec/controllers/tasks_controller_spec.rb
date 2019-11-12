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

      #it 'displays all tasks'

      it 'returns a success response' do
        get :index
        expect(response).to be_successful # be_successful expects a HTTP Status code of 200
      end
    end

    describe 'GET #show' do
      it 'assigns the requested task to @task'
      it 'renders :show template'
    end

    describe 'GET #new' do
      it 'assigns a new Task to @task'
      it 'renders :new template'
    end

    describe 'POST #create' do
      describe "with valid attributes" do
        it "saves the new task in the database"
        it "redirects to index page"
      end

      describe "with invalid attributes" do
        it "does not save the new task in the database"
        it "re-renders the :new template"
      end
    end

    describe 'PUT update' do
      describe 'valid attributes' do
        it 'located the requested @task'
        it "changes @task's attributes"
        it 'redirects to updated contact'
      end
    end
  end
end