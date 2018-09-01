module Telegram
  class MessageProcessor
    def initialize(bot, message)
      puts '::initialize'
      #puts bot.inspect
      #puts message.as_json

      user = create_user(message)
      chat = create_chat(message)
      create_message(message, user, chat)
    end

    private

    def create_message(message, user, chat)
      puts '::create_message'
      ::Message.create!(
        sender_id: user['id'],
        room_id: chat['id'],
        body: message['text']
      )
    end

    def create_user(message)
      puts '::create_user'
      ::User.find_or_create_by(
        email: message['from']['username']
      )
    end

    def create_chat(message)
      puts '::create_chat'
      ::GroupsChat.find_or_create_by(
        service: 'telegram',
        service_id: message['chat']['id']
      )
    end
  end
end
