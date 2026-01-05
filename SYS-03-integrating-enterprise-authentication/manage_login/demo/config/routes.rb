Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Main routes - Demo selection
  root "home#index"
  
  # Demo 1: Web Component with showLogin (self-managed auth)
  get "demo1", to: "demo1#index", as: :demo1
  post "demo1/configure", to: "demo1#configure", as: :demo1_configure
  
  # Demo 2: Programmatic auth with Trusted App + LoginWithJWT
  get "demo2", to: "demo2#index", as: :demo2
  get "demo2/login", to: "demo2#login", as: :demo2_login
  post "demo2/authenticate", to: "demo2#authenticate", as: :demo2_authenticate
  post "demo2/configure", to: "demo2#configure", as: :demo2_configure
  delete "demo2/logout", to: "demo2#logout", as: :demo2_logout
  
  # Demo 3: Microsoft Authentication + AIsuru
  get "demo3", to: "demo3#index", as: :demo3
  post "demo3/configure", to: "demo3#configure", as: :demo3_configure
  post "demo3/ms_callback", to: "demo3#ms_callback", as: :demo3_ms_callback
  delete "demo3/logout", to: "demo3#logout", as: :demo3_logout
end

