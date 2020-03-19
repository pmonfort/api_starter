Rails.application.routes.draw do
  resources :companies, only: %i[create update show]
  resources :users, only: %i[create update delete show index]
  resources :products, only: %i[create update delete show index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
