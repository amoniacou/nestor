Raven.configure do |config|
  config.environments = %w[ production ]
  config.excluded_exceptions += ['ActionController::RoutingError', 'ActiveRecord::RecordNotFound']
  if defined?(::Sidekiq)
    config.async = lambda { |event|
      ::SentryWorker.perform_async(event.to_hash)
    }
  end
  config.tags = {
    server_env: ENV['SENTRY_ENV'] == 'production' ? 'PROD' : 'STAGING'
  }
  config.sanitize_fields = ::Rails.application.config.filter_parameters.map(&:to_s)
  config.release = ENV['GIT_REV'] if ENV['GIT_REV'].present?
end