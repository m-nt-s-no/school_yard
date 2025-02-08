Rails.application.routes.draw do
  resources :enrollments
  resources :groups
  devise_for :users
  root "events#index"
  
end
