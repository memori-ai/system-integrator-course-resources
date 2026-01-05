Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Main routes
  root "home#index"
  post "home/configure", to: "home#configure", as: :configure_agent
end

