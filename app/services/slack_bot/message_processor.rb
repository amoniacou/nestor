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
        collect_users(client, data)
      else
        binding.pry
      end
    end

    private

    def message_to_self?(client, data)
      client.self && client.self.id == data.user
    end

    def create_chat(client, data)
      begin
        client.web_client.conversations_info channel: data.channel
        return
      rescue Slack::Web::Api::Errors::SlackError
      end
      chat = ::GroupsChat.find_or_create_by(service: 'slack', service_id: data['channel'])
      client.say(channel: chat.service_id, text: "You have added a new group chat! Please create new Room or assign to exist Room") unless chat.room_id.present?
    end

    def collect_users(client, data)
      users = client.web_client.channels_info(channel: data.channel).channel.members
      users.each do |user_id|
        user_info = client.web_client.users_info(user: user_id)
        next if user_info.user.is_bot
        user_messenger = ::Messenger.find_or_initialize_by(service: 'slack', service_id: user_id)
        user_messenger.data = user_info&.user || {}
        user_messenger.save!
        open_direct_message(client, user_messenger, user_info) if user_messenger.user_id.nil?
      end
    end

    def open_direct_message(client, user_messenger, user_info)
      email = user_messenger.data['profile']['email']
      user = ::User.find_by(email: email)
      if user
        user_messenger.user_id = user.id
        user_messenger.save!
      else
        chat = client.web_client.im_open user: user_info.user.id
        client.say channel: chat.channel.id, text: "I don't have your account link yet. Can you provide your account email?"
        client.say channel: chat.channel.id, text: "You can use next command:"
        client.say channel: chat.channel.id, text: "*@#{client.self.name}* account link EMAIL"
      end
    end

    def check_users
    end
  end
end