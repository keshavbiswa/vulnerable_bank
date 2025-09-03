Rails.application.routes.draw do
  root "users#index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/register", to: "users#new"
  post "/register", to: "users#create"

  resources :users do
    member do
      get :profile
      patch :update_profile
      get :admin_panel
    end
  end


  namespace :admin do
    resources :users
    get "dashboard", to: "dashboard#index"
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: [ :show, :update ]
      resources :transactions, only: [ :create ]
      post :transfer, to: "transfer#create"
    end
  end

  get "/search", to: "search#index"
  post "/upload_avatar", to: "avatars#create"
  get "/forgot_password", to: "password_reset#new"
  post "/forgot_password", to: "password_reset#create"
  get "/reset_password/:token", to: "password_reset#edit"
  patch "/reset_password/:token", to: "password_reset#update"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
