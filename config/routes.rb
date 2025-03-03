Rails.application.routes.draw do
  resources :events
  resources :messages
  resources :enrollments
  resources :groups
  devise_for :users
  root "events#index"
  
end
