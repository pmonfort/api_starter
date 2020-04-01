Rails.application.routes.draw do
  resources :companies, only: %i[create update show]
  resources :products
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
