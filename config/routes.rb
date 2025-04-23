Rails.application.routes.draw do
  devise_for :users

  unauthenticated do
    root "page#landing", as: :unauthenticated_root
  end

  authenticated :user do
    root "users#events", as: :authenticated_root
  end

  resources :groups, except: [:index] do
    resources :enrollments, only: [:create, :destroy]
  end
  get("/events/check_conflicts", { :controller => "events", :action => "check_conflicts" })
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
  post("/:slug", { :controller => "users", :action => "update" })

end
