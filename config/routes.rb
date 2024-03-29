Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'questions/new'

  root 'welcome#index'
  get '/index', to: 'welcome#index'
  get '/signup', to: 'users#new'
  get '/scoreboard', to: 'users#index'
  post '/signup',  to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: "sessions#destroy"
  get '/question', to: "questions#new"
  post '/question', to: "questions#create"
  get '/user_selections', to: "user_selections#new"
  post '/user_selections', to: "user_selections#create"
  get 'tags/:tag', to: "user_selections#new", as: :tag
  get '/user_selections/category', to: "user_selections#select_category"
  resources :users do
    member do
      get :deactivate
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
