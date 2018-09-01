require 'eventmachine'
require 'telegram/bot'

namespace :daemon do
  desc 'Running telegram bot server'
  task :telegram => :environment do
    token = '637987716:AAF-hED9peS7qOUC-PT318PD3U1m7V3PxCw'

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        ::Telegram::MessageProcessor.new(bot, message)
      end
    end
  end
end
