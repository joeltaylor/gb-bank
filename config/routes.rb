Rails.application.routes.draw do
  root to: "home#index"

  resources :home, only: :index
  resources :members, only: [:index, :edit, :update, :create, :new]
  resources :transactions, only: [:new, :create]

  namespace :api  do
    namespace :v1 do
      resources :members, only: [:index, :create, :update]
      resources :transactions, only: [:create]
    end
  end
end
