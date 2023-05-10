Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :categories, only: [:new, :create, :index, :edit, :update]
  resources :products, only: [:index, :new, :create, :show, :edit, :update] 

  resources :lots, only: [:index, :new, :create, :show] do
    resources :lot_items, only: [:new, :create, :destroy] do
    end
  end

end
