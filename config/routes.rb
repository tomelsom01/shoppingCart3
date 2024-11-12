Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :products
  resources :carts do
    post 'add_product', on: :member
  end
  post 'cart/:id/add_product', to: 'carts#add_product', as: 'add_to_cart'
end
