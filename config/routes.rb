Rails.application.routes.draw do
  root to: "home#index"

  # HomeController
  resources :home, only: :index
  resources :members, only: [:index, :edit, :update, :create, :new]
end
