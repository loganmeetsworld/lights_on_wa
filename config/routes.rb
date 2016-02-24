Rails.application.routes.draw do
  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/failure'

  get   '/login', :to => 'sessions#new', :as => :login
  get '/auth/:provider/callback', :to => 'sessions#create'

  root 'welcome#index'

  resources 'candidates'

  resources 'users', only: :show
end
