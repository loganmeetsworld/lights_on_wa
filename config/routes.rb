Rails.application.routes.draw do
  # Static pages
  root 'candidates#index'
  get 'about' => 'welcome#about', :as => :about

  # Candidates and users' pages
  resources 'candidates', only: [:index, :show, :destroy]
  post '/candidates/:id' => 'candidates#save', :as => :save
  resources 'users', only: :show

  get '/line/:id' => 'candidates#line'
  get '/burst/:id' => 'candidates#burst'

  # Sessions and auth
  get '/login' => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create', :as => :auth  
end