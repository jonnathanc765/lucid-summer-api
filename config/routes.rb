Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Resources
  resources :users, only: [:index, :show, :create, :update]
  resources :categories, only: [:index, :create, :show, :update, :destroy]
  resources :products, only: [:index, :show, :create, :update, :destroy]
  resources :cart_lines, only: [:create, :destroy]
  resources :addresses, only: [:index, :create, :update, :destroy, :show]
  resources :orders, only: [:index, :create, :show]
  resources :reviews, only: [:create, :show]


  # Custom routes
  get '/me', to: 'users#me'
  get '/health', to: 'health#health'
  get "/cart", to: 'carts#show'

  post "/product_images/:id", to: 'product_images#create'

  post '/checklist/:id', to: 'checklist#check'
  post '/orders/:id/update_status', to: 'orders#update_status'
end
