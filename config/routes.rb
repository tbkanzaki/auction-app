Rails.application.routes.draw do
  devise_for :users 
  
  # resources :users do
  #   post :blocked, on: :member
  #   post :unblocked, on: :member
  # end

  resources :users, only: [] do
    post :blocked, on: :member
    post :unblocked, on: :member
  end

  #post 'blocked_cpfs/blocked', to: 'blocked_cpfs#blocked'

  root to: 'home#index'
  resources :categories, only: [:new, :create, :index, :edit, :update]
  resources :blocked_cpfs, only: [:index, :new, :create, :destroy]

  resources :products, only: [:index, :new, :create, :show, :edit, :update] 
  resources :lot_bids, only: [:index]

  resources :lots, only: [:index, :new, :create, :show] do
    post :approved, on: :member
    post :closed, on: :member
    post :cancelled, on: :member
    resources :lot_items, on: :member, only: [:new, :create, :destroy]
    resources :lot_bids, on: :member, only: [:new, :create, :index]
  end
end
