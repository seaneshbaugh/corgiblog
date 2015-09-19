Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :passwords, :registrations, :confirmations, :unlocks]

  devise_scope :user do
    get 'login' => 'devise/sessions#new', as: :new_user_session
    post 'login' => 'devise/sessions#create', as: :user_session
    delete 'logout' => 'devise/sessions#destroy', as: :destroy_user_session

    post 'update-password' => 'devise/passwords#create', as: :user_password
    get 'reset-password' => 'devise/passwords#new', as: :new_user_password
    get 'update-password' => 'devise/passwords#edit', as: :edit_user_password
    put 'update-password' => 'devise/passwords#update'
  end

  get '/contact' => 'contact#new', as: :contact

  post '/contact' => 'contact#create'

  resources :pictures, only: [:index, :show]

  resources :posts, only: [:show]

  get '/posts.rss' => 'posts#index', defaults: { format: :rss }

  get '/sitemap.xml' => 'sitemap#index', as: :sitemap, defaults: { format: :xml }

  authenticate :user do
    namespace :admin do
      root to: 'admin#index'

      resource :account, only: [:show, :edit, :update]

      resources :pages

      resources :pictures do
        collection do
          get :selector
        end
      end

      resources :posts

      resources :users

      get '/tags.json' => 'tags#index'

      delete '/versions/:id/destroy' => 'versions#destroy', as: :destroy_version

      post '/versions/:id/revert' => 'versions#revert', as: :revert_version
    end
  end

  root to: 'posts#index'

  get ':id' => 'pages#show'
end
