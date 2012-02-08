Corgiblog::Application.routes.draw do
  get "password_resets/new"

  get "login" => "sessions#new", :as => "login"

  get "logout" => "sessions#destroy", :as => "logout"

  post "versions/:id/revert" => "versions#revert", :as => "revert_version"

  resources :pages, :only => [:index, :show]

  resources :password_resets, :only => [:new, :create, :edit, :update]

  resources :posts, :only => [:index, :show]

  resources :sessions, :only => [:new, :create, :destroy]

  namespace :admin do
    root :to => "admin#index"

    get "reboot" => "admin#reboot", :as => "reboot"

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

  root :to => "posts#index"
end
