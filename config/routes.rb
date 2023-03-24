Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "error", to: "pages#error", as: :error

  resources :histories, only: %i[index show create]
  resources :monuments, only: %i[index show]
  get "dashboard", to: "users#dashboard", as: :dashboard
end
