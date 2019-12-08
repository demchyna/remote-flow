Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    invitations: 'users/invitations'
  }

  root 'public#index'

  get '/pricing', to: 'public#pricing'

  namespace :account do
    get '/', to: 'dashboard#index'
    resources :users
    resources :devices
    resource  :profile, only: %i[edit update]
    resources :organizations, except: %i[new, create]
    resources :channels
    resources :contents
  end
end
