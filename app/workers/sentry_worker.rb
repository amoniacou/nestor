class SentryWorker
  include ::Sidekiq::Worker

  def perform(event)
    ::Raven.send_event(event)
  end
end