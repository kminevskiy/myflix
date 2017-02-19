Myflix::Application.routes.draw do
  get '/ui/:action', controller: 'ui'

  root to: "users#front"

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
  end
end
