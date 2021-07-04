Rails.application.routes.draw do
  devise_for :providers
  devise_for :users
  get 'services/index'
  root to: "services#index"
end
