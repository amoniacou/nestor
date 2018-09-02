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

      if text =~ /@AmoniacHistoryBot/
        command, attribute = text.gsub('@AmoniacHistoryBot ','').split(' ')
        case command
        when 'help'
          @bot.api.sendMessage chat_id: chat_id,
                               text: "[assign_to_room, create_room, account_link]"
        when 'create_room'
          room = Room.find_or_create_by name: attribute
          #user_id = @message.from.id
          @bot.api.sendMessage chat_id: chat_id,
                               text: "#{room.inspect}"
        when 'assign_to_room'
          room = Room.find_or_create_by name: attribute
          #user_id = @message.from.id
          groups_chat = GroupsChat.find_or_create_by service: 'telegram',
                                                     service_id: chat_id

          groups_chat.update! room_id: room.id
          @bot.api.sendMessage chat_id: chat_id,
                               text: "#{groups_chat.inspect}"
        when 'room_list'
          #user_id = @message.from.id
          @bot.api.sendMessage chat_id: chat_id,
                               text: Room.all.to_json
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
      #user = User.find(messenger.user_id)
      user = User.first
      groups_chat = create_groups_chat
      groups_chat.room_id = 1

      ::Message.create! sender_id: user.id,
                        room_id:   groups_chat.room_id,
                        body:      @message.text
    end

    def create_groups_chat
      ::GroupsChat.find_or_create_by service:    'telegram',
                                     service_id: @message.chat.id
    end
  end
end
