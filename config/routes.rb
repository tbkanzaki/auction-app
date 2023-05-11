Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :categories, only: [:new, :create, :index, :edit, :update]
  resources :products, only: [:index, :new, :create, :show, :edit, :update] 

  resources :lots, only: [:index, :new, :create, :show] do
    post :approved, on: :member
    post :closed, on: :member
    post :cancelled, on: :member
    resources :lot_items, on: :member, only: [:new, :create, :destroy]
  end
end
