Rails.application.routes.draw do
  root to: 'pokemon#index'

  get '/search' => 'pokemon#search'
end
