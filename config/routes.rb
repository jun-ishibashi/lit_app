Rails.application.routes.draw do
  devise_for :providers
  devise_for :users
  root to: "services#index"
  resources :services, only: [:index, :new, :create]
end
