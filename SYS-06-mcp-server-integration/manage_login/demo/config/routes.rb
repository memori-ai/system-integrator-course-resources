Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Main routes - Demo selection
  root "home#index"

  # Demo 1
  get "demo1", to: "demo1#index", as: :demo1

  # Demo 2
  get "demo2", to: "demo2#index", as: :demo2

  # Demo 3
  get "demo3", to: "demo3#index", as: :demo3
  post "demo3/configure", to: "demo3#configure", as: :demo3_configure
  get "demo3/workspace_files", to: "demo3#workspace_files", as: :demo3_workspace_files

  # Demo 4
  get "demo4", to: "demo4#index", as: :demo4

  # Demo 5
  get "demo5", to: "demo5#index", as: :demo5

  # Demo 6
  get "demo6", to: "demo6#index", as: :demo6
end
