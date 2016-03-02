Rails.application.routes.draw do
  # Static pages
  root 'welcome#home'
  get 'about' => 'welcome#about', :as => :about

  # Candidates and users' pages
  resources 'candidates' do 
    post 'candidates/:id' => 'candidates#save'
  end
  resources 'users', only: :show

  # Sessions and auth
  get '/login' => 'sessions#new', :as => :login
  get '/logout' => 'sessions#destroy'
  get '/auth/:provider/callback', :to => 'sessions#create', :as => :auth  
end