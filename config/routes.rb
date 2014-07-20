Rails.application.routes.draw do

  devise_for :users

  namespace :admin do
    root 'tools#index'
    resources :tools do
      collection do
        get 'delete'
      end

      member do
        post 'file', action: 'uploadfile'
        delete 'file', action: 'deletefile'
      end
    end
    resources :tool_groups

    resources :users do
      member do
        put 'admin'
      end
    end

  end

  root 'home#index'

  namespace :workspace do
    get :index
    get 'load/:id', action: 'load', as: 'load_pipeline'
    get 'merge/:id', action: 'merge', as: 'merge_pipeline'
  end

  namespace :datastore do
    get :index
  end

  resources :pipelines do
    collection do
      get 'my'
    end

  end

  resources :tools do
    collection do
      get 'my'
    end

    collection do
      get 'boxes'
    end

    member do
      get 'box'
      get 'box/:bid', action: 'box'
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

