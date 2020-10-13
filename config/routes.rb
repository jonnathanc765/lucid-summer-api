Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Resources
  resources :users, only: [:index, :show, :create, :update]
  resources :categories, only: [:index, :create, :update, :destroy]
  resources :products, only: [:index, :show, :create, :update, :destroy]
  resources :cart_lines, only: [:create, :destroy]
  resources :addresses, only: [:index]


  # Custom routes
  get '/health', to: 'health#health'
  get "/cart", to: 'carts#show'
end
