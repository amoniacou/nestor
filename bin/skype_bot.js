const SkywebCl = require('skyweb');
const Sequelize = require('sequelize');
const skyweb = new SkywebCl.default();
let errorCount = 0;
const appURL = process.env.APP_HOST || 'http://localhost:3000';
const appCatchURL = appURL + '/bots/skype'
const errorListener = (eventName, error) => {
  console.log(`${errorCount} : Error occured : ${error}`);
  errorCount++;
  if (errorCount === 10) {
    console.log(`Removing error listener`);
    skyweb.un('error', errorListener); // Removing error listener
  }
};
let botName;
skyweb.login(process.env.SKYPE_LOGIN, process.env.SKYPE_PASSWORD).then(function (account) {
  botName = skyweb.skypeAccount.selfInfo.username;
}).catch(function (reason) {
  console.log(reason);
});
const sequelize = new Sequelize(process.env.DATABASE_URL, {
  native: true
})

const Room = sequelize.define('room', {
  underscored: true
});

const GroupsChat = sequelize.define('groups_chat', {
  underscored: true
})

const Message = sequelize.define('message', {
  underscored: true
});

const User = sequelize.define('user', {
  underscored: true
});

const Messenger = sequelize.define('messenger', {
  underscored: true
});

const createChat = (channelId) => {
  Room.findOrCreate({
    where: {
      service: 'skype',
      service_id: channelId
    }
  }).
  spread((room, created) => {
    if (!room.room_id) {
      skyweb.sendMessage(channelId, "You have added a new group chat! Please create new Room or assign to exist Room")
    }
  })
}

skyweb.messagesCallback = function (messages) {
  messages.forEach(function (message) {
    const messageType = message.resource.messagetype;
    const conversationLink = message.resource.conversationLink;
    const conversationId = conversationLink.substring(conversationLink.lastIndexOf('/') + 1);
    switch (messageType) {
      case "ThreadActivity/DeleteMember":
      case "Control/Typing":
        break;
      case "ThreadActivity/AddMember":
        console.log("Add new member");
        let userId = message.resource.content.match(/<target>(.*)<\/target>/)[1]
        if (!userId) {
          break;
        }
        userId = userId.substring(userId.indexOf(':') + 1)
        if (userId === botName) {
          skyweb.sendMessage(conversationId, 'Thanks for join!');
        }
        console.log(message);
      case "RichText":
        console.log("Normal message")
        const fromLink = message.resource.from;
        let senderId = fromLink.substring(fromLink.lastIndexOf('/') + 1);
        senderId = senderId.substring(senderId.indexOf(':') + 1)
        const chat_id = conversationId.substring(conversationId.indexOf(':') + 1)
        let data = {
          time: message.time,
          message: message.resource.content,
          chat_id: chat_id,
          from: senderId
        }
        console.log(data)
        break;
    }

    //skyweb.sendMessage(conversationId, message.resource.content + '. Cats will rule the World');
  });
};
skyweb.on('error', errorListener);
process.on('SIGINT', function () {
  console.log("Caught interrupt signal");
  process.exit();
});