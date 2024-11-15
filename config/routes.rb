Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :products
  resources :carts do
    member do
      post 'add_product', to: 'carts#add_product'
      post 'reduce_product', to: 'carts#reduce_product'
    end
  end
  resources :cart_items, only: [:destroy]
  post 'cart/:id/add_product', to: 'carts#add_product', as: 'add_to_cart'
  resources :cart_items, only: [:destroy]
  resources :orders, only: [:new, :create]
end
