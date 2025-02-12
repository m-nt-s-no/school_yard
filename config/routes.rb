Rails.application.routes.draw do
  root "events#index"

  devise_for :users

  resources :groups
  resources :enrollments
  resources :events
  resources :messages

  #get ":username/events" => "users#events", as: :events
  #get ":username/groups" => "users#groups", as: :groups
  #get ":username/messages" => "users#messages", as: :messages
  #get ":username/calendar" => "users#calendar", as: :calendar
  #get "/directory" => "users#index", as: :directory
  get ":name" => "users#show", as: :user
end
