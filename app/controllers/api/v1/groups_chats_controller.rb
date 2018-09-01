module ::Api::V1
  class GroupsChatsController < ::ActionController::API
    def index
      @groups_chats = GroupsChat.all
      render json: @groups_chats
    end
  end
end
