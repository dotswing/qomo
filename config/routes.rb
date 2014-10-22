Rails.application.routes.draw do

  get 'jobs/index'

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
    post :run
    get 'load/:id', action: 'load', as: 'load_pipeline'
    get 'merge/:id', action: 'merge', as: 'merge_pipeline'
  end


  resources :jobs do
    collection do
      get :summary
    end
  end


  namespace :datastore do
    get :index
    get :upload
    post :upload, action: :upload_do
    post :delete
    get :download
    get :view
  end

  resources :pipelines do
    collection do
      get 'my'
    end

    member do
      get 'mark_public'
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

  namespace :scholar do
    get :index
    get 'pubmed/search', action: 'pubmed_search'
    get 'pubmed/search/do', action: 'do_pubmed_search'
    get 'publications/:pmid/add', action: 'publications_add', as: 'publications_add'
    get 'publications/:pmid/del', action: 'publications_del', as: 'publications_del'
  end

  namespace :settings do
    root 'profiles#edit'
    resource :profile

    get 'security', to: 'security#edit'
    put 'security', to: 'security#update'
  end


  namespace :help do
    get 'about'
    get 'agreement'
    get 'tutorial'
  end

end

