require 'eventmachine'
require 'telegram/bot'

namespace :daemon do
  desc 'Running telegram bot server'
  task :telegram => :environment do
    Telegram::Bot::Client.run(ENV['BOT_TOKEN']) do |bot|
      bot.listen do |message|
        processor = ::Telegram::MessageProcessor.new(bot, message)
        processor.call
      end
    end
  end
end
