module Telegram
  class MessageProcessor
    def initialize(bot, message)
      @bot     = bot
      @message = message
    end

    def call
      chat    = create_groups_chat
      text    = @message.text
      chat_id = @message.chat.id
      bot_name = "@#{ENV['BOT_NAME']}"

      if text =~ /#{bot_name}/
        command, attribute = text.gsub("#{bot_name}",'').split(' ')
        case command
        when 'help'
          @bot.api.sendMessage chat_id: chat_id,
                               text: "[assign_to_room, create_room, room_list, account_link, current_room, i_am]"
        when 'create_room'
          room = Room.find_or_create_by name: attribute
          @bot.api.sendMessage chat_id: chat_id,
                               text: "#{room.inspect}"
        when 'assign_to_room'
          room = Room.find_or_create_by name: attribute
          groups_chat = GroupsChat.find_or_create_by service: 'telegram',
                                                     service_id: chat_id

          groups_chat.update! room_id: room.id
          @bot.api.sendMessage chat_id: chat_id,
                               text: "#{groups_chat.inspect}"
        when 'room_list'
          @bot.api.sendMessage chat_id: chat_id,
                               text: Room.pluck(:name).to_json
        when 'current_room'
          groups_chat = GroupsChat.find_or_create_by service: 'telegram',
                                                     service_id: chat_id

          @bot.api.sendMessage chat_id: chat_id,
                               text: groups_chat.to_json
        when 'i_am'
          user = User.find_by(email: attribute)
          return unless user

          messenger = create_messenger
          messenger.update!(user_id: user.id)
          @bot.api.sendMessage chat_id: chat_id,
                               text: messenger.to_json
        end
      else
        create_message
      end
    end

    private

    def create_messenger
      Messenger.find_or_create_by service: 'telegram',
                                  service_id: @message.from.username
    end

    def create_message
      messenger = create_messenger
      groups_chat = create_groups_chat

      if groups_chat.room_id
        ::Message.create! sender_id: messenger.id,
                          room_id:   groups_chat.room_id,
                          body:      @message.text
      else
        bot_name = "@#{ENV['BOT_NAME']}"
        text = "First, type #{bot_name} room_list\nThen, type #{bot_name} assign_to_room ROOM_NAME"
        @bot.api.sendMessage chat_id: @message.chat.id,
                             text: text
      end
    end

    def create_groups_chat
      ::GroupsChat.find_or_create_by service:    'telegram',
                                     service_id: @message.chat.id
    end
  end
end
