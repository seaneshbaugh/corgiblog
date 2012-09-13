Corgiblog::Application.routes.draw do
  devise_for :users, :only => [:sessions, :passwords]

  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    delete '/logout' => 'devise/sessions#destroy'
    get '/reset-password' => 'devise/passwords#new', :as => 'reset_password'
  end

  resources :pages, :only => [:show]

  resources :pictures, :only => [:index, :show]

  resources :posts, :only => [:index, :show]

  authenticate :user do
    namespace :admin do
      root :to => 'admin#index'

      get 'reboot' => 'admin#reboot', :as => 'reboot'
      get 'export' => 'admin#export', :as => 'export'
      get 'analytics' => 'admin#analytics', :as => 'analytics'

      resources :pages

      resources :pictures

      resources :posts

      resources :users
    end

    post 'versions/:id/revert' => 'versions#revert', :as => 'revert_version'
  end

  root :to => 'posts#index'

  match ':id' => 'pages#show'
end
