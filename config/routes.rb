Rails.application.routes.draw do
  # Static pages
  root 'welcome#home'
  get 'about' => 'welcome#about', :as => :about

  # Candidates and users' pages
  resources 'candidates', only: [:index, :show, :destroy]
  post 'save' => 'candidates#save', :as => :save
  resources 'users', only: :show

  # Sessions and auth
  get '/login' => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create', :as => :auth  
end