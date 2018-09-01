module SlackBot
  class MessageProcessor

    def call(client, data)
      puts "call message processor"
      return if data['subtype'] == 'bot_message'
      return if message_to_self?(client, data)
      create_chat(client, data)
      case data["subtype"]
      when "group_join"
        client.say(channel: chat.service_id, text: "Nestor the chronicler is ready to record your exploits!")
      else
        #binding.pry
      end
    end

    private

    def message_to_self?(client, data)
      client.self && client.self.id == data.user
    end

    def create_chat(client, data)
      chat = ::GroupsChat.find_or_create_by(service: 'slack', service_id: data['channel'])
      client.say(channel: chat.service_id, text: "You have added a new group chat! Please create new Room or assign to exist Room") unless chat.room_id.present?
    end
  end
end