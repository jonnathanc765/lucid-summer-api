Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    sessions: 'sessions',
    token_validations: 'token_validations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Setting up for default host (blobs and path)
  default_url_options :host => ENV['DEFAULT_HOST']

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
  resources :coordinates, only: [:index, :create, :update, :destroy]


  # Custom routes
  get '/me', to: 'users#me'
  get '/health', to: 'health#health'
  get "/cart", to: 'carts#show'
  
  get "/related_products(/:category_id)", to: "products#related_products"
  post "/product_images/:product_id", to: 'product_images#create'
  delete "/product_images/:product_id/:id", to: 'product_images#destroy'

  post '/checklist/:id', to: 'checklist#check'
  post '/orders/:id/update_status', to: 'orders#update_status'

  get '/categories/limited/', to: 'categories#limited'


end
