Rails.application.routes.draw do
  root "users#events"

  devise_for :users

  resources :groups, except: [:index] do
    resources :enrollments, only: [:create, :destroy]
  end
  resources :events, except: [:index]
  resources :messages, only: [:show, :new, :create]

  get("/rake_tasks", { :controller => "rake_tasks", :action => "show" })
  get("/run_task", { :controller => "rake_tasks", :action => "run_task" })

  get "/directory" => "users#index", as: :directory
  get ":slug/events" => "users#events", as: :my_events
  get ":slug/groups" => "users#groups", as: :my_groups
  get ":slug/messages" => "users#messages", as: :my_messages
  get ":slug/calendar" => "users#calendar", as: :my_calendar
  get ":slug" => "users#show", as: :user
end
