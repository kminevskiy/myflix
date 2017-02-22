Myflix::Application.routes.draw do
  get '/ui/:action', controller: 'ui'

  root to: "users#front"

  get "/my_queue", to: "queue_items#index"
  resources "queue_items", only: [:create, :destroy]

  get "/register", to: "users#new"
  resources :users, only: [:front, :create, :show]

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/home", to: "videos#index"
  resources :videos, only: [:show, :index] do
    collection do
      get :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:index, :show]
end
