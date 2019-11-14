require 'rails_helper'
#require_relative "../support/devise"

# Change this ArticlesController to your project
RSpec.describe TasksController, type: :controller do
  describe "GET #index" do

    login_user

    it "should have a current_user" do
      expect(subject.current_user).to_not eq(nil)
    end

    it "returns a success response" do
      get :index
      expect(response).to be_successful # be_successful expects a HTTP Status code of 200
    end
  end
end