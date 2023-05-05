Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :categories, only: [:new, :create, :index, :edit, :update]

end
