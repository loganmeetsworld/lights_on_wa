Rails.application.routes.draw do
  # Static pages and home page
  root 'candidates#index'
  get 'about' => 'welcome#about', :as => :about

  # SSL verification
  get "/.well-known/acme-challenge/#{ENV['LE_AUTH_REQUEST']}", to: 'candidates#letsencrypt'

  # JSON endpoints
  get 'candidates/:id/expenditures_data/' => 'candidates#expenditures_data', :as => :expenditures_data
  get 'candidates/contributions_data/' => 'candidates#contributions_data', :as => :contributions_data
  get 'data' => 'candidates#data'

  # Candidates and users' pages
  resources 'candidates', only: [:index, :show, :destroy]
  post 'candidates/:id' => 'candidates#save', :as => :save
  get 'candidates/:id/expenditures' => 'candidates#expenditures', :as => :expenditures
  resources 'users', only: :show

  # AJAX calls for graphics
  get 'line/:id' => 'candidates#line'
  get 'burst/:id' => 'candidates#burst'

  # Sessions and auth
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy'
  get 'auth/:provider/callback' => 'sessions#create', :as => :auth  
  post "/auth/developer/callback", to: "sessions#create"
end