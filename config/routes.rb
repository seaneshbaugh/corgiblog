Corgiblog::Application.routes.draw do
  devise_for :users, :only => [:sessions, :passwords]

  devise_scope :user do
    get '/login' => 'devise/sessions#new'
  end

  devise_scope :user do
    delete '/logout' => 'devise/sessions#destroy'
  end

  resources :pages, :only => [:index, :show]

  resources :pictures, :only => [:index, :show]

  resources :posts, :only => [:index, :show]

  authenticate :user do
    namespace :admin do
      root :to => 'admin#index'

      get 'reboot' => 'admin#reboot', :as => 'reboot'
      get 'export' => 'admin#export', :as => 'export'

      resources :pages

      resources :pictures

      resources :posts

      resources :users
    end

    post 'versions/:id/revert' => 'versions#revert', :as => 'revert_version'
  end

  root :to => 'posts#index'
end
