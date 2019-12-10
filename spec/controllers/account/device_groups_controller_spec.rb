require 'rails_helper'

RSpec.describe Account::DeviceGroupsController, type: :controller do

  let!(:organization) { create(:organization) }
  let!(:another_organization) { create(:organization) }
  let!(:user) { create(:user, organization: organization) }
  let!(:device_group) { create(:device_group, name:'John', organization: organization) }

  context 'when not logged in' do
    describe 'GET #index' do
      it 'redirects to login page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET #show' do
      it 'redirects to login page' do
        get :show, params: { id: device_group.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET #new' do
      it 'redirects to login page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST #create' do
      it 'redirects to login page' do
        post :create, params: { name: device_group.name }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET #edit' do
      it 'redirects to login page' do
        get :edit, params: { id: device_group.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PATCH #update' do
      it 'redirects to login page' do
        patch :update, params: {
          device_group: {
            name: 'Theofurt'
          },
          id: device_group.id
        }

        expect(response).to redirect_to(new_user_session_path)
        expect(device_group.name).not_to eq('Theofurt')
        expect(device_group.name).to eq('John')
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to login page' do
        expect do
          delete :destroy, params: { id: device_group.id }
        end.not_to change(DeviceGroup, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'when logged in as user' do
    before do
      sign_in user
    end

    describe 'GET #index' do
      it 'renders index template' do
        get :index
        expect(response).to be_successful
        expect(response).to render_template(:index)
      end
    end

    describe 'GET #show' do
      it 'renders show template' do
        get :show, xhr: true,
        params: { id: device_group.id }
        expect(response).to be_successful
        expect(response).to render_template(:show)
      end
    end

    describe 'GET #new' do
      it 'renders new template' do
        get :new, xhr: true
        expect(response).to render_template(:new)
      end
    end

    describe 'GET #edit' do
      it 'renders edit template' do
        get :edit, xhr: true,
        params: { id: device_group.id }
        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end
    end

    describe 'POST #create' do
      it 'creates device group' do
        expect do
          post :create, xhr: true,
          params: {
            device_group: {
              name: device_group.name,
              description: device_group.description,
              organization_id: device_group.organization.id
            }
          }
        end.to change(DeviceGroup, :count).by(1)
      end
      it 'cannot creates device group with blank name' do
        expect do
          post :create, xhr: true,
          params: {
            device_group: {
              name: '',
              description: device_group.description,
              organization_id: device_group.organization.id
            }
          }
        end.to change(DeviceGroup, :count).by(0)
      end
    end

    describe 'PATCH #update' do
      it 'updates device group name' do
        patch :update, xhr: true,
        params: {
          device_group: {
            name: 'Theofurt'
          },
          id: device_group.id
        }

        expect(assigns(:device_group).name).not_to eq('John')
        expect(assigns(:device_group).name).to eq('Theofurt')
      end
      it 'cannot updates device group with blank name' do
        patch :update, xhr: true,
        params: {
          device_group: {
            name: '',
            description: device_group.description
          },
          id: device_group.id
        }
        device_group.reload
        expect(device_group.name).not_to eq('')
      end
      it 'cannot change device group organization' do
        patch :update, xhr: true,
        params: {
          device_group: {
            organization_id: another_organization.id
          },
          id: device_group.id
        }

        expect(assigns(:device_group).organization_id).not_to eq(another_organization.id)
      end

    end


    describe 'DELETE #destroy' do
      it 'changes Device Group.count' do
        expect do
          delete :destroy, xhr: true,
          params: { id: device_group.id }
        end.to change(DeviceGroup, :count).by(-1)
      end
    end
  end
end