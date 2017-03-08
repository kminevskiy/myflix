Myflix::Application.routes.draw do
  get '/ui/:action', controller: 'ui'

  root "users#front"

  get "/my_queue", to: "queue_items#index"
  post "/update_queue", to: "queue_items#update_queue"
  resources "queue_items", only: [:create, :destroy]

  get "/people", to: "relationships#index"
  resources :relationships, only: [:create, :destroy]

  get "/reset", to: "forgot_passwords#new"
  get "/reset/:token", to: "forgot_passwords#edit", as: :edit_password
  get "/reset_process", to: "forgot_passwords#show"
  resources :forgot_passwords, only: [:create, :update]

  get "/invite", to: "invites#new"
  post "/invite", to: "invites#create"
  get "/invite_confirmation", to: "invites#show"

  get "/register_ref/:token", to: "friends#new", as: :friend_arrived

  get "/register", to: "users#new"
  resources :users, only: [:front, :create, :show]

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/home", to: "videos#index"
  resources :videos, only: [:show, :index] do
    collection do
      get "search", to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:index, :show]
end
