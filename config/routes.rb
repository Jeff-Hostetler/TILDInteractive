Rails.application.routes.draw do
  resources :users, only: [:index, :create, :show]
  resources :sessions, only:[:create, :destroy]
end
