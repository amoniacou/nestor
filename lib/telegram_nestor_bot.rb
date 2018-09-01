require 'telegram/bot'

class TelegramNestorBot
  token = '637987716:AAF-hED9peS7qOUC-PT318PD3U1m7V3PxCw'

  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
      Message.create!(body: message.to_json)
    end
  end
end
