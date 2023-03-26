Rails.application.routes.draw do
  root to: "pages#home"

  devise_for :users, controllers: { registrations: 'registrations' }
  get "error", to: "pages#error", as: :error

  resources :histories, only: %i[index show create]
  resources :monuments, only: %i[index show] do
    resources :favourites, only: %i[index create destroy]
  end

  get "dashboard", to: "users#dashboard", as: :dashboard
end
