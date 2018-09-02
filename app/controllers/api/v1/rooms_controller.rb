module ::Api::V1
  class RoomsController < ::ActionController::API

    def services
      room = ::Room.where(id: params[:id]).first
      @services = room.present? ? room.groups_chats.pluck(:service).uniq : []
      render json: @services
    end
  end
end
