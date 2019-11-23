require 'rails_helper'

RSpec.describe Account::UsersController, type: :controller do
  render_views

  let!(:user) { create(:user) }
  let!(:user_valid_params) { { first_name: "John", last_name: "Doe", email: 'foo@gmail.com', password: 'foobar' } }
  let!(:user_invalid_params) { { first_name: "" } }


  context 'when logged in' do
    before do
      sign_in user
    end

    describe 'GET #index' do
      it 'renders index template' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it "returns a 200 status code" do
        get :new
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'should create a new user' do
          expect do
            post :create, params: { user: user_valid_params}
          end.to change(User, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'should not create a new contact' do
          expect do
            post :create, params: { user: user_invalid_params }
          end.to_not change(User, :count)
        end
      end
    end

    describe 'GET #show' do
      it 'should show user page' do
        get :show, params: { id: user.id }
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      it 'must display edit page' do
        get :edit, params: { id: user.id }
        expect(response).to render_template(:edit)
      end
    end

    describe 'PATCH #update' do
      it 'with valid attributes' do
        patch :update, params: { id: user.id, user: user_valid_params }
        user.reload
        expect(user.first_name).to eq(user_valid_params[:first_name])
      end

      it 'shouldnt update and redirects to edit' do
        patch :update, params: { id: user.id, user: user_invalid_params }
        user.reload
        expect(user.first_name).not_to eq(user_valid_params[:first_name])
        expect(response).to render_template(:edit)
      end
    end

    describe 'DELETE #destroy' do
      it 'should delete user' do
        expect{ (delete :destroy, params: { id: user.id }) }.to change{ User.count }.by(-1)
        expect(response).to redirect_to account_users_path
      end
    end

  end
end
