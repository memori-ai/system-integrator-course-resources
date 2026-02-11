Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Main routes - Demo selection
  root "home#index"

  # Demo 1: MongoDB via MCP Server
  get "demo1", to: "demo1#index", as: :demo1
  post "demo1/configure", to: "demo1#configure", as: :demo1_configure
  get "demo1/db_status", to: "demo1#db_status", as: :demo1_db_status

  # Demo 2: MySQL via MCP Server
  get "demo2", to: "demo2#index", as: :demo2
  post "demo2/configure", to: "demo2#configure", as: :demo2_configure
  get "demo2/db_status", to: "demo2#db_status", as: :demo2_db_status

  # Demo 3: Filesystem MCP Server
  get "demo3", to: "demo3#index", as: :demo3
  post "demo3/configure", to: "demo3#configure", as: :demo3_configure
  get "demo3/workspace_files", to: "demo3#workspace_files", as: :demo3_workspace_files
end

