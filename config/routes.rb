Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#index'
  resources :products
  get 'shops', to: 'shops#new'
  post 'add_cart', to: 'shops#create'
end
