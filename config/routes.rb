Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :messages
      get '/room_messages', to: 'messages#room_messages'
      get '/global_messages', to: 'messages#global_messages'
      get '/rooms/:id/services', to: 'rooms#services'
    end
  end
end
