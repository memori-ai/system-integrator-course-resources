# Several course demos share the same Rails module name and all run on localhost
# (different ports). Browsers scope cookies by host, not port, so a shared cookie
# name lets one demo overwrite another's session and break CSRF checks.
Rails.application.config.session_store :cookie_store, key: "_sys04_demo_session"
