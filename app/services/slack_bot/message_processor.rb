module SlackBot
  class MessageProcessor

    def call(client, data)
      puts "call message processor"
      return if data['subtype'] == 'bot_message'
      return if message_to_self?(client, data)
      return if private_channel?(client, data)
      chat = create_chat(client, data)
      case data["subtype"]
      when "group_join", "channel_join"
        collect_users(client, data)
      else
        user = collect_user(client, data.user)
        ::Message.create!(sender_id: user.id, room_id: chat.id, body: data.text, created_at: ::Time.at(data.ts.to_f))
      end
    end

    private

    def message_to_self?(client, data)
      client.self && client.self.id == data.user
    end

    def private_channel?(client, data)
      r = client.web_client.conversations_info channel: data.channel
      r.channel.is_private
    rescue Slack::Web::Api::Errors::SlackError
      false
    end

    def create_chat(client, data)
      chat = ::GroupsChat.find_or_create_by(service: 'slack', service_id: data['channel'])
      client.say(channel: chat.service_id, text: "You have added a new group chat! Please create new Room or assign to exist Room") unless chat.room_id.present?
      chat
    end

    def collect_users(client, data)
      users = client.web_client.channels_info(channel: data.channel).channel.members
      users.each do |user_id|
        user_messenger = collect_user(client, user_id)
        next unless user_messenger
        open_direct_message(client, user_messenger) if user_messenger.user_id.nil?
      end
    end

    def collect_user(client, user_id)
      user_info = client.web_client.users_info(user: user_id)
      return if user_info.user.is_bot
      user_messenger = ::Messenger.find_or_initialize_by(service: 'slack', service_id: user_id)
      user_messenger.data = user_info&.user || {}
      user_messenger.save!
      user_messenger
    end

    def open_direct_message(client, user_messenger)
      email = user_messenger.data['profile']['email']
      user = ::User.find_by(email: email)
      if user
        user_messenger.user_id = user.id
        user_messenger.save!
      else
        chat = client.web_client.im_open user: user_messenger.service_id
        client.say channel: chat.channel.id, text: "I don't have your account link yet. Can you provide your account email?"
        client.say channel: chat.channel.id, text: "You can use next command:"
        client.say channel: chat.channel.id, text: "*@#{client.self.name}* account link EMAIL"
      end
    end
  end
end