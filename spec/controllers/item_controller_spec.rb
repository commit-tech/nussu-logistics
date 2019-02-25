require 'spec_helper'

RSpec.describe ItemController, type: :controller do
    describe 'GET #edit' do
        it 'redirects when unauthenticated' do
            get :edit, params: { id: create(:user).id }
            should redirect_to(new_user_session_path)
        end
        it 'denies access when normal user access another users page' do
            user = create(:user)
            sign_in user
            expect do
                get :edit, params: { id: create(:user).id }
            end.to raise_error(CanCan::AccessDenied)
        end
        it 'provides access to admin' do
            user = create(:user)
            user.add_role(:admin)
            sign_in user
            get :edit, params: { id: create(:user).id }
            should respond_with :ok
        end
    end
    describe "GET #index" do
        it "populates an array of items"
        it "renders the :index view"
    end
  
    describe "GET #show" do
        it "assigns the requested contact to @item"
        it "renders the :show template"
    end
  
    describe "GET #new" do
        it "assigns a new Contact to @item"
        it "renders the :new template"
    end
  
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new contact in the database"
            it "redirects to the home page"
        end
    
        context "with invalid attributes" do
            it "does not save the new contact in the database"
            it "re-renders the :new template"
        end
    end
end