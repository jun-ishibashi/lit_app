Rails.application.routes.draw do
  devise_for :providers
  devise_for :users
  root to: "services#index"
  get 'services/search'
  resources :services, only: [:index, :new, :create, :show]
end
