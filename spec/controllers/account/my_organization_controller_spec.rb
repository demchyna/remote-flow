require 'rails_helper'

RSpec.describe Account::MyOrganizationController, type: :controller do
  render_views

  let!(:organization) { create(:organization, name: 'OldName') }
  let!(:admin) { create(:user, :admin, organization_id: organization.id) }


  context 'when not logged in' do
    describe 'GET #show' do
      it 'redirects to login page' do
        get :show
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET #edit' do
      it 'redirects to login page' do
        get :edit
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PATCH #update' do
      it 'redirects to login page' do
        patch :update, params: {
          organization: {
            name: 'NewName'
          },
          id: organization.id
        }

        expect(response).to redirect_to(new_user_session_path)
        expect(organization.name).not_to eq('NewName')
      end
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    describe 'GET #show' do
      it 'renders show template' do
        get :show
        expect(response).to be_successful
        expect(response).to render_template(:show)
      end
    end

    describe 'GET #edit' do
      it 'renders edit template' do
        get :edit
        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end
    end

    describe 'PATCH #update' do
      it 'updates organization name' do
        patch :update, params: {
          organization: {
            name: 'NewName'
          },
          id: organization.id
        }

        organization.reload

        expect(response).to redirect_to(account_my_organization_path)
        expect(organization.name).not_to eq('OldName')
        expect(organization.name).to eq('NewName')
      end

      it 'does not updates organization name' do
        put :update, params: {
          organization: {
            name: " "
          },
          id: organization.id
        }

        organization.reload

        expect(response).to render_template(:edit)
        expect(organization.name).to eq('OldName')
      end
    end
  end
end
