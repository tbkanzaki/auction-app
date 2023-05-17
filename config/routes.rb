Rails.application.routes.draw do
  devise_for :users 
  root to: 'home#index'

  resources :users, only: [] do
    post :blocked, on: :member
    post :unblocked, on: :member
  end

  resources :lot_doubts, only: [] do
    post :blocked, on: :member
    post :unblocked, on: :member
    resources :lot_doubt_answers, on: :member, only: [:new, :create]
  end

  resources :lot_doubt_answers, only: [:index]

  resources :categories, only: [:new, :create, :index, :edit, :update]
  resources :blocked_cpfs, only: [:index, :new, :create, :destroy]
  resources :products, only: [:index, :new, :create, :show, :edit, :update] 
  resources :lot_bids, only: [:index]

  resources :lots, only: [:index, :new, :create, :show] do
    post :approved, on: :member
    post :closed, on: :member
    post :cancelled, on: :member
    resources :lot_items, on: :member , only: [:new, :create, :destroy]
    resources :lot_bids, on: :member, only: [:new, :create, :index]
    resources :lot_doubts, on: :member, only: [:new, :create]
  end
end
