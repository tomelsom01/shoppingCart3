Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :products
  resources :carts do
    member do
      post 'add_product', to: 'carts#add_product', as: 'add_product'
      post 'reduce_product', to: 'carts#reduce_product', as: 'reduce_product'
    end
  end
  resources :cart_items, only: [:destroy] do
    member do
      post 'update_quantity'
    end
  end
  resources :orders do
    post 'payment', on: :member
  end
  get '/guest_order/new', to: 'orders#new_guest', as: :new_guest_order
  post '/webhooks/stripe', to: 'webhooks#stripe'
  resources :payments, only: [:create, :index]

end
