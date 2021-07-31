Rails.application.routes.draw do
  devise_for :providers
  devise_for :users
  root to: "services#index"
  get 'services/search'

  resources :services

  resources :users, only: :show
  resources :providers, only: :show

end
