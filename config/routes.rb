Rails.application.routes.draw do
  # Routes for the Group resource:
  # CREATE
  post("/insert_group", { :controller => "groups", :action => "create" })
  # READ
  get("/groups", { :controller => "groups", :action => "index" })
  get("/groups/:path_id", { :controller => "groups", :action => "show" })
  # UPDATE
  post("/modify_group/:path_id", { :controller => "groups", :action => "update" })
  # DELETE
  get("/delete_group/:path_id", { :controller => "groups", :action => "destroy" })
  #------------------------------

  devise_for :users
  root "events#index"
  
end
