module ::Api::V1
  class MessagesController < ::ActionController::API
    def index
      @messages = Message.all
      render json: @messages
    end
  end
end
