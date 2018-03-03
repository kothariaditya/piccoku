Rails.application.routes.draw do
  get 'images/index'

  root 'images#index'

  post '/images/create', to: 'images#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
