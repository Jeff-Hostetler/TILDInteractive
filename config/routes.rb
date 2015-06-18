Rails.application.routes.draw do
  resources :users, only: [:index, :create, :show] do
    resources :loans, only: [:index, :create, :show, :update]
  end
  resources :sessions, only:[:create, :destroy]
end
