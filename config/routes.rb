Rails.application.routes.draw do
  devise_for :providers
  devise_for :users
  root to: "services#index"
  get 'services/search'
  post 'services/search'

  resources :services do
    collection do
      match 'search' => 'services#search', via: [:get, :post]
    end
  end

  resources :users, only: :show
  resources :providers, only: :show

end
