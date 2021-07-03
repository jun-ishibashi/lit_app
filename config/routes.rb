Rails.application.routes.draw do
  get 'products/index'
  root to: "products#index"
end
