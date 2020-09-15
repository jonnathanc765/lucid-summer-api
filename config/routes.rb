Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Resources 
  resources :users, only: [:index, :show]


  # Custom routes 
  get '/health', to: 'health#health'
end
