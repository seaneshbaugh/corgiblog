Corgiblog::Application.routes.draw do
  devise_for :users, :only => [:sessions, :passwords]

  devise_scope :user do
    get '/login' => 'devise/sessions#new'
  end

  devise_scope :user do
    delete '/logout' => 'devise/sessions#destroy'
  end

  resources :pages, :only => [:index, :show]

  resources :password_resets, :only => [:new, :create, :edit, :update]

  resources :posts, :only => [:index, :show]

  authenticate :user do
    namespace :admin do
      root :to => 'admin#index'

      get 'reboot' => 'admin#reboot', :as => 'reboot'
      get 'export' => 'admin#export', :as => 'export'

      resources :pages do
        collection do
          get :edit_multiple
          put :update_multiple
          post :destroy_multiple
        end
      end

      resources :pictures do
        collection do
          get :selector
        end
      end

      resources :posts do
        collection do
          get :edit_multiple
          put :update_multiple
          post :destroy_multiple
        end
      end

      resources :users do
        collection do
          get :edit_multiple
          put :update_multiple
          post :destroy_multiple
        end
      end
    end

    post 'versions/:id/revert' => 'versions#revert', :as => 'revert_version'
  end

  #get 'password_resets/new'
  #
  #get 'login' => 'sessions#new', :as => 'login'
  #
  #get 'logout' => 'sessions#destroy', :as => 'logout'

  root :to => 'posts#index'
end
