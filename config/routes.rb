Rails.application.routes.draw do
  # Static pages
  root 'candidates#index'
  get 'about' => 'welcome#about', :as => :about

  get "/.well-known/acme-challenge/#{ENV['LE_AUTH_REQUEST']}", to: 'candidates#letsencrypt'

  # json endpoints
  get 'candidates/contributions_data/' => 'candidates#contributions_data', :as => :contributions_data
  get 'data' => 'candidates#data'

  # Candidates and users' pages
  resources 'candidates', only: [:index, :show, :destroy]
  post 'candidates/:id' => 'candidates#save', :as => :save
  resources 'users', only: :show

  get 'cash/:id' => 'candidates#cash'
  get 'inkind/:id' => 'candidates#inkind'
  get 'expenditures/:id' => 'candidates#expenditures'

  get 'line/:id' => 'candidates#line'
  get 'burst/:id' => 'candidates#burst'

  # Sessions and auth
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy'
  get 'auth/:provider/callback' => 'sessions#create', :as => :auth  
  post "/auth/developer/callback", to: "sessions#create"
end