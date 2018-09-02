Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :messages
    end
  end

  root to: 'home#show'
  match '/*page', to: 'home#show', via: :get
end
