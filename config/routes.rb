Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "error", to: "pages#error", as: :error

  resources :histories, only: %i[show create]
end
