Rails.application.routes.draw do
  devise_for :providers
  devise_for :users
  root to: "services#index"

  resources :services, only: %i[index show new create edit update destroy] do
    get :search, on: :collection
  end

  resources :users, only: :show
  resources :quote_requests, only: %i[index show new create]
  get "contact", to: "inquiries#new", as: :contact
  post "contact", to: "inquiries#create"
  get "mypage/provider", to: "providers#mypage", as: :mypage_provider
  get "for-providers", to: "providers#entry", as: :for_providers
  resources :providers, only: :show
end
