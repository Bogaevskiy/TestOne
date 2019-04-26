Rails.application.routes.draw do
  
  root 'posts#index', as: "home"

  resources :posts
  post 'posts/new' => 'posts#create'

  post 'posts/:id' => 'posts#grade'
  
  get '/idgrade' => 'posts#idgrade', as: 'idgrade'
  post '/idgrade' => 'posts#idgrade_value'

  get '/poststop' => 'posts#top', as: 'poststop'
  get '/groups' => 'posts#groups', as: 'groups'
 
end
