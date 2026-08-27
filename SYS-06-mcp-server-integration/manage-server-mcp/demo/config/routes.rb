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

  # Demo 4: MCP Scheduler + MCP Persistence. No configure action and no
  # embedded web component: see Demo4Controller for why (same reasoning as
  # Demo 7).
  get "demo4", to: "demo4#index", as: :demo4

  # Demo 5: an AIsuru agent exposed as an MCP server, consumed by a second agent
  get "demo5", to: "demo5#index", as: :demo5
  post "demo5/configure", to: "demo5#configure", as: :demo5_configure

  # Downloads the ready-made system prompt of one of the two demo agents.
  # Course attendees do not have this repository, so the prompts have to be
  # reachable from the page itself.
  get "demo5/prompt/:agent", to: "demo5#prompt", as: :demo5_prompt,
      constraints: { agent: /expert|assistant/ }

  # Demo 6: an external REST API (fake ERP) connected through the OAuth/API
  # connector. The page reads the same API to show live data.
  get "demo6", to: "demo6#index", as: :demo6
  post "demo6/configure", to: "demo6#configure", as: :demo6_configure
  get "demo6/commesse", to: "demo6#commesse", as: :demo6_commesse
  post "demo6/reset", to: "demo6#reset", as: :demo6_reset

  # Demo 7: Outlook + Vibe Coder + Persistence on one agent. The agent reads a
  # project request from the mailbox and builds the application it describes.
  # No configure action and no embedded web component: the Outlook MCP Server
  # enables IDENTITY_STRICT_MAILBOX by default, so the mailbox only answers the
  # AIsuru account that owns the agent. The run-through happens inside AIsuru.
  get "demo7", to: "demo7#index", as: :demo7

  # Downloads the agent system prompt and the demo request email as plain text.
  # Course attendees do not have this repository, so both have to be reachable
  # from the page itself.
  get "demo7/asset/:kind", to: "demo7#asset", as: :demo7_asset,
      constraints: { kind: /prompt|email/ }

  # One-click demo infrastructure (starts/stops the ngrok tunnel containers)
  post "infra/:demo/start", to: "infra#start", as: :infra_start, constraints: { demo: /demo[1236]/ }
  get "infra/:demo/status", to: "infra#status", as: :infra_status, constraints: { demo: /demo[1236]/ }
  post "infra/stop_all", to: "infra#stop_all", as: :infra_stop_all
  get "infra/token", to: "infra#token_status", as: :infra_token_status
  post "infra/token", to: "infra#save_token", as: :infra_save_token
end

