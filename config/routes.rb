Rails.application.routes.draw do

  devise_for :users

  namespace :admin do
    root 'tools#index'
    resources :tools do
      collection do
        get 'delete'
      end
    end
    resources :tool_groups
    resources :users
  end

  root 'home#index'

  namespace :workspace do
    get :index
  end

  namespace :datastore do
    get :index
  end

  resources :pipelines

  resources :tools do
    member do
      get 'box'
    end
  end

  resources :scholar

  namespace :settings do
    root 'profiles#edit'
    resource :profile

    get 'security', to: 'security#edit'
    put 'security', to: 'security#update'
  end

end

