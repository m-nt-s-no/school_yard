Rails.application.routes.draw do
  root "events#index"

  devise_for :users

  resources :groups
  resources :enrollments
  resources :events
  resources :messages

  get "/directory" => "users#index"#, as: :directory
  get ":name/events" => "users#events"#, as: :my_events
  get ":name/groups" => "users#groups"#, as: :my_groups
  get ":name/messages" => "users#messages"#, as: :my_messages
  get ":name/calendar" => "users#calendar"#, as: :my_calendar
  get ":name" => "users#show", as: :user
end
