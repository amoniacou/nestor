module SlackBot
  class MessageProcessor

    def call(client, data)
      puts "call message processor"
      binding.pry
      return if data['subtype'] == 'bot_message'
      return if message_to_self?(client, data)
      create_chat(client, data)
      case data["subtype"]
      when "group_join", "channel_join"
        collect_users
      else
        binding.pry
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

    def collect_users(client)
      users = client.web_client.channels_info(channel: data.channel).channel.members
      users.each do |user_id|
        user_info = client.web_client.users_info(user: user_id)
        user_messenger = ::Messenger.first_or_initialize_by(service: 'slack', service_id: user_id)
        user_messenger.data = user_info&.user || {}
        user_messenger.save!
        open_direct_message(client, user_id) if user_messenger.user_id.nil?
      end
    end

    def open_direct_message(client, user_id)
    end

    def check_users
    end
  end
end