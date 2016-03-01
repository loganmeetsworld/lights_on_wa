Rails.application.routes.draw do
  root 'candidates#index'
  get 'about', :to => "welcome#about", :as => :about
  get 'sessions/new'
  get 'sessions/create'

  get  '/login', :to => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy'
  get '/auth/:provider/callback', :to => 'sessions#create', :as => :auth

  # post '/search', :controller => 'welcome', :action => "search"
  
  resources 'candidates'

  post 'candidates/:id' => 'candidates#save'

  resources 'users', only: :show
end