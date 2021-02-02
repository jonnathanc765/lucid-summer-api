Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    sessions: 'sessions',
    token_validations: 'token_validations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Setting up for default host (blobs and path)
  default_url_options :host => ENV['DEFAULT_HOST']

  # ===  Custom routes  ===
  get '/me', to: 'users#me'
  get '/health', to: 'health#health'

  # Carts controller
  get "/cart", to: 'carts#show'
  
  # Products controller
  get "/related_products(/:category_id)", to: "products#related_products"
  post "/products/import", to: 'products#import'

  # Product images controller 
  post "/product_images/:product_id", to: 'product_images#create'
  delete "/product_images/:product_id/:id", to: 'product_images#destroy'

  # Checklist controller 
  post '/checklist/:id', to: 'checklist#check'

  # Orders controller 
  post '/orders/:id/update_status', to: 'orders#update_status'

  # Categories controller 
  get '/categories/limited/', to: 'categories#limited'

  # Resources
  resources :users, only: [:index, :show, :create, :update, :destroy]
  resources :categories, only: [:index, :create, :show, :update, :destroy], constraints: { id: /[0-9]+/ }
  resources :products, only: [:index, :show, :create, :update, :destroy]
  resources :cart_lines, only: [:create, :destroy, :update]
  resources :addresses, only: [:index, :create, :update, :destroy, :show]
  resources :orders, only: [:index, :create, :show]
  resources :reviews, only: [:create, :show, :index, :destroy]
  resources :roles, only: [:index]
  resources :available_dates, only: [:index]
  resources :payment_methods, only: [:create, :index]
  resources :coordinates, only: [:index, :show, :create, :update, :destroy]

end
