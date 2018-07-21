Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'friends', to: 'friendships#create'
    end
  end
end
