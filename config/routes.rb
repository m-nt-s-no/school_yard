Rails.application.routes.draw do
  root "events#index"

  devise_for :users

  resources :groups
  resources :enrollments
  resources :events
  resources :messages

  #get ":name/events" => "users#events", as: :events
  #get ":name/groups" => "users#groups", as: :groups
  #get ":name/messages" => "users#messages", as: :messages
  #get ":name/calendar" => "users#calendar", as: :calendar
  #get "/directory" => "users#index", as: :directory
  get ":name" => "users#show", as: :user
end
