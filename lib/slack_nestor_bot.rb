class SlackNestorBot < SlackRubyBot::Bot
  help do
    title 'Nestor the Chronicler'
    desc 'This bot store the chat history'

    command 'assign to room <room>' do
      desc 'Asign to exist Room'
    end

    command 'create room <room>' do
      desc 'Create new Room and assign that chat'
    end

    command 'account link <email>' do
      desc 'Link chat account to yout system account'
    end
  end

  command 'assign to room' do |client, data, match|
    room_name = match[:expression]
    if (room = ::Room.find_by(name: room_name))
      chat = ::GroupsChat.find_or_create_by(service: 'slack', service_id: data.channel)
      chat.room_id = room.id
      chat.save!
      client.say channel: data.channel, text: "Room Assigned"
    else
      client.say channel: data.channel, text: "Unknown Room"
    end
  end

  command 'create room' do |client, data, match|
    room_name = match[:expression]
    chat = ::GroupsChat.find_or_create_by(service: 'slack', service_id: data.channel)
    unless (room = ::Room.find_by(name: room_name))
      room = ::Room.create!(name: room_name)
    client.say channel: data.channel, text: "Room Created"
    end
    chat.room_id = room.id
    chat.save!
    client.say channel: data.channel, text: "Room Assigned"
  end

  command 'account link' do |client, data, match|
    user_info = client.web_client.users_info(user: data.user)
    return if user_info.user.is_bot
    user = ::User.find_by(email: match[:expression][8..-2].split('|').first)
    if user
      user_messenger = ::Messenger.find_or_initialize_by(service: 'slack', service_id: data.user)
      user_messenger.data = user_info&.user || {}
      user_messenger.user_id = user.id
      user_messenger.save!
      client.say channel: data.channel, text: "Account assigned"
    else
      client.say channel: data.channel, text: "Email not found"
    end
  end
end