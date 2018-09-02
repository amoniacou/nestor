module ::Api::V1
  class MessagesController < ::ActionController::API
    # before_action :choose_groups_chats

    def index
      # @messages = ::Message.where(room_id: @group_chats.ids)
      @messages = ::Message.all
      render json: @messages
    end

    def room_messages
      group_chat_ids = ::GroupsChat.where(room_id: params[:room_id]).ids
      @messages = ::Message.where(room_id: group_chat_ids).where("body like ?", "%#{ params[:q] }%")
      render json: @messages    
    end

    def global_messages
      @messages = ::Message.where("body like ?", "%#{ params[:q] }%")
      render json: @messages
    end

    private

      # def choose_groups_chats
      #   rooms_ids = ::RoomsUser.where(user_id: current_user.id).pluck(:room_id)
      #   @user_group_chats = ::GroupsChat.where('room_id IN (?)', rooms_ids)
      # end
  end
end
