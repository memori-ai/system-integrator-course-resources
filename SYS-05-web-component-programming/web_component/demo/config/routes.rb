Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Main routes - Demo selection
  root "home#index"

  # Demo 1
  get "demo1", to: "demo1#index", as: :demo1
  post "demo1/configure", to: "demo1#configure", as: :demo1_configure
  get "demo1/download-prompt", to: "demo1#download_prompt", as: :download_prompt_demo1
end
