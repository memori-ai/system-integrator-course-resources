Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Main routes - Demo selection
  root "home#index"

  # Demo 1
  get "demo1", to: "demo1#index", as: :demo1
  post "demo1/configure", to: "demo1#configure", as: :demo1_configure

  # Demo 2
  get "demo2", to: "demo2#index", as: :demo2
  post "demo2/configure", to: "demo2#configure", as: :demo2_configure
  get "demo2/download-swagger", to: "demo2#download_swagger", as: :download_swagger_demo2

end
