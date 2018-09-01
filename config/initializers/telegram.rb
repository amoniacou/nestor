SlackRubyBot::Client.logger.level = Logger::WARN

SlackRubyBot.configure do |config|
  config.logger = Logger.new(::Rails.root.join("log", "slack-telegram-bot.log").to_s, "daily")
end
