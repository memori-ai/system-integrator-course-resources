conf = { url: ENV['REDIS_URL'] }
conf.merge!(password: ENV['REDIS_PASSWORD']) unless ENV['REDIS_PASSWORD'].blank?

Sidekiq.configure_server do |config|
  config.redis = conf
end

Sidekiq.configure_client do |config|
  config.redis = conf
end

Sidekiq.strict_args!

