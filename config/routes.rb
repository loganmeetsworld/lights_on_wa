Rails.application.routes.draw do
  root 'candidates#index'
  get 'about' => 'welcome#about', :as => :about

  get '/login' => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy'
  get '/auth/:provider/callback', :to => 'sessions#create', :as => :auth
  resources 'users', only: :show
  
  resources 'candidates'
  post 'candidates/:id' => 'candidates#save'
end