Rails.application.routes.draw do
  root "events#index"

  devise_for :users

  resources :groups
  resources :enrollments
  resources :events
  resources :messages
end
