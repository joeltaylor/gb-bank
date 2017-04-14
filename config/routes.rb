Rails.application.routes.draw do
  root to: "home#index"

  # HomeController
  resources :home, only: :index
end
