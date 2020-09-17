Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Resources 
  resources :users, only: [:index, :show, :create, :update]


  # Custom routes 
  get '/health', to: 'health#health'
end
